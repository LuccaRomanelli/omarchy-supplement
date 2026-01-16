#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install voxtype via yay
"$SCRIPT_DIR/install-package.sh" voxtype

# Verify installation
if ! command -v voxtype &>/dev/null; then
  echo "Voxtype installation failed."
  exit 1
fi

# Download Whisper model (if not already downloaded)
WHISPER_DIR="$HOME/.local/share/voxtype"
if [ ! -d "$WHISPER_DIR" ] || [ -z "$(ls -A "$WHISPER_DIR" 2>/dev/null)" ]; then
  echo "Downloading Whisper model for offline transcription..."
  voxtype setup --download
fi

echo "Voxtype installed successfully!"
