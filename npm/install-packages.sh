#!/bin/bash

# Batch installer for global npm packages
# Reads from packages.list and installs all listed packages

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
LIST_FILE="$SCRIPT_DIR/packages.list"

if [ ! -f "$LIST_FILE" ]; then
    echo "Error: Package list file not found: $LIST_FILE"
    exit 1
fi

echo "Installing npm packages from $LIST_FILE..."
echo

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Extract package name (first field)
    PACKAGE_NAME=$(echo "$line" | awk '{print $1}')

    "$SCRIPT_DIR/install-package.sh" "$PACKAGE_NAME"
done < "$LIST_FILE"

echo
echo "npm package installation complete!"
