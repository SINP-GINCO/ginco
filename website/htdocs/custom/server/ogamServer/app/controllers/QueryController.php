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
include_once APPLICATION_PATH . '/controllers/QueryController.php';

/**
 * QueryController is the controller that manages the query module.
 *
 * @package controllers
 */
class Custom_QueryController extends QueryController {

	/**
	 * AJAX function : Builds the query.
	 *
	 * @return JSON
	 */
	public function ajaxbuildrequestAction() {
		$this->logger->debug('ajaxbuildrequestAction');

		$userSession = new Zend_Session_Namespace('user');
		$user = $userSession->user;

		// Check the validity of the POST
		if (!$this->getRequest()->isPost()) {
			$this->logger->debug('form is not a POST');
			return $this->_forward('index');
		}

		$datasetId = $this->getRequest()->getPost('datasetId');

		try {

			// Parse the input parameters and create a request object
			$formQuery = new Application_Object_Generic_FormQuery();
			$formQuery->datasetId = $datasetId;
			foreach ($_POST as $inputName => $inputValue) {
				if (strpos($inputName, "criteria__") === 0 && !$this->isEmptyCriteria($inputValue)) {
					$this->logger->debug('POST var added');
					$criteriaName = substr($inputName, strlen("criteria__"));
					$this->logger->debug(print_r($criteriaName, true));
					$split = explode("__", $criteriaName);

					// the user can request on sensiNiveau or diffusionniveauprecision only if he has the permission
					if (($split[1] != 'sensiniveau' || $user->isAllowed('VIEW_SENSITIVE')) && ($split[1] != 'diffusionniveauprecision' || $user->isAllowed('VIEW_PRIVATE'))) {
						$formQuery->addCriteria($split[0], $split[1], $inputValue);
					}
				}

				if (strpos($inputName, "column__") === 0) {
					$columnName = substr($inputName, strlen("column__"));
					$split = explode("__", $columnName);
					$formQuery->addResult($split[0], $split[1]);
				}
			}

			// Store the request parameters in session
			$websiteSession = new Zend_Session_Namespace('website');
			$websiteSession->formQuery = $formQuery;

			// Activate the result layer
			$this->mappingSession->activatedLayers[] = 'result_geometrie';

			echo '{"success":true}';
		} catch (Exception $e) {
			$this->logger->err('Error while getting result : ' . $e);
			echo '{"success":false,"errorMessage":' . json_encode($e->getMessage()) . '}';
		}

		// No View, we send directly the JSON
		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
		$this->getResponse()->setHeader('Content-type', 'application/json');
	}

