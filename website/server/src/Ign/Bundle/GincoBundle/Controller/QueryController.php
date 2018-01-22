<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\Mapping\Result;
use Ign\Bundle\OGAMBundle\Controller\QueryController as BaseController;
use Ign\Bundle\OGAMBundle\Entity\Generic\QueryForm;
use Ign\Bundle\OGAMBundle\Entity\Mapping\Layer;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Dynamode;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableTree;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Unit;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequest;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequestCriterion;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * @Route("/query")
 */
class QueryController extends BaseController {

	/**
	 * Show the main query page.
	 * GINCO : Change the results table that is cleaned (result instead of result_location)
	 *
	 * @Route("/show-query-form", name = "query_show-query-form")
	 */
	public function showQueryFormAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('showQueryFormAction');

		// Clean previous results
		$repo = $this->getDoctrine()
			->getManager('mapping')
			->getRepository(Result::class);
		$repo->cleanPreviousResults(session_id());

		// Check if the parameter of the default page is set
		if ($request->query->get('tab') === "predefined") {
			$logger->debug('defaultTab predefined');
			$defaultTab = 'predefined_request';
		} elseif ($request->query->get('tab') === "edition") {
			$logger->debug('defaultTab edition');
			$defaultTab = 'edition-add';
		}

		// Add the configuration parameters to the session for the map proxies (mapserverProxy and tilecacheProxy)
		if (!$request->getSession()->has('proxy_ConfigurationParameters')) {
			$configuration = $this->get('ogam.configuration_manager');
			$request->getSession()->set('proxy_ConfigurationParameters', $configuration->getParameters());
		}

