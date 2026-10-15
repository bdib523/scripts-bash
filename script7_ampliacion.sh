
#!/bin/bash

# Creamos el array asociativo
declare -A usuarios

i=0

# Leemos los usuarios del sistema
while IFS=: read -r nombre x uid gid comentario carpeta shell; do

    if [[ "$shell" != */nologin && "$shell" != */false && -n "$shell" ]]; then
        usuarios[$i,nombre]=$nombre
        usuarios[$i,carpeta]=$carpeta
        usuarios[$i,shell]=$shell
        ((i++))
    fi

done < /etc/passwd

total=$i
opcion=0

# Menu principal
while [ $opcion -ne 5 ]; do

    echo ""
    echo "MENU"
    echo "1.Visualizar todos los usuarios"
    echo "2.Crear fichero con los datos"
    echo "3.Guardar los datos en SQLite3"
    echo "4.Consultar los datos de SQLite3"
    echo "5.Salir"
    read -p "Elige una opcion: " opcion

    if [ $opcion -eq 1 ]; then

        for ((j=0; j<total; j++)); do
            echo "Nombre de usuario: ${usuarios[$j,nombre]}"
            echo "Carpeta personal: ${usuarios[$j,carpeta]}"
            echo "Shell por defecto: ${usuarios[$j,shell]}"
            echo ""
        done

    elif [ $opcion -eq 2 ]; then

        for ((j=0; j<total; j++)); do
            echo "${usuarios[$j,nombre]}:${usuarios[$j,carpeta]}:${usuarios[$j,shell]}"
        done > usuarios.txt

        echo "Fichero usuarios.txt creado"

    elif [ $opcion -eq 3 ]; then

        if ! command -v sqlite3 >/dev/null 2>&1; then
            echo "SQLite3 no esta instalado"
        else
            sqlite3 usuarios.db "CREATE TABLE IF NOT EXISTS usuarios (nombre TEXT PRIMARY KEY, carpeta TEXT, shell TEXT);"

            for ((j=0; j<total; j++)); do
                nombre="${usuarios[$j,nombre]}"
                carpeta="${usuarios[$j,carpeta]}"
                shell="${usuarios[$j,shell]}"

                sqlite3 usuarios.db "INSERT OR REPLACE INTO usuarios VALUES ('$nombre','$carpeta','$shell');"
            done

            echo "Datos guardados en usuarios.db"
        fi

    elif [ $opcion -eq 4 ]; then

        if [ -f usuarios.db ] && command -v sqlite3 >/dev/null 2>&1; then
            sqlite3 usuarios.db "SELECT * FROM usuarios;"
        else
            echo "No existe la base de datos o SQLite3 no esta instalado"
        fi

    elif [ $opcion -ne 5 ]; then
        echo "Opcion incorrecta"
    fi

done

echo "Fin del programa"
