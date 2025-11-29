#!/bin/bash

if ! command -v stow &>/dev/null; then
    yay -S --noconfirm --needed stow
fi
