<?php

require_once APPLICATION_PATH . '/controllers/AbstractOGAMController.php';

/**
 * GMLExportController is the controller that manages the control
 * of DEE-GML export jobs by the Job Manager.
 * And the direct download of the DEE GML file.
 *
 * @package Application_Controller
 */
class Custom_GmlexportController extends AbstractOGAMController {

    const JOBTYPE='ExportDEE';

    protected $jobManager = null;

    protected $exportFileModel = null;

    protected $submissionModel = null;

    protected $rawdb;

    /**
     * Initialise the controler.
     */
    public function init() {
        parent::init();

        // Set the current module name
        $websiteSession = new Zend_Session_Namespace('website');
        $websiteSession->module = "gmlexport";
        $websiteSession->moduleLabel = "GML Export";
        $websiteSession->moduleURL = "gmlexport";

        // The job Manager
        $this->jobManager = new Application_Service_JobManagerService();

        // The export file model
        $this->exportFileModel = new Application_Model_RawData_ExportFile();

        // SubmissionModel
        $this->submissionModel = new Application_Model_RawData_Submission();

        // The database
        $this->rawdb = Zend_Registry::get('raw_db');
    }

    /**
     * Check if the authorization is valid this controler.
     *
     * @throws an Exception if the user doesn't have the rights
     */
    function preDispatch() {
        parent::preDispatch();

        $userSession = new Zend_Session_Namespace('user');
        $user = $userSession->user;
        if (empty($user) || !$user->isAllowed('MANAGE_DATASETS')) {
            throw new Zend_Auth_Exception('Permission denied for right : MANAGE_DATASETS');
        }
    }

    /**
     * The "index" action is the default action for all controllers.
     * -- Does Nothing --
     */
    public function indexAction() {
        echo json_encode(array('OK'));
        // No View, we send directly the JSON
        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
        $this->getResponse()->setHeader('Content-type', 'application/json');
    }

    /**
     * Add a job in the job queue, and a line in export_file table
     * Status of the new job is PENDING.
     * The DEE Export Queue Manager is launched, except if
     * query parameter launch = 0.
     *
     */
    public function addJobAction() {
        $submissionId = $this->_getParam("submissionId");
        $launch = $this->_getParam("launch", true);

        $userSession = new Zend_Session_Namespace('user');
        $userLogin = $userSession->user->login;

        $this->logger->debug('GMLExport: add job in queue, submission id : ' . $submissionId);

        // Test if there is already an export file
        if ( $this->exportFileModel->existsExportFileData($submissionId)) {
            $this->logger->debug('GMLExport: export_file already exists, delting it.Submission id : ' . $submissionId);
            $this->cancelExport($submissionId);
        }

        // export file name
        $filePath = $this->exportFileModel->generateFilePath($submissionId);

        // Command to launch the GML Export Job
        $command = 'php ' . CUSTOM_APPLICATION_PATH . '/commands/generateDEE.php -s ' . $submissionId . ' -f ' . $filePath;
        // Length of the observation files
        $length = $this->exportFileModel->getJobLengthForSubmission($submissionId);

        $jobId = $this->jobManager->addJob( $command, self::JOBTYPE , $length );

        if ($jobId) {
            // Insert an line in export_file table
            $this->exportFileModel->addExportFile($submissionId, $jobId, $filePath, $userLogin);
        }
        else {
            $this->logger->debug('GMLExport: IMPOSSIBLE to add export_file entry, submission id : ' . $submissionId);
        }

        $return = array(
            'submissionId' => $submissionId,
            'success' => ($jobId > 0)
        );
        if ($jobId) {
            $return['status'] = Application_Service_JobManagerService::PENDING;

            // Launch the Queue Manager
            $this->logger->debug('GMLExport: launch the queue manager');

            if ($launch) {
                Job::exec('php ' . CUSTOM_APPLICATION_PATH . '/commands/exportDEEQueueManager.php');
            }
        }
        else {
            $this->logger->debug('GMLExport: IMPOSSIBLE to add job, submission id : ' . $submissionId);
        }

        echo json_encode($return);
        // No View, we send directly the JSON
        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
        $this->getResponse()->setHeader('Content-type', 'application/json');
    }

    /**
     * Cancel export action. See cancelExport.
     */
    public function cancelExportAction() {
        $submissionId = $this->_getParam("submissionId");
        $this->logger->debug('GMLExport: cancel export, submission id : ' . $submissionId);

        $success = $this->cancelExport($submissionId);

        $return = array(
            'submissionId' => $submissionId,
            "success" => $success,
        );
        if ($success) {
            $return['status'] = Application_Service_JobManagerService::NOTFOUND;
        }
        echo json_encode($return);

        // No View, we send directly the JSON
        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
        $this->getResponse()->setHeader('Content-type', 'application/json');
    }

