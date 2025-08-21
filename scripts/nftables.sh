#!/bin/bash
# Script completo para configurar nftables en Rocky Linux
# Funciona desde cero

echo "Iniciando configuración de nftables "

# 1. Instalar nftables si no está instalado
if ! command -v nft &>/dev/null; then
    echo "Instalando nftables..."
    sudo dnf install nftables -y
fi

# 2. Desactivar firewalld
echo "Desactivando firewalld..."
sudo systemctl stop firewalld 2>/dev/null || true
sudo systemctl disable firewalld 2>/dev/null || true
sudo systemctl mask firewalld 2>/dev/null || true

# 3. Crear archivo de reglas limpio
echo "Creando /etc/nftables.conf..."
sudo tee /etc/nftables.conf > /dev/null <<'EOF'
flush ruleset

table ip filter {
  chain input {
    type filter hook input priority 0;
    policy drop;

    iif "lo" accept
    ct state established,related accept

    # Permitir HTTP/HTTPS y SSH en puerto 3333
    tcp dport {80, 443, 3333} ct state new accept

    counter drop
  }

  chain output {
    type filter hook output priority 0;
    policy accept
  }

  chain forward {
    type filter hook forward priority 0;
    policy drop
  }
}
EOF

# 4. Ajustar permisos
echo "Ajustando permisos de /etc/nftables.conf..."
sudo chown root:root /etc/nftables.conf
sudo chmod 600 /etc/nftables.conf #solo root y no tiene ejecucion

# 5. Habilitar y arrancar servicio nftables
echo "Habilitando y arrancando nftables..."
sudo systemctl enable nftables
sudo systemctl restart nftables

# 6. Aplicar reglas
echo "Aplicando reglas..."
sudo nft -f /etc/nftables.conf

# 7. Verificar
echo "Reglas cargadas actualmente "
sudo nft list ruleset

echo "Configuración de nftables completada "