	/**
	 * AJAX function : Return the list of a location information.
	 *
	 * @return JSON.
	 */
	public function ajaxgetlocationinfoAction() {
		$this->logger->debug('ajaxgetlocationinfoAction');

		$lon = $this->getRequest()->getParam('LON');
		$lat = $this->getRequest()->getParam('LAT');
		$activeLayers = $this->getRequest()->getParam('layers');
		$sessionId = session_id();

		if ($this->resultLocationModel->getResultsCount($sessionId) == 0) {
			echo '{"success":true, "id":null, "title":null, "hasChild":false, "columns":[], "fields":[], "data":[]}';
		} else {

			$websiteSession = new Zend_Session_Namespace('website');
			$schema = $websiteSession->schema; // the schema used
			$queryObject = $websiteSession->queryObject; // the last query done

			$tables = $this->genericService->getAllFormats($schema, $queryObject); // Extract the location table from the last query
			$locationField = $this->metadataModel->getGeometryField($schema, array_keys($tables)); // Extract the location field from the available tables
			$locationTableInfo = $this->metadataModel->getTableFormat($schema, $locationField->format); // Get info about the location table

			$locations = $this->resultLocationModel->getLocationInfo($sessionId, $lon, $lat, $activeLayers, $resultsLayer);

			// $resultsLayers is the most precise layer where we have found results
			if ($resultsLayer) {
				$resultsLayer = 'result_' . $resultsLayer; // real name
				$layersModel = new Application_Model_Mapping_Layers();
				$layer = $layersModel->getLayer($resultsLayer);
			}

			if (!empty($locations)) {
				// we have at least one plot found

				// The id is used to avoid to display two time the same result (it's a id for the result dataset)
				$id = array(
					'Results'
				); // A small prefix is required here to avoid a conflict between the id when the result contain only one result
				   // The columns config to setup the grid columnModel
				$columns = array();
				// The columns max length to setup the column width
				$columnsMaxLength = array();
				// The fields config to setup the store reader
				$locationFields = array(
					'id'
				); // The id must stay the first field
				   // The data to full the store
				$locationsData = array();

				foreach ($locations as $locationsIndex => $location) {
					$locationData = array();

					// Get the locations identifiers
					$key = 'SCHEMA/' . $schema . '/FORMAT/' . $locationTableInfo->format;
					$key .= '/' . $location['pk'];
					$id[] = $key;
					$locationData[] = $key;

					// Remove the pk of the available columns
					unset($location['pk']);

					// Get the other fields
					// Setup the location data and the column max length
					foreach ($location as $columnName => $value) {
						$locationData[] = $value;
						if (empty($columnsMaxLength[$columnName])) {
							$columnsMaxLength[$columnName] = array();
						}
						$columnsMaxLength[$columnName][] = strlen($value);
					}
					// Setup the fields and columns config
					if ($locationsIndex === (count($locations) - 1)) {

						// Get the table fields
						$tableFields = $this->metadataModel->getTableFields($schema, $locationTableInfo->format, null);
						$tFOrdered = array();
						foreach ($tableFields as $tableField) {
							$tFOrdered[strtoupper($tableField->columnName)] = $tableField;
						}
						foreach ($location as $columnName => $value) {
							$tableField = $tFOrdered[strtoupper($columnName)];
							// Set the column model and the location fields
							$dataIndex = $tableField->format . '__' . $tableField->data;
							// Adds the column header to prevent it from being truncated too and 2 for the header margins
							$columnsMaxLength[$columnName][] = strlen($tableField->label) + 2;
							$column = array(
								'header' => $tableField->label,
								'dataIndex' => $dataIndex,
								'editable' => false,
								'tooltip' => $tableField->definition,
								'width' => max($columnsMaxLength[$columnName]) * 7,
								'type' => $tableField->type
							);
							$columns[] = $column;
							$locationFields[] = $dataIndex;
						}
					}
					$locationsData[] = $locationData;
				}

				// We must sort the array here because it can't be done
				// into the mapfile sql request to avoid a lower performance
				sort($id);

				// Check if the location table has a child table
				$hasChild = false;
				$children = $this->metadataModel->getChildrenTableLabels($locationTableInfo);
				if (!empty($children)) {
					$hasChild = true;
				}

				$results = array(
					"success" => true,
					"layerLabel" => $layer->layerLabel,
					"id" => implode('', $id),
					"title" => $locationTableInfo->label . ' (' . count($locationsData) . ')',
					"hasChild" => $hasChild,
					"columns" => $columns,
					"fields" => $locationFields,
					"data" => $locationsData
				);
				echo json_encode($results);
			} else {
				$results = array(
					"success" => true,
					"layerLabel" => '',
					"id" => null,
					"title" => null,
					"hasChild" => false,
					"columns" => array(),
					"fields" => array(),
					"data" => array()
				);
				echo json_encode($results);
			}
		}
		// No View, we send directly the output
		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
	}

