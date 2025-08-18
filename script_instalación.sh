#!/bin/bash

# Configuración
REPO_URL="https://github.com/1carlosruiz1/ProyectodeEgreso.git"
CLONE_DIR="/tmp/proyecto-egreso"

# 1. Clonar el repositorio (o actualizar si ya existe)
if [ -d "$CLONE_DIR" ]; then
    echo "Actualizando repositorio..."
    cd "$CLONE_DIR" && git pull
else
    echo "Clonando repositorio..."
    git clone "$REPO_URL" "$CLONE_DIR"
fi

# 2. Ir a la carpeta Scripts
cd "$CLONE_DIR/Scripts" || { echo "No se encontró la carpeta Scripts"; exit 1; }

# 3. Dar permisos de ejecución a todos los archivos
chmod +x *

# 4. Ejecutar todos los archivos
for script in *; do
    if [ -f "$script" ]; then
        echo "Ejecutando $script..."
        ./"$script"
        if [ $? -eq 0 ]; then
            echo "$script instalado correctamente."
        else
            echo "Error al instalar $script."
        fi
    fi
done

echo "Todos los scripts fueron procesados."
