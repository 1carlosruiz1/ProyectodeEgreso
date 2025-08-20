#!/bin/bash
if [ -n "$1" ]; then
    day="$1"
else
    day=$(LC_ALL=C date +%A)
fi
fecha=$(date +%Y-%m-%d)
# Variables
backup_files="/opt/proyecto"
backup_db="BDProyecto"
# Directorios
dest_full="/backup/completos"
dest_incr="/backup/incrementales"
# Crear carpetas si no existen
mkdir -p "$dest_full" "$dest_incr"


if [ "$day" = "Sunday" ]; then   # Backup completo (solo domingos)


    # Archivos destino
    file_backup="$dest_full/files-$fecha.tar.gz"
    db_backup="$dest_full/mysql-$fecha.sql.gz"


    # Backup completo de la web
    tar czf "$file_backup" "$backup_files"
    echo "Backup completo de la web en disco finalizado"
    date


    # Backup completo de la base de datos
    mysqldump --defaults-extra-file=/root/.my.cnf --skip-comments --add-drop-table --databases "$backup_db" \
        | gzip -9 > "$db_backup"
    echo "Backup completo de la BD en disco finalizado"
    date


    # Subida a Drive
    /usr/local/bin/rclone copy "$file_backup" gdrive:backup/completos
    /usr/local/bin/rclone copy "$db_backup" gdrive:backup/completos
    echo "Backup completo subido a Drive"
    date


    # --- Rotación de backups completos ---
    # Listar los backups completos (solo archivos tar.gz), ordenados por fecha
    backups=( $(ls -1 $dest_full/files-*.tar.gz 2>/dev/null | sort) )


    # Si hay más de 3 completos, borramos el más viejo y sus incrementales
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


if [ "$day" != "Sunday" ]; then  # Backup incremental (lunes a sabado)


    # Archivos destino
    file_incr="$dest_incr/files_incremental-$fecha.tar.gz"
    db_incr="$dest_incr/mysql_incremental-$fecha.sql.gz"


    # Snapshot para tar
    snapshot="$dest_incr/proyecto.snar"


    # Backup incremental de la web
    tar --listed-incremental="$snapshot" -czf "$file_incr" "$backup_files"
    echo "Backup incremental de la web en disco finalizado"
    date


    # Backup diario de la base de datos (dump completo, nombrado incremental)
    mysqldump --defaults-extra-file=/root/.my.cnf --skip-comments --add-drop-table --databases "$backup_db" \
        | gzip -9 > "$db_incr"
    echo "Backup de la BD en disco finalizado"
    date


    # Subida a Drive del incremental
    /usr/local/bin/rclone copy "$file_incr" gdrive:backup/incrementales
    /usr/local/bin/rclone copy "$db_incr" gdrive:backup/incrementales
    echo "Backup incremental subido a Drive"
    date
fi
