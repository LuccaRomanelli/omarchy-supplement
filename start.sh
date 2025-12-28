#!/bin/bash

# Omarchy Supplement Installation Script with Auto-Resume
# Supports automatic continuation after reboot

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="$HOME/.local/state/omarchy-supplement"
STATE_FILE="$STATE_DIR/install-progress"
AUTOSTART_DIR="$HOME/.config/autostart"
AUTOSTART_FILE="$AUTOSTART_DIR/omarchy-supplement-resume.desktop"

# Installation steps (order matters)
# First install zsh, then reboot, then everything else
STEPS=(
    "install-zsh.sh"
    "set-shell.sh"
    "REBOOT"  # Special marker - reboot here and continue after
    "install-yay-packages.sh"
    "install-pacman-packages.sh"
    "install-obisidian-vault.sh"
    "install-dotfiles.sh"
    "install-dev.sh"
    "install-tmux.sh"
    "install-shell-scripts.sh"
    "install-ai-tools.sh"
    "install-omarchy-themes.sh"
    "install-omarchy-webapps.sh"
    "uninstall-omarchy-apps.sh"
    "uninstall-omarchy-webapps.sh"
    "install-hyprland-overrides.sh"
    "yopki.sh"
    "usb-modeswitch.sh"
)

# Create state directory if needed
mkdir -p "$STATE_DIR"

# Get current step (default to 0)
get_current_step() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo 0
    fi
}

# Save current step
save_step() {
    echo "$1" > "$STATE_FILE"
}

# Clean up state and autostart
cleanup() {
    rm -f "$STATE_FILE"
    rm -f "$AUTOSTART_FILE"
    echo "Installation complete! State cleaned up."
}

# Create autostart entry for resume after reboot
create_autostart() {
    mkdir -p "$AUTOSTART_DIR"
    cat > "$AUTOSTART_FILE" << EOF
[Desktop Entry]
Type=Application
Name=Omarchy Supplement Resume
Exec=ghostty -e bash -c 'cd $SCRIPT_DIR && ./start.sh; exec zsh'
X-GNOME-Autostart-enabled=true
Comment=Resume omarchy-supplement installation after reboot
EOF
    echo "Autostart entry created for resume after reboot."
}

# Main installation loop
main() {
    local current_step=$(get_current_step)
    local total_steps=${#STEPS[@]}

    echo "=== Omarchy Supplement Installation ==="
    echo "Starting from step $((current_step + 1)) of $total_steps"
    echo ""

    for ((i=current_step; i<total_steps; i++)); do
        local step="${STEPS[$i]}"

        # Check for reboot marker
        if [[ "$step" == "REBOOT" ]]; then
            # Check if we already have zsh as shell (reboot already happened)
            ZSH_PATH=$(which zsh 2>/dev/null)
            if [[ "$SHELL" == "$ZSH_PATH" ]]; then
                echo "Zsh is already default shell, skipping reboot..."
                save_step $((i + 1))
                continue
            fi

            # Need to reboot
            echo ""
            echo "=== REBOOT REQUIRED ==="
            echo "Shell changed to zsh. Need to reboot to apply changes."
            echo "Installation will continue automatically after reboot."
            echo ""

            # Save next step
            save_step $((i + 1))

            # Create autostart
            create_autostart

            # Ask for confirmation
            read -p "Press Enter to reboot now (or Ctrl+C to cancel)..."

            # Reboot
            systemctl reboot
            exit 0
        fi

        # Run the step
        echo "[$((i + 1))/$total_steps] Running $step..."

        if [[ -x "$SCRIPT_DIR/$step" ]]; then
            "$SCRIPT_DIR/$step"
        else
            bash "$SCRIPT_DIR/$step"
        fi

        # Save progress after each step
        save_step $((i + 1))

        echo ""
    done

    # All done - cleanup
    cleanup
}

# Run main
main
