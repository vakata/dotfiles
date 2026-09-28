#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------------------------------------------------
# Configuration
# ----------------------------------------------------------------------

ADMINER_PHP="${ADMINER_PHP:-$SCRIPT_DIR/adminer.php}"
ADMINER_CSS="${ADMINER_CSS:-$SCRIPT_DIR/adminer.css}"

# Browser executable. Override CHROMIUM to force a particular binary.
CHROMIUM="${CHROMIUM:-}"

PHP_HOST="127.0.0.1"
PHP_BASE_PORT=18080

SSH_BASE_PORT=16998


# ----------------------------------------------------------------------
# Usage
#
# Bitwarden:
#
#   db named
#   db named other_database
#
# Looks for:
#
#   db.named
#
# Bitwarden notes contain:
#
#   mysql://host:3306/database
#   mysql://host:3306/database?ssh-host
#
#
# Direct:
#
#   db 'mysql://127.0.0.1:3306/test' '' root ''
#
#   db 'mysql://10.0.0.5:3306/test?jump-host' '' user password
#
# Arguments:
#
#   $1  Bitwarden connection name OR connection string
#   $2  optional database override
#   $3  username when using raw connection string
#   $4  password when using raw connection string
# ----------------------------------------------------------------------

die() {
    echo "db: $*" >&2
    exit 1
}

command -v bw >/dev/null ||
    die "bw not found"

command -v jq >/dev/null ||
    die "jq not found"

if [[ -z "${1:-}" ]]; then
    command -v fzf >/dev/null ||
        die "fzf not found"

    conn="$(
        bw list items --search 'db.' |
            jq -r '.[] | select(.name | startswith("db.")) | .name' |
            sort -u |
            sed 's/^db\.//' |
            fzf \
                --prompt='Database > ' \
                --height=40% \
                --reverse \
                --border
    )"

    [[ -n "$conn" ]] || exit 0
else
    conn="$1"
fi

db_override="${2:-}"

# ----------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------

port_in_use() {
    local port="$1"

    # PHP is already a required dependency. Using it here avoids depending
    # on Linux-only `ss` or macOS-specific `lsof`/`netstat` output formats.
    php -r '
        $s = @stream_socket_server("tcp://127.0.0.1:" . $argv[1], $errno, $errstr);
        if ($s === false) { exit(0); }
        fclose($s);
        exit(1);
    ' "$port"
}

find_free_port() {
    local port="$1"

    while port_in_use "$port"; do
        ((port++))
    done

    printf '%s\n' "$port"
}

find_chromium() {
    # Explicit override wins. It may be either a command name or an
    # absolute path (useful for macOS application bundles).
    if [[ -n "$CHROMIUM" ]]; then
        if [[ -x "$CHROMIUM" ]]; then
            printf '%s\n' "$CHROMIUM"
            return
        fi
        if command -v "$CHROMIUM" >/dev/null 2>&1; then
            command -v "$CHROMIUM"
            return
        fi
        die "Chromium not found: $CHROMIUM"
    fi

    case "$(uname -s)" in
        Darwin)
            local candidate
            for candidate in \
                "/Applications/Chromium.app/Contents/MacOS/Chromium" \
                "$HOME/Applications/Chromium.app/Contents/MacOS/Chromium" \
                "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
                "$HOME/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"; do
                if [[ -x "$candidate" ]]; then
                    printf '%s\n' "$candidate"
                    return
                fi
            done
            ;;
        *)
            local candidate
            for candidate in chromium chromium-browser google-chrome google-chrome-stable; do
                if command -v "$candidate" >/dev/null 2>&1; then
                    command -v "$candidate"
                    return
                fi
            done
            ;;
    esac

    die "Chromium/Chrome not found (set CHROMIUM to its executable path)"
}

b64() {
    printf '%s' "$1" | base64 | tr -d '\n'
}


# ----------------------------------------------------------------------
# Preconditions
# ----------------------------------------------------------------------

command -v ssh >/dev/null ||
    die "ssh not found"

command -v php >/dev/null ||
    die "php not found"

CHROMIUM="$(find_chromium)"

[[ -f "$ADMINER_PHP" ]] ||
    die "Adminer not found: $ADMINER_PHP"

# ----------------------------------------------------------------------
# Bitwarden lookup
# ----------------------------------------------------------------------

name="db.$conn"

if ! bw_items="$(bw list items --search "$name")"; then
    die "Unable to query Bitwarden"
fi

matches="$(
    jq -c \
        --arg name "$name" \
        '[.[] | select(.name == $name)]' \
        <<< "$bw_items"
)"

match_count="$(jq -r 'length' <<< "$matches")"

