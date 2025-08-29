#!/bin/bash
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="gestionBackups.sh"

echo "Creando script de instalación..."

cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/bin/bash
# /etc/profile.d/log_access.sh

LOG_FILE="/backup/logs/registro.log"
echo "Usuario $(whoami) accedió desde $SSH_CLIENT el $(date)" >> "$LOG_FILE"

EOF

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "Script instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
