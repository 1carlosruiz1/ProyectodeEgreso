#!/bin/bash

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="menu.sh"

echo "Creando script de instalación."

cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/usr/bin/env bash
while true; do
	clear
	echo "--- MENÚ DE ADMINISTRACIÓN ---"
	echo "1. Crear un directorio nuevo"
	echo "2. Crear archivo nuevo"
	echo "3. Opciones de Usuarios"
	echo "4. Opciones de Backups"
	echo "5. Salir"

	read -p "Escriba un número de opción: " opcionElejida

	case "$opcionElejida" in
    	1)
        	read -p "Escriba el nombre del nuevo directorio: " nombreDirectorio
        	read -p "Escriba la dirección del nuevo directorio (ej: /home/usuario/): " direccionDirectorio
        	mkdir -p "$direccionDirectorio/$nombreDirectorio"
        	read -p "Directorio creado exitosamente. Presione Enter para continuar "
        	;;
    	2)
        	read -p "Escriba el nombre del nuevo archivo: " nombreArchivo
        	read -p "Escriba la dirección del nuevo archivo (ej: /home/usuario/): " direccionArchivo
        	mkdir -p "$direccionArchivo"
        	nano "$direccionArchivo/$nombreArchivo"
        	;;
    	3)
			usuarios.sh
			;;        	
        4)
			gestionBackups.sh
			;;
		5)
			exit 0
			;;
    	*)
        	echo "Opción inválida"
        	read -p "Presione Enter para continuar"
        	;;
	esac
done
EOF
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "Script instalado en $INSTALL_DIR/$SCRIPT_NAME con permisos de ejecución."
