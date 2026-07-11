#!/bin/bash

# Definimos los perfiles con los nombres amigables que quieres ver
opciones="Rendimiento\nBalanceado\nAhorro de energía"

# Lanzamos fuzzel y guardamos la selección
seleccion=$(echo -e "$opciones" | fuzzel --dmenu --prompt "" --lines 3)

# Validamos la selección y aplicamos el perfil real correspondiente
case "$seleccion" in
"Rendimiento")
  powerprofilesctl set performance
  notify-send -u low -i battery "Perfil de energía" "Cambiado a: Rendimiento"
  ;;
"Balanceado")
  powerprofilesctl set balanced
  notify-send -u low -i battery "Perfil de energía" "Cambiado a: Balanceado"
  ;;
"Ahorro de energía")
  powerprofilesctl set power-saver
  notify-send -u low -i battery "Perfil de energía" "Cambiado a: Ahorro de energía"
  ;;
*)
  # Si cierras fuzzel sin seleccionar nada, el script termina sin hacer nada
  exit 0
  ;;
esac
