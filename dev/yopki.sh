#!/bin/bash

# Script to sync all Yopki repositories
# Usage: ./sync_yopki_repos.sh

set -euo pipefail

# Path to git_sync_repo.sh script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SYNC_SCRIPT="$ROOT_DIR/lib/git_sync_repo.sh"

# Check if git_sync_repo.sh script exists
if [ ! -f "$SYNC_SCRIPT" ]; then
  echo "Error: Script '$SYNC_SCRIPT' not found."
  echo "Make sure git_sync_repo.sh is in the same directory."
  exit 1
fi

# Make script executable if needed
chmod +x "$SYNC_SCRIPT"

# Base directory for Yopki repositories
BASE_DIR="$HOME/yopki"

echo "=========================================="
echo " Preparing base directory: $BASE_DIR"
echo "=========================================="

# Create $HOME/yopki directory if it doesn't exist
mkdir -p "$BASE_DIR"

echo "=========================================="
echo "Syncing Yopki repositories"
echo "=========================================="
echo ""

# Repository list
REPOS=(
  "git@github.com:yopkiinc/trip-planner-web.git"
  "git@github.com:yopkiinc/trip-planner-backend.git"
  "git@github.com:yopkiinc/trip-planner-bff.git"
  "git@github.com:yopkiinc/yopki-dev.git"
)

# Sync each repository
for REPO in "${REPOS[@]}"; do
  echo ""
  echo "=========================================="
  "$SYNC_SCRIPT" "$REPO" "" "main" "$BASE_DIR"
  echo "=========================================="
done

echo ""
echo "All repositories have been synced!"
echo ""
echo "Repositories available at $BASE_DIR:"
echo "  - $BASE_DIR/trip-planner-web"
echo "  - $BASE_DIR/trip-planner-backend"
echo "  - $BASE_DIR/trip-planner-bff"
echo "  - $BASE_DIR/yopki-dev"


echo "=========================================="
echo "Copy Yopki Web .env"
echo "=========================================="
echo ""
cd $BASE_DIR/trip-planner-web
npm install
if [ ! -f apps/web-desktop/.env.local ]; then
    cp apps/web-desktop/.env.local.example apps/web-desktop/.env.local
fi

if [ ! -f apps/web-mobile/.env.local ]; then
    cp apps/web-mobile/.env.local.example apps/web-mobile/.env.local
fi
npm install

echo "=========================================="
echo "Copy Yopki BFF .env"
echo "=========================================="
echo ""
cd $BASE_DIR/trip-planner-bff
if [ ! -f .secrets ]; then
    cp secrets.example .secrets
fi


echo "=========================================="
echo "Copy Yopki Backend .env"
echo "=========================================="
echo ""
cd $BASE_DIR/trip-planner-backend

if [ ! -f .env ]; then
    cp .env.example .env
fi

pnpm i

echo "=========================================="
echo "Configure UFW for Docker"
echo "=========================================="
echo ""

# Allow Docker containers to reach host services (required for Yopki dev environment)
UFW_RULES_FILE="/etc/ufw/before.rules"
DOCKER_RULE="-A ufw-before-input -s 172.16.0.0/12 -j ACCEPT"

if grep -q "172.16.0.0/12" "$UFW_RULES_FILE" 2>/dev/null; then
    echo "UFW Docker rule already exists, skipping..."
else
    echo "Adding UFW rule to allow Docker containers to reach host services..."
    sudo sed -i '/# allow all on loopback/i # Allow Docker containers to reach host services\n-A ufw-before-input -s 172.16.0.0/12 -j ACCEPT\n' "$UFW_RULES_FILE"
    echo "Reloading UFW..."
    sudo ufw reload
    echo "UFW configured for Docker."
fi
