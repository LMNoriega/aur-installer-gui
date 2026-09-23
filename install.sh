#!/usr/bin/env bash
# ==============================================================================
# AUR Installer GUI - Script de Instalación Universal
# Compatible con: KDE Plasma, GNOME, Hyprland, Sway, Niri, XFCE y más
# ==============================================================================

set -e

BOLD="\033[1m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
PURPLE="\033[1;35m"
RED="\033[1;31m"
RESET="\033[0m"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ACTION="auto"
for arg in "$@"; do
    case "$arg" in
        --update|-u)
            ACTION="update"
            ;;
        --reinstall|--full)
            ACTION="full"
            ;;
        --help|-h)
            echo "Uso: ./install.sh [OPCIONES]"
            echo ""
            echo "Opciones:"
            echo "  --update, -u         Actualizar a la última versión (rápido, conserva atajos y config)"
            echo "  --reinstall, --full  Reinstalación y reconfiguración completa desde cero"
            echo "  --help, -h           Mostrar esta ayuda"
            exit 0
            ;;
    esac
done

# Detección de instalación previa si no se especificó un flag explícito
if [ "$ACTION" = "auto" ] && [ -f "$HOME/.local/bin/aur-search-gui" ]; then
    echo -e "${PURPLE}╭──────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${PURPLE}│${RESET}             ${BOLD}AUR-INSTALLER-GUI${RESET}                            ${PURPLE}│${RESET}"
    echo -e "${PURPLE}╰──────────────────────────────────────────────────────────╯${RESET}"
    echo ""
    echo -e "${CYAN}==> Se detectó una instalación previa en ~/.local/bin/aur-search-gui${RESET}"
    echo ""
    echo -e "  ${BOLD}1)${RESET} ${GREEN}${BOLD}Actualizar a la última versión${RESET} (rápido: actualiza código, binarios y assets, conservando tus atajos)"
    echo -e "  ${BOLD}2)${RESET} ${YELLOW}Reinstalar / Reconfigurar desde cero${RESET} (vuelve a configurar dependencias, sudoers y atajos)"
    echo -e "  ${BOLD}3)${RESET} Salir"
    echo ""
    read -rp "  Selecciona una opción [1/2/3, por defecto: 1]: " opc
    opc=${opc:-1}
    case "$opc" in
        1)
            ACTION="update"
            ;;
        2)
            ACTION="full"
            ;;
        *)
            echo "Operación cancelada."
            exit 0
            ;;
    esac
fi

# Modo actualización rápida
if [ "$ACTION" = "update" ]; then
    echo -e "${PURPLE}╭──────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${PURPLE}│${RESET}         ${BOLD}ACTUALIZADOR DE AUR-INSTALLER-GUI${RESET}                ${PURPLE}│${RESET}"
    echo -e "${PURPLE}╰──────────────────────────────────────────────────────────╯${RESET}"
    echo ""
    echo -e "${BLUE}==> Actualizando AUR Installer GUI...${RESET}"

    # 1. Sincronización con Git si aplica
    if [ -d "$DIR/.git" ] && command -v git >/dev/null 2>&1; then
        echo -e "  ${BLUE}• Comprobando actualizaciones en GitHub...${RESET}"
        if [ -n "$(git -C "$DIR" status --porcelain 2>/dev/null)" ]; then
            echo -e "  ${YELLOW}! Aviso: Se detectaron cambios locales modificados en el repositorio.${RESET}"
            read -rp "  ¿Deseas descartar cambios locales y actualizar con la versión oficial limpia de GitHub? [S/n]: " reset_git
            reset_git=${reset_git:-S}
            if [[ "$reset_git" =~ ^[sS]$ ]]; then
                git -C "$DIR" fetch origin 2>/dev/null || true
                git -C "$DIR" reset --hard origin/main 2>/dev/null || true
                echo -e "  ${GREEN}✔ Repositorio sincronizado con la versión oficial limpia de GitHub.${RESET}"
            else
                echo -e "  ${YELLOW}Conservando cambios locales del repositorio.${RESET}"
            fi
        else
            git -C "$DIR" pull --rebase origin main 2>/dev/null || git -C "$DIR" pull origin main 2>/dev/null || true
            echo -e "  ${GREEN}✔ Repositorio actualizado con la última versión de GitHub.${RESET}"
        fi
    fi

    # 2. Actualizar archivos locales
    echo -e "  ${BLUE}• Actualizando binarios y recursos locales...${RESET}"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share/aur-gui/sounds"
    mkdir -p "$HOME/.local/share/applications"

    install -m 755 "$DIR/bin/aur-search-gui" "$HOME/.local/bin/aur-search-gui"
    install -m 755 "$DIR/bin/aur-installer-run" "$HOME/.local/bin/aur-installer-run"
    cp -f "$DIR/qml/Main.qml" "$HOME/.local/share/aur-gui/Main.qml"
    cp -f "$DIR/desktop/aur-installer-gui.desktop" "$HOME/.local/share/applications/aur-installer-gui.desktop"

    if [ -d "$DIR/assets/sounds" ]; then
        cp -rf "$DIR/assets/sounds/"* "$HOME/.local/share/aur-gui/sounds/"
    fi

    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    fi

    echo -e "\n${GREEN}${BOLD}✔ ¡AUR Installer GUI ha sido actualizado con éxito a la última versión!${RESET}"
    echo -e "  Tus configuraciones de atajos de teclado y sudoers se han conservado intactas."
    echo ""
    exit 0
