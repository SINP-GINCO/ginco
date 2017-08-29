<?php
/**
 * @var Composer\Autoload\ClassLoader
 */
require __DIR__ . '/../app/autoload.php';

use Symfony\Component\HttpFoundation\Session\Session;
use Symfony\Component\HttpFoundation\Session\Storage\NativeSessionStorage;
use Symfony\Component\HttpFoundation\Session\Storage\Handler\NativeFileSessionHandler;

$storage = new NativeSessionStorage(array(), new NativeFileSessionHandler("../app/sessions/"));
$session = new Session($storage);
$session->start();

// Set few script parameters used later in mapserverProxy.php
$sessionId = $session->getId();
$configurationParameters = $session->get('proxy_ConfigurationParameters');

session_write_close(); // Releases the session cookie