<?php
namespace Ign\Bundle\GincoBundle\Services;

use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericFieldMappingSet;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FormField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableField;
use Ign\Bundle\OGAMBundle\OGAMBundle;
use Ign\Bundle\OGAMBundle\Services\GenericService as BaseGenericService;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableTree;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericFormField;

/**
 * The Generic Service customized for Ginco.
 *
 * This service handles transformations between data objects and generate generic SQL requests from the metadata.
 */
class GenericService extends BaseGenericService {

	/**
	 * Get the form field corresponding to the table field.
	 * Ginco : add the selection of form_label and form_position.
	 * MIGRATION TO DO.
	 *
	 * @param GenericField $tableRowField
	 *        	the a valuable table row field
	 * @param Boolean $copyValues
	 *        	is true the values will be copied
	 * @return GenericFormField
	 */
	public function getTableToFormMapping(GenericField $tableRowField, $copyValues = false) {
		$this->logger->debug('getTableToFormMapping custom');
		$tableField = $tableRowField->getMetadata();
		// Get the description of the form field
		$req = "SELECT ff, fofo.label as form_label, fofo.position as form_position
				FROM OGAMBundle:Metadata\FormField ff
				JOIN OGAMBundle:Metadata\FieldMapping fm WITH fm.mappingType = 'FORM'
 				JOIN OGAMBundle:Metadata\FormFormat fofo WITH fofo.format = ff.format
				WHERE fm.srcData = ff.data
				AND fm.srcFormat = ff.format
				AND fm.dstFormat = :format
				AND fm.dstData = :data";
		$formField = $this->metadataModel->createQuery($req)
			->setParameters(array(
			'format' => $tableField->getFormat()
				->getFormat(),
			'data' => $tableField->getData()
				->getData()
		))
			->getOneOrNullResult();
		foreach($formField as $row){
			if(is_string($row)){
				$this->logger->debug($row);
			}
		}

		$valuedField = null;
		// Clone the object to avoid modifying existing object
		if ($formField[0] !== null) {
			$valuedField = new GenericFormField($formField[0]->getFormat()->getFormat(), $formField[0]->getData()->getData());
			$valuedField->setMetadata($formField[0], $this->locale);
			$valuedField->setFormPosition($formField['form_position']);
			$valuedField->setFormLabel($formField['form_label']);
		}

		// Copy the values
		if ($copyValues === true && $formField[0] !== null && $tableRowField->getValue() !== null) {

			// Copy the value and label
			$valuedField->setValue($tableRowField->getValue());
			$valuedField->setValueLabel($tableRowField->getValueLabel());
		}

		return $valuedField;
	}

	/**
	 * Generate the SQL request corresponding the distinct locations of the query result.
	 * Ginco : add the hiding_level column.
	 * Migrated.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param [OgamBundle\Entity\Generic\GenericField] $formFields
	 *        	a form fields array
	 * @param OgamBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @param Array $userInfos
	 *        	Few user informations
	 * @param Array $options
	 *        	formatting options for the returned fields (see buildSelectItem)
	 * @return String a SQL request
	 */
	public function generateGincoSQLSelectRequest($schema, $formFields, GenericFieldMappingSet $mappingSet, $userInfos, $options = array()) {
		$this->logger->debug('generateGincoSQLSelectRequest');

		// Add the requested columns
		$select = "SELECT DISTINCT "; // The "distinct" is for the case where we have some criteria but no result columns selected on the last table
		foreach ($formFields as $formField) {
			$tableField = $mappingSet->getDstField($formField)->getMetadata();
			$select .= $this->buildSelectItem($tableField, $options) . ", ";
		}
		$select = substr($select, 0, -2);

		// Get the leaf table
		$tables = $this->getAllFormats($schema, $mappingSet->getFieldMappingArray());
		$rootTable = reset($tables);
		$reversedTable = array_reverse($tables); // Only variables should be passed by reference
		$leafTable = array_shift($reversedTable);

		// Get the root table fields
		$rootTableFields = $this->metadataModel->getRepository(TableField::class)->getTableFields($schema, $rootTable->getTableFormat()
			->getFormat(), null, $this->locale);
		$hasColumnProvider = array_key_exists('PROVIDER_ID', $rootTableFields);

		// Add the id column
		$uniqueId = "'SCHEMA/" . $schema . "/FORMAT/" . $leafTable->getTableFormat()->getFormat() . "'";
		$keys = $leafTable->getTableFormat()->getPrimaryKeys();
		foreach ($keys as $key) {
			// Concatenate the column to create a unique Id
			$uniqueId .= " || '/' || '" . $key . "/' ||" . $leafTable->getTableFormat()->getFormat() . "." . $key;
		}
		$select .= ", " . $uniqueId . " as id";

		// Add the location centroid column (for zooming on the map)
		$locationField = $this->metadataModel->getRepository(TableField::class)->getGeometryField($schema, array_keys($tables), $this->locale);
		$select .= ", st_astext(st_centroid(st_transform(" . $locationField->getFormat()->getFormat() . "." . $locationField->getColumnName() . "," . $this->visualisationSRS . "))) as location_centroid ";

		// Add the provider id column
		if (!$userInfos['DATA_EDITION_OTHER_PROVIDER'] && $hasColumnProvider) {
			$select .= ", " . $leafTable->getTableFormat()->getFormat() . ".provider_id as _provider_id";
		}

		// Add the hiding level (for filtering possible sensible results)
		$select .= ", hiding_level";

		// Return the completed SQL request
		return $select;
	}

