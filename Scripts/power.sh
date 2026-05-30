#!/bin/bash

# Las opciones con sus iconos que van a salir en el menú
opciones="󰐥 Apagar\n󰜉 Reiniciar\n󰤄 Suspender\n󰍃 Cerrar Sesión"

# Usamos Fuzzel en modo dmenu para que nos muestre esta lista
# Le pasamos parámetros para que sea más chiquito y parezca un menú emergente
eleccion=$(echo -e "$opciones" | fuzzel --dmenu --lines=4 --width=20 --prompt="⚡ ")

# Ejecutar la orden real en el sistema según lo que elijas
case "$eleccion" in
*"Apagar") systemctl poweroff ;;
*"Reiniciar") systemctl reboot ;;
*"Suspender") systemctl suspend ;;
*"Cerrar Sesión") hyprctl dispatch exit ;;
esac
