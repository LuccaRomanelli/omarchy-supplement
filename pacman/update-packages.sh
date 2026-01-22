#!/bin/bash

# Batch updater for Pacman packages
# Reads from packages.list and updates all listed packages

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
LIST_FILE="$SCRIPT_DIR/packages.list"

if [ ! -f "$LIST_FILE" ]; then
    echo "Error: Package list file not found: $LIST_FILE"
    exit 1
fi

echo "Updating Pacman packages from $LIST_FILE..."
echo

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    "$SCRIPT_DIR/update-package.sh" "$line"
done < "$LIST_FILE"

echo
echo "Pacman package update complete!"
