#!/bin/bash

REPO_URL="https://github.com/1carlosruiz1/ProyectodeEgreso.git"
PROY_DIR="/home/Gerente/Descargas"
SCRIPTS_DIR="$PROY_DIR/scripts"
mkdir /home/Gerente/Descargas/scripts

# Borrar cualquier clon previo
rm -rf "$PROY_DIR"

# Clonar el repo completo
git clone "$REPO_URL" "$PROY_DIR"

# Entrar a la carpeta scripts
cd "$SCRIPTS_DIR" || { echo "No se encontró la carpeta scripts"; exit 1; }

# Dar permisos a todos los .sh
chmod +x *.sh

# Ejecutar todos los scripts
for script in *.sh; do
    echo "Ejecutando $script..."
    ./"$script" && echo "$script ejecutado correctamente." || echo "Error al ejecutar $script."
done
