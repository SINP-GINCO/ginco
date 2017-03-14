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
 * This is the CustomMetadata model.
 *
 * @package models
 */
include_once APPLICATION_PATH . '/models/Metadata/Metadata.php';

class Application_Model_Metadata_CustomMetadata extends Application_Model_Metadata_Metadata {

	/**
	 * Get the form formats containing a data for a given dataset
	 *
	 * @param String $datasetId
	 *        	the dataset selected in the query panel
	 * @param String $field
	 *        	the data whose form we want to get
	 * @return Array[String] form formats
	 */
	public function getFormFormats($datasetId, $field) {
		
		// (not done in models, it's why we do a direct sql request here).
		$db = Zend_Db_Table::getDefaultAdapter();
		
		$req = "SELECT df.format
				FROM metadata.dataset_forms df, metadata.form_field ff
				WHERE df.format = ff.format
				AND df.dataset_id = ?
				AND ff.data = ?";
		
		$query = $db->prepare($req);
		$query->execute(array(
			$datasetId,
			$field
		));
		
		$result = array();
		foreach ($query->fetchAll() as $row) {
			$result[] = $row['format'];
		}
		return $result;
	}

	/**
	 * Get the list of the data models.
	 *
	 * @return Array of Object
	 */
	public function getDataModels() {
		$this->logger->debug('getDataModels');
		$db = Zend_Db_Table::getDefaultAdapter();

		$req = "SELECT id, name
				FROM metadata.model
				ORDER BY name";

		$query = $db->prepare($req);
		$query->execute();

		$result = array();
		foreach ($query->fetchAll() as $row) {
			$result[$row['id']] = $row['name'];
		}
		return $result;
	}

	/**
	 * Get the model Id related to a given dataset
	 *
	 * @param
	 *        	$datasetId
	 * @return string : the model Id
	 */
	public function getModelForDataset($datasetId) {
		$db = Zend_Db_Table::getDefaultAdapter();
		
		$req = "SELECT md.model_id
				FROM metadata.model_datasets md
				WHERE md.dataset_id = ?";
		
		$query = $db->prepare($req);
		$query->execute(array(
			$datasetId
		));
		
		$modelId = '';
		foreach ($query->fetchAll() as $row) {
			$modelId = $row['model_id']; // Only one result expected...
		}
		return $modelId;
	}

	/**
	 * Get all table_format formats for a given model
	 *
	 * @param
	 *        	$modelId
	 * @return array[string] table_format formats
	 */
	public function getTableFormats($modelId) {
		$db = Zend_Db_Table::getDefaultAdapter();
		
		$req = "SELECT tf.format
				FROM metadata.table_format tf
				LEFT JOIN metadata.model_tables mt
				ON tf.format = mt.table_id
				WHERE mt.model_id = ?";
		
		$query = $db->prepare($req);
		$query->execute(array(
			$modelId
		));
		
		$result = array();
		foreach ($query->fetchAll() as $row) {
			$result[] = $row['format'];
		}
		return $result;
	}

	/**
	 * Get all table_fields for a given model
	 *
	 * @param
	 *        	$modelId
	 * @return array[Application_Object_Metadata_TableField]
	 */
	public function getTableFieldsForModel($modelId) {
		$db = Zend_Db_Table::getDefaultAdapter();
		
		$req = "SELECT tfi.*, d.label as label, d.unit, u.type, u.subtype, d.definition
				FROM metadata.table_field tfi
				LEFT JOIN metadata.model_tables mt ON tfi.format = mt.table_id
				LEFT JOIN metadata.data d ON tfi.data = d.data
				LEFT JOIN metadata.unit u on d.unit = u.unit
				WHERE mt.model_id = ?
				ORDER BY d.label";
		
		$select = $db->prepare($req);
		$select->execute(array(
			$modelId
		));
		
		$result = array();
		foreach ($select->fetchAll() as $row) {
			$result[] = $this->_readTableField($row);
		}
		
		return $result;
	}

