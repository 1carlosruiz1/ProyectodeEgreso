#!/bin/bash

# Configuración
REPO_URL="https://github.com/1carlosruiz1/ProyectodeEgreso.git"
CLONE_DIR="/tmp/proyecto-egreso"

# 1. Clonar o actualizar el repositorio
if [ -d "$CLONE_DIR" ]; then
    echo "Actualizando repositorio..."
    cd "$CLONE_DIR" && git pull
else
    echo "Clonando repositorio..."
    git clone "$REPO_URL" "$CLONE_DIR"
fi

# 2. Carpeta scripts
SCRIPTS_DIR="$CLONE_DIR/scripts"  # <-- cambia 'servicios' por 'scripts'
if [ -d "$SCRIPTS_DIR" ]; then
    cd "$SCRIPTS_DIR" || { echo "No se encontró la carpeta scripts"; exit 1; }
    
    # Dar permisos de ejecución a todos los .sh
    chmod +x *.sh
    
    # Ejecutar todos los scripts .sh
    for script in *.sh; do
        if [ -f "$script" ]; then
            echo "Ejecutando $script..."
            ./"$script"
            if [ $? -eq 0 ]; then
                echo "$script ejecutado correctamente."
            else
                echo "Error al ejecutar $script."
            fi
        fi
    done
else
    echo "Carpeta scripts no encontrada."
fi
