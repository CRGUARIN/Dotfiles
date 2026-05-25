function pkgtui -d "TUI para instalar/desinstalar paquetes con paru y fzf"
    clear

    # 1. MENÚ PRINCIPAL (BLANCO)
    set accion (echo -e "1. Instalar paquetes\n2. Desinstalar paquetes\n3. Salir" | fzf --prompt=" > " --color=pointer:white,marker:white --height=40% --layout=reverse --border --margin=5%)

    switch "$accion"
        case "1. Instalar paquetes"
            clear
            # 2. SUBMENÚ DE ORIGEN (BLANCO)
            set origen (echo -e "1. Repositorios Oficiales\n2. AUR (Arch User Repository)" | fzf --prompt="¿Dónde quieres buscar? > " --color=pointer:white,marker:white --height=30% --layout=reverse --border --margin=5%)

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
                        # 3. INSTALAR OFICIALES (VERDE)
                        set paquetes (pacman -Slq | fzf --multi --preview 'pacman -Si {}' --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
                    else
                        # 3. INSTALAR OFICIALES CON BÚSQUEDA (VERDE)
                        set paquetes (pacman -Ssq $busqueda | fzf --multi --preview 'pacman -Si {}' --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
                    end

                case "2. AUR (Arch User Repository)"
                    read -P "Término a buscar en AUR (obligatorio): " busqueda
                    if test -z "$busqueda"
                        clear
                        echo "Error: Para buscar en AUR es necesario escribir un término."
                        return 0
                    else
                        # 4. INSTALAR AUR (VERDE)
                        set paquetes (paru -Ssq --aur $busqueda | fzf --multi --preview 'paru -Si {}' --prompt=" > " --color=pointer:green,marker:green --height=90% --layout=reverse --preview-window=right:60%)
                    end
            end

            if test -n "$paquetes"
                clear
                echo -e "\nInstalando los siguientes paquetes:"
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
            # 5. DESINSTALAR (ROJO)
            set paquetes (paru -Qq | fzf --multi --preview 'paru -Qi {}' --prompt=" > " --color=pointer:red,marker:red --height=90% --layout=reverse --preview-window=right:60%)

            if test -n "$paquetes"
                clear
                echo -e "\nDesinstalando los siguientes paquetes:"
                for p in $paquetes
                    echo " -> $p"
                end
                echo ""
                paru -Rns $paquetes
            else
                echo "Operación cancelada."
            end

        case '*'
            clear
            echo "Saliendo..."
            return 0
    end
end
