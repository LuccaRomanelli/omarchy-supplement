#!/bin/bash

# Batch cloner for git repositories
# Reads from repos.list and clones all listed repositories

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
LIST_FILE="$SCRIPT_DIR/repos.list"

if [ ! -f "$LIST_FILE" ]; then
    echo "Error: Repository list file not found: $LIST_FILE"
    exit 1
fi

echo "Cloning git repositories from $LIST_FILE..."
echo

while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Parse line: repo_url [repo_name] [branch] [post_clone_script]
    read -r repo_url repo_name branch post_clone_script <<< "$line"

    "$SCRIPT_DIR/clone-repo.sh" "$repo_url" "$repo_name" "$branch" "$post_clone_script"
    echo
done < "$LIST_FILE"

echo "Git repository cloning complete!"
