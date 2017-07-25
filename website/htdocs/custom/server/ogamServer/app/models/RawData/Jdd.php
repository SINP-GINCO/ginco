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

	protected $dbConn;

	public function __construct() {
		parent::__construct();

		// Initialize the logger
		$this->logger = Zend_Registry::get("logger");

		// The database connection
		$this->dbConn = Zend_Registry::get('raw_db');
	}

	function __destruct() {
		$this->dbConn->closeConnection();
	}

	/**
	 * Initialization
	 */
	public function init() {
		$this->logger = Zend_Registry::get("logger");

		$translate = Zend_Registry::get('Zend_Translate');
		$this->lang = strtoupper($translate->getAdapter()->getLocale());
	}


	/**
	 * Find the datasets (jdd) which are not deleted.
	 *
	 * @param Application_Object_RawData_Jdd $jdd
	 *        	The jdd
	 * @return Application_Object_RawData_Jdd the jdd updated with the last id inserted
	 */
	public function findNotDeleted($providerId = null) {
		$this->logger->debug("findNotDeleted");
		$translator = Zend_Registry::get('Zend_Translate');
		Zend_Registry::get("logger")->info('getDatasets');
		// Retrieve jdd data
		$jddReq = "SELECT id, jdd_metadata_id, title, substring(title from 0 for 32) as short_title,
			status, created_at, submission_id, export_file_id
			FROM raw_data.jdd WHERE status <> 'deleted'
			ORDER BY id DESC";

		$selectJdd = $this->dbConn->prepare($jddReq);

		$selectJdd->execute();

		$result = array();
		foreach ($selectJdd->fetchAll() as $row) {

			$jddId = $row['id'];
			$submissionId = $row['submission_id'];
			$exportFileId = $row['export_file_id'];
			// Format metadata_id (with this form : ...e682aa)
			$jddMetadataId = $row['jdd_metadata_id'];
			$jddMetadataIdShort = "..." . substr($jddMetadataId, strlen($jddMetadataId) - 6, strlen($jddMetadataId));
			// Format of the tooltip of the submission and jddMetadata id
			$submissionIdTooltip = $translator->translate("Submission identifier") . " : $submissionId";
			$jddMetadataIdTooltip = $translator->translate("Jdd metadata id") . " : $jddMetadataId";
			// Format title
			$title = $row['title'];
			$titleShort = $row['short_title'];
			if (strlen($title) != strlen($titleShort)) {
				$titleShort = $titleShort . "...";
			}
			// Format creation date
			$createdAt = new DateTime($row['created_at']);
			$createdAt = $createdAt->format('d/m/Y');

			$jddInfo = array(
				'id' => $jddId,
				'submission_id_tooltip' => $submissionIdTooltip,
				'jdd_metadata_id_tooltip' => $jddMetadataIdTooltip,
				'jdd_metadata_id' => $jddMetadataId,
				'jdd_metadata_id_short' => $jddMetadataIdShort,
				'submission_id' => $row['submission_id'],
				'title' => $title,
				'title_short' => $titleShort,
				'created_at' => $createdAt,
				'nb_data' => '-',
				'provider_label' => '-'
			);

			if (isset($submissionId)) {
				// Retrieve submission data
				$submissionReq = " SELECT provider_id, p.label as provider_label, nb_line, s.status, step, file_type, file_name ";
				$submissionReq .= " FROM raw_data.submission s ";
				$submissionReq .= " LEFT JOIN raw_data.submission_file USING (submission_id)";
				$submissionReq .= " LEFT JOIN website.providers p ON p.id = s.provider_id";
				$submissionReq .= " WHERE submission_id = ? ";

				if ($providerId) {
					$req .= " AND provider_id = ?";
				}

				$selectSubmission = $this->dbConn->prepare($submissionReq);
				$params = array();
				$params[] = $submissionId;
				if ($providerId) {
					$params[] = $providerId;
				}
				$selectSubmission->execute($params);
				$submission = $selectSubmission->fetch();

				// Empty submission id tooltip if is canceled
				if ($submission['step'] === 'CANCEL' || $submission['step'] === 'INIT') {
					$jddInfo['submission_id_tooltip'] = $translator->translate("Submission identifier") . " : / ";
					$jddInfo['provider_id'] = '-';
					$jddInfo['provider_label'] = '-';
					$jddInfo['nb_data'] = '-';
					$jddInfo['file_type'] = '-';
					$jddInfo['file_name'] = '-';
					$jddInfo['status'] = $submission['status'];
					$jddInfo['step'] = $submission['step'];
				} else {
					$jddInfo['provider_id'] = $submission['provider_id'];
					$jddInfo['provider_label'] = $submission['provider_label'];
					$jddInfo['nb_data'] = $submission['nb_line'];
					$jddInfo['status'] = $submission['status'];
					$jddInfo['file_type'] = $submission['file_type'];
					$jddInfo['file_name'] = $submission['file_name'];
					$jddInfo['step'] = $submission['step'];
				}

				if($submission['step'] === 'INIT') {
					$jddInfo['nb_data'] = 0;
				}
			} else {
				$jddInfo['submission_id_tooltip'] = $translator->translate("Submission identifier") . " : / ";
			}

			if (isset($exportFileId)) {
				$jddInfo['export_file_id'] = $exportFileId;
			}

			$result[$jddId] = $jddInfo;
		}

		return $result;
	}

	/**
	 * Add a new jdd in Db.
	 *
	 * @param Application_Object_RawData_Jdd $jdd
	 *        	The jdd
	 * @return Application_Object_RawData_Jdd the jdd updated with the last id inserted
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
	 * Update an existing jdd.
	 *
	 * @param Application_Object_RawData_Jdd $jdd
	 *        	The jdd
	 * @return Integer the result of the update
	 */
	public function updateJdd($jdd) {
		$data = array();
		if (isset($jdd['title'])) {
			$data['title'] = $jdd['title'];
		}
		if (isset($jdd['status'])) {
			$data['status'] = $jdd['status'];
		}
		if (isset($jdd['modelId'])) {
			$data['model_id'] = $jdd['modelId'];
		}

		$where = $this->getAdapter()->quoteInto('id = ?', $jdd['id']);
		return $this->update($data, $where);
	}

	/**
	 * Get the jdd by its internal id
	 *
	 * @param $id
	 * @return object
	 * @throws Exception
	 */
	public function getJddById($id) {
		$row = $this->fetchRow("id = '" . $id . "'");
		if (!$row) {
			throw new Exception("Could not find jdd $id");
		}
		return $row->toArray();
	}

	/**
	 * Get the jdd corresponding to the metadata_id.
	 * Only the jdd that is not in deleted status is returned.
	 *
	 * @param
	 *        	$id
	 * @return boolean
	 */
	public function getJddByMetadataId($id) {
		$select = $this->select()
		->where('jdd_metadata_id = ?', $id)
		->where('status <> ?', 'deleted');
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

	/**
	 * Add the export_file_id to the jdd line linked to this export_file_id.
	 *
	 * @param Integer $id
	 *        	the id of the jdd
	 * @param Integer $exportFileId
	 *        	the id of the export file
	 * @return boolean
	 */
	public function addExportFile($id, $exportFileId) {
		$data = array(
			'export_file_id' => $exportFileId
		);
		$where = $this->getAdapter()->quoteInto('id = ?', $id);
		return $this->update($data, $where);
	}

	/**
	 * Set the status of the jdd linked to the given id to 'empty'.
	 *
	 * @param Integer $id
	 *        	the id of the jdd
	 * @return boolean
	 */
	public function cancel($id) {
		$data = array(
			'status' => 'deleted',
			'model_id' => null
		);
		$where = $this->getAdapter()->quoteInto('id = ?', $id);
		return $this->update($data, $where);
	}
}
