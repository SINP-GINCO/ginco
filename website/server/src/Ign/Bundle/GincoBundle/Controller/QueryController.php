<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Ign\Bundle\OGAMBundle\Entity\Mapping\ResultLocation;
use Ign\Bundle\OGAMBundle\Entity\Generic\QueryForm;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequest;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequestCriterion;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Dynamode;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Unit;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FormField;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableTree;
use Ign\Bundle\OGAMBundle\Controller\QueryController as BaseController;

/**
 * @Route("/query")
 */
class QueryController extends BaseController {

	/**
	 * AJAX function : Builds the query.
	 * OK Migrated. TODO : Check the TODO in the code.
	 *
	 * @Route("/ajaxbuildrequest")
	 */
	public function ajaxbuildrequestAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxbuildrequestAction');

		// Check the validity of the POST
		if (!$request->isMethod('POST')) {
			$logger->debug('form is not a POST');
			return $this->redirectToRoute('homepage');
		}

		$datasetId = $request->request->getAlnum('datasetId');

		try {

			// Parse the input parameters and create a request object
			$queryForm = new QueryForm();
			$queryForm->setDatasetId($datasetId);
			foreach ($request->request->all() as $inputName => $inputValue) {
				if (strpos($inputName, "criteria__") === 0 && !$this->get('ogam.query_service')->isEmptyCriteria($inputValue)) {
					$this->logger->debug('POST var added');
					$criteriaName = substr($inputName, strlen("criteria__"));
					$split = explode("__", $criteriaName);

					// The user can request on sensiNiveau or diffusionniveauprecision only if he has the permission
					if (($split[1] != 'sensiniveau' || $this->getUser()->isAllowed('VIEW_SENSITIVE')) && ($split[1] != 'diffusionniveauprecision' || $this->getUser()->isAllowed('VIEW_PRIVATE'))) {
						$queryForm->addCriterion($split[0], $split[1], $inputValue);
					} else {
						throw new \Exception($this->get('translator')->trans('Forbidden search'));
					}
				}

				if (strpos($inputName, "column__") === 0) {
					$columnName = substr($inputName, strlen("column__"));
					$split = explode("__", $columnName);
					$queryForm->addColumn($split[0], $split[1]);
				}
			}

			if ($queryForm->isValid()) {
				// Store the request parameters in session
				$request->getSession()->set('query_QueryForm', $queryForm);

				// Activate the result layer
				// TODO: Check if still mandatory
				// $this->mappingSession->activatedLayers[] = 'result_locations';

				return new JsonResponse([
					'success' => true
				]);
			} else {
				$logger->error('Invalid request.');
				return new JsonResponse([
					'success' => false,
					'errorMessage' => 'Invalid request.'
				]);
			}
		} catch (\Exception $e) {
			$logger->error('Error while getting result : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * @Route("/ajaxgetresultsbbox")
	 */
	public function ajaxgetresultsbboxAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetresultsbboxAction');

		$configuration = $this->get('ogam.configuration_manager');
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', 480));
		try {
			// Get the request from the session
			$queryForm = $request->getSession()->get('query_QueryForm');
			// Get the mappings for the query form fields
			$queryForm = $this->get('ogam.query_service')->setQueryFormFieldsMappings($queryForm);

			// Call the service to get the definition of the columns
			$userInfos = [
				"providerId" => $this->getUser() ? $this->getUser()
					->getProvider()
					->getId() : NULL,
				"DATA_QUERY_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY_OTHER_PROVIDER')
			];
			$where = $request->getSession()->get('query_SQLWhere');
			$from = $request->getSession()->get('query_SQLFrom');
			$nbResults = $request->getSession()->get('query_Count');

			$this->get('ogam.query_service')->prepareResults($from, $where, $queryForm, $this->getUser(), $userInfos, $request->getSession());
			// Execute the request
			$resultsbbox = $this->get('ogam.query_service')->getResultsBBox(session_id(), $nbResults);
			// Send the result as a JSON String
			return new JsonResponse([
				'success' => true,
				'resultsbbox' => $resultsbbox
			]);
		} catch (\Exception $e) {
			$logger->error('Error while getting result : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * AJAX function : Return the results features bounding box in order to zoom on the features.
	 * MIGRATION IN PROGRESS
	 * @return JSON.
	 */
	public function ajaxgetobservationbboxAction(Request $request) {
		$logger = $this->get('logger');
		$observationId = $request->request->getInt('observationId');
		$logger->debug('ajaxgetobservationbboxAction : ' . $observationId);

		if ($observationId == null) {
			$observationId = $request->get('observationId');
		}

		try {
			$bbox = $this->get('ogam.query_service')->getMapRequestObservationBoundingBox($observationId, $this->getUser());
			// Send the result as a JSON String
			return new JsonResponse([
				'success' => true,
				'bbox' => $bbox
			]);
		} catch (Exception $e) {
			$logger->error('Error while getting result : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}

	}

	/**
	 * MIGRATED.
	 * @Route("/ajaxgetresultcolumns")
	 */
	public function ajaxgetresultcolumnsAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetresultcolumns');

		try {
			// Get the request from the session
			$queryForm = $request->getSession()->get('query_QueryForm');
			// Get the mappings for the query form fields
			$queryForm = $this->get('ogam.query_service')->setQueryFormFieldsMappings($queryForm);
			// Get the request id
			$requestId = $this->getDoctrine()->getManager('mapping')->getRepository('IgnGincoBundle:Mapping\Request')->getLastRequestIdFromSession(session_id());
			// Get the maximum precision level
			$maxPrecisionLevel = $this->get('ogam.query_service')->getMaxPrecisionLevel($queryForm->getCriteria());

			// Call the service to get the definition of the columns
			$userInfos = [
				"providerId" => $this->getUser() ? $this->getUser()
					->getProvider()
					->getId() : NULL,
				"DATA_QUERY_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY_OTHER_PROVIDER'),
				"DATA_EDITION_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_EDITION_OTHER_PROVIDER')
			];

			$this->get('ogam.query_service')->buildRequestGinco($queryForm, $userInfos, $maxPrecisionLevel, $requestId, $request->getSession());

			$response = new Response();
			$response->headers->set('Content-Type', 'application/json');
			return $this->render('OGAMBundle:Query:ajaxgetresultcolumns.json.twig', array(
				'columns' => $this->get('ogam.query_service')
					->getColumns($queryForm),
				'userInfos' => $userInfos
			), $response);
		} catch (\Exception $e) {
			$logger->error('Error while getting result : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * @Route("/ajaxgetresultrows")
	 */
	public function ajaxgetresultrowsAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetresultrows');

		// Get the datatable parameters
		$start = $request->request->getInt('start');
		$length = $request->request->getInt('limit');
		$sort = $request->request->get('sort');
		$sortObj = json_decode($sort, true)[0];

		// Call the service to get the definition of the columns
		$userInfos = [
			"DATA_QUERY_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY_OTHER_PROVIDER')
		];

// 		$em = $this->getDoctrine()->getManager();
// 		$repository = $em->getRepository('GincoBundle\Mapping:Request');
// 		$requestId = $repository->getLastRequestIdFromSession(session_id());
		// Send the result as a JSON String
		return new JsonResponse([
			'success' => true,
			'total' => $request->getSession()->get('query_Count'),
			'data' => $this->get('ogam.query_service')->getResultRowsGinco($start, $length, $sortObj["property"], $sortObj["direction"], $request->getSession(), $userInfos)
		]);
	}

	/**
	 * AJAX function : Return the list of a location information.
	 * MIGRATION_IN_PROGRESS
	 *
	 * @Route("/ajaxgetlocationinfo")
	 */
	public function ajaxgetlocationinfoAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetlocationinfoAction');
		try {
			$lon = $request->query->get('LON');
			$lat = $request->query->get('LAT');
			$activeLayers = $request->query->get('layers');
			if (empty($lon) || empty($lat)) {
				throw new \InvalidArgumentException("The 'LON' and 'LAT' parameters are required.");
			}
			$sessionId = session_id();

			$defaultResponseArray = [
				'success' => true,
				"layerLabel" => '',
				'id' => null,
				"title" => null,
				"hasChild" => false,
				"columns" => [],
				"fields" => [],
				"data" => []
			];
			$resultLocationRepository = $this->getDoctrine()->getRepository(ResultLocation::class);

			if ($request->getSession()->get('query_Count', 0) == 0 && $resultLocationRepository->getResultsCount($sessionId)) {
				return new JsonResponse($defaultResponseArray);
			} else {
				$schema = $this->get('ogam.schema_listener')->getSchema();
				$locale = $this->get('ogam.locale_listener')->getLocale();
				$queryForm = $request->getSession()->get('query_QueryForm');
				// Get the mappings for the query form fields
				$queryForm = $this->get('ogam.query_service')->setQueryFormFieldsMappings($queryForm);

				// Get the location table information
				$tables = $this->get('ogam.generic_service')->getAllFormats($schema, $queryForm->getFieldMappingSet()
					->getFieldMappingArray()); // Extract the location table from the last query
					$locationField = $this->getDoctrine()
					->getRepository(TableField::class)
					->getGeometryField($schema, array_keys($tables), $locale); // Extract the location field from the available tables
					$locationTableInfo = $this->getDoctrine()
					->getRepository(TableFormat::class)
					->getTableFormat($schema, $locationField->getFormat()
						->getFormat(), $locale); // Get info about the location table

						// Get the intersected locations
						$locations = $resultLocationRepository->getLocationInfo($sessionId, $lon, $lat, $locationField, $schema, $this->get('ogam.configuration_manager'), $locale);

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
								$key = 'SCHEMA/' . $schema . '/FORMAT/' . $locationTableInfo->getFormat();
								$key .= '/' . $location['pk'];
								$id[] = $key;
								$locationData[] = $key;

								$logger->debug('$key : ' . $key);

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
									$tableFields = $this->getDoctrine()
									->getRepository(TableField::class)
									->getTableFields($schema, $locationField->getFormat()
										->getFormat(), null, $locale);
									$tFOrdered = array();
									foreach ($tableFields as $tableField) {
										$tFOrdered[strtoupper($tableField->getColumnName())] = $tableField;
									}
									foreach ($location as $columnName => $value) {
										$tableField = $tFOrdered[strtoupper($columnName)];
										// Set the column model and the location fields
										$dataIndex = $tableField->getName();
										// Adds the column header to prevent it from being truncated too and 2 for the header margins
										$columnsMaxLength[$columnName][] = strlen($tableField->getLabel()) + 2;
										$column = array(
											'header' => $tableField->getData()->getLabel(),
											'dataIndex' => $dataIndex,
											'editable' => false,
											'tooltip' => $tableField->getData()->getDefinition(),
											'width' => max($columnsMaxLength[$columnName]) * 7,
											'type' => $tableField->getData()
											->getUnit()
											->getType()
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
							$children = $this->getDoctrine()
							->getRepository(TableTree::class)
							->getChildrenTableLabels($locationTableInfo);
							if (!empty($children)) {
								$hasChild = true;
							}
							return new JsonResponse([
								'success' => true,
								"layerLabel" => $layer->layerLabel,
								'id' => implode('', $id),
								"title" => $locationTableInfo->getLabel() . ' (' . count($locationsData) . ')',
								"hasChild" => $hasChild,
								"columns" => $columns,
								"fields" => $locationFields,
								"data" => $locationsData
							]);
						} else {
							return new JsonResponse($defaultResponseArray);
						}
			}
		} catch (\Exception $e) {
			$logger->error('Error while getting details : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * @Route("/ajaxgetpredefinedrequestlist")
	 */
	public function ajaxgetpredefinedrequestlistAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetpredefinedrequestlist');

		$sort = $request->query->get('sort');
		$dir = $request->query->getAlpha('dir');

		// Get the predefined values for the forms
		$schema = $this->get('ogam.schema_listener')->getSchema();
		$locale = $this->get('ogam.locale_listener')->getLocale();
		$predefinedRequestRepository = $this->get('doctrine')->getRepository(PredefinedRequest::class);
		$predefinedRequestList = $predefinedRequestRepository->getPredefinedRequestList($schema, $dir, $sort, $locale, $this->getUser());

		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('OGAMBundle:Query:ajaxgetpredefinedrequestlist.json.twig', array(
			'data' => $predefinedRequestList,
			'user' => $this->getUser()
		), $response);
	}

	/**
	 * @Route("/ajaxgetpredefinedrequestcriteria")
	 */
	public function ajaxgetpredefinedrequestcriteriaAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetpredefinedrequestcriteria');

		$requestName = $request->query->get('request_name');
		$predefinedRequestCriterionRepository = $this->get('doctrine')->getRepository(PredefinedRequestCriterion::class);
		$locale = $this->get('ogam.locale_listener')->getLocale();

		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('OGAMBundle:Query:ajaxgetpredefinedrequestcriteria.html.twig', array(
			'data' => $predefinedRequestCriterionRepository->getPredefinedRequestCriteria($requestName, $locale)
		), $response);
	}

	/**
	 * Get the parameters used to initialise the result grid.
	 * @Route("/getgridparameters")
	 */
	public function getgridparametersAction() {
		$viewParam = array();
		$viewParam['hideGridCsvExportMenuItem'] = true; // By default the export is hidden
		$viewParam['hideGridDataEditButton'] = true;
		$viewParam['checkEditionRights'] = true; // By default, we don't check for rights on the data

		$user = $this->getUser();
		$schema = $this->get('ogam.schema_listener')->getSchema();

		if ($schema == 'RAW_DATA' && $user->isAllowed('EXPORT_RAW_DATA')) {
			$viewParam['hideGridCsvExportMenuItem'] = false;
		}
		if ($schema == 'HARMONIZED_DATA' && $user->isAllowed('EXPORT_HARMONIZED_DATA')) {
			$viewParam['hideGridCsvExportMenuItem'] = false;
		}
		if (($schema == 'RAW_DATA' || $schema == 'HARMONIZED_DATA') && $user->isAllowed('DATA_EDITION')) {
			$viewParam['hideGridDataEditButton'] = false;
		}
		if ($user->isAllowed('DATA_EDITION_OTHER_PROVIDER')) {
			$viewParam['checkEditionRights'] = false;
		}

		$response = new Response();
		$response->headers->set('Content-type', 'application/javascript');
		return $this->render('OGAMBundle:Query:getgridparameters.html.twig', $viewParam, $response);
	}

	/**
	 * Get the details associed with a result line (clic on the "detail button").
	 *
	 * @Route("/ajaxgetdetails")
	 */
	public function ajaxgetdetailsAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('getDetailsAction');

		try {
			// Get the names of the layers to display in the details panel
			// GINCO-802 : disable card details map
			$detailsLayers = null;

			// Get the current dataset to filter the results
			$datasetId = $request->getSession()
			->get('query_QueryForm')
			->getDatasetId();

			// Get the id and the bbox from the request
			$id = $request->request->get('id');
			if (empty($id)) {
				throw new \InvalidArgumentException('The id parameter is required.');
			}

			$userInfos = [
				"providerId" => $this->getUser() ? $this->getUser()
				->getProvider()
				->getId() : NULL,
				"DATA_EDITION" => $this->getUser() && $this->getUser()->isAllowed('DATA_EDITION')
			];

			// Bbox key is retrieved from POST
			$bbox = $request->get('bbox');

			$response = new Response();
			$response->headers->set('Content-Type', 'application/json');
			return $this->render('OGAMBundle:Query:ajaxgetdetails.json.twig', array(
				'data' => $this->get('ogam.query_service')
				->getDetailsDataGinco($id, $detailsLayers, $datasetId, true, $userInfos)
			), $response);
		} catch (\Exception $e) {
			$logger->error('Error while getting details : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * Get a label from a code, use a local cache mechanism.
	 *
	 * @param Application_Object_Metadata_TableField $tableField
	 *        	the field descriptor
	 * @param String $value
	 *        	the code to translate
	 */
	protected function getLabelCache($tableField, $value) {
		$label = '';
		$key = strtolower($tableField->getName());

		// Check in local cache
		if (isset($this->traductions[$key][$value])) {
			$label = $this->traductions[$key][$value];
		} else {
			// Check in database
			$trad = $this->get('ogam.generic_service')->getValueLabel($tableField, $value);

			// Put in cache
			if (!empty($trad)) {
				$label = $trad;
				$this->traductions[$key][$value] = $trad;
			}
		}

		return $label;
	}

	/**
	 * @Route("/csv-export")
	 */
	public function csvExportAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('csvExportAction');

		$user = $this->getUser();

		// Configure memory and time limit because the program ask a lot of resources
		$configuration = $this->get('ogam.configuration_manager');
		ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', '480'));
		$maxLines = 5000;

		// Define the header of the response
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');

		$content = "";

		if ($user->isAllowed('EXPORT_RAW_DATA')) {

			$websiteSession = $request->getSession();
			$select = $websiteSession->get('query_SQLSelect');
			$from = $websiteSession->get('query_SQLFrom');
			$where = $websiteSession->get('query_SQLWhere');
			$sql = $select . $from . $where;

			// Count the number of lines
			$total = $websiteSession->get('query_Count');
			$logger->debug('Expected lines : ' . $total);

			if ($sql == null) {
				$content .= iconv("UTF-8", $charset, '// No Data');
			} else if ($total > 65535) {
				$content .= iconv("UTF-8", $charset, '// Too many result lines');
			} else {

				// Prepend the Byte Order Mask to inform Excel that the file is in UTF-8
				if ($charset === 'UTF-8') {
					$content = chr(0xEF) . chr(0xBB) . chr(0xBF) . $content;
				}

				// Get the request from the session
				$queryForm = $request->getSession()->get('query_QueryForm');

				// Get the mappings for the query form fields
				$queryForm = $this->get('ogam.query_service')->setQueryFormFieldsMappings($queryForm);

				// Display the default message
				$content .= iconv("UTF-8", $charset, '// *************************************************');
				$content .= iconv("UTF-8", $charset, '// ' . $this->get('translator')->trans('Data Export') . "\n");
				$content .= iconv("UTF-8", $charset, '// *************************************************' . "\n\n");

				// Request criterias
				$content .= iconv("UTF-8", $charset, $this->csvExportCriterias($request));
				$content .= iconv("UTF-8", $charset, "\n");

				// Export the column names
				$content .= iconv("UTF-8", $charset, '// ');
				foreach ($queryForm->getColumns() as $genericFormField) {
					$genericTableField = $queryForm->getFieldMappingSet()->getDstField($genericFormField);
					$tableField = $genericTableField->getMetadata();
					$content .= iconv("UTF-8", $charset, $tableField->getLabel() . ';');
				}
				$content .= iconv("UTF-8", $charset, "\n");

				// Prepare the columns information
				$formFields = array();
				$tableFields = array();
				foreach ($queryForm->getColumns() as $genericFormField) {

					// Prepare some information for a later use
					// To avoid Doctrine request for each data line
					$formField = $this->get('ogam.query_service')->getFormField($genericFormField->getFormat(), $genericFormField->getData());
					$genericTableField = $queryForm->getFieldMappingSet()->getDstField($genericFormField);
					$tableField = $genericTableField->getMetadata();
					$formFields[$genericFormField->getId()] = $formField;
					$tableFields[$genericFormField->getId()] = $tableField;
				}

				// Get the order parameters
				$sort = $request->request->get('sort');
				$sortDir = $request->request->get('dir');

				$filter = "";

				if ($sort != "") {
					// $sort contains the form format and field
					$split = explode("__", $sort);
					$formField = new GenericField($split[0], $split[1]);
					$dstField = $queryForm->getFieldMappingSet()->getDstField($formField);
					$key = $dstField->getFormat() . "." . $dstField->getData();
					$filter .= " ORDER BY " . $key . " " . $sortDir . ", id";
				} else {
					$filter .= " ORDER BY id";
				}

				// Define the max number of lines returned
				$limit = " LIMIT " . $maxLines . " ";

				$count = 0;
				$page = 0;
				$finished = false;
				while (!$finished) {

					// Define the position of the cursor in the dataset
					$offset = " OFFSET " . ($page * $maxLines) . " ";

					// Execute the request
					$logger->debug('reading data ... page ' . $page);

					// Build complete query
					$query = $sql . $filter . $limit . $offset;

					// Execute the request
					$result = $this->get('ogam.query_service')->getQueryResults($query);

					// Export the lines of data
					foreach ($result as $line) {

						// $columns = $this->get('ogam.query_service')->getColumns($queryForm);

						foreach ($queryForm->getColumns() as $genericFormField) {

							$formField = $formFields[$genericFormField->getId()];
							$tableField = $tableFields[$genericFormField->getId()];

							$value = $line[strtolower($tableField->getName())];

							if ($value == null) {
								$content .= iconv("UTF-8", $charset, ';');
							} else {
								if ($tableField->getData()
									->getUnit()
									->getType() === "CODE") {

									$label = $this->getLabelCache($tableField, $value);

									$content .= iconv("UTF-8", $charset, '"' . $label . '";');
								} else if ($tableField->getData()
									->getUnit()
									->getType() === "ARRAY") {
									// Split the array items
									$arrayValues = explode(",", preg_replace("@[{-}]@", "", $value));
									$label = '';
									foreach ($arrayValues as $arrayValue) {

										$label .= $this->getLabelCache($tableField, $arrayValue);
										$label .= ',';
									}
									if ($label != '') {
										$label = substr($label, 0, -1);
									}
									$label = '[' . $label . ']';

									$content .= iconv("UTF-8", $charset, '"' . $label . '";');
								} else if ($formField->getInputType() === "NUMERIC") {
									// Numeric value
									if ($formField->getDecimals() !== null && $formField->getDecimals() !== "") {
										$value = number_format($value, $formField->getDecimals(), ',', '');
									}

									$content .= iconv("UTF-8", $charset, $value . ';');
								} else {
									// Default case : String value
									$content .= iconv("UTF-8", $charset, '"' . $value . '";');
								}
							}
						}
						$content .= iconv("UTF-8", $charset, "\n");
						$count ++;
					}

					// Check we have read everything
					if ($count == $total) {
						$finished = true;
					}

					$page ++;
				}
			}
		} else {
			$content .= iconv("UTF-8", $charset, '// No Permissions');
		}

		$response = new Response($content, 200);
		$response->headers->set('Content-Type', 'text/csv;charset=' . $charset . ';application/force-download;');
		$response->headers->set('Content-disposition', 'attachment; filename=DataExport_' . date('dmy_Hi') . '.csv');

		return $response;
	}

	/**
	 * Export the request criterias in the CSV file.
	 *
	 * @return String the criterias
	 */
	protected function csvExportCriterias(Request $request) {
		$criteriasLine = "";

		$criteriasLine .= '// ' . $this->get('translator')->trans('Request Criterias') . "\n";

		// Get the request from the session
		$queryForm = $request->getSession()->get('query_QueryForm');

		// List all the criterias
		foreach ($queryForm->getCriteria() as $genericFormField) {

			$genericTableField = $queryForm->getFieldMappingSet()->getDstField($genericFormField);
			$tableField = $genericTableField->getMetadata();

			// Get the descriptor of the form field
			$criteriasLine .= '// ' . $tableField->getLabel() . ';';

			if (is_array($genericFormField->getValueLabel())) {
				$criteriasLine .= implode(', ', $genericFormField->getValueLabel());
			} else {
				$criteriasLine .= $genericFormField->getValueLabel();
			}

			$criteriasLine .= "\n";
		}

		return $criteriasLine;
	}

	/**
	 * @Route("/kml-export")
	 */
	public function kmlExportAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('kmlExportAction');

		$user = $this->getUser();
		$schema = $this->get('ogam.schema_listener')->getSchema();

		// Configure memory and time limit because the program ask a lot of resources
		$configuration = $this->get('ogam.configuration_manager');
		ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', '480'));
		$maxLines = 5000;

		// Define the header of the response
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');

		$content = "";

		if (($schema == 'RAW_DATA' && $user->isAllowed('EXPORT_RAW_DATA')) || ($schema == 'HARMONIZED_DATA' && $user->isAllowed('EXPORT_HARMONIZED_DATA'))) {

			$websiteSession = $request->getSession();
			$select = $websiteSession->get('query_SQLSelect');
			$from = $websiteSession->get('query_SQLFrom');
			$where = $websiteSession->get('query_SQLWhere');
			$locationField = $websiteSession->get('query_locationField');

			$sql = $select . ', ST_AsKML(' . $locationField->getColumnName() . ') AS KML ' . $from . $where;

			// Count the number of lines
			$total = $websiteSession->get('query_Count');
			$logger->debug('Expected lines : ' . $total);

			if ($sql == null) {
				$content .= iconv("UTF-8", $charset, '// No Data');
			} else if ($total > 65535) {
				$content .= iconv("UTF-8", $charset, '// Too many result lines');
			} else {

				// Get the request from the session
				$queryForm = $request->getSession()->get('query_QueryForm');

				// Get the mappings for the query form fields
				$queryForm = $this->get('ogam.query_service')->setQueryFormFieldsMappings($queryForm);

				// Prepare the columns information
				$formFields = array();
				$tableFields = array();
				foreach ($queryForm->getColumns() as $genericFormField) {

					// Prepare some information for a later use
					// To avoid Doctrine request for each data line
					$formField = $this->get('ogam.query_service')->getFormField($genericFormField->getFormat(), $genericFormField->getData());
					$genericTableField = $queryForm->getFieldMappingSet()->getDstField($genericFormField);
					$tableField = $genericTableField->getMetadata();
					$formFields[$genericFormField->getId()] = $formField;
					$tableFields[$genericFormField->getId()] = $tableField;
				}

				// Display the default message
				$content .= iconv("UTF-8", $charset, '<?xml version="1.0" encoding="UTF-8"?>' . "\n");
				$content .= iconv("UTF-8", $charset, '<kml xmlns="http://www.opengis.net/kml/2.2">' . "\n");
				$content .= iconv("UTF-8", $charset, '<Document>' . "\n");

				// Get the order parameters
				$sort = $request->request->get('sort');
				$sortDir = $request->request->get('dir');

				$filter = "";

				if ($sort != "") {
					// $sort contains the form format and field
					$split = explode("__", $sort);
					$formField = new GenericField($split[0], $split[1]);
					$dstField = $queryForm->getFieldMappingSet()->getDstField($formField);
					$key = $dstField->getFormat() . "." . $dstField->getData();
					$filter .= " ORDER BY " . $key . " " . $sortDir . ", id";
				} else {
					$filter .= " ORDER BY id";
				}

				// Define the max number of lines returned
				$limit = " LIMIT " . $maxLines . " ";

				$count = 0;
				$page = 0;
				$finished = false;
				while (!$finished) {

					// Define the position of the cursor in the dataset
					$offset = " OFFSET " . ($page * $maxLines) . " ";

					// Execute the request
					$logger->debug('reading data ... page ' . $page);

					$query = $sql . $filter . $limit . $offset;

					$result = $this->get('ogam.query_service')->getQueryResults($query);

					// Export the lines of data
					foreach ($result as $line) {

						$content .= iconv("UTF-8", $charset, "<Placemark>");

						$content .= iconv("UTF-8", $charset, $line['kml']);

						$content .= iconv("UTF-8", $charset, "<ExtendedData>");

						foreach ($queryForm->getColumns() as $genericFormField) {

							$formField = $formFields[$genericFormField->getId()];
							$tableField = $tableFields[$genericFormField->getId()];

							$value = $line[strtolower($tableField->getName())];

							$label = $value;

							if ($value !== null) {
								if ($tableField->getData()
									->getUnit()
									->getType() === "CODE") {
									// Manage code traduction
									$label = $this->getLabelCache($tableField, $value);
								} else if ($tableField->getData()
									->getUnit()
									->getType() === "ARRAY") {
									// Split the array items
									$arrayValues = explode(",", preg_replace("@[{-}]@", "", $value));
									$label = '';
									foreach ($arrayValues as $arrayValue) {
										$label .= $this->getLabelCache($tableField, $arrayValue);
										$label .= ',';
									}
									if ($label != '') {
										$label = substr($label, 0, -1);
									}
									$label = '[' . $label . ']';
								} else if ($formField->getInputType() === "NUMERIC") {
									// Numeric value
									if ($formField->getDecimals() !== null && $formField->getDecimals() !== "") {
										$label = number_format($value, $formField->getDecimals());
									}
								}
							}

							$content .= iconv("UTF-8", $charset, '<Data name="' . $formField->getLabel() . '">');
							$content .= iconv("UTF-8", $charset, '<value>' . $label . '</value>');
							$content .= iconv("UTF-8", $charset, '</Data>');
						}

						$content .= iconv("UTF-8", $charset, "</ExtendedData>");

						$content .= iconv("UTF-8", $charset, "</Placemark>");

						$content .= iconv("UTF-8", $charset, "\n");

						$count ++;
					}

					// Check we have read everything
					if ($count == $total) {
						$finished = true;
					}

					$page ++;
				}

				$content .= iconv("UTF-8", $charset, '</Document>' . "\n");
				$content .= iconv("UTF-8", $charset, '</kml>' . "\n");
			}
		} else {
			$content .= iconv("UTF-8", $charset, '// No Permissions');
		}

		$response = new Response($content, 200);
		$response->headers->set('Content-Type', 'application/vnd.google-earth.kml+xml;charset=' . $charset . ';application/force-download;');
		$response->headers->set('Content-disposition', 'attachment; filename=DataExport_' . date('dmy_Hi') . '.kml');

		return $response;
	}

	/**
	 * @Route("/geojson-export")
	 */
	public function geojsonExportAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('geojsonExportAction');

		$user = $this->getUser();
		$schema = $this->get('ogam.schema_listener')->getSchema();

		// Configure memory and time limit because the program ask a lot of resources
		$configuration = $this->get('ogam.configuration_manager');
		ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', '480'));
		$maxLines = 5000;

		// Define the header of the response
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');

		$content = "";

		// Define the header of the response

		if (($schema == 'RAW_DATA' && $user->isAllowed('EXPORT_RAW_DATA')) || ($schema == 'HARMONIZED_DATA' && $user->isAllowed('EXPORT_HARMONIZED_DATA'))) {

			$websiteSession = $request->getSession();
			$select = $websiteSession->get('query_SQLSelect');
			$from = $websiteSession->get('query_SQLFrom');
			$where = $websiteSession->get('query_SQLWhere');
			$locationField = $websiteSession->get('query_locationField');

			$sql = $select . ', ST_AsGeoJSON(' . $locationField->getColumnName() . ') AS geojson ' . $from . $where;

			// Count the number of lines
			$total = $websiteSession->get('query_Count');
			$logger->debug('Expected lines : ' . $total);

			if ($sql == null) {
				$content .= iconv("UTF-8", $charset, '// No Data');
			} else if ($total > 65535) {
				$content .= iconv("UTF-8", $charset, '// Too many result lines');
			} else {

				// Get the request from the session
				$queryForm = $request->getSession()->get('query_QueryForm');

				// Get the mappings for the query form fields
				$queryForm = $this->get('ogam.query_service')->setQueryFormFieldsMappings($queryForm);

				// Prepare the columns information
				$formFields = array();
				$tableFields = array();
				foreach ($queryForm->getColumns() as $genericFormField) {

					// Prepare some information for a later use
					// To avoid Doctrine request for each data line
					$formField = $this->get('ogam.query_service')->getFormField($genericFormField->getFormat(), $genericFormField->getData());
					$genericTableField = $queryForm->getFieldMappingSet()->getDstField($genericFormField);
					$tableField = $genericTableField->getMetadata();
					$formFields[$genericFormField->getId()] = $formField;
					$tableFields[$genericFormField->getId()] = $tableField;
				}

				// Display the default message
				$content .= iconv("UTF-8", $charset, '{ "type": "FeatureCollection",' . "\n");
				$content .= iconv("UTF-8", $charset, ' "features": [' . "\n");

				// Get the order parameters
				$sort = $request->request->get('sort');
				$sortDir = $request->request->get('dir');

				$filter = "";

				if ($sort != "") {
					// $sort contains the form format and field
					$split = explode("__", $sort);
					$formField = new GenericField($split[0], $split[1]);
					$dstField = $queryForm->getFieldMappingSet()->getDstField($formField);
					$key = $dstField->getFormat() . "." . $dstField->getData();
					$filter .= " ORDER BY " . $key . " " . $sortDir . ", id";
				} else {
					$filter .= " ORDER BY id";
				}

				// Define the max number of lines returned
				$limit = " LIMIT " . $maxLines . " ";

				$count = 0;
				$page = 0;
				$finished = false;
				while (!$finished) {

					// Define the position of the cursor in the dataset
					$offset = " OFFSET " . ($page * $maxLines) . " ";

					// Execute the request
					$logger->debug('reading data ... page ' . $page);

					$query = $sql . $filter . $limit . $offset;

					$result = $this->get('ogam.query_service')->getQueryResults($query);

					// Export the lines of data
					foreach ($result as $line) {

						$content .= iconv("UTF-8", $charset, '{"type": "Feature", ');
						$content .= iconv("UTF-8", $charset, '"geometry": ' . $line['geojson'] . ', ');
						$content .= iconv("UTF-8", $charset, '"properties": {');

						foreach ($queryForm->getColumns() as $genericFormField) {

							$formField = $formFields[$genericFormField->getId()];
							$tableField = $tableFields[$genericFormField->getId()];

							$value = $line[strtolower($tableField->getName())];

							$label = $value;

							if ($value !== null) {
								if ($tableField->getData()
									->getUnit()
									->getType() === "CODE") {
									// Manage code traduction
									$label = $this->getLabelCache($tableField, $value);
								} else if ($tableField->getData()
									->getUnit()
									->getType() === "ARRAY") {
									// Split the array items
									$arrayValues = explode(",", preg_replace("@[{-}]@", "", $value));
									$label = '';
									foreach ($arrayValues as $arrayValue) {

										$label .= $this->getLabelCache($tableField, $arrayValue);
										$label .= ',';
									}
									if ($label != '') {
										$label = substr($label, 0, -1);
									}
									$label = '[' . $label . ']';
								} else if ($formField->getInputType() === "NUMERIC") {
									// Numeric value
									if ($formField->getDecimals() !== null && $formField->getDecimals() !== "") {
										$label = number_format($value, $formField->getDecimals());
									}
								}
							}

							$content .= iconv("UTF-8", $charset, '"' . $formField->getLabel() . '": "' . $label . '", ');
						}

						$content .= iconv("UTF-8", $charset, "}");

						$content .= iconv("UTF-8", $charset, "},");

						$content .= iconv("UTF-8", $charset, "\n");

						$count ++;
					}

					// Check we have read everything
					if ($count == $total) {
						$finished = true;
					}

					$page ++;
				}

				$content .= iconv("UTF-8", $charset, ']' . "\n");
				$content .= iconv("UTF-8", $charset, '}' . "\n");
			}
		} else {
			$content .= iconv("UTF-8", $charset, '}' . '// No Permissions');
		}

		$response = new Response($content, 200);
		$response->headers->set('Content-Type', 'application/json;charset=' . $charset . ';application/force-download;');
		$response->headers->set('Content-disposition', 'attachment; filename=DataExport_' . date('dmy_Hi') . '.geojson');

		return $response;
	}

	/**
	 * AJAX function : Nodes of a tree under a given node and for a given unit.
	 *
	 * @Route("/ajaxgettreenodes")
	 */
	public function ajaxgettreenodesAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgettreenodesAction');
		try {
			$unitCode = $request->get('unit');
			$code = $request->request->get('node');
			$depth = $request->get('depth');
			if (empty($unitCode) || empty($code) || empty($depth)) {
				throw new \InvalidArgumentException("The 'unit', 'node' and 'depth' parameters are required.");
			}
			$em = $this->get('doctrine.orm.metadata_entity_manager');
			$locale = $this->get('ogam.locale_listener')->getLocale();
			$unit = $em->find(Unit::class, $unitCode);
			$tree = $em->getRepository('OGAMBundle:Metadata\ModeTree')->getTreeChildrenModes($unit, $code, $depth ? $depth + 1 : 0, $locale);
			array_shift($tree);
			return $this->render('OGAMBundle:Query:ajaxgettreenodes.json.twig', array(
				'data' => $tree
			));
		} catch (\Exception $e) {
			$logger->error('Error while getting details : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * AJAX function : Nodes of a taxonomic referential under a given node.
	 *
	 * @Route("/ajaxgettaxrefnodes")
	 */
	public function ajaxgettaxrefnodesAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgettaxrefnodesAction');
		try {
			$unitCode = $request->get('unit');
			$code = $request->request->get('node');
			$depth = $request->get('depth');
			if (empty($unitCode) || empty($code) || empty($depth)) {
				throw new \InvalidArgumentException("The 'unit', 'node' and 'depth' parameters are required.");
			}
			$em = $this->get('doctrine.orm.metadata_entity_manager');
			$locale = $this->get('ogam.locale_listener')->getLocale();
			$unit = $em->find(Unit::class, $unitCode);
			$tree = $em->getRepository('OGAMBundle:Metadata\ModeTaxref')->getTaxrefChildrenModes($unit, $code, $depth ? $depth + 1 : 0, $locale);
			array_shift($tree);
			return $this->render('OGAMBundle:Query:ajaxgettaxrefnodes.json.twig', array(
				'data' => $tree
			));
		} catch (\Exception $e) {
			$logger->error('Error while getting details : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * AJAX function : Return the list of available codes for a dynamic list.
	 * (limit 1000)
	 * @Route("/ajaxgetdynamiccodes")
	 */
	public function ajaxgetdynamiccodesAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetdynamiccodesAction');
		try {
			$unitCode = $request->query->get('unit');
			$query = $request->query->get('query', null);
			$max = 1000;
			$start = $request->query->getInt('start', 0);
			$limit = $request->query->getInt('limit', $max);
			$limit = min($max, $limit);
			if (empty($unitCode)) {
				throw new \InvalidArgumentException("The 'unit' parameters is required.");
			}

			$em = $this->get('doctrine.orm.metadata_entity_manager');
			$unit = $em->find(Unit::class, $unitCode);
			$locale = $this->get('ogam.locale_listener')->getLocale();
			$modes = $em->getRepository(Dynamode::class)->getModesFilteredByLabel($unit, $query, $locale);

			$response = new JsonResponse();

			return $this->render('OGAMBundle:Query:ajaxgetcodes.json.twig', array(
				'total' => count($modes),
				'data' => array_slice($modes, $start, $limit)
			), $response);
		} catch (\Exception $e) {
			$logger->error('Error while getting details : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * AJAX function : Return the list of available codes for a MODE unit.
	 * @Route("/ajaxgetcodes")
	 */
	public function ajaxgetcodesAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetcodesAction');
		try {
			$unitCode = $request->query->get('unit');
			$query = $request->query->get('query', null);
			if (empty($unitCode)) {
				throw new \InvalidArgumentException("The 'unit' parameter is required.");
			}

			$em = $this->get('doctrine.orm.metadata_entity_manager');
			$unit = $em->find(Unit::class, $unitCode);

			$locale = $this->get('ogam.locale_listener')->getLocale();

			if ($query === null) {
				$modes = $em->getRepository(Unit::class)->getModes($unit, $locale);
			} else {
				$modes = $em->getRepository('OGAMBundle:Metadata\Mode')->getModesFilteredByLabel($unit, $query, $locale);
			}

			$response = new JsonResponse();

			return $this->render('OGAMBundle:Query:ajaxgetcodes.json.twig', array(
				'data' => $modes
			), $response);
		} catch (\Exception $e) {
			$logger->error('Error while getting details : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * AJAX function : Return the list of available codes for a MODE unit and a filter text.
	 * @Route("/ajaxgettreecodes")
	 */
	public function ajaxgettreecodesAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgettreecodesAction');
		try {
			$unitCode = $request->query->get('unit');
			$query = $request->query->get('query', null);
			$start = $request->query->getInt('start', 0);
			$limit = $request->query->getInt('limit', null);
			if (empty($unitCode)) {
				throw new \InvalidArgumentException("The 'unit' parameter is required.");
			}

			$em = $this->get('doctrine.orm.metadata_entity_manager');
			$unit = $em->find(Unit::class, $unitCode);

			$locale = $this->get('ogam.locale_listener')->getLocale();

			// $em->getRepository(Unit::class)->getModesFilteredByLabel($unit, $query, $locale);
			$rows = $em->getRepository('OGAMBundle:Metadata\ModeTree')->getTreeModesSimilareTo($unit, $query, $locale, $start, $limit);
			if (count($rows) < $limit) {
				// optimisation
				$count = count($rows);
			} else {
				// TODO use a paginator ?
				$count = $em->getRepository('OGAMBundle:Metadata\ModeTree')->getTreeModesSimilareToCount($unit, $query, $locale);
			}
			return $this->render('OGAMBundle:Query:ajaxgettreecodes.json.twig', array(
				'data' => $rows,
				'total' => $count
			), new JsonResponse());
		} catch (\Exception $e) {
			$logger->error('Error while getting details : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

	/**
	 * AJAX function : Return the list of available codes for a taxref and a filter text.
	 * @Route("/ajaxgettaxrefcodes")
	 */
	public function ajaxgettaxrefcodesAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgettaxrefcodesAction');
		try {
			$unitCode = $request->query->get('unit');
			$query = $request->query->get('query', null);
			$start = $request->query->getInt('start', 0);
			$limit = $request->query->getInt('limit', null);
			if (empty($unitCode)) {
				throw new \InvalidArgumentException("The 'unit' parameter is required.");
			}
			$em = $this->get('doctrine.orm.metadata_entity_manager');
			$unit = $em->find(Unit::class, $unitCode);

			$locale = $this->get('ogam.locale_listener')->getLocale();

			$rows = $em->getRepository('OGAMBundle:Metadata\ModeTaxref')->getTaxrefModesSimilarTo($unit, $query, $locale, $start, $limit);
			if (count($rows) < $limit) {
				// optimisation
				$count = count($rows);
			} else {
				$count = $em->getRepository('OGAMBundle:Metadata\ModeTaxref')->getTaxrefModesCount($unit, $query, $locale);
			}
			return $this->render('OGAMBundle:Query:ajaxgettaxrefcodes.json.twig', array(
				'data' => $rows,
				'total' => $count
			), new JsonResponse());
		} catch (\Exception $e) {
			$logger->error('Error while getting details : ' . $e);
			return new JsonResponse([
				'success' => false,
				'errorMessage' => $e->getMessage()
			]);
		}
	}

}
