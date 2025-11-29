#!/bin/bash

if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

if ! command -v gemini &>/dev/null; then
    npm install -g @google/gemini-cli
fi

if ! command -v abacusai &>/dev/null; then
    npm install -g @abacus-ai/cli
fi
