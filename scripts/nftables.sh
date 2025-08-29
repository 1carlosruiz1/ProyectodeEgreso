#!/bin/bash
SETUP_SCRIPT="nftables.sh"
DEST="/usr/local/bin/scriptsProyecto/"
mkdir -p "$DEST"
cat << 'EOF' > "$DEST/$SETUP_SCRIPT"
#!/bin/bash
LOG_DIR=/backup/logs
LOG_FILE="$LOG_DIR/registro.log"
echo "" >> "$LOG_FILE"
echo "=== [$0] Inicio de ejecución: $(date) | Usuario: $(whoami) ===" >> "$LOG_FILE"
echo "Iniciando configuración de nftables"
# 1. Instalar nftables si no está instalado
if ! command -v nft &>/dev/null; then
    echo "Instalando nftables..."
    dnf install -y nftables
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
    tcp dport {80, 443, 3333, 3306} ct state new accept
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
EOF
chmod +x "$DEST/$SETUP_SCRIPT"
chown root:root "$DEST/$SETUP_SCRIPT"
"$DEST/$SETUP_SCRIPT"
echo "Configuración de nftables terminada"
