<?php
/**
 * @var Composer\Autoload\ClassLoader
 */
$loader = require __DIR__.'/../app/autoload.php';

use Symfony\Component\HttpFoundation\Session\Session;
use Symfony\Component\HttpFoundation\Session\Storage\NativeSessionStorage;
use Symfony\Component\HttpFoundation\Session\Storage\Handler\NativeFileSessionHandler;
use Symfony\Component\Security\Core\Authentication\Token\UsernamePasswordToken;

$storage = new NativeSessionStorage(array(), new NativeFileSessionHandler("../app/sessions/"));
$session = new Session($storage);
$session->start();

$token = unserialize($session->get('_security_main'));

if(empty($token) || !$token->isAuthenticated() || empty($token->getUser())){
    error_log('User not connected on '.$_SERVER["HTTP_HOST"]);
    error_log('Request: '.$_SERVER["QUERY_STRING"]);
    header('Location: /');
}

/*
 * Notes:
 * The user's "roles" field mustn't be serialized to avoid circular references issues.
 * Use instead the token's provided "getRoles" function.
 * The user, role and permission entities must be serializables
 */
$isAllowed = false;
foreach ($token->getRoles() as $role) {
    if ($role->isAllowed('DATA_QUERY')) {
        $isAllowed = true;
        break;
    }
}
if (!$isAllowed) {
    error_log('User not granted on '.$_SERVER["HTTP_HOST"]);
    error_log('Request: '.$_SERVER["QUERY_STRING"]);
    header('Location: /');
}

// Set few script parameters
$sessionId = $session->getId();
$configurationParameters = $session->get('proxy_ConfigurationParameters');

session_write_close(); // Releases the session cookie