#!/bin/bash
INSTALL_DIR="/etc/profile.d/"
SCRIPT_NAME="log_access.sh"

echo "Creando script de registro de accesos..."

cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/bin/bash
LOG_DIR="/var/log/login_access"
mkdir -p "$LOG_DIR"
chmod 700 "$LOG_DIR"
LOG_FILE="$LOG_DIR/registro.log"
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"
REMOTE="${PAM_RHOST:-local}"
USER="$PAM_USER"
echo "Usuario $USER accedió desde $REMOTE el $(date)" >> "$LOG_FILE"

EOF
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
session optional pam_exec.so /usr/local/bin/log_access.sh
echo "Script instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
