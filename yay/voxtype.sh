#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Install voxtype-bin via yay
"$SCRIPT_DIR/install-package.sh" voxtype-bin voxtype

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

# Download Whisper model (if not already downloaded)
WHISPER_DIR="$HOME/.local/share/voxtype"
if [ ! -d "$WHISPER_DIR" ] || [ -z "$(ls -A "$WHISPER_DIR" 2>/dev/null)" ]; then
  echo "Downloading Whisper model for offline transcription..."
  voxtype setup --download
fi

# Create voxtype config directory
VOXTYPE_CONFIG_DIR="$HOME/.config/voxtype"
mkdir -p "$VOXTYPE_CONFIG_DIR"

# Configure voxtype for hyprland keybindings
VOXTYPE_CONFIG="$VOXTYPE_CONFIG_DIR/config.toml"
if [ ! -f "$VOXTYPE_CONFIG" ]; then
  echo "Creating voxtype configuration..."
  cat > "$VOXTYPE_CONFIG" << 'EOF'
# Voxtype configuration for Hyprland

# Disable built-in hotkey (using compositor keybindings instead)
[hotkey]
enabled = false

# Enable state file (required for toggle mode with compositor keybindings)
state_file = "auto"
EOF
fi

# Setup compositor compatibility
echo "Setting up compositor compatibility..."
voxtype setup compositor hyprland

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
