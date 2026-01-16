#!/bin/bash

pkg_names=(
    "alacritty"
    "signal-desktop"
    "xournalpp"
    "spotify"
)

for pkg in "${pkg_names[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        sudo pacman -Rns "$pkg" --noconfirm
    else
        echo "Package $pkg not installed, skipping..."
    fi
done
