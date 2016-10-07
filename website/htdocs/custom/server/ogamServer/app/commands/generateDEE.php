<?php
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
$db = $application->getBootstrap()->getResource('db');

// Configure memory and time limit because the program ask a lot of resources
$configuration = Zend_Registry::get("configuration");
ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
ini_set("max_execution_time", 0); // Not really useful because the script is used in CLI (max_execution_time is already 0)

// Initialise the logger
$logger = Zend_Registry::get("logger");

// Initialise the job manager
$jm = new Application_Service_JobManagerService();

$schema = 'RAW_DATA';

// Options from the command line :
// s : submission Id
// f : file name to write
// j (optional) : job id in the job queue
$options = getopt("j::s:f:");

// Get the submission Id
$submissionId = intval($options['s']);
// And the dataset Id
$submissionModel = new Application_Model_RawData_Submission();
$dataSubmission = $submissionModel->getSubmission($submissionId);
if (!$dataSubmission) {
    throw new Exception("Could not find submission $submissionId");
}
$datasetId = $dataSubmission->datasetId;

// Get the filename
$fileName = $options['f'];

// Get the job id (in the job queue)
$jobId = isset($options['j']) ? $options['j'] : null;

// Le logger n'a pas l'air de marcher ?
$logger->debug('generateDEE - Submission Id : ' . $submissionId . " DatasetId : " . $datasetId);

// -- Create a query object : the query must find all lines with given submission_id,
// And print a list of all fields in the model

$queryObject = new Application_Object_Generic_DataObject();
$queryObject->datasetId = $datasetId;

$customMetadataModel = new Application_Model_Metadata_CustomMetadata();
$modelId = $customMetadataModel->getModelForDataset($datasetId);
$tableFields = $customMetadataModel->getTableFieldsForModel($modelId);

// -- Criteria fields for the query
foreach ($tableFields as $tableField) {
    switch ($tableField->data) {
        case 'SUBMISSION_ID':
            $tableField->value = $submissionId;
            break;
    }
    $queryObject->addInfoField($tableField);
}

// -- Result fields for the query : all fields of the model
foreach ($tableFields as $tableField) {
    $queryObject->addEditableField($tableField);
}
$resultColumns = $queryObject->getEditableFields();

// -- Generate the SQL Request

// To generate unique ids for the gml, we put a marker wich is replaced by an id afterwards
$gml_id = "'ID#GMLID#'"; // enclose it in simple quotes to be recognized as a string in ST_AsGML

$options = array(
    'geometry_format' => 'gml',
    'geometry_srs' => 4326,
    'gml_precision' => 8,
    'gml_id' => $gml_id,
    'datetime_format' => 'YYYY-MM-DD"T"HH24:MI:SSTZ',
);

$genericService = new Application_Service_GenericService();
$select = $genericService->generateSQLSelectRequest($schema, $queryObject, $options);
$from = $genericService->generateSQLFromRequest($schema, $queryObject);
$where = $genericService->generateSQLWhereRequest($schema, $queryObject);
$sql = $select . $from . $where;
// todo : rajouter un ORDER BY


// -- Execute query and put results in a formatted array of strings
$genericModel = new Application_Model_Generic_Generic();
$results = $genericModel->executeRequest($sql);

// Put lines in a formatted array

$resultsArray = array();

foreach ($results as $line) {
    $resultLine = array();
    foreach ($resultColumns as $tableField) {

        $key = strtolower($tableField->getName());
        $value = $line[$key];
        $data = $tableField->data;
        // $formField = $formFields[$key];

        if ($value == null) {
            $resultLine[$data] = '';
        } else {
            switch ($tableField->type) {
                case 'ARRAY':
                    // Just sanitize string (remove "", {}, and [])
                    $bad = array("[", "]", "\"", "'", "{", "}");
                    $value = str_replace($bad, "", $value);
                    $resultLine[$data] = $value;
                    break;

                case "CODE":
                default:
                    // Default case : String or numeric value
                    $resultLine[$data] = $value;
                    break;
            }
        }
    }
    $resultsArray[] = $resultLine;
}

// Count the number of lines
$total = count($results);

// -- Export results to a CSV file

if ($total != 0) {

    // Instanciate GMLExport
    $gml = new GMLExport();

    // Opens a file
    $filePath = pathinfo($fileName, PATHINFO_DIRNAME);
    $pathExists = is_dir($filePath) || mkdir($filePath, 0755, true);

    if (!$pathExists) {
        throw new Exception("Error: could not create directory: $filePath");
    }
     else {
        $out = fopen($fileName, 'w');
        if (!$out) {
            throw new Exception("Error: could not open (w) file: $fileName");
        }
        else {
            // Write the whole GML in the file flux
            $gml->generateGML($resultsArray, $out, $jobId);
            fclose($out);
        }
    }
}

$jm->setJobCompleted($jobId);
// Sleep a little time after complete, to avoid being seen as "aborted"
sleep(2);