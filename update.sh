#!/bin/bash

# Omarchy Supplement Update Script
# Updates all packages and syncs all repositories

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

echo "=== Omarchy Supplement Update ==="
echo ""

echo "Updating YAY packages..."
zsh "$SCRIPT_DIR/yay/update-packages.sh"
echo ""

echo "Updating Pacman packages..."
zsh "$SCRIPT_DIR/pacman/update-packages.sh"
echo ""

echo "Updating npm packages..."
zsh "$SCRIPT_DIR/npm/update-packages.sh"
echo ""

echo "Updating curl packages..."
zsh "$SCRIPT_DIR/curl/update-packages.sh"
echo ""

echo "Syncing git repositories..."
zsh "$SCRIPT_DIR/git/sync-repos.sh"
echo ""

echo "=== Update Complete! ==="
