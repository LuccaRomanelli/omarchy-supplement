#!/bin/bash

ORIGINAL_DIR=$(pwd)
GIT_SYNC_SCRIPT="$ORIGINAL_DIR/git_sync_repo.sh"
REPO_URL="https://github.com/LuccaRomanelli/shell.git"
REPO_NAME="shell"

is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Sync the repository
"$GIT_SYNC_SCRIPT" "$REPO_URL" "$REPO_NAME"
