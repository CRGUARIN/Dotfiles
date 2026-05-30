#!/bin/bash
# TUI interactiva con pacman, yay, fzf y topgrade

clear

# MENÚ PRINCIPAL
accion=$(echo -e "1. Instalar paquetes\n2. Desinstalar paquetes\n3. Actualizar el sistema\n4. Salir" | fzf --prompt="" --info=hidden --height=12 --layout=reverse --border=rounded --margin=5% --color=pointer:white,marker:white \
  --bind '1:become(echo "1. Instalar paquetes")' \
  --bind '2:become(echo "2. Desinstalar paquetes")' \
  --bind '3:become(echo "3. Actualizar el sistema")' \
  --bind '4:become(echo "4. Salir")')

case "$accion" in
"1. Instalar paquetes")
  clear
  # SUBMENÚ DE ORIGEN
  origen=$(echo -e "1. Repositorios Oficiales\n2. AUR (Arch User Repository)" | fzf --prompt="" --info=hidden --height=10 --layout=reverse --border=rounded --margin=5% --color=pointer:white,marker:white \
    --bind '1:become(echo "1. Repositorios Oficiales")' \
    --bind '2:become(echo "2. AUR (Arch User Repository)")')

  if [ -z "$origen" ]; then
    clear
    echo "Operación cancelada."
    exit 0
  fi

  clear
  case "$origen" in
  "1. Repositorios Oficiales")
    # En Bash usamos <(comando) en lugar del psub de Fish
    paquetes=$(pacman -Slq | grep -vxFf <(pacman -Qq) | fzf --multi \
      --preview 'pacman -Si {}' \
      --border=rounded \
      --border-label=' alt-p (ocultar) | alt-d/u (scroll) ' \
      --border-label-pos=bottom \
      --bind 'alt-p:toggle-preview' \
      --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
      --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
    ;;
  "2. AUR (Arch User Repository)")
    paquetes=$(yay -Slqa | grep -vxFf <(pacman -Qq) | fzf --multi \
      --preview 'yay -Siia {}' \
      --border=rounded \
      --border-label=' alt-p (ocultar) | alt-b (PKGBUILD) | alt-i (Info) | alt-d/u (scroll) ' \
      --border-label-pos=bottom \
      --bind 'alt-p:toggle-preview' \
      --bind 'alt-b:change-preview:yay -Gpa {} | tail -n +5' \
      --bind 'alt-i:change-preview:yay -Siia {}' \
      --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
      --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
    ;;
  esac

  if [ -n "$paquetes" ]; then
    clear
    echo -e "Instalando los siguientes paquetes:"

    # Preparamos un arreglo para los paquetes a instalar
    paquetes_args=()

    for p in $paquetes; do
      echo " -> $p"
      if [ "$origen" = "2. AUR (Arch User Repository)" ]; then
        # Si elegimos AUR, Bash le inyecta "aur/" antes del nombre
        paquetes_args+=("aur/$p")
      else
        paquetes_args+=("$p")
      fi
    done

    echo ""
    yay -S "${paquetes_args[@]}"
  else
    echo "Operación cancelada."
  fi
  ;;

"2. Desinstalar paquetes")
  clear
  paquetes=$(yay -Qq | fzf --multi \
    --preview 'yay -Qi {}' \
    --border=rounded \
    --border-label=' alt-p (ocultar) | alt-d/u (scroll) ' \
    --border-label-pos=bottom \
    --bind 'alt-p:toggle-preview' \
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
    --prompt=" > " --color=pointer:red,marker:red --height=90% --layout=reverse --preview-window=right:60%)

  if [ -n "$paquetes" ]; then
    clear
    echo -e "Desinstalando los siguientes paquetes:"
    for p in $paquetes; do
      echo " -> $p"
    done
    echo ""
    yay -Rns $paquetes
  else
    echo "Operación cancelada."
  fi
  ;;

"3. Actualizar el sistema")
  clear
  echo -e "Iniciando actualización global..."
  topgrade
  ;;

*)
  clear
  echo "Saliendo..."
  exit 0
  ;;
esac
