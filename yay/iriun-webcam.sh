#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# Install iriunwebcam-bin (AUR)
"$SCRIPT_DIR/install-package.sh" iriunwebcam-bin iriunwebcam

# Install v4l2loopback-dkms (AUR) - virtual webcam kernel module
"$SCRIPT_DIR/install-package.sh" v4l2loopback-dkms

# Install qt5-wayland (pacman) - Wayland support for Qt5 apps
"$SCRIPT_DIR/../pacman/install-package.sh" qt5-wayland

# Install alsa-utils (pacman) - ALSA audio support for microphone
"$SCRIPT_DIR/../pacman/install-package.sh" alsa-utils

# Configure v4l2loopback to auto-load at boot (only if not already configured)
if [ ! -f /etc/modules-load.d/v4l2loopback.conf ]; then
    echo "Configuring v4l2loopback to load at boot..."
    echo "v4l2loopback" | sudo tee /etc/modules-load.d/v4l2loopback.conf
fi

# Configure v4l2loopback options (only if not already configured)
if [ ! -f /etc/modprobe.d/v4l2loopback.conf ]; then
    echo "Configuring v4l2loopback options..."
    echo "options v4l2loopback exclusive_caps=1" | sudo tee /etc/modprobe.d/v4l2loopback.conf
fi

# Load the module now (only if not already loaded)
if ! lsmod | grep -q v4l2loopback; then
    echo "Loading v4l2loopback module..."
    sudo modprobe v4l2loopback exclusive_caps=1
fi

echo "Iriun Webcam installed successfully!"
