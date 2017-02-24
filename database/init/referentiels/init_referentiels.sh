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
rootDir=$(dirname $(readlink -f $0))
dataDir=$rootDir/data

taxref=$dataDir/download/taxrefv10.txt
communes=$dataDir/download/visu_communes_geofla_2015.1.sql
departements=$dataDir/download/visu_departements_geofla_2015.1.sql
regions=$dataDir/download/visu_regions_geofla_2015.1.sql

# Note NV: Il aurait été sympa de pouvoir récupérer n'importe quelle version de
#       taxref et de faire passer les mêmes traitements. Mais finalement, je renonce
#       parce que chaque version de taxref est un peu différente.
if [ -f "$taxref" ]
then
	echo "$taxref a été trouvé localement..."
else
	echo "téléchargement de taxref v10..."
	wget "https://ginco.ign.fr/ref/TAXREFv10.0/TAXREFv10.0.txt" -O $taxref --no-verbose
fi
echo "Intégration des données taxref dans la base..."
psql "$connectionStr" -f $rootDir/create_taxref10_tables.sql
copyOptions="NULL '', FORMAT 'csv', HEADER, DELIMITER E'\t', ENCODING 'UTF-8'"
psql "$connectionStr" -c "\COPY referentiels.taxref FROM '$taxref' WITH ($copyOptions);"
echo "Intégration de TAXREF terminée."

echo "Intégration du référentiel de sensiblité et de sa table de métadonnées"
#FIXME: ajouter le téléchargement du référentiel de sensibilité compatible avec le taxref 10!
psql "$connectionStr" -f $dataDir/especesensible.sql
psql "$connectionStr" -f $dataDir/especesensiblelistes.sql

if [ -f "$communes" ]
then
	echo "$communes a été trouvé localement..."
else
	echo "téléchargement de la dernière version des limites administratives (geoFLA communes)..."
	wget "https://ginco.ign.fr/ref/geofla_last_communes.sql" -O $communes --no-verbose

fi

if [ -f "$departements" ]
then
	echo "$departements a été trouvé localement..."
else
	echo "téléchargement de la dernière version des limites administratives (geoFLA départements)..."
	wget "https://ginco.ign.fr/ref/geofla_last_departements.sql" -O $departements --no-verbose
fi

if [ -f "$regions" ]
then
	echo "$regions a été trouvé localement..."
else
	echo "téléchargement de la dernière version des limites administratives (geoFLA régions)..."
	wget "https://ginco.ign.fr/ref/geofla_last_regions.sql"      -O $regions --no-verbose
fi

echo "Intégration des limites administratives pour la visu..."
psql "$connectionStr" -f "$communes"
psql "$connectionStr" -f "$departements"
psql "$connectionStr" -f "$regions"
echo "Mise à jour des référentiels des limites administratives terminée."

echo "Création des autres référentiels métier"
psql "$connectionStr" -f $dataDir/codeenvalue.sql
psql "$connectionStr" -f $dataDir/codemaillevalue.sql
psql "$connectionStr" -f $dataDir/habref_20.sql

echo "Création des listes de valeurs du standard DEE"
psql "$connectionStr" -f $dataDir/nomenclatures.sql

echo "Indexation du tout"
psql "$connectionStr" -f $dataDir/index.sql
