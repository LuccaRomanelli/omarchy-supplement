#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Install voxtype-bin from AUR (not omarchy repo - version is outdated)
if ! pacman -Qi voxtype-bin &>/dev/null; then
  echo "Installing voxtype-bin from AUR..."
  yay -S --noconfirm --needed aur/voxtype-bin
fi

# Verify installation
if ! command -v voxtype &>/dev/null; then
  echo "Voxtype installation failed."
  exit 1
fi

# Add user to input group (required for hotkey detection)
if ! groups "$USER" | grep -q '\binput\b'; then
  echo "Adding user to input group (required for hotkey detection)..."
  sudo usermod -aG input "$USER"
  echo "NOTE: You need to log out and back in for the group change to take effect."
fi

# Config is managed by dotfiles (stow) - check if it exists
VOXTYPE_CONFIG="$HOME/.config/voxtype/config.toml"
if [ ! -f "$VOXTYPE_CONFIG" ]; then
  echo "Warning: Voxtype config not found. Run install/dotfiles.sh first."
fi

# Download multilingual model (small) for Portuguese support
MODEL_FILE="$HOME/.local/share/voxtype/models/ggml-small.bin"
if [ ! -f "$MODEL_FILE" ]; then
  echo "Downloading multilingual Whisper model (small) for Portuguese..."
  voxtype setup --download
fi

# Setup compositor compatibility
echo "Setting up compositor compatibility..."
voxtype setup compositor hyprland

# Ensure hyprland sources conf.d directory (required for voxtype submap)
HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"
if [ -f "$HYPRLAND_CONFIG" ] && ! grep -q "conf.d" "$HYPRLAND_CONFIG"; then
  echo "Adding conf.d source to hyprland.conf..."
  echo 'source = ~/.config/hypr/conf.d/*.conf' >> "$HYPRLAND_CONFIG"
fi

# Reload hyprland if running
if pgrep -x Hyprland &>/dev/null; then
  echo "Reloading Hyprland configuration..."
  hyprctl reload &>/dev/null || true
fi

# Setup systemd service for autostart
echo "Setting up systemd service..."
voxtype setup systemd

echo "Voxtype installed and configured successfully!"
echo ""
echo "IMPORTANT: If this is a fresh install, you need to:"
echo "  1. Log out and back in (for input group to take effect)"
echo "  2. Voxtype will start automatically on next login"
echo ""
echo "Usage: Hold SUPER+D to record, release to transcribe"
