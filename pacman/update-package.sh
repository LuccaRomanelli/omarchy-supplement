#!/bin/bash

# Centralized Pacman package updater
# Usage: ./update-package.sh <package_name>

PACKAGE_NAME=$1

if [ -z "$PACKAGE_NAME" ]; then
    echo "Error: Package name is required"
    echo "Usage: $0 <package_name>"
    exit 1
fi

if ! pacman -Qi "$PACKAGE_NAME" &>/dev/null; then
    echo "$PACKAGE_NAME is not installed, skipping update"
    exit 0
fi

echo "Updating $PACKAGE_NAME..."
sudo pacman -Syu --noconfirm "$PACKAGE_NAME"
exit $?
