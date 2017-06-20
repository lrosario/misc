#!/bin/bash
#Script escrito por Leonardo Rosário 
#Email me: contato@auditoriahacker.com

echo "Wordpress Cloner por Leonardo Rosário contato@auditoriahacker.com"
sleep 2
echo "Qual o site você quer clonar? (coloque o endereço completo sem www.)"
read sitea
echo "Qual site você gostaria de substituir? (coloque o endereço completo sem www.)"
read siteb
echo "Checando se o diretorio existe"
DIR="/var/www/$sitea/htdocs"
DIR2="/var/www/$siteb/htdocs"
DB1="/var/www/$sitea"
DB2="/var/www/$siteb"
# verifica se o diretorio existe e copia todos os arquivos.
if [ "$(ls -A $DIR)" ]; then
     echo "Copiando arquivos..."
     cp -rav $DIR $DIR2 >> /dev/null
     echo "Arquivos copiados."
else
    echo "$DIR está vazio"
    exit
fi
echo "Copiando o banco de dados.."
cd $DB1
DBNAME1=`cat wp-config.php | grep DB_NAME | cut -d \' -f 4`
cd $DB2
DBNAME2=`cat wp-config.php | grep DB_NAME | cut -d \' -f 4`
mysqldump --opt --force $DBNAME1 > /tmp/$sitea.sql
mysql $DBNAME2 < /tmp/$sitea.sql
rm -rf /tmp/$sitea.sql
read -p "Deseja substituir o nome do site no banco? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
	cd $DIR2
	wp --allow-root search-replace $sitea $siteb
else 
	echo "Você agora precisa modificar as entradas manualmente."
fi
