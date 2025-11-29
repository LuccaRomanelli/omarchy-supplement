#!/bin/bash

# Check if asdf is installed
if ! command -v asdf &>/dev/null; then
    echo "asdf is not installed. Please run ./install-asdf.sh first."
    exit 1
fi

# Install PHP build dependencies
echo "Installing PHP build dependencies..."
yay -S --noconfirm --needed base-devel gcc make openssl libxml2 curl libzip oniguruma sqlite

# Install php plugin for asdf if not already installed
if ! asdf plugin list | grep -q php; then
    asdf plugin add php https://github.com/asdf-community/asdf-php.git
fi

# Install latest stable PHP if no php version is installed
if ! asdf list php &>/dev/null || [ -z "$(asdf list php 2>/dev/null)" ]; then
    echo "Installing PHP..."
    asdf install php latest
    asdf global php latest
fi

echo "PHP installation complete!"
