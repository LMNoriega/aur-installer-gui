# Brag Plan: AUR Installer GUI

## What is this app?
Un lanzador e instalador flotante y minimalista para paquetes AUR y repositorios oficiales de Arch Linux, construido con Python y QML/QtQuick bajo la estética Serpantinum / Frosted Glass.

## The angle
Instalar paquetes de AUR nunca se sintió tan fluido ni estético: adiós a las búsquedas lentas en la terminal o interfaces toscas. Una ventana flotante estilo spotlight con vidrio esmerilado translúcido, animaciones elásticas de caracteres (*bouncy pop-in*), morphing de selección y efectos de sonido nativos táctiles.

## Hook (first 2-3 seconds)
Un atajo de teclado invoca instantáneamente la ventana flotante translúcida en el centro de la pantalla, con un borde resplandeciente malva y efecto de vidrio líquido esmerilado.

## Key moments (the middle)
- **Búsqueda en tiempo real con rebote elástico**: cada letra tecleada ("zen-browser") salta con una animación pop elástica y sonido táctil sincrónico.
- **Píldora de selección con morphing**: la barra de selección se desliza suavemente resaltando el paquete encontrado con sus badges ("AUR", "Popular").
- **Alternancia instantánea con Tab**: cambio fluido a modo "🗑️ Desinstalar" con acento dinámico rojo pastel (#ffb4ab), mostrando paquetes instalados y peso en disco.

## Outro / punchline
"AUR Installer GUI: Minimalista, veloz y 100% universal para cualquier escritorio Arch Linux."

## User flow worth showing
1. **Invocación**: Atajo abre la ventana flotante translúcida en el centro.
2. **Búsqueda y navegación**: Se escribe "zen-browser" con feedback de sonido por carácter y resultados instantáneos de AUR.
3. **Gestión y cambio de modo**: Tab cambia al selector de desinstalación y confirmación táctil con sonido de campana de progreso.

## Tone
- Preset: `polished`
- Creative direction: Modern floating Linux spotlight launcher with Serpantinum frosted glass aesthetic
- Interpretation: Transiciones fluidas, tipografía JetBrains Mono limpia, confianza visual a través del diseño de vidrio líquido y sincronización de sonido táctil.

## Format: landscape — 1920x1080
## Duration: 18 seconds

## Visual identity (from the project)
- Background: `#110d11` (base con 76% alpha sobre fondo oscuro moderno de Linux)
- Mantle/Surface: `#1f1a1f`, `#231e23`
- Accent Primary (Install): `#e9b5ef` (Mauve Serpantinum)
- Accent Secondary (Uninstall): `#ffb4ab` (Red Serpantinum)
- Text Primary: `#eae0e7`
- Text Subtext: `#cfc3cd` / `#988d97`
- Display & Body font: `JetBrains Mono, Inter, system-ui, sans-serif`
- Strongest visual element: Ventana flotante translúcida con borde neón malva, tab pill deslizante y feedback sonoro nativo.

## Share copy (draft)
AUR Installer GUI: un lanzador flotante minimalista para Arch Linux con estética Serpantinum, búsqueda instantánea y feedback sonoro nativo. 📦✨

## Audio direction
- Role: Warm lo-fi tech bed con efectos de sonido nativos táctiles del proyecto.
- Music: `happy-beats-business-moves-vol-12-by-ende-dot-app.mp3`
- Music treatment: Cama musical a volumen equilibrado (0.35) con fade-out sutil en los últimos 1.5s.
- Music cue guidance: Tempo ~110 BPM. Cues mayores alrededor de 8.74s y 13.5s para transiciones entre escenas y highlights.
- Audio-reactive treatment: Sutil respiración del resplandor de fondo y borde de la ventana según la energía musical.
- SFX posture: Moderada y táctil; utiliza los sonidos auténticos de la aplicación (`type.wav`, `sfx.wav`, `click.wav`, `Progress.wav`).
- Restraint rule: Los efectos de sonido apoyan las interacciones visuales (tecleo, cambio de tab, confirmación) sin saturar la pista musical.

## Storyboard

### Scene 1 — Invocación Spotlight — 3.5s
Aparición fluida de la ventana flotante translúcida estilo spotlight sobre fondo oscuro con sutiles orbes de desenfoque. Aparece el pill de atajo `Super + Space`. La ventana abre con borde malva (#e9b5ef) y foco inmediato en la barra de búsqueda con cursor palpitante.
Sequential/interaction: Sí — atajo de teclado se ilumina, la ventana se despliega con elasticidad y el cursor parpadea.
Audio intent: Apertura nítida y elegante.
Audio-coupled idea: Sfx de apertura suave de interfaz al aterrizar la ventana.
Music: Entrada suave de la pista musical.
Transition mood: clean → Scene 2

### Scene 2 — Búsqueda en Tiempo Real & Bouncy Pop-in — 5.0s
El usuario escribe "zen-browser". Cada letra aparece con un pequeño rebote elástico. Inmediatamente emergen los resultados de AUR ("zen-browser-bin", badges "AUR", "Popular", versión "v1.0.1"). La píldora de selección morphing se desliza bajo el primer resultado.
Sequential/interaction: Sí — tipeo secuencial de caracteres y deslizamiento de selección hacia el paquete.
Audio intent: Feedback táctil gratificante.
Audio-coupled idea: Sfx de tecleo auténtico sincronizado con la animación pop de las letras y switch sfx al seleccionar.
Transition mood: slide / crossfade → Scene 3

### Scene 3 — Alternancia Tab & Desinstalación — 5.0s
Presión simulada de `Tab`. La píldora activa se desliza suavemente a "🗑️ Desinstalar". La paleta transmuta dinámicamente de malva a rojo pastel (#ffb4ab). Se despliegan paquetes instalados con sus tamaños ("google-chrome 245 MB", "discord 180 MB"). Enter ejecuta la confirmación.
Sequential/interaction: Sí — el selector de tab se anima hacia la derecha con overshoot, la lista cambia y se ilumina el botón de confirmación.
Audio intent: Dinamismo de control y respuesta instantánea.
Audio-coupled idea: Sonido de switch en el tab y campanilla de progreso (Progress.wav) al confirmar.
Transition mood: clean wipe / scale → Scene 4

### Scene 4 — Outro & Universal Arch Linux — 4.5s
La ventana se reposiciona como tarjeta central con el logotipo/icono del paquete 📦 y el branding: "AUR Installer GUI". Se presentan los distintivos de compatibilidad: "Arch Linux · CachyOS · EndeavourOS · Omarchy · Yay / Paru".
Sequential/interaction: Sí — badges de compatibilidad emergen en secuencia.
Audio intent: Cierre satisfactorio y profesional.
Audio-coupled idea: Ring final y fade suave de la música.
Music: Fade out final hacia 18.0s.

**Music mood for this video:** Modern clean electronic beat (~110 BPM), tech and upbeat.
**Audio summary:** Base musical rítmica y limpia sobre la cual resaltan los sonidos físicos auténticos de la aplicación (tecleo, cambio de pestaña y campanilla de éxito).
