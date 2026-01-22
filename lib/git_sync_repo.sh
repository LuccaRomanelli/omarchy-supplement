#!/bin/bash

# Usage: ./git_sync_repo.sh <REPO_URL> [REPO_NAME] [BRANCH] [BASE_DIR] [FORCE_PULL]
# - REPO_URL: required
# - REPO_NAME: optional (default: name from URL)
# - BRANCH: optional (default: main)
# - BASE_DIR: optional (default: $HOME)
# - FORCE_PULL: optional (default: false) - if true, pulls even if repo exists

set -euo pipefail

REPO_URL="${1:-}"
REPO_NAME="${2:-}"
BRANCH="${3:-main}"
BASE_DIR="${4:-$HOME}"
FORCE_PULL="${5:-false}"

if [ -z "$REPO_URL" ]; then
  echo "Error: REPO_URL is required."
  echo "Usage: $0 <REPO_URL> [REPO_NAME] [BRANCH] [BASE_DIR] [FORCE_PULL]"
  exit 1
fi

# If REPO_NAME was not provided, extract from URL (part after last / without .git)
if [ -z "$REPO_NAME" ]; then
  REPO_NAME="$(basename "$REPO_URL" .git)"
fi

echo "Repo URL   : $REPO_URL"
echo "Repo Dir   : $REPO_NAME"
echo "Branch     : $BRANCH"
echo "Base Dir   : $BASE_DIR"
echo "Force Pull : $FORCE_PULL"

cd "$BASE_DIR"

if [ -d "$REPO_NAME/.git" ]; then
  if [ "$FORCE_PULL" = "true" ]; then
    echo "Repository '$REPO_NAME' exists. Pulling latest changes..."
    cd "$REPO_NAME"
    git fetch origin
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
    echo "Pull completed."
  else
    echo "Repository '$REPO_NAME' already exists. Skipping."
  fi
else
  echo "Repository '$REPO_NAME' does not exist. Cloning..."
  git clone --branch "$BRANCH" "$REPO_URL" "$REPO_NAME"
  echo "Clone completed."
fi
