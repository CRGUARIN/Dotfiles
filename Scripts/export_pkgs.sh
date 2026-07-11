#!/bin/bash

# Ruta de destino
DESTINO="$HOME/Documentos/Dotfiles/pkgs/"

# Crear la carpeta si no existe
mkdir -p "$DESTINO"

echo "Exportando paquetes oficiales (Pacman)..."
# -Qe muestra instalados explícitamente, -qn filtra solo los de repos oficiales
pacman -Qqn >"$DESTINO/pkglist.txt"

# Verificar si paru está instalado
if command -v paru &>/dev/null; then
  echo "Exportando paquetes de AUR (paru)..."
  # -Qm filtra solo los paquetes foráneos (AUR)
  paru -Qqm >"$DESTINO/aurlist.txt"
else
  echo "Aviso: 'paru' no está instalado en este sistema."
fi

echo "Archivos guardados en: $DESTINO"