	/**
	 * AJAX function : Get the description of the columns of the result of the query.
	 *
	 * @return JSON
	 */
	public function ajaxgetresultcolumnsAction($withSQL = false) {
		$this->logger->debug('ajaxgetresultcolumns');

		try {
			// Store the request parameters in session
			$websiteSession = new Zend_Session_Namespace('website');
			$formQuery = $websiteSession->formQuery;

			$requestId = $this->resultLocationModel->getLastRequestIdFromSession(session_id());
			$this->logger->debug("requestId  : " . $requestId);

			$websiteSession = new Zend_Session_Namespace('website');
			$customQueryService = new Custom_Application_Service_QueryService($websiteSession->schema);
			$maxPrecisionLevel = $customQueryService->getMaxPrecisionLevel($websiteSession->formQuery->criterias);

			// Call the service to get the definition of the columns
			echo $customQueryService->getResultColumnsCustom($formQuery->datasetId, $formQuery, $maxPrecisionLevel, $requestId, $websiteSession);
		} catch (Exception $e) {
			$this->logger->err('Error while getting result : ' . $e);
			echo '{"success":false,"errorMessage":' . json_encode($e->getMessage()) . '}';
		}

		// No View, we send directly the JSON
		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
		$this->getResponse()->setHeader('Content-type', 'application/json');
	}

	/**
	 * AJAX function : Get a page of query result data.
	 *
	 * @return JSON
	 */
	public function ajaxgetresultrowsAction() {
		$this->logger->debug('ajaxgetresultrows');

		// Get the datatable parameters
		$start = $this->getRequest()->getPost('start');
		$length = $this->getRequest()->getPost('limit');
		$sort = $this->getRequest()->getPost('sort');
		$sortObj = json_decode($sort, true)[0];

		$websiteSession = new Zend_Session_Namespace('website');
		$requestId = $this->resultLocationModel->getLastRequestIdFromSession(session_id());
		$customQueryService = new Custom_Application_Service_QueryService($websiteSession->schema);

		echo $customQueryService->getResultRowsCustom($start, $length, $sortObj["property"], $sortObj["direction"], $requestId, $websiteSession);

		// No View, we send directly the JSON
		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
		$this->getResponse()->setHeader('Content-type', 'application/json');
	}

	/**
	 * Get the details associed with a result line (clic on the "detail button").
	 *
	 * @param String $id
	 *        	The identifier of the line
	 * @return JSON representing the detail of the result line.
	 */
	public function ajaxgetdetailsAction($id = null) {
		$this->logger->debug('getDetailsAction : ' . $id);

		// #802 : desactivate card details map
		// Get the names of the layers to display in the details panel
		// $configuration = Zend_Registry::get('configuration');

		// $detailsLayers[] = $configuration->getConfig('query_details_layers1');
		$detailsLayers = null;

		// Get the current dataset to filter the results
		$websiteSession = new Zend_Session_Namespace('website');
		$datasetId = $websiteSession->datasetId;
		$customQueryService = new Custom_Application_Service_QueryService($websiteSession->schema);

		// Get the identifier of the line from the session, and the bbox
		if ($id == null) {
			$id = $this->getRequest()->getPost('id');
		}
		$bbox = $this->getRequest()->getPost('bbox');

		echo $customQueryService->getDetailsCustom($id, $detailsLayers, $datasetId, $bbox);

		// No View, we send directly the JSON
		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
		$this->getResponse()->setHeader('Content-type', 'application/json');
	}

	/**
	 * AJAX function : Return the results features bounding box in order to zoom on the features.
	 *
	 * @return JSON.
	 */
	public function ajaxgetresultsbboxAction() {
		$this->logger->debug('ajaxgetresultsbboxAction');

		$configuration = Zend_Registry::get("configuration");
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', 480));

		try {

			// Call the service to get the definition of the columns
			$websiteSession = new Zend_Session_Namespace('website');
			$formQuery = $websiteSession->formQuery;
			$customQueryService = new Custom_Application_Service_QueryService('RAW_DATA');
			$customQueryService->prepareResultLocationsCustom($formQuery);

			// Execute the request
			$resultsbbox = $this->resultLocationModel->getResultsBBox(session_id());

			// Send the result as a JSON String
			echo '{"success":true, "resultsbbox":' . json_encode($resultsbbox) . '}';
		} catch (Exception $e) {
			$this->logger->err('Error while getting result : ' . $e);
			echo '{"success":false, "errorMessage":' . json_encode($e->getMessage()) . '}';
		}

		// No View, we send directly the JSON
		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
		$this->getResponse()->setHeader('Content-type', 'application/json');
	}

