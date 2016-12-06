<?php

include_once APPLICATION_PATH . '/controllers/IntegrationController.php';
require_once CUSTOM_APPLICATION_PATH . '/vendor/autoload.php';
/**
 * Custom Integration Controller for GINCO
 * @package controllers
 */
class Custom_IntegrationController extends IntegrationController {

	protected $customMetadataModel;

	protected $genericService;

	protected $genericModel;

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
				$this->integrationServiceModel->uploadData($submission->submissionId, $submissionProviderId, $requestedFiles, $srid, true, true, true);
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
