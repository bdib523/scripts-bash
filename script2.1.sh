#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Tienes que poner 3 argumentos"
    echo "Uso: ./script.sh usuario directorio fichero"
    exit 1
fi

usuario=$1
directorio=$2
fichero=$3

ruta="$directorio/$fichero"

if [ ! -d "$directorio" ]; then
    echo "El directorio no existe"
    exit 1
fi

if [ ! -f "$ruta" ]; then
    echo "El fichero no existe"
    exit 1
fi

echo "El fichero existe"
echo "Propietario actual:"
stat -c "%U" "$ruta"

read -p "¿Quieres cambiar el propietario a $usuario? (s/n): " respuesta

if [ "$respuesta" = "s" ]; then
    sudo chown "$usuario" "$ruta"

    echo "Nuevo propietario:"
    stat -c "%U" "$ruta"

    echo "El propietario ha sido cambiado"
else
    echo "No se ha cambiado el propietario"
fi
