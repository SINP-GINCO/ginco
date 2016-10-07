<?php

include_once APPLICATION_PATH . '/controllers/IntegrationController.php';
require_once CUSTOM_APPLICATION_PATH . '/gmlexport/GMLExport.php';

/**
 * Custom Integration Controller for GINCO
 * @package controllers
 */
class Custom_IntegrationController extends IntegrationController {

	protected $customMetadataModel;

	protected $genericService;

	protected $genericModel;

	protected $traductions = array();

	/**
	 * Initialise the controler
	 */
	public function init()
	{
		parent::init();

		// Custom Metadata Model : methods used only in Ginco
		$this->customMetadataModel = new Application_Model_Metadata_CustomMetadata();
		// Generic Service
		$this->genericService = new Application_Service_GenericService();
		// Generic Model
		$this->genericModel = new Application_Model_Generic_Generic();
	}


	/**
	 * Show the data submission page.
	 *
	 * @return the HTML view
	 */
	public function showDataSubmissionPageAction() {
		$this->logger->debug('custom showCustomDataPageAction');

		// Get some info about the user
		$userSession = new Zend_Session_Namespace('user');

		// Get the current data submissions
		$this->view->submissions = $this->submissionModel->getActiveSubmissions();

		$this->render('custom-show-data-submission-page');
	}

	/**
	 * Show the upload data page.
	 *
	 * @return the HTML view
	 */
	public function showUploadDataAction() {
		$this->logger->debug('showUploadDataAction');

		// Get the parameters from configuration file
		$configuration = Zend_Registry::get("configuration");

		$showDetail = ($configuration->getConfig('showUploadFileDetail', true) == 1);
		$showModel = ($configuration->getConfig('showUploadFileModel', true) == 1);

		$this->logger->debug('$showDetail : ' . $showDetail);

		// Get the submission object from the database, and the dataset id and name
		$dataSession = new Zend_Session_Namespace('submission');
		$submissionId = $dataSession->data->submissionId;
		$submission = $this->submissionModel->getSubmission($submissionId);
		$dataset = $this->metadataModel->getDataset($submission->datasetId);

		$this->view->dataset = $dataset;

		$this->view->form = $this->getDataUploadForm($showDetail, $showModel);

		$this->render('custom-show-upload-data');
	}

	public function exportSensibilityReportAction()
	{

		// Configure memory and time limit because the program ask a lot of resources
		$configuration = Zend_Registry::get("configuration");
		ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', 480));

		// Load user for checking permissions
		// todo : add a permission for this action ?
		$userSession = new Zend_Session_Namespace('user');
		$user = $userSession->user;

		$schema = 'RAW_DATA';

		// Get the submission Id
		$submissionId = $this->_getParam("submissionId");
		// And the dataset Id
		$dataSubmission = $this->submissionModel->getSubmission($submissionId);
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

		$this->logger->debug('exportSensibilityReport - Submission Id : ' . $submissionId . " DatasetId : " . $datasetId);

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
				'codedepartement',
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

		// -- Export results to a CSV file

		// Define the header of the response
		$this->getResponse()->setHeader('Content-Type', 'text/csv;charset=' . $configuration->getConfig('csvExportCharset', 'UTF-8') . ';application/force-download;', true);
		$this->getResponse()->setHeader('Content-disposition', 'attachment; filename=Sensibility_Report_' . date('dmy_Hi') . '.csv', true);

		// Prepend the Byte Order Mask to inform Excel that the file is in UTF-8
		if ($configuration->getConfig('csvExportCharset', 'UTF-8') == 'UTF-8') {
			echo(chr(0xEF));
			echo(chr(0xBB));
			echo(chr(0xBF));
		}

		// Title

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

		// Opens the standard output as a file flux
		$out = fopen('php://output', 'w');
		foreach ($titleArray as $titleLine) {
			fputcsv($out, $titleLine, ';');
		}
		fclose($out);

		if ($total != 0) {
			// Opens the standard output as a file flux
			$out = fopen('php://output', 'w');
			fputcsv($out, $resultHeader, ';');
			foreach ($resultsArray as $resultLine) {
				fputcsv($out, $resultLine, ';');
			}
			fclose($out);
		}

		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
	}

