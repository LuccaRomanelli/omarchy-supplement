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

# Install Python via mise
if command -v mise &>/dev/null; then
    if ! mise list python 2>/dev/null | grep -q "python"; then
        echo "Installing Python via mise..."
        mise install python@latest
    fi
    mise use -g python@latest
fi

# Install python-dotenv
if command -v pip &>/dev/null; then
    if ! pip show python-dotenv &>/dev/null; then
        echo "Installing python-dotenv..."
        pip install python-dotenv
    fi
fi

if ! command -v laravel &>/dev/null; then
    omarchy-install-dev-env laravel
fi

"$ROOT_DIR/yay/install-package.sh" pnpm
