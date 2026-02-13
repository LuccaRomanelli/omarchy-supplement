#!/bin/bash

# Ollama Installation Script with CUDA support
# Installs ollama-cuda, enables the service, and pulls qwen2.5:3b model

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

echo "Installing Ollama with CUDA support..."

# Install ollama-cuda
"$SCRIPT_DIR/install-package.sh" ollama-cuda

# Enable and start ollama service (system-level)
echo "Enabling ollama service..."
sudo systemctl enable ollama
sudo systemctl start ollama

# Wait for service to start
echo "Waiting for ollama service to start..."
sleep 3

# Pull qwen2.5:3b model
echo "Pulling qwen2.5:3b model..."
ollama pull qwen2.5:3b

echo "Ollama installation complete!"
