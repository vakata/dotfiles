#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

export DATABASE_MODE=cli
exec "$SCRIPT_DIR/database.sh" "$@"
