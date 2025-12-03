#!/bin/bash

# Install Zsh
if ! command -v lsof &>/dev/null; then
    yay -S --noconfirm --needed lsof
fi
