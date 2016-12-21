<?php
// ------------------------------------------ //
// Redefine parameters from index.php //
// ------------------------------------------ //

// Set error level
error_reporting(E_ALL | E_STRICT);

// Redefine the paths to link to the correct directories
if (file_exists('./../../../../../ogam/website')) {
	define('APPLICATION_PATH', './../../../../../ogam/website/htdocs/server/ogamServer/app');
}
define('LIBRARY_PATH', './htdocs/ogam/library/');
define('APPLICATION_LOG_PATH', './htdocs/logs');
define('TEST_PATH', realpath('./customTest/'). '/');
define('APPLICATION_ENVIRONMENT', 'production');
define('APPLICATION_ENV', 'phpunit');

if (file_exists('./../public/includes')) {
	define('INCLUDES_PATH', './../public/includes');
} else if (file_exists('./../../../../../ogam/website')) {
	define('INCLUDES_PATH', './../../../../../ogam/website/htdocs/public/includes');
}

// ------------------------------------------ //
// Include the original application bootstrap //
// ------------------------------------------ //
include INCLUDES_PATH . '/setup.php';

require_once 'Zend/Application.php';
$application = new Zend_Application(APPLICATION_ENV . ' : ' . APPLICATION_ENVIRONMENT, $ApplicationConf);
// Start a session
Zend_Session::start();
