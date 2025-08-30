#!/bin/bash
INSTALL_DIR="/usr/local/bin/scriptsProyecto/"
SCRIPT_NAME="gestionUsuarios.sh"
mkdir -p "$INSTALL_DIR"
cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/usr/bin/env bash
LOG_DIR=/backup/logs
LOG_FILE="$LOG_DIR/registro.log"
echo "" >> "$LOG_FILE"
echo "=== [$0] Inicio de ejecución: $(date) | Usuario: $(whoami) ===" >> "$LOG_FILE"
while true; do
	clear
	echo "--- MENÚ DE USUARIOS ---"
	echo "1. Crear un usuario nuevo"
	echo "2. Cambiar contraseña de un usuario"
	echo "3. Eliminar un usuario"
	echo "4. Permitir a otro usuario accedet a TODO el menú"
	echo "5. Eliminar a un usuario del acceso al menú"
    echo "6. Ver usuarios y sus accesos respectivos"
    echo "7. Volver al menú principal"

	read -p "Escriba un número de opción: " opcionElejida


	case "$opcionElejida" in

    	1)
        	read -p "Escriba el nombre del nuevo usuario: " nombreUsuario
        	useradd -m $nombreUsuario
            passwd $nombreUsuario
            ;;
    	2)
	 		LOG_FILE="$LOG_DIR/registro.log"
			echo "" >> "$LOG_FILE"
			echo "=== [$0] Inicio de ejecución (cambio de contraseña de usuario): $(date) | Usuario: $(whoami) ===" >> "$LOG_FILE"
        	read -p "Escriba el nombre del usuario: " nombreUsuario
            if id "$nombreUsuario" &>/dev/null; then
                passwd $nombreUsuario
            else
                echo "El usuario $nombreUsuario no existe."
            fi
            ;;
    	3)
	 		LOG_FILE="$LOG_DIR/registro.log"
			echo "" >> "$LOG_FILE"
			echo "=== [$0] Inicio de ejecución (borró usuario): $(date) | Usuario: $(whoami) ===" >> "$LOG_FILE"
			read -p "Escriba el nombre del usuario: " nombreUsuario
            if id "$nombreUsuario" &>/dev/null; then
                userdel -r "$nombreUsuario"
                echo "Usuario $nombreUsuario eliminado."
            else
                echo "El usuario $nombreUsuario no existe."
            fi
            ;;
        4)
            read -p "Escriba el nombre del usuario: " nombreUsuario
            if id "$nombreUsuario" &>/dev/null; then
                echo "$nombreUsuario ALL=(ALL) NOPASSWD: /usr/local/bin/menu.sh" | sudo tee /etc/sudoers.d/$nombreUsuario
                chmod 440 /etc/sudoers.d/$nombreUsuario
                echo "Usuario $nombreUsuario agregado a sudoers para ejecutar menu.sh sin contraseña."
            else
                echo "El usuario $nombreUsuario no existe."
            fi
            ;;
        5)
            read -p "Escriba el nombre del usuario: " nombreUsuario
            if [ -f /etc/sudoers.d/$nombreUsuario ]; then
                rm -f /etc/sudoers.d/$nombreUsuario
                echo "Regla sudoers de $nombreUsuario eliminada."
            else
                echo "El usuario $nombreUsuario no tiene regla sudoers."
            fi
            ;;
        6)
            cut -d: -f1 /etc/passwd | while read usuario; do
            if grep -q "^$usuario " /etc/sudoers 2>/dev/null || [ -f /etc/sudoers.d/$usuario ]; then
                echo "$usuario -> Tiene acceso al menú"
            else
                echo "$usuario -> Sin acceso al menú"
            fi
            done
            read -p "Presione Enter para volver"
            ;;
        7)
            echo "Saliendo."
        	exit
        	;;
    	*)
        	echo "Opción inválida"
        	read -p "Presione Enter para continuar"
        	;;
	esac
done

EOF

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
chown root:root /usr/local/bin/scriptsProyecto/gestionUsuarios.sh
echo "Script instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."

