#!/bin/bash

# Set Zen Browser as default browser

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

if command -v zen &>/dev/null; then
    current_browser=$(xdg-settings get default-web-browser 2>/dev/null)
    if [ "$current_browser" != "zen.desktop" ]; then
        echo "Setting Zen Browser as default browser..."
        xdg-settings set default-web-browser zen.desktop
        echo "Zen Browser is now the default browser."
    else
        echo "Zen Browser is already the default browser."
    fi
else
    echo "Zen Browser not installed, skipping default browser configuration."
fi
