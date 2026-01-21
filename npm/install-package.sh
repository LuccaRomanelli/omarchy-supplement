#!/bin/bash

# Centralized npm global package installer
# Usage: ./install-package.sh <package_name>

PACKAGE_NAME=$1

if [ -z "$PACKAGE_NAME" ]; then
    echo "Error: Package name is required"
    echo "Usage: $0 <package_name>"
    exit 1
fi

if npm list -g "$PACKAGE_NAME" &>/dev/null; then
    echo "$PACKAGE_NAME is already installed"
    exit 0
else
    echo "Installing $PACKAGE_NAME..."
    npm install -g "$PACKAGE_NAME"
    exit $?
fi
