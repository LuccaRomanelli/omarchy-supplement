#!/bin/bash

# Centralized npm global package updater
# Usage: ./update-package.sh <package_name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PACKAGES_LIST="$SCRIPT_DIR/packages.list"

PACKAGE_NAME=$1

if [ -z "$PACKAGE_NAME" ]; then
    echo "Error: Package name is required"
    echo "Usage: $0 <package_name>"
    exit 1
fi

if [ ! -f "$PACKAGES_LIST" ]; then
    echo "Error: Package list file not found: $PACKAGES_LIST"
    exit 1
fi

# Find package entry in packages.list
# Format: <package_name> <check_command>
PACKAGE_ENTRY=$(grep -E "^$PACKAGE_NAME[[:space:]]" "$PACKAGES_LIST" | head -1)

if [ -z "$PACKAGE_ENTRY" ]; then
    echo "Error: Package '$PACKAGE_NAME' not found in $PACKAGES_LIST"
    exit 1
fi

# Parse the entry (package_name, check_command)
CHECK_CMD=$(echo "$PACKAGE_ENTRY" | awk '{print $2}')

if [ -z "$CHECK_CMD" ]; then
    echo "Error: Invalid package entry for '$PACKAGE_NAME'"
    echo "Expected format: <package_name> <check_command>"
    exit 1
fi

if ! command -v "$CHECK_CMD" &>/dev/null; then
    echo "$PACKAGE_NAME is not installed, skipping update"
    exit 0
fi

echo "Updating $PACKAGE_NAME..."
npm update -g "$PACKAGE_NAME"
exit $?
