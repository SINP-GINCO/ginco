<?php

#-------------------------------------------------------------------------------
# Create file $filePathOut from file $FilePathIn by replacing the tags @key@
# by the value found in $config
# For example:
# file in: "@il@ mangait dans l'herbe quand il s'est mis à pleuvoir."
# config: ('herbe' => 'appenti', 'il'=>'elle', 'toto' => 'titi', ...)
# file out: "elle mangait dans l'herbe quand il s'est mis à pleuvoir."
#
# $tag argument allow to define a different tag than '@'
# for example:
# if $tag='__' text should contain: __wordToSubtitute__ instead of @wordToSubtitute@
#-------------------------------------------------------------------------------
function substituteInFile($filePathIn, $filePathOut, $config, $tag = "@", $tagDirective = "%"){
	$content = file_get_contents($filePathIn);

	// Replace variables
	foreach ($config as $pattern => $value){
		$content = str_replace($tag . $pattern . $tag, $value, $content);
	}

	// Performs tests
	$testPatternMatch = str_replace('%', $tagDirective, '%if \s*\S+\s*%([^%]*)(?>%else%([^%]*))?%endif%');
	$testPatternEmpty = str_replace('%', $tagDirective, '%if \s*%([^%]*)(?>%else%([^%]*))?%endif%');

	$content = preg_replace("/$testPatternMatch/", '${1}', $content);
	$content = preg_replace("/$testPatternEmpty/", '${2}', $content);

	file_put_contents($filePathOut, $content);
}

#-------------------------------------------------------------------------------
# Load a java style properties file in an associative php array
#
# in $configFilePath: the path to the config File
# return an associative array with the key/value from the file
#-------------------------------------------------------------------------------
function loadPropertiesFromFile($configFilePath) {
	$result = array();
	readConfigFile($configFilePath, $result);
	return $result;
}


function readConfigFile($configFilePath, &$result) {

	if (!is_file($configFilePath)){
		echo ("[$configFilePath] is not a file");
		exit (1);
	}
	$configParentPath = dirname(realpath($configFilePath));

	$lines = explode("\n", file_get_contents($configFilePath));
	$key = "";
	$isWaitingOtherLine = false;
	$value='';

	foreach ($lines as $i => $line) {
		if (empty($line) || (!$isWaitingOtherLine && strpos($line, "#") === 0))
			continue;

		if (!$isWaitingOtherLine) {

			// Capture "import otherfile.properties" lines; https://regex101.com/r/Isg4VY/1/
			$importPattern = '/\bimport\s*(\'|"|)(.*)\1/';
			if (preg_match($importPattern, $line, $matches)) {
				$importFile = $matches[2];
				readConfigFile($configParentPath.'/'.$importFile, $result);
				continue;
			}

			// Regex capturing key-value pairs, with value enclosed in single quotes, double quotes, or nothing
			// see https://regex101.com/r/hK6gEa/4
			$pattern = '/\b([\w\.]+)\s*=\s*(\'|"|)(.*)\2/';
			preg_match($pattern, $line, $matches);
			$key = $matches[1];
			$value = $matches[3];
		}	else {
			$value .= $line;
		}
		/* Check if ends with single '\' */
		if (strrpos($value, "\\") === strlen($value)-strlen("\\")) {
			$value = substr($value,0,strlen($value)-1)."\n";
			$isWaitingOtherLine = true;
		}	else {
			$isWaitingOtherLine = false;
		}

		$result[$key] = $value;
		unset($lines[$i]);
	}
}


