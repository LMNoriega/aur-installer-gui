# 📦 AUR Installer GUI (Serpantinum Aesthetic)

Un instalador y desinstalador de paquetes de **AUR (Arch User Repository)** y repositorios oficiales de Arch Linux con interfaz gráfica flotante en **QML / QtQuick**, animaciones fluidas y efectos de sonido nativos inspirados en la estética de **Serpantinum**.

Diseñado para ser **100% universal**: funciona directamente en cualquier distribución basada en Arch Linux (**Arch puro, CachyOS, EndeavourOS, Manjaro, Omarchy**) y con cualquier entorno de escritorio o gestor de ventanas (**KDE Plasma, GNOME, Hyprland, Sway, Niri, XFCE**).

---

## ✨ Características

- 🔍 **Búsqueda instantánea en AUR y Repositorios Oficiales**: Consulta en tiempo real mediante la API oficial v5 de AUR y la base de datos local de `pacman`.
- 🗑️ **Pestaña de Desinstalación de Apps**: Lista y filtra todas las aplicaciones instaladas (`pacman -Qe`), dando máxima prioridad a las instaladas desde AUR y repositorios de usuario con su tamaño en disco.
- 🎨 **Estética nativa Serpantinum / Frosted Glass**:
  - Ventana flotante centrada con esquinas redondeadas y fondo translúcido tipo vidrio esmerilado.
  - Animación elástica de rebote (*bouncy pop-in*) para cada carácter que escribes.
  - Cursor deslizante suave y animado.
  - Barra de selección con efecto *morphing* detrás de cada elemento.
- 🔊 **Efectos de sonido integrados y autónomos**:
  - Sonidos incluidos directamente dentro del repositorio (sin necesidad de tener Serpantinum instalado).
  - Sonido al escribir (`reusables/input/type.wav`).
  - Sonido al alternar pestañas y navegar (`reusables/switch/sfx.wav`).
  - Sonido de confirmación y clic (`reusables/clickbutton/click.wav`).
  - Sonido de finalización y notificación (`notifications/Progress.wav`).
  - Soporte automático para `pw-play` (PipeWire), `paplay` (PulseAudio) y `aplay` (ALSA).
- 🖥️ **Soporte Universal de Terminales**:
  - Detecta automáticamente el emulador de terminal del sistema: **Kitty, Alacritty, Ghostty, Konsole (KDE), Foot, GNOME Terminal, Ptyxis, XFCE Terminal, Wezterm, Xterm** o `$TERMINAL`.
- ⚡ **Compatibilidad con `yay` y `paru`**:
  - Detección automática del helper instalado en tu sistema.
- 🛡️ **Seguridad por diseño**:
  - Regla segura y opcional en `sudoers (NOPASSWD: /usr/bin/pacman)` para instalaciones automáticas sin pedir clave constantemente.

---

## ⌨️ Atajos y Navegación

| Tecla / Acción | Descripción |
| :--- | :--- |
| **`Atajo asignado`** | Abre el menú flotante en el centro de la pantalla |
| **`Tab`** | Alterna entre el modo **📦 Instalar** y **🗑️ Desinstalar** |
| **Escribir** | Búsqueda o filtrado en tiempo real con sonidos y animación |
| **`↓` / `↑`** | Navega por la lista de paquetes (con sonido de switch y selección deslizante) |
| **`Enter`** (o clic) | Abre la terminal centrada y ejecuta la instalación o desinstalación |
| **`Esc`** | Cierra la ventana inmediatamente |

---

## 🚀 Instalación Rápida

```bash
git clone https://github.com/LMNoriega/aur-installer-gui.git
cd aur-installer-gui
./install.sh
```

El script de instalación:
1. Detecta tu entorno de escritorio (**KDE Plasma, GNOME, Hyprland, Sway, Niri**, etc.).
2. Comprueba dependencias y te permite instalarlas automáticamente.
3. Copia binarios, interfaz QML y sonidos integrados a `~/.local/`.
4. Te pregunta y configura el atajo de teclado adecuado para tu entorno (evitando colisiones en KDE Plasma).

---

## ⚙️ Configuración de Atajos por Entorno

### 🔵 KDE Plasma (CachyOS / Arch)
> ⚠️ **Nota:** En KDE Plasma, `Super + I` abre las Preferencias del Sistema por defecto.
> El instalador te sugerirá configurarlo como **`Meta + Shift + A`** o **`Meta + A`**.
> También puedes configurarlo o cambiarlo manualmente en:
> **Preferencias del Sistema > Accesos rápidos > Accesos rápidos personalizados > Instalador AUR**.

### 🟠 Hyprland
En tu archivo de atajos (`~/.config/hypr/bindings.lua` o `keybinds.lua`):
```lua
hl.bind("SUPER + I", hl.dsp.exec_cmd("aur-search-gui"))
```

En tus reglas de ventana flotante (`~/.config/hypr/settings.lua` o `hyprland.conf`):
```lua
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
```

### 🟣 GNOME
En **Configuración > Teclado > Ver y personalizar atajos > Atajos personalizados**:
- **Nombre:** `Instalador AUR`
- **Comando:** `aur-search-gui`
- **Atajo:** `<Super><Shift>A`

### 🟢 Sway / i3
En tu archivo de configuración (`~/.config/sway/config`):
```i3config
bindsym $mod+Shift+a exec aur-search-gui
```

### 🟡 Niri
En `~/.config/niri/config.kdl`:
```kdl
binds {
    Mod+Shift+A { spawn "aur-search-gui"; }
}
```

---

## 📄 Estructura del Repositorio

```
aur-installer-gui/
├── assets/
│   └── sounds/              # Efectos de sonido incluidos (independientes)
├── bin/
│   ├── aur-search-gui       # Backend y frontend QtQuick/QML
│   └── aur-installer-run    # Ejecutor en terminal (soporte yay/paru)
├── qml/
│   └── Main.qml             # Interfaz QML completa
├── desktop/
│   └── aur-installer-gui.desktop
├── sudoers/
│   └── 10-aur-installer     # Regla NOPASSWD para pacman
├── install.sh               # Instalador interactivo y universal
└── README.md
```

---

## 👤 Autor
- **Lucas Noriega** - [@LMNoriega](https://github.com/LMNoriega)
