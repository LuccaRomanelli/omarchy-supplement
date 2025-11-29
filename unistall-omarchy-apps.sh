#!/bin/bash

pkg_names="alacritty
signal-desktop
xournalapp
spotify"

if [[ -n "$pkg_names" ]]; then
  # Convert newline-separated selections to space-separated for yay
  echo "$pkg_names" | tr '\n' ' ' | xargs sudo pacman -Rns --noconfirm
  omarchy-show-done
fi
