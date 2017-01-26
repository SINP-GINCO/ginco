<?php

include_once('authentication.php');

// Gets the query parameters
parse_str(ltrim($_SERVER["QUERY_STRING"],'?'), $query);

// Capitalizes the parameters
$query = array_change_key_case($query, CASE_UPPER);

// Defines the permitted parameters (in alphabetical order to avoid duplication)
$queryParamsAllow = array(
    // WMS parameters:
    'BBOX',
    'FORMAT',
    'HEIGHT',
    'LAYERS',
    'REQUEST',
    'SERVICE',
    'SRS',
    'STYLES',
    'TRANSPARENT',
    'VERSION',
    'WIDTH'
);

// Checks the validity of the parameters
$queriesArg = array();
foreach($queryParamsAllow as $param) {
    if (isset($query[$param])){
        $queriesArg[$param] = $query[$param];
    }
}

// Forces the 'REQUEST' parameter
$queriesArg['REQUEST']  = 'GetMap';

// Forces the 'SERVICE' parameter
$queriesArg['SERVICE']  = 'WMS';

// Sets the headers
header('Content-Type: image/png');
header('Access-Control-Allow-Origin: *');

// Set the url
$url = $configurationParameters['tilecache_private_url']->getValue();
if(empty($url)){
    error_log("Tilecache private url not set, use of the default 'http://localhost/tilecache-ogam?' url.");
    error_log("Please, check the configuration of the 'tilecache_private_url' parameter into the 'website.application_parameters' database table.");
    $url = "http://localhost/tilecache-ogam?";
}

// Sets the uri (url + urn)
$uri = rtrim($url,'?').'?'.http_build_query($queriesArg);

//echo $uri;exit;
//error_log($uri);

// Returns the result
$content = file_get_contents($uri);
if ($content !== FALSE) {
    echo $content;
}