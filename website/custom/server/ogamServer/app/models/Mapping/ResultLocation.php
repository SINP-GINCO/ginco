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
include_once APPLICATION_PATH . '/models/Website/Role.php';
require_once CUSTOM_APPLICATION_PATH . '/services/CustomQueryService.php';
include_once CUSTOM_APPLICATION_PATH . '/models/Generic/CustomGeneric.php';

/**
 * This is the --CUSTOM-- model for managing result locations (for the web mapping).
 * result location is NO MORE used. Instead, two tables :
 * - requests: Stores redondant information about request
 * - results: n-m association table between requests and results, supporting access information
 *
 * @package Application_Model
 * @subpackage Mapping
 */
class Application_Model_Mapping_ResultLocation {

	/**
	 * The logger.
	 *
	 * @var Zend_Log
	 */
	var $logger;

	/**
	 * The database connection
	 *
	 * @var Zend_Db
	 */
	var $db;

	/**
	 *
	 * @var the role model
	 */
	protected $roleModel;

	/**
	 *
	 * @var the generic model
	 */
	protected $genericModel;

	private static $fieldsToSelect = array(
		'jourdatedebut',
		'jourdatefin',
		'nomcite',
		'cdref',
		'nomvalide',
		'observateuridentite',
		'organismegestionnairedonnee',
		'statutobservation',
		'sensible',
		'sensiniveau',
		'dspublique',
		'diffusionniveauprecision',
		'pk'
	);

	/**
	 * Initialisation.
	 */
	public function __construct() {

		// Initialise the logger
		$this->logger = Zend_Registry::get("logger");

		// The database connection
		$this->db = Zend_Registry::get('mapping_db');

		$this->roleModel = new Application_Model_Website_Role();
		$this->genericModel = new Custom_Application_Model_Generic_Generic();
	}

	/**
	 * Destuction.
	 */
	function __destruct() {
		$this->db->closeConnection();
		$this->roleModel = null;
		$this->genericModel = null;
	}

	/**
	 * Populate the result location table.
	 *
	 * @param String $from
	 *        	the FROM part of the SQL Request
	 * @param String $where
	 *        	the WHERE part of the SQL Request
	 * @param String $sessionId
	 *        	the user session id.
	 * @param Application_Object_Metadata_TableFormat $locationTable
	 *        	the location table
	 */
	public function fillLocationResult($from, $where, $sessionId, $locationTable) {
		$this->logger->info('fillLocationResult');
		if (empty($from) || empty($where)) {
			return;
		}
		$this->db->getConnection()->setAttribute(PDO::ATTR_TIMEOUT, 480);

		if ($this->_isLocalDB()) {
			$this->fillResults($from, $where, $sessionId, $locationTable);
		} else {
			$rawdb = Zend_Registry::get('raw_db');
			$rawdb->getConnection()->setAttribute(PDO::ATTR_TIMEOUT, 480);
			$this->fillResults($from, $where, $sessionId, $locationTable, $rawDb);
		}
	}

