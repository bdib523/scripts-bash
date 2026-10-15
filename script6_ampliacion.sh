#!/bin/bash

clear

# Comprobamos el argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 todos | sistema | escritorio"
    exit
fi

tipo=$1

# Comprobamos que el argumento sea correcto
if [ "$tipo" != "todos" ] && [ "$tipo" != "sistema" ] && [ "$tipo" != "escritorio" ]; then
    echo "Argumento incorrecto"
    exit
fi

# Creamos el array asociativo
declare -A usuarios

i=0

# Leemos los usuarios del sistema
while IFS=: read -r nombre x uid gid comentario carpeta shell; do

    incluir=0

    if [ "$tipo" = "todos" ]; then
        incluir=1
    elif [ "$tipo" = "sistema" ] && [ "$uid" -lt 1000 ]; then
        incluir=1
    elif [ "$tipo" = "escritorio" ] && [ "$uid" -ge 1000 ] && [ "$uid" -lt 65534 ]; then
        incluir=1
    fi

    if [ $incluir -eq 1 ]; then
        usuarios[$i,nombre]=$nombre
        usuarios[$i,uid]=$uid
        usuarios[$i,grupo]=$gid
        usuarios[$i,carpeta]=$carpeta
        usuarios[$i,shell]=$shell
        ((i++))
    fi

done < /etc/passwd

total=$i
opcion=0

# Mostramos el menu
while [ $opcion -ne 5 ]; do

    echo ""
    echo "MENU DE USUARIOS"
    echo "1.- Ver nombres de usuarios"
    echo "2.- Ver informacion de un usuario"
    echo "3.- Ver los shells de los usuarios"
    echo "4.- Cambiar shell de un usuario"
    echo "5.- Salir"
    read -p "Elige una opcion: " opcion

    if [ $opcion -eq 1 ]; then

        for ((j=0; j<total; j++)); do
            echo "${usuarios[$j,nombre]}"
        done

    elif [ $opcion -eq 2 ]; then

        read -p "Introduce el nombre del usuario: " buscar
        encontrado=0

        for ((j=0; j<total; j++)); do
            if [ "${usuarios[$j,nombre]}" = "$buscar" ]; then
                echo "Nombre: ${usuarios[$j,nombre]}"
                echo "UID: ${usuarios[$j,uid]}"
                echo "Grupo: ${usuarios[$j,grupo]}"
                echo "Carpeta: ${usuarios[$j,carpeta]}"
                echo "Shell: ${usuarios[$j,shell]}"
                encontrado=1
            fi
        done

        if [ $encontrado -eq 0 ]; then
            echo "Usuario no encontrado"
        fi

    elif [ $opcion -eq 3 ]; then

        for ((j=0; j<total; j++)); do
            echo "${usuarios[$j,nombre]} - ${usuarios[$j,shell]}"
        done

    elif [ $opcion -eq 4 ]; then

        if [ "$tipo" = "escritorio" ]; then

            read -p "Usuario al que quieres cambiar el shell: " buscar
            encontrado=0

            for ((j=0; j<total; j++)); do
                if [ "${usuarios[$j,nombre]}" = "$buscar" ]; then
                    echo "Shell actual: ${usuarios[$j,shell]}"
                    read -p "Introduce el nuevo shell: " nuevo
                    usuarios[$j,shell]=$nuevo
                    encontrado=1
                    echo "Shell cambiado en el array"
                fi
            done

            if [ $encontrado -eq 0 ]; then
                echo "Usuario no encontrado"
            fi

        else
            echo "Esta opcion solo esta disponible para escritorio"
        fi

    elif [ $opcion -ne 5 ]; then
        echo "Opcion incorrecta"
    fi

done

echo "Fin del programa"
