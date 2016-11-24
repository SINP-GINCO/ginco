<?php

$initDir = dirname(__FILE__);
require_once "$initDir/../../lib/share.php";

#-------------------------------------------------------------------------------
# Synopsis: Create a database from scratch for GINCO.
#           Parameters are filed in a properties file.
#
# FIXME: system calls to psql could be replaced by a php stuff.
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
function usage($mess=NULL){
	echo "------------------------------------------------------------------------\n";
	echo("\nCreate and initiate the DB for the configuration:\n");
	echo("> create_db -f <configFile> [{-D<propertiesName>=<Value>}]\n\n");
	echo "o <configFile>: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)){
		echo("$mess\n\n");
		exit(1);
	}
	exit;
}

#-------------------------------------------------------------------------------
# MAIN
#-------------------------------------------------------------------------------

# parameters' analyze
if (count($argv)==1) usage();

# get config
$config = loadPropertiesFromArgs();
$paramStr = implode(' ', array_slice($argv, 1));

$initDir     = dirname(__FILE__);
$metadataDir = "$initDir/../metadata"; # FIXME: ce répertoire doit bouger!
$refDir      = "$initDir/referentiels";

echo("Création de la base de données\n");
# dropdb $db_name -h $host -p $port -U $db_adminuser --if-exists
#FIXME je ne comprends pas pourquoi je suis obligé de fixer tout ça pour docker.
system("createdb {$config['db.name']} -h {$config['db.host']} -p {$config['db.port']} -U {$config['db.adminuser']} -E UTF8 -T template0");
#psql "host=$host port=$port user=$db_adminuser password=$db_adminuser_pw dbname=postgres" -v db_name=$db_name -f ${initDir}/0-Create_bdd.sql
execSQLFile("$initDir/0-add_extensions.sql",$config);
execSQLFile("$initDir/0-Create_user.sql",$config, false);

echo ("Création des schémas\n");
# creation du schema referentiels
execSQLFile("$initDir/3-0-Create_referentiels_schema.sql",$config);
#FIXME: on avait dit pas de shell dans demo-sinp...
$connectStr ="host="     .$config['db.host'];
$connectStr.=" port="    .$config['db.port'];
$connectStr.=" user="    .$config['db.adminuser'];
$connectStr.=" password=".$config['db.adminuser.pw'];
$connectStr.=" dbname="  .$config['db.name'];
system("$refDir/init_referentiels.sh $connectStr");

# setting metadata and metadata_work schema
execCustSQLFile("$initDir/create_metadata_schema_tpl.sql", $config + ['schema' => 'metadata']);
# note: populate_mode_taxref_table need an initialized referentiel schema.
execSQLFile("$initDir/populate_mode_taxref_table.sql",$config);
# FIXME: serait-il possible de laisser le méta-modèle de prod vide lors de la livraison?
system("php $initDir/metadata/import_metadata_from_csv.php $paramStr -Dschema=metadata");

execCustSQLFile("$initDir/create_metadata_schema_tpl.sql", $config + ['schema' => 'metadata_work']);
# mode_taxref is not usefull in metadata_work.
# execCustSQLFile("$initDir/populate_mode_taxref_table_tpl.sql", $config + ['schema' => 'metadata_work']);
system("php $initDir/metadata/import_metadata_from_csv.php $paramStr -Dschema=metadata_work");


execSQLFile("$initDir/1-2-Create_mapping_schema.sql",$config);
execSQLFile("$initDir/1-3-Create_website_schema.sql",$config);
execSQLFile("$initDir/1-4-Create_raw_data_schema.sql",$config);

execCustSQLFile("$initDir/4-create_geosource_schema_tpl.sql",$config,false);
execSQLFile("$initDir/2-Ogam_permissions.sql",$config);
execSQLFile("$initDir/2-Set_search_path.sql",$config);
execCustSQLFile("$initDir/3-Update_application_parameters_tpl.sql",$config);
execCustSQLFile("$initDir/3-Update_mapping_schema_tpl.sql",$config);
execSQLFile("$initDir/3-Init_roles.sql",$config);
execCustSQLFile("$initDir/3-Update_predefined_requests.sql",$config);

# set ginco_version from the last update directory
$updateDir = "$initDir/../update";
$sprintList = glob("$updateDir/sprint*",GLOB_ONLYDIR);
$lastUpdate = basename(array_pop($sprintList));
execCustSQLFile("$initDir/3-Update_ginco_version.sql", $config + ["ginco.version" => $lastUpdate]);

echo("Database {$config['db.name']} created.\n");
