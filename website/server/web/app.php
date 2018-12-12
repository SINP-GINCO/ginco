<?php

use Symfony\Component\HttpFoundation\Request;

/** @var \Composer\Autoload\ClassLoader $loader */
$loader = require __DIR__.'/../app/autoload.php';

$kernel = new AppKernel('prod', false);

/* trusted_proxies to get ip & co from load balancer */
Request::setTrustedProxies(['10.0.0.0/8'], Request::HEADER_X_FORWARDED_ALL);

/* spécification des entêtes pour la récupération des informations derrière un proxy (patch ATOS) */
Request::setTrustedHeaderName(Request::HEADER_FORWARDED, null);
Request::setTrustedHeaderName(Request::HEADER_CLIENT_IP, 'X-Forwarded-For');
Request::setTrustedHeaderName(Request::HEADER_CLIENT_HOST, 'X-Forwarded-Host');
Request::setTrustedHeaderName(Request::HEADER_CLIENT_PORT, 'X-Forwarded-Port');
Request::setTrustedHeaderName(Request::HEADER_CLIENT_PROTO, 'X-Forwarded-Proto');

// When using the HttpCache, you need to call the method in your front controller instead of relying on the configuration parameter
//Request::enableHttpMethodParameterOverride();
$request = Request::createFromGlobals();
$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
