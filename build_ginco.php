<?php
$projectDir = dirname(__FILE__);
require_once "$projectDir/lib/share.php";

//------------------------------------------------------------------------------
// Synopsis: build ogam services for GINCO instance defined in config file.
//------------------------------------------------------------------------------

function usage($mess=NULL){
	echo "------------------------------------------------------------------------\n";
	echo "\nBuild Ginco services and website\n";
	echo "> php build_ginco.php -f configFile [{-D<propertiesName>=<Value>}] [--mode=<dev|prod>] [--task1 --task2...]\n\n";
	echo "o configFile: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "o --mode : accepted values are prod and dev. 'prod' will create a build/ directory and put all builded services in it.
	   'dev' will put builded services in the project, and output post-installation instructions.\n";
	echo "o --builddir : directory where builded output will be put (only in prod mode).\n";
	echo "o The available tasks are:\n";
	echo "  o --java : build java integration and report services\n";
	echo "  o --website : build the 'server' part of the project (symfony)\n";
	echo "  o --ext : build the 'client' part of the project (ext)\n";
	echo "  o --mapfile : build the mapfile for mapserver\n";
	echo "  o --apacheconf : build the apache configuration file\n";
	echo "  o --supervisorconf : build the supervisor configuration file\n\n";

	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)){
		echo("$mess\n\n");
		exit(1);
	}
	exit;
}

// Build des services
// ======================
// on les range dans ./build/services
function buildJavaServices($config, $buildMode)
{
	global $projectDir, $buildDir, $postBuildInstructions;
	chdir($projectDir);

	echo("Building java services...\n");
	echo("-------------------------\n");

	$gincoDir = realpath($config['ginco.path']);
	if ($buildMode == 'dev') {
		$servicesBuildDir = "$buildDir/services/build";
	} else {
		$servicesBuildDir = "$buildDir/services";
	}
	is_dir($servicesBuildDir) || mkdir($servicesBuildDir, 0755, true);
	is_dir("$servicesBuildDir/webapps") || mkdir("$servicesBuildDir/webapps", 0755, true);
	is_dir("$servicesBuildDir/conf") || mkdir("$servicesBuildDir/conf", 0755, true);

	$ISFilename = "SINP" . $config['instance.name'] . "IntegrationService";

	// build du service d'intégration
	echo("Building integration service...\n");
	system("mv -f $gincoDir/service_integration/config/log4j.properties $gincoDir/service_integration/config/log4j.properties.save");
	substituteInFile("$projectDir/services_configs/service_integration/log4j_tpl.properties",
		"$gincoDir/service_integration/config/log4j.properties", $config);

	chdir($gincoDir);
	system("./gradlew service_integration:war");
	# le war se trouve dans ${$gincoDir}/service_integration/build/libs/service_integration-4.0.0.war

	copy("$gincoDir/service_integration/build/libs/service_integration-4.0.0.war",
		"$servicesBuildDir/webapps/$ISFilename.war");
	substituteInFile("$projectDir/services_configs/service_integration/IntegrationService_tpl.xml",
		"$servicesBuildDir/conf/$ISFilename.xml", $config);

	// Post installation command
	if ($buildMode == 'dev') {
		$postBuildInstructions[] = "Java service war file has been built: $servicesBuildDir/webapps/$ISFilename.war\n";
		$postBuildInstructions[] = "To install, do:\n\n";
		$postBuildInstructions[] = "sudo service tomcat8 stop\n";
		$postBuildInstructions[] = "sudo rm -rf /var/lib/tomcat8/webapps/$ISFilename\n";
		$postBuildInstructions[] = "sudo cp -f $servicesBuildDir/webapps/$ISFilename.war /var/lib/tomcat8/webapps/\n";
		$postBuildInstructions[] = "sudo cp -f $servicesBuildDir/conf/$ISFilename.xml /etc/tomcat8/Catalina/localhost/\n";
		$postBuildInstructions[] = "sudo service tomcat8 start\n\n";
	}

	echo("Done building java services.\n\n");

}


