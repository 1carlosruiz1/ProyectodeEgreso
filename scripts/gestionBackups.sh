#!/bin/bash
INSTALL_DIR="/usr/local/bin/scriptsProyecto/"
SCRIPT_NAME="gestionBackups.sh"

echo "Creando script de instalación..."
mkdir -p "$INSTALL_DIR"
cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/usr/bin/env bash

LOG_DIR="/backup/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/registro.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo ""
echo "=== [$0] Inicio de ejecución: $(date) ==="


DEST_FULL="/backup/completos"
DEST_INCR="/backup/incrementales"
RESTORE_DIR="/opt/proyecto"
DB_NAME="BDProyecto"

while true; do
    clear
    echo "--- MENÚ DE BACKUP Y RESTAURACIÓN ---"
    echo "1. Restauración de backups completos"
    echo "2. Restaurar backup de la base de datos"
    echo "3. Restaurar backup del programa"
    echo "4. Realizar backup completo manual"
    echo "5. Salir"
    read -rp "Escriba un número de opción: " opcion

    case "$opcion" in
        1)  
            echo "¿Desde dónde quieres restaurar?"
            echo "1. Partición local"
            echo "2. Google Drive"
            read -rp "Numero de opción: " origen

            if [ "$origen" -eq 2 ]; then
                mkdir -p "$DEST_FULL" "$DEST_INCR"
                /usr/local/bin/rclone copy gdrive:backup/completos "$DEST_FULL" --progress
                /usr/local/bin/rclone copy gdrive:backup/incrementales "$DEST_INCR" --progress
            fi

            echo "Restaurando archivos (último completo disponible)."
            ultimo_full=$(ls -1 "$DEST_FULL"/files-*.tar.gz | sort | tail -n 1)
            tar -xzf "$ultimo_full" -C /

            echo "Restaurando BD..."
            ultimo_db=$(ls -1 "$DEST_FULL"/mysql-*.sql.gz | sort | tail -n 1)
            gunzip -c "$ultimo_db" | mysql "$DB_NAME"

            echo "Restauración COMPLETA finalizada."
            read -p "Presione Enter para continuar."
            ;;
        2)  
            echo "¿Desde dónde quieres restaurar?"
            echo "1. Partición local"
            echo "2. Google Drive"
            read -rp "Opción: " origen
            read -rp "Indica la FECHA (YYYY-MM-DD): " fecha

            if [ "$origen" -eq 2 ]; then
                /usr/local/bin/rclone copy gdrive:backup/completos "$DEST_FULL" --progress
            fi

            archivo_db="$DEST_FULL/mysql-$fecha.sql.gz"
            if [ ! -f "$archivo_db" ]; then
                archivo_db="$DEST_INCR/mysql_incremental-$fecha.sql.gz"
            fi

            if [ -f "$archivo_db" ]; then
                gunzip -c "$archivo_db" | mysql "$DB_NAME"
                echo "BD restaurada."
            else
                echo "No se encontró backup de BD para esa fecha."
            fi
            read -p "Presione Enter para continuar."
            ;;
        3) 
            echo "¿Desde dónde quieres restaurar?"
            echo "1. Partición local"
            echo "2. Google Drive"
            read -rp "Opción: " origen
            read -rp "Indica la FECHA (YYYY-MM-DD): " fecha

            if [ "$origen" -eq 2 ]; then
                /usr/local/bin/rclone copy gdrive:backup/completos "$DEST_FULL" --progress
                /usr/local/bin/rclone copy gdrive:backup/incrementales "$DEST_INCR" --progress
            fi

            dia=$(date -d "$fecha" +%A)
            if [ "$dia" = "Sunday" ]; then
                archivo_files="$DEST_FULL/files-$fecha.tar.gz"
                if [ -f "$archivo_files" ]; then
                    tar -xzf "$archivo_files" -C /
                    echo "Archivos restaurados desde backup completo."
                else
                    echo "No se encontró backup completo del $fecha."
                fi
            else
                ultimo_domingo=$(date -d "$fecha -$(($(date -d "$fecha" +%u))) days" +%Y-%m-%d)
                echo "Restaurando desde el completo del domingo $ultimo_domingo..."
                tar -xzf "$DEST_FULL/files-$ultimo_domingo.tar.gz" -C /
                echo "Aplicando incrementales hasta $fecha..."
                for incr in $(ls "$DEST_INCR"/files_incremental-*.tar.gz | sort); do
                    f=$(basename "$incr" | cut -d'-' -f3 | cut -d'.' -f1)
                    if [[ "$f" > "$ultimo_domingo" && "$f" <= "$fecha" ]]; then
                        tar --incremental -xzf "$incr" -C /
                    fi
                done
                echo "Archivos restaurados hasta el $fecha."
            fi
            read -p "Presione Enter para continuar..."
            ;;
        4)  
            /usr/local/bin/scriptsProyecto/backup.sh Sunday
            read -p "Presione Enter para continuar."
            ;;
        5)  
            echo "Saliendo"
            exit 0
            ;;
        *)
            echo "Opción inválida."
            read -p "Presione Enter para continuar."
            ;;
    esac
done

EOF

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
chown root:root /usr/local/bin/scriptsProyecto/gestionBackups.sh
echo "Script instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
