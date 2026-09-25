#!/bin/bash

set -e

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

brew bundle dump --force --file="$DIR/brewfile"

