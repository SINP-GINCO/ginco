<?php
namespace Ign\Bundle\GincoBundle\Manager;

use Doctrine\DBAL\Connection;
use Doctrine\ORM\EntityManager;

use Ign\Bundle\GincoBundle\Services\QueryService;
use Ign\Bundle\GincoBundle\Entity\Generic\BoundingBox;
use Ign\Bundle\GincoBundle\Entity\Generic\GenericTableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableTree;
use Ign\Bundle\GincoBundle\Services\GenericService;
use Ign\Bundle\OGAMConfigurateurBundle\DependencyInjection\Configuration;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\Standard;

/**
 * Class allowing generic access to the RAW_DATA tables.
 */
class GenericManager {

	/**
	 * The system of projection for the visualisation.
	 *
	 * @var String
	 */
	var $visualisationSRS;
	
	/**
	 * The logger.
	 *
	 * @var Logger
	 */
	var $logger;
	
	/**
	 * The generic service.
	 *
	 * @var GenericService
	 */
	protected $genericService;
	
	/**
	 * The metadata Model.
	 *
	 * @var EntityManager
	 */
	protected $metadataModel;
	
	/**
	 * The database connections
	 *
	 * @var Connection
	 */
	protected $rawdb;
	
	/**
	 *
	 * @var Connection
	 */
	protected $metadatadb;
	
	/**
	 * The configuration.
	 *
	 * @var Configuration
	 */
	protected $configuration;

	/**
	 * The query service.
	 *
	 * @var QueryService
	 */
	protected $queryService;

	/**
	 * Initialisation
	 */
	public function __construct($metaModel_em, $raw_em, $genericService, $configuration) {
		
		// Initialise the logger
		// $this->logger = Zend_Registry::get("logger");
		
		// Initialise the projection system
		$this->visualisationSRS = $configuration->getConfig('srs_visualisation', 3857);
		
		// Initialize the configuration object
		$this->configuration = $configuration;
		
		// Initialise the metadata model
		$this->metadataModel = $metaModel_em;
		
		// Initialise the generic service
		$this->genericService = $genericService;
		
		// The database connection
		$this->rawdb = $raw_em->getConnection();
		$this->metadatadb = $metaModel_em->getConnection();
	}

	/**
	 * Fill a line of data with the stored values, given its primary key.
	 * Only one object is expected in return.
	 *
	 * @param GenericTableFormat $data
	 *        	the shell of the data object with the values for the primary key.
	 * @return GenericTableFormat The complete data object.
	 * @throws an exception if no data found
	 */
	public function getDatum(GenericTableFormat $data) {
		$tableFormat = $data->getTableFormat();
	
		$this->logger->info('getDatum : ' . $tableFormat->getFormat());
	
		$schema = $tableFormat->getSchema();
	
		// Get the values from the data table
		$sql = "SELECT " . $this->genericService->buildSelect(array_map(function ($field) {
			return $field->getMetadata();
		}, $data->all()));
		$sql .= " FROM " . $schema->getName() . "." . $tableFormat->getTableName() . " AS " . $tableFormat->getFormat();
		$sql .= " WHERE (1 = 1)" . $this->genericService->buildWhere($schema->getCode(), $data->all());
	
		$this->logger->info('getDatum : ' . $sql);
	
		$select = $this->rawdb->prepare($sql);
		$select->execute();
		$row = $select->fetch();
	
		// Checks if the data exists
		if(empty($row)){
			$msg = "No data found for id: " . implode(', ', $data->getIdFields());
			$this->logger->error($msg);
			throw new \Exception($msg);
		}
	
	
		// Fill the values with data from the table
		foreach ($data->all() as $field) {
			$key = strtolower($field->getId());
			$field->setValue($row[$key]);
			$unit = $field->getMetadata()
			->getData()
			->getUnit();
			// Store additional info for geometry type
			if ($unit->getType() === "GEOM") {
				$xmin = $row[strtolower($key) . '_x_min'];
				$xmax = $row[strtolower($key) . '_x_max'];
				$ymin = $row[strtolower($key) . '_y_min'];
				$ymax = $row[strtolower($key) . '_y_max'];
				$field->setValueBoundingBox(new BoundingBox($xmin, $xmax, $ymin, $ymax));
			} else if ($unit->getType() === "ARRAY") {
				// For array field we transform the value in a array object
				$field->setValue($this->genericService->stringToArray($field->getValue()));
			}
		}
	
		// Fill the values with data from the table
		foreach ($data->all() as $field) {
				
			// Fill the value labels for the field
			$field->setValueLabel($this->genericService->getValueLabel($field->getMetadata(), $field->getValue())); // FIXME: setValueLabel(or handle by template, controller, ..)
		}
	
		return $data;
	}
	
