#!/bin/bash

ORIGINAL_DIR=$(pwd)
GIT_SYNC_SCRIPT="$ORIGINAL_DIR/git_sync_repo.sh"
REPO_URL="https://github.com/LuccaRomanelli/dotfiles.git"
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

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  echo "removing old configs"
  rm -rf ~/.config/nvim ~/.config/starship.toml ~/.local/share/nvim/ ~/.cache/nvim/ ~/.config/ghostty/config

  cd "$REPO_NAME"
  stow zshrc
  stow ghostty
  stow tmux
  stow nvim
  stow starship
  stow waybar
else
  echo "Failed to clone the repository."
  exit 1
fi

