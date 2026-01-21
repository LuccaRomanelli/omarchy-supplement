#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

for script in "$SCRIPT_DIR"/*.sh; do
    [ "$(basename "$script")" = "all.sh" ] && continue
    echo "Running $(basename "$script")..."
    zsh "$script"
done
