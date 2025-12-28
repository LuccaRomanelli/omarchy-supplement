#!/bin/bash

# Install nhost CLI

if ! command -v nhost &>/dev/null; then
    echo "Installing nhost CLI..."
    curl -L https://raw.githubusercontent.com/nhost/cli/main/get.sh | bash
else
    echo "nhost is already installed"
fi