	/**
	 * Generate the FROM clause of the SQL request corresponding to a list of parameters.
	 * Ginco : support for the ogam_id column and results and joined tables for filtering results;
	 * MIGRATED.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param OgamBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @param Array|String $joinTables
	 *        	the extra tables to join in the request
	 * @param String $geometryTablePKeyIdWithTable
	 *        	the full name of the ogam_id primary key of the table which contains the geometry field (in the form tablename.ogam_id_<xxx>)
	 * @param String $geometryTablePKeyProviderIdWithTable
	 *        	the full name of the provider_id primary key of the table which contains the geometry field (in the form tablename.xxx)
	 * @return String a SQL request
	 */
	public function generateGincoSQLFromRequest($schema, GenericFieldMappingSet $mappingSet, $joinTables = array(), $geometryTablePKeyIdWithTable = null, $geometryTablePKeyProviderIdWithTable = null) {
		$this->logger->debug('generateGincoSQLFromRequest');

		//
		// Prepare the FROM clause
		//

		// Prepare the list of needed tables
		$tables = $this->getAllFormats($schema, $mappingSet->getFieldMappingArray());

		// Add the root table;
		$rootTable = array_shift($tables);
		$rootTableName = $rootTable->getTableFormat()->getTableName();
		$rootTableFormat = $rootTable->getTableFormat()->getFormat();
		$from = " FROM " . $rootTableName . " " . $rootTableFormat;

		// Add results table
		// $from .= ', mapping.results ';

		// Add the user asked joined tables
		if (in_array('submission', $joinTables)) {
			$from .= " LEFT JOIN $schema.submission ON submission.submission_id = $rootTableFormat.submission_id";
		}
		if (in_array('results', $joinTables)) {
			$from .= " LEFT JOIN mapping.results ON results.id_observation = $geometryTablePKeyIdWithTable AND results.id_provider = $geometryTablePKeyProviderIdWithTable";
		}

		// Add the joined tables
		$i = 0;
		foreach ($tables as $tableTreeData) {
			$i ++;

			// Join the table
			$from .= " JOIN " . $tableTreeData->getTableFormat()->getTableName() . " " . $tableTreeData->getTableFormat()->getFormat() . " on (";

			// Add the join keys
			$keys = $tableTreeData->getJoinKeys();
			foreach ($keys as $key) {
				$from .= $tableTreeData->getTableFormat()->getFormat() . "." . trim($key) . " = " . $tableTreeData->getParentTableFormat()->getFormat() . "." . trim($key) . " AND ";
			}
			$from = substr($from, 0, -5);
			$from .= ") ";
		}

		return $from;
	}