	/**
	 * Fill a line of data with the stored values, given its primary key.
	 * Only one object is expected in return.
	 * MIGRATED.
	 *
	 * @param GenericTableFormat $data
	 *        	the shell of the data object with the values for the primary key.
	 * @param int $requestId
	 *        	the id of the request
	 * @return GenericTableFormat The complete data object.
	 * @throws an exception if no data found
	 */
	public function getDatumGinco(GenericTableFormat $data, $requestId) {
		$tableFormat = $data->getTableFormat();

		$this->logger->info('getDatum Ginco: ' . $tableFormat->getFormat());

		$schema = $tableFormat->getSchema();
		$ĥidingValue = $this->configuration->getConfig('hiding_value');

		// Get the values from the data table
		// We must select hiding_level to determinate for each field if the value must be hidden.
		// Nevertheless, the current table_format is not necessarily the format of the table carrying the geometry.
		// So we can't use it to join on results table everytime.
		// 1- Find the table carrying the geometry
		// 2- Do the JOINS with each ancestor, to the one who carries the geometry
		// => rule : it must be forbidden to put hidden fields in older tables than geometry table.

		$joinToGeometryTable = $this->genericService->getJoinToGeometryTable($schema->getName(), $tableFormat->getFormat());

		$sql = "SELECT DISTINCT " . $this->genericService->buildSelect(array_map(function ($field) {
			return $field->getMetadata();
		}, $data->all()));
		$sql .= ", hiding_level";
		$sql .= $joinToGeometryTable;
		$sql .= " WHERE (1 = 1)" . $this->genericService->buildWhere($schema->getCode(), $data->getIdFields());
		$sql .= " AND results.id_request = '" . $requestId . "'";

		$this->logger->info('getDatum custom : ' . $sql);

		$select = $this->rawdb->prepare($sql);
		$select->execute();
		$row = $select->fetch();

		// Checks if the data exists
		if (empty($row)) {
			$msg = "No data found for id: " . implode(', ', $data->getIdFields());
			$this->logger->error($msg);
			throw new \Exception($msg);
		}

		// Fill the values with data from the table
		foreach ($data->getFields() as $field) {
			$key = strtolower($field->getId());
			$field->setValue($row[$key]);
			$unit = $field->getMetadata()
				->getData()
				->getUnit();
			$shouldValueBeHidden = $this->shouldValueBeHidden($field->getData(), $row['hiding_level']);
			if ($shouldValueBeHidden) {
				$field->setValue($ĥidingValue);
			} else {
				$field->setValue($row[$key]);
			}
			// Store additional info for geometry type
			if ($unit->getType() === "GEOM") {
				$xmin = $row[strtolower($key) . '_x_min'];
				$xmax = $row[strtolower($key) . '_x_max'];
				$ymin = $row[strtolower($key) . '_y_min'];
				$ymax = $row[strtolower($key) . '_y_max'];
				$field->setValueBoundingBox(new BoundingBox($xmin, $xmax, $ymin, $ymax));
			} else if ($unit->getType() === "ARRAY") {
				// For array field we transform the value in a array object
				if ($shouldValueBeHidden) {
					$field->setValue($ĥidingValue);
				} else {
					$field->setValue($this->genericService->stringToArray($field->getValue()));
				}
			}
		}

		// Fill the values with data from the table
		foreach ($data->all() as $field) {

			// Fill the value labels for the field
			$field->setValueLabel($this->genericService->getValueLabel($field->getMetadata(), $field->getValue())); // FIXME: setValueLabel(or handle by template, controller, ..)
		}

		return $data;
	}
	
