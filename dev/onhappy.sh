#!/bin/bash

# Script to sync all Onhappy repositories
# Usage: ./sync_onhappy_repos.sh

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

# Base directory for Onhappy repositories
BASE_DIR="$HOME/onhappy"

echo "=========================================="
echo " Preparing base directory: $BASE_DIR"
echo "=========================================="

# Create $HOME/onhappy directory if it doesn't exist
mkdir -p "$BASE_DIR"

echo "=========================================="
echo "Syncing Onhappy repositories"
echo "=========================================="
echo ""

# Repository list
REPOS=(
  "git@gitlab.com:onflylabs/onhappy/reposit-rios/onhappy-frontend.git"
  "git@gitlab.com:onflylabs/onhappy/reposit-rios/onhappy-backend.git"
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
echo "  - $BASE_DIR/onhappy-frontend"
echo "  - $BASE_DIR/onhappy-backend"

echo ""
echo "=========================================="
echo "Setting up onhappy-frontend"
echo "=========================================="
echo ""
cd $BASE_DIR/onhappy-frontend

# Install npm dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "Installing npm dependencies..."
    npm install
else
    echo "npm dependencies already installed, skipping..."
fi

# Copy .env if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please configure your .env file with the necessary credentials"
else
    echo ".env file already exists, skipping..."
fi

echo ""
echo "=========================================="
echo "Setting up onhappy-backend"
echo "=========================================="
echo ""
cd $BASE_DIR/onhappy-backend

# Copy .env if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please configure your .env file with the necessary credentials"
    echo "   See: https://gitlab.com/onflylabs/onhappy/reposit-rios/onhappy-backend#how-to-generate-env-keys"
else
    echo ".env file already exists, skipping..."
fi

# Configure WWWUSER and WWWGROUP if not already set
if ! grep -q "^WWWUSER=" .env || ! grep -q "^WWWGROUP=" .env; then
    echo "Configuring WWWUSER and WWWGROUP..."
    CURRENT_USER=$(id -u)
    CURRENT_GROUP=$(id -g)
    
    # Update or add WWWUSER
    if grep -q "^WWWUSER=" .env; then
        sed -i "s/^WWWUSER=.*/WWWUSER=$CURRENT_USER/" .env
    else
        echo "WWWUSER=$CURRENT_USER" >> .env
    fi
    
    # Update or add WWWGROUP
    if grep -q "^WWWGROUP=" .env; then
        sed -i "s/^WWWGROUP=.*/WWWGROUP=$CURRENT_GROUP/" .env
    else
        echo "WWWGROUP=$CURRENT_GROUP" >> .env
    fi
    
    echo "✓ WWWUSER set to $CURRENT_USER"
    echo "✓ WWWGROUP set to $CURRENT_GROUP"
else
    echo "WWWUSER and WWWGROUP already configured, skipping..."
fi

# Install composer dependencies if vendor doesn't exist
if [ ! -d "vendor" ]; then
    echo "Installing composer dependencies..."
    docker run -it \
        -u "$(id -u):$(id -g)" \
        -v ${PWD}/:/var/www/html \
        -w /var/www/html \
        composer:lts \
        composer install --ignore-platform-reqs --no-scripts
else
    echo "Composer dependencies already installed, skipping..."
fi

# Check if sail is available
if [ ! -f "vendor/bin/sail" ]; then
    echo "❌ Error: Laravel Sail not found. Composer install may have failed."
    exit 1
fi

# Create and start containers
echo "Creating and starting Docker containers..."
vendor/bin/sail up --detach --force-recreate laravel.test

# Wait for containers to be ready
echo "Waiting for containers to be ready..."
sleep 5

# Run post-autoload-dump
echo "Running post-autoload-dump..."
vendor/bin/sail composer run post-autoload-dump

# Generate app key if not already generated
if ! grep -q "^APP_KEY=base64:" .env; then
    echo "Generating application key..."
    vendor/bin/sail artisan key:generate
else
    echo "Application key already generated, skipping..."
fi

# Copy configuration files
echo "Copying configuration files..."
if [ -f ".git/hooks/pre-commit.sample" ] && [ ! -f ".git/hooks/pre-commit" ]; then
    cp .git/hooks/pre-commit.sample .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo "✓ Pre-commit hook configured"
fi

if [ -f "phpstan.neon.dev" ] && [ ! -f "phpstan.neon" ]; then
    cp phpstan.neon.dev phpstan.neon
    echo "✓ PHPStan configuration copied"
fi

# Publish Telescope assets
if [ ! -d "public/vendor/telescope" ]; then
    echo "Publishing Telescope assets..."
    vendor/bin/sail artisan telescope:publish
else
    echo "Telescope assets already published, skipping..."
fi

# Publish Horizon assets
if [ ! -d "public/vendor/horizon" ]; then
    echo "Publishing Horizon assets..."
    vendor/bin/sail artisan horizon:publish
else
    echo "Horizon assets already published, skipping..."
fi

# Publish Debugbar assets
if [ ! -d "public/vendor/debugbar" ]; then
    echo "Publishing Debugbar assets..."
    vendor/bin/sail artisan vendor:publish --provider="Barryvdh\Debugbar\ServiceProvider"
else
    echo "Debugbar assets already published, skipping..."
fi

# Run migrations and seed
echo "Running migrations and seeding database..."
vendor/bin/sail artisan migrate --seed --force

# Install Node dependencies
if [ ! -d "node_modules" ]; then
    echo "Installing Node dependencies..."
    vendor/bin/sail npm install
else
    echo "Node dependencies already installed, skipping..."
fi

# Build admin assets
echo "Building admin assets..."
vendor/bin/sail npm run build

# Publish storage link and app assets
if [ ! -L "public/storage" ]; then
    echo "Creating storage link..."
    vendor/bin/sail artisan storage:link
else
    echo "Storage link already exists, skipping..."
fi

echo "Publishing app assets..."
vendor/bin/sail artisan app:publish-assets

echo ""
echo "=========================================="
echo "✓ Setup completed successfully!"
echo "=========================================="
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Configure your .env files with the necessary credentials:"
echo "   - Frontend: $BASE_DIR/onhappy-frontend/.env"
echo "   - Backend: $BASE_DIR/onhappy-backend/.env"
echo ""
echo "2. Configure Minio (http://minio:8900/):"
echo "   - User: sail"
echo "   - Password: password"
echo "   - Create 'onhappy-files' bucket with Public access policy"
echo ""
echo "3. Add to /etc/hosts:"
echo "   127.0.0.1  minio"
echo "   127.0.0.1  api.onhappy.local"
echo "   127.0.0.1  admin.onhappy.local"
echo ""
echo "4. Start the admin development server:"
echo "   cd $BASE_DIR/onhappy-backend"
echo "   vendor/bin/sail npm run dev"
echo ""
echo "Available URLs:"
echo "  - API: http://api.onhappy.local"
echo "  - Admin: http://admin.onhappy.local"
echo "  - Telescope: http://api.onhappy.local/telescope"
echo "  - Horizon: http://api.onhappy.local/horizon"
echo "  - Mailpit: http://api.onhappy.local:8025"
echo "  - Minio: http://minio:8900"
echo "  - Swagger: http://api.onhappy.local/docs/api"
echo ""
