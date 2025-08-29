#!/bin/bash
INSTALL_DIR="/etc/profile.d/"
SCRIPT_NAME="log_access.sh"

echo "Creando script de registro de accesos..."

cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/bin/bash
# /etc/profile.d/log_access.sh
LOG_DIR="/backup/logs"
mkdir -p "$LOG_DIR"
chmod 700 "$LOG_DIR"
LOG_FILE="$LOG_DIR/registro.log"
REMOTE="${SSH_CLIENT:-local}"
echo "Usuario $(whoami) accedió desde $REMOTE el $(date)" >> "$LOG_FILE"
EOF
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "Script instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
