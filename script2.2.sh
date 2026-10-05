#!/bin/bash

# Comprobar que se ha indicado al menos un fichero
if [ $# -lt 1 ]; then
    echo "Uso: $0 fichero1 fichero2 fichero3 ..."
    exit 1
fi

LOG="resultado.log"

# Crear/limpiar el archivo de log
echo "========================================" > "$LOG"
echo "INFORME DEL SCRIPT" >> "$LOG"
echo "Fecha: $(date)" >> "$LOG"
echo "========================================" >> "$LOG"

for FICHERO in "$@"
do
    echo ""
    echo "Buscando: $FICHERO"
    echo "Buscando: $FICHERO" >> "$LOG"

    # Buscar el fichero en todo el sistema
    RUTA=$(find / -type f -name "$FICHERO" 2>/dev/null | head -n 1)

    if [ -z "$RUTA" ]; then
        echo "El fichero NO existe en el sistema."
        echo "Resultado: NO ENCONTRADO" >> "$LOG"
    else
        echo "Fichero encontrado."
        echo "Ruta: $RUTA"

        echo "Resultado: ENCONTRADO" >> "$LOG"
        echo "Ruta: $RUTA" >> "$LOG"

        # Preguntar si quiere hacer una copia
        read -p "¿Quieres hacer una copia de este fichero? (s/n): " RESPUESTA

        if [ "$RESPUESTA" = "s" ] || [ "$RESPUESTA" = "S" ]; then

            read -p "¿Dónde quieres copiarlo? (actual/otra): " DESTINO

            if [ "$DESTINO" = "actual" ]; then
                cp "$RUTA" "./$FICHERO"

                echo "Copia realizada en la carpeta actual."
                echo "Copia realizada en: $(pwd)/$FICHERO" >> "$LOG"

            else
                read -p "Introduce la carpeta de destino: " CARPETA

                # Comprobar que existe la carpeta
                if [ -d "$CARPETA" ]; then
                    cp "$RUTA" "$CARPETA/"

                    echo "Copia realizada en $CARPETA"
                    echo "Copia realizada en: $CARPETA/$FICHERO" >> "$LOG"
                else
                    echo "La carpeta no existe."
                    echo "ERROR: La carpeta $CARPETA no existe." >> "$LOG"
                fi
            fi

        else
            echo "No se ha realizado ninguna copia."
            echo "No se realizó copia." >> "$LOG"
        fi
    fi

    echo "----------------------------------------" >> "$LOG"
done

echo ""
echo "Proceso terminado."
echo "Se ha generado el archivo: $LOG"
