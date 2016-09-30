<?php

// todo: comment

ini_set("max_execution_time", 0); // Not really useful because the script is used in CLI (max_execution_time is already 0)

include_once( dirname(__FILE__) . '/../../../../../public/includes/setup.php' );

// Zend_Application
require_once 'Zend/Application.php';

$application = new Zend_Application(APPLICATION_ENV, $ApplicationConf);
$application->bootstrap();

// Initialise the logger
$logger = Zend_Registry::get("logger");

// The Job Manager Service
$jm = new Application_Service_JobManagerService();

// Job queue name todo: take it from an application parameter, or constant, and replace in GmlexportController
$queueName = 'ExportDEE';
// Max of concurrent running jobs
$maxJobs = 1;

// Exit if one job in the queue is already running
$running = $jm->numberOfRunningJobs($queueName) ;
if ($running > 0) {
    exit();
}

// Continue while there is PENDING tasks or
// while there is still RUNNING tasks (to catch new PENDING tasks)
while ( ($nextJobId = $jm->nextPendingJob($queueName)) || ($running > 0) ) {
    if ( $running >= $maxJobs) {
        sleep(1);
        $running = $jm->numberOfRunningJobs($queueName);
        continue;
    }
    $jm->runJob( $nextJobId );
    $running = $jm->numberOfRunningJobs($queueName);
}