	/**
	 * Create a GML export file for data with given submissionId
	 *
	 * @throws Zend_Exception
	 */
	public function exportGmlAction()
	{

		// Configure memory and time limit because the program ask a lot of resources
		$configuration = Zend_Registry::get("configuration");
		ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', 480));

		// Load user for checking permissions
		$userSession = new Zend_Session_Namespace('user');
		$user = $userSession->user;
		if (empty($user) || !$user->isAllowed('MANAGE_DATASETS')) {
			throw new Zend_Auth_Exception('Permission denied for right : MANAGE_DATASETS');
		}

		$schema = 'RAW_DATA';

		// Get the submission Id
		$submissionId = $this->_getParam("submissionId");
		// And the dataset Id
		$dataSubmission = $this->submissionModel->getSubmission($submissionId);
		$datasetId = $dataSubmission->datasetId;

		$this->logger->debug('exportGml - Submission Id : ' . $submissionId . " DatasetId : " . $datasetId);

		// -- Create a query object : the query must find all lines with given submission_id,
		// And print a list of all fields in the model

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

		// -- Result fields for the query : all fields of the model
		foreach ($tableFields as $tableField) {
			$queryObject->addEditableField($tableField);
		}
		$resultColumns = $queryObject->getEditableFields();

		// -- Generate the SQL Request

		// Get the PK to generate unique ids for the gml
		//$pk = $this->genericService->generateSQLPrimaryKey($schema, $queryObject);
		//$gml_id = "'GEOM_' || " . str_replace(",", " || '_' || ", str_replace('table_observation.', '', $pk));
		// No, finally just a marker wich is replaced by an id afterwards
		$gml_id = "'ID#GMLID#'"; // enclose it in simple quotes to be recognized as a string in ST_AsGML

		$options = array(
				'geometry_format' => 'gml',
				'geometry_srs' => 4326,
				'gml_precision' => 8,
				'gml_id' => $gml_id,
				'datetime_format' => 'YYYY-MM-DD"T"HH24:MI:SSTZ',
		);

		$select = $this->genericService->generateSQLSelectRequest($schema, $queryObject, $options);
		$from = $this->genericService->generateSQLFromRequest($schema, $queryObject);
		$where = $this->genericService->generateSQLWhereRequest($schema, $queryObject);
		$sql = $select . $from . $where;
		// to-do : rajouter un ORDER BY


		// -- Execute query and put results in a formatted array of strings

		$results = $this->genericModel->executeRequest($sql);

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

		// Define the header of the response
		$this->getResponse()->setHeader('Content-Type', 'text/xml;charset=utf-8;application/force-download;', true);
		$this->getResponse()->setHeader('Content-disposition', 'attachment; filename=Export_GML.xml', true);

		if ($total != 0) {

			// Instanciate GMLExport
			$gml = new GMLExport();

			// Opens the standard output as a file flux
			$out = fopen('php://output', 'w');

			// Write the whole GML in the file flux
			$gml->generateGML($resultsArray, $out);

			fclose($out);
		}

		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
	}


	/**
	 * Get a label from a code, use a local cache mechanism.
	 *
	 * @param Application_Object_Metadata_TableField $tableField
	 *            the field descriptor
	 * @param String $value
	 *            the code to translate
	 */
	protected function getLabelCache($tableField, $value)
	{
		$label = '';
		$key = strtolower($tableField->getName());

		// Check in local cache
		if (isset($this->traductions[$key][$value])) {
			$label = $this->traductions[$key][$value];
		} else {
			// Check in database
			$trad = $this->genericService->getValueLabel($tableField, $value);

			// Put in cache
			if (!empty($trad)) {
				$label = $trad;
				$this->traductions[$key][$value] = $trad;
			}
		}

		return $label;
	}