	/**
	 * Populates the requests and results table in a local database.
	 *
	 * @param String $from
	 *        	the FROM part of the SQL Request
	 * @param String $where
	 *        	the WHERE part of the SQL Request
	 * @param String $sessionId
	 *        	the user session id.
	 * @param Application_Object_Metadata_TableFormat $locationTable
	 *        	the location table
	 * @param Connection $rawDb
	 *        	the connection to the remote database where raw_data schema is.
	 *        	If null, raw_db is considered as being in local database.
	 */
	private function fillResults($from, $where, $sessionId, $locationTable, $rawDb = null) {
		// -- First, insert a "request" record
		$sql = "INSERT INTO requests (session_id) VALUES ('$sessionId') RETURNING id;";
		$reqId = $this->db->fetchOne($sql);

		// -- Then copy references to raw_data results in the "results" table

		// Le nom de la table portant l'info géométrique
		$tableFormat = $locationTable->format;

		// Map the varying two keys in results to the keys in the raw_data table
		$keys = $this->genericModel->getRawDataTablePrimaryKeys($locationTable);

		if ($rawDb) {
			// The "remote" method is 2x or 3x more time consuming. Used when the raw data schema is in another database.
			// Select raw results
			$select = "SELECT DISTINCT " . $keys['id_observation'] . " AS id_observation, " . $keys['id_provider'] . " AS id_provider " . $from . $where;
			$query = $rawdb->prepare($select);
			$query->execute();

			$insert = "INSERT INTO results (id_request, id_observation, id_provider, table_format, hiding_level)
 				   VALUES (?, ?, ?, ?, ?)";

			$queryIns = $this->db->prepare($insert);

			foreach ($query->fetchAll() as $row) {
				$queryIns->execute(array(
					$reqId,
					$row['id_observation'],
					$row['id_provider'],
					$tableFormat,
					0
				));
			}
		} else {
			$permissions = $this->getVisuPermissions();
			if ($permissions['logged']) {
				$defaultHidingLevel = 0;
			} else {
				$defaultHidingLevel = 1;
			}
			// We can use INSERT ... SELECT statement only if we are exactly on the same server
			$sql = "INSERT INTO results (id_request, id_observation, id_provider, table_format, hiding_level)
				SELECT DISTINCT $reqId, " . $tableFormat . "." . $keys['id_observation'] . ", $tableFormat." . $keys['id_provider'] . ", ? , $defaultHidingLevel $from $where;";

			$this->logger->info('fillResults : ' . $sql);

			$stmt = $this->db->prepare($sql);
			$stmt->execute(array(
				$tableFormat
			));
		}

		// Get back the results and for each, get and fill hiding level
		$tableValues = $this->getHidingLevels($keys, $locationTable, $this->getVisuPermissions(), $from, $where, $reqId);
		$this->setHidingLevels($tableValues, $locationTable->format, $sessionId);

		// Remove any values that can be obtained through criterias more precise than the hiding level
		$this->deleteUnshowableResultsFromCriterias($reqId);
	}

	/**
	 * Gets the id of the last request played within the current session.
	 *
	 * @param
	 *        	Integer the session id
	 * @return String the request id
	 */
	public function getLastRequestIdFromSession($sessionId) {
		$this->logger->debug('getLastRequestIdFromSession : ' . $sessionId);
		$db = $this->db;
		$sql = "SELECT id FROM requests req WHERE req.session_id = ?
				ORDER BY req.id DESC LIMIT 1";
		$stmt = $db->prepare($sql);
		$stmt->execute(array(
			$sessionId
		));

		return $stmt->fetchColumn();
	}

	/**
	 * Updates the hiding levels for all rows provided in the array of values.
	 *
	 * @param
	 *        	Array of String $keys the name of the fields of the primary key
	 *
	 * @param Application_Object_Metadata_TableFormat $geometryTable
	 *        	the table object carrying the 'geometrie' column, containing tableName and tableFormat
	 * @param
	 *        	Array of String $permissions the array of permissions (VIEW_SENSITIVE, VIEW_PRIVATE)
	 *
	 * @param String $from
	 *        	the FROM part of the SQL Request
	 * @param String $where
	 *        	the WHERE part of the SQL Request
	 * @param String $reqId
	 *        	the request id
	 * @return Array|Integer the list of hiding levels
	 */
	public function getHidingLevels($keys, $geometryTable, $permissions, $from, $where, $reqId) {
		// Retrieve parameters for calculation of hiding level
		$ogamId = $keys['id_observation'];
		$providerId = $keys['id_provider'];
		$req = "SELECT " . $geometryTable->format . " . $ogamId as id_observation,  submission.$providerId as id_provider, sensiniveau, diffusionniveauprecision, dspublique $from
						INNER JOIN results res ON res.id_provider = submission.$providerId AND res.id_observation = " . $geometryTable->format . " . $ogamId
						$where AND res.id_request = ?
						ORDER BY res.id_provider, res.id_observation;";

		$this->logger->debug('getHidingLevels : ' . $req);
		$select = $this->db->prepare($req);
		$select->execute(array(
			$reqId
		));

		$results = $select->fetchAll();

		for ($i = 0; $i < count($results); $i ++) {
			$sensiNiveau = $results[$i]['sensiniveau'];
			$diffusionNiveauPrecision = $results[$i]['diffusionniveauprecision'];
			$dsPublique = $results[$i]['dspublique'];

			$sensibilityHidingLevel = $this->getSensibilityHidingLevel($sensiNiveau, $permissions);
			$privateHidingLevel = $this->getPrivateHidingLevel($dsPublique, $diffusionNiveauPrecision, $permissions);

			$results[$i]['hiding_level'] = max($sensibilityHidingLevel, $privateHidingLevel);
		}
		return $results;
	}

