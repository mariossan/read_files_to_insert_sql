#!/bin/bash

echo $(date)

#se hace la lectura de directorios y se muestran
base_dir="/home/mariossan/Documents/Alkemy/botin_de_lays"
SQL="SQL2"
search_dir="$base_dir/CODIGOS_FINALES_v2"

for entry in "$search_dir"/*
do
    #se obtuene la ruta del nuevo directorio
    new_dir="$entry"

    #nombre de la product en cuestion
    product=$(echo "$entry" | cut -c 67-)
    
    #echo $product
    #exit 1
    
    #se crea un archivo .sql con las adecuaciones necesarias
    cd "$base_dir/";
    touch "$SQL/$product.sql"

    #Lectura de directios internos para poder leer el archivo interno
    for foldercode in "$new_dir"/*
    do
        #file_to_be_created="$(echo "$foldercode" | cut -d'/' -f 8)"
        echo "insert ignore into codes(code,product) values" >> "$SQL/$product.sql"
        file_to_read="$foldercode/CLARiTY Data File.txt"

        n=1
        total=$(wc -l "$file_to_read" | awk '{ print $1 }')

        while  IFS= read -r line; do
            # reading each line
            if [ "$n" -lt "$total" ]; 
                then
                    echo "('$line', '$product')," >> "$SQL/$product.sql"
                else 
                    echo "('$line', '$product');" >> "$SQL/$product.sql"
            fi
            n=$((n+1))
        done < $file_to_read
    done

    #una vez creado el archivo lo parseo para quitar las coasas no necesarias
    #sed 's/\\r//g' "$SQL/$product.sql" > "$SQL/$product.sql_v2"

    tr -d "\n\r" < "$SQL/$product.sql" > "$SQL/$product.sql_v2"
    rm "$SQL/$product.sql"
    mv "$SQL/$product.sql_v2" "$SQL/$product.sql"

    echo $(date)

    #se hace el insert de un nuevo archivo para poder tener los inserts de cada sql
    echo "mysql -u root -proot botin_de_lays < $product.sql &&" >> "$SQL/to_insert.sql"
done