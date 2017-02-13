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


	/**
	 * Validate the data.
	 * Custom: send a notification mail to the
	 */
	public function validateDataAction() {
		$this->logger->debug('validateDataAction');

		// Get the parameters from configuration file
		$configuration = Zend_Registry::get("configuration");

		// Get the submission Id
		$submissionId = $this->_getParam("submissionId");

		// Send the validation request to the integration server
		try {
			$this->integrationServiceModel->validateDataSubmission($submissionId);
		} catch (Exception $e) {
			$this->logger->err('Error during validation: ' . $e);
			$this->view->errorMessage = $e->getMessage();
			return $this->render('show-data-error');
		}

		// -- Send the email
		$uuid = $submissionId; // todo remplacer par le vrai uuid du jdd
		$siteName = $configuration->getConfig('site_name');
		// Files of the submission
		$submissionModel = new Application_Model_RawData_CustomSubmission();
		$submissionFiles = $submissionModel->getSubmissionFiles($submissionId);
		$fileNames = array_map("basename", array_column($submissionFiles, "file_name"));

		// Contact user = connected user.
		// Reload it from db because email value can have been changed since beginning of the session
		$userSession = new Zend_Session_Namespace('user');
		$userLogin = $userSession->user->login;
		$userModel = new Application_Model_Website_User();
		$user = $userModel->getUser($userLogin);

		// Title and body:
		$title = (count($submissionFiles) > 1) ? "Intégration des jeux de données " : "Intégration du jeu de données ";
		$title .= implode($fileNames, ", ");

		// Using the mailer service based on SwiftMailer
		$mailerService = new Application_Service_MailerService();

		// Create a message
		$message = $mailerService->newMessage($title);

		// body
		$body = "<p>Bonjour,</p>";
		$body .= (count($submissionFiles) > 1) ? "<p>Les fichiers de données <em>%s</em> que vous nous avez transmis ont été intégrés sur la plate-forme :
             <em>%s</em> et publié le %s.<br>" : "<p>Le fichier de données <em>%s</em> que vous nous avez transmis a été intégré sur la plate-forme :
             <em>%s</em> et publié le %s.<br>";
		$body .= "Sur la plate-forme, le jeu de données porte désormais le numéro de la soumission : %s.</p>";
		$body .= "<p>Vous trouverez en pièce jointe le rapport final de conformité et de cohérence du fichier,
                le rapport final sur la sensibilité des observations ainsi que le fichier vous permettant de reporter les
                identifiants permanents SINP attribués aux données du jeu par la plate-forme.</p>";
		$body .= "<p>Bien cordialement,</p>
               <p>Contact : %s<br>Courriel: %s</p>";

		$body = sprintf($body, implode($fileNames, ", "), $siteName, date("d/m/Y"), $uuid, $user->username, $user->email);

		$message->setTo($user->email)->setBody($body, 'text/html');

		// Attachments
		$reports = $submissionModel->getReportsFilenames($submissionId);

		// Regenerate sensibility report each time (see #815)
		$submissionModel->writeSensibilityReport($submissionId, $reports["sensibilityReport"]);

		foreach ($reports as $report => $reportPath) {
			if (!is_file($reportPath)) {
				$this->logger->debug("validateDataAction: report file $filePath does not exist, trying to generate them");
				// We try to generate the reports, and then re-test
				$submissionModel->generateReport($submissionId, $report);
				if (!is_file($reportPath)) {
					throw new Exception("Report file '$report' does not exist for submission $submissionId");
				}
			}

			$message->attach(Swift_Attachment::fromPath($reportPath));
		}

		// Send the message
		$mailerService->sendMessage($message);

		// Forward the user to the next step
		$this->_redirector->gotoUrl('/integration/show-data-submission-page');
	}
}
