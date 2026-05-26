function pkgtui -d "TUI para instalar/desinstalar/actualizar paquetes con paru, fzf y topgrade"
    clear

    # MENÚ PRINCIPAL (Blanco)
    set accion (echo -e "1. Instalar paquetes\n2. Desinstalar paquetes\n3. Actualizar todo el sistema\n4. Salir" | fzf --prompt=" > " --color=pointer:white,marker:white --height=40% --layout=reverse --border --margin=5%)

    switch "$accion"
        case "1. Instalar paquetes"
            clear
            # SUBMENÚ DE ORIGEN (Blanco)
            set origen (echo -e "1. Repositorios Oficiales\n2. AUR (Arch User Repository)" | fzf --prompt=" > " --color=pointer:white,marker:white --height=30% --layout=reverse --border --margin=5%)

            if test -z "$origen"
                clear
                echo "Operación cancelada."
                return 0
            end

            clear
            switch "$origen"
                case "1. Repositorios Oficiales"
                    read -P "Búsqueda en Repos Oficiales (en blanco para listar todos): " busqueda
                    if test -z "$busqueda"
                        # INSTALAR OFICIALES (Verde)
                        set paquetes (pacman -Slq | fzf --multi --preview 'pacman -Si {}' --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
                    else
                        set paquetes (pacman -Ssq $busqueda | fzf --multi --preview 'pacman -Si {}' --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
                    end

                case "2. AUR (Arch User Repository)"
                    read -P "Término a buscar en AUR (obligatorio): " busqueda
                    if test -z "$busqueda"
                        clear
                        echo "Error: Para buscar en AUR es necesario escribir un término."
                        return 0
                    else
                        # INSTALAR AUR (Verde)
                        set paquetes (paru -Ssq --aur $busqueda | fzf --multi --preview 'paru -Si {}' --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
                    end
            end

            if test -n "$paquetes"
                clear
                echo -e "Instalando los siguientes paquetes:"
                for p in $paquetes
                    echo " -> $p"
                end
                echo ""
                paru -S $paquetes
            else
                echo "Operación cancelada."
            end

        case "2. Desinstalar paquetes"
            clear
            # DESINSTALAR (Rojo)
            set paquetes (paru -Qq | fzf --multi --preview 'paru -Qi {}' --prompt=" > " --color=pointer:red,marker:red --height=90% --layout=reverse --preview-window=right:60%)

            if test -n "$paquetes"
                clear
                echo -e "Desinstalando los siguientes paquetes:"
                for p in $paquetes
                    echo " -> $p"
                end
                echo ""
                paru -Rns $paquetes
            else
                echo "Operación cancelada."
            end

        case "3. Actualizar todo el sistema"
            clear
            echo -e "Iniciando actualización global con Topgrade..."
            topgrade

        case '*'
            clear
            echo "Saliendo..."
            return 0
    end
end