	/**
	 * Get the information about the ancestors of a line of data.
	 * The key elements in the parent tables must have an existing value in the child.
	 *
	 * @param GenericTableFormat $data
	 *        	the data object we're looking at.
	 * @return GenericTableFormat[] The line of data in the parent tables.
	 */
	public function getAncestors(GenericTableFormat $data) {
		$ancestors = array();
	
		$tableFormat = $data->getTableFormat();
		/* @var $tableFormat TableFormat */
	
		$this->logger->info('getAncestors');
	
		// Get the parent of the current table
		$sql = "SELECT parent_table, join_key";
		$sql .= " FROM TABLE_TREE ";
		$sql .= " WHERE SCHEMA_CODE = '" . $tableFormat->getSchemaCode() . "'";
		$sql .= " AND child_table = '" . $tableFormat->getFormat() . "'";
	
		$this->logger->info('getAncestors : ' . $sql);
	
		$select = $this->metadatadb->prepare($sql);
		$select->execute();
		$row = $select->fetch() ;
		$parentTable = $row['parent_table'] ;
		$joinKeys = explode(',', $row['join_key']) ;
	
		// Check if we are not the root table
		if ($parentTable != null) {
				
			// Build an empty parent object
			$parent = $this->genericService->buildGenericTableFormat($tableFormat->getSchemaCode(), $parentTable, null);
			
			$fields = $data->all() ;
			
			// Fill the PK values (we hope that the child contain the fields of the parent pk)
			foreach ($parent->getIdFields() as $key) {
				$fieldName = $tableFormat->getFormat() . '__' . $key->getData();
				if (array_key_exists($fieldName, $fields)) {
					$keyField = $fields[$fieldName];
					if ($keyField != null && $keyField->getValue() != null) {
						$key->setValue($keyField->getValue());
					}
				}
			}
			
			foreach ($joinKeys as $joinKey) {
				$fieldName = $tableFormat->getFormat() . '__' . $joinKey ;
				if (array_key_exists($fieldName, $fields)) {
					$keyField = $fields[$fieldName] ;
					$parentFieldName = $parent->getTableFormat()->getFormat() . '__' . $joinKey ;
					$key = $parent->getField($parentFieldName) ;
					$key->setValue($keyField->getValue()) ;
				}
			}
				
			// Get the line of data from the table
			$parent = $this->getDatum($parent);
				
			$ancestors[] = $parent;
				
			// Recurse
			$ancestors = array_merge($ancestors, $this->getAncestors($parent));
		}
		return $ancestors;
	}
	
	/**
	 * Get the information about the children of a line of data.
	 *
	 * @param GenericTableFormat $data
	 *        	the data object we're looking at.
	 * @param String $datasetId
	 *        	the dataset id
	 * @return Array[Format => List[GenericTableFormat]] The lines of data in the children tables, indexed by format.
	 */
	public function getChildren($data, $datasetId = null) {
		$children = array();
	
		/* @var $data GenericTableFormat */
		$tableFormat = $data->getTableFormat();
		/* @var $tableFormat TableFormat */
	
		$this->logger->info('getChildren dataset : ' . $datasetId);
	
		// Get the children of the current table
		$sql = "SELECT *";
		$sql .= " FROM TABLE_TREE TT";
		if ($datasetId != null) {
			$sql .= " JOIN (SELECT DISTINCT DATASET_ID, SCHEMA_CODE, FORMAT FROM DATASET_FIELDS) as DF";
			$sql .= " ON DF.SCHEMA_CODE = TT.SCHEMA_CODE AND DF.FORMAT = TT.CHILD_TABLE";
		}
		$sql .= " WHERE TT.SCHEMA_CODE = '" . $tableFormat->getSchemaCode() . "'";
		$sql .= " AND TT.PARENT_TABLE = '" . $tableFormat->getFormat() . "'";
		if ($datasetId != null) {
			$sql .= " AND DF.DATASET_ID = '" . $datasetId . "'";
		}
	
		$this->logger->info('getChildren : ' . $sql);
	
		$select = $this->metadatadb->prepare($sql);
		$select->execute();
	
		// For each potential child table listed, we search for the actual lines of data available
		foreach ($select->fetchAll() as $row) {
			$childTable = $row['child_table'];
			$joinKeys = explode(',', $row['join_key']) ;
				
			// Build an empty data object (for the query)
			$child = $this->genericService->buildGenericTableFormat($tableFormat->getSchemaCode(), $childTable);
			
			$fields = $data->all() ;
			foreach ($joinKeys as $joinKey) {
				$parentFieldName = $data->getTableFormat()->getFormat() . '__' . $joinKey ;
				$childFieldName = $child->getTableFormat()->getFormat() . '__' . $joinKey ;
				if (array_key_exists($parentFieldName, $fields)) {
					$parentField = $fields[$parentFieldName] ;
					$childField = $child->getField($childFieldName) ;
					$childField->setValue($parentField->getValue()) ;
				}
			}
				
			// Get the lines of data corresponding to the partial key
			$childs = $this->_getDataList($child);
				
			// Add to the result
			$children[$child->getTableFormat()->getFormat()->getFormat()] = $childs;
		}
	
		return $children;
	}
	
