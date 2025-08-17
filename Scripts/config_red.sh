#!/bin/bash
INTERFAZ="ens18"

echo "Ver interfaces disponibles: "
nmcli device status

echo "Configurando IP estática "
nmcli con mod $INTERFAZ ipv4.method manual
nmcli con mod $INTERFAZ ipv4.addresses 192.168.1.100/24
nmcli con mod $INTERFAZ ipv4.gateway 192.168.1.1
nmcli con mod $INTERFAZ ipv4.dns "8.8.8.8 1.1.1.1"

echo "Activando la conexión "
nmcli con up $INTERFAZ

echo "Configuración aplicada: "
nmcli device show $INTERFAZ | grep -E "IP4.ADDRESS|IP4.GATEWAY|IP4.DNS"
