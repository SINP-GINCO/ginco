<?php
include_once APPLICATION_PATH . '/controllers/IntegrationController.php';
require_once CUSTOM_APPLICATION_PATH . '/vendor/autoload.php';

/**
 * Custom Integration Controller for GINCO
 *
 * @package controllers
 */
class Custom_IntegrationController extends IntegrationController {

	protected $customMetadataModel;

	protected $genericService;

	protected $genericModel;

	/**
	 * Initialise the controler
	 */
	public function init() {
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
	 * Download the list of submisssions/datasets as a csv file
	 */
	public function downloadActiveSubmissionsCsvAction() {
		$this->logger->debug('downloadActiveSubmissionsCsvAction');
		// Configure memory and time limit because the program ask a lot of resources
		$configuration = Zend_Registry::get("configuration");
		ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", 0);

		// Get the current data submissions
		$submissions = $this->submissionModel->getActiveSubmissions();

		// Create the array to output to the csv file
		$results = array();

		$resultHeader = array(
			"Soumission",
			"Date",
			"Organisme",
			"Utilisateur",
			"Modèle d'import",
			"Fichier",
			"Lignes",
			"Etape d'import",
			"Statut de l'import",
			"Données publiées"
		);

		foreach ($submissions as $submission) {
			$resultLine = array();

			// Submission id
			$resultLine[] = $submission->submissionId;
			// Date
			$resultLine[] = $submission->date;
			// Provider
			$resultLine[] = $submission->providerLabel;
			// User (which has done the submission)
			$resultLine[] = $submission->userLogin;
			// Import model
			$resultLine[] = $submission->datasetLabel;
			// Files and lines
			$files = array();
			$lines = array();
			foreach ($submission->files as $file) {
				$files[] = basename($file->fileName);
				$lines[] = $file->lineNumber;
			}
			// Files
			$resultLine[] = implode(",", $files);
			// Number of lines in the file
			$resultLine[] = implode(",", $lines);
			// Step of integration
			$resultLine[] = $submission->step;
			// Status of integration
			$resultLine[] = $submission->status;
			// Data validated ?
			$resultLine[] = ($submission->step == "VALIDATE" && ($submission->status == "OK" || $submission->status == "WARNING")) ? "Oui" : "Non";

			$results[] = $resultLine;
		}

		// -- Export results to a CSV file

		$fileName = "Liste_JDD_" . preg_replace('/\s+/', '-', $configuration->getConfig('site_name', 'GINCO')) . "_" . date("d-m-Y") . ".csv";

		// Define the header of the response
		$this->getResponse()->setHeader('Content-Type', 'text/csv;charset=' . $configuration->getConfig('csvExportCharset', 'UTF-8') . ';application/force-download;', true);
		$this->getResponse()->setHeader('Content-disposition', 'attachment; filename=' . $fileName, true);

		// Prepend the Byte Order Mask to inform Excel that the file is in UTF-8
		if ($configuration->getConfig('csvExportCharset', 'UTF-8') == 'UTF-8') {
			echo (chr(0xEF));
			echo (chr(0xBB));
			echo (chr(0xBF));
		}

		// Opens the standard output as a file flux
		$out = fopen('php://output', 'w');
		fputcsv($out, $resultHeader, ';');

		foreach ($results as $resultLine) {
			fputcsv($out, $resultLine, ';');
		}
		fclose($out);

		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
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
}
