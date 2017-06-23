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
		$ancestorsValue = array_values($ancestorsToGeometry);
		$geometryTable = array_pop($ancestorsValue);
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