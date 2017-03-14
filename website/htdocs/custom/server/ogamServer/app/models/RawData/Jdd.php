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
 * This is the model for the jdd.
 *
 * @package models
 */
class Application_Model_RawData_Jdd extends Zend_Db_Table_Abstract {

	// == Properties defined in Zend_Db_Table_Abstract

	// Db table name
	protected $_name = 'raw_data.jdd';
	// Primary key column
	protected $_primary = 'id';

	protected $logger;

	protected $lang;

	/**
	 * Initialization
	 */
	public function init() {
		$this->logger = Zend_Registry::get("logger");

		$translate = Zend_Registry::get('Zend_Translate');
		$this->lang = strtoupper($translate->getAdapter()->getLocale());
	}

	/**
	 * Add a new jdd in Db.
	 *
	 * @param Application_Object_Website_Jdd $jdd
	 *        	The jdd
	 * @return Application_Object_Website_Jdd the jdd updated with the last id inserted
	 */
	public function add($jdd) {
		$data = array(
			'jdd_metadata_id' => $jdd->jddMetadataId,
			'title' => $jdd->title,
			'status' => $jdd->status,
			'model_id' => $jdd->modelId
		);
		return $this->insert($data);
	}

	/**
	 * Get the jdd corresponding to the id.
	 *
	 * @param
	 *        	$id
	 * @return boolean
	 */
	public function getJddByMetadataId($id) {
		$select = $this->select()->where('jdd_metadata_id = ?', $id);
		$row = $this->fetchRow($select);
		if ($row !== null) {
			return $row->toArray();
		}
	}

	/**
	 * Remove the submission_id from the jdd line linked to this submission_id.
	 *
	 * @param Integer $submissionId
	 *        	the submission id
	 * @return boolean
	 */
	public function removeSubmission($submissionId) {
		$data = array(
			'submission_id' => NULL
		);
		$where = $this->getAdapter()->quoteInto('submission_id = ?', $submissionId);
		return $this->update($data, $where);
	}
}
