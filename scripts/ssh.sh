#!/bin/bash

mkdir -p /usr/local/bin/scriptsProyecto/
cat > /usr/local/bin/scriptsProyecto/ssh.sh <<'EOF'
#!/bin/bash


LOG_DIR="/backup/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/registro.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo ""
echo "=== [$0] Inicio de ejecución: $(date) ==="

# Instalación y configuración automática de SSH en Rocky Linux
# Configuración segura: puerto 3333, solo usuarios Gerente y Usuario, root bloqueado

set -e  # Detener ejecución si hay error

# Instalar SSH
dnf install -y openssh-server

# Habilitar e iniciar el servicio
systemctl enable sshd
systemctl start sshd 

# Archivo de configuración
CONFIG_FILE="/etc/ssh/sshd_config"

# Cambiar el puerto a 3333
if grep -q "^#\?Port " $CONFIG_FILE; then
    sed -i 's/^#\?Port .*/Port 3333/' $CONFIG_FILE
else
    echo "Port 3333" >> $CONFIG_FILE
fi

# Permitir solo usuarios Gerente y Usuario
if grep -q "^#\?AllowUsers " $CONFIG_FILE; then
    sed -i 's/^#\?AllowUsers .*/AllowUsers Gerente Usuario/' $CONFIG_FILE
else
    echo "AllowUsers Gerente Usuario" >> $CONFIG_FILE
fi

# Bloquear root
if grep -q "^#\?PermitRootLogin " $CONFIG_FILE; then
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' $CONFIG_FILE
else
    echo "PermitRootLogin no" >> $CONFIG_FILE
fi

# Recargar SSH para aplicar cambios
systemctl reload sshd

echo "SSH instalado y configurado en el puerto 3333"
echo "Usuarios permitidos: Gerente y Usuario"
echo "Root bloqueado"
EOF

# Ajustar permisos y propietario
echo "Cambiando permisos"
chown root:root /usr/local/bin/scriptsProyecto/ssh.sh
chmod +x /usr/local/bin/scriptsProyecto/ssh.sh

# Ejecutar el script
echo "Ejecutando script de configuración de SSH..."
/usr/local/bin/scriptsProyecto/ssh.sh

echo "Configuración de SSH terminada"