	/**
	 * Get a list of data objects from a table, given an incomplete primary key.
	 * A list of data objects is expected in return.
	 *
	 * @param GenericTableFormat $data
	 *        	the shell of the data object with the values for the primary key.
	 * @return Array[GenericTableFormat] The complete data objects.
	 */
	protected function _getDataList($data) {
		$this->logger->info('_getDataList');
	
		$result = array();
	
		// The table format descriptor
		$tableFormat = $data->getTableFormat();
	
		$schema = $tableFormat->getSchema();
	
		// Get the values from the data table
		$sql = "SELECT " . $this->genericService->buildSelect(array_map(function ($field) {
			return $field->getMetadata();
		}, $data->all()));
		$sql .= " FROM " . $schema->getName() . "." . $tableFormat->getTableName() . " AS " . $tableFormat->getFormat();
		$sql .= " WHERE (1 = 1)" . $this->genericService->buildWhere($schema->getCode(), array_merge($data->getIdFields(), $data->getFields()));
	
		$this->logger->info('_getDataList : ' . $sql);
	
		$select = $this->rawdb->prepare($sql);
		$select->execute();
		foreach ($select->fetchAll() as $row) {
				
			// Build an new empty data object
			$child = $this->genericService->buildGenericTableFormat($schema->getCode(), $data->getTableFormat()
				->getFormat());
				
			// Fill the values with data from the table
			foreach ($child->all() as $field) {
	
				$field->setValue($row[strtolower($field->getId())]);
	
				if ($field->getMetadata()
					->getData()
					->getUnit()
					->getType() === "ARRAY") {
						// For array field we transform the value in a array object
						$field->setValue($this->genericService->stringToArray($field->getValue()));
					}
	
					// Fill the value labels for the field
					$field->setValueLabel($this->genericService->getValueLabel($field->getMetadata(), $field->getValue())); // FIXME setValueLabel ?
			}
				
			$result[] = $child;
		}
	
		return $result;
	}
	
	/**
	 * Get the join keys
	 *
	 * @param GenericTableFormat $data
	 *        	the shell of the data object.
	 * @return Array[String] The join keys.
	 */
	public function getJoinKeys($data) {
		$tableFormat = $data->getTableFormat();
		/*
		 * $sql = "SELECT join_key";
		 * $sql .= " FROM TABLE_TREE";
		 * $sql .= " WHERE schema_code = '" . $tableFormat->schemaCode . "'";
		 * $sql .= " AND child_table = '" . $tableFormat->format . "'";
		*/
		$joinKeys = $this->metadataModel->find(TableTree::class, array(
			'schema' => $tableFormat->getSchema()
			->getCode(),
			'tableFormat' => $tableFormat->getFormat()
		))
		->getJoinKeys();
	
		return $joinKeys;
	}
	
