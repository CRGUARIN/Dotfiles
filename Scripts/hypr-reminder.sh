#!/usr/bin/env bash

PID_FILE="/tmp/hypr_reminders.pids"
touch "$PID_FILE"

# --- CONFIGURACIÓN ESTÉTICA DE FUZZEL ---
BG_COLOR="0a0a0acc"     # Fondo Gris Oscuro
TEXT_COLOR="cdd6f4ff"   # Letras del Prompt claras
INPUT_COLOR="f5e0dcff"  # Letras que tú escribes claras
MATCH_COLOR="f38ba8ff"  # Color de coincidencia
BORDER_COLOR="333333ff" # Borde de la ventana (Azul)

# Función base para lanzar Fuzzel de forma limpia
lanzar_fuzzel() {
  local prompt_text="$1"
  echo "" | fuzzel --dmenu \
    --background=$BG_COLOR \
    --text-color=$TEXT_COLOR \
    --input-color=$INPUT_COLOR \
    --match-color=$MATCH_COLOR \
    --border-color=$BORDER_COLOR \
    --border-width=2 \
    --border-radius=8 \
    --horizontal-pad=15 \
    --vertical-pad=10 \
    --width=30 \
    --lines=0 \
    --prompt="$prompt_text"
}

clean_pids() {
  sed -i '/^$/d' "$PID_FILE"
  while read -r pid; do
    if ! kill -0 "$pid" 2>/dev/null; then
      sed -i "/^$pid$/d" "$PID_FILE"
    fi
  done <"$PID_FILE"
}

case "$1" in
"clear")
  while read -r pid; do
    kill "$pid" 2>/dev/null
  done <"$PID_FILE"
  >"$PID_FILE"
  swaync-client -t -t 2>/dev/null
  notify-send "Recordatorios" "Todos los recordatorios han sido cancelados." -i dialog-information -a "SwayNC"
  ;;
"show")
  clean_pids
  count=$(wc -l <"$PID_FILE")
  notify-send "Recordatorios" "Tienes $count recordatorio(s) activo(s)." -i dialog-information -a "SwayNC"
  ;;
*)
  MINUTES=$1
  MESSAGE=$2

  # Si se ejecuta mediante el atajo (sin argumentos)
  if [[ -z "$MINUTES" || -z "$MESSAGE" ]]; then
    if ! command -v fuzzel &>/dev/null; then
      notify-send "Error" "Fuzzel no está instalado." -i dialog-error -a "SwayNC"
      exit 1
    fi

    # Paso 1: Pedir solo los Minutos
    MINUTES=$(lanzar_fuzzel "Minutos:  ")
    [[ -z "$MINUTES" ]] && exit 0 # Si cancela con ESC, salir

    # Paso 2: Pedir solo el Mensaje
    MESSAGE=$(lanzar_fuzzel "Mensaje:  ")
    [[ -z "$MESSAGE" ]] && exit 0 # Si cancela con ESC, salir
  fi

  # Validar que los minutos sean un número entero
  if ! [[ "$MINUTES" =~ ^[0-9]+$ ]]; then
    notify-send "Error" "Los minutos deben ser un número entero." -i dialog-error -a "SwayNC"
    exit 1
  fi

  # Cuenta regresiva en segundo plano
  (
    sleep $((MINUTES * 60))
    notify-send "⏰ ¡Tiempo Cumplido!" "$MESSAGE" -u critical -i appointment-soon -a "SwayNC"
  ) &

  echo $! >>"$PID_FILE"
  notify-send "Recordatorio Creado" "En $MINUTES minutos: $MESSAGE" -i appointment-new -a "SwayNC"
  ;;
esac
