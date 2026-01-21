#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Install Node.js versions (LTS 24)
if command -v mise &>/dev/null; then
    if ! mise list node 2>/dev/null | grep -q "24"; then
        echo "Installing Node.js 24 via mise..."
        MISE_NODE_VERIFY=0 mise install node@24
    fi
    mise use -g node@24  # Set LTS 24 as default (idempotent)
fi

"$ROOT_DIR/yay/install-package.sh" pnpm