	/**
	 * Returns the sensibility hiding level based on user permissions and sensibility level of the data.
	 * If the user is not logged in, the default return value is at least 1.
	 *
	 * @param Integer $sensiNiveau
	 * @param
	 *        	Array of Boolean $permissions permissions linked to visualization : sensitive and private.
	 * @return Integer the sensibility hiding level
	 */
	private function getSensibilityHidingLevel($sensiNiveau, $permissions) {
		$hidingLevel = $sensiNiveau;
		if (!$permissions['logged'] && $hidingLevel < 1) {
			$hidingLevel = 1;
		} else if ($permissions['sensitive']) {
			$hidingLevel = 0;
		}
		return $hidingLevel;
	}

	/**
	 * Returns the private hiding level based on user permissions and private level of the data.
	 * If the user is not logged in, the default return value is at least 1.
	 *
	 * @param String $dsPublique
	 *        	the value of the dspublique. 'Pr' for private.
	 * @param Integer $diffusionNiveauPrecision
	 *        	the value of the diffusionNiveauPrecision
	 * @param
	 *        	Array of Boolean $permissions permissions linked to visualization : sensitive and private.
	 * @return Integer the private hiding level
	 */
	private function getPrivateHidingLevel($dsPublique, $diffusionNiveauPrecision, $permissions) {
		$hidingLevel = $diffusionNiveauPrecision;
		if (!$permissions['logged'] && ($hidingLevel < 1 || $hidingLevel == 5)) {
			$hidingLevel = 1;
		} else if ($permissions['private']) {
			$hidingLevel = 0;
		} else if ($dsPublique == 'Pr' && ($diffusionNiveauPrecision == 0 || empty($diffusionNiveauPrecision))) {
			$hidingLevel = 1;
		} else if ($diffusionNiveauPrecision == 5) {
			$hidingLevel = 0;
		}
		return $hidingLevel;
	}

	/**
	 * Sets the hiding_level column for all values given.
	 *
	 * @param
	 *        	Array|Array of String $tableValues the list of the values of the primary key fields
	 * @param String $tableFormat
	 *        	the format of the table
	 * @param String $sessionId
	 *        	the id of the user session
	 */
	private function setHidingLevels($tableValues, $tableFormat, $sessionId) {
		$fullRequest = "";
		$permissions = $this->getVisuPermissions();
		if ($permissions['logged']) {
			$minHidingLevel = 0;
		} else {
			$minHidingLevel = 1;
		}

		for ($i = 0; $i < count($tableValues); $i ++) {
			if ($tableValues[$i]['hiding_level'] > $minHidingLevel) {
				$fullRequest .= "UPDATE results AS res SET hiding_level = " . $tableValues[$i]['hiding_level'] . " FROM requests AS req ";
				$fullRequest .= "WHERE res.id_provider = '" . $tableValues[$i]['id_provider'] . "' ";
				$fullRequest .= "AND res.id_observation = '" . $tableValues[$i]['id_observation'] . "' ";
				$fullRequest .= "AND res.table_format = '" . $tableFormat . "' ";
				$fullRequest .= "AND res.id_request = req.id AND req.session_id = '" . $sessionId . "';";
			}
		}
		$this->logger->debug('setHidingLevels : ' . $fullRequest);

		if (!empty($fullRequest)) {
			$this->db->exec($fullRequest);
		}
	}

	/**
	 * Gets the permissions linked to visualization : sensitive, private and logged.
	 * If the user is not logged in, all observations are hidden below level of commune.
	 *
	 * @return array of string|boolean $permissions
	 */
	public function getVisuPermissions() {
		$user = (new Zend_Session_Namespace('user'))->user;
		$permissions = array(
			'sensitive' => $user->isAllowed('VIEW_SENSITIVE'),
			'private' => $user->isAllowed('VIEW_PRIVATE'),
			'logged' => !array_key_exists('visiteur', $user->rolesList)
		);
		return $permissions;
	}

