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

# Download large-v3-turbo model for GPU acceleration (multilingual PT/EN)
MODEL_DIR="$HOME/.local/share/voxtype/models"
MODEL_FILE="$MODEL_DIR/ggml-large-v3-turbo.bin"
mkdir -p "$MODEL_DIR"
if [ ! -f "$MODEL_FILE" ]; then
  echo "Downloading large-v3-turbo Whisper model (1.6GB)..."
  curl -L --progress-bar -o "$MODEL_FILE" \
    "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin"
fi

# Enable GPU acceleration if Vulkan backend is available and not already active
GPU_STATUS=$(voxtype setup gpu 2>&1)
if echo "$GPU_STATUS" | grep -q "GPU (Vulkan) - active"; then
  echo "GPU acceleration already enabled."
elif echo "$GPU_STATUS" | grep -q "GPU (Vulkan) - installed"; then
  echo "Enabling GPU acceleration..."
  sudo voxtype setup gpu --enable
fi

# Setup compositor compatibility
echo "Setting up compositor compatibility..."
voxtype setup compositor hyprland

# Fix: Ensure bindr for SUPER+D release exists in voxtype_recording submap
# The voxtype setup may not include this, causing the release to not be detected
VOXTYPE_SUBMAP="$HOME/.config/hypr/conf.d/voxtype-submap.conf"
if [ -f "$VOXTYPE_SUBMAP" ] && ! grep -q "bindr = SUPER, D" "$VOXTYPE_SUBMAP"; then
  echo "Fixing voxtype submap: adding SUPER+D release binding..."
  sed -i '/^submap = voxtype_recording$/,/^submap = reset$/{
    /^submap = voxtype_recording$/a\
bindr = SUPER, D, exec, voxtype record stop
  }' "$VOXTYPE_SUBMAP"
fi

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