		// Forward the user to the next step
		$visuUrl = ($this->container->getParameter('kernel.environment') == 'dev') ? '/odd' : '/odp';
		$visuUrl = $request->getBasePath() . $visuUrl;
		if (isset($defaultTab) && $defaultTab === "edition-add") {
			$providerId = $this->getUser() ? $this->getUser()
				->getProvider()
				->getId() : NULL;
			return $this->redirect($visuUrl . '/index.html?locale=' . $request->getLocale() . (isset($defaultTab) ? '#' . $defaultTab : '') . '/SCHEMA/RAW_DATA/FORMAT/LOCATION_DATA/PROVIDER_ID/' . $providerId);
		} else {
			return $this->redirect($visuUrl . '/index.html?locale=' . $request->getLocale() . (isset($defaultTab) ? '#' . $defaultTab : ''));
		}
	}

	/**
	 * @Route("/ajaxresetresult")
	 */
	public function ajaxresetresultAction() {
		$this->get('logger')->debug('ajaxresetresultAction');

		$sessionId = session_id();

		$repo = $this->getDoctrine()
			->getManager('mapping')
			->getRepository(Result::class);
		$repo->cleanPreviousResults($sessionId);

		return new JsonResponse([
			'success' => true
		]);
	}

	/**
	 * AJAX function : Builds the query.
	 * OK Migrated. TODO : Check the TODO in the code.
	 *
	 * @Route("/ajaxbuildrequest", name="query_build_request")
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
					$criteriaName = substr($inputName, strlen("criteria__"));
					$split = explode("__", $criteriaName);

					// the user can request on sensiNiveau or diffusionniveauprecision only if he has the permission
					if (($split[1] != 'sensiniveau' || $this->getUser()->isAllowed('VIEW_SENSITIVE')) && ($split[1] != 'diffusionniveauprecision' || $this->getUser()->isAllowed('VIEW_PRIVATE'))) {
						$queryForm->addCriterion($split[0], $split[1], $inputValue);
						$logger->debug("Criterion added is : " . $split[1]);
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
	 * @Route("/ajaxgetresultsbbox", name="query_get_results_bbox")
	 */
	public function ajaxgetresultsbboxAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetresultsbboxAction');

		$configuration = $this->get('ogam.configuration_manager');
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', 480));
		try {
			$grandPublicRole = $this->getDoctrine()
				->getManager('website')
				->getRepository('OGAMBundle:Website\Role')
				->findByLabel('Grand public');
			// Get the request from the session
			$queryForm = $request->getSession()->get('query_QueryForm');
			// Get the mappings for the query form fields
			$queryForm = $this->get('ogam.query_service')->setQueryFormFieldsMappings($queryForm);

			// Call the service to get the definition of the columns
			$userInfos = [
				"providerId" => $this->getUser() ? $this->getUser()
					->getProvider() : NULL,
				"hasGrandPublicRole" => in_array($grandPublicRole, $this->getUser()->getRoles()),
				"DATA_QUERY" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY'),
				"DATA_QUERY_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY_OTHER_PROVIDER'),
				"CONFIRM_SUBMISSION" => $this->getUser() && $this->getUser()->isAllowed('CONFIRM_SUBMISSION')
			];

			$where = $request->getSession()->get('query_SQLWhere');
			$from = $request->getSession()->get('query_SQLFrom');
			$nbResults = $request->getSession()->get('query_Count');

			$this->get('ogam.query_service')->prepareResults($from, $where, $queryForm, $this->getUser(), $userInfos, $request->getSession());
			// Execute the request
			$resultsbbox = $this->get('ogam.query_service')->getResultsBBox($request->getSession()
				->getId(), $nbResults);
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
	 * MIGRATED.
	 *
	 * @Route("/ajaxgetobservationbbox", name="query_get_observation_bbox")
	 */
	public function ajaxgetobservationbboxAction(Request $request) {
		$logger = $this->get('logger');
		$observationId = $request->request->get('observationId');
		$logger->debug('ajaxgetobservationbboxAction : ' . $observationId);
		$locale = $this->get('ogam.locale_listener')->getLocale();

		try {
			$bbox = $this->get('ogam.query_service')->getObservationBoundingBox($observationId, $request->getSession(), $this->getUser(), $locale);
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
	 * @Route("/ajaxgetresultcolumns", name="query_get_result_columns")
	 */
	public function ajaxgetresultcolumnsAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetresultcolumns');

		try {
			$grandPublicRole = $this->getDoctrine()
				->getManager('website')
				->getRepository('OGAMBundle:Website\Role')
				->find(4);
			// Get the request from the session
			$queryForm = $request->getSession()->get('query_QueryForm');
			// Get the mappings for the query form fields
			$queryForm = $this->get('ogam.query_service')->setQueryFormFieldsMappings($queryForm);
			// Get the request id
			$requestId = $this->getDoctrine()
				->getManager('mapping')
				->getRepository('IgnGincoBundle:Mapping\Request')
				->getLastRequestIdFromSession(session_id());
			// Get the maximum precision level
			$maxPrecisionLevel = $this->get('ogam.query_service')->getMaxPrecisionLevel($queryForm->getCriteria());
			// Call the service to get the definition of the columns
			$userInfos = [
				"providerId" => $this->getUser() ? $this->getUser()
					->getProvider() : NULL,
				"hasGrandPublicRole" => in_array($grandPublicRole, $this->getUser()->getRoles()),
				"DATA_QUERY" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY'),
				"DATA_QUERY_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY_OTHER_PROVIDER'),
				"DATA_EDITION_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_EDITION_OTHER_PROVIDER'),
				"CONFIRM_SUBMISSION" => $this->getUser() && $this->getUser()->isAllowed('CONFIRM_SUBMISSION')
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
	 * @Route("/ajaxgetresultrows", name="query_get_result_rows")
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

		$resultRows = $this->get('ogam.query_service')->getResultRowsGinco($start, $length, $sortObj["property"], $sortObj["direction"], $request->getSession(), $userInfos, $this->get('ogam.locale_listener')
			->getLocale());

		// Send the result as a JSON String
		return new JsonResponse([
			'success' => true,
			'total' => $request->getSession()->get('query_Count'),
			'data' => $resultRows
		]);
	}

	/**
	 * AJAX function : Return the list of a location information.
	 * MIGRATION_IN_PROGRESS
	 *
	 * @Route("/ajaxgetlocationinfo", name="query_get_location_info")
	 */
	public function ajaxgetlocationinfoAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetlocationinfoAction');
		try {
			$lon = $request->query->get('LON');
			$lat = $request->query->get('LAT');
			$activeLayers = $request->query->get('layers');
			if (empty($lon) || empty($lat) || empty($activeLayers)) {
				throw new \InvalidArgumentException("The 'LON', 'LAT' and 'layers' parameters are required.");
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

			if ($request->getSession()->get('query_Count', 0) == 0) {
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
				$locations = $this->get('ogam.query_service')->getLocationInfo($sessionId, $lon, $lat, $locationField, $schema, $this->get('ogam.configuration_manager'), $locale, $activeLayers, $resultsLayer);
				// $resultsLayers is the most precise layer where we have found results
				if ($resultsLayer) {
					$resultsLayer = 'result_' . $resultsLayer; // real name
					$layerRepo = $this->getDoctrine()->getRepository(Layer::class);
					$layer = $layerRepo->findOneBy(array(
						'name' => $resultsLayer
					));
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
						"layerLabel" => $layer->getLabel(),
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
	 * @Route("/ajaxgetpredefinedrequestlist", name="query_get_predefined_request_list")
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
	 * @Route("/ajaxgetpredefinedrequestcriteria", name="query_get_predefined_request_criteria")
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
	 * @Route("/getgridparameters", name="query_get_grid_parameters")
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
	 * @Route("/ajaxgetdetails", name="query_get_details")
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
					->getProvider() : NULL,
				"DATA_EDITION" => $this->getUser() && $this->getUser()->isAllowed('DATA_EDITION')
			];

			// Bbox key is retrieved from POST
			$bbox = $request->get('bbox');

			$response = new Response();
			$response->headers->set('Content-Type', 'application/json');
			return $this->render('IgnGincoBundle:Query:ajaxgetdetails.json.twig', array(
				'data' => $this->get('ogam.query_service')
					->getDetailsDataGinco($id, $detailsLayers, $datasetId, $bbox, true, $userInfos)
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
	 * Returns a csv file corresponding to the requested data.
	 * Fields are empty when the user doesn't have the right to view them.
	 * (same as "hidden" in the result array).
	 *
	 * @Route("/csv-export", name="query_csv_export")
	 */
	public function csvExportAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('csvExportAction');

		$user = $this->getUser();
		$schema = $this->get('ogam.schema_listener')->getSchema();
		$websiteSession = $request->getSession();

		$requestId = $this->getDoctrine()
			->getManager('mapping')
			->getRepository('IgnGincoBundle:Mapping\Request')
			->getLastRequestIdFromSession(session_id());

		// Configure memory and time limit because the program ask a lot of resources
		$configuration = $this->get('ogam.configuration_manager');
		ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', '480'));

		// Number of results to export
		$total = $websiteSession->get('query_Count');
		$logger->debug('Expected lines : ' . $total);

		// Query by $maxLines batches
		$maxLines = 5000;

		// Start writing output (CSV file)
		$content = "";

		// Define the header of the response
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');

		// Prepend the Byte Order Mask to inform Excel that the file is in UTF-8
		if ($charset === 'UTF-8') {
			$content = chr(0xEF) . chr(0xBB) . chr(0xBF);
		}

		if (($schema == 'RAW_DATA' && !$user->isAllowed('EXPORT_RAW_DATA'))) {
			$content .= iconv("UTF-8", $charset, ('// No Permissions'));
		} else if ($total > 65535) {
			$content .= iconv("UTF-8", $charset, ('// Too many result lines (>65535)'));
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

			// Get the request from the session
			$queryForm = $request->getSession()->get('query_QueryForm');

			// Get the mappings for the query form fields
			$queryForm = $this->get('ogam.query_service')->setQueryFormFieldsMappings($queryForm);

			// Display the default message
			$content .= iconv("UTF-8", $charset, '// *************************************************' . "\n");
			$content .= iconv("UTF-8", $charset, '// ' . $this->get('translator')->trans('Data Export') . "\n");
			$content .= iconv("UTF-8", $charset, '// *************************************************' . "\n\n");

			// Request criterias
			$content .= iconv("UTF-8", $charset, $this->csvExportCriterias($request));
			$content .= iconv("UTF-8", $charset, "\n");

			// Export the column names
			$line = array();
			foreach ($queryForm->getColumns() as $genericFormField) {
				$genericTableField = $queryForm->getFieldMappingSet()->getDstField($genericFormField);
				$tableField = $genericTableField->getMetadata();
				$line[] = $tableField->getLabel();
				$content .= iconv("UTF-8", $charset, $tableField->getLabel() . ';');
			}
			$content .= iconv("UTF-8", $charset, "\n");

			$pagesTotal = ceil($total / $maxLines);

			for ($page = 0; $page < $pagesTotal; $page ++) {

				$userInfos = [
					"DATA_QUERY_OTHER_PROVIDER" => $user && $user->isAllowed('DATA_QUERY_OTHER_PROVIDER')
				];

				// Get requested data
				// they come in the form of a json; convert them associative array and then to csv
				$data = $this->get('ogam.query_service')->getResultRowsGinco($page * $maxLines, $maxLines, null, null, $request->getSession(), $userInfos, $this->get('ogam.locale_listener')
					->getLocale());

				if ($data != null) {
					// Write each line in the csv
					foreach ($data as $line) {
						// keep only the first count($resultColumns), because there is 2 or 3 technical fields sent back (after the result columns).
						$line = array_slice($line, 0, count($queryForm->getColumns()));
						// implode all arrays
						foreach ($line as $index => $value) {
							if (is_array($value)) {
								$line[$index] = join(",", $value); // just use join because we don't want double enclosure...
							}
						}
						// Write csv line to output
						$outputLine = $arrayToCsv($line, ';', '"');
						$content .= iconv("UTF-8", $charset, $outputLine);
					}
				}
			}
		}
		$response = new Response($content, 200);
		$response->headers->set('Content-Type', 'text/csv;charset=' . $charset . ';application/force-download;');
		$response->headers->set('Content-disposition', 'attachment; filename=DataExport_' . date('Ymd_Hi') . '.csv');

		return $response;
	}

	/**
	 * Export the request criterias in the CSV file.
	 *
	 * @return String the criterias
	 */
	protected function csvExportCriterias(Request $request) {
		$criteriasLine = "";

		// Get the request from the session
		$queryForm = $request->getSession()->get('query_QueryForm');

		if ($queryForm->getCriteria()) {
			$criteriasLine .= '// ' . $this->get('translator')->trans('Request Criterias') . "\n";
		}

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
	 * KML export is not defined in GINCO because of the hiding of geometry
	 * @Route("/kml-export", name="query_kml_export")
	 */
	public function kmlExportAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('kmlExportAction');

		$charset = $this->get('ogam.configuration_manager')->getConfig('csvExportCharset', 'UTF-8');

		$content = iconv("UTF-8", $charset, "// L'export KML n'est pas prévu dans GINCO, merci de contacter l'administrateur.");

		$response = new Response($content, 200);
		$response->headers->set('Content-Type', 'application/vnd.google-earth.kml+xml;charset=' . $charset . ';application/force-download;');
		$response->headers->set('Content-disposition', 'attachment; filename=DataExport_' . date('Ymd_Hi') . '.kml');

		return $response;
	}

	/**
	 * GeoJson export is not defined in GINCO
	 * @Route("/geojson-export", name="query_geojson_export")
	 */
	public function geojsonExportAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('geojsonExportAction');

		// Define the header of the response
		$charset = $this->get('ogam.configuration_manager')->getConfig('csvExportCharset', 'UTF-8');

		$content = iconv("UTF-8", $charset, "// L'export GeoJson n'est pas prévu dans GINCO, merci de contacter l'administrateur.");

		$response = new Response($content, 200);
		$response->headers->set('Content-Type', 'application/json;charset=' . $charset . ';application/force-download;');
		$response->headers->set('Content-disposition', 'attachment; filename=DataExport_' . date('Ymd_Hi') . '.geojson');

		return $response;
	}

	/**
	 * AJAX function : Nodes of a tree under a given node and for a given unit.
	 *
	 * @Route("/ajaxgettreenodes", name="query_get_treenodes")
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
	 * @Route("/ajaxgettaxrefnodes", name="query_get_taxref_nodes")
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
	 * @Route("/ajaxgetdynamiccodes", name="query_get_dynamic_codes")
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
	 * @Route("/ajaxgetcodes", name="query_get_codes")
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
	 * @Route("/ajaxgettreecodes", name="query_get_tree_codes")
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
	 * @Route("/ajaxgettaxrefcodes", name="query_get_taxref_codes")
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
