#!/usr/bin/env bash
set -euo pipefail

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

sudo pacman -Qqen > "$DIR/packages.txt"
sudo pacman -Qqem > "$DIR/packages-aur.txt"
