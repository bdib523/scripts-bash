#!/bin/bash

# Funcion para comprobar si existe un fichero
comprobar_fichero()
{
    if [ -f "$1" ]; then
        return 1
    else
        return 0
    fi
}


# Recorremos todos los ficheros recibidos
for fichero in "$@"
do
    comprobar_fichero "$fichero"

    if [ $? -eq 1 ]; then

        echo "--------------------------------"
        echo "El fichero existe"
        echo "Nombre: $(basename "$fichero")"
        echo "Ruta: $(dirname "$fichero")"
        echo "Propietario: $(stat -c "%U" "$fichero")"

        permisos=$(stat -c "%A" "$fichero")

        echo "Permisos del propietario:"

        # Lectura
        if [ "${permisos:1:1}" = "r" ]; then
            echo "Lectura: SI"
        else
            echo "Lectura: NO"
        fi

        # Escritura
        if [ "${permisos:2:1}" = "w" ]; then
            echo "Escritura: SI"
        else
            echo "Escritura: NO"
        fi

        # Ejecucion
        if [ "${permisos:3:1}" = "x" ]; then
            echo "Ejecución: SI"
        else
            echo "Ejecución: NO"
        fi

        echo "Fecha de creación: $(stat -c "%w" "$fichero")"

    else

        echo "El fichero $fichero no existe"
        echo "Se va a crear en la carpeta actual"

        touch "$fichero"

        echo "Fichero creado"

    fi

done
