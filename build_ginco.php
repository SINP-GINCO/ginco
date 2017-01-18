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

// TODO Build des services
// ======================
// on les range dans ./build/services
function buildJavaServices($config, $buildMode)
{
	echo("clean...\n");
	$buildDir = "$projectDir/build";
	if (is_dir("$buildDir")) {
		system("rm -fr $buildDir");
	}
	mkdir($buildDir, 0777, true);


	$servicesBuildDir = "$buildDir/services";
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
	echo("Building repport service...\n");
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
}

# TODO Build du SITE WEB
#=======================
# on range tout dans ./build/website
function buildWebsite($config, $buildMode)
{
    global $projectDir, $buildDir;

    echo("building server (symfony)...\n\n");
    echo("----------------------------\n");

    $serverDirOgam = $config['ogam.path'] . "/website/htdocs/server";
    $buildServerDir = $buildDir . "/website/server" ;
    is_dir($buildServerDir) || mkdir($buildServerDir, 0755, true);

    // Copy configurator files if in prod mode
    if ($buildMode == 'prod') {
        echo("Copying ginco server directory project to $buildServerDir...\n");
        system("cp -r $projectDir/website/server/* $buildServerDir/");
    }

    // Copy or symlink OgamBundle
    if ($buildMode == 'prod') {
        echo("Copying OGAMBundle to $buildServerDir/src/Ign/Bundle/...\n");
        system("cp -r $serverDirOgam/src/Ign/Bundle/OGAMBundle $buildServerDir/src/Ign/Bundle/");
    } else {
        echo("Creating a symlink to OGAMBundle in $buildServerDir/src/Ign/Bundle/...\n");
        system("rm -rf $buildServerDir/src/Ign/Bundle/OGAMBundle");
        system("ln -s $serverDirOgam/src/Ign/Bundle/OGAMBundle $buildServerDir/src/Ign/Bundle/OGAMBundle");
    }

    chdir("$buildServerDir");
    if ($buildMode == 'prod') {
        echo("Executing build.sh...\n");
        system("bash build.sh --no-interaction");
    } else {
        echo("Executing build.sh...\n");
        system("bash build_dev.sh --no-interaction");
    }

    echo("Filling parameters.yml with configuration parameters...\n");
    substituteInFile(
        "$buildServerDir/app/config/parameters.yml.dist",
        "$buildServerDir/app/config/parameters.yml",
        ['host' => $config['db.host'],
            'port' => $config['db.port'],
            'db' => $config['db.name'],
            'user' => $config['db.user'],
            'pw' => $config['db.user.pw'],
            'admin_user' => $config['db.adminuser'],
            'admin_pw' => $config['db.adminuser.pw'],
            ],
        '__'
    );

    # on supprime le cache qui a été initialisé avec les mauvaises valeurs et les mauvais chemins.
    if ($buildMode == 'prod') {
        echo("Clearing /app/cache/prod (wrong values)...\n");
        system("rm -r $buildServerDir/app/cache/prod");
    }

    echo("Done building server (symfony).\n\n");

    // ------------------------------------------------
    // todo reprendre le code à partir d'ici


	global $projectDir;

	echo("");

	mkdir("$buildDir/website", 0777, true);
	symlink("$projectDir/ogam/website/htdocs/client", "$projectDir/website/htdocs/client");
	symlink("$projectDir/ogam/website/htdocs/server", "$projectDir/website/htdocs/server");
	symlink("$projectDir/ogam/website/htdocs/public", "$projectDir/website/htdocs/public");
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
	$versionInfo = $currentBranch . ' ' . date('d/m/o G:i:s');
	$layoutFile = "$buildDir/website/custom/server/ogamServer/app/layouts/scripts/layout.phtml";
	substituteInFile($layoutFile, $layoutFile, ['build.version' => $versionInfo]);

	// Piwik
	$piwikTrackingFile = "$buildDir/website/custom/server/ogamServer/app/layouts/scripts/piwik.html";
	substituteInFile($piwikTrackingFile, $piwikTrackingFile, $config);

	// adaptation du application.ini à la config de l'instance.
	$appConfDir = "$buildDir/website/custom/server/ogamServer/app/configs";
	substituteInFile("$appConfDir/application.ini.tpl", "$appConfDir/application.ini", $config);
	unlink("$appConfDir/application.ini.tpl");

	// installation des dépendances Composer
	chdir("$buildDir/website/custom/server/ogamServer/app");
	system("bash build.sh --no-interaction");
}

