<?php
/**
 * This script is an autonomous command, and must be run with php.
 * It generates a DEE export file (in GML).
 * It is usually called by the queue manager script.
 *
 * Usage:
 *
 *  php generateDEE.php -m $JDD_ID -f OUTPUT_FILE.xml -u $USER_LOGIN [ -j $JOB_ID ]
 *
 * $SUBMISSION_ID: id of the submission (dataset) in table raw_data.submission
 * $JDD_ID: id of the jdd in table raw_data.jdd
 * $JOB_ID: id of the job in the table website.job_queue. Used to write progress in database during the process.
 * OUTPUT_FILE.xml: file path/name of the output file.
 *
 */
include_once( dirname(__FILE__) . '/../../../../../public/includes/setup.php' );

// Zend_Application
require_once 'Zend/Application.php';

// GML Export toolbox
require_once CUSTOM_APPLICATION_PATH . '/gmlexport/GMLExport.php';
// Job Manager
require_once CUSTOM_APPLICATION_PATH . '/services/JobManagerService.php';

// Bootstrap Zend
$application = new Zend_Application(APPLICATION_ENV, $ApplicationConf);
$application->getBootstrap()->bootstrap();

// Configure memory and time limit because the program ask a lot of resources
$configuration = Zend_Registry::get("configuration");
ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
ini_set("max_execution_time", 0); // Not really useful because the script is used in CLI (max_execution_time is already 0)

// Initialise the logger
$logger = Zend_Registry::get("logger");
$logger->debug("generateDEE launched...");

// Initialise the job manager
$jm = new Application_Service_JobManagerService();

// Options from the command line :
// m : jdd_id
// f : file name to write
// u : user_login for e-mail
// j (optional) : job id in the job queue
$options = getopt("j::m:f:u:");

// Get the jddId
$jddId = intval($options['m']);

// Get the filename
$fileName = $options['f'];

// Get the user_login
$userLogin = $options['u'];

// Get the job id (in the job queue)
$jobId = isset($options['j']) ? $options['j'] : null;

// Generate DEE GML
$gml = new GMLExport();
$dateCreated = time();
$gml->generateDeeGml($jddId, $fileName, $jobId);
$logger->debug("GML created for jdd $jddId: $fileName");

// Create the archive and put it in the DEE download directory
$archivePath = $gml->createArchiveDeeGml($jddId, $fileName);
$logger->debug("GML Archive created for jdd $jddId: $archivePath");

// Send notification emails to the user and to the MNHN
$gml->sendDEENotificationMail($jddId, $archivePath, $dateCreated, $userLogin);
$logger->debug("GML Notification mail sent");

if ($jobId) {
    $jm->setJobCompleted($jobId);
}

// Sleep a little time after complete, to avoid being seen as "aborted"
sleep(2);
$logger->debug("End of generateDEE.");