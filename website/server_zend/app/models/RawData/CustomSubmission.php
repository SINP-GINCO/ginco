<?php
/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 *
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices.
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents.
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */

/**
 * This is the CustomSubmission model.
 * Extends model with functions to create reports:
 *  - sensibility report
 *  - provider id to permanent id report
 *  - integration report
 *
 * @package models
 */
include_once APPLICATION_PATH . '/models/RawData/Submission.php';

class Application_Model_RawData_CustomSubmission extends Application_Model_RawData_Submission {

    protected $metadataModel;
    protected $customMetadataModel;
    protected $genericModel;
    protected $genericService;
    protected $configuration;
    protected $translator;
    protected $translations;

    /**
     * Initialisation.
     */
    public function __construct() {

        parent::__construct();

        // Initialise a metadata model
        $this->metadataModel = new Application_Model_Metadata_Metadata();
        // Custom Metadata Model : methods used only in Ginco
        $this->customMetadataModel = new Application_Model_Metadata_CustomMetadata();
        // Generic Model
        $this->genericModel = new Application_Model_Generic_Generic();
        // Generic Service
        $this->genericService = new Application_Service_GenericService();
        // Configuration
        $this->configuration = Zend_Registry::get("configuration");
        // Get the translator
        $this->translator = Zend_Registry::get('Zend_Translate');
        // translations
        $this->translations = array();
    }

    /**
     * Get the complete path to the reports directory (per submission)
     *
     * @param $submissionId
     * @return string
     */
    public function getReportsDirectory($submissionId) {
        return $this->configuration->getConfig('UploadDirectory')
            . '/reports'
            . '/' . $submissionId
            ;
    }

    /**
     * Get an associative array with complete paths to the reports files:
     * - sensibilityReport
     * - permanentIdsReport
     * - integrationReport
     *
     * @param $submissionId
     * @return array
     */
    public function getReportsFilenames($submissionId) {
        $reportsDirectory = $this->getReportsDirectory($submissionId);
        $fileNames = array(
            'sensibilityReport' => $reportsDirectory . '/Rapport_Sensibilite_' . $submissionId . '.csv',
            'permanentIdsReport' => $reportsDirectory . '/ID_Permanents_' . $submissionId . '.csv',
            'integrationReport' => $reportsDirectory . '/Rapport_Conformite_Coherence_' . $submissionId . '.pdf'
        );
        return $fileNames;
    }


    /**
     * Generate one report (which: $report)
     * and write them to files
     *
     * @param $submissionId
     * @param $report
     * @throws Exception
     */
    public function generateReport($submissionId, $report) {

        $this->logger->debug('generateReport, submission: ' . $submissionId . ', report: ' . $report);

        // The directory where we are going to store the reports, and the filenames
        $reportsDirectory = $this->getReportsDirectory($submissionId) ;
        $filenames = $this->getReportsFilenames($submissionId);

        // Create it if not exists
        $pathExists = is_dir($reportsDirectory) || mkdir($reportsDirectory, 0755, true);
        if (!$pathExists) {
            throw new Exception("Error: could not create directory: $reportsDirectory");
        }

        switch ($report) {
            case 'integrationReport':
                // generate Integration report
                $this->writeIntegrationReport($submissionId, $filenames['integrationReport'] );
                break;
            case 'sensibilityReport':
                // generate sensibility report
                $this->writeSensibilityReport($submissionId, $filenames['sensibilityReport']);
                break;
            case 'permanentIdsReport':
                // generate id report
                $this->writePermanentIdsReport($submissionId, $filenames['permanentIdsReport']);
                break;
            default:
                break;
        }
    }

    /**
     * Call the Java report service to generate the
     * integration report, and write it down to $outputFile
     *
     * @param $submissionId
     * @param $outputFile
     * @return bool
     * @throws Exception
     */
    public function writeIntegrationReport($submissionId, $outputFile) {
        $reportServiceURL = $this->configuration->getConfig('reportGenerationService_url', 'http://localhost:8080/OGAMRG/');
        $errorReport = $this->configuration->getConfig('errorReport', 'ErrorReport.rptdesign');

        $reportURL = $reportServiceURL . "/run?__format=pdf&__report=report/" . $errorReport . "&submissionid=" . $submissionId;

        $this->logger->debug('writeIntegrationReport, submissionId '.$submissionId.' : ' . $reportURL);

        // Open the reportUrl (pdf report)
        $handle = fopen($reportURL, "rb");
        // Open the file in write mode
        $out = fopen($outputFile, 'wb');
        if (!$out) {
            throw new Exception("Error: could not open (w) file: $outputFile");
        }
        // Read the report and write it to the output file
        $result = stream_get_contents($handle);
        fwrite($out, $result);

        fclose($handle);
        fclose($out);
        return true;
    }


