#!/bin/bash
INSTALL_DIR="/usr/local/bin/scriptsProyecto"
SCRIPT_NAME="gestionBackups.sh"
cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
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
validar_fecha() {
  date -d "$1" +%F >/dev/null 2>&1
}
descargar_backups() {
  local tipo=$1
  if [ "$origen" -eq 2 ]; then
    rclone copy "gdrive:backup/$tipo" "/backup/$tipo" --progress
  fi
}

while true; do
    clear
    echo "--- MENÚ DE BACKUP Y RESTAURACIÓN ---"
    echo "1. Restauración completa (archivos + BD)"
    echo "2. Restaurar solo la base de datos"
    echo "3. Restaurar solo archivos/programa"
    echo "4. Realizar backup completo manual"
	echo "5. Ver listado de backups realizados"
    echo "6. Salir"
    read -rp "Escriba un número de opción: " opcion
    case "$opcion" in
        1)
            echo "¿Desde dónde quieres restaurar?"
            echo "1. Partición local"
            echo "2. Google Drive"
            read -rp "Número de opción: " origen
            # Descargar si es Drive
            descargar_backups completos
            descargar_backups incrementales
            echo "Restaurando archivos (último completo disponible)..."
            ultimo_full=$(ls -1 "$DEST_FULL"/files-*.tar.gz 2>/dev/null | sort | tail -n 1)
            if [ -f "$ultimo_full" ]; then
                tar -xzf "$ultimo_full" -C /
                echo "Archivos restaurados."
            else
                echo "No se encontró backup completo de archivos."
            fi
            echo "Restaurando base de datos..."
            ultimo_db=$(ls -1 "$DEST_FULL"/mysql-*.sql.gz 2>/dev/null | sort | tail -n 1)
            if [ -f "$ultimo_db" ]; then
                gunzip -c "$ultimo_db" | mysql "$DB_NAME"
                echo "Base de datos restaurada."
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

            if ! validar_fecha "$fecha"; then
              echo "Fecha inválida. Formato esperado: YYYY-MM-DD."
              read -p "Presione Enter para continuar."
              continue
            fi
            descargar_backups completos
            descargar_backups incrementales
            archivo_db="$DEST_FULL/mysql-$fecha.sql.gz"
            if [ ! -f "$archivo_db" ]; then
                archivo_db="$DEST_INCR/mysql_incremental-$fecha.sql.gz"
            fi
            if [ -f "$archivo_db" ]; then
                gunzip -c "$archivo_db" | mysql "$DB_NAME"
                echo "Base de datos restaurada desde $archivo_db."
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
            if ! validar_fecha "$fecha"; then
              echo "Fecha inválida. Formato esperado: YYYY-MM-DD."
              read -p "Presione Enter para continuar."
              continue
            fi
            descargar_backups completos
            descargar_backups incrementales

            dia_num=$(date -d "$fecha" +%u)  # 1=lun ... 7=dom
            if [ "$dia_num" -eq 7 ]; then
                archivo_files="$DEST_FULL/files-$fecha.tar.gz"
                if [ -f "$archivo_files" ]; then
                    tar -xzf "$archivo_files" -C /
                    echo "Archivos restaurados desde backup completo."
                else
                    echo "No se encontró backup completo del $fecha."
                fi
            else
                ultimo_domingo=$(date -d "$fecha -$(( dia_num % 7 )) days" +%Y-%m-%d)
                archivo_completo="$DEST_FULL/files-$ultimo_domingo.tar.gz"

                if [ -f "$archivo_completo" ]; then
                    echo "Restaurando desde el completo del domingo $ultimo_domingo..."
                    tar -xzf "$archivo_completo" -C /
                else
                    echo "No se encontró backup completo del domingo $ultimo_domingo."
                fi

                echo "Aplicando incrementales hasta $fecha..."
                while IFS= read -r incr; do
                    if [[ "$incr" > "$ultimo_domingo" && ( "$incr" < "$fecha" || "$incr" == "$fecha" ) ]]; then
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
			clear
			echo "BACKUPS REALIZADOS DE DRIVE: "
			echo "COMPLETOS"
			echo ""
			rclone ls gdrive:backup/completos
			echo ""

			echo "INCREMENTALES"
			echo ""
			rclone ls gdrive:backup/incrementales
			echo ""

			echo "BACKUPS REALIZADOS EN LA PARTICIÓN DEDICADA"
			echo "COMPLETOS"
			echo ""
			ls -r /backup/completos
			echo ""

			echo "INCREMENTALES"
			echo ""
			ls -r /backup/incrementales
   			;;
    6)
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
echo "Script instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
