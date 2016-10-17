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
include_once APPLICATION_PATH . '/services/GenericService.php';

/**
 * The Generic Service.
 *
 * This service handles transformations between data objects and generate generic SQL requests from the metadata.
 *
 * @package Application_Service
 */
class Custom_Application_Service_GenericService extends Application_Service_GenericService {

	/**
	 * The logger.
	 *
	 * @var Zend_Log
	 */
	var $logger;

	/**
	 * Generate the FROM clause of the SQL request corresponding to a list of parameters.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param Application_Object_Generic_DataObject $dataObject
	 *        	the query object (list of TableFields)
	 * @return String a SQL request
	 */
	public function generateSQLFromRequestCustom($schema, $dataObject, $pKeyIdWithTable, $pKeyProviderIdWithTable, $joinTables) {
		$this->logger->debug('generateSQLFromRequest');

		//
		// Prepare the FROM clause
		//

		// Prepare the list of needed tables
		$tables = $this->getAllFormats($schema, $dataObject);

		// Add the root table;
		$rootTable = array_shift($tables);
		$logicalName = $rootTable->getLogicalName();
		$from = " FROM " . $rootTable->tableName . " " . $logicalName;

		// Add the user asked joined tables
		if (in_array('submission', $joinTables)) {
			$from .= " LEFT JOIN $schema.submission ON submission.submission_id = $logicalName.submission_id";
		}
		if (in_array('results', $joinTables)) {
			$from .= " LEFT JOIN mapping.results ON results.id_observation = $pKeyIdWithTable AND results.id_provider = $pKeyProviderIdWithTable";
		}

		// Add the joined tables
		$i = 0;
		foreach ($tables as $tableTreeData) {
			$i ++;

			// Join the table
			$from .= " JOIN " . $tableTreeData->tableName . " " . $tableTreeData->getLogicalName() . " on (";

			// Add the join keys
			$keys = explode(',', $tableTreeData->keys);
			foreach ($keys as $key) {
				$from .= $tableTreeData->getLogicalName() . "." . trim($key) . " = " . $tableTreeData->parentTable . "." . trim($key) . " AND ";
			}
			$from = substr($from, 0, -5);
			$from .= ") ";
		}

		$this->logger->debug('generateSQLFromRequest :' . $from);
		return $from;
	}

	/**
	 * Generate the WHERE clause of the SQL request corresponding to a list of parameters.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param Application_Object_Generic_DataObject $dataObject
	 *        	the query object (list of TableFields)
	 * @return String a SQL request
	 */
	public function generateSQLWhereRequestCustom($schemaCode, $dataObject) {
		$this->logger->debug('generateSQLWhereRequest');

		// Prepare the list of needed tables
		$tables = $this->getAllFormats($schemaCode, $dataObject);

		// Add the root table;
		$rootTable = array_shift($tables);

		// Get the root table fields
		$rootTableFields = $this->metadataModel->getTableFields($schemaCode, $rootTable->getLogicalName());
		$hasColumnProvider = array_key_exists('PROVIDER_ID', $rootTableFields);

		//
		// Prepare the WHERE clause
		//
		$where = " WHERE (1 = 1)";
		foreach ($dataObject->infoFields as $tableField) {
			if ($tableField->subtype == 'ID') {
				// exact search
				$where .= $this->buildWhereItem($schemaCode, $tableField, true);
			} else {
				$where .= $this->buildWhereItem($schemaCode, $tableField, false);
			}
		}

		// Right management
		// Check the provider id of the logged user
		$userSession = new Zend_Session_Namespace('user');
		if (!empty($userSession->user)) {
			$providerId = $userSession->user->provider->id;
			if (!$userSession->user->isAllowed('DATA_QUERY_OTHER_PROVIDER') && $hasColumnProvider) {
				$where .= " AND " . $rootTable->getLogicalName() . ".provider_id = '" . $providerId . "'";
			}
		}

		if (!$userSession->user->isAllowed('CONFIRM_SUBMISSION')) {
			// user with "publish data" permission can see submissions all the time
			$where .= " AND submission.step = 'VALIDATE' ";
		}

		// Return the completed SQL request
		return $where;
	}
}