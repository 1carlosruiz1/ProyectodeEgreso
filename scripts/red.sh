#!/bin/bash
mkdir -p /usr/local/bin/scriptsProyecto/
cat > /usr/local/bin/scriptsProyecto/red.sh <<'EOF'
#!/bin/bash
LOG_DIR=/backup/logs
LOG_FILE="$LOG_DIR/registro.log"
echo "" >> "$LOG_FILE"
echo "=== [$0] Inicio de ejecución: $(date) | Usuario: $(whoami) ===" >> "$LOG_FILE"
INTERFAZ="enp0s3"
IP_STATIC="192.168.1.100/24"
GATEWAY="192.168.1.1"
DNS="8.8.8.8 1.1.1.1"

# Ver interfaces disponibles
echo "Interfaces disponibles"
nmcli device status

# Verificar si existe la conexión, crear si no existe
if ! nmcli con show "$INTERFAZ" &>/dev/null; then
    echo "Conexión '$INTERFAZ' no encontrada. Creando nueva conexión..."
    nmcli con add type ethernet ifname "$INTERFAZ" con-name "$INTERFAZ"
fi

# Configurar IP estática
echo "Configurando IP estática "
nmcli con mod "$INTERFAZ" ipv4.method manual
nmcli con mod "$INTERFAZ" ipv4.addresses "$IP_STATIC"
nmcli con mod "$INTERFAZ" ipv4.gateway "$GATEWAY"
nmcli con mod "$INTERFAZ" ipv4.dns "$DNS"

# Activar la conexión
echo "Activando la conexión "
nmcli con up "$INTERFAZ" || nmcli con up "$INTERFAZ" --ask

# Mostrar configuración aplicada
echo "Configuración aplicada "
nmcli device show "$INTERFAZ" | grep -E "IP4.ADDRESS|IP4.GATEWAY|IP4.DNS"
EOF

# 2. Ajustar permisos y propietario
echo "Cambiando permisos de /usr/local/bin/config_red.sh..."
chown root:root /usr/local/bin/scriptsProyecto/red.sh
chmod +x /usr/local/bin/scriptsProyecto/red.sh

# 3. Ejecutar el script
echo "Ejecutando script de configuración de red..."
/usr/local/bin/scriptsProyecto/red.sh

echo "Configuración de red instalada y aplicada "
