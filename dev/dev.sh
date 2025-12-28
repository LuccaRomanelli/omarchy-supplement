#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Install Node.js versions (latest + LTS 24)
if command -v mise &>/dev/null; then
    echo "Installing Node.js versions via mise..."
    MISE_NODE_VERIFY=0 mise install node@latest
    MISE_NODE_VERIFY=0 mise install node@24
    mise use -g node@24  # Set LTS 24 as default
fi

if ! command -v laravel &>/dev/null; then
    omarchy-install-dev-env laravel
fi

"$ROOT_DIR/yay/install-package.sh" pnpm
