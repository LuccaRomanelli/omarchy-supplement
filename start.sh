#!/bin/bash

# Omarchy Supplement Installation Script - Continuous Installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

echo "=== Omarchy Supplement Installation ==="
echo ""

# Installation steps (order matters)
# First install zsh, then reboot, then everything else
STEPS=(
    "yay/zsh.sh"
    "lib/set-shell.sh"
    "REBOOT"  # Special marker - reboot here and continue after
    "yay/install-packages.sh"
    "pacman/install-packages.sh"
    "npm/install-packages.sh"
    "curl/install-packages.sh"
    "git/clone-repos.sh"
    "dev/dev.sh"
    "yay/tmux.sh"
    "install/omarchy-themes.sh"
    "install/omarchy-webapps.sh"
    "uninstall/omarchy-apps.sh"
    "uninstall/omarchy-webapps.sh"
    "install/hyprland-overrides.sh"
    "dev/yopki.sh"
    "install/usb-modeswitch.sh"
    "yay/iriun-webcam.sh"
    "yay/voxtype.sh"
)

echo "Installing Zsh + Oh-My-Zsh + plugins..."
bash "$SCRIPT_DIR/yay/zsh.sh"
echo ""

if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed. Exiting."
    exit 1
fi

echo "Installing YAY packages..."
zsh "$SCRIPT_DIR/yay/install-packages.sh"
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

echo "Installing development tools..."
zsh "$SCRIPT_DIR/dev/dev.sh"
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

echo "Uninstalling Omarchy apps..."
zsh "$SCRIPT_DIR/uninstall/omarchy-apps.sh"
echo ""

echo "Uninstalling Omarchy webapps..."
zsh "$SCRIPT_DIR/uninstall/omarchy-webapps.sh"
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