	/**
	 * Read a table field object from a result line.
	 *
	 * @param Result $row        	
	 * @return Application_Object_Metadata_FormField
	 */
	private function _readTableField($row) {
		$tableField = new Application_Object_Metadata_TableField();
		$tableField->data = $row['data'];
		$tableField->format = $row['format'];
		$tableField->columnName = $row['column_name'];
		$tableField->isCalculated = $row['is_calculated'];
		$tableField->isEditable = $row['is_editable'];
		$tableField->isInsertable = $row['is_insertable'];
		$tableField->isMandatory = $row['is_mandatory'];
		$tableField->position = $row['position'];
		$tableField->label = $row['label'];
		$tableField->unit = $row['unit'];
		$tableField->type = $row['type'];
		$tableField->subtype = $row['subtype'];
		$tableField->definition = $row['definition'];
		
		return $tableField;
	}

	/**
	 * Get the taxons.
	 *
	 * Return a hierarchy of taxons
	 *
	 * @param String $unit
	 *        	The unit
	 * @param String $parentcode
	 *        	The identifier of the start node in the tree (by default the root node is *)
	 * @param Integer $levels
	 *        	The number of levels of depth (if 0 then no limitation), relative to the root node
	 * @return Application_Object_Metadata_TreeNode
	 */
	public function getTaxrefChildren($unit, $parentcode = '*', $levels = 1) {
		$key = $this->_formatCacheKey('custom getTaxrefChildren_' . $unit . '_' . $parentcode . '_' . $levels);
		
		$this->logger->debug($key);
		
		if ($this->useCache) {
			$cachedResult = $this->cache->load($key);
		}
		
		if (empty($cachedResult)) {
			
			$req = "WITH RECURSIVE node_list( unit, code, parent_code, name, complete_name, lb_name, vernacular_name, is_reference, is_leaf, level) AS (  ";
			$req .= "	    SELECT unit, code, parent_code, name, complete_name, lb_name, vernacular_name, is_reference, is_leaf, 1";
			$req .= "		FROM mode_taxref ";
			$req .= "		WHERE unit = ? ";
			$req .= "		AND parent_code = ? ";
			$req .= "	UNION ALL ";
			$req .= "		SELECT child.unit, child.code, child.parent_code, child.name, child.complete_name, child.lb_name, child.vernacular_name, child.is_reference, child.is_leaf, level + 1 ";
			$req .= "		FROM mode_taxref child ";
			$req .= "		INNER JOIN node_list on (child.parent_code = node_list.code AND child.unit = node_list.unit) ";
			$req .= "		WHERE child.unit = ? ";
			if ($levels != 0) {
				$req .= "	AND level < " . $levels . " ";
			}
			$req .= "	) ";
			$req .= "	SELECT * ";
			$req .= "	FROM node_list ";
			$req .= "	ORDER BY level, parent_code, name "; // level is used to ensure correct construction of the structure
			
			$select = $this->db->prepare($req);
			
			$select->execute(array(
				$unit,
				$parentcode,
				$unit
			));
			
			$rows = $select->fetchAll();
			
			if (!empty($rows)) {
				$resultTree = new Application_Object_Metadata_TreeNode(); // The root is empty
				foreach ($rows as $row) {
					
					$parentCode = $row['parent_code'];
					
					// Build the new node
					$tree = new Application_Object_Metadata_CustomTaxrefNode();
					$tree->code = $row['code'];
					$tree->name = $row['name'];
					$tree->completeName = $row['complete_name'];
					$tree->scientificName = $row['lb_name'];
					$tree->vernacularName = $row['vernacular_name'];
					$tree->isLeaf = $row['is_leaf'];
					$tree->isReference = $row['is_reference'];
					
					// Check if a parent can be found in the structure
					$parentNode = $resultTree->getNode($parentCode);
					if ($parentNode == null) {
						// Add the new node to the result root
						$resultTree->addChild($tree);
					} else {
						// Add it to the found parent
						$parentNode->addChild($tree);
					}
				}
			} else {
				$resultTree = null;
			}
			
			if ($this->useCache) {
				$this->cache->save($resultTree, $key);
			}
			return $resultTree;
		} else {
			return $cachedResult;
		}
	}

