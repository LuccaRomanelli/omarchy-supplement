#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

INSTALL_DIR="$HOME/.local/bin"
ICON_DIR="$HOME/.local/share/icons"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_FILE="$ICON_DIR/auto-claude.png"
DESKTOP_FILE="$DESKTOP_DIR/auto-claude.desktop"
APPIMAGE_FILE="$INSTALL_DIR/auto-claude.AppImage"

mkdir -p "$INSTALL_DIR" "$ICON_DIR" "$DESKTOP_DIR"

# Get latest stable release from GitHub (excludes prereleases and drafts)
echo "Fetching latest Auto-Claude release..."
RELEASE_DATA=$(curl -sL "https://api.github.com/repos/AndyMik90/Auto-Claude/releases/latest")

# Extract tag and download URL using grep (avoids jq issues with control characters in release notes)
LATEST_TAG=$(echo "$RELEASE_DATA" | grep -o '"tag_name": *"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$LATEST_TAG" ]; then
  echo "Failed to fetch latest release."
  exit 1
fi

echo "Latest stable release: $LATEST_TAG"

# Track installed version in a separate file
VERSION_FILE="$INSTALL_DIR/.auto-claude-version"

if [ -f "$APPIMAGE_FILE" ] && [ -f "$VERSION_FILE" ]; then
  CURRENT_VERSION=$(cat "$VERSION_FILE")
  if [ "$CURRENT_VERSION" = "$LATEST_TAG" ]; then
    echo "Auto-Claude $LATEST_TAG is already installed."
  else
    echo "Updating Auto-Claude from $CURRENT_VERSION to $LATEST_TAG..."
    rm -f "$APPIMAGE_FILE"
  fi
fi

# Download AppImage if not present
if [ ! -f "$APPIMAGE_FILE" ]; then
  DOWNLOAD_URL=$(echo "$RELEASE_DATA" | grep -o '"browser_download_url": *"[^"]*\.AppImage"' | cut -d'"' -f4)

  if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" = "null" ]; then
    echo "Failed to find AppImage download URL."
    exit 1
  fi

  echo "Downloading Auto-Claude AppImage..."
  curl -L --progress-bar -o "$APPIMAGE_FILE" "$DOWNLOAD_URL"
  chmod +x "$APPIMAGE_FILE"
  echo "$LATEST_TAG" > "$VERSION_FILE"
fi

# Create symlink for easy command access
ln -sf "$APPIMAGE_FILE" "$INSTALL_DIR/auto-claude"

# Verify installation (check file exists and is executable)
if [ ! -x "$APPIMAGE_FILE" ]; then
  echo "Auto-Claude installation failed."
  exit 1
fi

# Ensure version file exists
echo "$LATEST_TAG" > "$VERSION_FILE"

# Download custom icon
if [ ! -f "$ICON_FILE" ]; then
  echo "Downloading Auto-Claude icon..."
  curl -L --progress-bar -o "$ICON_FILE" \
    "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png"
fi

# Create desktop file
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=Auto-Claude
Comment=Autonomous multi-agent coding framework
Exec=$APPIMAGE_FILE
Icon=$ICON_FILE
Terminal=false
Type=Application
Categories=Development;
EOF

echo "Auto-Claude $LATEST_TAG installed successfully!"
