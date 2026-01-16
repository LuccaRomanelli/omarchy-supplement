#!/bin/bash

# Omarchy Supplement Installation Script - Continuous Installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
    "install/obsidian-vault.sh"
    "install/dotfiles.sh"
    "dev/dev.sh"
    "yay/tmux.sh"
    "install/shell-scripts.sh"
    "install/ai-tools.sh"
    "install/nhost.sh"
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

# Step 1: Install Zsh + Oh-My-Zsh + plugins (runs in bash)
echo "[1/19] Installing Zsh + Oh-My-Zsh + plugins..."
bash "$SCRIPT_DIR/yay/zsh.sh"
echo ""

# Check if zsh was installed successfully
if ! command -v zsh &>/dev/null; then
    echo "Error: Zsh installation failed. Exiting."
    exit 1
fi

# Steps 2-17: Run remaining installations in zsh
echo "[2/19] Installing YAY packages..."
zsh "$SCRIPT_DIR/yay/install-packages.sh"
echo ""

echo "[3/19] Installing Pacman packages..."
zsh "$SCRIPT_DIR/pacman/install-packages.sh"
echo ""

echo "[4/19] Setting up Obsidian vault..."
zsh "$SCRIPT_DIR/install/obsidian-vault.sh"
echo ""

echo "[5/19] Installing dotfiles..."
zsh "$SCRIPT_DIR/install/dotfiles.sh"
echo ""

echo "[6/19] Installing development tools..."
zsh "$SCRIPT_DIR/dev/dev.sh"
echo ""

echo "[7/19] Installing Tmux + TPM..."
zsh "$SCRIPT_DIR/yay/tmux.sh"
echo ""

echo "[8/19] Installing shell scripts..."
zsh "$SCRIPT_DIR/install/shell-scripts.sh"
echo ""

echo "[9/19] Installing AI tools..."
zsh "$SCRIPT_DIR/install/ai-tools.sh"
echo ""

echo "[10/19] Installing Nhost CLI..."
zsh "$SCRIPT_DIR/install/nhost.sh"
echo ""

echo "[11/19] Installing Omarchy themes..."
zsh "$SCRIPT_DIR/install/omarchy-themes.sh"
echo ""

echo "[12/19] Installing Omarchy webapps..."
zsh "$SCRIPT_DIR/install/omarchy-webapps.sh"
echo ""

echo "[13/19] Uninstalling Omarchy apps..."
zsh "$SCRIPT_DIR/uninstall/omarchy-apps.sh"
echo ""

echo "[14/19] Uninstalling Omarchy webapps..."
zsh "$SCRIPT_DIR/uninstall/omarchy-webapps.sh"
echo ""

echo "[15/19] Installing Hyprland overrides..."
zsh "$SCRIPT_DIR/install/hyprland-overrides.sh"
echo ""

echo "[16/19] Setting up Yopki projects..."
zsh "$SCRIPT_DIR/dev/yopki.sh"
echo ""

echo "[17/19] Configuring USB mode switch..."
zsh "$SCRIPT_DIR/install/usb-modeswitch.sh"
echo ""

# Step 18: Install Voxtype (speech-to-text)
echo "[18/19] Installing Voxtype..."
zsh "$SCRIPT_DIR/yay/voxtype.sh"
echo ""

# Step 19: Set zsh as default shell
echo "[19/19] Setting Zsh as default shell..."
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
