#!/bin/bash

# Omarchy Supplement Installation Script - Continuous Installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

echo "=== Omarchy Supplement Installation ==="
echo ""

echo "Installing Zsh + Oh-My-Zsh + plugins..."
bash "$SCRIPT_DIR/yay/zsh.sh"
echo ""

if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed. Exiting."
    exit 1
fi

echo "Installing development tools..."
zsh "$SCRIPT_DIR/dev/dev.sh"
echo ""

echo "Installing YAY packages..."
zsh "$SCRIPT_DIR/yay/install-packages.sh"
echo ""

echo "Setting default browser..."
zsh "$SCRIPT_DIR/install/default-browser.sh"
echo ""

echo "Installing Pacman packages..."
zsh "$SCRIPT_DIR/pacman/install-packages.sh"
echo ""

echo "Installing npm packages..."
zsh "$SCRIPT_DIR/npm/install-packages.sh"
echo ""

echo "Installing curl packages..."
zsh "$SCRIPT_DIR/curl/install-packages.sh"
echo ""

echo "Cloning git repositories..."
zsh "$SCRIPT_DIR/git/clone-repos.sh"
echo ""



echo "Installing Tmux + TPM..."
zsh "$SCRIPT_DIR/yay/tmux.sh"
echo ""

echo "Installing Omarchy themes..."
zsh "$SCRIPT_DIR/install/omarchy-themes.sh"
echo ""

echo "Installing Omarchy webapps..."
zsh "$SCRIPT_DIR/install/omarchy-webapps.sh"
echo ""

echo "Running uninstall scripts..."
zsh "$SCRIPT_DIR/uninstall/all.sh"
echo ""

echo "Installing Hyprland overrides..."
zsh "$SCRIPT_DIR/install/hyprland-overrides.sh"
echo ""

echo "Setting up Yopki projects..."
zsh "$SCRIPT_DIR/dev/yopki.sh"
echo ""

echo "Configuring USB mode switch..."
zsh "$SCRIPT_DIR/install/usb-modeswitch.sh"
echo ""

echo "Installing Iriun Webcam..."
zsh "$SCRIPT_DIR/yay/iriun-webcam.sh"
echo ""

echo "Installing Voxtype..."
zsh "$SCRIPT_DIR/yay/voxtype.sh"
echo ""

echo "Installing Auto-Claude..."
zsh "$SCRIPT_DIR/yay/auto-claude.sh"
echo ""

echo "Setting Zsh as default shell..."
bash "$SCRIPT_DIR/lib/set-shell.sh"
echo ""

# All done
echo "=== Installation Complete! ==="
echo ""
echo "To apply the shell change, please:"
echo "  - Logout and login again, OR"
echo "  - Reboot your system"
echo ""
echo "After that, your terminal will use Zsh with all configurations."
echo ""
