#!/bin/bash

THEMES_DIR="$HOME/.config/omarchy/themes"

# Função que mapeia URL -> nome de diretório real do tema
get_theme_dir_name() {
    local repo_url="$1"

    case "$repo_url" in
        "https://github.com/dotsilva/omarchy-purplewave-theme")
            echo "purplewave"
            ;;
        "https://github.com/Luquatic/omarchy-catppuccin-dark")
            echo "catppuccin-dark"
            ;;
        "https://github.com/vyrx-dev/omarchy-void-theme.git")
            echo "void"
            ;;
        "https://github.com/ahmed-z0/omarchy-miles-morales-theme")
            echo "miles-morales"
            ;;
        "https://github.com/JJDizz1L/aetheria.git")
            echo "aetheria"
            ;;
        "https://github.com/HANCORE-linux/omarchy-batou-theme.git")
            echo "batou"
            ;;
        "https://github.com/JustArmaan/omarchy-gotham-city-theme.git")
            echo "gotham-city"
            ;;
        "https://github.com/atif-1402/omarchy-rainynight-theme.git")
            echo "rainynight"
            ;;
        "https://github.com/abhijeet-swami/omarchy-spectra-theme")
            echo "spectra"
            ;;
        "https://github.com/atif-1402/omarchy-neonstreet-theme.git")
            echo "neonstreet"
            ;;
        "https://github.com/Grey-007/duskwire.git")
            echo "duskwire"
            ;;
        "https://github.com/ShehabShaef/omarchy-drac-theme")
            echo "drac"
            ;;
        "https://github.com/evanklem/omarchy-avocado-theme")
            echo "avocado"
            ;;
        "https://github.com/RiO7MAKK3R/omarchy-omacarchy-theme")
            echo "omacarchy"
            ;;
        *)
            # fallback: usa o basename sem .git
            basename "$repo_url" .git
            ;;
    esac
}

is_theme_installed() {
    local repo_url="$1"
    local theme_dir
    theme_dir="$(get_theme_dir_name "$repo_url")"

    if [ -d "$THEMES_DIR/$theme_dir" ]; then
        return 0
    else
        return 1
    fi
}

install_theme_if_needed() {
    local repo_url="$1"
    local theme_dir
    theme_dir="$(get_theme_dir_name "$repo_url")"

    if is_theme_installed "$repo_url"; then
        echo "✓ Tema '$theme_dir' já está instalado. Pulando..."
    else
        echo "→ Instalando tema '$theme_dir' a partir de '$repo_url'..."
        omarchy-theme-install "$repo_url"
    fi
}

mkdir -p "$THEMES_DIR"

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
