#!/bin/bash

# Batch installer for Pacman packages
# Reads from pacman-packages.list and installs all listed packages

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIST_FILE="$SCRIPT_DIR/pacman-packages.list"

if [ ! -f "$LIST_FILE" ]; then
    echo "Error: Package list file not found: $LIST_FILE"
    exit 1
fi

echo "Installing Pacman packages from $LIST_FILE..."
echo

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Call centralized installer with the line (package name and optional binary name)
    $SCRIPT_DIR/install-pacman-package.sh $line
done < "$LIST_FILE"

echo
echo "Pacman package installation complete!"
