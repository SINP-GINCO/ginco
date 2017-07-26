<?php
namespace Ign\Bundle\GincoBundle\Services;

use Ign\Bundle\GincoBundle\Entity\Mapping\Request;
use Ign\Bundle\GincoBundle\Entity\Mapping\Result;
use Ign\Bundle\OGAMBundle\Entity\Generic\QueryForm;
use Ign\Bundle\OGAMBundle\Entity\Mapping\Layer;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Format;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FormField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Unit;
use Ign\Bundle\OGAMBundle\OGAMBundle;
use Ign\Bundle\OGAMBundle\Services\QueryService as BaseService;
use Symfony\Component\HttpFoundation\Session\Session;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericFormField;
use Ign\Bundle\OGAMBundle\Entity\Website\User;

/**
 * The Query Service customized for Ginco.
 *
 * This service handles the queries used to feed the query interface with ajax requests.
 */
class QueryService extends BaseService {

	private static $fieldLevels = array(
		'geometrie' => 0,
		'nomcommune' => 1,
		'nomcommunecalcule' => 1,
		'codecommune' => 1,
		'codecommunecalcule' => 1,
		'codemaille' => 2,
		'codemaillecalcule' => 2,
		'codedepartement' => 3,
		'codedepartementcalcule' => 3
	);

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

	private static $submissionJoin = array(
		'submission'
	);

	private static $resultJoins = array(
		'submission',
		'results'
	);

	public static function getFieldsLevels() {
		return self::$fieldLevels;
	}

	/**
	 * The map repository.
	 *
	 * @var Repository
	 */
	protected $mapRepository;

	public function __construct($doctrine, $genericService, $configuration, $logger, $locale, $schema, $genericModel, $mapRepository, $user=null) {
		parent::__construct($doctrine, $genericService, $configuration, $logger, $locale, $schema, $genericModel, $user);

		$this->mapRepository = $mapRepository;
	}

	/**
	 * Copy the locations of the result in a temporary table.
	 * MIGRATED
	 *
	 * @param String $from
	 *        	the FROM part of the SQL Request
	 * @param String $where
	 *        	the WHERE part of the SQL Request
	 * @param \OGAMBundle\Entity\Generic\QueryForm $queryForm
	 *        	the form request object
	 * @param mixed $user
	 *        	the user in session
	 * @param Array $userInfos
	 *        	Few user informations
	 * @param Session $session
	 *        	the current session
	 */
	public function prepareResults($from, $where, $queryForm, $user, $userInfos, $session) {
		$this->logger->debug('prepareResults ginco');

		// Get the mappings for the query form fields
		$mappingSet = $queryForm->getFieldMappingSet();

		// Generate and save the table formats in session
		$tables = $this->genericService->getAllFormats($this->schema, $mappingSet->getFieldMappingArray());
		$session->set('all_tables_formats', $tables);

		// Generate the SQL Request
		$from = $this->genericService->generateGincoSQLFromRequest($this->schema, $mappingSet, self::$submissionJoin);
		$where = $this->genericService->generateGincoSQLWhereRequest($this->schema, $queryForm->getCriteria(), $mappingSet, $userInfos, $tables);

		// Clean previously stored results
		$sessionId = session_id();
		$this->logger->debug('SessionId : ' . $sessionId);
		$repo = $this->doctrine->getManager('mapping')->getRepository(Result::class);
		$repo->cleanPreviousResults($sessionId);

		// Identify the field carrying the location information
		// $tables = $this->genericService->getAllFormats($this->schema, $mappingSet->getFieldMappingArray());
		$locationFields = $this->metadataModel->getRepository(TableField::class)->getGeometryFields($this->schema, array_keys($tables), $this->locale);
		foreach ($locationFields as $locationField) {
			$locationTableInfo = $this->metadataModel->getRepository(TableFormat::class)->getTableFormat($this->schema, $locationField->getFormat()
				->getFormat(), $this->locale);
			// Run the request to store a temporary result table (for the web mapping)
			$this->fillResultTable($from, $where, $sessionId, $user, $locationTableInfo, $queryForm->getCriteria());
		}
	}

