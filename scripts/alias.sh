#!/bin/bash
INSTALL_DIR="/etc/profile.d/"
SCRIPT_NAME="aliases.sh"
LOG_DIR="/backup/logs"
LOG_FILE="$LOG_DIR/registro.log"
echo "Creando script de alias y variables de entorno para todos los usuarios..."
cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/bin/bash
# Alias y variables persistentes para todos los usuarios
alias menu='sudo /usr/local/bin/scriptsProyecto/menu.sh'
alias verlog='less /backup/logs/registro.log'
export LOG_PATH="/backup/logs/registro.log"
EOF
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
sudo mkdir -p "$LOG_DIR"
sudo touch "$LOG_FILE"
sudo truncate -s 0 "$LOG_FILE"
sudo chmod 644 "$LOG_FILE"
sudo chmod 755 "$LOG_DIR"
sudo chcon -t var_log_t "$LOG_FILE"
echo "Script de alias instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
echo "Alias 'menu' y 'verlog' disponibles para todos los usuarios al iniciar sesión."
