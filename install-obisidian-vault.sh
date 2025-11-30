#!/bin/bash

ORIGINAL_DIR=$(pwd)
GIT_SYNC_SCRIPT="$ORIGINAL_DIR/git_sync_repo.sh"
REPO_URL="git@github.com:LuccaRomanelli/obisidian.git"
REPO_NAME="obisidian"

cd ~
# Sync the repository
"$GIT_SYNC_SCRIPT" "$REPO_URL" "$REPO_NAME"


