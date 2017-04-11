#!/bin/bash

# variaveis básicas
mysqlpass="senha_root_aqui"
bucket="s3://backupdb"
tabela="nome_da_tabela"


# Armazena a data na variavel stamp
stamp=$(date +%F)

databases=`mysql -u root -p$mysqlpass -N -B -e "SHOW tables from $tabela;" | tr -d "| "`

# Feedback
echo -e "Gerando dump..."

# Cria o laço pra pegar as tabelas da base
for db in $databases; do
  filename="$stamp - $db.sql.gz"
  tmpfile="/tmp/$filename"
  object="$bucket/$stamp/$filename"

  # Dump e compacta
  mysqldump -u root -p$mysqlpass --skip-comments --compact $tabela "$db" | gzip -c > "$tmpfile"

  # Upload
  echo -e "  fazendo upload..."
  s3cmd put "$tmpfile" "$object"

  # Delete
  rm -f "$tmpfile"

done;
