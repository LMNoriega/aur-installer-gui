#!/usr/bin/env bash
# Script de instalación para aur-installer-gui

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Instalando aur-installer-gui..."

# 1. Crear directorios de destino
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/aur-gui"
mkdir -p "$HOME/.local/share/applications"

# 2. Copiar ejecutables y recursos
cp -f "$DIR/bin/aur-search-gui" "$HOME/.local/bin/aur-search-gui"
cp -f "$DIR/bin/aur-installer-run" "$HOME/.local/bin/aur-installer-run"
cp -f "$DIR/qml/Main.qml" "$HOME/.local/share/aur-gui/Main.qml"
cp -f "$DIR/desktop/aur-installer-gui.desktop" "$HOME/.local/share/applications/aur-installer-gui.desktop"

chmod +x "$HOME/.local/bin/aur-search-gui"
chmod +x "$HOME/.local/bin/aur-installer-run"

echo "✔ Archivos instalados en ~/.local/bin y ~/.local/share"

# 3. Preguntar por la regla sudoers NOPASSWD opcional
if [ ! -f /etc/sudoers.d/10-aur-installer ]; then
    read -rp "¿Deseas configurar la regla segura de sudoers (NOPASSWD para pacman) para instalaciones 100% automáticas? [s/N]: " resp
    if [[ "$resp" =~ ^[sS]$ ]]; then
        sudo cp "$DIR/sudoers/10-aur-installer" /etc/sudoers.d/10-aur-installer
        sudo chmod 0440 /etc/sudoers.d/10-aur-installer
        echo "✔ Regla sudoers instalada con éxito."
    fi
fi

echo "==> Instalación finalizada con éxito."
echo "Puedes ejecutarlo con 'aur-search-gui' o configurando tu atajo en Hyprland (ej: Super + I)."
