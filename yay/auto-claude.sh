#!/bin/bash
# Auto-Claude installer script
# Downloads and sets up Auto-Claude AppImage

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

VERSION="2.7.5"
APPIMAGE_NAME="Auto-Claude-${VERSION}-linux-x86_64.AppImage"
DOWNLOAD_URL="https://github.com/AndyMik90/Auto-Claude/releases/download/v${VERSION}/${APPIMAGE_NAME}"
INSTALL_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons"
VERSION_FILE="$INSTALL_DIR/.auto-claude-version"

# Check if already installed with correct version
if [ -f "$INSTALL_DIR/auto-claude" ] && [ -f "$VERSION_FILE" ]; then
    INSTALLED_VERSION=$(cat "$VERSION_FILE")
    if [ "$INSTALLED_VERSION" = "$VERSION" ]; then
        echo "Auto-Claude v${VERSION} is already installed."
        exit 0
    fi
fi

echo "Installing Auto-Claude v${VERSION}..."

# Create directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$DESKTOP_DIR"
mkdir -p "$ICON_DIR"

# Download AppImage
echo "Downloading Auto-Claude AppImage..."
if ! curl -L -o "$INSTALL_DIR/auto-claude" "$DOWNLOAD_URL"; then
    echo "Failed to download Auto-Claude"
    exit 1
fi

# Make executable
chmod +x "$INSTALL_DIR/auto-claude"

# Store version for idempotency
echo "$VERSION" > "$VERSION_FILE"

# Download icon (optional, don't fail if missing)
echo "Downloading icon..."
curl -sL -o "$ICON_DIR/auto-claude.png" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png" 2>/dev/null || true

# Create desktop entry
cat > "$DESKTOP_DIR/auto-claude.desktop" << EOF
[Desktop Entry]
Name=Auto-Claude
Comment=Intelligent automation for Claude AI
Exec=$INSTALL_DIR/auto-claude
Icon=$ICON_DIR/auto-claude.png
Type=Application
Categories=Development;Utility;
Terminal=false
EOF

echo "Auto-Claude v${VERSION} installed successfully!"
echo "Location: $INSTALL_DIR/auto-claude"