	/**
	 * Deletes the rows that should not appear on the map or in the results table.
	 * Criteria for deleting rows is based on the calculation of the maximum level of
	 * precision asked by the user. If this maximum level is inferior to the hiding_level
	 * of the row, the row will be deleted.
	 *
	 * @param string $reqId
	 */
	private function deleteUnshowableResultsFromCriterias($reqId) {
		$this->logger->info('deleteUnshowableResultsFromCriterias with request id : ' . $reqId);
		$customQueryService = new Custom_Application_Service_QueryService($this->getSchema());
		$maxPrecisionLevel = $customQueryService->getMaxPrecisionLevel($this->getQueryCriterias());
		$sql = "DELETE FROM results WHERE hiding_level > ? AND id_request = ?";

		$stmt = $this->db->prepare($sql);
		$stmt->execute(array(
			$maxPrecisionLevel,
			$reqId
		));
	}

	protected function getSchema() {
		$websiteSession = new Zend_Session_Namespace('website');
		return $websiteSession->schema;
	}

	protected function getQueryCriterias() {
		$websiteSession = new Zend_Session_Namespace('website');
		return $websiteSession->formQuery->criterias;
	}

	/**
	 * Cleans the previously stored results.
	 * Delete the results belonging to the current user or that are too old.
	 *
	 * @param
	 *        	String the user session id.
	 */
	public function cleanPreviousResults($sessionId) {

		// Deleting from requests also delete from results because of the
		// ON DELETE CASCADE in the definition of the table
		$req = "DELETE FROM requests
				WHERE session_id = ? OR (_creationdt < CURRENT_TIMESTAMP - INTERVAL '2 days')";

		$this->logger->info('cleanPreviousResults request : ' . $req);

		$query = $this->db->prepare($req);
		$query->execute(array(
			$sessionId
		));
	}

	/**
	 * Returns the bounding box that bounds geometries of results table.
	 *
	 * @param String $sessionId
	 *        	the user session id.
	 * @param String $resultLayer
	 *        	the less precise result layer viewed.
	 * @return Array of : String the bounding box as WKT (well known text), and Boolean true if bounding box is restrained.
	 */
	public function getResultsBBox($sessionId, $resultLayer = 'departement') {
		$this->logger->info('getResultsBBox session_id : ' . $sessionId);

		$configuration = Zend_Registry::get("configuration");
		$projection = $configuration->getConfig('srs_visualisation', 3857);
		$bboxComputeThreshold = $configuration->getConfig('results_bbox_compute_threshold');
		$regionCode = $configuration->getConfig('regionCode');

		$websiteSession = new Zend_Session_Namespace('website');
		$nbResults = $websiteSession->count;
		$restrainedBbox = false;

		$this->logger->info('getResultsBBox regionCode : ' . $regionCode);
		// Trim regionCode
		if (!in_array($regionCode, array(
			'FR',
			'DAILYBUILD'
		))) {
			if (substr($regionCode, 0, 1) === 'R') {
				$regionCode = substr($regionCode, 1);
			}
		}

		if (is_null($bboxComputeThreshold) || $nbResults < $bboxComputeThreshold) {

			$req = "SELECT st_astext(st_extent(st_transform(geom, $projection ))) as wkt
				FROM bac_$resultLayer bac
				INNER JOIN observation_$resultLayer obs ON obs.id_$resultLayer = bac.id_$resultLayer
				INNER JOIN results res ON res.table_format =  obs.table_format
				AND res.id_provider = obs.id_provider
				AND res.id_observation = obs.id_observation
				INNER JOIN requests req ON res.id_request = req.id
				WHERE req.session_id = ?";

			$this->logger->info("getResultsBBox computing full results bbox with request : $req");

			$select = $this->db->prepare($req);
			$select->execute(array(
				$sessionId
			));
		} else {
			$restrainedBbox = true;
			if (!in_array($regionCode, array(
				'FR',
				'DAILYBUILD'
			))) {
				$req = "SELECT st_astext(st_envelope(st_transform(geom, $projection))) as wkt
						FROM referentiels.geofla_region
						WHERE code_reg = ?";

				$this->logger->info("getResultsBBox computing default region bbox with request : $req");

				$select = $this->db->prepare($req);
				$select->execute(array(
					$regionCode
				));
			} else {
				$req = "SELECT st_astext(st_extent(st_transform(geom, 3857))) as wkt
						FROM referentiels.geofla_region
						WHERE code_reg NOT LIKE '0%'";

				$this->logger->info("getResultsBBox computing default metropolitan country bbox with request : $req");
				$select = $this->db->prepare($req);
				$select->execute();
			}
		}

		$result = $select->fetchColumn(0);

		return array(
			'bbox' => $result,
			'restrained' => $restrainedBbox
		);
	}

