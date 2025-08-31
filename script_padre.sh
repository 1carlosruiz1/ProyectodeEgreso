#!/bin/bash

# URL del repositorio y branch
REPO_URL="https://github.com/1carlosruiz1/ProyectodeEgreso.git"
BRANCH="master"
# Directorios
PROY_DIR="/usr/local/bin/proyecto-egreso"
DEST_DIR="/usr/local/bin/scriptsInstalacion"
# 1. Crear carpetas necesarias
mkdir -p "$PROY_DIR"
mkdir -p "$DEST_DIR"
# 2. Borrar cualquier clon previo
rm -rf "$PROY_DIR" /usr/local/bin/scriptsProyecto usr/local/bin/scriptsInstalacion
# 3. Clonar la branch master
git clone --branch "$BRANCH" "$REPO_URL" "$PROY_DIR" || { echo "Error al clonar el repositorio"; exit 1; }
# 4. Borrar scripts viejos en DEST_DIR
rm -f "$DEST_DIR"/*.sh

# 5. Copiar los scripts de /scripts/ a DEST_DIR
if [ -d "$PROY_DIR/scripts" ]; then
    cp "$PROY_DIR/scripts/"*.sh "$DEST_DIR"/
else
    echo "No se encontró la carpeta scripts en el repositorio"
    exit 1
fi
# 6. Dar permisos de ejecución
chmod +x "$DEST_DIR"/*.sh
# 7. Ejecutar todos los scripts copiados
for script in "$DEST_DIR"/*.sh; do
    "$script" && echo "$(basename "$script") ejecutado correctamente." || echo "Error al ejecutar $(basename "$script")."
done
# 8. Copiar este instalador a DEST_DIR
SCRIPT_NAME=$(basename "$0")
cp "$0" "/usr/local/bin/$SCRIPT_NAME"
chmod +x "/usr/local/bin/$SCRIPT_NAME"
# 9. Borrar el repositorio clonado
rm -rf "$PROY_DIR"
