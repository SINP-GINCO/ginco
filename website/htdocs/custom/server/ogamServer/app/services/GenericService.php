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
	 * Make the table_tree JOIN if necessary.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param Application_Object_Generic_DataObject $dataObject
	 *        	the query object (list of TableFields)
	 * @param Array|String $joinTables
	 *        	the extra tables to join in the request
	 * @param String $geometryTablePKeyIdWithTable
	 *        	the full name of the ogam_id primary key of the table which contains the geometry field (in the form tablename.ogam_id_<xxx>)
	 * @param String $geometryTablePKeyProviderIdWithTable
	 *        	the full name of the provider_id primary key of the table which contains the geometry field (in the form tablename.xxx)
	 * @return String a SQL request
	 */
	public function generateSQLFromRequestCustom($schema, $dataObject, $joinTables = array(), $geometryTablePKeyIdWithTable = null, $geometryTablePKeyProviderIdWithTable = null) {
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
			$from .= " LEFT JOIN mapping.results ON results.id_observation = $geometryTablePKeyIdWithTable AND results.id_provider = $geometryTablePKeyProviderIdWithTable";
		}
		
		// Add the joined tables
		foreach ($tables as $tableTreeData) {
			
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

	/**
	 * Get the FROM clause, with JOINS linking youngest requested table to mapping.results table
	 *
	 * @param String $schema        	
	 * @param string $tableFormat the format of the requested table   	
	 */
	public function getJoinToGeometryTable($schema, $tableFormat) {
		$this->logger->debug('getJoinToGeometryTable');
				
		// Get the ancestors of the table
		$customMetadataModel = new Application_Model_Metadata_CustomMetadata();
		$ancestors = $customMetadataModel->getTablesTree($tableFormat, $schema);
		
		// Get the ancestors to the geometry table only
		$ancestorsToGeometry = $customMetadataModel->getAncestorsToGeometry($schema, $ancestors);
		
		// Add the requested table (FROM)
		$ancestorsValue = array_values($ancestorsToGeometry);
		$requestedTable = array_shift($ancestorsValue);
		
		$logicalName = $requestedTable->getLogicalName();
		$this->logger->debug('requested table format : ' . $logicalName);
		
		$from = " FROM " . $requestedTable->tableName . " " . $logicalName;
		
		// Add the joined tables (when there is ancestors)
		foreach ($ancestorsToGeometry as $tableTreeData) {
			if ($tableTreeData->parentTable != '*') {
				$parentTableName = $ancestorsToGeometry[$tableTreeData->parentTable]->tableName;
				$from .= " JOIN " . $parentTableName . " " . $tableTreeData->parentTable . " on (";
				// Add the join keys
				$keys = explode(',', $tableTreeData->keys);
				foreach ($keys as $key) {
					$from .= $tableTreeData->getLogicalName() . "." . trim($key) . " = " . $tableTreeData->parentTable . "." . trim($key) . " AND ";
				}
				$from = substr($from, 0, -5);
				$from .= ") ";
			}
		}
		
		// Add  JOIN beetween results table and the table which contains the geometry column (last table of the list)
		$geometryTable = array_pop(array_values($ancestorsToGeometry));
		$this->logger->debug('geometryTable : ' . $geometryTable->tableFormat);
		
		$geometryTableFormat = $customMetadataModel->getTableFormat($schema, $geometryTable->tableFormat);
		$geometryTableFormatKeys = $geometryTableFormat->primaryKeys;
		foreach ($geometryTableFormatKeys as $geometryKey) {
			if (strtolower(trim($geometryKey)) != 'provider_id') {
				$geometryTablePKeyId = trim($geometryKey);
			}
		}
		$from .= " LEFT JOIN mapping.results ON results.id_observation = " . $geometryTable->tableFormat . "." . $geometryTablePKeyId . " AND results.id_provider = " . $geometryTable->tableFormat . ".provider_id";
		
		$this->logger->debug('getJoinToGeometryTable :' . $from);
		return $from;
	}
}