	/**
	 * Returns the number of results in the results table.
	 *
	 * @param
	 *        	String the user session id.
	 * @return Integer the number of results
	 */
	public function getResultsCount($sessionId) {
		$req = "SELECT count(*) FROM results
 				INNER JOIN requests ON results.id_request = requests.id
 				WHERE session_id = ?";

		$select = $this->db->prepare($req);
		$select->execute(array(
			$sessionId
		));
		$result = $select->fetchColumn(0);

		return $result;
	}

	/**
	 * Returns the intersected location information.
	 *
	 * @param String $sessionId
	 *        	The session id
	 * @param Float $lon
	 *        	the longitude
	 * @param Float $lat
	 *        	the latitude
	 * @param
	 *        	Array of String $activeLayers
	 *        	the layers currently visible
	 * @param
	 *        	String &$resultsLayer
	 *        	the more precise layer where results are found
	 * @return Array
	 * @throws Exception
	 */
	public function getLocationInfo($sessionId, $lon, $lat, $activeLayers, &$resultsLayer = null) {
		$this->logger->info('getLocationInfo session_id : ' . $sessionId);
		$this->logger->info('getLocationInfo lon : ' . $lon);
		$this->logger->info('getLocationInfo lat : ' . $lat);
		$this->logger->info('getLocationInfo layers : ' . implode(',', $activeLayers));

		$configuration = Zend_Registry::get("configuration");
		$projection = $configuration->getConfig('srs_visualisation', 3857);
		$selectMode = 'buffer'; // $configuration->getConfig('featureinfo_selectmode', 'buffer');
		$margin = $configuration->getConfig('featureinfo_margin', '1000');

		$translate = Zend_Registry::get('Zend_Translate');
		$lang = strtoupper($translate->getAdapter()->getLocale());

		$websiteSession = new Zend_Session_Namespace('website');
		// Get the current used schema
		$schema = $websiteSession->schema;
		// Get the last query done
		$queryObject = $websiteSession->queryObject;

		$genericService = new Application_Service_GenericService();
		$metadataModel = new Application_Model_Metadata_Metadata();
		// Extract the location table from the last query
		$tables = $genericService->getAllFormats($schema, $queryObject);
		// Extract the location field from the available tables
		$locationField = $metadataModel->getGeometryField($schema, array_keys($tables));
		// Get the location table infos
		$locationTableInfo = $metadataModel->getTableFormat($schema, $locationField->format);
		// Get the location table columns
		$tableFields = $metadataModel->getTableFields($schema, $locationField->format, null);

		// Setup the location table columns for the select
		// Only few columns are selected
		$cols = '';
		$joinForMode = '';
		$i = 0;
		foreach ($tableFields as $tableField) {
			$columnName = $tableField->columnName;
			if (in_array($columnName, self::$fieldsToSelect)) {
				// Get the mode label if the field is a modality
				if ($tableField->type === 'CODE' && $tableField->subtype === 'MODE') {
					$modeAlias = 'm' . $i;
					$translateAlias = 't' . $i;
					$cols .= 'COALESCE(' . $translateAlias . '.label, ' . $modeAlias . '.label) as ' . $columnName . ', ';
					$joinForMode .= 'LEFT JOIN mode ' . $modeAlias . ' ON ' . $modeAlias . '.CODE = ' . $columnName . ' AND ' . $modeAlias . '.UNIT = \'' . $tableField->unit . '\' ';
					$joinForMode .= 'LEFT JOIN translation ' . $translateAlias . ' ON (' . $translateAlias . '.lang = \'' . $lang . '\' AND ' . $translateAlias . '.table_format = \'MODE\' AND ' . $translateAlias . '.row_pk = ' . $modeAlias . '.unit || \',\' || ' . $modeAlias . '.code) ';
					$i ++;
				} elseif ($tableField->type === "DATE") {
					$cols .= 'to_char(' . $columnName . ', \'YYYY/MM/DD\') as ' . $columnName . ', ';
				} else {
					$cols .= $columnName . ', ';
				}
			}
		}

		// Setup the location table pks for the join on the location table
		// and for the pk column
		$pkscols = '';
		foreach ($locationTableInfo->primaryKeys as $primaryKey) {
			$pkscols .= "l." . $primaryKey . "::varchar || '__' || ";
			$cols .= "'" . strtoupper($primaryKey) . "/' || " . $primaryKey . " || '/' || ";
		}
		if ($pkscols != '') {
			$pkscols = substr($pkscols, 0, -11);
		} else {
			throw new Exception('No pks columns found for the location table.');
		}
		if ($cols != '') {
			$cols = substr($cols, 0, -11) . " as pk ";
		} else {
			throw new Exception('No columns found for the location table.');
		}

		$select = "SELECT " . $cols . " ";

		// Order the active layers from the more precise to the less precise
		$orderedLayers = array(
			'geometrie',
			'commune',
			'maille',
			'departement'
		);

		$findLayer = function ($name) use ($orderedLayers) {
			foreach ($orderedLayers as $layer) {
				if (stripos($name, $layer) !== false) {
					return $layer;
				}
			}
			return false;
		};

		$activeLayers = array_map($findLayer, $activeLayers);
		$orderedActiveLayers = array_intersect($orderedLayers, $activeLayers);

		// Build the FROM ... JOIN ... WHERE ... part of the request ;
		// Then execute it for each $orderedActiveLayers, until you get at least one result.

		$rawDataTableName = $locationTableInfo->tableName;
		// Map the varying two keys in results to the keys in the raw_data table
		$keys = $this->genericModel->getRawDataTablePrimaryKeys($locationTableInfo);

		$fromTemplate = "FROM bac_# bac
				  INNER JOIN observation_# obs ON obs.id_$ = bac.id_#
				  INNER JOIN results res ON res.table_format =  obs.table_format
				  AND res.id_provider = obs.id_provider
				  AND res.id_observation = obs.id_observation
				  INNER JOIN requests req ON res.id_request = req.id
				  INNER JOIN $rawDataTableName raw ON raw.provider_id = res.id_provider
				  AND raw." . $keys['id_observation'] . " = res.id_observation
				  WHERE req.session_id = ?
				  AND hiding_level <= ?
				  AND ST_DWithin(bac.geom, ST_SetSRID(ST_Point(?, ?),$projection), $margin)
				  ORDER BY res.id_provider, res.id_observation";

		foreach ($orderedActiveLayers as $level => $layer) {

			$idName = ($layer == 'geometrie') ? 'geom' : $layer;

			$fromWhere = str_replace('#', $layer, $fromTemplate);
			$fromWhere = str_replace('$', $idName, $fromWhere);

			$req = $select . $fromWhere;

			$this->logger->info("getLocationInfo request, layer $layer : $req");

			$query = $this->db->prepare($req);
			$query->execute(array(
				$sessionId,
				$level,
				$lon,
				$lat
			));

			$results = $query->fetchAll();

			// If results, order and return them, else continue
			$sortedResult = array();
			if (!empty($results)) {
				foreach (self::$fieldsToSelect as $fieldToDisplay) {
					for ($i = 0; $i < count($results); $i ++) {
						foreach (array_keys($results[$i]) as $key) {
							if ($key == $fieldToDisplay) {
								$sortedResult[$i][$fieldToDisplay] = $results[$i][$key];
							}
						}
					}
				}
				$resultsLayer = $layer;
				return $sortedResult;
			}
		}
		// If no results found in all active layers, return null
		return null;
	}

	/**
	 * Indicate if the raw database is on a remote server.
	 *
	 * @return Boolean true if the raw database is on a local server
	 */
	protected function _isLocalDB() {
		$rawdb = Zend_Registry::get('raw_db');

		$mappingConfig = $this->db->getConfig();
		$rawConfig = $rawdb->getConfig();

		// We consider that the database is remote if any of the main config options is different
		$isLocal = true;
		$isLocal = $isLocal && ($mappingConfig['host'] === $rawConfig['host']);
		$isLocal = $isLocal && ($mappingConfig['port'] === $rawConfig['port']);
		$isLocal = $isLocal && ($mappingConfig['dbname'] === $rawConfig['dbname']);
		$isLocal = $isLocal && ($mappingConfig['username'] === $rawConfig['username']);

		$this->logger->info('isLocal : ' . ($isLocal ? "yes" : "no"));

		return $isLocal;
	}
}
