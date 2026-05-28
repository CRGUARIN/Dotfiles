# Variables de entorno globales
set -gx EDITOR neovide --no-fork
set -gx VISUAL neovide --no-fork

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Inicializaciones y cosmética
