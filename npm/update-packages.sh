#!/bin/bash

# Batch updater for npm global packages
# Reads from packages.list and updates all listed packages

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
LIST_FILE="$SCRIPT_DIR/packages.list"

if [ ! -f "$LIST_FILE" ]; then
    echo "Error: Package list file not found: $LIST_FILE"
    exit 1
fi

echo "Updating npm global packages from $LIST_FILE..."
echo

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Extract package name (first field)
    package_name=$(echo "$line" | awk '{print $1}')

    "$SCRIPT_DIR/update-package.sh" "$package_name"
done < "$LIST_FILE"

echo
echo "npm global package update complete!"
