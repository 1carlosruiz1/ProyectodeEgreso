#!/bin/bash
INSTALL_DIR="/etc/profile.d/"
SCRIPT_NAME="aliases.sh"
echo "Creando script de alias y variables de entorno para todos los usuarios..."
cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/bin/bash
# Alias y variables persistentes para todos los usuarios
# Alias para ejecutar menú (funciona con sudo)
alias menu='sudo /usr/local/bin/scriptsProyecto/menu.sh'
# Alias para ver el registro de accesos
alias verlog='less /backup/logs/registro.log'
# Variable de entorno opcional para la ruta del log
export LOG_PATH="/backup/logs/registro.log"
EOF
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
sudo truncate -s 0 /backup/logs/registro.log
sudo chmod 644 /backup/logs/registro.log
sudo chmod 644 /backup/logs
echo "Script de alias instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
echo "Alias 'menu' y 'verlog' disponibles para todos los usuarios al iniciar sesión."