	/**
	 * Troncates the array of the ancestors, ends it with the table containing the geometry
	 *
	 * @param String $schema        	
	 * @param Array[Application_Object_Metadata_TableTreeData] $ancestors        	
	 * @return Array[Application_Object_Metadata_TableTreeData] $ancestorsToGeometry
	 */
	public function getAncestorsToGeometry($schema, $ancestors) {
		$this->logger->info('getAncestorsToGeometry');
		
		$ancestorsToGeometry = array();
		$ĥasGeometryColumn = 0;
		
		while ($ĥasGeometryColumn != 1) {
			$ancestor = array_shift($ancestors);
			$ancestorsToGeometry[$ancestor->getLogicalName()] = $ancestor;
			
			$req = " SELECT 1 as has_geometry ";
			$req .= " FROM INFORMATION_SCHEMA.COLUMNS ";
			$req .= " WHERE table_name = ? ";
			$req .= " and column_name = 'geometrie' ";
			$req .= " and table_schema = ? ";
			
			$this->logger->info('getAncestorsToGeometry : ' . $req);
			
			$select = $this->db->prepare($req);
			$select->execute(array(
				$ancestor->tableName,
				strtolower($schema)
			));
			$this->logger->info('ancestor table name : ' . $ancestor->tableName . ", join keys : " . $ancestor->keys);
			
			$row = $select->fetch();
			if ($row['has_geometry'] != null) {
				$ĥasGeometryColumn = 1;
			}
		}
		return $ancestorsToGeometry;
	}
	
	/**
	 * Get the form field corresponding to the table field.
	 *
	 * @param Application_Object_Metadata_TableField $tableField
	 *        	the table field
	 * @return Array[Application_Object_Metadata_FormField]
	 */
	public function getTableToFormMapping($tableField) {
		$this->logger->info('getTableToFormMapping : ' . $tableField->format . " " . $tableField->data . ' ' . $this->lang);
	
		$key = $this->_formatCacheKey('getTableToFormMapping' . $tableField->format . '_' . $tableField->data . '_' . $this->lang);
	
		// Get the form description corresponding to the table field
		$result = null;
		if ($this->useCache) {
			$result = $this->cache->load($key);
		}
		if (empty($result)) {
	
			$req = " SELECT form_field.*, COALESCE(t.label, data.label) as label, COALESCE(t.definition, data.definition) as definition, unit.unit, unit.type, unit.subtype, form_format.label as form_label, form_format.position as form_position";
			$req .= " FROM form_field ";
			$req .= " LEFT JOIN field_mapping on (field_mapping.src_format = form_field.format AND field_mapping.src_data = form_field.data AND mapping_type = 'FORM') ";
			$req .= " LEFT JOIN data on (form_field.data = data.data)";
			$req .= " LEFT JOIN unit on (data.unit = unit.unit)";
			$req .= " LEFT JOIN form_format on (form_format.format = form_field.format)";
			$req .= " LEFT JOIN translation t ON (lang = '" . $this->lang . "' AND table_format = 'DATA' AND row_pk = data.data) ";
			$req .= " WHERE field_mapping.dst_format = ? ";
			$req .= " AND field_mapping.dst_data = ? ";
			$req .= " ORDER BY form_format.position, form_field.position ";
	
			$this->logger->info('getTableToFormMapping : ' . $req);
	
			$select = $this->db->prepare($req);
			$select->execute(array(
				$tableField->format,
				$tableField->data
			));
	
			$row = $select->fetch();
	
			if (!empty($row)) {
				$formField = $this->_readFormField($row);
	
				if ($this->useCache) {
					$this->cache->save($formField, $key);
				}
				$result = $formField;
			}
		}
	
		return $result; // clone to avoid updating the values of the cached result
	}
	
	/**
	 * Read a form field object from a result line.
	 *
	 * @param Result $row
	 * @return Application_Object_Metadata_FormField
	 */
	private function _readFormField($row) {
		$formField = new Application_Object_Metadata_CustomFormField();
		$formField->data = $row['data'];
		$formField->format = $row['format'];
		if (array_key_exists('form_label', $row)) {
			$formField->formLabel = $row['form_label'];
		}
		if (array_key_exists('form_position', $row)) {
			$formField->formPosition = $row['form_position'];
		}
		$formField->isCriteria = $row['is_criteria'];
		$formField->isResult = $row['is_result'];
		$formField->inputType = $row['input_type'];
		$formField->isDefaultResult = $row['is_default_result'];
		$formField->isDefaultCriteria = $row['is_default_criteria'];
		$formField->defaultValue = $row['default_value'];
		$formField->definition = $row['definition'];
		$formField->label = $row['label'];
		$formField->type = $row['type'];
		$formField->subtype = $row['subtype'];
		$formField->unit = $row['unit'];
		$formField->decimals = $row['decimals'];
		$formField->mask = $row['mask'];
		$formField->position = $row['position'];
	
		return $formField;
	}
}