case "$match_count" in
    0)
        #
        # No Bitwarden match.
        #
        # Treat $1 as the actual connection string.
        #

        comm="$conn"
        user="${3:-}"
        pass="${4:-}"

        ;;

    1)
        #
        # Exact Bitwarden match.
        #

        item="$(jq -c '.[0]' <<< "$matches")"

        comm="$(jq -r '.notes // ""' <<< "$item")"
        user="$(jq -r '.login.username // ""' <<< "$item")"
        pass="$(jq -r '.login.password // ""' <<< "$item")"

        ;;

    *)
        die "Multiple Bitwarden items found with exact name: $name"
        ;;
esac

[[ -n "$comm" ]] ||
    die "No connection string provided"


# ----------------------------------------------------------------------
# Parse connection string
#
# Examples:
#
#   mysql://db.example.com:3306/database
#   mysql://127.0.0.1:3306/database?server.example.com
#   pgsql://10.0.0.2:5432/mydb
# ----------------------------------------------------------------------

if [[ "$comm" != *"://"* ]]; then
    die "Invalid connection string: $comm"
fi

type="${comm%%://*}"
rest="${comm#*://}"


# ----------------------------------------------------------------------
# Optional SSH proxy
#
# Anything after ? is interpreted as the SSH host.
# ----------------------------------------------------------------------

if [[ "$rest" == *"?"* ]]; then
    prox="${rest#*\?}"
    rest="${rest%%\?*}"
else
    prox=""
fi


# ----------------------------------------------------------------------
# Database name
# ----------------------------------------------------------------------

if [[ "$rest" == */* ]]; then
    hopo="${rest%%/*}"
    dbnm="${rest#*/}"
else
    hopo="$rest"
    dbnm=""
fi

if [[ -n "$db_override" ]]; then
    dbnm="$db_override"
fi


# ----------------------------------------------------------------------
# Host and port
# ----------------------------------------------------------------------

if [[ "$hopo" != *":"* ]]; then
    die "No port specified in connection string: $comm"
fi

host="${hopo%%:*}"
port="${hopo##*:}"

[[ -n "$host" ]] ||
    die "Empty database host"

[[ "$port" =~ ^[0-9]+$ ]] ||
    die "Invalid database port: $port"

if [[ "$host" == "localhost" ]]; then
    host="127.0.0.1"
fi


# ----------------------------------------------------------------------
# Legacy convenience:
#
# db.foo with:
#
#   mysql://127.0.0.1:3306/db
#
# means SSH to "foo".
#
# Explicit ?ssh-host always wins.
# ----------------------------------------------------------------------

if [[ "$host" == "127.0.0.1" \
      && -z "$prox" \
      && "$match_count" -eq 1 \
      && "${conn:0:1}" != "@" ]]; then

    prox="$conn"
fi

# ----------------------------------------------------------------------
# Map connection scheme to Adminer driver
# ----------------------------------------------------------------------

case "$type" in
    mysql|mariadb)
        adminer_driver="server"
        ;;

    pgsql|postgres|postgresql)
        adminer_driver="pgsql"
        ;;

    mssql|sqlsrv)
        adminer_driver="mssql"
        ;;

    oracle)
        adminer_driver="oracle"
        ;;

    *)
        die "Unsupported Adminer database type: $type"
        ;;
esac


# ----------------------------------------------------------------------
# Cleanup
# ----------------------------------------------------------------------

ssh_pid=""
php_pid=""
browser_pid=""
tmpdir=""

cleanup() {
    trap - EXIT INT TERM

    if [[ -n "$browser_pid" ]]; then
        kill "$browser_pid" 2>/dev/null || true
    fi

    if [[ -n "$php_pid" ]]; then
        kill "$php_pid" 2>/dev/null || true
        wait "$php_pid" 2>/dev/null || true
    fi

    if [[ -n "$ssh_pid" ]]; then
        kill "$ssh_pid" 2>/dev/null || true
        wait "$ssh_pid" 2>/dev/null || true
    fi

    if [[ -n "$tmpdir" && -d "$tmpdir" ]]; then
        rm -rf -- "$tmpdir"
    fi
}

trap cleanup EXIT INT TERM


# ----------------------------------------------------------------------
# SSH tunnel
# ----------------------------------------------------------------------

adminer_host="$host"
adminer_port="$port"

if [[ -n "$prox" ]]; then

    tunnel_port="$(find_free_port "$SSH_BASE_PORT")"

    echo "Opening SSH tunnel via $prox..."

    ssh \
        -N \
        -o ExitOnForwardFailure=yes \
        -o ServerAliveInterval=30 \
        -o ServerAliveCountMax=3 \
        -L "127.0.0.1:${tunnel_port}:${host}:${port}" \
        "$prox" &

    ssh_pid=$!

    #
    # Give SSH a moment to report an immediate forwarding failure.
    #

    sleep 0.25

    if ! kill -0 "$ssh_pid" 2>/dev/null; then
        wait "$ssh_pid" 2>/dev/null || true
        ssh_pid=""
        die "SSH tunnel failed"
    fi

    adminer_host="127.0.0.1"
    adminer_port="$tunnel_port"
