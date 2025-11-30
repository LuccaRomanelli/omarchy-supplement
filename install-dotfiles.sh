#!/bin/bash

ORIGINAL_DIR=$(pwd)
GIT_SYNC_SCRIPT="$ORIGINAL_DIR/git_sync_repo.sh"
REPO_URL="git@github.com:LuccaRomanelli/dotfiles.git"
REPO_NAME="dotfiles"

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

# Check if the clone was successful
if [ $? -eq 0 ]; then
  echo "removing old configs"
  rm -rf ~/.config/ghostty ~/.config/waybar

  cd "$REPO_NAME"
  stow zshrc
  stow ghostty
  stow tmux
  stow waybar
else
  echo "Failed to clone the repository."
  exit 1
fi

