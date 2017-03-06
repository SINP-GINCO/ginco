<?php
$projectDir = dirname(__FILE__);
require_once "$projectDir/lib/share.php";

//------------------------------------------------------------------------------
// Synopsis: build ogam services for GINCO instance defined in config file.
// TODO: could be a gradle script.
//------------------------------------------------------------------------------

function usage($mess=NULL){
	echo "------------------------------------------------------------------------\n";
	echo("\nbuild ogam services for GINCO instance\n");
	echo("> php build_ginco_services.php -f configFile [{-D<propertiesName>=<Value>}]\n\n");
	echo "o configFile: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)){
		echo("$mess\n\n");
		exit(1);
	}
	exit;
}

if (count($argv)==1) usage();

$config=loadPropertiesFromArgs();

// Build des services
// ======================
// on les range dans ./build/services

echo("clean...\n");
$buildDir = "$projectDir/build";
if (is_dir("$buildDir")) {
	system("rm -fr $buildDir");
}
mkdir($buildDir, 0777, true);


$servicesBuildDir="$buildDir/services";
mkdir($servicesBuildDir, 0777, true);
mkdir("$servicesBuildDir/webapps", 0777, true);
mkdir("$servicesBuildDir/conf", 0777, true);

propertiesToFile($config, "$buildDir/config.properties");


// build du service d'intégration
echo("Building integration service...\n");
substituteInFile("$projectDir/services_configs/service_integration/log4j_tpl.properties", 
                 "$projectDir/ogam/service_integration/config/log4j.properties", $config);
chdir("$projectDir/ogam");
system("./gradlew service_integration:war");
	# le war se trouve dans ${ogamDir}/service_integration/build/libs/service_integration-3.0.0.war

copy("$projectDir/ogam/service_integration/build/libs/service_integration-3.0.0.war", 
     "$servicesBuildDir/webapps/SINP{$config['instance.name']}IntegrationService.war");
substituteInFile("$projectDir/services_configs/service_integration/IntegrationService_tpl.xml", 
                 "$servicesBuildDir/conf/SINP{$config['instance.name']}IntegrationService.xml", $config);

//build du service de rapport
echo("Building report service...\n");
// remplacement des rapports par défaut d'ogam par le rapport d'erreur GINCO
array_map('unlink', glob("$projectDir/ogam/service_generation_rapport/report/*"));
copy("$projectDir/services_configs/service_generation_rapport/ErrorReport.rptdesign",
     "$projectDir/ogam/service_generation_rapport/report/ErrorReport.rptdesign");
// build
chdir("$projectDir/ogam");
#system("./gradlew service_generation_rapport:war");
	# le war contenant les rapports se trouve dans 
	# ${ogamDir}/service_generation_rapport/build/libs/service_generation_rapport-3.0.0.war
	# En fait, la target war ne fonctionne pas correctement pour ce service. Il faut utiliser
	# la target deploy à la place (en attendant que ce soit corrigé)
#mkdir("$buildDir/tmp");
system("./gradlew service_generation_rapport:addReports");
	# Le war se retrouve dans build/tmp/webapps/OGAMRG.war
	# Le xml dans ...
copy("$projectDir/ogam/service_generation_rapport/build/libs/OGAMRG.war", 
     "$servicesBuildDir/webapps/SINP{$config['instance.name']}RGService.war");
substituteInFile("$projectDir/services_configs/service_generation_rapport/ReportService_tpl.xml", 
                 "$servicesBuildDir/conf/SINP{$config['instance.name']}RGService.xml", $config);

/*
// build du service Géosource
echo("Building geosource...\n");
copy("$projectDir/service_geosource/geosource.war", "$servicesBuildDir/webapps/geosource.war");
// on dezippe le war pour modifier sa conf.
chdir("$servicesBuildDir/webapps");
system("unzip -q geosource.war");
unlink("geosource.war");
// adaptation de la config geosource
unlink("geosource/WEB-INF/config-node/srv.xml");
copy("$projectDir/service_geosource/srv.xml", "./geosource/WEB-INF/config-node/srv.xml");
substituteInFile("$projectDir/service_geosource/jdbc_tpl.properties", 
                 "$servicesBuildDir/webapps/geosource/WEB-INF/config-db/jdbc.properties", 
                 ['geosource.db.user' => 'geosource', 'geosource.db.user.pw' => 'geosource'] + $config);

chdir("$servicesBuildDir/webapps/geosource");
system("zip -r -q ../geosource.war ./");
chdir("$servicesBuildDir/webapps");
system("rm -r $servicesBuildDir/webapps/geosource");

mkdir("$buildDir/confEnvJava", 0777, true);
copy("$projectDir/service_geosource/setenv.sh", "$buildDir/confEnvJava/setenv.sh");
*/

