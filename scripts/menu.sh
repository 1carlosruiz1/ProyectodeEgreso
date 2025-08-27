#!/bin/bash

INSTALL_DIR="/usr/local/bin/scriptsProyecto/"
SCRIPT_NAME="menu.sh"

echo "Creando script de instalación."
mkdir -p "$INSTALL_DIR"
cat << 'EOF' > "$INSTALL_DIR/$SCRIPT_NAME"
#!/usr/bin/env bash
while true; do
	clear
	echo "--- MENÚ DE ADMINISTRACIÓN ---"
	echo "1. Crear un directorio nuevo"
	echo "2. Crear archivo nuevo"
	echo "3. Opciones de Usuarios"
	echo "4. Opciones de Backups"
	echo "5. Opciones de restauración de servicios"
	echo "6. Ver configuraciones activas"
	echo "7. Ver log del sistema y backups"
	echo "8. Salir"

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
			gestionUsuarios.sh
			;;        	
        4)
			gestionBackups.sh
			;;
		5)
			while true; do
				clear
				echo "--- MENÚ DE RESTAURACIÓN ---"
				echo "1. Resetear configuraciones de ssh"
				echo "2. Resetear configuraciones de nftables"
				echo "3. Resetear configuraciones de red"
				echo "4. Resetear sistema de backups automáticos"
				echo "5. Volver"
				read -p "Escriba un número de opción: " opcionElejida2

				case "$opcionElejida2" in
					1) ssh.sh ;;
					2) nftables.sh ;;	
					3) red.sh ;;
					4) scriptsInstalacion/backup.sh ;;
					5) break ;;   # <- vuelve al menú principal
    				*) 
        				echo "Opción inválida"
        				read -p "Presione Enter para continuar"
        				;;	
				esac
			done
			;;
		6)
			echo "=== CONFIGURACIONES ACTIVAS ==="

			echo ""
			echo "Configuración activa de SSH:"
			sshd -T 2>/dev/null | more
			echo ""
			echo "Configuración activa de nftables:"
			sudo nft list ruleset
			echo ""
			echo "Configuración de red actual:"
			echo "Interfaces de red:"
			ip addr show
			echo "Tabla de enrutamiento:"
			ip route show
			echo "DNS en uso:"
			resolvectl status 2>/dev/null || cat /etc/resolv.conf
			read -p "Presione Enter para continuar"
			;;
		7)
			while true; do
				clear
				echo "--- VISOR DE LOGS ---"
				echo "1. Ver todos los registros"
				echo "2. Ver registros en vivo"
				echo "3. Volver"
				read -p "Elija un número de opción: " logOpcion
				case "$logOpcion" in
					1) 
						cat /backup/logs/scripts_unificados.log
						read -p "Presione Enter para continuar"
						;;
					2)
						tail -f /backup/logs/scripts_unificados.log
						;;
					3) break ;;
					*) 
						echo "Opción inválida"
						read -p "Presione Enter para continuar"
						;;
				esac
			done
			;;
		8)
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

echo "Gerente ALL=(ALL) NOPASSWD: $INSTALL_DIR/$SCRIPT_NAME" | sudo tee /etc/sudoers.d/menu_gerente
sudo chmod 440 /etc/sudoers.d/menu_gerente