    /**
     * Generate sensibility report,
     * and write it down to $outputFile
     *
     * @param $submissionId
     * @param $outputFile
     * @return bool
     * @throws Exception
     */
    public function writeSensibilityReport($submissionId, $outputFile) {

        $schema = 'RAW_DATA';

        // Get the dataset Id
        $dataSubmission = $this->getSubmission($submissionId);
        $datasetId = $dataSubmission->datasetId;
        $dataset = $this->metadataModel->getDataset($datasetId);

        // Total number of data in the submission
        $subData = $this->genericModel->executeRequest("SELECT nb_line FROM raw_data.submission_file WHERE submission_id = " . $submissionId);
        if (count($subData) > 0) {
            $counts = array_column($subData, 'nb_line');
            $totalSubmission = max($counts);
        } else {
            $totalSubmission = 0;
        }

        $this->logger->debug('writeSensibilityReport - Submission Id : ' . $submissionId . " DatasetId : " . $datasetId);

        // -- Create a query object : the query must find all 'sensible = OUI' lines with given submission_id,
        // And print a list of given fields

        $queryObject = new Application_Object_Generic_DataObject();
        $queryObject->datasetId = $datasetId;

        $modelId = $this->customMetadataModel->getModelForDataset($datasetId);
        $tableFields = $this->customMetadataModel->getTableFieldsForModel($modelId);

        // -- Criteria fields for the query
        foreach ($tableFields as $tableField) {
            switch ($tableField->data) {
                case 'SUBMISSION_ID':
                    $tableField->value = $submissionId;
                    break;
                case 'sensible':
                    $tableField->value = '1';
                    break;
            }
            $queryObject->addInfoField($tableField);
        }

        // -- List of fields to print in the report
        $reportFields = array(
            'PROVIDER_ID',
            'identifiantpermanent',
            'cdref',
            'cdnom',
            'occstatutbiologique',
            'datefin',
            'sensible',
            'sensiniveau',
            'codedepartementcalcule',
            'sensireferentiel',
            'sensiversionreferentiel',
            'sensidateattribution',
            'sensialerte',
            'sensimanuel',
        );

        // -- Result fields for the query
        foreach ($tableFields as $tableField) {
            if (in_array($tableField->data, $reportFields)) {
                $queryObject->addEditableField($tableField);
            }
        }
        $resultColumns = $queryObject->getEditableFields();

        // -- Header
        $resultHeader = array();
        foreach ($resultColumns as $tableField) {
            $resultHeader[] = $tableField->label;
        }

        // -- Generate the SQL Request
        $select = $this->genericService->generateSQLSelectRequest($schema, $queryObject);
        $from = $this->genericService->generateSQLFromRequest($schema, $queryObject);
        $where = $this->genericService->generateSQLWhereRequest($schema, $queryObject);
        $sql = $select . $from . $where;

        // -- Execute query and put results in a formatted array of strings

        $results = $this->genericModel->executeRequest($sql);

        // Put lines in a formatted array

        $resultsArray = array();

        foreach ($results as $line) {
            $resultLine = array();
            foreach ($resultColumns as $tableField) {

                $key = strtolower($tableField->getName());
                $value = $line[$key];
                // $formField = $formFields[$key];

                if ($value == null) {
                    $resultLine[] = '';
                } else {
                    switch ($tableField->type) {

                        case "CODE":
                            // For cdref and cdnom, show code instead of label
                            if (($tableField->data == 'cdref') || ($tableField->data == 'cdnom')) {
                                $resultLine[] = $value;
                            } else {
                                $resultLine[] = $this->getLabelCache($tableField, $value);
                            }
                            break;

                        case 'ARRAY':
                            // Split the array items
                            $arrayValues = explode(",", preg_replace("@[{-}]@", "", $value));
                            foreach ($arrayValues as $index => $arrayValue) {
                                $arrayValues[$index] = $this->getLabelCache($tableField, $arrayValue);
                            }
                            $resultLine[] = '[' . implode(',', $arrayValues) . ']';
                            break;

                        default:
                            // Default case : String or numeric value
                            $resultLine[] = $value;
                            break;
                    }
                }
            }
            $resultsArray[] = $resultLine;
        }

        // Count the number of lines
        $total = count($results);

        // -- Title

        $titleArray = array();
        $titleArray[] = array(
            '// ' . $this->translator->translate('Sensibility report')
        );
        $titleArray[] = array(
            '// ' . $this->translator->translate('Dataset') . ':',
            $dataset->label
        );
        $titleArray[] = array(
            '// ' . $this->translator->translate('Submission ID') . ':',
            $submissionId
        );
        $titleArray[] = array(
            '// ' . $this->translator->translate('Date') . ':',
            date('d/m/Y')
        );
        $titleArray[] = array(
            '// ' . $this->translator->translate('Number of sensible data') . ':',
            $total
        );
        $titleArray[] = array(
            '// ' . $this->translator->translate('Total number of data in the submission') . ':',
            $totalSubmission
        );
        $titleArray[] = array('');
        $titleArray[] = array('');


        // -- Export results to a CSV file

        // Open the file in write mode
        $out = fopen($outputFile, 'w');
        if (!$out) {
            throw new Exception("Error: could not open (w) file: $outputFile");
        }

        // Write Title
        foreach ($titleArray as $titleLine) {
            fputcsv($out, $titleLine, ";");
        }
        if ($total != 0) {
            // Opens the standard output as a file flux
            fputcsv($out, $resultHeader, ";");
            foreach ($resultsArray as $resultLine) {
                fputcsv($out, $resultLine, ";");
            }
        }
        fclose($out);
        return true;
    }

