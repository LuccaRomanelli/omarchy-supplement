#!/bin/bash

# Install Zsh
if ! command -v yazi &>/dev/null; then
    yay -S --noconfirm --needed yazi
fi
