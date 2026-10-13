#!/bin/bash

clear

#Comprobar que me pasan un argumento
if [ $# -ne 1 ]; then
    echo "Tienes que pasar un fichero"
    exit 1
fi

#Funcion para comprobar si existe el fichero
comprobar_fichero() {
    if [ -f "$1" ]; then
        return 1
    else
        return 0
    fi
}

fichero=$1

comprobar_fichero "$fichero"

if [ $? -eq 0 ]; then
    echo "El fichero no existe"
    exit 1
fi

#Guardar los datos en un array asociativo
declare -A datos

datos[nombre]=$(basename "$fichero")
datos[ruta]=$(dirname "$(realpath "$fichero")")
datos[tamano]=$(stat -c "%s" "$fichero")

nombreoriginal=${datos[nombre]}
opcion=0

#Mostramos el menu
while [ $opcion -ne 7 ] && [ $opcion -ne 8 ]; do

    echo "-------------------------"
    echo "1.-Ver nombre del fichero"
    echo "2.-Ver ruta del fichero"
    echo "3.-Ver tamaño del fichero"
    echo "4.-Ver contenido del fichero"
    echo "5.-Cambiar nombre del fichero"
    echo "6.-Guardar los cambios"
    echo "7.-Salir sin realizar cambios"
    echo "8.-Salir y guardar cambios"
    echo "-------------------------"

    read -p "Dame una opcion (1...8): " opcion

    if [ "$opcion" -eq 1 ]; then

        echo "Nombre: ${datos[nombre]}"

    elif [ "$opcion" -eq 2 ]; then

        echo "Ruta: ${datos[ruta]}"

    elif [ "$opcion" -eq 3 ]; then

        echo "Tamaño: ${datos[tamano]} bytes"

    elif [ "$opcion" -eq 4 ]; then

        cat "${datos[ruta]}/$nombreoriginal"

    elif [ "$opcion" -eq 5 ]; then

        read -p "Introduce el nuevo nombre: " nuevo
        datos[nombre]=$nuevo
        echo "Nombre cambiado en el array"

    elif [ "$opcion" -eq 6 ]; then

        if [ "${datos[nombre]}" != "$nombreoriginal" ]; then
            if [ -e "${datos[ruta]}/${datos[nombre]}" ]; then
                echo "Ya existe un fichero con ese nombre"
            else
                mv "${datos[ruta]}/$nombreoriginal" "${datos[ruta]}/${datos[nombre]}"
                nombreoriginal=${datos[nombre]}
                echo "Cambios guardados"
            fi
        else
            echo "No hay cambios"
        fi

    elif [ "$opcion" -eq 7 ]; then

        echo "Saliendo sin guardar cambios"

    elif [ "$opcion" -eq 8 ]; then

        if [ "${datos[nombre]}" != "$nombreoriginal" ]; then
            if [ -e "${datos[ruta]}/${datos[nombre]}" ]; then
                echo "Ya existe un fichero con ese nombre"
                opcion=0
            else
                mv "${datos[ruta]}/$nombreoriginal" "${datos[ruta]}/${datos[nombre]}"
                echo "Cambios guardados"
            fi
        fi

        echo "Saliendo del programa"

    else

        echo "Opcion incorrecta"

    fi

done
