#!/bin/bash

clear

#Me van a pasar argumentos y los voy a guardar en un array
declare -a numeros
numeros=($@)

if [ $# -eq 0 ]; then
    echo "Tienes que pasar numeros como argumentos"
    exit 1
fi

mayor=${numeros[0]}
posicionmayor=0
posicion=0

#Mostramos al usuario un menu
echo "-------------------------"
echo "1.-Listado de elementos"
echo "2.-El numero mayor"
echo "3.-Posicion del mayor"
echo "4.-Orden menor a mayor"
echo "5.-Orden mayor a menor"
echo "-------------------------"

read -p "Dame una opcion dada (1 al 5): " opcion

if [ "$opcion" -eq 1 ]; then

    #Recorro todos los numeros del array y los muestro
    for num in ${numeros[@]}; do
        echo $num
    done

elif [ "$opcion" -eq 2 ]; then

    #Busco el numero mayor
    for num in ${numeros[@]}; do
        if [ "$num" -gt "$mayor" ]; then
            mayor=$num
        fi
    done

    echo "El mayor es $mayor"

elif [ "$opcion" -eq 3 ]; then

    #Sacar la posicion del numero mayor en el array
    for num in ${numeros[@]}; do
        if [ "$num" -gt "$mayor" ]; then
            mayor=$num
            posicionmayor=$posicion
        fi
        posicion=$(($posicion+1))
    done

    echo "La posicion del numero mayor es $posicionmayor"

elif [ "$opcion" -eq 4 ]; then

    #Sacar el array de menor a mayor
    veces=0
    total=${#numeros[@]}

    while [ "$veces" -ne $(($total*$total)) ]; do
        posicion=1

        for num in "${numeros[@]}"; do
            if [ "$posicion" -lt "$total" ]; then
                if [ "${numeros[$((posicion-1))]}" -gt "${numeros[$posicion]}" ]; then
                    temporal=${numeros[$((posicion-1))]}
                    numeros[$((posicion-1))]=${numeros[$posicion]}
                    numeros[$posicion]=$temporal
                fi
            fi

            posicion=$(($posicion+1))
        done

        veces=$(($veces+1))
    done

    echo "Array ordenado de menor a mayor:"
    echo "${numeros[@]}"

elif [ "$opcion" -eq 5 ]; then

    #Sacar el array de mayor a menor
    veces=0
    total=${#numeros[@]}

    while [ "$veces" -ne $(($total*$total)) ]; do
        posicion=1

        for num in "${numeros[@]}"; do
            if [ "$posicion" -lt "$total" ]; then
                if [ "${numeros[$((posicion-1))]}" -lt "${numeros[$posicion]}" ]; then
                    temporal=${numeros[$((posicion-1))]}
                    numeros[$((posicion-1))]=${numeros[$posicion]}
                    numeros[$posicion]=$temporal
                fi
            fi

            posicion=$(($posicion+1))
        done

        veces=$(($veces+1))
    done

    echo "Array ordenado de mayor a menor:"
    echo "${numeros[@]}"

else
    echo "Error, tienes que elegir una de las opciones mostradas"
fi
