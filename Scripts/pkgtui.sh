#!/bin/bash
# TUI interactiva con pacman, yay, fzf y topgrade (Sincronización automatizada)

# --- SISTEMA DE CONFIGURACIÓN Y RUTAS ---
CONFIG_DIR="$HOME/Scripts/Configuraciones/"
CONFIG_FILE="$CONFIG_DIR/pkgtui.conf"

# --- VERIFICACIÓN DE DEPENDENCIAS ---
dependencias=("pacman" "yay" "fzf" "topgrade")
for cmd in "${dependencias[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: Falta la dependencia '$cmd'. Instálala para continuar."
    exit 1
  fi
done

# Inicialización de configuración
mkdir -p "$CONFIG_DIR"
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  DESTINO="$HOME/Documentos/Dotfiles/pkgs/"
  echo "DESTINO=\"$DESTINO\"" >"$CONFIG_FILE"
fi

# --- FUNCIÓN DE EXPORTACIÓN ---
exportar_listas() {
  echo -e "\n[+] Sincronizando listas de paquetes en: $DESTINO"
  mkdir -p "$DESTINO"
  pacman -Qqn >"$DESTINO/pkglist.txt"
  yay -Qqm >"$DESTINO/aurlist.txt"
  echo -e "[✔] ¡Listas exportadas exitosamente!"
  sleep 1.5
}