	/**
	 * Show the create data submission page.
	 * Overwrite the Ogam Action, the form has a choice for the provider.
	 *
	 * @return the HTML view
	 */
	public function showCreateDataSubmissionAction()
	{
		$this->logger->debug('Custom showCreateDataSubmissionAction');

		$userSession = new Zend_Session_Namespace('user');
		$user = $userSession->user;

		$this->view->form = $this->getSubmissionForm($user);

		$this->render('custom-show-create-data-submission');
	}

	/**
	 * Build and return the data submission form.
	 */
	protected function getSubmissionForm($user = null)
	{
		$form = new Application_Form_OGAMForm(array(
				'attribs' => array(
						'name' => ' data-submission-form',
						'action' => $this->baseUrl . '/integration/validate-create-data-submission'
				)
		));

		//
		// Add the dataset element
		//
		$requestElement = $form->createElement('select', 'DATASET_ID');
		$requestElement->setLabel('Dataset');
		$requestElement->setRequired(true);
		$datasets = $this->metadataModel->getDatasetsForUpload();
		$datasetIds = array();
		foreach ($datasets as $dataset) {
			$datasetIds[$dataset->id] = $dataset->label;
			if ($dataset->isDefault === '1') {
				$requestElement->setValue($dataset->id);
			}
		}
		$requestElement->addMultiOptions($datasetIds);

		//
		// Add the provider element
		//
		$providerIdElem = $form->createElement('select', 'PROVIDER_ID');
		$providerIdElem->setLabel('Provider of the dataset');
		$providerIdElem->setRequired(true);
		if ($user != null && $user->provider != null) {
			$providerIdElem->setValue($user->provider->id);
		}
		// $providers = $this->metadataModel->getModeLabels('PROVIDER_ID');
		$providerModel = new Application_Model_Website_Provider();
		$providers = $providerModel->getProvidersList();
		$providersChoices = array();
		foreach ($providers as $provider) {
			$providersChoices[$provider->id] = $provider->label;
		}
		$providerIdElem->addMultiOptions($providersChoices);

		//
		// Add the submit element
		//
		$submitElement = $form->createElement('submit', 'submit');
		$submitElement->setLabel('Submit');

		// Add elements to form:
		$form->addElement($requestElement);
		$form->addElement($providerIdElem);
		$form->addElement($submitElement);

		return $form;
	}

	/**
	 * Validate the create data submission page.
	 * Overwrites the custom action, uses the provider Id submitted in the form
	 *
	 * @return the HTML view
	 */
	public function validateCreateDataSubmissionAction()
	{
		$this->logger->debug('validateCreateDataSubmissionAction');

		// Check the validity of the POST
		if (!$this->getRequest()->isPost()) {
			$this->logger->debug('form is not a POST');
			return $this->_forward('index');
		}

		// Check the validity of the Form
		$form = $this->getSubmissionForm();
		if (!$form->isValid($_POST)) {
			$this->logger->debug('form is not valid');
			$this->view->form = $form;
			return $this->render('show-create-data-submission');
		}

		// Get the selected values
		$values = $form->getValues();
		$datasetId = $values['DATASET_ID'];
		$submissionProviderId = $values['PROVIDER_ID'];

		$userSession = new Zend_Session_Namespace('user');
		$userLogin = $userSession->user->login;
		// $providerId = $userSession->user->provider->id;
		$this->logger->debug('userLogin : ' . $userLogin);
		// $this->logger->debug('providerId : ' . $providerId);
		$this->logger->debug('submitted as providerId : ' . $submissionProviderId);

		// Send the request to the integration server
		try {
			$submissionId = $this->integrationServiceModel->newDataSubmission($submissionProviderId, $datasetId, $userLogin);
		} catch (Exception $e) {
			$this->logger->err('Error during upload: ' . $e);
			$this->view->errorMessage = $e->getMessage();
			return $this->render('show-data-error');
		}

		// Store the submission information in session
		$dataSubmission = new Application_Object_RawData_Submission();
		$dataSubmission->submissionId = $submissionId;
		$dataSubmission->providerId = $submissionProviderId;
		$dataSubmission->datasetId = $datasetId;
		$dataSubmission->userLogin = $userLogin;
		$dataSession = new Zend_Session_Namespace('submission');
		$dataSession->data = $dataSubmission;

		// Forward the user to the next step
		return $this->showUploadDataAction();
	}

