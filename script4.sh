#!/bin/bash

echo "Introduce los números separados por espacios:"
read -a numeros

while true
do
    echo ""
    echo "-------- MENU --------"
    echo "1. Listado de los elementos"
    echo "2. El número mayor"
    echo "3. La posición del mayor"
    echo "4. Ordenar de menor a mayor"
    echo "5. Ordenar de mayor a menor"
    echo "6. Salir"
    echo "----------------------"

    read -p "Elige una opción: " opcion

    case $opcion in

        1)
            echo "Elementos del array:"
            echo "${numeros[@]}"
            ;;

        2)
            mayor=${numeros[0]}

            for numero in "${numeros[@]}"
            do
                if [ "$numero" -gt "$mayor" ]; then
                    mayor=$numero
                fi
            done

            echo "El número mayor es: $mayor"
            ;;

        3)
            mayor=${numeros[0]}

            for numero in "${numeros[@]}"
            do
                if [ "$numero" -gt "$mayor" ]; then
                    mayor=$numero
                fi
            done

            for i in "${!numeros[@]}"
            do
                if [ "${numeros[$i]}" -eq "$mayor" ]; then
                    echo "El mayor está en la posición: $i"
                fi
            done
            ;;

        4)
            ordenados=($(printf "%s\n" "${numeros[@]}" | sort -n))

            echo "Array ordenado de menor a mayor:"
            echo "${ordenados[@]}"
            ;;

        5)
            ordenados=($(printf "%s\n" "${numeros[@]}" | sort -nr))

            echo "Array ordenado de mayor a menor:"
            echo "${ordenados[@]}"
            ;;

        6)
            echo "Programa terminado"
            break
            ;;

        *)
            echo "Opción incorrecta"
            ;;

    esac
done