	/**
	 * Populate the result location table.
	 * This is the Ginco method for Ogam fillResultLocation method.
	 *
	 * @param String $from
	 *        	the FROM part of the SQL Request
	 * @param String $where
	 *        	the WHERE part of the SQL Request
	 * @param String $sessionId
	 *        	the user session id.
	 * @param mixed $user
	 *        	the user in session
	 * @param \OGAMBundle\Entity\Metadata\TableFormat $locationTable
	 *        	the location table
	 * @param array[Ign\Bundle\OGAMBundle\Entity\Generic\Field] $queryCriteria
	 *        	the form fields (query criteria)
	 */
	public function fillResultTable($from, $where, $sessionId, $user, $locationTable, $queryCriteria) {
		$this->logger->info('fillResultTable');

		if (empty($from) || empty($where)) {
			return;
		}
		$requestRepository = $this->doctrine->getManager('mapping')->getRepository(Request::class);
		$resultRepository = $this->doctrine->getManager('mapping')->getRepository(Result::class);

		// First, insert a "request" record
		$reqId = $requestRepository->createRequest($sessionId);

		// Then copy references in the "results" table

		// The name of the table holding the geometric information
		$tableFormat = $locationTable->getFormat();

		// Map the varying two keys in results to the keys in the raw_data table
		$keys = $this->genericModel->getRawDataTablePrimaryKeys($locationTable);

		$permissions = $this->getVisuPermissions($user);
		if ($permissions['logged']) {
			$defaultHidingLevel = 0;
		} else {
			$defaultHidingLevel = 1;
		}
		// Insert the results
		$resultRepository->insert($reqId, $tableFormat, $keys, $defaultHidingLevel, $from, $where);

		// Get back the results and for each, get and fill hiding level
		$tableValues = $this->getHidingLevels($keys, $locationTable, $this->getVisuPermissions($user), $from, $where, $reqId);
		$resultRepository->bulkUpdate($tableValues, $locationTable->getFormat(), $sessionId, $permissions);

		// Remove any values that can be obtained through criterias more precise than the hiding level
		$maxPrecisionLevel = $this->getMaxPrecisionLevel($queryCriteria);
		$resultRepository->deleteUnshowableResults($reqId, $maxPrecisionLevel);
	}

	/**
	 * Updates the hiding levels for all rows provided in the array of values.
	 * MIGRATED
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
		$ogamIdColumn = $keys['id_observation'];
		$providerIdColumn = $keys['id_provider'];

		$results = $this->genericModel->getHidingLevelParameters($geometryTable, $ogamIdColumn, $providerIdColumn, $reqId, $from, $where);

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
	 * Returns the level of the maximum precision allowed for the set of request criteria.
	 * levels are numbered from 1 (max precision, ie geom) to 4 (lower precision, ie region).
	 * Max precision level is equivalent to min level id.
	 *
	 * @param
	 *        	array of FormField $criterias
	 * @return $maxPrecisionLevel the level of the maximum precision allowed for the set of request criteria.
	 */
	public function getMaxPrecisionLevel($criterias) {
		$this->logger->debug('getMaxPrecisionLevel');

		$maxPrecisionLevel = 1000;
		$fieldsLevels = $this->getFieldsLevels();
		foreach ($criterias as $criteria) {
			$data = $criteria->getData();
			if (in_array($data, array_keys($fieldsLevels))) {
				$fieldLevel = $fieldsLevels[$data];
				if ($fieldLevel < $maxPrecisionLevel) {
					$maxPrecisionLevel = $fieldLevel;
				}
			}
		}

		$this->logger->debug("maxPrecisionLevel : " . $maxPrecisionLevel);
		return $maxPrecisionLevel;
	}

