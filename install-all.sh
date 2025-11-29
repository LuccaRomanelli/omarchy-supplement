#!/bin/bash

# Install all packages in order
./install-zsh.sh
./install-yazi.sh
./install-asdf.sh
./install-nodejs.sh
./install-php.sh
./install-ghostty.sh
./install-tmux.sh
./install-stow.sh
./install-dotfiles.sh
./install-shell-scripts.sh
./install-ripgrep.sh
./install-obsidian-vault.sh
./install-hyprland-overrides.sh

./set-shell.sh