// partie extjs
function buildExtJS($config, $buildMode)
{
	global $projectDir, $buildDir;

	echo("building client (extJs)...\n");
	echo("--------------------------\n");

	$clientDir = "$projectDir/website/client";
	$clientDirOgam = $config['ogam.path'] . "/website/htdocs/client";
	$buildClientDir = $buildDir . "/website/client" ;
	is_dir($buildClientDir) || mkdir($buildClientDir, 0755, true);

	// Copy ext and ogam code to project
	echo("Copying ext and ogam code from ogam project...\n");
	system("cp -r $clientDirOgam/ext $clientDir");
	system("cp -r $clientDirOgam/packages $clientDir");
	system("cp -r $clientDirOgam/ogamDesktop $clientDir");
	system("cp -r $clientDirOgam/.sencha $clientDir");
	system("cp $clientDirOgam/workspace.json $clientDir");

	// Customize app.json and index.html
	echo("Customize app.json...\n");
	substituteInFile("$clientDir/gincoDesktop/app_tpl.json", "$clientDirOgam/ogamDesktop/app.json", $config);
	// in dev mode, keep original file
	if ($buildMode == 'dev') {
		system("cp $clientDir/gincoDesktop/index.html $clientDir/gincoDesktop/index.html.keep");
	}
	echo("Customize index.html...\n");
	substituteInFile("$clientDir/gincoDesktop/index.html", "$clientDir/gincoDesktop/index.html", $config);

	// Build with sencha command
	echo("Upgrade sencha command...\n");
	chdir("$clientDir/ogamDesktop/");
	system("sencha app upgrade");
	if ($buildMode == 'dev') {
		echo("Build with sencha command in dev environment...\n\n");
		system("sencha app build development");
	}
	// Always build (also) in prod environment
	echo("Build with sencha command in prod environment...\n\n");
	system("sencha app build");

	// Clean up
	if ($buildMode == 'dev') {
		echo("Cleaning up...\n");
		// Delete code : all but gincoDesktop
		chdir($clientDir);
		system("rm -rf .sencha ext ogamDesktop packages workspace.json");
		// Restore index.html in dev mode
		system("mv $clientDir/gincoDesktop/index.html.keep $clientDir/gincoDesktop/index.html");
	}
	// Prod mode: mv build directory to $buildDir
	else {
		echo("Moving build files to $buildClientDir...\n");
		system("mv $clientDir/build $buildClientDir/");
	}
	echo("Done building client (extJs).\n\n");
}

# Customize Mapfile
function buildMapfile($config, $buildMode)
{
	global $projectDir, $buildDir;

	echo("building mapfile...\n");
	echo("-------------------\n");

	$buildMapserverDir = $buildDir . "/mapserver";

	// Same effect as if ($buildMode=='prod')
	if ( !is_dir($buildMapserverDir) ) {
		echo("Creating $buildMapserverDir directory...\n");
		mkdir($buildMapserverDir, 0755, true);
		system("cp -r $projectDir/mapserver/data $buildMapserverDir");
	}
	echo("Creating mapfile: $buildMapserverDir/ginco_{$config['instance.name']}.map...\n");
	substituteInFile("$projectDir/mapserver/ginco_tpl.map", "$buildMapserverDir/ginco_{$config['instance.name']}.map", $config);
	echo("Done building mapfile.\n\n");
}

# on la range dans ./build/confapache
function buildApacheConf($config, $buildMode)
{
	global $projectDir, $buildDir, $postBuildInstructions;

	echo("building apache config...\n");
	echo("-------------------------\n");

	$confapacheBuildDir = "$buildDir/confapache";
	// Same effect as if ($buildMode=='prod')
	if ( !is_dir($confapacheBuildDir) ) {
		echo("Creating $confapacheBuildDir directory...\n");
		mkdir($confapacheBuildDir, 0755, true);
	}

	$buildConfFile = "$confapacheBuildDir/ginco_{$config['instance.name']}.conf";
	echo("Creating apache configuration file: $buildConfFile...\n");

	substituteInFile("$projectDir/confapache/ginco_apache2_tpl_$buildMode.conf", $buildConfFile, $config);

	if ($buildMode == 'dev') {
		$postBuildInstructions[] = "Apache configuration file has been built: $buildConfFile\n";
		$postBuildInstructions[] = "To install, do:\n\n";
		$postBuildInstructions[] = "sudo cp $buildConfFile /etc/apache2/sites-available/\n";
		$postBuildInstructions[] = "sudo a2ensite " . pathinfo($buildConfFile, PATHINFO_BASENAME) . "\n";
		$postBuildInstructions[] = "sudo service apache2 reload\n\n";
	}

	echo("Done building apache config.\n\n");
}