	/**
	 * Insert a line of data from a table.
	 *
	 * @param GenericTableFormat $data
	 *        	the shell of the data object to insert.
	 * @return GenericTableFormat $data the eventually edited data object.
	 * @throws an exception if an error occur during insert
	 */
	public function insertData($data) {
		$this->logger->info('insertData');
	
		$tableFormat = $data->getTableFormat();
	
		$schema = $tableFormat->getSchema();
	
		// Get the values from the data table
		$sql = "INSERT INTO " . $schema->getName() . "." . $tableFormat->getTableName();
		$columns = "";
		$values = "";
		$return = "";
	
		// updates of the data.
		foreach ($data->getIdFields() as $field) {
			$meta = $field->getMetadata();
			if ($field->getValue() !== null) {
	
				// Primary keys that are not set should be serials ...
				$columns .= $meta->getColumnName() . ", ";
				$values .= $this->genericService->buildSQLValueItem($schema->getCode(), $field);
				$values .= ", ";
			} else {
				$this->logger->info('field ' . $meta->getColumnName() . " " . $meta->getIsCalculated());
	
				// Case of a calculated PK (for example a serial)
				if ($meta->getIsCalculated()) {
					if ($return == "") {
						$return .= " RETURNING ";
					} else {
						$return .= ", ";
					}
					$return .= $meta->getColumnName();
				}
			}
		}
		foreach ($data->getFields() as $field) {
			if ($field->getValue() != null) {
				// Primary keys that are not set should be serials ...
				if ($field->getData() !== "LINE_NUMBER") {
					$columns .= $field->getMetadata()->getColumnName() . ", ";
					$values .= $this->genericService->buildSQLValueItem($schema->getCode(), $field);
					$values .= ", ";
				}
			}
		}
		// remove last commas
		$columns = substr($columns, 0, -2);
		$values = substr($values, 0, -2);
	
		$sql .= "(" . $columns . ") VALUES (" . $values . ")" . $return;
	
		$this->logger->info('insertData : ' . $sql);
	
		$request = $this->rawdb->prepare($sql);
	
		try {
			$request->execute();
		} catch (\Exception $e) {
			$this->logger->error('Error while inserting data  : ' . $e->getMessage());
			throw new \Exception("Error while inserting data  : " . $e->getMessage());
		}
	
		if ($return !== "") {
				
			foreach ($request->fetchAll() as $row) {
				foreach ($data->getIdFields() as $field) {
					if ($field->getMetadata()->getIsCalculated()) {
						$field->setValue($row[strtolower($field->getMetadata()
							->getColumnName())]);
					}
				}
			}
		}
	
		return $data;
	}
	
	/**
	 * Update a line of data from a table.
	 *
	 * @param GenericTableFormat $data
	 *        	the shell of the data object with the values for the primary key.
	 * @throws an exception if an error occur during update
	 */
	public function updateData($data) {
	
		/* @var $data GenericTableFormat */
		$tableFormat = $data->getTableFormat();
		/* @var $tableFormat TableFormat */
	
		$schema = $tableFormat->getSchema();
	
		// Get the values from the data table
		$sql = "UPDATE " . $schema->getName() . "." . $tableFormat->getTableName() . " " . $tableFormat->getFormat();
		$sql .= " SET ";
	
		// updates of the data.
		foreach ($data->getFields() as $valuedField) {
			/* @var $field TableField */
			$field = $valuedField->getMetadata();
			if ($valuedField->getData() != "LINE_NUMBER" && $field->getIsEditable()) {
				// Hardcoded value
				$sql .= $field->getColumnName() . " = " . $this->genericService->buildSQLValueItem($schema->getCode(), $valuedField);
				$sql .= ", ";
			}
		}
		// remove last comma
		$sql = substr($sql, 0, -2);
	
		$sql .= " WHERE (1 = 1)";
	
		// Build the WHERE clause with the info from the PK.
		foreach ($data->getIdFields() as $primaryKey) {
			// Hardcoded value : We ignore the submission_id info (we should have an unicity constraint that allow this)
			$sql .= $this->genericService->buildWhereItem($schema->getCode(), $primaryKey->getMetadata(), $primaryKey->getValue(), true);
		}
	
		$this->logger->info('updateData : ' . $sql);
	
		$request = $this->rawdb->prepare($sql);
	
		try {
			$request->execute();
		} catch (\Exception $e) {
			$this->logger->error('Error while updating data  : ' . $e->getMessage());
			throw new \Exception("Error while updating data  : " . $e->getMessage());
		}
	}
	
