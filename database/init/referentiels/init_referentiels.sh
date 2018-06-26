#!/bin/bash
set -e
set -x

usage(){
	echo "------------------------------------------------------------------------------------------------"
	echo "Script de initialisation des référentiels de la base de données Ginco."
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

dataDir=/var/data
mkdir -p /var/data/download

rootDir=$(dirname $(readlink -f $0))
dataLocalDir=$rootDir/data

refurl=https://ginco.naturefrance.fr/ref

taxref=$dataDir/download/taxrefv11.txt
communes=$dataDir/download/commune_carto_2017.sql
departements=$dataDir/download/departement_carto_2017.sql
regions=$dataDir/download/region_carto_2017.sql
espacesnaturels=$dataDir/download/en_inpn.csv

# Note NV: Il aurait été sympa de pouvoir récupérer n'importe quelle version de
#       taxref et de faire passer les mêmes traitements. Mais finalement, je renonce
#       parce que chaque version de taxref est un peu différente.
if [ -f "$taxref" ]
then
	echo "$taxref a été trouvé localement..."
else
	echo "téléchargement de taxref v11..."
	wget "$refurl/TAXREFv11.0/TAXREFv11.0.txt" -O $taxref --no-verbose
fi
echo "Intégration des données taxref dans la base..."
psql "$connectionStr" -f $rootDir/create_taxref11_tables.sql
copyOptions="NULL '', FORMAT 'csv', HEADER, DELIMITER E'\t', ENCODING 'UTF-8'"
psql "$connectionStr" -c "\COPY referentiels.taxref FROM '$taxref' WITH ($copyOptions);"
echo "Intégration de TAXREF terminée."

echo "Intégration du référentiel de sensiblité et de sa table de métadonnées"
#FIXME: ajouter le téléchargement du référentiel de sensibilité compatible avec le taxref 11!
psql "$connectionStr" -f $dataLocalDir/especesensible.sql
psql "$connectionStr" -f $dataLocalDir/especesensiblelistes.sql

if [ -f "$communes" ]
then
	echo "$communes a été trouvé localement..."
else
	echo "téléchargement de la dernière version des limites administratives (admin express-cog communes carto 2017)..."
	wget "$refurl/commune_carto_2017.sql" -O $communes --no-verbose

fi

if [ -f "$departements" ]
then
	echo "$departements a été trouvé localement..."
else
	echo "téléchargement de la dernière version des limites administratives (admin express-cog départements carto 2017)..."
	wget "$refurl/departement_carto_2017.sql" -O $departements --no-verbose
fi

if [ -f "$regions" ]
then
	echo "$regions a été trouvé localement..."
else
	echo "téléchargement de la dernière version des limites administratives (admin express-cog régions carto 2017)..."
	wget "$refurl/region_carto_2017.sql"      -O $regions --no-verbose
fi

echo "Intégration des limites administratives pour la visu..."
psql "$connectionStr" -f "$communes"
psql "$connectionStr" -f "$departements"
psql "$connectionStr" -f "$regions"
echo "Mise à jour des référentiels des limites administratives terminée."


if [ -f "$espacesnaturels" ]
then
	echo "$espacesnaturels a été trouvé localement..."
else
	echo "téléchargement de la dernière version des espaces naturels (export INPN)..."
	wget "$refurl/espaces_naturels_last.csv" -O $espacesnaturels --no-verbose
fi

echo "Integration du référentiel des espaces naturels..."
psql "$connectionStr" -f $rootDir/espaces_naturels_1.sql
copyOptions="NULL '', FORMAT 'csv', HEADER, DELIMITER E',', ENCODING 'UTF-8'"
psql "$connectionStr" -c "\COPY referentiels.codeentampon  ( codeen, libelleen, typeen, labeltypeen) FROM '$espacesnaturels' WITH ($copyOptions);"
psql "$connectionStr" -f $rootDir/espaces_naturels_2.sql

echo "Création des autres référentiels métier"
psql "$connectionStr" -f $dataLocalDir/codemaillevalue.sql
psql "$connectionStr" -f $dataLocalDir/habref_20.sql

echo "Création des listes de valeurs du standard DEE"
psql "$connectionStr" -f $dataLocalDir/nomenclatures.sql

echo "Création des la liste des référentiels et nomenclatures avec leurs versions"
psql "$connectionStr" -f $dataLocalDir/liste_referentiels.sql

echo "Indexation du tout"
psql "$connectionStr" -f $dataLocalDir/index.sql
