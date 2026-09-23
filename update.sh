#!/usr/bin/env bash
# ==============================================================================
# AUR Installer GUI - Actualizador Rápido
# ==============================================================================
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$DIR/install.sh" --update "$@"
