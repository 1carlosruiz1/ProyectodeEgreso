#!/bin/bash

# Configuración
REPO_URL="https://github.com/1carlosruiz1/ProyectodeEgreso.git"
SCRIPTS_DIR="/tmp/proyecto-egreso/scripts"

# Clonar
rm -rf "$(dirname "$SCRIPTS_DIR")"
git clone "$REPO_URL" "$(dirname "$SCRIPTS_DIR")"

cd "$SCRIPTS_DIR" || { echo "No se encontró la carpeta scripts"; exit 1; }

# Dar permisos a todos los .sh
chmod +x *.sh

# Ejecutar todos los scripts
for script in *.sh; do
    echo "Ejecutando $script..."
    ./"$script" && echo "$script ejecutado correctamente." || echo "Error al ejecutar $script."
done
