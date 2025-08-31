#!/bin/bash
BACKUP_SCRIPT="/usr/local/bin/scriptsProyecto/backup.sh"
DEST_BACKUP="/usr/local/bin/scriptsProyecto"
DEST_FULL="/backup/completos"
DEST_INCR="/backup/incrementales"
mkdir -p "$DEST_FULL" "$DEST_INCR" "$DEST_BACKUP"
echo "Creando $BACKUP_SCRIPT."
cat << 'EOF' > "$BACKUP_SCRIPT"
#!/bin/bash
LOG_DIR="/backup/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/registro.log"
echo "" >> "$LOG_FILE"
echo "=== [$0] Inicio de ejecución: $(date) | Usuario: $(whoami) ===" >> "$LOG_FILE"
if [ -n "$1" ]; then
    day="$1"
else
    day=$(LC_ALL=C date +%A)
fi
fecha=$(date +%Y-%m-%d)
backup_files="/opt/proyecto"
backup_db="BDProyecto"
dest_full="/backup/completos"
dest_incr="/backup/incrementales"
mkdir -p "$dest_full" "$dest_incr"
if [ "$day" = "Sunday" ]; then
    file_backup="$dest_full/files-$fecha.tar.gz"
    db_backup="$dest_full/mysql-$fecha.sql.gz"

    tar czf "$file_backup" "$backup_files"
    echo "Backup completo de la web en disco finalizado"
    date
    mysqldump --defaults-extra-file=/root/.my.cnf --skip-comments --add-drop-table --databases "$backup_db" \
        | gzip -9 > "$db_backup"
    echo "Backup completo de la BD en disco finalizado"
    date
    /usr/local/bin/rclone copy "$file_backup" gdrive:backup/completos
    /usr/local/bin/rclone copy "$db_backup" gdrive:backup/completos
    echo "Backup completo subido a Drive"
    date
    backups=( $(ls -1 $dest_full/files-*.tar.gz 2>/dev/null | sort) )
    if [ ${#backups[@]} -gt 3 ]; then
        old_file="${backups[0]}"
        old_date=$(basename "$old_file" | cut -d'-' -f2- | cut -d'.' -f1)
        echo "Borrando backup completo local del $old_date"
        rm -f "$dest_full/files-$old_date.tar.gz"
        rm -f "$dest_full/mysql-$old_date.sql.gz"
        rm -f $dest_incr/*"$old_date"* 2>/dev/null

        echo "Borrando backup completo en Drive del $old_date"
        /usr/local/bin/rclone deletefile "gdrive:/backups/completos/files-$old_date.tar.gz"
        /usr/local/bin/rclone deletefile "gdrive:/backups/completos/mysql-$old_date.sql.gz"
        /usr/local/bin/rclone delete "gdrive:/backups/incrementales" --include "*$old_date*"
        echo "Backup del $old_date eliminado (local + Drive)."
    fi
fi
if [ "$day" != "Sunday" ]; then
    incr_dir="$dest_incr/$fecha"
    mkdir -p "$incr_dir"
    # Incremental usando rsync
    # --link-dest apunta al último completo
    ultimo_full=$(ls -1 "$dest_full"/files-*.tar.gz | sort | tail -n 1)
    # Si quieres mantenerlo como copia descomprimida:
    rsync -a --link-dest="$backup_files" "$backup_files/" "$incr_dir/"
    echo "Backup incremental de la web en disco finalizado"
    date
    # Backup de BD sigue igual
    db_incr="$dest_incr/mysql_incremental-$fecha.sql.gz"
    mysqldump --defaults-extra-file=/root/.my.cnf --skip-comments --add-drop-table --databases "$backup_db" \
        | gzip -9 > "$db_incr"
    echo "Backup de la BD en disco finalizado"
    date
    rclone copy "$incr_dir" gdrive:backup/incrementales
    rclone copy "$db_incr" gdrive:backup/incrementales
    echo "Backup incremental subido a Drive"
    date
fi
EOF
chmod +x "$BACKUP_SCRIPT"
chown root:root /usr/local/bin/scriptsProyecto/backup.sh
echo "$BACKUP_SCRIPT creado y con permisos de ejecución."
CRON_LINE="0 0 * * * $BACKUP_SCRIPT"
if ! sudo crontab -l | grep -Fq "$BACKUP_SCRIPT"; then
    (sudo crontab -l 2>/dev/null; echo "$CRON_LINE") | sudo crontab -
    echo "Tarea agregada al crontab de root: $CRON_LINE"
fi
echo "Instalación del backup automatico completa"
