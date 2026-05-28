function pkgtui -d "TUI interactiva con pacman, yay, fzf y topgrade"
    clear

    # MENÚ PRINCIPAL (Caja compacta segura, input oculto compatible, selección instantánea)
    set accion (echo -e "1. Instalar paquetes\n2. Desinstalar paquetes\n3. Actualizar el sistema\n4. Salir" | fzf --prompt="" --info=hidden --height=12 --layout=reverse --border=rounded --margin=5% --color=pointer:white,marker:white \
        --bind '1:become(echo "1. Instalar paquetes")' \
        --bind '2:become(echo "2. Desinstalar paquetes")' \
        --bind '3:become(echo "3. Actualizar el sistema")' \
        --bind '4:become(echo "4. Salir")')

    switch "$accion"
        case "1. Instalar paquetes"
            clear
            # SUBMENÚ DE ORIGEN (Caja compacta segura, input oculto compatible, selección instantánea)
            set origen (echo -e "1. Repositorios Oficiales\n2. AUR (Arch User Repository)" | fzf --prompt="" --info=hidden --height=10 --layout=reverse --border=rounded --margin=5% --color=pointer:white,marker:white \
                --bind '1:become(echo "1. Repositorios Oficiales")' \
                --bind '2:become(echo "2. AUR (Arch User Repository)")')

            if test -z "$origen"
                clear
                echo "Operación cancelada."
                return 0
            end

            clear
            switch "$origen"
                case "1. Repositorios Oficiales"
                    set paquetes (pacman -Slq | grep -vxFf (pacman -Qq | psub) | fzf --multi \
                        --preview 'pacman -Si {}' \
                        --border=rounded \
                        --border-label=' alt-p (ocultar) | alt-d/u (scroll) ' \
                        --border-label-pos=bottom \
                        --bind 'alt-p:toggle-preview' \
                        --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
                        --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)

                case "2. AUR (Arch User Repository)"
                    set paquetes (yay -Slqa | grep -vxFf (pacman -Qq | psub) | fzf --multi \
                        --preview 'yay -Siia {}' \
                        --border=rounded \
                        --border-label=' alt-p (ocultar) | alt-b (PKGBUILD) | alt-i (Info) | alt-d/u (scroll) ' \
                        --border-label-pos=bottom \
                        --bind 'alt-p:toggle-preview' \
                        --bind 'alt-b:change-preview:yay -Gpa {} | tail -n +5' \
                        --bind 'alt-i:change-preview:yay -Siia {}' \
                        --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
                        --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
            end

            if test -n "$paquetes"
                clear
                echo -e "Instalando los siguientes paquetes:"
                for p in $paquetes
                    echo " -> $p"
                end
                echo ""

                # Si elegimos AUR, Fish le inyecta "aur/" antes de pasárselo a yay
                if test "$origen" = "2. AUR (Arch User Repository)"
                    set paquetes aur/$paquetes
                end

                yay -S $paquetes
            else
                echo "Operación cancelada."
            end

        case "2. Desinstalar paquetes"
            clear
            set paquetes (yay -Qq | fzf --multi \
                --preview 'yay -Qi {}' \
                --border=rounded \
                --border-label=' alt-p (ocultar) | alt-d/u (scroll) ' \
                --border-label-pos=bottom \
                --bind 'alt-p:toggle-preview' \
                --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
                --prompt=" > " --color=pointer:red,marker:red --height=90% --layout=reverse --preview-window=right:60%)

            if test -n "$paquetes"
                clear
                echo -e "Desinstalando los siguientes paquetes:"
                for p in $paquetes
                    echo " -> $p"
                end
                echo ""
                yay -Rns $paquetes
            else
                echo "Operación cancelada."
            end

        case "3. Actualizar el sistema"
            clear
            echo -e "Iniciando actualización global..."
            topgrade

        case '*'
            clear
            echo "Saliendo..."
            return 0
    end
end