    /**
     * Generate "provider ids to SINP permanent ids" report,
     * and write it down to $outputFile
     *
     * @param $submissionId
     * @param $outputFile
     * @return bool
     * @throws Exception
     */
    public function writePermanentIdsReport($submissionId, $outputFile) {

        $schema = 'RAW_DATA';

        // Get the dataset Id
        $dataSubmission = $this->getSubmission($submissionId);
        $datasetId = $dataSubmission->datasetId;

        $this->logger->debug('writePermanentIdsReport - Submission Id : ' . $submissionId . " DatasetId : " . $datasetId);

        // -- Create a query object : the query must find all lines with given submission_id,
        // And print a list of given fields: identifiantPermanent, identifiantOrigine

        $queryObject = new Application_Object_Generic_DataObject();
        $queryObject->datasetId = $datasetId;

        $modelId = $this->customMetadataModel->getModelForDataset($datasetId);
        $tableFields = $this->customMetadataModel->getTableFieldsForModel($modelId);

        // -- Criteria fields for the query
        foreach ($tableFields as $tableField) {
            switch ($tableField->data) {
                case 'SUBMISSION_ID':
                    $tableField->value = $submissionId;
                    break;
            }
            $queryObject->addInfoField($tableField);
        }

        // -- List of fields to print in the report
        $reportFields = array(
            'identifiantpermanent',
            'identifiantorigine'
            );

        // -- Result fields for the query
        foreach ($tableFields as $tableField) {
            if (in_array($tableField->data, $reportFields)) {
                $queryObject->addEditableField($tableField);
            }
        }
        $resultColumns = $queryObject->getEditableFields();

        // -- Header
        $resultHeader = array();
        foreach ($resultColumns as $tableField) {
            $resultHeader[] = $tableField->label;
        }

        // -- Generate the SQL Request
        $select = $this->genericService->generateSQLSelectRequest($schema, $queryObject);
        $from = $this->genericService->generateSQLFromRequest($schema, $queryObject);
        $where = $this->genericService->generateSQLWhereRequest($schema, $queryObject);
        $sql = $select . $from . $where;

        // -- Execute query and put results in a formatted array of strings

        $results = $this->genericModel->executeRequest($sql);

        // Put lines in a formatted array

        $resultsArray = array();

        foreach ($results as $line) {
            $resultLine = array();
            foreach ($resultColumns as $tableField) {

                $key = strtolower($tableField->getName());
                $value = $line[$key];
                // $formField = $formFields[$key];

                if ($value == null) {
                    $resultLine[] = '';
                } else {
                    // Default case : String or numeric value
                    $resultLine[] = $value;
                }
            }
            $resultsArray[] = $resultLine;
        }

       // -- Export results to a CSV file

        // Open the file in write mode
        $out = fopen($outputFile, 'w');
        if (!$out) {
            throw new Exception("Error: could not open (w) file: $outputFile");
        }

        fputcsv($out, $resultHeader, ";");
        foreach ($resultsArray as $resultLine) {
            fputcsv($out, $resultLine, ";");
        }
        fclose($out);
        return true;
    }

    /**
     * Get a label from a code, use a local cache mechanism.
     *
     * @param $tableField Application_Object_Metadata_TableField
     * @param $value
     * @return string
     */
    protected function getLabelCache($tableField, $value)
    {
        $label = '';
        $key = strtolower($tableField->getName());

        // Check in local cache
        if (isset($this->translations[$key][$value])) {
            $label = $this->translations[$key][$value];
        } else {
            // Check in database
            $trad = $this->genericService->getValueLabel($tableField, $value);

            // Put in cache
            if (!empty($trad)) {
                $label = $trad;
                $this->translations[$key][$value] = $trad;
            }
        }

        return $label;
    }


    /**
     * Get submission files
     *
     * @param $submissionId
     * @return array
     */
    public function getSubmissionFiles($submissionId) {
        Zend_Registry::get("logger")->info('getSubmissionFiles : ' . $submissionId);

        $req = " SELECT * FROM submission_file WHERE submission_id = ?";
        $select = $this->db->prepare($req);
        $select->execute(array(
            $submissionId
        ));

        $results = array();
        foreach ($select->fetchAll() as $row) {
            $results[] = $row;
        }
        return $results;
    }


}