# on range tout dans ./build/website
function buildWebsite($config, $buildMode)
{
    global $projectDir, $buildDir, $postBuildInstructions;
	chdir($projectDir);

    echo("building server: Ogam, Ginco, Configurator (symfony parts)...\n");
    echo("-------------------------------------------------------------\n");

    //$serverDirOgam = realpath($config['ginco.path'] . "/website/htdocs/server/ogamServer");
    $buildServerDir = $buildDir . "/website/server" ;
    is_dir($buildServerDir) || mkdir($buildServerDir, 0755, true);

    // Copy website files if in prod mode
    if ($buildMode == 'prod') {
        echo("Copying ginco server directory project to $buildServerDir...\n");
        system("cp -r $projectDir/website/server/* $buildServerDir/");
    }

	// Copy or symlink configurator bundles
	$configuratorDir = realpath($config['configurator.path']);
	if ($buildMode == 'prod') {
		echo("Copying configurator bundles to $buildServerDir/src/Ign/Bundle/...\n");
		system("rm -rf $buildServerDir/src/Ign/Bundle/*ConfigurateurBundle");
		system("cp -r $configuratorDir/src/Ign/Bundle/*ConfigurateurBundle $buildServerDir/src/Ign/Bundle/");
	} else {
		echo("Creating symlinks to OGAM/GincoConfigurateurBundle in $buildServerDir/src/Ign/Bundle/...\n");
		system("rm -rf $buildServerDir/src/Ign/Bundle/*ConfigurateurBundle");
		system("ln -s $configuratorDir/src/Ign/Bundle/OGAMConfigurateurBundle $buildServerDir/src/Ign/Bundle/OGAMConfigurateurBundle");
		system("ln -s $configuratorDir/src/Ign/Bundle/GincoConfigurateurBundle $buildServerDir/src/Ign/Bundle/GincoConfigurateurBundle");
	}

	// ajout de la version du build dans le template du site
	if ($buildMode == 'prod') {
		$currentBranch = system("git rev-parse --abbrev-ref HEAD");
		$versionInfo = $currentBranch . ' ' . date('d/m/o G:i:s');
		echo("Adding version ($versionInfo) in site template...\n");
		$layoutFile = "$buildServerDir/app/Resources/views/base.html.twig";
		substituteInFile($layoutFile, $layoutFile, ['build.version' => $versionInfo]);

		// Piwik
		$piwikTrackingFile = "$buildServerDir/app/Resources/views/piwik.html.twig";
		substituteInFile($piwikTrackingFile, $piwikTrackingFile, $config);
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
			'db_version' => $config['db.version'],
			'mailer_transport' => $config['mailer.transport'],
			'mailer_host' => $config['mailer.host'],
			'instance_name' => $config['instance.name'],
			'url_basepath' => $config['url.basepath'],
			'basepath' => (empty($config['url.basepath'])) ? '' : $config['url.basepath'],
		],
		'__'
	);

	chdir("$buildServerDir");

	// Get composer and install vendors (but don't run scripts, we do it after
	if (!is_file("composer.phar")) {
		echo "Installing composer...\n";
		// We allow the program to try a few times because we often go on a curl error...
		// https://github.com/composer/composer/issues/6538#issuecomment-328311429
		for ($i=1; $i<=5; $i++) {
			echo "Try $i...\n";
			system("https_proxy=http://proxy.ign.fr:3128 curl -sS https://getcomposer.org/installer | php");
			if (is_file("composer.phar")){
				break;
			}
			elseif ($i==5) {
				echo "ERROR: couldn't download composer.\n";
				exit(1);
			}
			else {
				sleep(60); // wait before making another attempt
			}
		}
	}
	echo "Installing project vendors...\n";
	system("./composer.phar install --no-scripts");

	// Installing assets and clear cache:
	// --> Ok in dev mode
	// --> Not done in prod mode because app/console assets:install need a connection
	// to the database, which is not accessible from local ign or jenkins.
	// --> done by the installer in switch_version.sh, on the target server.
	if ($buildMode == 'dev') {
        echo("Installing assets...\n");
        system('php app/console fos:js-routing:dump --env=dev --target="./src/Ign/Bundle/OGAMConfigurateurBundle/Resources/public/js/fos_js_routes_dev.js"');
        system("php app/console assets:install --symlink");
    }

    // Directories used in application:
	// Production mode: they are created once, outside the project, and the installer create symlinks,
	// execpt the website/logs directory
	// Development mode: we show post-installation instructions

	if ($buildMode == 'prod') {
		$buildLogsDir = $buildDir . "/website/logs" ;
		is_dir($buildLogsDir) || mkdir($buildLogsDir, 0755, true);
	} else if ($buildMode == 'dev') {
		$postBuildInstructions[] = "Create the following directories, where you want (best outside the project):\n";
		$postBuildInstructions[] = "* tmp: directory where data will be uploaded\n";
		$postBuildInstructions[] = "* upload: directory where data will be uploaded\n";
		$postBuildInstructions[] = "* dee: directory where dee files and archives will be stored\n";
		$postBuildInstructions[] = "* export: directory where export files will be stored\n";
		$postBuildInstructions[] = "Then complete with the absolute paths the values of the following parameters in table website.application_parameters:\n";
		$postBuildInstructions[] = "uploadDir (tmp), UploadDirectory (upload), deePublicDirectory and deePrivateDirectory (???), exportPuplicDirectory (export)\n\n";

		$postBuildInstructions[] = "Set permissions on application directories, execute:\n";
		$postBuildInstructions[] = " cd $buildServerDir\n";
		$postBuildInstructions[] = " sudo setfacl -R -m u:www-data:rwX -m u:`whoami`:rwX app/cache app/logs app/sessions\n";
		$postBuildInstructions[] = " sudo setfacl -dR -m u:www-data:rwX -m u:`whoami`:rwX app/cache app/logs app/sessions\n\n";
	}

    echo("Done building server (symfony).\n\n");
}

