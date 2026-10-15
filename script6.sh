#!/bin/bash
#!/bin/bash

clear

#Creamos el array asociativo
declare -A usuarios

#Contador de usuarios
i=0

#Leemos el fichero passwd
while IFS=: read -r nombre x uid gid comentario carpeta shell; do

    usuarios[$i,nombre]=$nombre
    usuarios[$i,grupo]=$gid
    usuarios[$i,carpeta]=$carpeta
    usuarios[$i,shell]=$shell
    usuarios[$i,modificado]=no

    ((i++))

done < /etc/passwd

total=$i
opcion=0

#Mostramos el menu
while [ $opcion -ne 5 ] && [ $opcion -ne 6 ]; do

    echo "-------------------------"
    echo "1.-Ver nombres de usuarios"
    echo "2.-Ver datos de un usuario"
    echo "3.-Modificar grupo principal"
    echo "4.-Guardar los datos"
    echo "5.-Salir y guardar"
    echo "6.-Salir sin guardar"
    echo "-------------------------"

    read -p "Dame una opcion: " opcion

    if [ $opcion -eq 1 ]; then

        #Mostrar los nombres
        for ((j=0; j<total; j++)); do
            echo "${usuarios[$j,nombre]}"
        done

    elif [ $opcion -eq 2 ]; then

        read -p "Nombre del usuario: " buscar
        encontrado=0

        for ((j=0; j<total; j++)); do
            if [ "${usuarios[$j,nombre]}" = "$buscar" ]; then
                echo "Nombre: ${usuarios[$j,nombre]}"
                echo "Grupo principal (GID): ${usuarios[$j,grupo]}"
                echo "Carpeta personal: ${usuarios[$j,carpeta]}"
                echo "Shell: ${usuarios[$j,shell]}"
                encontrado=1
            fi
        done

        if [ $encontrado -eq 0 ]; then
            echo "Usuario no encontrado"
        fi

    elif [ $opcion -eq 3 ]; then

        read -p "Nombre del usuario: " buscar
        encontrado=0

        for ((j=0; j<total; j++)); do
            if [ "${usuarios[$j,nombre]}" = "$buscar" ]; then
                read -p "Nuevo GID del grupo principal: " grupo
                usuarios[$j,grupo]=$grupo
                usuarios[$j,modificado]=si
                encontrado=1
                echo "Grupo cambiado en el array"
            fi
        done

        if [ $encontrado -eq 0 ]; then
            echo "Usuario no encontrado"
        fi

    elif [ $opcion -eq 4 ] || [ $opcion -eq 5 ]; then

        for ((j=0; j<total; j++)); do
            if [ "${usuarios[$j,modificado]}" = "si" ]; then
                echo "Usuario: ${usuarios[$j,nombre]}"
                echo "Nuevo GID: ${usuarios[$j,grupo]}"
                echo "Para guardar el cambio en el sistema usa usermod."
            fi
        done

        if [ $opcion -eq 5 ]; then
            echo "Saliendo del programa"
            exit 0
        fi

    elif [ $opcion -eq 6 ]; then

        echo "Saliendo sin guardar los cambios"
        exit 0

    else

        echo "Opcion incorrecta"

    fi

done
