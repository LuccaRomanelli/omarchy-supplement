#!/bin/bash

# Install Zsh
if ! command -v zen-browser &>/dev/null; then
    yay -S zen-browser-bin
fi
