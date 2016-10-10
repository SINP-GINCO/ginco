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
 * This is the moel for the Export File (DEE in GML format) model.
 *
 * @package models
 */
class Application_Model_RawData_ExportFile extends Zend_Db_Table_Abstract {

    //== Properties defined in Zend_Db_Table_Abstract

    // Db table name
    protected $_name = 'raw_data.export_file';
    // Primary key column
    protected $_primary = 'submission_id';

    protected $logger;
    protected $lang;

    /**
     * Initialisation
     */
    public function init() {
        $this->logger = Zend_Registry::get("logger");

        $translate = Zend_Registry::get('Zend_Translate');
        $this->lang = strtoupper($translate->getAdapter()->getLocale());
    }

    /**
     * Get a boolean telling if there is a line in export_file
     * for the given submission id
     *
     * @param $id
     * @return boolean
     */
    public function existsExportFileData($submissionId) {
        $row = $this->fetchRow("submission_id = '" . $submissionId . "'");
        if (!$row) {
            return false;
        }
        return true;
    }

    /**
     * Get an export_file by submission id
     *
     * @param $id
     * @return Rowset
     * @throws Exception
     */
    public function getExportFileData($submissionId) {
        $row = $this->fetchRow("submission_id = '" . $submissionId . "'");
        if (!$row) {
            throw new Exception("Could not find export_file for submission $submissionId");
        }
        return $row;
    }

    /**
     * Add a new export_file line
     *
     * @param $submissionId
     * @param $jobId
     * @param $fileName
     * @param int $fileSize
     * @return mixed : last id inserted
     * @throws Exception
     */
    public function addExportFile($submissionId, $jobId, $fileName) {
        if ($this->existsExportFileData($submissionId)) {
            throw new Exception("An export file already exists for submission  $submissionId");
        }
        $data = array(
            'submission_id' => $submissionId,
            'job_id' => $jobId,
            'file_name' => $fileName,
        );
        return $this->insert($data);
    }

    /**
     * Delete an export_filefrom Db
     *
     * @param $id
     */
    public function deleteExportFileData($submissionId) {
        // As there is a on delete cascade on job_id, chances are good that record is already deleted from export_file
        if (!$this->existsExportFileData($submissionId)) {
            return true;
        }
        return $this->delete("submission_id = '" . $submissionId . "'");
    }

   /**
     * Delete an export_file file from disk
     *
     * @param $id
     */
    public function deleteExportFileFromDisk($submissionId) {
        if (!$this->existsExportFileData($submissionId)) {
            return false;
        }
        $exportFile = $this->getExportFileData($submissionId);
        $filePath = $exportFile->file_name;
        return unlink($filePath);
    }

    public function existsExportFileOnDisk($submissionId) {
        if (!$this->existsExportFileData($submissionId)) {
            return false;
        }
        $exportFile = $this->getExportFileData($submissionId);
        $filePath = $exportFile->file_name;
        return is_file($filePath);
    }

    /**
     * Get a "length" measure for the export job.
     * This length is the number of lines in the observation file.
     * If there is several files in the import, we take the max of lines.
     *
     * @param $submissionId
     * @return mixed
     */
    public function getJobLengthForSubmission($submissionId) {
        $db = $this->getAdapter();
        $sql = "select max(nb_line) from submission_file where submission_id = ?";
        $select = $db->prepare($sql);
        $select->execute(array($submissionId));
        $length = $select->fetchColumn();
        return $length;
    }

    /**
     * Generate an absolute file path for export file
     *
     * @param $submissionId
     * @return string
     */
    public function generateFilePath($submissionId) {
        $configuration = Zend_Registry::get('configuration');
        $filePath = $configuration->getConfig('UploadDirectory') . '/DEE/'. $submissionId . '/';
        $filename = "DEE-Submission-$submissionId-" . date('YmdHi') . '.xml';
        return $filePath . $filename ;
    }

}