	/**
	 * Delete a line of data from a table.
	 *
	 * @param GenericTableFormat $data
	 *        	the shell of the data object with the values for the primary key.
	 * @throws an exception if an error occur during delete
	 */
	public function deleteData($data) {
	
		/** @var $data GenericTableFormat **/
		$tableFormat = $data->getTableFormat();
		/** @var $tableFormat TableFormat **/
	
		$this->logger->info('deleteData');
	
		$schema = $tableFormat->getSchema();
	
		// Get the values from the data table
		$sql = "DELETE FROM " . $schema->getName() . "." . $tableFormat->getTableName();
		$sql .= " WHERE (1 = 1) ";
	
		// Build the WHERE clause with the info from the PK.
		foreach ($data->getIdFields() as $valuedField) {
			/* @var $primaryKey TableField */
			$primaryKey = $valuedField->getMetadata();
			// Hardcoded value : We ignore the submission_id info (we should have an unicity constraint that allow this)
			if (!($tableFormat->getSchemaCode() === "RAW_DATA" && $primaryKey->getData()->getData() === "SUBMISSION_ID")) {
	
				if ($primaryKey->getData()
					->getUnit()
					->getType() === "NUMERIC" || $primaryKey->getData()
					->getUnit()
					->getType() === "INTEGER") {
						$sql .= " AND " . $primaryKey->getColumnName() . " = " . $valuedField->getValue();
					} else if ($primaryKey->getData()
						->getUnit()
						->getType() === "ARRAY") {
							// Arrays not handlmed as primary keys
							throw new \Exception("A primary key should not be of type ARRAY");
						} else {
							$sql .= " AND " . $primaryKey->getColumnName() . " = '" . $valuedField->getValue() . "'";
						}
			}
		}
	
		$this->logger->info('deleteData : ' . $sql);
	
		$request = $this->rawdb->prepare($sql);
	
		try {
			$request->execute();
		} catch (\Exception $e) {
			$this->logger->error('Error while deleting data  : ' . $e->getMessage());
			throw new \Exception("Error while deleting data  : " . $e->getMessage());
		}
	}
	
	public function setLogger($logger) {
		$this->logger = $logger;
	}

	/**
	 * Map the varying two keys in results to the keys in the raw_data table
	 *
	 * MIGRATED.
	 * @param Application_Object_Metadata_TableFormat $table
	 * @return array|bool
	 */
	public function getRawDataTablePrimaryKeys($table) {
		// Map the varying two keys in results to the keys in the raw_data table
		$tableName = $table->getTableName();
		$this->logger->debug("getRawDataTablePrimaryKeys with location table $tableName");
		$keys = array();
		$keyNames = array_map('strtolower', $table->getPrimaryKeys());
		if (count($keyNames) != 3) {
			throw new \Exception("Nombre de clés primaires dans la table $tableName != 3.");
			return false;
		}
		if (!in_array('provider_id', $keyNames)) {
			throw new \Exception("'provider_id' n'est pas une clé primaire dans la table $tableName.");
			return false;
		}
		if (!in_array('user_login', $keyNames)) {
			throw new \Exception("'user_login' n'est pas une clé primaire dans la table $tableName.");
			return false;
		}
		$keys['id_provider'] = 'provider_id';
		$keys['user_login'] = 'user_login' ;
		$otherKey = array_diff($keyNames, [
			'provider_id',
			'user_login'
		]);
		$keys['id_observation'] = $otherKey[0];
		return $keys;
	}

