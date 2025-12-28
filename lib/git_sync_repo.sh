#!/bin/bash

# Usage: ./git_sync_repo.sh <REPO_URL> [REPO_NAME] [BRANCH] [BASE_DIR]
# - REPO_URL: required
# - REPO_NAME: optional (default: name from URL)
# - BRANCH: optional (default: main)
# - BASE_DIR: optional (default: $HOME)

set -euo pipefail

REPO_URL="${1:-}"
REPO_NAME="${2:-}"
BRANCH="${3:-main}"
BASE_DIR="${4:-$HOME}"

if [ -z "$REPO_URL" ]; then
  echo "Error: REPO_URL is required."
  echo "Usage: $0 <REPO_URL> [REPO_NAME] [BRANCH] [BASE_DIR]"
  exit 1
fi

# If REPO_NAME was not provided, extract from URL (part after last / without .git)
if [ -z "$REPO_NAME" ]; then
  REPO_NAME="$(basename "$REPO_URL" .git)"
fi

echo "Repo URL : $REPO_URL"
echo "Repo Dir : $REPO_NAME"
echo "Branch   : $BRANCH"
echo "Base Dir : $BASE_DIR"

cd "$BASE_DIR"

if [ -d "$REPO_NAME/.git" ]; then
  echo "Repository '$REPO_NAME' already exists. Pulling branch '$BRANCH'..."
  cd "$REPO_NAME"
  git fetch origin
  git checkout "$BRANCH" || git checkout -b "$BRANCH" origin/"$BRANCH"
  git pull origin "$BRANCH"
  echo "Pull completed."
else
  echo "Repository '$REPO_NAME' does not exist. Cloning..."
  git clone --branch "$BRANCH" "$REPO_URL" "$REPO_NAME"
  echo "Clone completed."
fi
