#!/bin/bash

SETUP_SCRIPT="/usr/local/bin/scriptsProyecto/nftables.sh"
DEST="/usr/local/bin/scriptsProyecto/"

echo "Creando script $SETUP_SCRIPT..."
mkdir -p "$DEST"

sudo tee "$SETUP_SCRIPT" > /dev/null <<'EOF'
#!/bin/bash
echo "Iniciando configuración de nftables"

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
sudo tee /etc/nftables.conf > /dev/null <<'RULES'
flush ruleset

table ip filter {
  chain input {
    type filter hook input priority 0;
    policy drop;

    iif "lo" accept
    ct state established,related accept

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
RULES

# 4. Ajustar permisos del archivo de reglas
sudo chown root:root /etc/nftables.conf
sudo chmod 600 /etc/nftables.conf

# 5. Habilitar y arrancar servicio nftables
sudo systemctl enable nftables
sudo systemctl restart nftables

# 6. Aplicar reglas
sudo nft -f /etc/nftables.conf

# 7. Verificar
echo "Reglas cargadas actualmente:"
sudo nft list ruleset

echo "Configuración de nftables completada"
EOF

# Dar permisos de ejecución al script
sudo chmod +x "$SETUP_SCRIPT"
sudo chown root:root "$SETUP_SCRIPT"

echo "Ejecutando la configuración de NFTables "
/usr/local/bin/scriptsProyecto/nftables.sh
echo "Script $SETUP_SCRIPT creado y listo."


