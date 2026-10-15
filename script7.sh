
#!/bin/bash

# Leemos los usuarios del sistema
while IFS=: read -r nombre x uid gid comentario carpeta shell; do

    # Comprobamos si puede iniciar sesion
    if [[ "$shell" != */nologin && "$shell" != */false && -n "$shell" ]]; then

        echo "Nombre de usuario: $nombre"
        echo "Carpeta personal: $carpeta"
        echo "Shell por defecto: $shell"
        echo ""

    fi

done < /etc/passwd
