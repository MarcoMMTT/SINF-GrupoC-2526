#!/bin/bash
DB_NAME=$1
OUTPUT="./backup_${DB_NAME}_$(date +%F).sql"

if [ -z "$DB_NAME" ]; then
    echo "Uso: ./backup_db.sh nombre_de_la_db"
else
    mysqldump -u root -p "$DB_NAME" > "$OUTPUT"
    echo "Copia de seguridad guardada en $OUTPUT"
fi