// partie extjs
function buildExtJS($config, $buildMode)
{
	global $projectDir, $buildDir;
	chdir($projectDir);

	echo("building client (extJs)...\n");
	echo("--------------------------\n");

	$clientDir = "$projectDir/website/client";
	$clientDirGinco = realpath($config['ginco.path'] . "/website/client");
	$buildClientDir = $buildDir . "/website/client" ;
	is_dir($buildClientDir) || mkdir($buildClientDir, 0755, true);

	// Customize app.json and index.html
	echo("Customize app.json...\n");
	substituteInFile("$clientDir/ogamDesktop/app_tpl.json", "$clientDir/ogamDesktop/app.json", $config);

	echo("Customize index.html...\n");
	substituteInFile("$clientDir/ogamDesktop/index_tpl.html", "$clientDir/ogamDesktop/index.html", $config);

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
	chdir($projectDir);

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
	chdir($projectDir);

	echo("building apache config...\n");
	echo("-------------------------\n");

	$confapacheBuildDir = "$buildDir/confapache";
	// Same effect as if ($buildMode=='prod')
	if ( !is_dir($confapacheBuildDir) ) {
		echo("Creating $confapacheBuildDir directory...\n");
		mkdir($confapacheBuildDir, 0755, true);
	}

	// No basepath: the Ginco application is alone on the domain and the virtual host
	if (empty($config['url.basepath'])) {
		$buildConfFile = "$confapacheBuildDir/ginco_{$config['instance.name']}.conf";
		echo("Creating apache configuration file: $buildConfFile...\n");

		substituteInFile("$projectDir/confapache/ginco_own_domain_tpl_$buildMode.conf", $buildConfFile, $config);

		if ($buildMode == 'dev') {
			$postBuildInstructions[] = "Apache configuration file has been built: $buildConfFile\n";
			$postBuildInstructions[] = "To install, do:\n\n";
			$postBuildInstructions[] = "sudo cp $buildConfFile /etc/apache2/sites-available/\n";
			$postBuildInstructions[] = "sudo a2ensite " . pathinfo($buildConfFile, PATHINFO_BASENAME) . "\n";
			$postBuildInstructions[] = "sudo service apache2 reload\n\n";
		}
	}
	// Basepath: the Ginco application can share the virtual host with other apps
	else {
		echo("Creating apache configuration files: \n");

		$buildConfFileVHost = "$confapacheBuildDir/ginco_{$config['url.domain']}.conf";
		substituteInFile("$projectDir/confapache/ginco_vhost_tpl.conf", $buildConfFileVHost, $config);
		echo("* $buildConfFileVHost\n");

		$buildConfFileMapserver = "$confapacheBuildDir/include_mapserver_{$config['instance.name']}.conf";
		substituteInFile("$projectDir/confapache/include_mapserver_tpl.conf", $buildConfFileMapserver, $config);
		echo("* $buildConfFileMapserver\n");

		$buildConfFileLogs = "$confapacheBuildDir/include_customlog_{$config['instance.name']}.conf";
		substituteInFile("$projectDir/confapache/include_customlog_tpl.conf", $buildConfFileLogs, $config);
		echo("* $buildConfFileLogs\n");

		$buildConfFileGinco = "$confapacheBuildDir/include_ginco_{$config['instance.name']}.conf";
		substituteInFile("$projectDir/confapache/include_ginco_tpl.conf", $buildConfFileGinco, $config);
		echo("* $buildConfFileGinco\n");

		$buildConfFileMaintenance = "$confapacheBuildDir/include_maintenance_{$config['instance.name']}.conf";
		substituteInFile("$projectDir/confapache/include_maintenance_tpl.conf", $buildConfFileMaintenance, $config);
		echo("* $buildConfFileMaintenance\n");

		if ($buildMode == 'dev') {
			$postBuildInstructions[] = "Apache configuration files has been built: $buildConfFileVHost, $buildConfFileGinco, $buildConfFileLogs, $buildConfFileMapserver\n";
			$postBuildInstructions[] = "To install, do:\n\n";
			$postBuildInstructions[] = "sudo cp -f $buildConfFileVHost /etc/apache2/sites-available/\n";
			$postBuildInstructions[] = "sudo ln -fs $buildConfFileGinco /etc/apache2/sites-available/\n";
			$postBuildInstructions[] = "sudo ln -fs $buildConfFileLogs /etc/apache2/sites-available/\n";
			$postBuildInstructions[] = "sudo ln -fs $buildConfFileMapserver /etc/apache2/sites-available/\n";
			$postBuildInstructions[] = "sudo ln -fs $buildConfFileMaintenance /etc/apache2/sites-available/\n";
			$postBuildInstructions[] = "sudo a2ensite " . pathinfo($buildConfFileVHost, PATHINFO_BASENAME) . "\n";
			$postBuildInstructions[] = "sudo service apache2 reload\n\n";
		}
	}


	echo("Done building apache config.\n\n");
}


