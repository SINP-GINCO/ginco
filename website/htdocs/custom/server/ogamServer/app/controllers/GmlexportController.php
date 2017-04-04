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

    protected $jddModel = null;

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

        // JddnModel
        $this->jddModel = new Application_Model_RawData_Jdd();

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
        $exportFileId = $this->_getParam("exportFileId");
        $jddId = $this->_getParam("jddId");
        $submissionId = $this->_getParam("submissionId");
        $launch = $this->_getParam("launch", true);

        $userSession = new Zend_Session_Namespace('user');
        $userLogin = $userSession->user->login;

        $this->logger->debug('GMLExport: add job in queue, export file id : ' . $exportFileId . ', jdd id : ' . $jddId);

        // Get the jdd uuid
        $jddModel = new Application_Model_RawData_Jdd();
        $jddResult = $jddModel->find($jddId);
        $jddResult->current();
        $jdd =  $jddResult->toArray()[0];
        $uuid = $jdd['jdd_metadata_id'];

        // Test if there is already an export file
        if ($exportFileId > 0 && $this->exportFileModel->existsExportFileData($exportFileId)) {
            $this->logger->debug('GMLExport: export_file already exists, deleting it. Export file id : ' . $exportFileId);
            $this->cancelExport($exportFileId);
        }

        // export file name
        $filePath = $this->exportFileModel->generateFilePath($uuid);

        // Command to launch the GML Export Job
        $command = 'php ' . CUSTOM_APPLICATION_PATH . '/commands/generateDEE.php -m ' . $jddId . ' -f ' . $filePath . ' -u ' . $userLogin;
        // Length of the observation files
        $length = $this->exportFileModel->getJobLengthForSubmission($submissionId);

        $jobId = $this->jobManager->addJob( $command, self::JOBTYPE , $length );

        if ($jobId) {
            // Insert a line in export_file table
            $exportFileId = $this->exportFileModel->addExportFile($jddId, $jobId, $filePath, $userLogin);
            // Update jdd with the export file id
            $this->jddModel->addExportFile($jddId, $exportFileId);
        }
        else {
            $this->logger->debug('GMLExport: IMPOSSIBLE to add export_file entry, jdd id : ' . $jddId);
        }

        $return = array(
            'exportFileId' => $exportFileId,
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
        $id = $this->_getParam("id");
        $this->logger->debug('GMLExport: cancel export, export file id : ' . $id);

        $success = $this->cancelExport($id);

        $return = array(
            'id' => $id,
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
    protected function cancelExport($id) {
        // Test if there is already an export_file entry
        if (! $this->exportFileModel->existsExportFileData($id) ) {
            return false;
        }

        // Warning !!! don't change order of following operations (ON DELETE CASCADE...)

        // Physically delete old file
        if ($this->exportFileModel->existsExportFileOnDisk($id)) {
            $this->logger->debug('GMLExport: physically delete old file');
            $this->exportFileModel->deleteExportFileFromDisk($id);
        }
        // Check if file still exists (error on deletion...)
        $success = !$this->exportFileModel->existsExportFileOnDisk($id);
        if (!$success) {
            $this->logger->debug('GMLExport: problem, old file still exists.');
        }

        // Cancel the job
        $jobId = $this->getJobIdFromExportFile($id);
        if ($jobId) {
            $success = $success && $this->jobManager->cancelJob($jobId);
        }
        else {
            $success = false;
            $this->logger->debug('GMLExport: error, couldn \'t get job id');
        }

        // Delete from the export_file table
        $success = $success && $this->exportFileModel->deleteExportFileData($id);

        return $success;
    }


    /**
     * Get the status of the export job for submission
     * submissionId (GET or POST parameter)
     */
    public function getStatusAction() {
        $submissionId = $this->_getParam("submissionId");
        $this->logger->debug('GMLExport: getStatus, submission id : ' . $submissionId);

        $jobId = $this->getJobIdFromExportFile($submissionId);
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
        $jddIds = $this->_getParam("jddIds");
        $this->logger->debug('GMLExport: getAllStatus, submission ids : ' . implode(',',$submissionIds));

        $return = array();
        $i = 0;
        foreach ($submissionIds as $submissionId) {
            $jddId = $jddIds[$i];
            $jobId = $this->getJobIdFromExportFile($submissionId);
            if (!$jobId) {
                $status = Application_Service_JobManagerService::NOTFOUND;
            }
            else {
                $status = $this->jobManager->getStatus($jobId);
            }

            $part = array(
                "jddId" => $jddId,
                "submissionId" => $submissionId,
                "status" => $status
            );

            if ($status == 'RUNNING') {
                $part['progress'] = $this->jobManager->getProgressPercentage($jobId);
            }
            $return[] = $part;
            $i++;
        }

        echo json_encode($return);
        // No View, we send directly the JSON
        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
        $this->getResponse()->setHeader('Content-type', 'application/json');
    }

    /**
     * Download the DEE Zip File
     *
     * @throws Zend_Exception
     */
    public function downloadAction()
    {
        // To handle large files
        set_time_limit(0);

        // Get the export file Id
        $id = $this->_getParam("id");
        $this->logger->debug('GMLExport: download file, export file id : ' . $id);

        // Check if the job is completed, get the filename, and checks if the file exists
        $jobId = $this->getJobIdFromExportFile($id);
        if (!$jobId) {
            $this->logger->debug('GMLExport: error, couldn\'t find job id');
            throw new Exception("Could not find export_file with id $id");
        }
        $status = $this->jobManager->getStatus($jobId);
        if ($status != Application_Service_JobManagerService::COMPLETED) {
            $this->logger->debug('GMLExport: DEE generation is not completed');
            throw new Exception("DEE generation is not completed for export file with id $id");
        }
        $exportFile = $this->exportFileModel->getExportFileData($id);
        $filePath = $exportFile->file_name;
        $fileName = pathinfo($filePath, PATHINFO_FILENAME) . '.zip';

        // tests the existence of the zip file
        $configuration = Zend_Registry::get('configuration');
        $archiveFilePath =  $configuration->getConfig('deePublicDirectory') . '/' . $fileName;

        if (!is_file( $archiveFilePath )) {
            $this->logger->debug('GMLExport: DEE archive file does not exist');
            throw new Exception("DEE archive file does not exist for export file with id $id");
        }

        // -- Get back the file

        // Define the header of the response
        $this->getResponse()->setHeader('Content-Type', 'text/xml;charset=utf-8;application/force-download;', true);
        $this->getResponse()->setHeader('Content-disposition', 'attachment; filename=' . $fileName, true);

        $file = fopen($archiveFilePath,"rb");
        while(!feof($file))
        {
            print(@fread($file, 1024*8));
        }

        $this->_helper->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender();
    }

    /**
     * Utility function: get the job id for a given export file id, from table raw_data.export_file
     *
     * @param $exportFileId
     * @return bool
     */
    protected function getJobIdFromExportFile($exportFileId) {
        if (!$this->exportFileModel->existsExportFileData($exportFileId)) {
            return false;
        }
        $exportFile = $this->exportFileModel->getExportFileData($exportFileId);
        return $exportFile->job_id; // return the job_id or false
    }

}
