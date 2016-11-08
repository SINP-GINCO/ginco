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
include_once APPLICATION_PATH . '/services/QueryService.php';
include_once CUSTOM_APPLICATION_PATH . '/models/Generic/CustomGeneric.php';

/**
 * The Query Service customized for Ginco.
 *
 * This service handles the queries used to feed the query interface with ajax requests.
 *
 * @package Application_Service
 */
class Custom_Application_Service_QueryService extends Application_Service_QueryService {

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

	public static function getFieldsLevels() {
		return self::$fieldLevels;
	}

	/**
	 * Get a page of query result data.
	 * This method is customized.
	 * It adds the maximum precision level factor in the methodology of retrieving results.
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
	 * @return JSON
	 */
	public function getResultRowsCustom($start, $length, $sort, $sortDir, $idRequest, $websiteSession) {
		$this->logger->debug('getResultRows custom');
		
		$configuration = Zend_Registry::get("configuration");
		$projection = $configuration->getConfig('srs_visualisation', 3857);
		$ĥidingValue = $configuration->getConfig('hiding_value');
		
		try {
			
			$select = $websiteSession->SQLSelect;
			$pKey = $websiteSession->SQLPkey;
			$fromJoins = $websiteSession->SQLFromJoinResults;
			$from = $websiteSession->SQLFrom;
			$where = $websiteSession->SQLWhere;
			$andWhere = $websiteSession->SQLAndWhere;
			
			$order = "";
			$hidingLevelKey = ", hiding_level, ";
			if (!empty($sort)) {
				$orderKey = "";
				$orderKeyType = "";
				// $sort contains the form format and field
				$split = explode("__", $sort);
				$formField = new Application_Object_Metadata_FormField();
				$formField->format = $split[0];
				$formField->data = $split[1];
				$tableField = $this->genericService->getFormToTableMapping($this->schema, $formField);
				$orderKey = $tableField->format . "." . $tableField->data;
				$orderKeyType = $tableField->type;
				$order .= " ORDER BY " . $orderKey . " " . $sortDir;
				// Customization of select for specific data types
				if ($orderKeyType == 'GEOM' || $orderKeyType == 'DATE') {
					$select .= ", " . $orderKey;
				}
				$nullSubstitute = $this->getPostgresValueFromOgamType($orderKeyType);
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
			
			$this->logger->debug('select = ' . $select);
			$this->logger->debug('pkey = ' . $pKey);
			$this->logger->debug('from = ' . $from);
			$this->logger->debug('where = ' . $where);
			
			// // Build complete query
			if (empty($orderKey)) {
				$query = "$select $hidingLevelKey $pKey $fromJoins WHERE ($pKey) IN ($subquery $order $filter) $andWhere";
			} else {
				$query = "$select, $orderkeyCoalesce $hidingLevelKey $pKey $fromJoins";
				$query .= " WHERE ($pKey, $orderkeyCoalesce) IN ($subquery ORDER BY coalesce $sortDir $filter)";
				$query .= " $andWhere ORDER BY $orderkeyCoalesce $sortDir";
			}
			// Execute the request
			$result = $this->genericModel->executeRequest($query);
			
			// Retrive the session-stored info
			$resultColumns = $websiteSession->resultColumns;
			$countResult = $websiteSession->count;
			
			// Result rows (one row = an non-indexed array of values)
			$rows = array();
			foreach ($result as $line) {
				$row = array();
				$observationId = '';
				foreach ($line as $key => $value) {
					if (stripos($key, 'ogam_id') !== false) {
						$observationId = $value;
					}
				}
				
				foreach ($resultColumns as $tableField) {
					$key = strtolower($tableField->getName());
					$value = $line[$key];
					$hidingLevel = $line['hiding_level'];
					$shouldValueBeHidden = $this->shouldValueBeHidden($tableField->columnName, $hidingLevel);
					// Manage code traduction
					if ($tableField->type === "CODE" && $value != "") {
						if ($shouldValueBeHidden) {
							$value = $ĥidingValue;
						}
						$row[] = strval($this->genericService->getValueLabel($tableField, $value));
					} else if ($tableField->type === "ARRAY" && $value != "") {
						if ($shouldValueBeHidden) {
							$row[] = $ĥidingValue;
						} else {
							// Split the array items
							$arrayValues = explode(",", preg_replace("@[{-}]@", "", $value));
							foreach ($arrayValues as $index => $value) {
								if ($shouldValueBeHidden) {
									$arrayValues[$index] = $ĥidingValue;
								}
								$arrayValues[$index] = $this->genericService->getValueLabel($tableField, $arrayValues[$index]);
							}
							$row[] = $arrayValues;
						}
					} else {
						if ($shouldValueBeHidden) {
							$value = $ĥidingValue;
						}
						$row[] = $value;
					}
				}
				
				// Add the line id
				$row[] = $line['id'];
				// And the plot location in WKT: NO !!! We replace it with
				// the bounding box of the "more precise geometry visible by user"
				// $row[] = $line['location_centroid'];
				
				// Add the bounding box of the more precise geometry visible by user (and non-empty geometry)
				// (used by "See on the map" button).
				
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
								WHERE res.id_request = $idRequest
								AND res.id_provider = '" . $line['provider_id'] . "'
								AND res.id_observation = '$observationId'";
					$bbResult = $this->genericModel->executeRequest($bbQuery);
					if (count($bbResult) && !empty($bbResult[0]['wkt'])) {
						$bbox = $bbResult[0]['wkt'];
						break;
					}
				}
				$row[] = $bbox;
				
				// Right management : add the provider id of the data
				$userSession = new Zend_Session_Namespace('user');
				if (!$userSession->user->isAllowed('DATA_EDITION_OTHER_PROVIDER')) {
					$row[] = $line['provider_id'];
				}
				
				$rows[] = $row;
			}
		} catch (Exception $e) {
			$this->logger->err('Error while getting result : ' . $e);
			$json = array(
				"success" => false,
				"errorMessage" => $e->getMessage()
			);
			return json_encode($json);
		}
		
		// Send the result as a JSON String
		$json = array(
			"success" => true,
			"total" => $countResult,
			"rows" => $rows
		);
		return json_encode($json);
	}