# le code du configurateur a été récupéré dans build/configurator
function buildConfigurator($config, $buildMode)
{
    global $buildDir;

	echo("building configurator...\n");
	echo("------------------------\n");

    $configuratorDir = $config['configurator.path'];
    $buildConfiguratorDir = ($buildMode == 'dev') ? $configuratorDir : $buildDir . "/configurator" ;
    is_dir($buildConfiguratorDir) || mkdir($buildConfiguratorDir, 0755, true);

    // Copy configurator files if in prod mode
    if ($buildMode == 'prod') {
        echo("Copying configurator project to $buildConfiguratorDir...\n");
        system("cp -r $configuratorDir/* $buildConfiguratorDir/");
    }

	chdir("$buildConfiguratorDir");
	if ($buildMode == 'prod') {
	    echo("Executing build.sh...\n");
        system("bash build.sh --no-interaction");
    } else {
        echo("Executing build.sh...\n");
        system("bash build_dev.sh --no-interaction");
    }

    echo("Filling parameters.yml with configuration parameters...\n");
	substituteInFile("$buildConfiguratorDir/app/config/parameters.yml.dist",
		"$buildConfiguratorDir/app/config/parameters.yml",
		['host' => $config['db.host'],
			'port' => $config['db.port'],
			'db' => $config['db.name'],
			'user' => $config['db.user'],
			'pw' => $config['db.user.pw'],
			'admin_user' => $config['db.adminuser'],
			'admin_pw' => $config['db.adminuser.pw'],
			'base_url' => '/configurateur'],
		'__');

	# on supprime le cache qui a été initialisé avec les mauvaises valeurs et les mauvais chemins.
    if ($buildMode == 'prod') {
        echo("Clearing /app/cache/prod (wrong values)...\n");
        system("rm -r $buildConfiguratorDir/app/cache/prod");
    }

    echo("Done building configurator.\n\n");
}

// todo: j'en fais quoi de ça ?
// system("chmod -R a+w $buildDir");

//------------------------------------------------------------------------------------------------------

if (count($argv)==1) usage();

// Get configuration and build options

$shortOpts = "f:"; // Name of config file
$shortOpts .= "D::"; // Overwrite config options

// Order of tasks listed here is important: they will be run that order
$tasksOptions  = array(
	"java",		// Build java services
	"website",		// Build ginco website
	"ext",		// Build extJS client
	"mapfile",		// Build mapfile
	"apacheconf",		// Build apache configuration file
	"configurator",		// Build configurator website
);
$otherOptions = array(
	"mode::",     	// Development mode: symlinks instead of copy files
);
$longOpts = array_merge($tasksOptions,$otherOptions);

$params = getopt($shortOpts, $longOpts);
//var_dump($params);

if (!isset($params['f']) || empty($params['f']))
	usage();

// Get configuration parameters
$config=loadPropertiesFromArgs();
// var_dump($config);

// Get tasks to execute
$tasks = array();
foreach ($tasksOptions as $task) {
	if (isset($params[$task])) {
		$tasks[] = $task;
	}
}
// If no task given, build all
if (count($tasks) == 0) {
	$tasks = $tasksOptions;
}
//var_dump($tasks);

// Mode: development or prod
$buildMode = (isset($params['mode']) && $params['mode']=='prod') ? 'prod' : 'dev';

// build dir: where to put resulting builded files
$buildDir = ($buildMode == 'prod') ? "$projectDir/build" : $projectDir;

// deploy dir: the path of the ginco application once deployed on target machine
$deployDir = ($buildMode == 'prod') ? "/var/www/" . $config['instance.name'] : $projectDir;
$config['deploy.dir'] = $deployDir;

// Post build instructions in dev mode
$postBuildInstructions = array();

// Execute tasks
if (in_array('java', $tasks)) {
	buildJavaServices($config, $buildMode);
}
if (in_array('website', $tasks)) {
	buildWebsite($config, $buildMode);
}
if (in_array('ext', $tasks)) {
	buildExtJS($config, $buildMode);
}
if (in_array('mapfile', $tasks)) {
	buildMapfile($config, $buildMode);
}
if (in_array('apacheconf', $tasks)) {
	buildApacheConf($config, $buildMode);
}
if (in_array('configurator', $tasks)) {
	buildConfigurator($config, $buildMode);
}
echo ("Build finished build_ginco.php.\n\n");


// Show post-build instructions
if (count($postBuildInstructions) > 0) {
	echo("Post-build installation instructions:\n");
	echo("=====================================\n\n");
	foreach($postBuildInstructions as $instruction) {
		echo($instruction);
	}
}

