#!/bin/bash
INSTALL_DIR="/usr/local/bin/scriptsProyecto/"
SCRIPT_NAME="configAccesos.sh.sh"

echo "Creando script de instalación..."
mkdir -p "$INSTALL_DIR"
cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/bin/bash

LOG_DIR="/backup/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/registro.log"
exec >> "$LOG_FILE" 2>&1
echo ""
echo "=== [$0] Inicio de ejecución: $(date) ==="

MENU_PATH="/ruta/completa/a/menu.sh"

#Alias para Gerente
echo "alias menu='sudo $MENU_PATH'" >> /home/Gerente/.bashrc
chown Gerente:Gerente /home/Gerente/.bashrc

#Crear wrapper log para todos los usuarios
cat << EOF > /usr/local/bin/log
#!/bin/bash
sudo $MENU_PATH 7
EOF
chmod +x /usr/local/bin/log

#Ajustar permisos de menu.sh
chown root:root "$MENU_PATH"
chmod 700 "$MENU_PATH"

#Configurar sudoers para que todos puedan ejecutar menu.sh 7 sin contraseña
SUDOERS_FILE="/etc/sudoers.d/menu7"
echo "ALL ALL=(root) NOPASSWD: $MENU_PATH 7" > "$SUDOERS_FILE"
chmod 440 "$SUDOERS_FILE"

echo "Configuración completada."
echo "Gerente puede usar 'menu'. Todos los usuarios pueden usar 'log' para punto 7."

EOF

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "Script instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
