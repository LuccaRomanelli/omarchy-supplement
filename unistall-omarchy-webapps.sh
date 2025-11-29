#!/bin/bash

ICON_DIR="$HOME/.local/share/applications/icons"
DESKTOP_DIR="$HOME/.local/share/applications/"

APP_NAME=(
    "Basecamp"
    "Chatgpt"
    "Google Contacts"
    "Google Messages"
    "HEY"
    "X"
    "Zoom"
)

for APP_NAME in "${APP_NAMES[@]}"; do
  rm -f "$DESKTOP_DIR/$APP_NAME.desktop"
  rm -f "$ICON_DIR/$APP_NAME.png"
  echo "Removed $APP_NAME"
done


