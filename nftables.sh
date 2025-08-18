#!/bin/bash#!/bin/bash
# Instalador de reglas nftables para Restaurante en Rocky Linux
# Funciona desde cero

echo "=== Iniciando configuración de nftables ==="

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

# 3. Crear (o sobrescribir) archivo de configuración de nftables
echo "Creando /etc/nftables.conf..."
sudo tee /etc/nftables.conf > /dev/null <<'EOF'
flush ruleset

table ip filter {
  set blacklist {
    type ipv4_addr
    timeout 10m
  }

  chain input {
    type filter hook input priority 0;
    policy drop;

    ip saddr @blacklist drop
    iif "lo" accept
    ct state established,related accept

    # Permitir solo HTTP/HTTPS y SSH en puerto 3333
    tcp dport {80, 443, 3333} ct state new accept

    # Limitar demasiadas conexiones nuevas al puerto web
    tcp dport {80, 443} ct state new limit rate over 20/10s add @blacklist { ip saddr }

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
sudo chown root:Restaurante /etc/nftables.conf 2>/dev/null || true
sudo chmod 740 /etc/nftables.conf

# 5. Aplicar configuración y habilitar servicio nftables
echo "Aplicando reglas..."
sudo nft -f /etc/nftables.conf

echo "Habilitando servicio nftables..."
sudo systemctl enable nftables
sudo systemctl restart nftables

echo "=== Configuración completada: nftables funcionando ==="


