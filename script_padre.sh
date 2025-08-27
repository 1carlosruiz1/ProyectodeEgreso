#!/bin/bash

# URL del repositorio
REPO_URL="https://github.com/1carlosruiz1/ProyectodeEgreso.git"

# Directorios
PROY_DIR="/usr/local/bin/proyecto-egreso"
DEST_DIR="/bin/scriptsInstalacion"

# 1. Crear carpetas necesarias
mkdir -p "$PROY_DIR"
mkdir -p "$DEST_DIR"

# 2. Borrar cualquier clon previo
rm -rf "$PROY_DIR"

# 3. Clonar el repo completo
git clone "$REPO_URL" "$PROY_DIR" || { echo "Error al clonar el repositorio"; exit 1; }

# 4. Borrar scripts viejos en DEST_DIR antes de copiar los nuevos
rm -f "$DEST_DIR"/*.sh

# 5. Copiar los scripts desde la carpeta "scripts" del repo hacia DEST_DIR
if [ -d "$PROY_DIR/scripts" ]; then
    cp "$PROY_DIR/scripts/"*.sh "$DEST_DIR"/
else
    echo "No se encontró la carpeta scripts en el repositorio"
    exit 1
fi

# 6. Dar permisos de ejecución a todos los .sh en DEST_DIR
chmod +x "$DEST_DIR"/*.sh

# 7. Ejecutar todos los scripts que se copiaron
for script in "$DEST_DIR"/*.sh; do
    echo "Ejecutando $(basename "$script")..."
    "$script" && echo "$(basename "$script") ejecutado correctamente." || echo "Error al ejecutar $(basename "$script")."
done

mkdir -p /backup/logs/registro.log

# 8. Copiar este mismo instalador a la carpeta destino para poder reutilizarlo
SCRIPT_NAME=$(basename "$0")
cp "$0" "$DEST_DIR/$SCRIPT_NAME"
chmod +x "$DEST_DIR/$SCRIPT_NAME"

# 9. Borrar el repositorio clonado para no dejar basura
rm -rf "$PROY_DIR"

echo "Instalación finalizada. Todos los scripts están en $DEST_DIR"
