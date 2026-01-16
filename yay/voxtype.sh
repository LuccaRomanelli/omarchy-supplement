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

# Create voxtype config directory
VOXTYPE_CONFIG_DIR="$HOME/.config/voxtype"
mkdir -p "$VOXTYPE_CONFIG_DIR"

# Configure voxtype for Hyprland with multilingual support
VOXTYPE_CONFIG="$VOXTYPE_CONFIG_DIR/config.toml"
echo "Creating voxtype configuration..."
cat > "$VOXTYPE_CONFIG" << 'EOF'
# Voxtype configuration for Hyprland + Multilingual (PT/EN)

state_file = "auto"

[hotkey]
# Disabled - using Hyprland keybindings (SUPER+D)
enabled = false

[whisper]
# Multilingual model with good speed/quality balance
model = "small"
# Auto-detect language (works for English and Portuguese)
language = "auto"

[output]
mode = "type"
fallback_to_clipboard = true

[output.notification]
# Show notification when recording starts
on_recording_start = true
# Show notification when transcription begins
on_recording_stop = true
# Show notification with transcribed text
on_transcription = true
EOF

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