	/**
	 * AJAX function : Return the results features bounding box in order to zoom on the features.
	 *
	 * @return JSON.
	 */
	public function ajaxgetobservationbboxAction($observationId = null) {
		$this->logger->debug('ajaxgetobservationbboxAction : ' . $observationId);

		if ($observationId == null) {
			$observationId = $this->getRequest()->getPost('observationId');
		}

		$configuration = Zend_Registry::get("configuration");

		try {
			$customQueryService = new Custom_Application_Service_QueryService('RAW_DATA');
			$bbox = $customQueryService->getObservationBoundingBox($observationId);

			echo '{"success":true, "bbox":' . json_encode($bbox) . '}';
		} catch (Exception $e) {
			$this->logger->err('Error while getting result : ' . $e);
			echo '{"success":false, "errorMessage":' . json_encode($e->getMessage()) . '}';
		}

		// No View, we send directly the JSON
		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
		$this->getResponse()->setHeader('Content-type', 'application/json');
	}

	/**
	 * AJAX function : Nodes of a taxonomic referential under a given node.
	 *
	 * @return JSON.
	 */
	public function ajaxgettaxrefnodesAction() {
		$this->logger->debug('custom ajaxgettaxrefnodesAction');

		$unit = $this->getRequest()->getParam('unit');
		$code = $this->getRequest()->getPost('node');
		$depth = $this->getRequest()->getParam('depth');

		$customMetadata = new Application_Model_Metadata_CustomMetadata();
		$tree = $customMetadata->getTaxrefChildren($unit, $code, $depth);

		// Send the result as a JSON String
		$json = '{"success":true,' . '"data":[' . $tree->toJSON() . ']' . '}';

		echo $json;

		// No View, we send directly the JSON
		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
		$this->getResponse()->setHeader('Content-type', 'application/json');
	}

