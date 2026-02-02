#!/bin/bash
# Script para gerenciar monitores automaticamente
# - HDMI conectado: usa apenas o monitor externo (desabilita eDP-1)
# - HDMI desconectado: usa a tela do notebook

check_and_switch() {
    # Verifica se HDMI-A-1 está conectado (usando hyprctl monitors all para ver todos)
    if hyprctl monitors all -j | grep -q '"name": "HDMI-A-1"'; then
        # HDMI conectado - desabilita tela do notebook
        hyprctl keyword monitor "eDP-1, disable"
    else
        # HDMI desconectado - habilita tela do notebook
        hyprctl keyword monitor "eDP-1, preferred, 0x0, 1"
    fi
}

# Aguarda Hyprland inicializar completamente
sleep 2

# Executa verificação inicial
check_and_switch

# Monitora eventos de conexão/desconexão de monitores
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    case "$line" in
        monitoradded*|monitorremoved*)
            sleep 0.5  # Pequeno delay para estabilização
            check_and_switch
            ;;
    esac
done
