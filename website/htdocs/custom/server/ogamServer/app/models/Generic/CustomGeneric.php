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
include_once APPLICATION_PATH . '/models/Generic/Generic.php';
include_once CUSTOM_APPLICATION_PATH . '/models/Mapping/ResultLocation.php';

/**
 * This is the --CUSTOM-- model for the generic.php model.
 * It extends the original model, and only customizes the getDatum method for
 * hiding some of the details of the card.
 *
 * @package Application_Model
 * @subpackage Generic
 */
class Custom_Application_Model_Generic_Generic extends Application_Model_Generic_Generic {


	/**
	 * Fill a line of data with the values a table, given its primary key.
	 * Only one object is expected in return.
	 *
	 * @param Application_Object_Generic_DataObject $data
	 *        	the shell of the data object with the values for the primary key.
	 * @return Application_Object_Generic_DataObject The complete data object.
	 */
	public function getDatum($data) {
		$tableFormat = $data->tableFormat;

		$this->logger->info('getDatum custom: ' . $tableFormat->format);

		$configuration = Zend_Registry::get("configuration");
		$ĥidingValue = $configuration->getConfig('hiding_value');

		$schema = $this->metadataModel->getSchema($tableFormat->schemaCode);

		$customResultLocation = new Application_Model_Mapping_ResultLocation();
		$customQueryService = new Custom_Application_Service_QueryService($schema);

		$keys = $this->getRawDataTablePrimaryKeys($tableFormat);
		$requestId = $customResultLocation->getLastRequestIdFromSession(session_id());

		// Get the values from the data table
		$sql = "SELECT DISTINCT " . $this->genericService->buildSelect($data->getFields());
		$sql .= ", hiding_level";
		$sql .= " FROM " . $schema->name . "." . $tableFormat->tableName . " AS " . $tableFormat->format;
		$sql .= ", mapping.results, mapping.requests";
		$sql .= " WHERE (1 = 1)" . $this->genericService->buildWhere($schema->code, $data->infoFields);
		$sql .= " AND " . $tableFormat->format . "." . $keys['id_observation'] . " = results.id_observation";
		$sql .= " AND " . $tableFormat->format . "." . $keys['id_provider'] . " = results.id_provider";
		$sql .= " AND table_format = '" . $tableFormat->format . "'";
		$sql .= " AND id_request = '" . $requestId . "'";
		$sql .= " AND id_request = requests.id";

		$this->logger->info('getDatum : ' . $sql);

		$select = $this->rawdb->prepare($sql);
		$select->execute();
		$row = $select->fetch();

		// Fill the values with data from the table
		foreach ($data->editableFields as $field) {
			$key = strtolower($field->getName());
			$shouldValueBeHidden = $customQueryService->shouldValueBeHidden($field->data, $row['hiding_level']);
			if ($shouldValueBeHidden) {
				$field->value = $ĥidingValue;
			} else {
				$field->value = $row[$key];
			}

			// Store additional info for geometry type
			if ($field->type === "GEOM") {
				$field->xmin = $row[strtolower($key) . '_x_min'];
				$field->xmax = $row[strtolower($key) . '_x_max'];
				$field->ymin = $row[strtolower($key) . '_y_min'];
				$field->ymax = $row[strtolower($key) . '_y_max'];
			} else if ($field->type === "ARRAY") {
				// For array field we transform the value in a array object
				if ($shouldValueBeHidden) {
					$field->value = $ĥidingValue;
				} else {
					$field->value = $this->genericService->stringToArray($field->value);
				}
			}
		}

		// Fill the values with data from the table
		foreach ($data->getFields() as $field) {

			// Fill the value labels for the field
			$field->valueLabel = $this->genericService->getValueLabel($field, $field->value);
		}
		return $data;
	}

	/**
	 * Map the varying two keys in results to the keys in the raw_data table
	 *
	 * @param Application_Object_Metadata_TableFormat $table
	 * @return array|bool
	 */
	public function getRawDataTablePrimaryKeys($table) {
		// Map the varying two keys in results to the keys in the raw_data table
		$tableName = $table->tableName;
		$this->logger->debug("getRawDataTablePrimaryKeys with location table $tableName");
		$keys = array();
		$keyNames = array_map('strtolower', $table->primaryKeys);
		if (count($keyNames) != 2) {
			throw new Exception("Nombre de clés primaires dans la table $tableName != 2.");
			return false;
		}
		if (!in_array('provider_id', $keyNames)) {
			throw new Exception("'provider_id' n'est pas une clé primaire dans la table $tableName.");
			return false;
		}
		$keys['id_provider'] = 'provider_id';
		$otherKey = array_diff($keyNames, [
			'provider_id'
		]);
		$keys['id_observation'] = $otherKey[0];
		return $keys;
	}
}
