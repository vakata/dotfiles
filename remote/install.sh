#!/bin/sh

set -e

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

backup_and_link() {
    src="$1"
    dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        backup="${dest}.bak.$STAMP"

        echo "Backing up $dest -> $backup"
        mv "$dest" "$backup"
    fi

    echo "Linking $dest -> $src"
    ln -s "$src" "$dest"
}

# Top-level dotfiles
for src in "$DIR"/.*; do
    name="$(basename "$src")"

    case "$name" in
        .|..|.config)
            continue
            ;;
    esac

    backup_and_link "$src" "$HOME/$name"
done

# ~/.config entries
if [ -d "$DIR/.config" ]; then
    mkdir -p "$HOME/.config"

    for src in "$DIR/.config"/* "$DIR/.config"/.*; do
        [ -e "$src" ] || [ -L "$src" ] || continue

        name="$(basename "$src")"

        case "$name" in
            .|..)
                continue
                ;;
        esac

        backup_and_link "$src" "$HOME/.config/$name"
    done
fi
