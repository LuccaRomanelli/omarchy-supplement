#!/bin/bash

# Install Zen
if ! command -v zen-browser &>/dev/null; then
    yay -S --noconfirm --needed zen-browser-bin
fi
