<?php

include_once APPLICATION_PATH . '/controllers/AbstractOGAMController.php';
require_once CUSTOM_APPLICATION_PATH . '/vendor/autoload.php';

/**
 * Custom Dataset Controller for GINCO
 * Performs actions on datasets :
 *  - Create reports
 *  - Post-treatments after integration
 *
 * These actions are outside the Integration Controller because they must not be
 * restricted to logged in users, as they can be called from the Java Integration service.
 * (no preDispatch)
 *
 * @package controllers
 */
class Custom_DatasetController  extends AbstractOGAMController {


    protected $customMetadataModel;
	protected $genericService;
	protected $genericModel;
    protected $configuration;

	/**
	 * Initialise the controler
	 */
	public function init()
	{
		parent::init();

        $this->configuration = Zend_Registry::get("configuration");

        // Initialise the model
        $this->metadataModel = new Application_Model_Metadata_Metadata();
        $this->integrationServiceModel = new Application_Model_IntegrationService_IntegrationService();
        $this->submissionModel = new Application_Model_RawData_Submission();

		// Custom Metadata Model : methods used only in Ginco
		$this->customMetadataModel = new Application_Model_Metadata_CustomMetadata();
		// Generic Service
		$this->genericService = new Application_Service_GenericService();
		// Generic Model
		$this->genericModel = new Application_Model_Generic_Generic();
	}

    /**
     * Generate the post-integration reports
     * and write them to files.
     *
     * This action is called in the Integration Service (java), and no authorized user
     * is logged in (in fact, the "visitor" user is logged by the auto-login defined in the Bootstrap.php)
     *
     */
	public function generateReportsAction() {
        // Configure memory and time limit because the program ask a lot of resources
        ini_set("memory_limit", $this->configuration->getConfig('memory_limit', '1024M'));
        ini_set("max_execution_time", 0);

        // Get the submission Id
        $submissionId = $this->_getParam("submissionId");

        $this->generateReports($submissionId);

        // Disable rendering
        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
    }


    /**
     * Generate the reports for a dataset (submission)
     * and write them to files
     *
     * @param $submissionId
     * @throws Exception
     */
    protected function generateReports($submissionId) {

        $customSubmissionModel = new Application_Model_RawData_CustomSubmission();

        // Get the submission
        $submission = $customSubmissionModel->getSubmission($submissionId);
        $this->logger->debug('generateReports, submission: ' . $submissionId );

        // generate Integration report (always)
        $customSubmissionModel->generateReport($submissionId, 'integrationReport');

        // only if status=OK
        if ($submission->status == "OK") {
            // generate sensibility report
            $customSubmissionModel->generateReport($submissionId, 'sensibilityReport');

            // generate id report
            $customSubmissionModel->generateReport($submissionId, 'permanentIdsReport');
        }
    }


    /**
     * Generic action to download reports
     * Call with GET parameters:
     *  - submissionId: the id of the submission
     *  - report: type of report, ie: sensibilityReport | permanentIdsReport | integrationReport
     *
     * @throws Exception
     */
    public function downloadReportAction()
    {
        // Configure memory and time limit because the program ask a lot of resources
        ini_set("memory_limit", $this->configuration->getConfig('memory_limit', '1024M'));
        ini_set("max_execution_time", 0);

        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();

        // Load user for checking permissions
        $userSession = new Zend_Session_Namespace('user');
        $user = $userSession->user;
        if (empty($user) || !$user->isAllowed('DATA_INTEGRATION')) {
            throw new Zend_Auth_Exception('Permission denied for right : DATA_INTEGRATION');
        }

        // Get the submission Id
        $submissionId = $this->_getParam("submissionId");
        // get the report name
        $report = $this->_getParam("report");
        $this->logger->debug("downloadReportAction: submission: $submissionId, report: $report" );

        $customSubmissionModel = new Application_Model_RawData_CustomSubmission();

        // Get File Name
        $filenames = $customSubmissionModel->getReportsFilenames($submissionId);
        $filePath = $filenames[$report];

        // Regenerate sensibility report each time (see #815)
        if ($report == "sensibilityReport") {
            $customSubmissionModel->writeSensibilityReport($submissionId, $filePath);
        }

        // tests the existence of the file
        if (!is_file( $filePath )) {
            $this->logger->debug("downloadReportAction: sensibility report file $filePath does not exist, trying to generate them");
            // We try to generate the reports, and then re-test
            $customSubmissionModel->generateReport($submissionId, $report);
            if (!is_file( $filePath )) {
                throw new Exception("Report file '$report' does not exist for submission $submissionId");
            }
        }

        // Get File type from its name
        $fileType = pathinfo($filePath, PATHINFO_EXTENSION); // csv or pdf
        $contentType = (strtolower($fileType) == 'csv') ? 'text/csv;charset=utf-8' : 'application/pdf';

        // -- Download the file

        // Define the header of the response
        $this->getResponse()->setHeader('Content-Type', $contentType . ';application/force-download;', true);
        $this->getResponse()->setHeader('Content-disposition', 'attachment; filename=' . pathinfo($filePath, PATHINFO_BASENAME), true);

        if (strtolower($fileType) == 'csv') {
            // Prepend the Byte Order Mask to inform Excel that the file is in UTF-8
            if ($this->configuration->getConfig('csvExportCharset', 'UTF-8') == 'UTF-8') {
                echo(chr(0xEF));
                echo(chr(0xBB));
                echo(chr(0xBF));
            }
        }

        $file = fopen($filePath,"rb");
        while(!feof($file))
        {
            print(@fread($file, 1024*8));
        }
        fclose($file);

    }

}
