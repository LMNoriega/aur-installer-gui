# 📦 AUR Installer GUI (Serpantinum Aesthetic)

Un instalador y desinstalador de paquetes de **AUR (Arch User Repository)** y repositorios oficiales de Arch Linux con interfaz gráfica flotante en **QML / QtQuick**, animaciones fluidas y efectos de sonido nativos inspirados en el lanzador de **Serpantinum** para **Hyprland**.

---

## ✨ Características

- 🔍 **Búsqueda instantánea en AUR y Repositorios Oficiales**: Consulta en tiempo real mediante la API oficial v5 de AUR y la base de datos local de `pacman`.
- 🗑️ **Pestaña de Desinstalación de Apps**: Lista y filtra todas las aplicaciones instaladas (`pacman -Qe`), dando máxima prioridad a las instaladas desde AUR y repositorios de usuario con su tamaño en disco.
- 🎨 **Estética nativa Serpantinum**:
  - Ventana flotante centrada con esquinas redondeadas y bordes iluminados.
  - Sincronización dinámica de la paleta de colores activa (`qs_colors.json`).
  - Animación elástica de rebote (*bouncy pop-in*) para cada carácter que escribes.
  - Cursor deslizante suave y animado.
  - Barra de selección con efecto *morphing* detrás de cada elemento.
- 🔊 **Efectos de sonido integrados**:
  - Sonido al escribir (`reusables/input/type.wav`).
  - Sonido al alternar pestañas y navegar (`reusables/switch/sfx.wav`).
  - Sonido de confirmación y clic (`reusables/clickbutton/click.wav`).
  - Sonido de finalización y notificación (`notifications/Progress.wav`).
- ⚡ **Instalación y Desinstalación 100% Automática**:
  - No requiere ingresar contraseñas repetidamente gracias a la regla segura de `sudoers`.
  - Responde automáticamente a confirmaciones interactivas (`--noconfirm`, limpieza de build y diffs).
  - Cierre automático de la terminal tras 2 segundos al completarse exitosamente.
- 🛡️ **Seguridad por diseño**:
  - No almacena contraseñas en ningún archivo de texto ni en disco.
  - Se rige bajo el principio de menor privilegio con `sudoers (NOPASSWD: /usr/bin/pacman)`.

---

## ⌨️ Atajos y Navegación

| Tecla / Acción | Descripción |
| :--- | :--- |
| **`Super + I`** | Abre el menú flotante en el centro de la pantalla |
| **`Tab`** | Alterna entre el modo **📦 Instalar** y **🗑️ Desinstalar** |
| **Escribir** | Búsqueda o filtrado en tiempo real con sonidos y animación |
| **`↓` / `↑`** | Navega por la lista de paquetes (con sonido de switch y selección deslizante) |
| **`Enter`** (o clic) | Abre la terminal centrada y ejecuta la instalación o desinstalación |
| **`Esc`** | Cierra la ventana inmediatamente |

---

## 🚀 Instalación y Configuración

### 1. Clonar el repositorio
```bash
git clone https://github.com/LMNoriega/aur-installer-gui.git
cd aur-installer-gui
./install.sh
```

### 2. Dependencias requeridas
En Arch Linux / Omarchy:
```bash
yay -S python-pyqt6 yay pipewire notify-send
```

### 3. Configuración en Hyprland (`~/.config/hypr/`)

En tu archivo de atajos (`~/.config/hypr/config/keybinds.lua`):
```lua
hl.bind("SUPER + I", hl.dsp.exec_cmd("aur-search-gui"))
```

En tus reglas de ventana (`~/.config/hypr/config/settings.lua`):
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

---

## 📄 Estructura del Proyecto

```
aur-installer-gui/
├── bin/
│   ├── aur-search-gui      # Lanzador y backend en Python/QtQuick
│   └── aur-installer-run    # Ejecutor en terminal con yay, sonidos y notificaciones
├── qml/
│   └── Main.qml             # Interfaz QML completa con estética y sonidos Serpantinum
├── desktop/
│   └── aur-installer-gui.desktop
├── sudoers/
│   └── 10-aur-installer     # Regla NOPASSWD para pacman
├── install.sh               # Script de instalación rápida
└── README.md
```

---

## 👤 Autor
- **Lucas Noriega** - [@LMNoriega](https://github.com/LMNoriega)
