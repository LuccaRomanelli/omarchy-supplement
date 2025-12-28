#!/bin/bash

# Centralized YAY package installer
# Usage: ./install-yay-package.sh <package_name> [binary_name]
# If binary_name is not provided, it defaults to package_name

PACKAGE_NAME=$1
BINARY_NAME=${2:-$1}  # Default to package name if not provided

if [ -z "$PACKAGE_NAME" ]; then
    echo "Error: Package name is required"
    echo "Usage: $0 <package_name> [binary_name]"
    exit 1
fi

if ! command -v "$BINARY_NAME" &>/dev/null; then
    echo "Installing $PACKAGE_NAME..."
    yay -S --noconfirm --needed "$PACKAGE_NAME"
    exit $?
else
    echo "$BINARY_NAME is already installed"
    exit 0
fi
