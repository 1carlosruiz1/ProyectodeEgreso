#!/bin/bash
LOG_DIR="/backup/logs"
LOG_FILE="$LOG_DIR/registro.log"
SCRIPT_PAM="/usr/local/bin/log_access.sh"
echo "Creando script de registro de accesos (PAM)..."
cat << 'EOF' > "$SCRIPT_PAM"
#!/bin/bash
LOG_DIR="/var/log/login_access"
mkdir -p "$LOG_DIR"
chmod 755 "$LOG_DIR"
LOG_FILE="$LOG_DIR/registro.log"
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"
REMOTE="${PAM_RHOST:-local}"
USER="$PAM_USER"
UID_NUM=$(id -u "$USER")
if [ "$UID_NUM" -ge 1000 ] || [ "$UID_NUM" -eq 0 ]; then
    echo "Usuario $USER accedió desde $REMOTE el $(date)" >> "$LOG_FILE"
fi
EOF
chmod +x "$SCRIPT_PAM"
PAM_FILES=("/etc/pam.d/sshd" "/etc/pam.d/login")

for f in "${PAM_FILES[@]}"; do
    # Verificar si ya existe la línea
    if ! grep -q "$SCRIPT_PAM" "$f"; then
        echo "session optional pam_exec.so $SCRIPT_PAM" >> "$f"
        echo "Línea agregada a $f en $f"
    fi
done
echo "Instalación completa. PAM configurado para registrar accesos de usuarios."