fi

echo -e "${PURPLE}╭──────────────────────────────────────────────────────────╮${RESET}"
echo -e "${PURPLE}│${RESET}             ${BOLD}INSTALADOR DE AUR-INSTALLER-GUI${RESET}              ${PURPLE}│${RESET}"
echo -e "${PURPLE}╰──────────────────────────────────────────────────────────╯${RESET}"
echo ""

# ------------------------------------------------------------------------------
# 1. Comprobación y sugerencia de dependencias
# ------------------------------------------------------------------------------
echo -e "${BLUE}==> 1. Comprobando dependencias...${RESET}"

MISSING_DEPS=()

if ! command -v pacman >/dev/null 2>&1; then
    echo -e "${RED}✘ Error: Este instalador requiere una distribución basada en Arch Linux (pacman).${RESET}"
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    MISSING_DEPS+=("python")
fi

if ! python3 -c "import PyQt6" >/dev/null 2>&1; then
    MISSING_DEPS+=("python-pyqt6")
fi

if ! command -v yay >/dev/null 2>&1 && ! command -v paru >/dev/null 2>&1; then
    MISSING_DEPS+=("yay")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "  ${YELLOW}! Dependencias faltantes detectadas:${RESET} ${MISSING_DEPS[*]}"
    read -rp "  ¿Deseas intentar instalarlas ahora con pacman? [S/n]: " inst_deps
    inst_deps=${inst_deps:-S}
    if [[ "$inst_deps" =~ ^[sS]$ ]]; then
        sudo pacman -S --needed --noconfirm "${MISSING_DEPS[@]}" || {
            echo -e "${YELLOW}No se pudieron instalar todas automáticamente. Asegúrate de instalarlas manualmente.${RESET}"
        }
    fi
else
    echo -e "  ${GREEN}✔ Todas las dependencias principales están instaladas (Python, PyQt6, Helper AUR).${RESET}"
fi

# Detectar emuladores de terminal
DETECTED_TERM=""
for t in kitty alacritty ghostty konsole foot gnome-terminal ptyxis xfce4-terminal wezterm xterm; do
    if command -v "$t" >/dev/null 2>&1; then
        DETECTED_TERM="$t"
        break
    fi
done

if [ -n "$DETECTED_TERM" ]; then
    echo -e "  ${GREEN}✔ Terminal detectada para instalación interactiva:${RESET} ${CYAN}${DETECTED_TERM}${RESET}"
else
    echo -e "  ${YELLOW}! Aviso: No se detectó una terminal conocida (kitty, alacritty, konsole, etc.).${RESET}"
fi

# ------------------------------------------------------------------------------
# 2. Instalación de archivos locales
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}==> 2. Instalando archivos y recursos...${RESET}"

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/aur-gui/sounds/notifications"
mkdir -p "$HOME/.local/share/aur-gui/sounds/reusables/input"
mkdir -p "$HOME/.local/share/aur-gui/sounds/reusables/clickbutton"
mkdir -p "$HOME/.local/share/aur-gui/sounds/reusables/switch"
mkdir -p "$HOME/.local/share/applications"

# Copiar ejecutables y QML
install -m 755 "$DIR/bin/aur-search-gui" "$HOME/.local/bin/aur-search-gui"
install -m 755 "$DIR/bin/aur-installer-run" "$HOME/.local/bin/aur-installer-run"
cp -f "$DIR/qml/Main.qml" "$HOME/.local/share/aur-gui/Main.qml"
cp -f "$DIR/desktop/aur-installer-gui.desktop" "$HOME/.local/share/applications/aur-installer-gui.desktop"

# Copiar assets de sonido incluidos en el repositorio
if [ -d "$DIR/assets/sounds" ]; then
    cp -rf "$DIR/assets/sounds/"* "$HOME/.local/share/aur-gui/sounds/"
    echo -e "  ${GREEN}✔ Efectos de sonido integrados instalados en ~/.local/share/aur-gui/sounds/${RESET}"
fi

echo -e "  ${GREEN}✔ Binarios instalados en ~/.local/bin/${RESET}"
echo -e "  ${GREEN}✔ Lanzador desktop registrado en ~/.local/share/applications/${RESET}"