	/**
	 * Get the description of the columns of the result of the query.
	 *
	 * @param String $datasetId
	 *        	the dataset identifier
	 * @param FormQuery $formQuery
	 *        	the form request object
	 * @param Integer $maxPrecisionLevel
	 *        	the maximum level of precision asked by the user
	 * @param Integer $requestId
	 *        	the id of the request
	 * @param Zend_Session_Namespace $websiteSession
	 *        	the websiteSession (storing SQL requests parameters)
	 * @return JSON
	 */
	public function getResultColumnsCustom($datasetId, $formQuery, $maxPrecisionLevel, $requestId, $websiteSession) {
		$this->logger->debug('getResultColumns custom');
		
		$json = "";
		// Transform the form request object into a table data object
		$queryObject = $this->genericService->getFormQueryToTableData($this->schema, $formQuery);
		
		if (count($formQuery->results) === 0) {
			$json = '{"success": false, "errorMessage": "At least one result column should be selected"}';
		} else {
			
			$this->customGenericService = new Custom_Application_Service_GenericService();
			
			$select = $websiteSession->SQLSelect;
			$pKey = $websiteSession->SQLPkey;
			$from = $websiteSession->SQLFromJoinResults;
			$where = $websiteSession->SQLWhere;
			// Customize select
			$select .= ', ' . $pKey . ", hiding_level";
			$rawDataTableName = str_replace(',', '', explode(' ', $from)[3]);
			
			// Add where clause for filtering on hiding_level
			$andWhere = " AND table_format = '" . $rawDataTableName . "'";
			$andWhere .= " AND id_request = " . $requestId;
			$andWhere .= " AND hiding_level <= " . $maxPrecisionLevel;
			
			// Customize from
			$from .= ', mapping.results ';
			
			$this->logger->debug('$select : ' . $select);
			$this->logger->debug('$from : ' . $from);
			$this->logger->debug('$where : ' . $where);
			
			$websiteSession->datasetId = $datasetId;
			$websiteSession->SQLAndWhere = $andWhere;
			
			// Send the result as a JSON String
			$json = '{"success":true,';
			
			// Metadata
			$json .= '"root":[';
			// Get the titles of the columns
			foreach ($formQuery->results as $formField) {
				
				// Get the full description of the form field
				$formField = $this->metadataModel->getFormField($formField->format, $formField->data);
				
				// Export the JSON
				$json .= '{' . $formField->toJSON() . ', "hidden":false},';
			}
			// Add the identifier of the line
			$json .= '{"name":"id","label":"Identifier of the line","inputType":"TEXT","definition":"The plot identifier", "hidden":true}';
			// Add the plot location in WKT
			$json .= ',{"name":"location_centroid","label":"Location centroid","inputType":"TEXT","definition":"The plot location", "hidden":true}';
			
			// Right management : add the provider id of the data
			$userSession = new Zend_Session_Namespace('user');
			if (!$userSession->user->isAllowed('DATA_EDITION_OTHER_PROVIDER')) {
				$json .= ',{"name":"_provider_id","label":"Provider","inputType":"TEXT","definition":"The provider", "hidden":true}';
			}
			$json .= ']}';
		}
		return $json;
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
			$criteriaName = $criteria->data;
			if (isset(Custom_Application_Service_QueryService::getFieldsLevels()[$criteriaName])) {
				$level = Custom_Application_Service_QueryService::getFieldsLevels()[$criteriaName];
				if ($level < $maxPrecisionLevel) {
					$maxPrecisionLevel = $level;
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
		if (isset($this->getFieldsLevels()[$columnName])) {
			$level = Custom_Application_Service_QueryService::getFieldsLevels()[$columnName];
			if ($level < $hidingLevel) {
				return true;
			}
		}
	}

	/**
	 * Get the details associed with a result line (clic on the "detail button").
	 *
	 * @param String $id
	 *        	The identifier of the line
	 * @param String $detailsLayers
	 *        	The names of the layers used to display the images in the detail panel.
	 * @param String $datasetId
	 *        	The identifier of the dataset (to filter data)
	 * @return JSON representing the detail of the result line.
	 */
	public function getDetailsCustom($id, $detailsLayers, $datasetId = null, $bbox = '') {
		$this->logger->debug('getDetails : ' . $id);
		// add a success flag (default true) and encode
		return json_encode(array_merge(array(
			'success' => true
		), $this->getDetailsDataCustom($id, $detailsLayers, $datasetId, $bbox, true)));
	}

	/**
	 * Get the details associed with a result line (clic on the "detail button").
	 *
	 * @param String $id
	 *        	The identifier of the line
	 * @param String $detailsLayers
	 *        	The names of the layers used to display the images in the detail panel.
	 * @param String $datasetId
	 *        	The identifier of the dataset (to filter data)
	 * @param boolean $withChildren
	 *        	If true, get the information about the children of the object
	 * @return array Array that represents the details of the result line.
	 */
	public function getDetailsDataCustom($id, $detailsLayers, $datasetId, $bbox = '', $withChildren = false) {
		$this->logger->debug('getDetailsData : ' . $id);
		
		// Transform the identifier in an array
		$keyMap = $this->_decodeId($id);
		
		// The test in the following block code (empty[$keyMap[$infoField->data]])
		// fails if $infoField->data and the keys of $keyMap don't have the same case...
		// So we put everything in uppercase
		$keysKeyMap = array_map("strtoupper", array_keys($keyMap));
		$valuesKeyMap = array_values($keyMap);
		$keyMap = array_combine($keysKeyMap, $valuesKeyMap);
		
		// Prepare a data object to be filled
		$data = $this->genericService->buildDataObject($keyMap['SCHEMA'], $keyMap['FORMAT'], null);
		
		// Complete the primary key info with the session values
		foreach ($data->infoFields as $infoField) {
			if (!empty($keyMap[strtoupper($infoField->data)])) {
				$infoField->value = $keyMap[strtoupper($infoField->data)];
			}
		}
		
		// Get the detailed data
		$customGenericModel = new Custom_Application_Model_Generic_Generic();
		$customGenericModel->getDatum($data);
		
		// The data ancestors
		$ancestors = $customGenericModel->getAncestors($data);
		$ancestors = array_reverse($ancestors);
		
		// #802 : desactivate card details map
		// Look for a geometry object in order to calculate a bounding box
		// Look for the plot location
		// $bb = Application_Object_Mapping_BoundingBox::createBoundingBoxFromWKT($bbox, 5000, 20000);
		$bb = null;
		$locationTable = $data;
		
		// Defines the mapsserver parameters.
		$mapservParams = '';
		foreach ($locationTable->getInfoFields() as $primaryKey) {
			$mapservParams .= '&' . $primaryKey->columnName . '=' . $primaryKey->value;
		}
		
		// Title of the detail message
		$dataDetails = array();
		$dataDetails['formats'] = array();
		
		// List all the formats, starting with the ancestors
		foreach ($ancestors as $ancestor) {
			$ancestorJSON = $this->genericService->datumToDetailJSON($ancestor, $datasetId);
			if ($ancestorJSON !== '') {
				$dataDetails['formats'][] = json_decode($ancestorJSON, true);
			}
		}
		
		// Add the current data
		$dataJSON = $this->genericService->datumToDetailJSON($data, $datasetId);
		if ($dataJSON !== '') {
			$dataDetails['formats'][] = json_decode($dataJSON, true);
		}
		
		// Defines the panel title
		$titlePK = '';
		foreach ($data->infoFields as $infoField) {
			if ($titlePK !== '') {
				$titlePK .= '_';
			}
			$titlePK .= $infoField->value;
		}
		$dataInfo = end($dataDetails['formats']);
		$dataDetails['title'] = $dataInfo['title'] . ' (' . $titlePK . ')';
		
		// Add the localisation maps
		if (!empty($detailsLayers)) {
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
		}
		
		// Add the children
		if ($withChildren) {
			
			// Prepare a data object to be filled
			$data2 = $this->genericService->buildDataObject($keyMap["SCHEMA"], $keyMap["FORMAT"], null);
			
			// Complete the primary key
			foreach ($data2->infoFields as $infoField) {
				if (!empty($keyMap[$infoField->data])) {
					$infoField->value = $keyMap[$infoField->data];
				}
			}
			// Get children too
			$websiteSession = new Zend_Session_Namespace('website');
			$children = $customGenericModel->getChildren($data2, $websiteSession->datasetId);
			
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
	 * Copy the locations of the result in a temporary table.
	 *
	 * @param FormQuery $formQuery
	 *        	the form request object
	 */
	public function prepareResultLocationsCustom($formQuery) {
		$this->logger->debug('prepareResultLocationsCustom');
		
		$this->customGenericService = new Custom_Application_Service_GenericService($this->schema);
		
		// Transform the form request object into a table data object
		$queryObject = $this->customGenericService->getFormQueryToTableData($this->schema, $formQuery);
		
		if (count($formQuery->results) === 0) {
			$json = '{"success": false, "errorMessage": "At least one result column should be selected"}';
		} else {
			
			$sqlPKey = $this->genericService->generateSQLPrimaryKey($this->schema, $queryObject);
			
			// Get the ids
			$pKeyIdWithTable = explode(',', $sqlPKey)[0];
			$pKeyId = explode('.', $pKeyIdWithTable)[1];
			$pKeyProviderIdWithTable = explode(',', $sqlPKey)[1];
			$pKeyProviderId = explode('.', $pKeyProviderIdWithTable)[1];
			
			$submissionJoin = array(
				'submission'
			);
			$resultJoins = array(
				'submission',
				'results'
			);
			// Generate the SQL Request
			$select = $this->customGenericService->generateSQLSelectRequest($this->schema, $queryObject);
			$fromNoJoin = $this->customGenericService->generateSQLFromRequestCustom($this->schema, $queryObject, $pKeyIdWithTable, $pKeyProviderIdWithTable, array());
			$fromJoinSubmission = $this->customGenericService->generateSQLFromRequestCustom($this->schema, $queryObject, $pKeyIdWithTable, $pKeyProviderIdWithTable, $submissionJoin);
			$fromJoinResults = $this->customGenericService->generateSQLFromRequestCustom($this->schema, $queryObject, $pKeyIdWithTable, $pKeyProviderIdWithTable, $resultJoins);
			$where = $this->customGenericService->generateSQLWhereRequestCustom($this->schema, $queryObject);
			
			$tables = $this->genericService->getAllFormats($this->schema, $queryObject);
			$locationField = $this->metadataModel->getGeometryField($this->schema, array_keys($tables));
			
			// Calculate the number of lines of result
			$countResult = $this->genericModel->executeRequest("SELECT COUNT(*) as count " . $fromJoinSubmission . $where);
			
			// Get the website session
			$websiteSession = new Zend_Session_Namespace('website');
			// Store the metadata in session for subsequent requests
			$websiteSession->resultColumns = $queryObject->editableFields;
			$websiteSession->locationField = $locationField;
			$websiteSession->SQLSelect = $select;
			$websiteSession->SQLFrom = $fromJoinSubmission;
			$websiteSession->SQLFromJoinResults = $fromJoinResults;
			$websiteSession->SQLWhere = $where;
			$websiteSession->SQLPkey = $sqlPKey;
			$websiteSession->queryObject = $queryObject;
			$websiteSession->count = $countResult[0]['count'];
			$websiteSession->schema = $this->schema;
			
			// Clean previously stored results
			$sessionId = session_id();
			$this->resultLocationModel->cleanPreviousResults($sessionId);
			
			// Identify the field carrying the location information
			$tables = $this->genericService->getAllFormats($this->schema, $queryObject);
			$locationField = $this->metadataModel->getGeometryField($this->schema, array_keys($tables));
			$locationTableInfo = $this->metadataModel->getTableFormat($this->schema, $locationField->format);
			
			// Run the request to store a temporary result table (for the web mapping)
			$this->resultLocationModel->fillLocationResult($fromJoinSubmission, $where, $sessionId, $locationTableInfo);
		}
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
