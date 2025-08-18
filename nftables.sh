#!/bin/bash
# Instalador de reglas nftables para Restaurante
# Versión simple: sobrescribe siempre

echo "=== Configuración de nftables para Restaurante ==="

# 1. Desactivar firewalld
echo "Desactivando firewalld..."
systemctl stop firewalld 2>/dev/null || true
systemctl disable firewalld 2>/dev/null || true
systemctl mask firewalld 2>/dev/null || true

# 2. Crear (o sobrescribir) archivo de configuración de nftables
echo "Sobrescribiendo /etc/nftables.conf..."
cat > /etc/nftables.conf <<'EOF'
#!/usr/sbin/nft -f
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

# 3. Ajustar permisos y propietario
echo "Cambiando permisos de /etc/nftables.conf..."
chown root:Restaurante /etc/nftables.conf 2>/dev/null || true
chmod 740 /etc/nftables.conf

# 4. Aplicar configuración y habilitar nftables
echo "Aplicando configuración..."
nft -f /etc/nftables.conf

echo "Habilitando servicio nftables..."
systemctl enable nftables
systemctl restart nftables

echo "=== Instalación completada: nftables configurado y en ejecución ==="
