<?php
namespace Ign\Bundle\GincoBundle\Services;

use Symfony\Component\HttpFoundation\Session\Session;
use Doctrine\ORM\NoResultException;
use Ign\Bundle\OGAMBundle\OGAMBundle;
use Symfony\Component\HttpFoundation\ParameterBag;
use Ign\Bundle\OGAMBundle\Entity\Generic\QueryForm;

/**
 * The Submission Service.
 *
 * Functions to create :
 * - sensibility report
 * - provider id to permanent id report
 * - integration report
 */
class SubmissionService {

	/**
	 * The logger.
	 *
	 * @var Logger
	 */
	protected $logger;

	/**
	 */
	protected $configuration;

	/**
	 *
	 * @var GenericService
	 */
	protected $genericService;

	/**
	 *
	 * @var QueryService
	 */
	protected $queryService;

	/**
	 *
	 * @var Doctrine entity manager for schema raw_data
	 */
	protected $rawDataEntityManager;

	/**
	 *
	 * @var Doctrine entity manager for schema metadata
	 */
	protected $metadataEntityManager;

	/**
	 *
	 * @var translator
	 */
	protected $translator;

	function __construct($logger, $configuration, $genericService, $queryService, $rawDataEntityManager, $metadataEntityManager, $translator) {
		// Initialise the logger
		$this->logger = $logger;
		
		// Initialise the configuration
		$this->configuration = $configuration;
		
		// Initialise the query service
		$this->queryService = $queryService;
		
		// Initialise the generic service
		$this->genericService = $genericService;
		
		// Initialise the rawdata entity manager
		$this->emrd = $rawDataEntityManager;
		
		// Initialise the metadata entity manager
		$this->emm = $metadataEntityManager;
		
		// Initialise the translator
		$this->translator = $translator;
	}

	/**
	 * Get an associative array with complete paths to the reports files:
	 * - sensibilityReport
	 * - permanentIdsReport
	 * - integrationReport
	 *
	 * @param
	 *        	$submissionId
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
	 * Get the complete path to the reports directory (per submission)
	 *
	 * @param
	 *        	$submissionId
	 * @return string
	 */
	public function getReportsDirectory($submissionId) {
		$uploadDirectory = $this->configuration->getConfig('UploadDirectory', 'http://localhost:8080/OGAMRG/');
		return $uploadDirectory . '/reports' . '/' . $submissionId;
	}

