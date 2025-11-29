#!/bin/bash

# Install Zsh
if ! command -v rg &>/dev/null; then
    sudo pacman -S ripgrep
fi