	/**
	 * Validate the upload of one or more data file.
	 * Overwrites the custom action, uses the provider Id submitted in the form
	 *
	 * @return the HTML view
	 */
	public function validateUploadDataAction()
	{
		$this->logger->debug('validateUploadDataAction');

		// Check the validity of the POST
		if (!$this->getRequest()->isPost()) {
			$this->logger->debug('form is not a POST');
			return $this->_forward('index');
		}

		// Check the validity of the From
		$form = $this->getDataUploadForm();
		if (!$form->isValid($_POST)) {
			$this->logger->debug('form is not valid');
			$this->view->form = $form;
			return $this->render('show-upload-data');
		}

		// Get the selected values
		$values = $form->getValues();
		if (array_key_exists('SRID', $values)) {
			$srid = $values['SRID'];
		} else {
			// there is no geometric column
			$srid = '0';
		}

		// Upload the files on Server
		$upload = new Zend_File_Transfer_Adapter_Http();
		$upload->receive();

		// Get the submission info
		$dataSession = new Zend_Session_Namespace('submission');
		$submission = $dataSession->data;

		// Get the user info
		$userSession = new Zend_Session_Namespace('user');
		$submissionProviderId = $submission->providerId;

		// Get the configuration info
		$configuration = Zend_Registry::get("configuration");
		$uploadDir = $configuration->getConfig('uploadDir');

		//
		// For each requested file
		//
		$dataSubmission = $this->submissionModel->getSubmission($submission->submissionId);
		$requestedFiles = $this->metadataModel->getRequestedFiles($dataSubmission->datasetId);

		$allFilesUploaded = true;
		foreach ($requestedFiles as $requestedFile) {

			// Get the uploaded filename
			$filename = $upload->getFileName($requestedFile->format, false);
			$filepath = $upload->getFileName($requestedFile->format);
			// Print it only if it is not an array (ie: nothing has been selected by the user)
			if (!is_array($filename)) {
				$this->logger->debug('uploaded filename ' . $filename);
			}

			// Check that the file is present
			if (empty($filename)) {
				$this->logger->debug('empty');
				$allFilesUploaded = false;
			} else {
				// Move the file to the upload directory for archive
				$this->logger->debug('move file : ' . $filename);
				$targetPath = $uploadDir . DIRECTORY_SEPARATOR . $submission->submissionId . DIRECTORY_SEPARATOR . $requestedFile->fileType;
				$targetName = $targetPath . DIRECTORY_SEPARATOR . $filename;
				@mkdir($uploadDir . DIRECTORY_SEPARATOR . $submission->submissionId); // create the submission dir
				@mkdir($targetPath);
				@rename($filepath, $targetName);

				$this->logger->debug('renamed to ' . $targetName);
				$requestedFile->filePath = $targetName;
			}
		}

		// Check that all the files have been uploaded
		if (!$allFilesUploaded) {
			$this->view->errorMessage = $this->translator->translate('You must select all files to upload');
			$this->view->form = $form;
			return $this->render('show-upload-data');
		} else {

			// Send the files to the integration server
			try {
				$this->integrationServiceModel->uploadData($submission->submissionId, $submissionProviderId, $requestedFiles, $srid, true);
			} catch (Exception $e) {
				$this->logger->err('Error during upload: ' . $e);
				$this->view->errorMessage = $e->getMessage();
				return $this->render('show-data-error');
			}

			// Redirect the user to the show plot location page
			// This ensure that the user will not resubmit the data by doing a refresh on the page
			$this->_redirector->gotoUrl('/integration/show-data-submission-page');
		}
	}

}
