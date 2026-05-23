#!/bin/bash

# 1. Define la ruta exacta de tu carpeta de fondos
# (Asegúrate de que esta carpeta exista y tenga tus imágenes)
DIR="$HOME/Imágenes/Fondos/"

# 2. Verificamos que la carpeta exista para evitar errores
if [ ! -d "$DIR" ]; then
  notify-send "Error de Fondos" "No se encontró la carpeta: $DIR"
  exit 1
fi

# 3. Busca todas las imágenes en la carpeta y selecciona una al azar
IMG=$(find "$DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf -n 1)

# 4. Verificamos que sí encontró una imagen
if [ -z "$IMG" ]; then
  notify-send "Error de Fondos" "La carpeta está vacía o no tiene formatos válidos."
  exit 1
fi

# 5. Aplica el fondo usando awww con una transición aleatoria y fluida
awww img "$IMG" \
  --transition-fps 60 \
  --transition-type random \
  --transition-duration 2
