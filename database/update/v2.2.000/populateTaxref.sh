#!/bin/bash
set -e
set -x

usage(){
	echo "-------------------------------------------------------------------------------------------------"
	echo "Script de initialisation de taxref dans la base de données Ginco."
	echo "-------------------------------------------------------------------------------------------------"
	echo " $0 <chaine de connexion postgreSQL>"
	echo
	echo " * <chaine de connexion postgreSQL> : Une liste d'argument de la forme:"
	echo "      host=localhost port=<port> user=<user> password=<pwd> dbname=<db> ..."
	echo "-------------------------------------------------------------------------------------------------"
	exit 0
}

# Analyse des paramètres
if [[ $# -eq 0 ]]; then
	usage
fi

#connectionStr="host=localhost port=$PORT_DB user=${db_adminuser} password=${db_adminuser_pw} dbname=${db_name}"
connectionStr=$@
rootDir=$(dirname $(readlink -f $0))
downloadDir=/var/data/download
mkdir -p $downloadDir

refurl=https://ginco.naturefrance.fr/ref
taxref=$downloadDir/taxrefv11.txt

if [ -f "$taxref" ]
then
	echo "$taxref a été trouvé localement..."
else
	echo "téléchargement de taxref v11..."
	wget "$refurl/TAXREFv11/TAXREFv11.txt" -O $taxref --no-verbose
fi
echo "Intégration des données taxref dans la base..."
copyOptions="NULL '', FORMAT 'csv', HEADER, DELIMITER E'\t', ENCODING 'UTF-8'"
psql "$connectionStr" -c "\COPY referentiels.taxref FROM '$taxref' WITH ($copyOptions);"
echo "Intégration de TAXREF terminée."