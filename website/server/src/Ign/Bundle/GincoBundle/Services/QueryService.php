<?php
namespace Ign\Bundle\OGAMBundle\Services;

use Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FormField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Unit;
use Ign\Bundle\OGAMBundle\Entity\Mapping\ResultLocation;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericFieldMappingSet;
use Ign\Bundle\OGAMBundle\Entity\Generic\QueryForm;
use Ign\Bundle\OGAMBundle\Repository\GenericRepository;
use Symfony\Component\HttpFoundation\Session\Session;
use Doctrine\ORM\NoResultException;
use Ign\Bundle\OGAMBundle\OGAMBundle;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FormFormat;
use Ign\Bundle\OGAMBundle\Entity\Mapping\LayerService;
use Ign\Bundle\OGAMBundle\Entity\Mapping\Layer;
use Ign\Bundle\OGAMBundle\Repository\Mapping\LayerRepository;
use Ign\Bundle\OGAMBundle\Entity\Generic\BoundingBox;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequest;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Format;
use Ign\Bundle\OGAMBundle\Services\QueryService as BaseService;
use Doctrine\ORM\Query\ResultSetMapping;

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
	 * Copy the locations of the result in a temporary table.
	 * MIGRATED
	 *
	 * @param String $from
	 *        	the FROM part of the SQL Request
	 * @param String $where
	 *        	the WHERE part of the SQL Request
	 * @param \OGAMBundle\Entity\Generic\QueryForm $queryForm
	 *        	the form request object
	 * @param Array $userInfos
	 *        	Few user informations
	 */
	public function prepareResults($from, $where, $queryForm, $userInfos) {
		$this->logger->debug('prepareResults');

		// Get the mappings for the query form fields
		$mappingSet = $queryForm->getFieldMappingSet();

		// Generate the SQL Request
		$from = $this->genericService->generateSQLFromRequest($this->schema, $mappingSet);
		$where = $this->genericService->generateSQLWhereRequest($this->schema, $queryForm->getCriteria(), $mappingSet, $userInfos);

		// Clean previously stored results
		$sessionId = session_id();
		$this->logger->debug('SessionId : ' . $sessionId);
		$this->doctrine->getRepository('GincoBundle:Mapping\Result')->cleanPreviousResults($sessionId);

		// Identify the field carrying the location information
		$tables = $this->genericService->getAllFormats($this->schema, $mappingSet->getFieldMappingArray());
		$locationFields = $this->metadataModel->getRepository(TableField::class)->getGeometryFields($this->schema, array_keys($tables), $this->locale);
		foreach ($locationFields as $locationField) {
			$locationTableInfo = $this->metadataModel->getRepository(TableFormat::class)->getTableFormat($this->schema, $locationField->getFormat()
				->getFormat(), $this->locale);
			// Run the request to store a temporary result table (for the web mapping)
			$this->fillResultTable($from, $where, $sessionId, $locationTableInfo);
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
	 * @param \OGAMBundle\Entity\Metadata\TableFormat $locationTable
	 *        	the location table
	 */
	public function fillResultTable($from, $where, $sessionId, $locationTable) {
		$this->logger->info('fillResultTable');

		if (empty($from) || empty($where)) {
			return;
		}
		$requestRepository = $this->doctrine->getRepository('GincoBundle:Mapping\Request');
		$resultRepository = $this->doctrine->getRepository('GincoBundle:Mapping\Result');
		$genericManager = $this->get('ogam.manager.generic');

		// First, insert a "request" record
		$reqId = $requestRepository->createRequest($sessionId);

		// Then copy references in the "results" table

		// The name of the table holding the geometric information
		$tableFormat = $locationTable->format;

		// Map the varying two keys in results to the keys in the raw_data table
		$keys = $genericManager->getRawDataTablePrimaryKeys($locationTable);

		$permissions = $this->getVisuPermissions();
		if ($permissions['logged']) {
			$defaultHidingLevel = 0;
		} else {
			$defaultHidingLevel = 1;
		}
		// Insert the results
		$resultRepository->insert($reqId, $tableFormat, $keys, $defaultHidingLevel, $from, $where);

		// Get back the results and for each, get and fill hiding level
		$tableValues = $this->getHidingLevels($keys, $locationTable, $this->getVisuPermissions(), $from, $where, $reqId);
		$resultRepository->bulkUpdate($tableValues, $locationTable->format, $sessionId);

		// Remove any values that can be obtained through criterias more precise than the hiding level
		$maxPrecisionLevel = $this->getMaxPrecisionLevel($this->getQueryCriterias());
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
		$genericManager = $this->get('ogam.manager.generic');

		$results = $genericManager->getHidingLevelParameters($geometryTable, $ogamIdColumn, $providerIdColumn, $from, $where);

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

		foreach ($criterias as $criteria) {
			$fieldLevel = self::$fieldsLevels[$criteria->data];
			if (isset($fieldLevel)) {
				if ($fieldLevel < $maxPrecisionLevel) {
					$maxPrecisionLevel = $fieldLevel;
				}
			}
		}

		$this->logger->debug("maxPrecisionLevel : " . $maxPrecisionLevel);
		return $maxPrecisionLevel;
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
		if (isset(self::$fieldLevels[$columnName])) {
			$level = self::$fieldLevels[$columnName];
			if ($level < $hidingLevel) {
				return true;
			}
		}
	}

	/**
	 * Gets the permissions linked to visualization : sensitive, private and logged.
	 * If the user is not logged in, all observations are hidden below level of commune.
	 * MIGRATED
	 *
	 * @return array of string|boolean $permissions
	 */
	public function getVisuPermissions() {
		$user = $this->getUser();
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
	public function buildRequest(QueryForm $queryForm, $userInfos, $maxPrecisionLevel, $requestId, Session $session) {
		$this->logger->debug('buildRequest custom');

		// Get the mappings for the query form fields
		$mappingSet = $queryForm->getFieldMappingSet();

		// Identify the field carrying the location information
		$tables = $this->genericService->getAllFormats($this->schema, $mappingSet);
		$tableFieldRepository = $this->metadataModel->getRepository('OGAMBundle:Metadata\TableField');
		$tableFormatRepository = $this->metadataModel->getRepository('OGAMBundle:Metadata\TableFormat');
		$locationField = $tableFieldRepository->getGeometryField($this->schema, array_keys($tables), $this->locale);
		$locationTableInfo = $tableFormatRepository->getTableFormat($this->schema, $locationField->format);
		$geometryTablePKeyIdWithTable = $locationTableInfo->format . "." . $locationTableInfo->primaryKeys[0];
		$geometryTablePKeyProviderIdWithTable = $locationTableInfo->format . "." . $locationTableInfo->primaryKeys[1];

		// The not customised $from clause contains table_tree joins. Here we add joins with submission table, or submission and results tables.
		$fromJoinSubmission = $this->genericService->generateGincoSQLFromRequest($this->schema, $mappingSet, self::$submissionJoin);
		// Results table contains geometry table id. => table and keys must be thoses of the geometry table
		$fromJoinResults = $this->genericService->generateGincoSQLFromRequest($this->schema, $mappingSet, self::$resultJoins, $geometryTablePKeyIdWithTable, $geometryTablePKeyProviderIdWithTable);

		// Generate the SQL Request
		$select = $this->genericService->generateGincoSQLSelectRequest($this->schema, $queryForm->getColumns(), $mappingSet, $userInfos);
		$where = $this->genericService->generateGincoSQLWhereRequest($this->schema, $queryForm->getCriteria(), $mappingSet, $userInfos);
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
	}

	/**
	 * Return the total count of query result
	 *
	 * @param string $from
	 *        	The FROM part of the query
	 * @param string $where
	 *        	The WHERE part of the query
	 * @throws NoResultException
	 * @return integer The total count
	 */
	private function _getQueryResultsCount($from, $where) {
		$conn = $this->doctrine->getManager()->getConnection();
		$sql = "SELECT COUNT(*) as count " . $from . $where;
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchColumn();
		if ($result !== FALSE && $result !== "") {
			return $result;
		} else {
			throw new NoResultException('No result found for the request : ' . $sql);
		}
	}

	/**
	 * Get the form fields corresponding to the columns.
	 *
	 * @param QueryForm $queryForm
	 *        	the request form
	 * @return [FormField] The form fields corresponding to the columns
	 */
	public function getColumns($queryForm) {
		$formFields = [];
		foreach ($queryForm->getColumns() as $formField) {
			// Get the full description of the form field
			$formFields[] = $this->getFormField($formField->getFormat(), $formField->getData());
		}
		return $formFields;
	}

	/**
	 * Get a form field.
	 *
	 * @param String $format
	 *        	the format
	 * @param String $data
	 *        	the data
	 * @return FormField The form fields corresponding to the columns
	 */
	public function getFormField($format, $data) {
		return $this->metadataModel->getRepository(FormField::class)->getFormField($format, $data, $this->locale);
	}

	/**
	 * Set the fields mappings for the provided schema into the query form.
	 *
	 * @param string $schema
	 * @param \OGAMBundle\Entity\Generic\QueryForm $queryForm
	 *        	the list of query form fields
	 * @return the updated form
	 */
	public function setQueryFormFieldsMappings($queryForm) {
		$mappingSet = $this->genericService->getFieldsFormToTableMappings($this->schema, $queryForm->getCriteria());
		$mappingSet->addFieldMappingSet($this->genericService->getFieldsFormToTableMappings($this->schema, $queryForm->getColumns()));
		$queryForm->setFieldMappingSet($mappingSet);

		return $queryForm;
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
	 * @param String $idRequest
	 *        	the id of the request (allows to get results from results table)
	 * @param Session $session
	 *        	the current session
	 * @param Boolean $emptyHidingValue
	 *        	if true, we leave the hided values empty (and not replaced with a string), and we keep their type
	 * @param Array $userInfos
	 *        	Few user informations
	 * @return JSON
	 */
	public function getResultRows($start, $length, $sort, $sortDir, $idRequest, $session, $userInfos, $emptyHidingValue = false) {
		$this->logger->debug('getResultRows');

		$projection = $this->configuration->getConfig('srs_visualisation', 3857);
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
			$formField = new FormField();
			$formField->setFormat($split[0]);
			$formField->setData($split[1]);
			$tableField = $this->metadataModel->getRepository(TableField::class)->getFormToTableMapping($this->schema, $formField);
			$orderKey = $tableField->getFormat() . "." . $tableField->getData();
			$orderKeyType = $tableField->getType();
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

		// Retrieve number of total results
		$countRequest = "SELECT count(*) $fromJoins WHERE ($pKey) IN ($subquery $order) $andWhere";
		$countRequestResult = $this->genericModel->executeRequest($countRequest);
		$countResult = $countRequestResult[0]['count'];
		$session->set('query_SQLCount', $countResult);

		// Retrieve the session-stored info
		$columnsDstFields = $queryForm->getColumnsDstFields();

		$rows = array();
		foreach ($result as $line) {
			$row = array();
			$observationId = '';
			foreach ($line as $key => $value) {
				if (stripos($key, 'loc_pk') !== false) {
					$observationId = $value;
				}
			}

			foreach ($resultColumns as $tableField) {
				$key = strtolower($tableField->getName());
				$value = $line[$key];
				$hidingLevel = $line['hiding_level'];
				$shouldValueBeHidden = $this->genericModel->shouldValueBeHidden($tableField->columnName, $hidingLevel);
				$type = $tableField->getData()>getUnit()->getType();
				// Manage code traduction
				if ($type === "CODE" && $value != "") {
					if ($shouldValueBeHidden) {
						$value = ($emptyHidingValue) ? "" : $ĥidingValue;
					}
					$row[] = strval($this->genericService->getValueLabel($tableField, $value));
				} else if ($type === "ARRAY" && $value != "") {
					if ($shouldValueBeHidden) {
						$row[] = ($emptyHidingValue) ? array() : $ĥidingValue;
					} else {
						// Split the array items
						$arrayValues = explode(",", preg_replace("@[{-}]@", "", $value));
						foreach ($arrayValues as $index => $value) {
							if ($shouldValueBeHidden) {
								$arrayValues[$index] = ($emptyHidingValue) ? "" : $ĥidingValue;
							}
							$arrayValues[$index] = $this->genericService->getValueLabel($tableField, $arrayValues[$index]);
						}
						$row[] = $arrayValues;
					}
				} else {
					if ($shouldValueBeHidden) {
						$value = ($emptyHidingValue) ? "" : $ĥidingValue;
					}
					$row[] = $value;
				}
			}

			// Add the line id
			$row[] = $line['id'];

			// Right management : add the provider id of the data
			if (!$userInfos['DATA_QUERY_OTHER_PROVIDER']) {
				$resultRow[] = $line['_provider_id'];
			}
			$rows[] = $row;
		}
		return $resultRows;
	}

	/**
	 * Return the query result(s)
	 *
	 * @param string $sql
	 *        	The sql of the query
	 * @return array The result(s)
	 */
	public function getQueryResults($sql) {
		$conn = $this->doctrine->getManager()->getConnection();
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll();
		return $result;
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
		$mapRepository = $this->get('ginco.repository.mapping.map');

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
			$bbox = $mapRepository->getPreciseBbox($projection, $resultLayer, $sessionId);
		} else {
			$restrainedBbox = true;
			if (!in_array($regionCode, array(
				'FR',
				'DAILYBUILD'
			))) {
				$bbox = $mapRepository->getRegionBbox($projection, $regionCode);
			} else {
				$this->logger->info("Computing metropolitan country bbox...");
				$bbox = $mapRepository->getMetropolitanBbox($projection);
			}
		}

		return array(
			'bbox' => $bbox,
			'restrained' => $restrainedBbox
		);
	}

	/**
	 * ********************* EDITION ************************************************************************************
	 */

	/**
	 * Get the form fields for a data to edit.
	 *
	 * @param GenericTableFormat $data
	 *        	the data object to edit
	 * @return array Serializable.
	 */
	public function getEditForm($data) {
		$this->logger->debug('getEditForm');

		return $this->_generateEditForm($data);
	}

	/**
	 * Generate the JSON structure corresponding to a list of edit fields.
	 *
	 * @param GenericTableFormat $data
	 *        	the data object to edit
	 * @return array normalize value
	 */
	private function _generateEditForm($data) {
		$return = new \ArrayObject();
		// / beurk !! stop go view json
		foreach ($data->getIdFields() as $tablefield) {
			$formField = $this->genericService->getTableToFormMapping($tablefield); // get some info about the form
			if (!empty($formField)) {
				$return->append($this->_generateEditField($formField, $tablefield));
			}
		}
		foreach ($data->getFields() as $tablefield) {
			$formField = $this->genericService->getTableToFormMapping($tablefield); // get some info about the form
			if (!empty($formField)) {
				$return->append($this->_generateEditField($formField, $tablefield));
			}
		}
		return array(
			'success' => true,
			'data' => $return->getArrayCopy()
		);
	}

	/**
	 * Convert a java/javascript-style date format to a PHP date format.
	 *
	 * @param String $format
	 *        	the format in java style
	 * @return String the format in PHP style
	 */
	private function _convertDateFormat($format) {
		$format = str_replace("yyyy", "Y", $format);
		$format = str_replace("yy", "y", $format);
		$format = str_replace("MMMMM", "F", $format);
		$format = str_replace("MMMM", "F", $format);
		$format = str_replace("MMM", "M", $format);
		$format = str_replace("MM", "m", $format);
		$format = str_replace("EEEEEE", "l", $format);
		$format = str_replace("EEEEE", "l", $format);
		$format = str_replace("EEEE", "l", $format);
		$format = str_replace("EEE", "D", $format);
		$format = str_replace("dd", "d", $format);
		$format = str_replace("HH", "H", $format);
		$format = str_replace("hh", "h", $format);
		$format = str_replace("mm", "i", $format);
		$format = str_replace("ss", "s", $format);
		$format = str_replace("A", "a", $format);
		$format = str_replace("S", "u", $format);

		return $format;
	}

	/**
	 *
	 * @param GenericField $formEntryField
	 * @param GenericField $tableRowField
	 */
	private function _generateEditField($formEntryField, $tableRowField) {
		$tableField = $tableRowField->getMetadata();
		$formField = $formEntryField->getMetadata();

		$field = new \stdClass();
		$field->inputType = $formField->getInputType();
		$field->decimals = $formField->getDecimals();
		$field->defaultValue = $formField->getDefaultValue();

		$field->unit = $formField->getData()
			->getUnit()
			->getUnit();
		$field->type = $formField->getData()
			->getUnit()
			->getType();
		$field->subtype = $formField->getData()
			->getUnit()
			->getSubType();

		$field->name = $tableRowField->getId();
		$field->label = $tableField->getLabel();

		$field->isPK = in_array($tableField->getData()->getData(), $tableField->getFormat()->getPrimaryKeys(), true) ? '1' : '0';
		if ($tableField->getData()->getUnit() === $formField->getData()->getUnit()) {
			$this->logger->info('query_service :: table field and form field has not the same unit ?!');
		}

		$field->value = $tableRowField->getValue();
		$field->valueLabel = $tableRowField->getValueLabel();
		$field->editable = $tableField->getIsEditable() ? '1' : '0';
		$field->insertable = $tableField->getIsInsertable() ? '1' : '0';
		$field->required = $field->isPK ? !($tableField->getIsCalculated()) : $tableField->getIsMandatory();
		$field->data = $tableField->getData()->getData(); // The name of the data is the table one
		$field->format = $tableField->getFormat()->getFormat();

		if ($field->value === null) {
			if ($field->defaultValue === '%LOGIN%') {
				$user = $this->user;
				$field->value = $user->login;
			} else if ($field->defaultValue === '%TODAY%') {

				// Set the current date
				if ($formField->mask !== null) {
					$field->value = date($this->_convertDateFormat($formField->mask));
				} else {
					$field->value = date($this->_convertDateFormat('yyyy-MM-dd'));
				}
			} else {
				$field->value = $field->defaultValue;
			}
		}

		// For the RANGE field, get the min and max values
		if ($field->type === "NUMERIC" && $field->subtype === "RANGE") {
			$range = $tableField->getData()
				->getUnit()
				->getRange();
			$field->params = [
				"min" => $range->getMin(),
				"max" => $range->getMax()
			];
		}

		if ($field->inputType === 'RADIO' && $field->type === 'CODE') {

			$opts = $this->metadataModel->getRepository(Unit::class)->getModes($formField->getUnit());

			$field->options = array_column($opts, 'label', 'code');
		}

		return $field;
	}

	/**
	 * ********************* DETAILS ************************************************************************************
	 */

	/**
	 * Get the details associed with a result line (clic on the "detail button").
	 * MIGRATION IN PROGESS (done is call to getDatum).
	 *
	 * @param String $id
	 *        	The identifier of the line
	 * @param String $detailsLayers
	 *        	The names of the layers used to display the images in the detail panel.
	 * @param String $datasetId
	 *        	The identifier of the dataset (to filter data)
	 * @param boolean $withChildren
	 *        	If true, get the information about the children of the object
	 * @param Array $userInfos
	 *        	Few user informations
	 * @return array Array that represents the details of the result line.
	 */
	public function getDetailsData($id, $detailsLayers, $datasetId = null, $withChildren = false, $userInfos) {
		$this->logger->debug('getDetailsData : ' . $id);

		// Transform the identifier in an array
		$keyMap = $this->_decodeId($id);

		// Prepare a GenericTableFormat to be filled
		$gTableFormat = $this->genericService->buildGenericTableFormat($keyMap['SCHEMA'], $keyMap['FORMAT'], null);

		// Complete the primary key info
		foreach ($gTableFormat->getIdFields() as $idField) {
			if (!empty($keyMap[$idField->getData()])) {
				$idField->setValue($keyMap[$idField->getData()]);
			}
		}

		// Get the detailled data
		$requestId = $this->doctrine->getRepository('GincoBundle:Mapping\Request')->getLastRequestIdFromSession(session_id());
		$this->genericModel->getDatum($gTableFormat, $requestId);

		// The data ancestors
		$ancestors = $this->genericModel->getAncestors($gTableFormat);
		$ancestors = array_reverse($ancestors);

		// Searchs the geometric field and table
		$bb = null;
		$bb2 = null;
		$locationTable = null;
		foreach ($gTableFormat->all() as $field) {
			if ($field->getMetadata()
				->getData()
				->getUnit()
				->getType() === 'GEOM' && !$field->isEmpty()) {
				// define a bbox around the location
				$bb = $field->getValueBoundingBox()->getSquareBoundingBox(10000);
				// Prepare an overview bbox
				$bb2 = $field->getValueBoundingBox()->getSquareBoundingBox(50000);
				$locationTable = $gTableFormat;
				break;
			}
		}
		if ($bb === null) {
			foreach ($ancestors as $ancestor) {
				foreach ($ancestor->getFields() as $field) {
					if ($field->getMetadata()
						->getData()
						->getUnit()
						->getType() === 'GEOM' && !$field->isEmpty()) {
						// define a bbox around the location
						$bb = $field->getValueBoundingBox()->getSquareBoundingBox(10000);
						// Prepare an overview bbox
						$bb2 = $field->getValueBoundingBox()->getSquareBoundingBox(200000);
						$locationTable = $ancestor;
						break;
					}
				}
			}
		}

		// Defines the mapsserver parameters.
		$mapservParams = '';
		foreach ($locationTable->getIdFields() as $idField) {
			$mapservParams .= '&' . $idField->getMetadata()->getColumnName() . '=' . $idField->getValue();
		}

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
		if (!empty($detailsLayers) && $bb !== null) {
			if ($detailsLayers[0] !== '') {
				$url = array();
				$url = explode(";", ($this->getDetailsMapUrl(empty($detailsLayers) ? '' : $detailsLayers[0], $bb, $mapservParams)));

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

			if ($detailsLayers[1] !== '') {
				$url = array();
				$url = explode(";", ($this->getDetailsMapUrl(empty($detailsLayers) ? '' : $detailsLayers[1], $bb2, $mapservParams)));
				$dataDetails['maps2'] = array(
					'title' => 'overview'
				);

				// complete the array with the urls of maps2
				$dataDetails['maps2']['urls'][] = array();
				$countUrls = count($url);
				for ($i = 0; $i < $countUrls; $i ++) {
					$dataDetails['maps2']['urls'][$i]['url'] = $url[$i];
				}
			}
		}

		// Add the children
		if ($withChildren) {

			// Prepare a data object to be filled
			$data2 = $this->genericService->buildGenericTableFormat($keyMap["SCHEMA"], $keyMap["FORMAT"], null);

			// Complete the primary key
			foreach ($data2->getIdFields() as $idField) {
				if (!empty($keyMap[$idField->getData()])) {
					$idField->setValue($keyMap[$idField->getData()]);
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
	 * Decode the identifier
	 *
	 * @param String $id
	 * @return Array the decoded id
	 */
	private function _decodeId($id) {
		// Transform the identifier in an array
		$keyMap = array();
		$idElems = explode("/", $id);
		$i = 0;
		$count = count($idElems);
		while ($i < $count) {
			$keyMap[$idElems[$i]] = $idElems[$i + 1];
			$i += 2;
		}
		return $keyMap;
	}

	/**
	 * Generate an URL for the details map.
	 *
	 * @param String $detailsLayers
	 *        	List of layers to display
	 * @param BoundingBox $bb
	 *        	bounding box
	 * @param String $mapservParams
	 *        	Parameters for mapserver
	 * @return String
	 */
	protected function getDetailsMapUrl($detailsLayers, BoundingBox $bb, $mapservParams) {

		// Configure the projection systems
		$visualisationSRS = $this->configuration->getConfig('srs_visualisation', '3857');
		$baseUrls = '';

		// Get the base urls for the services
		$detailServices = $this->doctrine->getRepository(LayerService::class)->getDetailServices();

		// Get the server name for the layers
		$layerNames = explode(",", $detailsLayers);
		// $serviceLayerNames = "";
		$versionWMS = "";

		foreach ($layerNames as $layerName) {
			$layer = $this->doctrine->getRepository(Layer::class)->find($layerName);
			$serviceLayerName = $layer->getServiceLayerName();

			// Get the base Url for detail service
			if ($layer->getDetailService() !== '') {
				$detailServiceName = $layer->getDetailService()->getName();
			}

			foreach ($detailServices as $detailService) {

				if ($detailService->getName() === $detailServiceName) {

					$params = json_decode($detailService->getConfig())->params;
					$service = $params->SERVICE;
					$baseUrl = json_decode($detailService->getConfig())->urls[0];

					if ($service === 'WMS') {

						$baseUrls .= $baseUrl . 'LAYERS=' . $serviceLayerName;
						$baseUrls .= '&TRANSPARENT=true';
						$baseUrls .= '&FORMAT=image%2Fpng';
						$baseUrls .= '&EXCEPTIONS=BLANK';
						$baseUrls .= '&SERVICE=' . $params->SERVICE;
						$baseUrls .= '&VERSION=' . $params->VERSION;
						$baseUrls .= '&REQUEST=' . $params->REQUEST;
						$baseUrls .= '&STYLES=';
						$baseUrls .= '&BBOX=' . $bb->toString();
						$baseUrls .= '&WIDTH=300';
						$baseUrls .= '&HEIGHT=300';
						$baseUrls .= '&map.scalebar=STATUS+embed';
						$baseUrls .= $mapservParams;
						$versionWMS = $params->VERSION;
						if (substr_compare($versionWMS, '1.3', 0, 3) === 0) {
							$baseUrls .= '&CRS=EPSG%3A' . $visualisationSRS;
						} elseif (substr_compare($versionWMS, '1.0', 0, 3) === 0 || substr_compare($versionWMS, '1.1', 0, 3) === 0) {
							$baseUrls .= '&SRS=EPSG%3A' . $visualisationSRS;
						} else {
							$this->logger->err("WMS version unsupported, please change the WMS version for the '" . $layerName . "' layer.");
						}
						$baseUrls .= ';';
					} elseif ($service === 'WMTS') {

						$this->logger->err("WMTS service unsupported, please change the detail service for the '" . $layerName . "' layer.");

						// TODO : Gets the tileMatrix, tileCol, tileRow corresponding to the bb
						/*
						 * $baseUrls .= $baseUrl . 'LAYER=' . $serviceLayerName;
						 * $baseUrls .= '&SERVICE='.json_decode($detailService->serviceConfig)->{'params'}->{'SERVICE'};
						 * $baseUrls .= '&VERSION='.json_decode($detailService->serviceConfig)->{'params'}->{'VERSION'};
						 * $baseUrls .= '&REQUEST='.json_decode($detailService->serviceConfig)->{'params'}->{'REQUEST'};
						 * $baseUrls .= '&STYLE='.json_decode($detailService->serviceConfig)->{'params'}->{'STYLE'};
						 * $baseUrls .= '&FORMAT='.json_decode($detailService->serviceConfig)->{'params'}->{'FORMAT'};
						 * $baseUrls .= '&TILEMATRIXSET='.json_decode($detailService->serviceConfig)->{'params'}->{'TILEMATRIXSET'};
						 * $baseUrls .= '&TILEMATRIX='.$tileMatrix;
						 * $baseUrls .= '&TILECOL='.$tileCol;
						 * $baseUrls .= '&TILEROW='.$tileRow;
						 * $baseUrls .=';';
						 */
					} else {
						$this->logger->err("'" . $service . "' service unsupported, please change the detail service for the '" . $layerName . "' layer.");
					}
				}
			}
		}
		if ($baseUrls !== "") {
			$baseUrls = substr($baseUrls, 0, -1); // remove last semicolon
		}

		return $baseUrls;
	}
}