    /**
     * Cancel an Export.
     * Delete the file if exists;
     * Cancel the job;
     * Delete line in export_file.
     *
     */
    protected function cancelExport($submissionId) {
        // Test if there is already an export_file entry
        if (! $this->exportFileModel->existsExportFileData($submissionId) ) {
            return false;
        }

        // Warning !!! don't change order of following operations (ON DELETE CASCADE...)

        // Physically delete old file
        if ($this->exportFileModel->existsExportFileOnDisk($submissionId)) {
            $this->logger->debug('GMLExport: physically delete old file');
            $this->exportFileModel->deleteExportFileFromDisk($submissionId);
        }
        // Check if file still exists (error on deletion...)
        $success = !$this->exportFileModel->existsExportFileOnDisk($submissionId);
        if (!$success) {
            $this->logger->debug('GMLExport: problem, old file still exists.');
        }

        // Cancel the job
        $jobId = $this->getJobIdForSubmission($submissionId);
        if ($jobId) {
            $success = $success && $this->jobManager->cancelJob($jobId);
        }
        else {
            $success = false;
            $this->logger->debug('GMLExport: error, couldn \'t get job id');
        }

        // Delete from the export_file table
        $success = $success && $this->exportFileModel->deleteExportFileData($submissionId);

        return $success;
    }


    /**
     * Get the status of the export job for submission
     * submissionId (GET or POST parameter)
     */
    public function getStatusAction() {
        $submissionId = $this->_getParam("submissionId");
        $this->logger->debug('GMLExport: getStatus, submission id : ' . $submissionId);

        $jobId = $this->getJobIdForSubmission($submissionId);
        if (!$jobId) {
            $status = Application_Service_JobManagerService::NOTFOUND;
        }
        else {
            $status = $this->jobManager->getStatus($jobId);
        }

        $return = array(
            "submissionId" => $submissionId,
            "status" => $status
        );

        if ($status == 'RUNNING') {
            $return['progress'] = $this->jobManager->getProgressPercentage($jobId);
        }

        echo json_encode($return);
        // No View, we send directly the JSON
        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
        $this->getResponse()->setHeader('Content-type', 'application/json');
    }

    /**
     * Get status of a list of export jobs
     * submissionIds: (GET or POST parameter, array)
     */
    public function getAllStatusAction() {
        $submissionIds = $this->_getParam("submissionIds");
        $this->logger->debug('GMLExport: getAllStatus, submission ids : ' . implode(',',$submissionIds));

        $return = array();
        foreach ($submissionIds as $submissionId) {
            $jobId = $this->getJobIdForSubmission($submissionId);
            if (!$jobId) {
                $status = Application_Service_JobManagerService::NOTFOUND;
            }
            else {
                $status = $this->jobManager->getStatus($jobId);
            }

            $part = array(
                "submissionId" => $submissionId,
                "status" => $status
            );

            if ($status == 'RUNNING') {
                $part['progress'] = $this->jobManager->getProgressPercentage($jobId);
            }
            $return[] = $part;
        }

        echo json_encode($return);
        // No View, we send directly the JSON
        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
        $this->getResponse()->setHeader('Content-type', 'application/json');
    }

    /**
     * Download the GML File
     *
     * @throws Zend_Exception
     */
    public function downloadAction()
    {
        // To handle large files
        set_time_limit(0);

        // Get the submission Id
        $submissionId = $this->_getParam("submissionId");
        $this->logger->debug('GMLExport: download file, submission id : ' . $submissionId);

        // Check if the job is completed, get the filename, and checks if the file exists
        $jobId = $this->getJobIdForSubmission($submissionId);
        if (!$jobId) {
            $this->logger->debug('GMLExport: error, couldn\'t find job id');
            throw new Exception("Could not find export_file for submission $submissionId");
        }
        $status = $this->jobManager->getStatus($jobId);
        if ($status != Application_Service_JobManagerService::COMPLETED) {
            $this->logger->debug('GMLExport: DEE generation is not completed');
            throw new Exception("DEE generation is not completed for submission $submissionId");
        }
        $exportFile = $this->exportFileModel->getExportFileData($submissionId);
        $filePath = $exportFile->file_name;
        $fileName = pathinfo($filePath, PATHINFO_BASENAME);

        if (!is_file( $filePath )) {
            $this->logger->debug('GMLExport: DEE file does not exist');
            throw new Exception("DEE file does not exist for submission $submissionId");
        }

        // -- Get back the file

        // Define the header of the response
        $this->getResponse()->setHeader('Content-Type', 'text/xml;charset=utf-8;application/force-download;', true);
        $this->getResponse()->setHeader('Content-disposition', 'attachment; filename=' . $fileName, true);

        $file = fopen($filePath,"rb");
        while(!feof($file))
        {
            print(@fread($file, 1024*8));
        }

        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
    }

    /**
     * Utility function: get the job id for a given submission id, from table raw_data.export_file
     *
     * @param $submissionId
     * @return bool
     */
    protected function getJobIdForSubmission( $submissionId) {
        if (!$this->exportFileModel->existsExportFileData($submissionId)) {
            return false;
        }
        $exportFile = $this->exportFileModel->getExportFileData($submissionId);
        return $exportFile->job_id; // return the job_id or false
    }

}