# --- BUCLE DEL MENÚ PRINCIPAL ---
while true; do
  clear
  accion=$(echo -e "1. Instalar paquetes\n2. Desinstalar paquetes\n3. Actualizar el sistema\n4. Limpieza del sistema\n5. Configurar ruta de exportación\n6. Exportar listas manualmente\n7. Salir" | fzf --prompt=" Menú Principal > " --info=hidden --height=14 --layout=reverse --border=rounded --margin=5% --color=pointer:white,marker:white \
    --bind '1:become(echo "1")' \
    --bind '2:become(echo "2")' \
    --bind '3:become(echo "3")' \
    --bind '4:become(echo "4")' \
    --bind '5:become(echo "5")' \
    --bind '6:become(echo "6")' \
    --bind '7:become(echo "7")' \
    --bind 'esc:become(echo "7")')

  # CORRECCIÓN: Extraer solo el primer número en caso de que se haya presionado Enter
  accion="${accion:0:1}"

  case "$accion" in
  "1")
    clear
    origen=$(echo -e "1. Repositorios Oficiales\n2. AUR (Arch User Repository)" | fzf --prompt=" Origen > " --info=hidden --height=10 --layout=reverse --border=rounded --margin=5% --color=pointer:white,marker:white \
      --bind '1:become(echo "1")' \
      --bind '2:become(echo "2")' \
      --bind 'esc:become(echo "")')

    origen="${origen:0:1}"
    [[ -z "$origen" ]] && continue

    clear
    if [[ "$origen" == "1" ]]; then
      readarray -t paquetes < <(pacman -Slq | grep -vxFf <(pacman -Qq) | fzf --multi \
        --preview 'pacman -Si {}' \
        --border=rounded \
        --border-label=' alt-p (ocultar) | alt-d/u (scroll) | tab (seleccionar) ' \
        --border-label-pos=bottom \
        --bind 'alt-p:toggle-preview' \
        --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
        --prompt=" Instalar Oficial > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
    else
      readarray -t paquetes < <(yay -Slqa | grep -vxFf <(pacman -Qq) | fzf --multi \
        --preview 'yay -Siia {}' \
        --border=rounded \
        --border-label=' alt-p (ocultar) | alt-b (PKGBUILD) | alt-i (Info) | alt-d/u (scroll) | tab (seleccionar) ' \
        --border-label-pos=bottom \
        --bind 'alt-p:toggle-preview' \
        --bind 'alt-b:change-preview:yay -Gpa {} | tail -n +5' \
        --bind 'alt-i:change-preview:yay -Siia {}' \
        --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
        --prompt=" Instalar AUR > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
    fi

    if [[ ${#paquetes[@]} -gt 0 ]]; then
      clear
      echo -e "Instalando los siguientes paquetes:\n"
      printf " -> %s\n" "${paquetes[@]}"
      echo ""

      yay -S "${paquetes[@]}"

      # GATILLO: Si se instaló sin errores, auto-exportar
      if [[ $? -eq 0 ]]; then exportar_listas; fi
    fi
    ;;

  "2")
    clear
    readarray -t paquetes < <(yay -Qq | fzf --multi \
      --preview 'yay -Qi {}' \
      --border=rounded \
      --border-label=' alt-p (ocultar) | alt-d/u (scroll) | tab (seleccionar) ' \
      --border-label-pos=bottom \
      --bind 'alt-p:toggle-preview' \
      --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
      --prompt=" Desinstalar > " --color=pointer:red,marker:red --height=90% --layout=reverse --preview-window=right:60%)

    if [[ ${#paquetes[@]} -gt 0 ]]; then
      clear
      echo -e "Desinstalando los siguientes paquetes:\n"
      printf " -> %s\n" "${paquetes[@]}"
      echo ""
      yay -Rns "${paquetes[@]}"

      # GATILLO: Si se desinstaló sin errores, auto-exportar
      if [[ $? -eq 0 ]]; then exportar_listas; fi
    fi
    ;;

  "3")
    clear
    echo -e "Iniciando actualización global...\n"
    topgrade
    echo -e "\nPresiona Enter para volver al menú..."
    read -r
    ;;

  "4")
    clear
    limpieza=$(echo -e "1. Limpiar caché de paquetes descargados\n2. Eliminar paquetes huérfanos" | fzf --prompt=" Limpieza > " --info=hidden --height=10 --layout=reverse --border=rounded --margin=5% --color=pointer:yellow,marker:yellow \
      --bind '1:become(echo "1")' \
      --bind '2:become(echo "2")' \
      --bind 'esc:become(echo "")')

    limpieza="${limpieza:0:1}"

    clear
    if [[ "$limpieza" == "1" ]]; then
      echo -e "Limpiando descargas incompletas o corruptas...\n"

      # CORRECCIÓN: Usar 'find' con sudo para evitar problemas de expansión de Bash
      sudo find /var/cache/pacman/pkg/ -type f -name "download-*" -delete

      echo -e "Limpiando la caché de paquetes...\n"
      yay -Sc
    elif [[ "$limpieza" == "2" ]]; then
      echo -e "Buscando paquetes huérfanos...\n"
      readarray -t huerfanos < <(pacman -Qdtq)

      if [[ ${#huerfanos[@]} -gt 0 ]]; then
        yay -Rns "${huerfanos[@]}"
        if [[ $? -eq 0 ]]; then exportar_listas; fi
      else
        echo "El sistema está limpio. No hay paquetes huérfanos."
      fi
    fi
    [[ -n "$limpieza" ]] && {
      echo -e "\nPresiona Enter para volver al menú..."
      read -r
    }
    ;;

  "5")
    clear
    echo -e "Ruta actual de exportación:\n$DESTINO\n"
    read -e -r -p "Introduce la nueva ruta (o presiona Enter para cancelar): " nueva_ruta
    if [[ -n "$nueva_ruta" ]]; then
      nueva_ruta="${nueva_ruta/#\~/$HOME}"
      echo "DESTINO=\"$nueva_ruta\"" >"$CONFIG_FILE"
      DESTINO="$nueva_ruta"
      clear
      echo -e "Ruta actualizada exitosamente.\n"
      exportar_listas
    fi
    ;;

  "6")
    clear
    exportar_listas
    ;;

  "7" | "")
    clear
    echo "¡Hasta luego!"
    exit 0
    ;;
  esac
done