# ------------------------------------------------------------------------------
# 3. Regla opcional de sudoers NOPASSWD para pacman
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}==> 3. Configuración de privilegios automáticos (sudoers)...${RESET}"
if [ -f /etc/sudoers.d/10-aur-installer ]; then
    echo -e "  ${GREEN}✔ La regla /etc/sudoers.d/10-aur-installer ya está configurada.${RESET}"
else
    echo "  Esta regla permite que pacman instale paquetes sin pedir contraseña continuamente."
    read -rp "  ¿Deseas configurar la regla segura de sudoers (NOPASSWD para pacman)? [S/n]: " resp_sudo
    resp_sudo=${resp_sudo:-S}
    if [[ "$resp_sudo" =~ ^[sS]$ ]]; then
        TARGET_USER="${SUDO_USER:-$USER}"
        if groups "$TARGET_USER" 2>/dev/null | grep -q '\bwheel\b'; then
            sudo cp "$DIR/sudoers/10-aur-installer" /etc/sudoers.d/10-aur-installer
        else
            echo "$TARGET_USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" | sudo tee /etc/sudoers.d/10-aur-installer > /dev/null
        fi
        sudo chmod 0440 /etc/sudoers.d/10-aur-installer
        echo -e "  ${GREEN}✔ Regla sudoers instalada con éxito.${RESET}"
    else
        echo -e "  ${YELLOW}Omitido. El instalador te pedirá tu contraseña cada vez.${RESET}"
    fi
fi

# ------------------------------------------------------------------------------
# 4. Detección de entorno y configuración de atajo de teclado
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}==> 4. Configuración del atajo de teclado...${RESET}"

