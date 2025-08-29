#!/usr/bin/env bash
LOG_DIR="/backup/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/registro.log"
echo "" >> "$LOG_FILE"
echo "=== [$0] Inicio de ejecución: $(date) | Usuario: $(whoami) ===" >> "$LOG_FILE"
DEST_FULL="/backup/completos"
DEST_INCR="/backup/incrementales"
RESTORE_DIR="/opt/proyecto"
DB_NAME="BDProyecto"
mkdir -p "$DEST_FULL" "$DEST_INCR" "$RESTORE_DIR"

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
            read -rp "Número de opción: " origen
            LOG_FILE="$LOG_DIR/registro.log"
            echo "" >> "$LOG_FILE"
            echo "=== [$0] Inicio de ejecución (restauracion de backup): $(date) | Usuario: $(whoami) ===" >> "$LOG_FILE"
            if [ "$origen" -eq 2 ]; then
                rclone copy gdrive:backup/completos "$DEST_FULL" --progress
                rclone copy gdrive:backup/incrementales "$DEST_INCR" --progress
            fi

            echo "Restaurando archivos (último completo disponible)..."
            ultimo_full=$(ls -1 "$DEST_FULL"/files-*.tar.gz | sort | tail -n 1)
            if [ -f "$ultimo_full" ]; then
                tar -xzf "$ultimo_full" -C /
            else
                echo "No se encontró backup completo."
            fi

            echo "Restaurando base de datos..."
            ultimo_db=$(ls -1 "$DEST_FULL"/mysql-*.sql.gz | sort | tail -n 1)
            if [ -f "$ultimo_db" ]; then
                gunzip -c "$ultimo_db" | mysql "$DB_NAME"
            else
                echo "No se encontró backup de base de datos."
            fi

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
                rclone copy gdrive:backup/completos "$DEST_FULL" --progress
            fi

            archivo_db="$DEST_FULL/mysql-$fecha.sql.gz"
            if [ ! -f "$archivo_db" ]; then
                archivo_db="$DEST_INCR/mysql_incremental-$fecha.sql.gz"
            fi

            if [ -f "$archivo_db" ]; then
                gunzip -c "$archivo_db" | mysql "$DB_NAME"
                echo "Base de datos restaurada."
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
            
            if [ "$origen" = "2" ]; then
                rclone copy gdrive:backup/completos "$DEST_FULL" --progress
                rclone copy gdrive:backup/incrementales "$DEST_INCR" --progress
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
                ultimo_domingo=$(date -d "$fecha -$(( $(date -d "$fecha" +%u) % 7 )) days" +%Y-%m-%d)
                archivo_completo="$DEST_FULL/files-$ultimo_domingo.tar.gz"
            
                if [ -f "$archivo_completo" ]; then
                    echo "Restaurando desde el completo del domingo $ultimo_domingo..."
                    tar -xzf "$archivo_completo" -C /
                else
                    echo "No se encontró backup completo del domingo $ultimo_domingo."
                fi
                echo "Aplicando incrementales hasta $fecha"
                while IFS= read -r incr; do
                    if [[ "$incr" > "$ultimo_domingo" && "$incr" <= "$fecha" ]]; then
                        rsync -a "$DEST_INCR/$incr/" /
                        echo "Incremental $incr aplicado."
                    fi
                done < <(find "$DEST_INCR" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)     
                echo "Archivos restaurados hasta el $fecha."
            fi
            read -p "Presione Enter para continuar."
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
