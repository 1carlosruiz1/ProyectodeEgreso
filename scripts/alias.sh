
#!/bin/bash
INSTALL_DIR="/etc/profile.d/"
SCRIPT_NAME="log_access.sh"

echo "Creando script de registro de accesos..."

cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
echo "alias menu='sudo /usr/local/bin/scriptsProyecto/menu.sh'" > /etc/profile.d/menu.sh
chmod +x /etc/profile.d/menu.sh
EOF
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "Script instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