	/**
	 * Get the parameters from the table given used for hiding level calculation.
	 *
	 * @param TableFormat $geometryTable
	 *        	the table holding the geometry field
	 * @param string $ogamIdColumn
	 *        	the name of the ogam_id column
	 * @param string $providerIdColumn
	 *        	the name of the provider_id column
	 * @param integer $reqiD the id of the request
	 * @param string $from
	 *        	the FROM part of the SQL request
	 * @param string $where
	 *        	the WHERE part of the SQL request
	 */
	public function getHidingLevelParameters(TableFormat $geometryTable, $ogamIdColumn, $providerIdColumn, $reqId, $from, $where) {
		
		$standardType = $geometryTable->getModel()->getStandard()->getName() ;
		if (Standard::STANDARD_HABITAT == $standardType) {
			
			$req = $this->buildSQLHidingLevelParametersHabitat($geometryTable, $ogamIdColumn, $providerIdColumn, $reqId, $from, $where) ;
			
		} else {
		
			$req = "SELECT " . $geometryTable->getFormat()->getFormat() . " . $ogamIdColumn as id_observation,  submission.$providerIdColumn as id_provider, sensiniveau, diffusionniveauprecision, dspublique $from
			INNER JOIN results res ON res.id_provider = submission.$providerIdColumn AND res.id_observation = " . $geometryTable->getFormat()->getFormat() . " . $ogamIdColumn
			$where AND res.id_request = ?
			ORDER BY res.id_provider, res.id_observation;";
		}

		$select = $this->rawdb->prepare($req);
		$select->execute(array($reqId));

		return $select->fetchAll();
	}
	
	
	/**
	 * Construit la requête SQL pour déterminer si l'objet doit être caché ou non.
	 * Il n'existe pas vraiment de moyen de savoir si on travaille sur une station ou un habitat avec les données en entrée.
	 * S'il existe une table parente, on considère qu'on travaille sur un habitat, la table parente étant la station.
	 * 
	 * Dans la table results, les id_observation ne peuvent être que des stations. Si on a un habitat, il faut faire la jointure avec la station.
	 * 
	 * Les paramètres de sensibilité requêtés sont renommés pour que la notion de "hiding level" soit la même que pour les taxons
	 * (celle des habitats est une version simplifiée de celle des taxons).
	 * 
	 * @param TableFormat $table
	 * @param type $ogamIdColumn
	 * @param type $providerIdColumn
	 * @param type $reqId
	 * @param type $from
	 * @param type $where
	 */
	private function buildSQLHidingLevelParametersHabitat(TableFormat $table, $ogamIdColumn, $providerIdColumn, $reqId, $from, $where) {
		
		/* @var $parentTable TableFormat */
		$parentTable = $this->metadataModel->getRepository('IgnGincoBundle:Metadata\TableFormat')->findParent($table) ;
		
		if (!$parentTable) {
			
			// Pas de table parente -> l'objet qu'on manipule est une station.
			
			$format = $table->getFormat()->getFormat() ;
			
			$req = "SELECT $format.$ogamIdColumn as id_observation,  submission.$providerIdColumn as id_provider, null as sensiniveau, null as diffusionniveauprecision, dspublique $from
			INNER JOIN results res ON res.id_provider = submission.$providerIdColumn AND res.id_observation = $format.$ogamIdColumn
			$where AND res.id_request = ?
			ORDER BY res.id_provider, res.id_observation;";
			
		} else {
			
			// Il y a une table parente -> l'objet qu'on manipule est un habitat.
			
			$format = $table->getFormat()->getFormat() ;
			$parentFormat = $parentTable->getFormat()->getFormat() ;
			$parentOgamIdColumn = $parentTable->getPkName() ;
			
			$req = "SELECT $parentFormat.$parentOgamIdColumn as id_observation,  submission.$providerIdColumn as id_provider, $format.sensibilitehab as sensiniveau, null as diffusionniveauprecision, $parentFormat.dspublique $from
			INNER JOIN results res ON res.id_provider = submission.$providerIdColumn AND res.id_observation = $parentFormat.$parentOgamIdColumn
			$where AND res.id_request = ?
			ORDER BY res.id_provider, res.id_observation;";
		}
		
		return $req ;
	}

	/**
	 * Returns true if column has geographic type information and if it is more precise
	 * than the hiding level of the row.
	 *
	 * @param string $columnName
	 * @param integer $hidingLevel
	 * @return boolean
	 */
	public function shouldValueBeHidden($columnName, $hidingLevel) {
		if (isset(QueryService::getFieldsLevels()[$columnName])) {
			$level = QueryService::getFieldsLevels()[$columnName];
			if ($level < $hidingLevel) {
				return true;
			}
		}
	}
}