//------------------------------------------------------------------------------
// loadPropertiesFromArgs()
// Synopsis: * read command line parameters from argv.
//           * load properties from file indicated by -f option
//           * add or override properties from -D options
//           * return an associative array containing the properties.
//
// Example: Commande -f ./path/to/config.properties -Dfoo=bar -Dname=Nico
//
// config.properties containning:
//    name = john
//    db.user = Kelly
//
// will returns:
//    array(3) {
//      ["name"]   => string(4) "Nico"
//      ["db.user"]=> string(5) "Kelly"
//      ["foo"]    => string(3) "bar"
//    }
//
// TODO: should throw exceptions
//------------------------------------------------------------------------------
function loadPropertiesFromArgs(){
	$params = getopt("f:D::");
	if (!array_key_exists('f', $params)){
		echo "-f option (config file) is mandatory.\n";
		exit(1);
	}
	$config=loadPropertiesFromFile($params['f']);

	if (array_key_exists('D', $params)){
		if (is_array($params['D'])){
			$propertiesList = $params['D'];
		}else{
			$propertiesList = array($params['D']);
		}
		foreach ($propertiesList as $propertyStr) {
			$splitProp = explode('=', $propertyStr);
			if (count($splitProp) != 2){
				echo("The string [$propertyStr] should be like key=value.");
				exit(1);
			}
			$config[$splitProp[0]] = $splitProp[1];
		}
	}
	return $config;
}

//------------------------------------------------------------------------------
// propertiesToFile($config, $filePath)
// Synopsis: dump config array into a file. This is usefull to :
//            * keep information about exact config used for a build
//            * fire a ant script with this conf.
//------------------------------------------------------------------------------
function propertiesToFile($config, $filePath){
	$content = '';
	reset($config);
	foreach ($config as $key => $value){
		$content = $content . "$key=$value\n";
	}
	file_put_contents($filePath, $content);
}

//------------------------------------------------------------------------------
// execSQLFile()
// Synopsis: runs an SQL file.
//
// $tmplSQLFilePath is the template SQL File to execute.
// $config is the properties associative array to connect to the DB server.
//
// FIXME: system calls to psql could be replaced by a php stuff.
// if $failOnSQLError is set to true, sqlerror are ignored
//------------------------------------------------------------------------------
function execSQLFile($SQLFilePath, $config, $failOnSQLError=true){
	if (!is_file($SQLFilePath)){
		throw new Exception("[$SQLFilePath] is not a file");
	}

	$conStr ="host="     .$config['db.host'];
	$conStr.=" port="    .$config['db.port'];
	$conStr.=" user="    .$config['db.adminuser'];
	$conStr.=" password=".$config['db.adminuser.pw'];
	$conStr.=" dbname="  .$config['db.name'];

	$failStr = '';
	if ($failOnSQLError){
		$failStr = '--set ON_ERROR_STOP=1';
	}

	$cmd = 'psql ' . $failStr . " \"$conStr\" -f $SQLFilePath";
	echo "executing $SQLFilePath ...\n";
	system($cmd . ' > /dev/null', $returnCode);

	if ($returnCode != 0){
		throw new Exception("Error while executing: [$cmd]");
	}
}


//------------------------------------------------------------------------------
// execCustSQLFile()
// Synopsis: Customizes and runs an SQL file.
//
// $tmplSQLFilePath is the template SQL File to execute.
// $config is the properties associative array to use to customize the SQL File
//         and to connect to the DB server.
//------------------------------------------------------------------------------
function execCustSQLFile($tmplSQLFilePath, $config, $failOnSQLError=true){
	if (!is_file($tmplSQLFilePath)){
		throw new Exception("[$tmplSQLFilePath] is not a file");
	}

	$tmpDir = dirname(__FILE__).'/build';
	if (!is_dir($tmpDir)){
		mkdir($tmpDir);
	}

	# file to be executed: tmp/<template file name>-<current pid>
	# for example: ./tmp/update_maps.sql-198642
	$custSQLFilePath = $tmpDir.'/'.basename($tmplSQLFilePath).'-'.getmypid();

	try{
		substituteInFile($tmplSQLFilePath, $custSQLFilePath, $config);
		execSQLFile($custSQLFilePath, $config, $failOnSQLError);
	}catch (Exception $e) {
		throw $e;
	}

	unlink($custSQLFilePath);
}