fi

if [[ "${DATABASE_MODE:-gui}" == "cli" ]]; then
    case "$type" in
        mysql|mariadb)
            exec mysql \
                --host="$adminer_host" \
                --port="$adminer_port" \
                --user="$user" \
                --password="$pass" \
                "$dbnm"
            ;;

        pgsql|postgres|postgresql)
            PGPASSWORD="$pass" \
                psql \
                    --host="$adminer_host" \
                    --port="$adminer_port" \
                    --username="$user" \
                    --dbname="$dbnm"
            ;;

        oracle)
            sqlplus \
                "$user/$pass@//$adminer_host:$adminer_port/$dbnm"
            ;;

        mssql|sqlsrv)
            sqlcmd \
                -S "$adminer_host,$adminer_port" \
                -U "$user" \
                -P "$pass" \
                -d "$dbnm"
            ;;

        *)
            die "No CLI client configured for database type: $type"
            ;;
    esac

    exit
fi

# ----------------------------------------------------------------------
# Temporary Adminer environment
# ----------------------------------------------------------------------

tmpdir="$(
    mktemp -d \
        "${XDG_RUNTIME_DIR:-/tmp}/db-adminer.XXXXXX"
)"

chmod 700 "$tmpdir"

cp "$ADMINER_PHP" "$tmpdir/adminer.php"
if [[ -f "$ADMINER_CSS" ]]; then
    cp "$ADMINER_CSS" "$tmpdir/adminer.css"
    cp "$ADMINER_CSS" "$tmpdir/adminer-dark.css"
fi
chmod 600 "$tmpdir/adminer.php"

driver64="$(b64 "$adminer_driver")"
server64="$(b64 "${adminer_host}:${adminer_port}")"
user64="$(b64 "$user")"
pass64="$(b64 "$pass")"
db64="$(b64 "$dbnm")"

cat > "$tmpdir/adminer-loader.php" <<EOF
<?php

\$driver = base64_decode('${driver64}');
\$server = base64_decode('${server64}');
\$user   = base64_decode('${user64}');
\$pass   = base64_decode('${pass64}');
\$db     = base64_decode('${db64}');

/*
 * Adminer needs the connection details in the URL.
 *
 * On the first request, redirect ourselves to Adminer's normal
 * authenticated URL shape.
 */
if (!isset(\$_GET['username']) && !isset(\$_GET['file'])) {
    \$params = [];

    if (\$driver === 'server') {
        \$params['server'] = \$server;
    } else {
        \$params[\$driver] = \$server;
    }

    \$params['username'] = \$user;

    if (\$db !== '') {
        \$params['db'] = \$db;
    }

    header(
        'Location: /adminer-loader.php?' .
        http_build_query(\$params)
    );

    exit;
}

function adminer_object()
{
    global \$driver, \$server, \$user, \$pass, \$db;

    /*
     * At this point Adminer has loaded its support functions and has
     * started its session.
     *
     * Seed the exact credential tuple which Adminer is about to use.
     */
    Adminer\\set_password(
        \$driver,
        \$server,
        \$user,
        \$pass
    );

    class AdminerAutoLogin extends Adminer\\Adminer
    {
        public function login(\$login, \$password)
        {
            /*
             * Allow passwordless DB users too.
             */
            return true;
        }
    }

    return new AdminerAutoLogin();
}

require __DIR__ . '/adminer.php';
EOF

chmod 600 "$tmpdir/adminer-loader.php"

php_port="$(find_free_port "$PHP_BASE_PORT")"

php \
    -d display_errors=1 \
    -d display_startup_errors=1 \
    -d error_reporting=E_ALL \
    -S "${PHP_HOST}:${php_port}" \
    -t "$tmpdir" &

php_pid=$!

sleep 0.15

if ! kill -0 "$php_pid" 2>/dev/null; then
    wait "$php_pid" 2>/dev/null || true
    php_pid=""
    die "PHP server failed"
fi

chromium_profile="$tmpdir/chromium"
mkdir -m 700 "$chromium_profile"

url="http://${PHP_HOST}:${php_port}/adminer-loader.php"

"$CHROMIUM" \
    --user-data-dir="$chromium_profile" \
    --app="$url" \
    --no-first-run \
    --no-default-browser-check \
    --disable-sync \
    >/dev/null 2>&1 &

browser_pid=$!

wait "$browser_pid"
browser_pid=""
