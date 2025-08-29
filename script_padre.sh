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
cp "$0" "$DEST_DIR/$SCRIPT_NAME"
chmod +x "$DEST_DIR/$SCRIPT_NAME"

# 9. Borrar el repositorio clonado
rm -rf "$PROY_DIR"


#10 ccontroles de acceso:

mkdir -p /backup/logs

LOG_FILE="/backup/logs/registro.log"
exec >> "$LOG_FILE" 2>&1
echo ""
echo "=== [$0] Inicio de ejecución: $(date) ==="

# Alias para Gerente
echo "alias menu='sudo /usr/local/bin/scriptsProyecto/menu.sh'" >> /home/Gerente/.bashrc
chown Gerente:Gerente /home/Gerente/.bashrc

# Crear wrapper "log" para todos los usuarios
cat << 'EOF_WRAPPER' > /usr/local/bin/log
#!/bin/bash
sudo /usr/local/bin/scriptsProyecto/menu.sh 7
EOF_WRAPPER
chmod +x /usr/local/bin/log

# Ajustar permisos de menu.sh
chown root:root /usr/local/bin/scriptsProyecto/menu.sh
chmod 700 /usr/local/bin/scriptsProyecto/menu.sh

# Permitir a todos ejecutar menu.sh 7 sin contraseña
echo "ALL ALL=(root) NOPASSWD: /usr/local/bin/scriptsProyecto/menu.sh 7" > /etc/sudoers.d/menu7
chmod 440 /etc/sudoers.d/menu7

echo "Configuración completada."
echo "Gerente puede usar 'menu'. Todos los usuarios pueden usar 'log' para punto 7."

echo "Instalación finalizada. Todos los scripts están en /usr/local/bin/scriptsProyecto/"
