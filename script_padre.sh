#!/bin/bash

REPO_URL="https://github.com/1carlosruiz1/ProyectodeEgreso.git"
PROY_DIR="/usr/local/bin/proyecto-egreso"
SCRIPTS_DIR="$PROY_DIR/scripts"

# Borrar cualquier clon previo
rm -rf "$PROY_DIR"

# Clonar el repo completo
git clone "$REPO_URL" "$PROY_DIR"

# Asegurarse de que exista la carpeta scripts
mkdir -p "$SCRIPTS_DIR"

# Entrar a la carpeta scripts
cd "$SCRIPTS_DIR" || { echo "No se encontró la carpeta scripts"; exit 1; }

# Dar permisos a todos los .sh
chmod +x *.sh

# Ejecutar todos los scripts
for script in *.sh; do
    echo "Ejecutando $script..."
    ./"$script" && echo "$script ejecutado correctamente." || echo "Error al ejecutar $script."
done