	/**
	 * Generate the WHERE clause of the SQL request corresponding to a list of parameters.
	 * Ginco : check for user permissions on submission. Exact search for id column.
	 * MIGRATED.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param [OgamBundle\Entity\Generic\GenericField] $formFields
	 *        	a form fields array
	 * @param OgamBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @return String a SQL request
	 */
	public function generateGincoSQLWhereRequest($schemaCode, $formFields, GenericFieldMappingSet $mappingSet, $userInfos, $tables) {
		$this->logger->debug('generateSQLWhereRequest ginco');

		// Add the root table;
		$rootTable = array_shift($tables);

		// Get the root table fields
		$rootTableFields = $this->metadataModel->getRepository(TableField::class)->getTableFields($schemaCode, $rootTable->getTableFormat()
			->getFormat(), null, $this->locale);

		$hasColumnProvider = array_key_exists('PROVIDER_ID', $rootTableFields);
		$hasConfirmSubmission = array_key_exists('CONFIRM_SUBMISSION', $userInfos) && $userInfos['CONFIRM_SUBMISSION'];
		$hasGrandPublicRole = array_key_exists('hasGrandPublicRole', $userInfos) && $userInfos['hasGrandPublicRole'];
		//
		// Prepare the WHERE clause
		//
		$where = " WHERE (1 = 1)";
		foreach ($formFields as $formField) {
			$tableField = $mappingSet->getDstField($formField)->getMetadata();

			if ($tableField->getData()
				->getUnit()
				->getSubType() == 'ID') {
				// Exact search
				$where .= $this->buildWhereItem($schemaCode, $tableField, $formField->getValue(), true);
			} else {
				$where .= $this->buildWhereItem($schemaCode, $tableField, $formField->getValue(), false);
			}
		}

		// Right management
		// Check the provider id of the logged user
		// If the user role has not the permission to see unpublished data of other provider (ie has not DATA_QUERY_OTHER_PROVIDER), he can see his own datas or other providers published datas
		if (!$userInfos['DATA_QUERY_OTHER_PROVIDER'] && $hasColumnProvider && !$hasGrandPublicRole) {
			$where .= " AND (" . $rootTable->getTableFormat()->getFormat() . ".provider_id = '" . $userInfos['providerId'] . "' OR submission.step='VALIDATE')";
		}

		// User with "publish data" permission can see submissions all the time, so we dont filter on validate submission
		if (!$hasConfirmSubmission) {
			$where .= " AND submission.step = 'VALIDATE' ";
		}

		// Return the completed SQL request
		return $where;
	}

	/**
	 * Generate the WHERE clause of the SQL request used for the whole request.
	 * The other where generation method is used in the subquery of the main query.
	 * It is specifc to Ginco as it only adds columns for filtering possible sensible data.
	 *
	 * @param String $rawDataTableName
	 *        	the name of the table prefixed by the schema name
	 * @param Integer $requestId
	 *        	the id of the request
	 * @param Integer $maxPrecisionLevel
	 *        	the value of the hiding_level
	 * @return String a SQL request
	 */
	public function generateSQLEndWhereRequest($rawDataTableName, $requestId, $maxPrecisionLevel) {
		$this->logger->debug('generateSQLEndWhereRequest');

		$endWhere = " AND table_format = '" . $rawDataTableName . "'";
		$endWhere .= " AND id_request = " . $requestId;
		$endWhere .= " AND hiding_level <= " . $maxPrecisionLevel;

		return $endWhere;
	}

