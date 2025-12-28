#!/bin/bash

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

./install-yay-package.sh pnpm
