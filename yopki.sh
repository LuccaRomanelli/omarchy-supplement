#!/bin/bash

# Script para sincronizar todos os repositórios da Yopki
# Usage: ./sync_yopki_repos.sh

set -euo pipefail

# Caminho para o script git_sync_repo.sh
ORIGINAL_DIR=$(pwd)
SYNC_SCRIPT="$ORIGINAL_DIR/git_sync_repo.sh"

# Verifica se o script git_sync_repo.sh existe
if [ ! -f "$SYNC_SCRIPT" ]; then
  echo "Erro: Script '$SYNC_SCRIPT' não encontrado."
  echo "Certifique-se de que git_sync_repo.sh está no mesmo diretório."
  exit 1
fi

# Torna o script executável se necessário
chmod +x "$SYNC_SCRIPT"

# Diretório base para os repositórios Yopki
BASE_DIR="$HOME/yopki"

echo "=========================================="
echo " Preparando diretório base: $BASE_DIR"
echo "=========================================="

# Cria o diretório $HOME/yopki se não existir
mkdir -p "$BASE_DIR"

echo "=========================================="
echo "Sincronizando repositórios da Yopki"
echo "=========================================="
echo ""

# Lista de repositórios
REPOS=(
  "git@github.com:yopkiinc/trip-planner-web.git"
  "git@github.com:yopkiinc/trip-planner-backend.git"
  "git@github.com:yopkiinc/trip-planner-bff.git"
  "git@github.com:yopkiinc/yopki-dev.git"
)

# Sincroniza cada repositório
for REPO in "${REPOS[@]}"; do
  echo ""
  echo "=========================================="
  "$SYNC_SCRIPT" "$REPO" "" "main" "$BASE_DIR"
  echo "=========================================="
done

echo ""
echo "✅ Todos os repositórios foram sincronizados!"
echo ""
echo "Repositórios disponíveis em $BASE_DIR:"
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
