#!/bin/bash

set -euo pipefail

# Verifica se asdf está instalado
if ! command -v asdf &>/dev/null; then
    echo "asdf is not installed. Please run ./install-asdf.sh first."
    exit 1
fi

# Função para instalar pacotes via yay apenas se não estiverem instalados
install_pkg_if_needed() {
    local pkg="$1"
    if ! pacman -Qi "$pkg" &>/dev/null; then
        echo "→ Instalando pacote: $pkg"
        yay -S --noconfirm --needed "$pkg"
    else
        echo "✓ Pacote já instalado: $pkg"
    fi
}

echo "Instalando dependências de build do PHP (idempotente)..."

DEPS=(
    base-devel
    gcc
    make
    openssl
    libxml2
    curl
    libzip
    oniguruma
    sqlite
)

for pkg in "${DEPS[@]}"; do
    install_pkg_if_needed "$pkg"
done

# Instala plugin php do asdf se ainda não estiver instalado
if ! asdf plugin list | grep -q '^php$'; then
    echo "→ Adicionando plugin php ao asdf..."
    asdf plugin add php https://github.com/asdf-community/asdf-php.git
else
    echo "✓ Plugin php já está adicionado ao asdf."
fi

# Descobre a versão "latest" do PHP suportada pelo plugin
echo "Verificando versão 'latest' do PHP pelo asdf..."
LATEST_PHP_VERSION="$(asdf list all php | grep -v 'rc' | grep -v 'alpha' | grep -v 'beta' | tail -n 1 || true)"

if [ -z "$LATEST_PHP_VERSION" ]; then
    echo "Não foi possível determinar a versão mais recente do PHP via asdf."
    exit 1
fi

echo "Versão mais recente detectada: $LATEST_PHP_VERSION"

# Verifica se essa versão já está instalada
if asdf list php 2>/dev/null | grep -q "$LATEST_PHP_VERSION"; then
    echo "✓ PHP $LATEST_PHP_VERSION já está instalado."
else
    echo "→ Instalando PHP $LATEST_PHP_VERSION..."
    asdf install php "$LATEST_PHP_VERSION"
fi

# Define global apenas se ainda não estiver setado para essa versão
CURRENT_GLOBAL="$(asdf current php 2>/dev/null | awk '{print $2}' || true)"

if [ "$CURRENT_GLOBAL" = "$LATEST_PHP_VERSION" ]; then
    echo "✓ PHP global já está definido como $LATEST_PHP_VERSION."
else
    echo "→ Definindo PHP global para $LATEST_PHP_VERSION..."
    asdf global php "$LATEST_PHP_VERSION"
fi

echo "✓ Instalação/configuração do PHP via asdf concluída!"
