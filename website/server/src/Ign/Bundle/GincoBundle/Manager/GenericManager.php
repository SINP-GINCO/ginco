<?php
namespace Ign\Bundle\OGAMBundle\Manager;

use Ign\Bundle\OGAMBundle\Entity\Generic\BoundingBox;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericTableFormat;
use Ign\Bundle\OGAMBundle\Manager\GenericManager as BaseManager;
use Ign\Bundle\OGAMBundle\Services\GenericService;
use Ign\Bundle\OGAMConfigurateurBundle\DependencyInjection\Configuration;
use Ign\Bundle\GincoBundle\Services\QueryService;

/**
 * Class allowing generic access to the RAW_DATA tables.
 */
class GenericManager extends BaseManager {

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
	public function __construct($metaModel_em, $raw_em, $genericService, $queryService, $configuration) {

		// Initialize the configuration object
		$this->configuration = $configuration;

		// Initialize the query service
		$this->queryService = $queryService;

		parent::__construct($metaModel_em, $raw_em, $genericService, $configuration);
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
	public function getDatum(GenericTableFormat $data, $requestId) {
		$tableFormat = $data->getTableFormat();

		$this->logger->info('getDatum : ' . $tableFormat->getFormat());

		$schema = $tableFormat->getSchema();
		$ĥidingValue = $this->configuration->getConfig('hiding_value');

		// Get the values from the data table
		// We must select hiding_level to determinate for each field if the value must be hidden.
		// Nevertheless, the current table_format is not necessarily the format of the table carrying the geometry.
		// So we can't use it to join on results table everytime.
		// 1- Find the table carrying the geometry
		// 2- Do the JOINS with each ancestor, to the one who carries the geometry
		// => rule : it must be forbidden to put hidden fields in older tables than geometry table.

		$joinToGeometryTable = $this->genericService->getJoinToGeometryTable($schema->name, $tableFormat->format);

		$sql = "SELECT DISTINCT " . $this->genericService->buildSelect($data->getFields());
		$sql .= ", hiding_level";
		$sql .= $joinToGeometryTable;
		$sql .= " WHERE (1 = 1)" . $this->genericService->buildWhere($schema->code, $data->infoFields);
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
			$shouldValueBeHidden = $this->queryService->shouldValueBeHidden($field->getData(), $row['hiding_level']);
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
				$field->setValue($this->genericService->stringToArray($field->getValue()));
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
			throw new \Exception("Nombre de clés primaires dans la table $tableName != 2.");
			return false;
		}
		if (!in_array('provider_id', $keyNames)) {
			throw new \Exception("'provider_id' n'est pas une clé primaire dans la table $tableName.");
			return false;
		}
		$keys['id_provider'] = 'provider_id';
		$otherKey = array_diff($keyNames, [
			'provider_id'
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
	 * @param string $from
	 *        	the FROM part of the SQL request
	 * @param string $where
	 *        	the WHERE part of the SQL request
	 */
	public function getHidingLevelParameters($geometryTable, $ogamIdColumn, $providerIdColumn, $from, $where) {
		$req = "SELECT " . $geometryTable->format . " . $ogamIdColumn as id_observation,  submission.$providerIdColumn as id_provider, sensiniveau, diffusionniveauprecision, dspublique $from
		INNER JOIN results res ON res.id_provider = submission.$providerIdColumn AND res.id_observation = " . $geometryTable->format . " . $ogamIdColumn
		$where AND res.id_request = ?
		ORDER BY res.id_provider, res.id_observation;";

		$select = $this->rawdb->prepare($sql);
		$select->execute();

		return $select->fetchAll();
	}
}