#!/bin/bash
INSTALL_DIR="/etc/profile.d/"
SCRIPT_NAME="aliases.sh"
LOG_DIR="/backup/logs"
LOG_FILE="$LOG_DIR/registro.log"
cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/bin/bash
alias menu='sudo /usr/local/bin/scriptsProyecto/menu.sh'
alias verlog='less /backup/logs/registro.log'
export LOG_PATH="/backup/logs/registro.log"
EOF
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"
truncate -s 0 "$LOG_FILE"  # vacía el archivo al inicio
chmod 755 "$LOG_DIR"      # todos pueden entrar al directorio
chmod 644 "$LOG_FILE"     # todos pueden leer el log, solo root puede escribir
# SELinux)
chcon -t var_log_t "$LOG_DIR"
chcon -t var_log_t "$LOG_FILE"
echo "Alias 'menu' y 'verlog' disponibles para todos los usuarios al iniciar sesión."