	/**
	 * Get the FROM clause, with JOINS linking youngest requested table to mapping.results table
	 *
	 * MIGRATED.
	 *
	 * @param String $schema
	 * @param string $tableFormat
	 *        	the format of the requested table
	 */
	public function getJoinToGeometryTable($schema, $tableFormat) {
		$this->logger->debug('getJoinToGeometryTable');

		$tableTreeRepo = $this->metadataModel->getRepository(TableTree::class);
		$tableFormatRepo = $this->metadataModel->getRepository(TableFormat::class);

		// Get the ancestors of the table
		$ancestors = $tableTreeRepo->getAncestors($tableFormat, $schema);

		// Get the ancestors to the geometry table only
		$ancestorsToGeometry = $this->getAncestorsToGeometry($schema, $ancestors);

		// Add the requested table (FROM)
		$ancestorsValue = array_values($ancestorsToGeometry);
		$requestedTable = array_shift($ancestorsValue);

		$logicalName = $requestedTable->getTableFormat()->getFormat();

		$from = " FROM " . $requestedTable->getTableFormat()->getTableName() . " " . $logicalName;

		// Add the joined tables (when there is ancestors)
		foreach ($ancestorsToGeometry as $tableTreeData) {
			if ($tableTreeData->getParentTableFormat()->getFormat() != '*') {
				$parentTableName = $ancestorsToGeometry[$tableTreeData->getParentTableFormat()]->getTableName();
				$from .= " JOIN " . $parentTableName . " " . $tableTreeData->getParentTableFormat()->getFormat() . " on (";
				// Add the join keys
				$keys = explode(',', $tableTreeData->getTableFormat()->getPrimaryKeys());
				foreach ($keys as $key) {
					$from .= $tableTreeData->getTableFormat()->getFormat() . "." . trim($key) . " = " . $tableTreeData->getParentTableFormat()->getFormat() . "." . trim($key) . " AND ";
				}
				$from = substr($from, 0, -5);
				$from .= ") ";
			}
		}

		// Add JOIN beetween results table and the table which contains the geometry column (last table of the list)
		$ancestorsValue = array_values($ancestorsToGeometry);
		$geometryTable = array_pop($ancestorsValue);

		$geometryTableFormat = $tableFormatRepo->findOneBy(array(
			'format' => $geometryTable->getTableFormat()
				->getFormat()
		));
		$geometryTableFormatKeys = $geometryTableFormat->getPrimaryKeys();
		foreach ($geometryTableFormatKeys as $geometryKey) {
			if (strtolower(trim($geometryKey)) != 'provider_id') {
				$geometryTablePKeyId = trim($geometryKey);
			}
		}
		$from .= " LEFT JOIN mapping.results ON results.id_observation = " . $geometryTable->getTableFormat()->getFormat() . "." . $geometryTablePKeyId . " AND results.id_provider = " . $geometryTable->getTableFormat()->getFormat() . ".provider_id";

		$this->logger->debug('getJoinToGeometryTable :' . $from);
		return $from;
	}

	/**
	 * Truncates the array of the ancestors, ends it with the table containing the geometry
	 * MIGRATED
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
			$ancestorsToGeometry[$ancestor->getTableFormat()->getTableName()] = $ancestor;

			$req = " SELECT 1 as has_geometry ";
			$req .= " FROM INFORMATION_SCHEMA.COLUMNS ";
			$req .= " WHERE table_name = ? ";
			$req .= " and column_name = 'geometrie' ";
			$req .= " and table_schema = ? ";

			$this->logger->info('getAncestorsToGeometry : ' . $req);

			$conn = $this->metadataModel->getConnection();
			$results = $conn->fetchAll($req, array(
				$ancestor->getTableFormat()->getTableName(),
				strtolower($schema)
			));

			$row = $results[0];
			if ($row['has_geometry'] != null) {
				$ĥasGeometryColumn = 1;
			}
		}
		return $ancestorsToGeometry;
	}

	/**
	 * Returns a Postgres value corresponding to Ogam type.
	 * The aim is to replace NULL values to be able to compare it to other values.
	 *
	 * @param $ogamType ogam
	 *        	type coming from unit table type column.
	 *
	 * @return Postgres value
	 */
	public function getPostgresValueFromOgamType($ogamType) {
		switch ($ogamType) {
			case "NUMERIC":
				$result = '-2147483648';
				break;
			case "ARRAY":
				$result = "{}";
				break;
			case "CODE":
				$result = "0";
				break;
			case "STRING":
				$result = "";
				break;
			case "DATE":
				$result = "0001/01/01";
				break;
			case "TIME":
				$result = "00:00:00";
				break;
			case "INTEGER":
				$result = '-2147483648';
				break;
			case "GEOM":
				$result = '0101000020E6100000548A66B35D001740CDE29BFDEB274840';
				break;
			default:
				$result = "0";
		}
		return $result;
	}
}