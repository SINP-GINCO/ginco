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


echo "Mise à jour de TAXREF vers la V9..."
#psql "$connectionStr" -c "DROP TABLE IF EXISTS referentiels.taxref;"
#psql "$connectionStr" -c "DROP TABLE IF EXISTS referentiels.taxref_rang;"
#psql "$connectionStr" -c "DROP TABLE IF EXISTS referentiels.taxref_statut;"
psql "$connectionStr" -f $rootDir/create_taxref_tables.sql

copyOptions="NULL '', FORMAT 'csv', HEADER, DELIMITER E'\t', ENCODING 'UTF-8'"
psql "$connectionStr" -c "\COPY referentiels.taxref FROM '$dataDir/TAXREFv9.0/TAXREFv90.txt' WITH ($copyOptions);"
# FIXME: Attention, ici il est nécessaire que le schéma metadata existe!
# psql "$connectionStr" -f $rootDir/populate_mode_taxref_table.sql
echo "Mise à jour de TAXREF vers la V9 terminée."

echo "Mise à jour des référentiels des limites administratives (source GeoFLA 2015.1)..."
#psql "$connectionStr" -c "DROP TABLE IF EXISTS referentiels.communes CASCADE;"
#psql "$connectionStr" -c "DROP TABLE IF EXISTS referentiels.departements CASCADE;"
#psql "$connectionStr" -c "DROP TABLE IF EXISTS referentiels.regions CASCADE;"
psql "$connectionStr" -f $dataDir/GEOFLAv2015.1/geofla_v2015.1_communes.sql
psql "$connectionStr" -f $dataDir/GEOFLAv2015.1/geofla_v2015.1_departements.sql
psql "$connectionStr" -f $dataDir/GEOFLAv2015.1/geofla_v2015.1_regions.sql
echo "Mise à jour des référentiels des limites administratives terminée."

echo "Création des autres référentiels métier"
psql "$connectionStr" -f $dataDir/codeenvalue.sql
psql "$connectionStr" -f $dataDir/codemaillevalue.sql
psql "$connectionStr" -f $dataDir/especesensible.sql
psql "$connectionStr" -f $dataDir/habref_20.sql

echo "Création des listes de valeurs du standard DEE"
psql "$connectionStr" -f $dataDir/nomenclatures.sql

echo "Indexation du tout"
psql "$connectionStr" -f $dataDir/index.sql
