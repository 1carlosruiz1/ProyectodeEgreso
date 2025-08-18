#!/bin/bash
# Instalador de configuración de red estática

echo "=== Instalando script de red en /usr/local/bin/config_red.sh ==="

# 1. Crear (o sobrescribir) el script de configuración
cat > /usr/local/bin/config_red.sh <<'EOF'
#!/bin/bash
INTERFAZ="enp0s3"

echo "Ver interfaces disponibles: "
nmcli device status

echo "Configurando IP estática "
nmcli con mod $INTERFAZ ipv4.method manual
nmcli con mod $INTERFAZ ipv4.addresses 192.168.1.100/24
nmcli con mod $INTERFAZ ipv4.gateway 192.168.1.1
nmcli con mod $INTERFAZ ipv4.dns "8.8.8.8 1.1.1.1"

echo "Activando la conexión "
nmcli con up $INTERFAZ

echo "Configuración de red aplicada: "
nmcli device show $INTERFAZ | grep -E "IP4.ADDRESS|IP4.GATEWAY|IP4.DNS"
EOF

# 2. Ajustar permisos y propietario
echo "Cambiando permisos de /usr/local/bin/config_red.sh..."
chown root:Restaurante /usr/local/bin/config_red.sh 2>/dev/null || true
chmod 750 /usr/local/bin/config_red.sh

# 3. Ejecutar el script
echo "Ejecutando script de configuración de red..."
/usr/local/bin/config_red.sh

echo "=== Configuración de red instalada y aplicada ==="