CURRENT_DESKTOP="desconocido"
if [ -n "$KDE_FULL_SESSION" ] || [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$DESKTOP_SESSION" = "plasma" ]; then
    CURRENT_DESKTOP="kde"
elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$DESKTOP_SESSION" = "gnome" ]; then
    CURRENT_DESKTOP="gnome"
elif [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] || [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    CURRENT_DESKTOP="hyprland"
elif [ -n "$SWAYSOCK" ] || [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
    CURRENT_DESKTOP="sway"
elif [ -n "$NIRI_SOCKET" ] || [ "$XDG_CURRENT_DESKTOP" = "niri" ]; then
    CURRENT_DESKTOP="niri"
fi

echo -e "  Entorno de escritorio detectado: ${CYAN}${CURRENT_DESKTOP}${RESET}"

DEFAULT_KEY="Super+Shift+A"
if [ "$CURRENT_DESKTOP" = "hyprland" ]; then
    DEFAULT_KEY="SUPER + I"
elif [ "$CURRENT_DESKTOP" = "kde" ]; then
    DEFAULT_KEY="Meta+Shift+A"
    echo -e "  ${YELLOW}Nota para KDE Plasma: 'Super + I' suele abrir las Preferencias del Sistema.${RESET}"
    echo -e "  ${YELLOW}Se recomienda usar 'Meta+Shift+A' o 'Meta+A' para evitar conflictos.${RESET}"
fi

read -rp "  ¿Deseas configurar un atajo de teclado ahora? [S/n]: " set_key
set_key=${set_key:-S}

if [[ "$set_key" =~ ^[sS]$ ]]; then
    read -rp "  Ingresa la combinación de teclas deseada [Default: $DEFAULT_KEY]: " CHOSEN_KEY
    CHOSEN_KEY="${CHOSEN_KEY:-$DEFAULT_KEY}"

    case "$CURRENT_DESKTOP" in
        kde)
            KCONF=$(command -v kwriteconfig6 || command -v kwriteconfig5 || true)
            if [ -n "$KCONF" ]; then
                $KCONF --file kglobalshortcutsrc --group "aur-installer-gui.desktop" --key "_launch" "${CHOSEN_KEY},none,Instalador AUR"
                qdbus6 org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel.reloadConfig 2>/dev/null || \
                qdbus org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel.reloadConfig 2>/dev/null || true
                echo -e "  ${GREEN}✔ Atajo '$CHOSEN_KEY' registrado en KDE Plasma (kglobalshortcutsrc).${RESET}"
            else
                echo -e "  ${YELLOW}Abre 'Preferencias del Sistema > Accesos rápidos', busca 'Instalador AUR' y asígnale '$CHOSEN_KEY'.${RESET}"
            fi
            ;;
        hyprland)
            CONFIGURED=0
            # 1. Omarchy / Modular Lua Hyprland setup
            if [ -f "$HOME/.config/hypr/config/keybinds.lua" ] && [ -f "$HOME/.config/hypr/config/settings.lua" ]; then
                if ! grep -q "aur-search-gui" "$HOME/.config/hypr/config/keybinds.lua" 2>/dev/null; then
                    echo "hl.bind(\"$CHOSEN_KEY\", hl.dsp.exec_cmd(\"aur-search-gui\"))" >> "$HOME/.config/hypr/config/keybinds.lua"
                fi
                if ! grep -q "aur-installer-gui" "$HOME/.config/hypr/config/settings.lua" 2>/dev/null; then
                    cat <<'HL' >> "$HOME/.config/hypr/config/settings.lua"

-- AUR Installer window rules
hl.window_rule({
  name = "aur-installer-gui",
  match = { class = "aur-installer-gui" },
  float = true,
  center = true,
  size = { 740, 560 },
})

hl.window_rule({
  name = "aur-installer-term",
  match = { class = "aur-installer-term" },
  float = true,
  center = true,
  size = { 900, 600 },
})
HL
                fi
                CONFIGURED=1
            # 2. Archcraft / bindings.lua setup
            elif [ -f "$HOME/.config/hypr/bindings.lua" ]; then
                if ! grep -q "aur-search-gui" "$HOME/.config/hypr/bindings.lua" 2>/dev/null; then
                    echo "hl.bind(\"$CHOSEN_KEY\", hl.dsp.exec_cmd(\"aur-search-gui\"))" >> "$HOME/.config/hypr/bindings.lua"
                fi
                CONFIGURED=1
            # 3. Standard hyprland.conf setup
            elif [ -f "$HOME/.config/hypr/hyprland.conf" ]; then
                if ! grep -q "aur-search-gui" "$HOME/.config/hypr/hyprland.conf" 2>/dev/null; then
                    cat <<HLC >> "$HOME/.config/hypr/hyprland.conf"

# AUR Installer GUI
bind = SUPER, I, exec, aur-search-gui
windowrulev2 = float, class:^(aur-installer-gui)$
windowrulev2 = center, class:^(aur-installer-gui)$
windowrulev2 = size 740 560, class:^(aur-installer-gui)$
windowrulev2 = float, class:^(aur-installer-term)$
windowrulev2 = center, class:^(aur-installer-term)$
windowrulev2 = size 900 600, class:^(aur-installer-term)$
HLC
                fi
                CONFIGURED=1
            fi

            if [ $CONFIGURED -eq 1 ]; then
                if command -v hyprctl >/dev/null 2>&1; then
                    hyprctl reload >/dev/null 2>&1 || true
                fi
                echo -e "  ${GREEN}✔ Atajo y reglas de ventana flotante configuradas y recargadas en Hyprland.${RESET}"
            else
                echo -e "  ${GREEN}Para Hyprland, añade la siguiente línea a tu configuración:${RESET}"
                echo -e "  ${CYAN}hl.bind(\"$CHOSEN_KEY\", hl.dsp.exec_cmd(\"aur-search-gui\"))${RESET}"
                echo -e "  o en sintaxis hyprland.conf:"
                echo -e "  ${CYAN}bind = SUPER, I, exec, aur-search-gui${RESET}"
            fi
            ;;
        gnome)
            echo -e "  ${GREEN}En GNOME puedes asignarlo desde: Configuración > Teclado > Ver y personalizar atajos > Atajos personalizados.${RESET}"
            echo -e "  Comando: ${CYAN}aur-search-gui${RESET} | Tecla: ${CYAN}$CHOSEN_KEY${RESET}"
            ;;
        sway|i3)
            echo -e "  ${GREEN}En tu archivo de configuración de Sway/i3 añade:${RESET}"
            echo -e "  ${CYAN}bindsym \$mod+Shift+a exec aur-search-gui${RESET}"
            ;;
        niri)
            echo -e "  ${GREEN}En tu config.kdl de Niri añade:${RESET}"
            echo -e "  ${CYAN}binds { Mod+Shift+A { spawn \"aur-search-gui\"; } }${RESET}"
            ;;
        *)
            echo -e "  ${GREEN}Atajo asignable en tu gestor de ventanas: Comando '${CYAN}aur-search-gui${RESET}' con teclas '${CYAN}$CHOSEN_KEY${RESET}'.${RESET}"
            ;;
    esac
fi

# ------------------------------------------------------------------------------
# 5. Finalización
# ------------------------------------------------------------------------------
echo -e "\n${GREEN}${BOLD}✔ ¡Instalación finalizada con éxito!${RESET}"
echo -e "Puedes abrirlo desde:"
echo -e "  1. La terminal ejecutando: ${CYAN}aur-search-gui${RESET}"
echo -e "  2. El menú de aplicaciones de tu escritorio buscando: ${CYAN}Instalador AUR${RESET}"
if [ -n "$CHOSEN_KEY" ]; then
    echo -e "  3. Con tu atajo de teclado: ${CYAN}$CHOSEN_KEY${RESET}"
fi
echo ""
