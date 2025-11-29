#!/bin/bash

# Diretório onde os temas do Omarchy são instalados
THEMES_DIR="$HOME/.config/omarchy/themes"

# Função para verificar se um tema já está instalado
is_theme_installed() {
    local repo_url="$1"
    # Extrai o nome do repositório da URL (remove .git se existir)
    local theme_name=$(basename "$repo_url" .git)
    
    # Verifica se o diretório do tema existe
    if [ -d "$THEMES_DIR/$theme_name" ]; then
        return 0  # Tema já instalado
    else
        return 1  # Tema não instalado
    fi
}

# Função para instalar tema se não estiver instalado
install_theme_if_needed() {
    local repo_url="$1"
    local theme_name=$(basename "$repo_url" .git)
    
    if is_theme_installed "$repo_url"; then
        echo "✓ Tema '$theme_name' já está instalado. Pulando..."
    else
        echo "→ Instalando tema '$theme_name'..."
        omarchy-theme-install "$repo_url"
    fi
}

# Cria o diretório de temas se não existir
mkdir -p "$THEMES_DIR"

# Instala os temas apenas se não estiverem instalados
install_theme_if_needed "https://github.com/dotsilva/omarchy-purplewave-theme"
install_theme_if_needed "https://github.com/Luquatic/omarchy-catppuccin-dark"
install_theme_if_needed "https://github.com/vyrx-dev/omarchy-void-theme.git"
install_theme_if_needed "https://github.com/ahmed-z0/omarchy-miles-morales-theme"
install_theme_if_needed "https://github.com/JJDizz1L/aetheria.git"
install_theme_if_needed "https://github.com/HANCORE-linux/omarchy-batou-theme.git"
install_theme_if_needed "https://github.com/JustArmaan/omarchy-gotham-city-theme.git"
install_theme_if_needed "https://github.com/atif-1402/omarchy-rainynight-theme.git"
install_theme_if_needed "https://github.com/abhijeet-swami/omarchy-spectra-theme"
install_theme_if_needed "https://github.com/atif-1402/omarchy-neonstreet-theme.git"
install_theme_if_needed "https://github.com/Grey-007/duskwire.git"
install_theme_if_needed "https://github.com/ShehabShaef/omarchy-drac-theme"
install_theme_if_needed "https://github.com/evanklem/omarchy-avocado-theme"
install_theme_if_needed "https://github.com/RiO7MAKK3R/omarchy-omacarchy-theme"

curl -fsSL https://imbypass.github.io/omarchy-theme-hook/install.sh | bash

echo ""
echo "✓ Instalação concluída!"