	/**
	 * Gets the permissions linked to visualization : sensitive, private and logged.
	 * If the user is not logged in, all observations are hidden below level of commune.
	 * MIGRATED
	 *
	 * @param mixed $user
	 *        	the user in session
	 * @return array of string|boolean $permissions
	 */
	public function getVisuPermissions($user) {
		$permissions = array(
			'sensitive' => $user->isAllowed('VIEW_SENSITIVE'),
			'private' => $user->isAllowed('VIEW_PRIVATE'),
			'logged' => !array_key_exists('visiteur', $user->getRoles())
		);
		return $permissions;
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
	 * Build the request.
	 * MIGRATED.
	 *
	 * @param QueryForm $queryForm
	 *        	the request form
	 * @param Array $userInfos
	 *        	Few user informations
	 * @param Integer $maxPrecisionLevel
	 *        	the maximum level of precision asked by the user
	 * @param Integer $requestId
	 *        	the id of the request
	 * @param Session $session
	 *        	the current session
	 */
	public function buildRequestGinco(QueryForm $queryForm, $userInfos, $maxPrecisionLevel, $requestId, Session $session) {
		$this->logger->debug('buildRequest custom');

		// Get the mappings for the query form fields
		$mappingSet = $queryForm->getFieldMappingSet();

		// Identify the field carrying the location information
		$tables = $this->genericService->getAllFormats($this->schema, $mappingSet);
		$tables = $session->get('all_tables_formats');
		$tableFieldRepository = $this->metadataModel->getRepository('OGAMBundle:Metadata\TableField');
		$tableFormatRepository = $this->metadataModel->getRepository('OGAMBundle:Metadata\TableFormat');
		$locationField = $tableFieldRepository->getGeometryField($this->schema, array_keys($tables), $this->locale);
		$locationTableInfo = $tableFormatRepository->getTableFormat($this->schema, $locationField->getFormat(), $this->locale);
		$geometryTablePKeyIdWithTable = $locationTableInfo->getFormat() . "." . $locationTableInfo->getPrimaryKeys()[0];
		$geometryTablePKeyProviderIdWithTable = $locationTableInfo->getFormat() . "." . $locationTableInfo->getPrimaryKeys()[1];

		// The not customised $from clause contains table_tree joins. Here we add joins with submission table, or submission and results tables.
		$fromJoinSubmission = $this->genericService->generateGincoSQLFromRequest($this->schema, $mappingSet, self::$submissionJoin);
		// Results table contains geometry table id. => table and keys must be thoses of the geometry table
		$fromJoinResults = $this->genericService->generateGincoSQLFromRequest($this->schema, $mappingSet, self::$resultJoins, $geometryTablePKeyIdWithTable, $geometryTablePKeyProviderIdWithTable);

		// Generate the SQL Request
		$select = $this->genericService->generateGincoSQLSelectRequest($this->schema, $queryForm->getColumns(), $mappingSet, $userInfos);
		$where = $this->genericService->generateGincoSQLWhereRequest($this->schema, $queryForm->getCriteria(), $mappingSet, $userInfos, $tables);
		$endWhere = $this->genericService->generateSQLEndWhereRequest(str_replace(',', '', explode(' ', $fromJoinSubmission)[3]), $requestId, $maxPrecisionLevel);
		$sqlPKey = $this->genericService->generateSQLPrimaryKey($this->schema, $mappingSet);

		$this->logger->debug('$select : ' . $select);
		$this->logger->debug('$from : ' . $fromJoinSubmission);
		$this->logger->debug('$where : ' . $where);
		$this->logger->debug('$endWhere : ' . $endWhere);

		// Store the metadata in session for subsequent requests
		$session->set('query_SQLSelect', $select);
		$session->set('query_SQLFrom', $fromJoinSubmission);
		$session->set('query_SQLFromJoinResults', $fromJoinResults);
		$session->set('query_SQLWhere', $where);
		$session->set('query_SQLEndWhere', $endWhere);
		$session->set('query_SQLPkey', $sqlPKey);
		$session->set('query_locationField', $locationField); // used in the KML export

		// Subquery (for getting desired rows)
		$subquery = "SELECT DISTINCT " . $sqlPKey . $fromJoinSubmission . $where;

		// Count the number of results (necessary for getResultsBbox and getResultRows)
		$countRequest = "SELECT count(*) $fromJoinResults WHERE ($sqlPKey) IN ($subquery) $endWhere";
		$this->logger->debug('count request = ' . $countRequest);
		$countRequestResult = $this->getQueryResults($countRequest);
		$countResult = $countRequestResult[0]['count'];
		$session->set('query_Count', $countResult);
	}

	/**
	 * Get a page of query result data.
	 * MIGRATED
	 *
	 * @param Integer $start
	 *        	the start line number
	 * @param Integer $length
	 *        	the size of a page
	 * @param String $sort
	 *        	the sort column
	 * @param String $sortDir
	 *        	the sort direction (ASC or DESC)
	 * @param Session $session
	 *        	the current session
	 * @param Boolean $emptyHidingValue
	 *        	if true, we leave the hided values empty (and not replaced with a string), and we keep their type
	 * @param Array $userInfos
	 *        	Few user informations
	 * @param String $locale
	 *        	the current locale
	 * @param Boolean $emptyHidingValue
	 *        	whether the hiding value should be empty or not
	 * @return JSON
	 */
	public function getResultRowsGinco($start, $length, $sort, $sortDir, $session, $userInfos, $locale, $emptyHidingValue = false) {
		$this->logger->debug('getResultRows');

		$ĥidingValue = $this->configuration->getConfig('hiding_value');

		// Get the request from the session
		$queryForm = $session->get('query_QueryForm');

		// Get the mappings for the query form fields
		$queryForm = $this->setQueryFormFieldsMappings($queryForm);

		$select = $session->get('query_SQLSelect');
		$pKey = $session->get('query_SQLPkey');
		$fromJoins = $session->get('query_SQLFromJoinResults');
		$from = $session->get('query_SQLFrom');
		$where = $session->get('query_SQLWhere');
		$andWhere = $session->get('query_SQLEndWhere');

		$order = "";
		$hidingLevelKey = ", hiding_level, ";

		if (!empty($sort)) {
			$orderKey = "";
			$orderKeyType = "";
			// $sort contains the form format and field
			$split = explode("__", $sort);
			$formField = new GenericField($split[0], $split[1]);
			$tableField = $this->metadataModel->getRepository(TableField::class)->getFormToTableMapping($this->schema, $formField, $locale);
			$orderKey = $tableField->getFormat()->getFormat() . "." . $tableField->getData()->getData();
			$orderKeyType = $tableField->getData()->getUnit()->getType();
			$order .= " ORDER BY " . $orderKey . " " . $sortDir;
			// Customization of select for specific data types
			if ($orderKeyType == 'GEOM' || $orderKeyType == 'DATE') {
				$select .= ", " . $orderKey;
			}
			$nullSubstitute = $this->genericService->getPostgresValueFromOgamType($orderKeyType);
		} else {
			$order .= " ORDER BY " . $pKey;
		}

		// Subquery (for getting desired rows)
		if (empty($orderKey)) {
			$subquery = "SELECT DISTINCT " . $pKey . $from . $where;
		} else {
			// coalesce() replaces $orderKey NULL values by $nullSubstitute
			$orderkeyCoalesce = "coalesce($orderKey, '$nullSubstitute')";
			$subquery = "SELECT DISTINCT $pKey, $orderkeyCoalesce $from $where";
		}
		$filter = "";
		if (!empty($length)) {
			$filter .= " LIMIT " . $length;
		}
		if (!empty($start)) {
			$filter .= " OFFSET " . $start;
		}

		// Retrieve the geometry table pkey "ogam_id_table_xxx"
		$split1 = explode('results.id_observation = ', $fromJoins);
		$split2 = explode(' ', $split1[1])[0];
		$locationTablepKeyId = ", $split2 as loc_pk";

		$this->logger->debug('select = ' . $select);
		$this->logger->debug('pkey = ' . $pKey);
		$this->logger->debug('$locationTablepKeyId = ' . $locationTablepKeyId);
		$this->logger->debug('from = ' . $from);
		$this->logger->debug('where = ' . $where);

		// Build complete query
		if (empty($orderKey)) {
			$query = "$select $hidingLevelKey $pKey $locationTablepKeyId $fromJoins WHERE ($pKey) IN ($subquery $order $filter) $andWhere";
		} else {
			$query = "$select, $orderkeyCoalesce $hidingLevelKey $pKey $locationTablepKeyId $fromJoins";
			$query .= " WHERE ($pKey, $orderkeyCoalesce) IN ($subquery ORDER BY coalesce $sortDir $filter)";
			$query .= " $andWhere ORDER BY $orderkeyCoalesce $sortDir";
		}
		// Execute the request
		$result = $this->getQueryResults($query);

		// Retrieve the session-stored info
		$columnsDstFields = $queryForm->getColumnsDstFields();

		$resultRows = array();
		foreach ($result as $line) {
			$resultRow = array();
			$observationId = '';
			foreach ($line as $key => $value) {
				if (stripos($key, 'loc_pk') !== false) {
					$observationId = $value;
				}
			}

			foreach ($columnsDstFields as $columnDstField) {

				$tableField = $columnDstField->getMetadata();
				$key = strtolower($tableField->getName());
				$value = $line[$key];
				$hidingLevel = $line['hiding_level'];
				$shouldValueBeHidden = $this->genericModel->shouldValueBeHidden($tableField->getColumnName(), $hidingLevel);
				$type = $tableField->getData()
					->getUnit()
					->getType();
				// Manage code traduction
				if ($type === "CODE" && $value != "") {
					if ($shouldValueBeHidden) {
						$value = ($emptyHidingValue) ? "" : $ĥidingValue;
					}
					$resultRow[] = strval($this->genericService->getValueLabel($tableField, $value));
				} else if ($type === "ARRAY" && $value != "") {
					if ($shouldValueBeHidden) {
						$resultRow[] = ($emptyHidingValue) ? array() : $ĥidingValue;
					} else {
						// Split the array items
						$arrayValues = explode(",", preg_replace("@[{-}]@", "", $value));
						foreach ($arrayValues as $index => $value) {
							if ($shouldValueBeHidden) {
								$arrayValues[$index] = ($emptyHidingValue) ? "" : $ĥidingValue;
							}
							$arrayValues[$index] = $this->genericService->getValueLabel($tableField, $arrayValues[$index]);
						}
						$resultRow[] = $arrayValues;
					}
				} else {
					if ($shouldValueBeHidden) {
						$value = ($emptyHidingValue) ? "" : $ĥidingValue;
					}
					$resultRow[] = $value;
				}
			}

			// Add the line id
			$resultRow[] = $line['id'];

			// Right management : add the provider id of the data
			if (!$userInfos['DATA_QUERY_OTHER_PROVIDER']) {
				$resultRow[] = $line['_provider_id'];
			}
			$resultRows[] = $resultRow;
		}
		return $resultRows;
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
	public function getResultsBBox($sessionId, $nbResults, $resultLayer = 'departement') {
		$this->logger->info('getResultsBBox session_id : ' . $sessionId);

		$projection = $this->configuration->getConfig('srs_visualisation', 3857);
		$bboxComputeThreshold = $this->configuration->getConfig('results_bbox_compute_threshold');
		$regionCode = $this->configuration->getConfig('regionCode');
		$restrainedBbox = false;

		$this->logger->info("With regionCode : $regionCode, sessionId : $sessionId, projection : $projection, nbResults : $nbResults");

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

			$this->logger->info("Computing full results bbox...");
			$bbox = $this->mapRepository->getPreciseBbox($projection, $resultLayer, $sessionId);
		} else {
			$restrainedBbox = true;
			if (!in_array($regionCode, array(
				'FR',
				'DAILYBUILD'
			))) {
				$bbox = $this->mapRepository->getRegionBbox($projection, $regionCode);
			} else {
				$this->logger->info("Computing metropolitan country bbox...");
				$bbox = $this->mapRepository->getMetropolitanBbox($projection);
			}
		}

		return array(
			'bbox' => $bbox,
			'restrained' => $restrainedBbox
		);
	}

	/**
	 * ********************* DETAILS ************************************************************************************
	 */

	/**
	 * Get the details associed with a result line (clic on the "detail button").
	 * MIGRATED.
	 *
	 * @param String $id
	 *        	The identifier of the line
	 * @param String $detailsLayers
	 *        	The names of the layers used to display the images in the detail panel.
	 * @param String $datasetId
	 *        	The identifier of the dataset (to filter data)
	 * @param String $bbox
	 *        	The bounding box (not used)
	 * @param boolean $withChildren
	 *        	If true, get the information about the children of the object
	 * @param Array $userInfos
	 *        	Few user informations
	 * @return array Array that represents the details of the result line.
	 */
	public function getDetailsDataGinco($id, $detailsLayers, $datasetId, $bbox = '', $withChildren = false, $userInfos) {
		$this->logger->debug('getDetailsData : ' . $id);

		// Transform the identifier in an array
		$keyMap = $this->_decodeId($id);

		// The test in the following block code (empty[$keyMap[$infoField->data]])
		// fails if $infoField->data and the keys of $keyMap don't have the same case...
		// So we put everything in uppercase
		$keysKeyMap = array_map("strtoupper", array_keys($keyMap));
		$valuesKeyMap = array_values($keyMap);
		$keyMap = array_combine($keysKeyMap, $valuesKeyMap);

		// Prepare a GenericTableFormat to be filled
		$gTableFormat = $this->genericService->buildGenericTableFormat($keyMap['SCHEMA'], $keyMap['FORMAT'], null);

		// Complete the primary key info
		foreach ($gTableFormat->getIdFields() as $idField) {
			if (!empty($keyMap[strtoupper($idField->getData())])) {
				$idField->setValue($keyMap[strtoupper($idField->getData())]);
			}
		}

		// Get the detailed data
		$requestId = $this->doctrine->getRepository('Ign\Bundle\GincoBundle\Entity\Mapping\Request', 'mapping')->getLastRequestIdFromSession(session_id());
		$this->genericModel->getDatumGinco($gTableFormat, $requestId);

		// The data ancestors
		$ancestors = $this->genericModel->getAncestors($gTableFormat);
		$ancestors = array_reverse($ancestors);

		// Defines the formats
		$dataDetails = array();
		$dataDetails['formats'] = array();
		$gTables = array_merge($ancestors, [
			$gTableFormat
		]);

		foreach ($gTables as $gTable) {
			$dataDetails['formats'][] = [
				'id' => $gTable->getId(),
				'title' => $gTable->getMetadata()->getLabel(),
				'fields' => $this->genericService->getFormFieldsOrdered($gTable->all()),
				'editURL' => $userInfos['DATA_EDITION'] ? $gTable->getId() : null
			];
		}

		// Defines the panel title
		$title = '';
		foreach ($gTableFormat->getIdFields() as $idField) {
			if ($title !== '') {
				$title .= '_';
			}
			$title .= $idField->getValue();
		}
		$dataInfo = end($dataDetails['formats']);
		$dataDetails['title'] = $dataInfo['title'] . ' (' . $title . ')';

		// Add the localisation maps
		if (!empty($detailsLayers)) {
			if ($detailsLayers[0] !== '') {
				$url = array();
				$url = explode(";", ($this->getDetailsMapUrl(empty($detailsLayers) ? '' : $detailsLayers[0], $bbox, '')));

				$dataDetails['maps1'] = array(
					'title' => 'image'
				);

				// complete the array with the urls of maps1
				$dataDetails['maps1']['urls'][] = array();
				$urlCount = count($url);
				for ($i = 0; $i < $urlCount; $i ++) {
					$dataDetails['maps1']['urls'][$i]['url'] = $url[$i];
				}
			}
		}

		// Add the children
		if ($withChildren) {

			// Prepare a data object to be filled
			$data2 = $this->genericService->buildGenericTableFormat($keyMap["SCHEMA"], $keyMap["FORMAT"], null);

			// Complete the primary key
			foreach ($data2->getIdFields() as $idField) {
				if (!empty($keyMap[strtoupper($idField->getData())])) {
					$idField->setValue($keyMap[strtoupper($idField->getData())]);
				}
			}
			// Get children too
			$children = $this->genericModel->getChildren($data2, $datasetId);

			// Add the children
			foreach ($children as $listChild) {
				$dataArray = $this->genericService->dataToGridDetailArray($id, $listChild);
				if ($dataArray !== null) {
					$dataDetails['children'][] = $dataArray;
				}
			}
		}

		return $dataDetails;
	}

	/**
	 * Get the bounding box of the more precise geometry visible by user (and non-empty geometry).
	 * This function is called by "See on the map" button.
	 * This function is specific to Ginco.
	 * MIGRATED.
	 *
	 * @param String $observationId
	 *        	the observation id composed of schema, format, ogam_id, provider_id
	 * @param Session $session
	 *        	the current session
	 * @param mixed $user
	 *        	the user in session
	 * @param String $locale
	 *        	the current locale
	 * @return String the bbox represented by a WKT character chain
	 */
	public function getObservationBoundingBox($observationId = null, $session, $user, $locale) {
		$this->logger->info('getObservationBoundingBox');

		$requestId = $this->doctrine->getRepository('Ign\Bundle\GincoBundle\Entity\Mapping\Request', 'mapping')->getLastRequestIdFromSession($session->getId());

		$from = $session->get('query_SQLFrom');
		$where = $session->get('query_SQLWhere');
		$projection = $this->configuration->getConfig('srs_visualisation', 3857);

		// Transform the identifier in an array
		$keyMap = $this->_decodeId($observationId);
		$keysKeyMap = array_map("strtoupper", array_keys($keyMap));
		$valuesKeyMap = array_values($keyMap);
		$keyMap = array_combine($keysKeyMap, $valuesKeyMap);

		$table = $this->doctrine->getRepository(TableFormat::class)->getTableFormat($this->schema, $keyMap['FORMAT'], $locale);
		$keys = $this->genericModel->getRawDataTablePrimaryKeys($table);

		$providerId = $keyMap[strtoupper($keys['id_provider'])];
		$observationId = $keyMap[strtoupper($keys['id_observation'])];

		$permissions = $this->getVisuPermissions($user);
		$hidingLevel = $this->getHidingLevels($keys, $table, $permissions, $from, $where, $requestId)[0]['hiding_level'];

		$hidingLevels = array(
			"geometrie",
			"commune",
			"maille",
			"departement"
		);
		$bbox = '';

		for ($i = $hidingLevel; $i < count($hidingLevels); $i ++) {
			$layer = $hidingLevels[$i];
			$idKey = ($layer == "geometrie") ? "geom" : $layer;

			$bbQuery = "SELECT ST_AsText(ST_Extent(ST_Transform(geom, $projection ))) AS wkt
			FROM bac_$layer bac
			INNER JOIN observation_$layer obs ON obs.id_$idKey = bac.id_$layer
			INNER JOIN results res ON res.table_format =  obs.table_format
			AND res.id_provider = obs.id_provider
			AND res.id_observation = obs.id_observation
			WHERE res.id_request = $requestId
			AND res.id_provider = '" . $providerId . "'
			AND res.id_observation = '$observationId'";

			$bbResult = $this->getQueryResults($bbQuery);

			if (count($bbResult) && !empty($bbResult[0]['wkt'])) {
				$bbox = $bbResult[0]['wkt'];
				break;
			}
		}

		return $bbox;
	}

	/**
	 * Returns the intersected location information.
	 * MIGRATED
	 *
	 * @param String $sessionId
	 *        	The session id
	 * @param Float $lon
	 *        	the longitude
	 * @param Float $lat
	 *        	the latitude
	 * @param TableField $locationField
	 *        	the location table field
	 * @param String $schema
	 *        	the current Schema
	 * @param ConfigurationManager $configuration
	 *        	the configuration manager
	 * @param String $locale
	 *        	the current locale
	 * @param
	 *        	Array of String $activeLayers
	 *        	the layers currently visible
	 * @param
	 *        	String &$resultsLayer
	 *        	the more precise layer where results are found
	 * @return Array
	 * @throws Exception
	 */
	public function getLocationInfo($sessionId, $lon, $lat, $locationField, $schema, $configuration, $locale, $activeLayers, &$resultsLayer = null) {
		$projection = $configuration->getConfig('srs_visualisation', 3857);
		$selectMode = $configuration->getConfig('featureinfo_selectmode', 'buffer');
		$margin = $configuration->getConfig('featureinfo_margin', '1000');

		$locationTableFormat = $locationField->getFormat()->getFormat();
		// Get the location table infos
		$locationTableInfo = $this->doctrine->getManager('mapping')->getRepository(TableFormat::class)->getTableFormat($schema, $locationTableFormat, $locale);
		// Get the location table columns
		$tableFields = $this->doctrine->getManager('mapping')->getRepository(TableField::class)->getTableFields($schema, $locationTableFormat, null, $locale);

		// Setup the location table columns for the select
		// Only few columns are selected
		$cols = '';
		$joinForMode = '';
		$i = 0;
		foreach ($tableFields as $tableField) {
			$columnName = $tableField->getColumnName();
			if ($columnName != $locationField->getColumnName() && $columnName != 'SUBMISSION_ID' && $columnName != 'PROVIDER_ID' && $columnName != 'LINE_NUMBER') {

				if (in_array($columnName, self::$fieldsToSelect)) {
					// Get the mode label if the field is a modality
					$tableFieldUnit = $tableField->getData()->getUnit();
					if ($tableFieldUnit->getType() === 'CODE' && $tableFieldUnit->getSubtype() === 'MODE') {
						$modeAlias = 'm' . $i;
						$translateAlias = 't' . $i;
						$cols .= 'COALESCE(' . $translateAlias . '.label, ' . $modeAlias . '.label) as ' . $columnName . ', ';
						$joinForMode .= 'LEFT JOIN mode ' . $modeAlias . ' ON ' . $modeAlias . '.CODE = ' . $columnName . ' AND ' . $modeAlias . '.UNIT = \'' . $tableFieldUnit->getUnit() . '\' ';
						$joinForMode .= 'LEFT JOIN translation ' . $translateAlias . ' ON (' . $translateAlias . '.lang = \'' . $locale . '\' AND ' . $translateAlias . '.table_format = \'MODE\' AND ' . $translateAlias . '.row_pk = ' . $modeAlias . '.unit || \',\' || ' . $modeAlias . '.code) ';
						$i ++;
					} elseif ($tableFieldUnit->getType() === "DATE") {
						$cols .= 'to_char(' . $columnName . ', \'YYYY/MM/DD\') as ' . $columnName . ', ';
					} else {
						$cols .= $columnName . ', ';
					}
				}
			}
		}

        // Setup the location table pks for the join on the location table
        // and for the pk column
        $pkscols = '';
        foreach ($locationTableInfo->getPrimaryKeys() as $primaryKey) {
            $pkscols .= "l." . $primaryKey . "::varchar || '__' || ";
            $cols .= "'" . strtoupper($primaryKey) . "/' || " . $primaryKey . " || '/' || ";
        }
        if ($pkscols != '') {
            $pkscols = substr($pkscols, 0, -11);
        } else {
            throw new \Exception('No pks columns found for the location table.');
        }
        if ($cols != '') {
            $cols = substr($cols, 0, -11) . " as pk ";
        } else {
            throw new \Exception('No columns found for the location table.');
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

		$rawDataTableName = $locationTableInfo->getTableName();
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
			$this->logger->info("getLocationInfo request parameters, session $sessionId, level $level, lon $lon, lat $lat");

			$conn = $this->doctrine->getManager('mapping')->getConnection();
			$stmt = $conn->prepare($req);

			$stmt->execute(array(
				$sessionId,
				$level,
				$lon,
				$lat
			));

			$results = $stmt->fetchAll();

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
	 * Generate the JSON structure corresponding to a list of edit fields.
	 *
	 * @param GenericTableFormat $data
	 *        	the data object to edit
	 * @return array normalize value
	 */
	protected function _generateEditForm($data, User $user = null) {
		$return = new \ArrayObject();
		// / beurk !! stop go view json
		foreach ($data->getIdFields() as $tablefield) {
			$formField = $this->genericService->getTableToFormMapping($tablefield); // get some info about the form
			if (!empty($formField)) {
				$return->append($this->_generateEditFieldGinco($formField, $tablefield));
			}
		}
		foreach ($data->getFields() as $tablefield) {
			$formField = $this->genericService->getTableToFormMapping($tablefield); // get some info about the form
			if (!empty($formField)) {
				$return->append($this->_generateEditFieldGinco($formField, $tablefield));
			}
		}
		$this->logger->debug("----Array copy.");
		$this->logger->debug(print_r($return->getArrayCopy(), true));
		return array(
			'success' => true,
			'data' => $return->getArrayCopy()
		);
	}

	/**
	 *
	 * @param GenericFormField $formEntryField
	 * @param GenericFormField $tableRowField
	 */
	protected function _generateEditFieldGinco($formEntryField, $tableRowField) {
		// Add form_label and form_position
		$field = $this->_generateEditField($formEntryField, $tableRowField);
		$field->formLabel = $formEntryField->getFormLabel();
		$field->formPosition = $formEntryField->getFormPosition();
		return $field;
	}
}