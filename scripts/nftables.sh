SETUP_SCRIPT="/usr/local/bin/scriptsProyecto/nftables.sh"
DEST="/usr/local/bin/scriptsProyecto/"
mkdir -p "$DEST"
# Crear el script
cat > /usr/local/bin/scriptsProyecto/nftables.sh <<'EOF'
#!/bin/bash
LOG_DIR="/backup/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/registro.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo ""
echo "=== [$0] Inicio de ejecución: $(date) ==="
echo "Iniciando configuración de nftables"
# 1. Instalar nftables si no está instalado
if ! command -v nft &>/dev/null; then
    echo "Instalando nftables..."
    dnf install nftables -y
fi
# 2. Desactivar firewalld
echo "Desactivando firewalld..."
systemctl stop firewalld 2>/dev/null || true
systemctl disable firewalld 2>/dev/null || true
systemctl mask firewalld 2>/dev/null || true
# 3. Crear archivo de reglas limpio
echo "Creando /etc/nftables.conf..."
cat <<'RULES' > /etc/nftables.conf
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
chown root:root /etc/nftables.conf
chmod 600 /etc/nftables.conf
# 5. Habilitar y arrancar servicio nftables
systemctl enable nftables
systemctl restart nftables
# 6. Aplicar reglas
nft -f /etc/nftables.conf
# 7. Verificar
echo "Reglas cargadas actualmente:"
nft list ruleset
echo "Configuración de nftables completada"
EOF
# Convertir a formato Unix
if command -v dos2unix >/dev/null 2>&1; then
    dos2unix "$SETUP_SCRIPT"
else
    # alternativa con sed
    sed -i 's/\r$//' "$SETUP_SCRIPT"
fi
# Dar permisos
chmod +x "$SETUP_SCRIPT"
chown root:root "$SETUP_SCRIPT"

# Dar permisos
chmod +x "$SETUP_SCRIPT"
chown root:root "$SETUP_SCRIPT"
# Ejecutar
"$SETUP_SCRIPT"
