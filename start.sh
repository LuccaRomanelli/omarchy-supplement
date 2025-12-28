#!/bin/bash

# Install all packages in order

# Batch install packages from lists
./install-yay-packages.sh
./install-pacman-packages.sh

# Individual installs with post-install setup or special requirements
./install-obisidian-vault.sh
./install-dotfiles.sh
./install-zsh.sh
./install-dev.sh
./install-tmux.sh
./install-shell-scripts.sh
./install-ai-tools.sh
./install-omarchy-themes.sh
./install-omarchy-webapps.sh
./set-shell.sh
./uninstall-omarchy-apps.sh
./uninstall-omarchy-webapps.sh
./install-hyprland-overrides.sh
./yopki.sh
