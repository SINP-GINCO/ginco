<?php
namespace Ign\Bundle\OGAMBundle\Manager;

use Doctrine\DBAL\Connection;
use Doctrine\ORM\EntityManager;
use Ign\Bundle\OGAMBundle\Services\GenericService;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableTree;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericTableFormat;
use Ign\Bundle\OGAMBundle\Entity\Generic\BoundingBox;

/**
 * Class allowing generic access to the RAW_DATA tables.
 * 
 * @author FBourcier
 *        
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
	 * Initialisation
	 */
	public function __construct($metaModel_em, $raw_em, $genericService, $configuration) {
		
		// Initialise the logger
		// $this->logger = Zend_Registry::get("logger");
		
		// Initialise the projection system
		$this->visualisationSRS = $configuration->getConfig('srs_visualisation', 3857);
		
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
		$sql .= " WHERE (1 = 1)" . $this->genericService->buildWhere($schema->getCode(), $data->getIdFields());
		
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
		foreach ($data->getFields() as $field) {
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
		$sql = "SELECT parent_table";
		$sql .= " FROM TABLE_TREE ";
		$sql .= " WHERE SCHEMA_CODE = '" . $tableFormat->getSchemaCode() . "'";
		$sql .= " AND child_table = '" . $tableFormat->getFormat() . "'";
		
		$this->logger->info('getAncestors : ' . $sql);
		
		$select = $this->metadatadb->prepare($sql);
		$select->execute();
		$parentTable = $select->fetchColumn(0);
		
		// Check if we are not the root table
		if ($parentTable != "*") {
			
			// Build an empty parent object
			$parent = $this->genericService->buildGenericTableFormat($tableFormat->getSchemaCode(), $parentTable, null);
			
			// Fill the PK values (we hope that the child contain the fields of the parent pk)
			foreach ($parent->getIdFields() as $key) {
				$fieldName = $tableFormat->getFormat() . '__' . $key->getData();
				$fields = $data->all();
				if (array_key_exists($fieldName, $fields)) {
					$keyField = $fields[$fieldName];
					if ($keyField != null && $keyField->getValue() != null) {
						$key->setValue($keyField->getValue());
					}
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
			
			// Build an empty data object (for the query)
			$child = $this->genericService->buildGenericTableFormat($tableFormat->getSchemaCode(), $childTable);
			
			// Fill the known primary keys (we hope the child contain the keys of the parent)
			foreach ($data->getIdFields() as $dataKey) {
				foreach ($child->getIdFields() as $childKey) {
					if ($dataKey->getData() == $childKey->getData()) {
						$childKey->setValue($dataKey->getValue());
					}
				}
				foreach ($child->getFields() as $childKey) {
					if ($dataKey->getData() == $childKey->getData()) {
						$childKey->setValue($dataKey->getValue());
					}
				}
			}
			
			// Get the lines of data corresponding to the partial key
			$childs = $this->_getDataList($child);
			
			// Add to the result
			$children[$child->getTableFormat()->getFormat()] = $childs;
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
}