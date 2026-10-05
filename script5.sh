#!/bin/bash

# Comprobar que hay un solo argumento
if [ $# -ne 1 ]; then
    echo "Uso: ./script5.sh fichero"
    exit 1
fi

# Funcion para comprobar si existe el fichero
comprobar_fichero()
{
    if [ -f "$1" ]; then
        return 1
    else
        return 0
    fi
}

fichero=$1

# Comprobar si existe
comprobar_fichero "$fichero"

if [ $? -eq 0 ]; then
    echo "El fichero no existe"
    exit 1
fi

# Crear el array asociativo
declare -A archivo

archivo[nombre]="$(basename "$fichero")"
archivo[ruta]="$(dirname "$(realpath "$fichero")")"
archivo[tamano]="$(stat -c "%s" "$fichero")"

# Nombre real del fichero
nombre_real="${archivo[nombre]}"

while true
do
    echo ""
    echo "---------- MENU ----------"
    echo "1. Ver nombre del fichero"
    echo "2. Ver ruta del fichero"
    echo "3. Ver tamaño del fichero"
    echo "4. Ver contenido del fichero"
    echo "5. Cambiar nombre del fichero"
    echo "6. Guardar los cambios"
    echo "7. Salir sin realizar cambios"
    echo "8. Salir y guardar cambios"
    echo "--------------------------"

    read -p "Elige una opcion: " opcion

    case $opcion in

        1)
            echo "Nombre: ${archivo[nombre]}"
            ;;

        2)
            echo "Ruta: ${archivo[ruta]}"
            ;;

        3)
            echo "Tamaño: ${archivo[tamano]} bytes"
            ;;

        4)
            echo "Contenido del fichero:"
            cat "${archivo[ruta]}/$nombre_real"
            ;;

        5)
            read -p "Introduce el nuevo nombre: " nuevo_nombre

            archivo[nombre]="$nuevo_nombre"

            echo "Nombre cambiado en el array"
            ;;

        6)
            if [ "${archivo[nombre]}" != "$nombre_real" ]; then

                mv "${archivo[ruta]}/$nombre_real" "${archivo[ruta]}/${archivo[nombre]}"

                nombre_real="${archivo[nombre]}"

                echo "Cambios guardados"

            else
                echo "No hay cambios"
            fi
            ;;

        7)
            echo "Saliendo sin guardar cambios"
            exit 0
            ;;

        8)
            if [ "${archivo[nombre]}" != "$nombre_real" ]; then

                mv "${archivo[ruta]}/$nombre_real" "${archivo[ruta]}/${archivo[nombre]}"

                nombre_real="${archivo[nombre]}"
            fi

            echo "Cambios guardados"
            echo "Saliendo del programa"
            exit 0
            ;;

        *)
            echo "Opcion incorrecta"
            ;;

    esac
done