	/**
	 * Returns a csv file corresponding to the requested data.
	 * Fields are empty when the user doesn't have the right to view them.
	 * (same as "hidden" in the result array).
	 */
	public function csvExportAction() {
		$this->logger->debug('gridCsvExportAction');

		$userSession = new Zend_Session_Namespace('user');
		$user = $userSession->user;
		$websiteSession = new Zend_Session_Namespace('website');
		$schema = $websiteSession->schema;
		$requestId = $this->resultLocationModel->getLastRequestIdFromSession(session_id());
		$customQueryService = new Custom_Application_Service_QueryService($websiteSession->schema);

		// Configure memory and time limit because the program ask a lot of resources
		$configuration = Zend_Registry::get("configuration");
		ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', '480'));

		// Number of results to export
		$total = $websiteSession->count;
		$this->logger->debug('Expected lines : ' . $total);

		// Query by $maxLines batches
		$maxLines = 5000;

		// Start writing output (CSV file)
		// Define the header of the response
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');
		$this->getResponse()->setHeader('Content-Type', 'text/csv;charset=' . $charset . ';application/force-download;', true);
		$this->getResponse()->setHeader('Content-disposition', 'attachment; filename=DataExport_' . date('dmy_Hi') . '.csv', true);

		// Prepend the Byte Order Mask to inform Excel that the file is in UTF-8
		if ($charset === 'UTF-8') {
			echo (chr(0xEF));
			echo (chr(0xBB));
			echo (chr(0xBF));
		}

		if (($schema == 'RAW_DATA' && !$user->isAllowed('EXPORT_RAW_DATA')) || ($schema == 'HARMONIZED_DATA' && !$user->isAllowed('EXPORT_HARMONIZED_DATA'))) {
			$this->outputCharset('// No Permissions');
		} else if ($total > 65535) {
			$this->outputCharset('// Too many result lines (>65535)');
		} else {

			// Use fputcsv to return a string
			$arrayToCsv = function ($fields, $delimiter = ",", $enclosure = '"', $noLineReturn = false) {
				// Remove original enclosing character from fields
				$fields = array_map(function ($field) {
					return trim($field, '"');
				}, $fields);

				$temp = fopen('php://memory', 'r+');
				// use the default csv handler
				fputcsv($temp, $fields, $delimiter, $enclosure);
				rewind($temp);
				$csv = stream_get_contents($temp);
				fclose($temp);
				if ($noLineReturn) {
					$csv = substr($csv, 0, -1);
				}
				return $csv;
			};

			// Retrive the session-stored info
			$resultColumns = $websiteSession->resultColumns; // array of TableField

			// Prepare the form info
			foreach ($resultColumns as $tableField) {
				$key = strtolower($tableField->getName());
				// Get the full description of the form field
				$formFields[$key] = $this->genericService->getTableToFormMapping($tableField);
			}

			// Display the default message
			$this->outputCharset('// *************************************************' . "\n");
			$this->outputCharset('// ' . $this->translator->translate('Data Export') . "\n");
			$this->outputCharset('// *************************************************' . "\n\n");

			// Request criterias
			$this->outputCharset($this->csvExportCriterias());
			$this->outputCharset("\n");

			// Export the column names
			$line = array();
			foreach ($resultColumns as $tableField) {
				$line[] = $tableField->label;
			}
			$outputLine = $arrayToCsv($line, ';', '"');
			$this->outputCharset('// ' . $outputLine);

			// Get the order parameters: No, they are not in the request
			// $sort = $this->getRequest()->getPost('sort');
			// $sortDir = $this->getRequest()->getPost('dir');

			$pagesTotal = ceil($total / $maxLines);

			for ($page = 0; $page < $pagesTotal; $page ++) {

				// Get requested data
				// they come in the form of a json; convert them associative array and then to csv
				$dataJSON = $customQueryService->getResultRowsCustom($page * $maxLines, $maxLines, null, null, $requestId, $websiteSession, true);

				$data = json_decode($dataJSON, true);

				if ($data["success"]) {
					$rows = $data["rows"];
					// Write each line in the csv
					foreach ($rows as $line) {
						// keep only the first count($resultColumns), because there is 2 or 3 technical fields sent back (after the result columns).
						$line = array_slice($line, 0, count($resultColumns));
						// implode all arrays
						foreach ($line as $index => $value) {
							if (is_array($value)) {
								$line[$index] = join(",", $value); // just use join because we don't want double enclosure...
							}
						}
						// Write csv line to output
						$outputLine = $arrayToCsv($line, ';', '"');
						$this->outputCharset($outputLine);
					}
				}
			}
		}

		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
	}

	/**
	 * Returns a kml file corresponding to the requested data.
	 * KML export is not defined in GINCO because of the hiding of geometry
	 */
	public function kmlExportAction() {
		$this->logger->debug('gridKMLExportAction');

		// Define the header of the response
		$configuration = Zend_Registry::get("configuration");
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');
		$this->getResponse()->setHeader('Content-Type', 'application/vnd.google-earth.kml+xml;charset=' . $charset . ';application/force-download;', true);
		$this->getResponse()->setHeader('Content-disposition', 'attachment; filename=DataExport_' . date('dmy_Hi') . '.kml', true);

		$this->outputCharset("// L'export KML n'est pas prévu dans GINCO, merci de contacter l'administrateur.");

		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
	}

	/**
	 * Returns a geoJSON file corresponding to the requested data.
	 * GeoJson export is not defined in GINCO
	 */
	public function geojsonExportAction() {
		$this->logger->debug('geojsonExportAction');

		// Define the header of the response
		$configuration = Zend_Registry::get("configuration");
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');
		$this->getResponse()->setHeader('Content-Type', 'application/json;charset=' . $charset . ';application/force-download;', true);
		$this->getResponse()->setHeader('Content-disposition', 'attachment; filename=DataExport_' . date('dmy_Hi') . '.geojson', true);

		$this->outputCharset("// L'export GeoJson n'est pas prévu dans GINCO, merci de contacter l'administrateur.");

		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
	}
}