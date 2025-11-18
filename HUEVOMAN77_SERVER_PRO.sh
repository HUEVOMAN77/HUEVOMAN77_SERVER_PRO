#!/bin/bash

#=============================
# 🔥 HUEVOMAN77 SERVER PRO 🔥
#   Sistema oficial 2025
#=============================

reset_color="\e[0m"
cyan="\e[36m"
green="\e[32m"
yellow="\e[33m"
red="\e[31m"

banner() {
clear
echo -e "${cyan}"
echo "╔══════════════════════════════════════════════╗"
echo "   🔥 PANEL OFICIAL HUEVOMAN77 SERVER PRO 🔥"
echo "╚══════════════════════════════════════════════╝"
echo -e "${reset_color}"
}

crear_usuario() {
    banner
    echo -e "${green}[*] Crear usuario 7 días${reset_color}"
    read -p "Nombre del usuario: " usuario
    read -p "Contraseña: " clave

    # Crear usuario sin carpeta home ni shell
    useradd -M -s /usr/sbin/nologin $usuario 2>/dev/null

    if [ $? -ne 0 ]; then
        echo -e "${red}[!] Error creando el usuario (posiblemente ya existe)${reset_color}"
        return
    fi

    echo "$usuario:$clave" | chpasswd

    # Fecha expiración 7 días
    fecha=$(date -d "+7 days" +"%Y-%m-%d")
    chage -E $fecha $usuario

    echo -e "${yellow}Usuario creado con éxito:${reset_color}"
    echo -e "Usuario: ${green}$usuario${reset_color}"
    echo -e "Contraseña: ${green}$clave${reset_color}"
    echo -e "Expira: ${red}$fecha${reset_color}"
    read -p "Presiona ENTER para continuar..."
}

renovar_usuario() {
    banner
    echo -e "${green}[*] Renovar usuario${reset_color}"
    read -p "Usuario a renovar: " usuario
    read -p "Días a agregar: " dias

    fecha=$(date -d "+$dias days" +"%Y-%m-%d")
    chage -E $fecha $usuario 2>/dev/null

    if [ $? -ne 0 ]; then
        echo -e "${red}[!] Error renovando. ¿El usuario existe?${reset_color}"
        return
    fi

    echo -e "${yellow}Usuario renovado exitosamente.${reset_color}"
    echo -e "Nuevo vencimiento: ${green}$fecha${reset_color}"
    read -p "ENTER para continuar..."
}

eliminar_usuario() {
    banner
    read -p "Usuario a eliminar: " usuario
    userdel $usuario 2>/dev/null

    if [ $? -ne 0 ]; then
        echo -e "${red}[!] Error eliminando. Tal vez no existe.${reset_color}"
        return
    fi

    echo -e "${yellow}Usuario eliminado.${reset_color}"
    read -p "ENTER..."
}

ver_activos() {
    banner
    echo -e "${cyan}Usuarios activos:${reset_color}"
    awk -F: '$3>=1000 {print $1}' /etc/passwd
    echo
    read -p "ENTER..."
}

info_server() {
    banner
    echo -e "${yellow}Información del servidor:${reset_color}"
    echo -e "Hostname: ${green}$(hostname)${reset_color}"
    echo -e "IP Pública: ${green}$(curl -s ifconfig.me)${reset_color}"
    echo -e "Uptime: ${cyan}$(uptime -p)${reset_color}"
    read -p "ENTER..."
}

menu() {
while true; do
    banner
    echo -e "${green}[1]${reset_color} Crear usuario 7 días"
    echo -e "${green}[2]${reset_color} Renovar usuario"
    echo -e "${green}[3]${reset_color} Eliminar usuario"
    echo -e "${green}[4]${reset_color} Ver usuarios activos"
    echo -e "${green}[5]${reset_color} Información del servidor"
    echo -e "${green}[0]${reset_color} Salir"
    echo
    read -p "Opción: " op

    case $op in
        1) crear_usuario ;;
        2) renovar_usuario ;;
        3) eliminar_usuario ;;
        4) ver_activos ;;
        5) info_server ;;
        0) exit ;;
        *) echo -e "${red}Opción no válida${reset_color}" ;;
    esac
done
}

menu
