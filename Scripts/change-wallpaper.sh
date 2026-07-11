#!/bin/bash

# Define la ruta exacta de tu carpeta de fondos
DIR="$HOME/Imágenes/Fondos/"

# Archivo temporal para recordar cuál fue el último fondo que se usó
STATE_FILE="$HOME/.cache/current_wallpaper"

# Verifica que la carpeta exista para evitar errores
if [ ! -d "$DIR" ]; then
  notify-send "Error de Fondos" "No se encontró la carpeta: $DIR"
  exit 1
fi

# 3. Busca todas las imágenes, las ordena alfabéticamente y las guarda en un arreglo (lista)
# Usa -print0 y sort -z para manejar bien los nombres de archivo que tengan espacios
readarray -d '' IMGS < <(find "$DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) -print0 | sort -z)

# Verificamos que sí encontró al menos una imagen
NUM_IMGS=${#IMGS[@]}
if [ $NUM_IMGS -eq 0 ]; then
  notify-send "Error de Fondos" "La carpeta está vacía o no tiene formatos válidos."
  exit 1
fi

# Lógica para seleccionar la imagen de forma secuencial
NEXT_INDEX=0

# Si existe el archivo de estado, lee cuál fue el último fondo
if [ -f "$STATE_FILE" ]; then
  LAST_IMG=$(cat "$STATE_FILE")

  # Busca en qué posición de la lista está el último fondo
  for i in "${!IMGS[@]}"; do
    if [[ "${IMGS[$i]}" == "$LAST_IMG" ]]; then
      # Calcula el índice del siguiente fondo
      # El módulo (%) hace que si llega al final, vuelva al inicio (0)
      NEXT_INDEX=$(((i + 1) % NUM_IMGS))
      break
    fi
  done
fi

# Selecciona la nueva imagen y la guardamos en el archivo de estado
IMG="${IMGS[$NEXT_INDEX]}"
echo "$IMG" >"$STATE_FILE"

# Aplica el fondo usando awww
awww img "$IMG" \
  --transition-fps 60 \
  --transition-type random \
  --transition-duration 2

# Ejecuta matugen y elige el color principal automáticamente (índice 0)
matugen image "$IMG" --source-color-index 0
