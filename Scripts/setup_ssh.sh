!/bin/bash

# Instalar SSH
dnf install -y openssh-server

# Habilitar e iniciar el servicio
systemctl enable sshd
systemctl start sshd

# Archivo de configuración
CONFIG_FILE="/etc/ssh/sshd_config"

# Hacer backup del archivo original por si las dudas
cp $CONFIG_FILE ${CONFIG_FILE}.bak

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

# Bloquear root por mas seguridad
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
