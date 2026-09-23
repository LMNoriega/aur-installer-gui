version = 1.1.0

# Registro de Cambios (Changelog) - AUR Installer GUI

## [1.1.0] - 2026-09-23
### Añadido
- **Búsqueda natural inteligente**: tolera búsquedas con espacios (ej. "google chrome"), nombres con guiones y normalización de términos en paralelo.
- **Puntuación por relevancia y popularidad**: prioriza coincidencias exactas, tokens de palabras completas y paquetes con alta cantidad de votos en AUR (Google Chrome, VS Code, Spotify, etc.).
- **Soporte universal para múltiples escritorios**: compatible de forma nativa con KDE Plasma, GNOME, Hyprland, Sway y Niri mediante `xdg-terminal-exec`.
- **Selector y configuración de terminal predeterminada**: integración con las preferencias XDG del sistema (Kitty, Foot, Alacritty, Konsole, etc.).
- **Efectos de sonido táctiles integrados**: assets de sonido incluidos directamente en el repositorio.
- **Sistema de actualización inteligente (`update.sh`)**: comprobación automática de versión remota vs. versión local mediante `CHANGELOG.md` y sincronización con GitHub.

## [1.0.0] - 2026-09-23
### Versión inicial
- Interfaz gráfica moderna en QML / Python PyQt6 estilo Sarpanitium.
- Búsqueda en AUR y repositorios oficiales.
- Instalación interactiva en ventana flotante de terminal con `yay` o `paru`.
- Pestaña de desinstalador con listado de aplicaciones y paquetes instalados.
- Regla segura de `sudoers` para instalación sin interrupciones de contraseña.