	/**
	 * Generate one report (which: $report)
	 * and write them to files
	 *
	 * @param
	 *        	$submissionId
	 * @param
	 *        	$report
	 * @throws Exception
	 */
	public function generateReport($submissionId, $report) {
		$this->logger->debug('generateReport, submission: ' . $submissionId . ', report: ' . $report);
		
		// The directory where we are going to store the reports, and the filenames
		$reportsDirectory = $this->getReportsDirectory($submissionId);
		$filenames = $this->getReportsFilenames($submissionId);
		
		// Create it if not exists
		$pathExists = is_dir($reportsDirectory) || mkdir($reportsDirectory, 0755, true);
		if (!$pathExists) {
			$this->logger->debug("Error: could not create directory: $reportsDirectory");
			throw new \Exception("Error: could not create directory: $reportsDirectory");
		}
		
		switch ($report) {
			case 'integrationReport':
				// generate Integration report
				$this->writeIntegrationReport($submissionId, $filenames['integrationReport']);
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
	 * @param
	 *        	$submissionId
	 * @param
	 *        	$outputFile
	 * @return bool
	 * @throws Exception
	 */
	function writeIntegrationReport($submissionId, $outputFile) {
		$reportServiceURL = $this->configuration->getConfig('reportGenerationService_url', 'http://localhost:8080/OGAMRG/');
		$errorReport = $this->configuration->getConfig('errorReport', 'ErrorReport.rptdesign');
		
		$reportURL = $reportServiceURL . "/run?__format=pdf&__report=report/" . $errorReport . "&submissionid=" . $submissionId;
		
		$this->logger->debug('writeIntegrationReport, submissionId ' . $submissionId . ' : ' . $reportURL);
		
		// Open the reportUrl (pdf report)
		$handle = fopen($reportURL, "rb");
		// Open the file in write mode
		$out = fopen($outputFile, 'wb');
		if (!$out) {
			$this->logger->debug("Error: could not open (w) file: $outputFile");
			throw new \Exception("Error: could not open (w) file: $outputFile");
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
	 * @param
	 *        	$submissionId
	 * @param
	 *        	$outputFile
	 * @return bool
	 * @throws Exception
	 */
	function writeSensibilityReport($submissionId, $outputFile) {
		$schema = 'RAW_DATA';
		
		// Get the dataset Id
		$submissionRepo = $this->emrd->getRepository('Ign\Bundle\OGAMBundle\Entity\RawData\Submission', 'raw_data');
		$submission = $submissionRepo->find($submissionId);
		$datasetId = $submission->getDataset()->getId();
		$datasetLabel = $submission->getDataset()->getLabel();
		$modelId = $submission->getDataset()
			->getModel()
			->getId();
		
		// Total number of data in the submission
		$subData = $this->queryService->getQueryResults("SELECT nb_line FROM raw_data.submission_file WHERE submission_id = " . $submissionId);
		if (count($subData) > 0) {
			$counts = array_column($subData, 'nb_line');
			$totalSubmission = max($counts);
		} else {
			$totalSubmission = 0;
		}
		
		$this->logger->debug('writeSensibilityReport - Submission Id : ' . $submissionId . " DatasetId : " . $datasetId);
		
		// -- Create a query object : the query must find all 'sensible = OUI' lines with given submission_id,
		// And print a list of all fields in the model
		$queryForm = new QueryForm();
		$queryForm->setDatasetId($datasetId);
		
		$tableFieldRepo = $this->emm->getRepository('Ign\Bundle\OGAMBundle\Entity\Metadata\TableField', 'metadata');
		$tableFields = $tableFieldRepo->getTableFieldsForModel($modelId);
		
		$formFieldRepo = $this->emm->getRepository('Ign\Bundle\OGAMBundle\Entity\Metadata\FormField', 'metadata');
		$formFields = $formFieldRepo->getFormFieldsFromModel($modelId);
		
		// -- Criteria fields for the query
		foreach ($formFields as $formField) {
			$data = $formField->getData()->getData();
			$format = $formField->getFormat()->getFormat();
			switch ($data) {
				case 'SUBMISSION_ID':
					$queryForm->addCriterion($format, 'SUBMISSION_ID', $submissionId);
					break;
				case 'sensible':
					$queryForm->addCriterion($format, 'sensible', '1');
					break;
			}
		}
		
		// -- List of fields to print in the report
		$reportFields = array(
			'PROVIDER_ID',
			'identifiantpermanent',
			'identifiantorigine',
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
			'sensimanuel'
		);
		
		// -- Result fields for the query
		foreach ($formFields as $formField) {
			if (in_array($formField->getData()->getData(), $reportFields)) {
				$queryForm->addColumn($formField->getFormat()
					->getFormat(), $formField->getData()
					->getData());
			}
		}
		$resultColumns = $queryForm->getColumns();
		
		// -- Header
		$resultHeader = array();
		foreach ($resultColumns as $genericField) {
			$field = $formFieldRepo->findOneBy(array(
				'data' => $genericField->getData(),
				'format' => $genericField->getFormat()
			));
			$resultHeader[] = $field->getLabel();
		}
		
		// -- Generate the SQL Request
		// Get the mappings for the query form fields
		$criteria = $queryForm->getCriteria();
		$queryForm = $this->queryService->setQueryFormFieldsMappings($queryForm);
		
		$mappingSet = $queryForm->getFieldMappingSet($queryForm);
		
		// Set false user params, thus everybody accessing the integration page can see sensitive data in the report
		$userInfos = [
			"providerId" => NULL,
			"DATA_QUERY_OTHER_PROVIDER" => true,
			"DATA_EDITION_OTHER_PROVIDER" => false
		];
		
		$select = $this->genericService->generateSQLSelectRequest($schema, $queryForm->getColumns(), $mappingSet, $userInfos);
		$from = $this->genericService->generateSQLFromRequest($schema, $mappingSet);
		$where = $this->genericService->generateSQLWhereRequest($schema, $queryForm->getCriteria(), $mappingSet, $userInfos);
		$sqlPKey = $this->genericService->generateSQLPrimaryKey($schema, $mappingSet);
		$sql = $select . $from . $where;
		
		// -- Execute query and put results in a formatted array of strings
		$results = $this->queryService->getQueryResults($sql);
		
		// Put lines in a formatted array
		
		$resultsArray = array();
		
		foreach ($results as $line) {
			$resultLine = array();
			foreach ($resultColumns as $formField) {
				$tableField = $mappingSet->getDstField($formField)->getMetadata();
				$key = strtolower($tableField->getName());
				$value = $line[$key];
				$data = $tableField->getData()->getData();
				
				if ($value == null) {
					$resultLine[$data] = '';
				} else {
					$type = $tableField->getData()
						->getUnit()
						->getType();
					switch ($type) {
						
						case "CODE":
							// For cdref and cdnom, show code instead of label
							if (($data == 'cdref') || ($data == 'cdnom')) {
								$resultLine[$data] = $value;
							} else {
								$resultLine[$data] = $this->getLabelCache($tableField, $value);
							}
							break;
						
						case 'ARRAY':
							// Split the array items
							$arrayValues = explode(",", preg_replace("@[{-}]@", "", $value));
							foreach ($arrayValues as $index => $arrayValue) {
								$arrayValues[$index] = $this->getLabelCache($tableField, $arrayValue);
							}
							$resultLine[$data] = '[' . implode(',', $arrayValues) . ']';
							break;
						
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
		
		// -- Title
		
		$titleArray = array();
		$titleArray[] = array(
			'// ' . $this->translator->trans('Report.Sensitivity.SensibilityReport')
		);
		$titleArray[] = array(
			'// ' . $this->translator->trans('Dataset') . ':',
			$datasetLabel
		);
		$titleArray[] = array(
			'// ' . $this->translator->trans('Report.Sensitivity.SubmissionId') . ':',
			$submissionId
		);
		$titleArray[] = array(
			'// ' . $this->translator->trans('Date') . ':',
			date('d/m/Y')
		);
		$titleArray[] = array(
			'// ' . $this->translator->trans('Report.Sensitivity.SensitiveDataNumber') . ':',
			$total
		);
		$titleArray[] = array(
			'// ' . $this->translator->trans('Report.Sensitivity.TotalDataNumber') . ':',
			$totalSubmission
		);
		$titleArray[] = array(
			''
		);
		$titleArray[] = array(
			''
		);
		
		// -- Export results to a CSV file
		// Open the file in write mode
		$out = fopen($outputFile, 'w');
		if (!$out) {
			$this->logger->debug("Error: could not open (w) file: $outputFile");
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
	 * @param
	 *        	$submissionId
	 * @param
	 *        	$outputFile
	 * @return bool
	 * @throws Exception
	 */
	function writePermanentIdsReport($submissionId, $outputFile) {
		$schema = 'RAW_DATA';
		
		// Get the dataset Id
		$submissionRepo = $this->emrd->getRepository('Ign\Bundle\OGAMBundle\Entity\RawData\Submission', 'raw_data');
		$submission = $submissionRepo->find($submissionId);
		$datasetId = $submission->getDataset()->getId();
		$modelId = $submission->getDataset()
			->getModel()
			->getId();
		
		$this->logger->debug('writePermanentIdsReport - Submission Id : ' . $submissionId . " DatasetId : " . $datasetId);
		
		// -- Create a query object : the query must find all lines with given submission_id,
		// And print a list of given fields: identifiantPermanent, identifiantOrigine
		
		$queryForm = new QueryForm();
		$queryForm->setDatasetId($datasetId);
		
		$tableFieldRepo = $this->emm->getRepository('Ign\Bundle\OGAMBundle\Entity\Metadata\TableField', 'metadata');
		$tableFields = $tableFieldRepo->getTableFieldsForModel($modelId);
		
		$formFieldRepo = $this->emm->getRepository('Ign\Bundle\OGAMBundle\Entity\Metadata\FormField', 'metadata');
		$formFields = $formFieldRepo->getFormFieldsFromModel($modelId);
		
		// -- Criteria fields for the query
		foreach ($formFields as $formField) {
			$data = $formField->getData()->getData();
			$format = $formField->getFormat()->getFormat();
			switch ($data) {
				case 'SUBMISSION_ID':
					$queryForm->addCriterion($format, 'SUBMISSION_ID', $submissionId);
					break;
			}
		}
		
		// -- List of fields to print in the report
		$reportFields = array(
			'identifiantpermanent',
			'identifiantorigine'
		);
		
		// -- Result fields for the query
		foreach ($formFields as $formField) {
			if (in_array($formField->getData()->getData(), $reportFields)) {
				$queryForm->addColumn($formField->getFormat()
					->getFormat(), $formField->getData()
					->getData());
			}
		}
		$resultColumns = $queryForm->getColumns();
		
		// -- Header
		$resultHeader = array();
		foreach ($resultColumns as $genericField) {
			$field = $formFieldRepo->findOneBy(array(
				'data' => $genericField->getData(),
				'format' => $genericField->getFormat()
			));
			$resultHeader[] = $field->getLabel();
		}
		
		// -- Generate the SQL Request
		// Get the mappings for the query form fields
		$criteria = $queryForm->getCriteria();
		$queryForm = $this->queryService->setQueryFormFieldsMappings($queryForm);
		
		$mappingSet = $queryForm->getFieldMappingSet($queryForm);
		
		// Set false user params
		$userInfos = [
			"providerId" => NULL,
			"DATA_QUERY_OTHER_PROVIDER" => true,
			"DATA_EDITION_OTHER_PROVIDER" => false
		];
		
		$select = $this->genericService->generateSQLSelectRequest($schema, $queryForm->getColumns(), $mappingSet, $userInfos);
		$from = $this->genericService->generateSQLFromRequest($schema, $mappingSet);
		$where = $this->genericService->generateSQLWhereRequest($schema, $queryForm->getCriteria(), $mappingSet, $userInfos);
		$sqlPKey = $this->genericService->generateSQLPrimaryKey($schema, $mappingSet);
		$sql = $select . $from . $where;
		
		// -- Execute query and put results in a formatted array of strings
		$results = $this->queryService->getQueryResults($sql);
		
		// Put lines in a formatted array
		$resultsArray = array();
		
		foreach ($results as $line) {
			$resultLine = array();
			foreach ($resultColumns as $formField) {
				$tableField = $mappingSet->getDstField($formField)->getMetadata();
				$key = strtolower($tableField->getName());
				$value = $line[$key];
				$data = $tableField->getData()->getData();
				
				if ($value == null) {
					$resultLine[$data] = '';
				} else {
					// Default case : String or numeric value
					$resultLine[$data] = $value;
				}
			}
			$resultsArray[] = $resultLine;
		}
		
		// -- Export results to a CSV file
		
		// Open the file in write mode
		$out = fopen($outputFile, 'w');
		if (!$out) {
			$this->logger->debug("Error: could not open (w) file: $outputFile");
			throw new \Exception("Error: could not open (w) file: $outputFile");
		}
		// Opens the standard output as a file flux
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
	 * @param $tableField TableField        	
	 * @param
	 *        	$value
	 * @return string
	 */
	protected function getLabelCache($tableField, $value) {
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
}