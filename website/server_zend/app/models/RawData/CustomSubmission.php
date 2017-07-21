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
 * This is the CustomSubmission model.
 * Extends model with functions to create reports:
 *  - sensibility report
 *  - provider id to permanent id report
 *  - integration report
 *
 * @package models
 */
include_once APPLICATION_PATH . '/models/RawData/Submission.php';

class Application_Model_RawData_CustomSubmission extends Application_Model_RawData_Submission {

    protected $metadataModel;
    protected $customMetadataModel;
    protected $genericModel;
    protected $genericService;
    protected $configuration;
    protected $translator;
    protected $translations;

    /**
     * Initialisation.
     */
    public function __construct() {

        parent::__construct();

        // Initialise a metadata model
        $this->metadataModel = new Application_Model_Metadata_Metadata();
        // Custom Metadata Model : methods used only in Ginco
        $this->customMetadataModel = new Application_Model_Metadata_CustomMetadata();
        // Generic Model
        $this->genericModel = new Application_Model_Generic_Generic();
        // Generic Service
        $this->genericService = new Application_Service_GenericService();
        // Configuration
        $this->configuration = Zend_Registry::get("configuration");
        // Get the translator
        $this->translator = Zend_Registry::get('Zend_Translate');
        // translations
        $this->translations = array();
    }

    /**
     * Get submission files
     *
     * @param $submissionId
     * @return array
     */
    public function getSubmissionFiles($submissionId) {
        Zend_Registry::get("logger")->info('getSubmissionFiles : ' . $submissionId);

        $req = " SELECT * FROM submission_file WHERE submission_id = ?";
        $select = $this->db->prepare($req);
        $select->execute(array(
            $submissionId
        ));

        $results = array();
        foreach ($select->fetchAll() as $row) {
            $results[] = $row;
        }
        return $results;
    }


}