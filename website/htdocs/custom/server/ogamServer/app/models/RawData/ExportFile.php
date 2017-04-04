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
 * This is the model for the Export File (DEE in GML format) model.
 *
 * @package models
 */
class Application_Model_RawData_ExportFile extends Zend_Db_Table_Abstract {

    //== Properties defined in Zend_Db_Table_Abstract

    // Db table name
    protected $_name = 'raw_data.export_file';
    // Primary key column
    protected $_primary = 'id';

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
     * for the given id
     *
     * @param $id
     * @return boolean
     */
    public function existsExportFileData($id) {
        $row = $this->fetchRow("id = '" . $id . "'");
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
    public function getExportFileData($id) {
        $row = $this->fetchRow("id = '" . $id . "'");
        if (!$row) {
            throw new Exception("Could not find export_file for id $id");
        }
        return $row;
    }

    /**
     * Add a new export_file line
     *
     * @param $jobId
     * @param $fileName
     * @param $userLogin : the user who initiated the export
     * @param int $fileSize
     * @return mixed : last id inserted
     * @throws Exception
     */
    public function addExportFile($jddId, $jobId, $fileName, $userLogin) {
        $this->logger->debug("addExportFile $fileName for jdd $jddId (job id $jobId, user: $userLogin)");
        $data = array(
            'job_id' => $jobId,
            'file_name' => $fileName,
            'user_login' => $userLogin,
        );
        return $this->insert($data);
    }

    /**
     * Delete an export_file from Db
     *
     * @param $id
     */
    public function deleteExportFileData($id) {
        $this->logger->debug("deleteExportFileData for id $id");
        // As there is a on delete cascade on job_id, chances are good that record is already deleted from export_file
        if (!$this->existsExportFileData($id)) {
            return true;
        }
        return $this->delete("id = '" . $id . "'");
    }

    /**
     * Delete an export_file file from disk
     *
     * @param $id
     */
    public function deleteExportFileFromDisk($id) {
        $this->logger->debug("deleteExportFileFromDisk for id $id");
         if (!$this->existsExportFileData($id)) {
             return false;
         }
        $exportFile = $this->getExportFileData($id);
        $filePath = $exportFile->file_name;
        return unlink($filePath);
    }

    public function existsExportFileOnDisk($id) {
        if (!$this->existsExportFileData($id)) {
            return false;
        }
        $exportFile = $this->getExportFileData($id);
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
     * @param $jddId
     * @return string
     */
    public function generateFilePath($jddId) {
        $configuration = Zend_Registry::get('configuration');

        $regionCode = $configuration->getConfig('regionCode','REGION');
        $date = date('Y-m-d_H-i-s');
        $uuid = $jddId;

        $fileNameWithoutExtension = $regionCode . '_' . $date . '_' . $uuid ;

        $filePath = $configuration->getConfig('deePrivateDirectory') . '/' . $fileNameWithoutExtension . '/';
        $filename = $fileNameWithoutExtension . '.xml';

        return $filePath . $filename ;
    }

}
