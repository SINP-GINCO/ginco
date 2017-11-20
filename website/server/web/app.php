<?php

use Symfony\Component\HttpFoundation\Request;

/** @var \Composer\Autoload\ClassLoader $loader */
$loader = require __DIR__.'/../app/autoload.php';
include_once __DIR__.'/../app/bootstrap.php.cache';

$kernel = new AppKernel('prod', false);
$kernel->loadClassCache();
//$kernel = new AppCache($kernel);

// todo : as soon as the reverse proxy pb is fixed, remove this and replace
// todo : with correct trusted_proxies configuration
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO'])) {
	$_SERVER['REQUEST_SCHEME'] = $_SERVER['HTTP_X_FORWARDED_PROTO'];
	if ($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
		$_SERVER['HTTPS'] = 'on';
	};
}
// When using the HttpCache, you need to call the method in your front controller instead of relying on the configuration parameter
//Request::enableHttpMethodParameterOverride();
$request = Request::createFromGlobals();


$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