# on la range dans ./build/confsupervisor
function buildSupervisorConf($config, $buildMode)
{
	global $projectDir, $buildDir, $postBuildInstructions;
	chdir($projectDir);

	echo("building supervisor config...\n");
	echo("-----------------------------\n");

	$confsupervisorBuildDir = "$buildDir/confsupervisor";
	// Same effect as if ($buildMode=='prod')
	if ( !is_dir($confsupervisorBuildDir) ) {
		echo("Creating $confsupervisorBuildDir directory...\n");
		mkdir($confsupervisorBuildDir, 0755, true);
	}

	$buildConfFile = "$confsupervisorBuildDir/ginco_{$config['instance.name']}.conf";
	echo("Creating supervisor configuration file: $buildConfFile...\n");
	
	// Add parameter in config
	$config['consumer.name'] = 'ginco_generic';
	substituteInFile("$projectDir/confsupervisor/ginco_supervisor_tpl.conf", $buildConfFile, $config);

	if ($buildMode == 'dev') {
		$postBuildInstructions[] = "Supervisor configuration file has been built: $buildConfFile\n";
		$postBuildInstructions[] = "To install, do:\n\n";
		$postBuildInstructions[] = "sudo cp $buildConfFile /etc/supervisor/conf.d/\n";
		$postBuildInstructions[] = "sudo service supervisor restart\n\n";
	}

	echo("Done building supervisor config.\n\n");
}


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
	"supervisorconf",		// Build supervisor configuration file
);
$otherOptions = array(
	"mode::",     	// Development mode: symlinks instead of copy files
	"builddir::",   // Directory where build output will be put (only in prod mode)
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

// Mode: development or prod (default is prod)
$buildMode = (isset($params['mode']) && $params['mode']=='dev') ? 'dev' : 'prod';

// build dir: where to put resulting builded files
// In prod mod, always erase build directory to have a coherent set of builded services
if ($buildMode == 'prod') {
	$buildDir = (isset($params['builddir']) && !empty($params['builddir'])) ? $params['builddir'] : "$projectDir/build";
	$buildDir = realpath($buildDir);
	if (is_dir($buildDir) && $buildDir != $projectDir) {
		system("rm -rf $buildDir");
	}
	mkdir($buildDir, 0755, true);
} else {
	$buildDir = $projectDir;
}


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
if (in_array('supervisorconf', $tasks)) {
	buildSupervisorConf($config, $buildMode);
}
// In prod mode, we keep the config parameters to a file which will be sent to the target machine
// It will be used by database creation/update scripts
if ($buildMode == 'prod') {
	propertiesToFile($config, "$buildDir/config.properties");
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

