<?php 

$initDir = dirname(__FILE__);
require_once "$initDir/../../lib/share.php";

#-------------------------------------------------------------------------------
# Synopsis: Defines environment type from properties file.
#
#-------------------------------------------------------------------------------

try {
	/* Check that role with public request permission have private request permission */
	$config = loadPropertiesFromArgs();
	
	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";
	
	if (!isset($config['instance.environment'])) {
		throw new Exception("Parameters instance.environment must be set in properties file.") ;	
	}

	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	
	$instanceEnv = $config['instance.environment'] ;
	
	$sql = "SELECT * FROM website.application_parameters WHERE name = 'environment'" ;
	$result = pg_query($sql) ;
	if ($result) {
		echo "Parameter 'environment' is already set.".PHP_EOL ;
		pg_close($dbconn) ;
		exit(0) ;
	}
	
	$sql = "INSERT INTO website.application_parameters(name, value, description) VALUES ('environment', '$instanceEnv', 'Environment type (dev, test, prod)')" ;
	$result = pg_query($sql) ;
	if (!$result) {
		echo "An SQL error occured while inserting environment parameter in database.".PHP_EOL ;
		pg_close($dbconn) ;
		exit(1) ;
	}
	
	pg_close($dbconn);
	
	
} catch (Exception $e) {
	echo "$initDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}