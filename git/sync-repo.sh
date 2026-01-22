#!/bin/bash

# Centralized git repository sync (pull latest)
# Usage: ./sync-repo.sh <repo_url> [repo_name] [branch] [post_sync_script]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GIT_SYNC_SCRIPT="$ROOT_DIR/lib/git_sync_repo.sh"

REPO_URL="${1:-}"
REPO_NAME="${2:-}"
BRANCH="${3:-main}"
POST_SYNC_SCRIPT="${4:-}"

if [ -z "$REPO_URL" ]; then
    echo "Error: Repository URL is required"
    echo "Usage: $0 <repo_url> [repo_name] [branch] [post_sync_script]"
    exit 1
fi

# If REPO_NAME was not provided, extract from URL
if [ -z "$REPO_NAME" ]; then
    REPO_NAME="$(basename "$REPO_URL" .git)"
fi

# Sync the repository with FORCE_PULL=true
"$GIT_SYNC_SCRIPT" "$REPO_URL" "$REPO_NAME" "$BRANCH" "$HOME" "true"

# Run post-sync script if specified and exists
if [ -n "$POST_SYNC_SCRIPT" ] && [ -f "$HOME/$REPO_NAME/$POST_SYNC_SCRIPT" ]; then
    echo "Running post-sync script: $POST_SYNC_SCRIPT"
    cd "$HOME/$REPO_NAME"
    bash "$POST_SYNC_SCRIPT"
fi