# Build du SITE WEB 
#=======================
# on range tout dans ./build/website
echo("building website (php)...\n");
mkdir("$buildDir/website", 0777, true);
symlink("$projectDir/ogam/website/htdocs/client","$projectDir/website/htdocs/client");
symlink("$projectDir/ogam/website/htdocs/server","$projectDir/website/htdocs/server");
symlink("$projectDir/ogam/website/htdocs/public","$projectDir/website/htdocs/public");
mkdir("$projectDir/website/htdocs/logs");

system("cp -r -L $projectDir/website/htdocs/* $buildDir/website");
// FIXME: la creation des répertoires est-elle vraiment utile?
mkdir("$buildDir/website/sessions");
// L'installeur remplace les répertoires suivants par des liens symboliques vers /var/data/ginco/...
mkdir("$buildDir/website/tmp");
// mkdir("$buildDir/website/tmp/database");
// mkdir("$buildDir/website/tmp/language");
mkdir("$buildDir/website/upload");
mkdir("$buildDir/website/dee");


// ajout de la version du build dans le template du site
$currentBranch = system("git rev-parse --abbrev-ref HEAD");
$versionInfo   = $currentBranch . ' ' . date('d/m/o G:i:s');
$layoutFile="$buildDir/website/custom/server/ogamServer/app/layouts/scripts/layout.phtml";
substituteInFile($layoutFile, $layoutFile, ['build.version' => $versionInfo]);

// Piwik
$piwikTrackingFile="$buildDir/website/custom/server/ogamServer/app/layouts/scripts/piwik.html";
substituteInFile($piwikTrackingFile, $piwikTrackingFile, $config);

// adaptation du application.ini à la config de l'instance.
$appConfDir="$buildDir/website/custom/server/ogamServer/app/configs";
substituteInFile("$appConfDir/application.ini.tpl", "$appConfDir/application.ini", $config);
unlink("$appConfDir/application.ini.tpl");

// installation des dépendances Composer
chdir("$buildDir/website/custom/server/ogamServer/app");
system("bash build.sh --no-interaction");

// partie extjs
echo("building website (extJs)...\n");
$clientDir = "$projectDir/website/htdocs/custom/client/ogamDesktop";
substituteInFile("$clientDir/app_tpl.json", 
                 "$buildDir/website/client/ogamDesktop/app.json", $config);
substituteInFile("$clientDir/index.html","$buildDir/website/custom/client/ogamDesktop/index.html", $config);
chdir("$buildDir/website/client/ogamDesktop/");
system("sencha app upgrade");
system("sencha app build");

# Customize Mapfile
echo("building mapfile...\n");
mkdir("$buildDir/mapserver", 0777, true);
substituteInFile("$projectDir/mapserver/ginco_tpl.map", 
                 "$buildDir/mapserver/ginco_{$config['instance.name']}.map", $config);
system("cp -r $projectDir/mapserver/data $buildDir/mapserver/");

# Customize Apache Configuration
# on la range dans ./build/confapache
echo("building apache config...\n");
mkdir("$buildDir/confapache", 0777, true);
substituteInFile("$projectDir/website/config/httpd_ginco_apache2_tpl.conf",
                 "$buildDir/confapache/httpd_ginco_{$config['instance.name']}.conf", 
                 $config + ['app.env' => 'production']);


# Build of configurator
#=======================
# le code du configurateur a été récupéré dans build/configurator
echo("building configurator...\n");
system("cp -r $projectDir/configurator $buildDir");
chdir("$buildDir/configurator");
system("bash build.sh --no-interaction");

substituteInFile("$buildDir/configurator/app/config/parameters.yml.dist",
                 "$buildDir/configurator/app/config/parameters.yml",
                 ['host'       => $config['db.host'],
                  'port'       => $config['db.port'],
                  'db'         => $config['db.name'],
                  'user'       => $config['db.user'],
                  'pw'         => $config['db.user.pw'],
                  'admin_user' => $config['db.adminuser'],
                  'admin_pw'   => $config['db.adminuser.pw'],
                  'base_url'   => '/configurateur'], 
                 '__');

# on supprime le cache qui a été initialisé avec les mauvaises valeurs et les mauvais chemins.
system("rm -r $buildDir/configurator/app/cache/prod");

system("chmod -R a+w $buildDir");