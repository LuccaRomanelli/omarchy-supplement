#!/bin/bash

# Usage: ./git_sync_repo.sh <REPO_URL> [REPO_NAME] [BRANCH]
# - REPO_URL: required
# - REPO_NAME: opcional (default: name from URL)
# - BRANCH: opcional (default: main)

set -euo pipefail

REPO_URL="${1:-}"
REPO_NAME="${2:-}"
BRANCH="${3:-main}"

if [ -z "$REPO_URL" ]; then
  echo "Erro: REPO_URL é obrigatório."
  echo "Uso: $0 <REPO_URL> [REPO_NAME] [BRANCH]"
  exit 1
fi

# Se REPO_NAME não foi passado, extrai da URL (parte depois da última / sem .git)
if [ -z "$REPO_NAME" ]; then
  REPO_NAME="$(basename "$REPO_URL" .git)"
fi

echo "Repo URL : $REPO_URL"
echo "Repo Dir : $REPO_NAME"
echo "Branch   : $BRANCH"

cd "$HOME"

if [ -d "$REPO_NAME/.git" ]; then
  echo "Repositório '$REPO_NAME' já existe. Fazendo pull da branch '$BRANCH'..."
  cd "$REPO_NAME"
  git fetch origin
  git checkout "$BRANCH" || git checkout -b "$BRANCH" origin/"$BRANCH"
  git pull origin "$BRANCH"
  echo "Pull concluído."
else
  echo "Repositório '$REPO_NAME' não existe. Clonando..."
  git clone --branch "$BRANCH" "$REPO_URL" "$REPO_NAME"
  echo "Clone concluído."
fi
