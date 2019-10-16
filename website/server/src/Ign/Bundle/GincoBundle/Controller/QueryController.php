<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Doctrine\DBAL\Exception\UniqueConstraintViolationException;
use Ign\Bundle\GincoBundle\Entity\Mapping\Result;
use Ign\Bundle\GincoBundle\Entity\Generic\GenericField;
use Ign\Bundle\GincoBundle\Entity\Generic\QueryForm;
use Ign\Bundle\GincoBundle\Entity\Mapping\Layer;
use Ign\Bundle\GincoBundle\Entity\Metadata\Data;
use Ign\Bundle\GincoBundle\Entity\Metadata\Dynamode;
use Ign\Bundle\GincoBundle\Entity\Metadata\FormField;
use Ign\Bundle\GincoBundle\Entity\Metadata\FormFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\Format;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableField;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableTree;
use Ign\Bundle\GincoBundle\Entity\Metadata\Unit;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Method;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\Exception\BadCredentialsException;

/**
 * @Route("/query")
 */
class QueryController extends GincoController {

	/**
	 * @Route("/index", name = "query_home")
	 * The "/" route is disabled for security raison (see security.yml)
	 */
	public function indexAction(Request $request) {
		return $this->redirectToRoute('query_show-query-form', [
			'tab' => $request->query->get('tab')
		]);
	}

	/**
	 * Show the main query page.
	 *
	 * @Route("/show-query-form", name = "query_show-query-form")
	 */
	public function showQueryFormAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
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
	 * @Route("/ajaxgetdatasets")
	 */
	public function ajaxgetdatasetsAction(Request $request) {
		$this->get('monolog.logger.ginco')->debug('ajaxgetdatasetsAction');
		return new JsonResponse($this->get('ginco.manager.query')->getDatasets($this->getUser()));
	}

	/**
	 * @Route("/ajaxresetresult")
	 */
	public function ajaxresetresultAction() {
		$this->get('monolog.logger.ginco')->debug('ajaxresetresultAction');
		
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
	 * @Route("/ajaxgetqueryform")
	 */
	public function ajaxgetqueryformAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgetqueryformAction');
		
		$filters = json_decode($request->query->get('filter'));
		
		$datasetId = null;
		$requestId = null;
		
		if (is_array($filters)) {
			foreach ($filters as $aFilter) {
				switch ($aFilter->property) {
					case 'processId':
						$datasetId = $aFilter->value;
						break;
					case 'request_id':
						$requestId = $aFilter->value;
						break;
					default:
						$logger->debug('filter unattended : ' . $aFilter->property);
				}
			}
		} else {
			$datasetId = json_decode($request->query->get('datasetId'));
			$requestId = $request->request->get('request_id');
		}
		
		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('IgnGincoBundle:Query:ajaxgetqueryform.json.twig', array(
			'forms' => $this->get('ginco.manager.query')
				->getQueryForms($datasetId, $requestId)
		), $response);
	}

	/**
	 * AJAX function : Get the list of criteria or columns available for a process form.
	 *
	 * @Route("/ajaxgetqueryformfields")
	 */
	public function ajaxgetqueryformfieldsAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgetqueryformfieldsAction');
		
		$filters = json_decode($request->query->get('filter'));
		
		$datasetId = null;
		
		if (is_array($filters)) {
			foreach ($filters as $aFilter) {
				switch ($aFilter->property) {
					case 'processId':
						$datasetId = $aFilter->value;
						break;
					case 'form':
						$formFormat = $aFilter->value;
						break;
					case 'fieldsType':
						$fieldsType = $aFilter->value;
						break;
					default:
						$logger->debug('filter unattended : ' . $aFilter->property);
				}
			}
		}
		
		$query = $request->query->get('query');
		$start = $request->query->get('start');
		$limit = $request->query->get('limit');
		
		$schema = $this->get('ginco.schema_listener')->getSchema();
		$locale = $this->get('ginco.locale_listener')->getLocale();
		
		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('IgnGincoBundle:Query:ajaxgetqueryformfields.json.twig', array(
			'fieldsType' => $fieldsType,
			'list' => $this->getDoctrine()
				->getRepository(FormField::class)
				->getFormFields($datasetId, $formFormat, $schema, $locale, $query, $start, $limit, $fieldsType),
			'count' => $this->getDoctrine()
				->getRepository(FormField::class)
				->getFormFieldsCount($datasetId, $formFormat, $schema, $locale, $query, $fieldsType)
		), $response);
	}

	/**
	 * AJAX function : Builds the query.
	 * OK Migrated. TODO : Check the TODO in the code.
	 *
	 * @Route("/ajaxbuildrequest", name="query_build_request")
	 */
	public function ajaxbuildrequestAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
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
				if (strpos($inputName, "criteria__") === 0 && !$this->get('ginco.query_service')->isEmptyCriteria($inputValue)) {
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
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgetresultsbboxAction');
		
		$configuration = $this->get('ginco.configuration_manager');
		ini_set("max_execution_time", $configuration->getConfig('max_execution_time', 480));
		try {
			$grandPublicRole = $this->getDoctrine()
				->getManager('website')
				->getRepository('IgnGincoBundle:Website\Role')
				->findByLabel('Grand public');
			// Get the request from the session
			$queryForm = $request->getSession()->get('query_QueryForm');
			// Get the mappings for the query form fields
			$queryForm = $this->get('ginco.query_service')->setQueryFormFieldsMappings($queryForm);
			
			// Call the service to get the definition of the columns
			$userInfos = [
				"providerId" => $this->getUser() ? $this->getUser()->getProvider() : NULL,
				"hasGrandPublicRole" => in_array($grandPublicRole, $this->getUser()->getRoles()),
				"DATA_QUERY" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY'),
				"DATA_QUERY_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY_OTHER_PROVIDER'),
				"EDIT_DATA_OWN" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_OWN'),
				"EDIT_DATA_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_PROVIDER'),
				"EDIT_DATA_ALL" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_ALL')
			];
			
			$where = $request->getSession()->get('query_SQLWhere');
			$from = $request->getSession()->get('query_SQLFrom');
			$logger->info('where :' . $where);
			$logger->info('from : ' . $from);
				
			$resultCount = $this->get('ginco.query_service')->prepareResults($from, $where, $queryForm, $this->getUser(), $userInfos, $request->getSession());
			
			if ($resultCount > $configuration->getConfig('max_results', 5000)) {
				return new JsonResponse([
					'success' => false,
					'count' => $resultCount
				]);
			} else {
				// Execute the request
				$sessionId = $request->getSession()->getId();
				$projection = $configuration->getConfig('srs_visualisation', 3857);
				$logger->info('getResultsBBox session_id : ' . $sessionId . ', projection : ' . $projection);
				
				$mapRepo = $this->get('ginco.repository.mapping.map');
				$resultsBbox = $mapRepo->getResultsBbox($projection, $sessionId);
				
				// Send the result as a JSON String
				return new JsonResponse([
					'success' => true,
					'resultsbbox' => $resultsBbox
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
	 * AJAX function : Return the results features bounding box in order to zoom on the features.
	 * MIGRATED.
	 *
	 * @Route("/ajaxgetobservationbbox", name="query_get_observation_bbox")
	 */
	public function ajaxgetobservationbboxAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$observationId = $request->request->get('observationId');
		$logger->debug('ajaxgetobservationbboxAction : ' . $observationId);
		$locale = $this->get('ginco.locale_listener')->getLocale();
		
		try {
			$bbox = $this->get('ginco.query_service')->getObservationBoundingBox($observationId, $request->getSession(), $this->getUser(), $locale);
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
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgetresultcolumns');
		
		try {
			$grandPublicRole = $this->getDoctrine()
				->getManager('website')
				->getRepository('IgnGincoBundle:Website\Role')
				->findByLabel('Grand public');
			// Get the request from the session
			$queryForm = $request->getSession()->get('query_QueryForm');
			// Get the mappings for the query form fields
			$queryForm = $this->get('ginco.query_service')->setQueryFormFieldsMappings($queryForm);
			// Get the request id
			$requestId = $this->getDoctrine()
				->getManager('mapping')
				->getRepository('IgnGincoBundle:Mapping\Request')
				->getLastRequestIdFromSession(session_id());
			// Get the maximum precision level
			$maxPrecisionLevel = $this->get('ginco.query_service')->getMaxPrecisionLevel($queryForm->getCriteria());
			// Call the service to get the definition of the columns
			$userInfos = [
				"providerId" => $this->getUser() ? $this->getUser()->getProvider() : NULL,
				"hasGrandPublicRole" => in_array($grandPublicRole, $this->getUser()->getRoles()),
				"DATA_QUERY" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY'),
				"DATA_QUERY_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY_OTHER_PROVIDER'),
				"EDIT_DATA_OWN" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_OWN'),
				"EDIT_DATA_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_PROVIDER'),
				"EDIT_DATA_ALL" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_ALL')
			];
			
			$this->get('ginco.query_service')->buildRequestGinco($queryForm, $userInfos, $maxPrecisionLevel, $requestId, $request->getSession());
			
			$response = new Response();
			$response->headers->set('Content-Type', 'application/json');
			return $this->render('IgnGincoBundle:Query:ajaxgetresultcolumns.json.twig', array(
				'columns' => $this->get('ginco.query_service')
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
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgetresultrows');
		
		// Get the datatable parameters
		$start = $request->request->getInt('start');
		$length = $request->request->getInt('limit');
		$sort = $request->request->get('sort');
		$sortObj = json_decode($sort, true)[0];
		
		// Call the service to get the definition of the columns
		$userInfos = [
			"DATA_QUERY_OTHER_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('DATA_QUERY_OTHER_PROVIDER'),
			"EDIT_DATA_OWN" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_OWN'),
			"EDIT_DATA_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_PROVIDER'),
			"EDIT_DATA_ALL" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_ALL')
		];
		
		$resultRows = $this->get('ginco.query_service')->getResultRowsGinco($start, $length, $sortObj["property"], $sortObj["direction"], $request->getSession(), $userInfos, $this->get('ginco.locale_listener')
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
		$logger = $this->get('monolog.logger.ginco');
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
				$schema = $this->get('ginco.schema_listener')->getSchema();
				$locale = $this->get('ginco.locale_listener')->getLocale();
				$queryForm = $request->getSession()->get('query_QueryForm');
				// Get the mappings for the query form fields
				$queryForm = $this->get('ginco.query_service')->setQueryFormFieldsMappings($queryForm);
				
				// Get the location table information
				$tables = $this->get('ginco.generic_service')->getAllFormats($schema, $queryForm->getFieldMappingSet()
					->getFieldMappingArray()); // Extract the location table from the last query
				$locationField = $this->getDoctrine()
					->getRepository(TableField::class)
					->getGeometryField($schema, array_keys($tables), $locale); // Extract the location field from the available tables
				$locationTableInfo = $this->getDoctrine()
					->getRepository(TableFormat::class)
					->getTableFormat($schema, $locationField->getFormat()
					->getFormat(), $locale); // Get info about the location table
                $children = $this->getDoctrine()->getRepository('IgnGincoBundle:Metadata\TableTree')->findChildren($locationTableInfo) ;
					                         
				// Get the intersected locations
				$locations = $this->get('ginco.query_service')->getLocationInfo($sessionId, $lon, $lat, $locationField, $schema, $this->get('ginco.configuration_manager'), $locale, $activeLayers, $resultsLayer);
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
                            if (!empty($children)) {
                                foreach ($children as $child) {
                                    $childFields = $this->getDoctrine()->getRepository(TableField::class)->getTableFields($schema, $child->getChildTable(), null, $locale) ;
                                    $tableFields = array_merge($tableFields, $childFields) ;
                                }
                            }
							$tFOrdered = array();
							foreach ($tableFields as $tableField) {
								$tFOrdered[strtoupper($tableField->getColumnName())] = $tableField;
							}
							foreach ($location as $columnName => $value) {
								$tableField = $tFOrdered[strtoupper($columnName)];
								// Set the column model and the location fields
								$dataIndex = $tableField->getName();
								// Adds the column header to prevent it from being truncated too and 2 for the header margins
								$columnsMaxLength[$columnName][] = strlen($tableField->getData()->getLabel()) + 2;
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
	 * Get the parameters used to initialise the result grid.
	 * @Route("/getgridparameters", name="query_get_grid_parameters")
	 */
	public function getgridparametersAction() {
		$viewParam = array();
		$viewParam['hideGridCsvExportMenuItem'] = true; // By default the export is hidden
		$viewParam['hideGridDataEditButton'] = true;
		$viewParam['checkEditionRights'] = true; // By default, we don't check for rights on the data
		
		$user = $this->getUser();
		$schema = $this->get('ginco.schema_listener')->getSchema();
		
		if ($schema == 'RAW_DATA' && $user->isAllowed('EXPORT_RAW_DATA')) {
			$viewParam['hideGridCsvExportMenuItem'] = false;
		}
		if ($schema == 'RAW_DATA' && $this->isGranted("EDIT_DATA")) {
			$viewParam['hideGridDataEditButton'] = false;
		}
		if ($user->isAllowed('EDIT_DATA_ALL')) {
			$viewParam['checkEditionRights'] = false;
		}
		
		$response = new Response();
		$response->headers->set('Content-type', 'application/javascript');
		return $this->render('IgnGincoBundle:Query:getgridparameters.html.twig', $viewParam, $response);
	}

	/**
	 * Get the details associed with a result line (clic on the "detail button").
	 *
	 * @Route("/ajaxgetdetails", name="query_get_details")
	 */
	public function ajaxgetdetailsAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
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
				"providerId" => $this->getUser() ? $this->getUser()->getProvider() : NULL,
				"EDIT_DATA_OWN" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_OWN'),
				"EDIT_DATA_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_PROVIDER'),
				"EDIT_DATA_ALL" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_ALL')
			];
			
			// Bbox key is retrieved from POST
			$bbox = $request->get('bbox');
			
			$response = new Response();
			$response->headers->set('Content-Type', 'application/json');
			return $this->render('IgnGincoBundle:Query:ajaxgetdetails.json.twig', array(
				'data' => $this->get('ginco.query_service')
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
			$trad = $this->get('ginco.generic_service')->getValueLabel($tableField, $value);
			
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
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('csvExportAction');
		
		$user = $this->getUser();
		$schema = $this->get('ginco.schema_listener')->getSchema();
		
		$configuration = $this->get('ginco.configuration_manager');
		
		// Number of results to export
		$total = $request->getSession()->get('query_Count');
		$logger->debug('Expected lines : ' . $total);
		
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
			$queryForm = $this->get('ginco.query_service')->setQueryFormFieldsMappings($queryForm);
			
			// Display the default message
			$content .= iconv("UTF-8", $charset, '// *************************************************' . "\n");
			$content .= iconv("UTF-8", $charset, '// ' . $this->get('translator')->trans('Data Export') . "\n");
			$content .= iconv("UTF-8", $charset, '// *************************************************' . "\n\n");
			
			// Request criterias
			$content .= iconv("UTF-8", $charset, $this->get('ginco.export_csv')->csvExportCriterias($request));
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
			
			$userInfos = [
				"DATA_QUERY_OTHER_PROVIDER" => $user && $user->isAllowed('DATA_QUERY_OTHER_PROVIDER'),
				"EDIT_DATA_OWN" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_OWN'),
				"EDIT_DATA_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_PROVIDER'),
				"EDIT_DATA_ALL" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_ALL')
			];
			
			// Get requested data
			// they come in the form of a json; convert them associative array and then to csv
			// C'est ça qui prend du temps (notamment récupérer le label de chaque code...)
			$data = $this->get('ginco.query_service')->getResultRowsGinco(0, 150, null, null, $request->getSession(), $userInfos, $this->get('ginco.locale_listener')
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
		
		$filename = pathinfo($this->get('ginco.export_csv')->generateFilePath(), PATHINFO_BASENAME);
		
		$response = new Response($content, 200);
		$response->headers->set('Content-Type', 'text/csv;charset=' . $charset . ';application/force-download;');
		$response->headers->set('Content-disposition', 'attachment; filename=' . $filename);
		
		return $response;
	}

	/**
	 * Returns a csv file corresponding to the requested data.
	 * Fields are empty when the user doesn't have the right to view them.
	 * (same as "hidden" in the result array).
	 *
	 * @Route("/csv-asyn-export", name="query_csv_asyn_export")
	 */
	public function csvAsynchronousExportAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('csvAsynchronousExportAction');
		
		try {
			$user = $this->getUser();
			$schema = $this->get('ginco.schema_listener')->getSchema();
			
			if (($schema == 'RAW_DATA' && !$user->isAllowed('EXPORT_RAW_DATA'))) {
				return new JsonResponse([
					'success' => false,
					'errorMessage' => "No permissions"
				]);
			} else {
				// Publish the message to RabbitMQ
				$messageId = $this->get('old_sound_rabbit_mq.ginco_generic_producer')->publish('exportCSV', [
					'request' => $request,
					'userInfos' => [
						"providerId" => $this->getUser() ? $this->getUser()
							->getProvider() : NULL,
						"email" => $this->getUser() ? $this->getUser()
							->getEmail() : NULL,
						"DATA_QUERY_OTHER_PROVIDER" => $user && $user->isAllowed('DATA_QUERY_OTHER_PROVIDER'),
						"EDIT_DATA_OWN" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_OWN'),
						"EDIT_DATA_PROVIDER" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_PROVIDER'),
						"EDIT_DATA_ALL" => $this->getUser() && $this->getUser()->isAllowed('EDIT_DATA_ALL'),
						"EXPORT_RAW_DATA" => $user && $user->isAllowed('EXPORT_RAW_DATA')
					]
				]);
				
				return new JsonResponse([
					'success' => true,
					'messageId' => $messageId
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
	 * AJAX function : Nodes of a tree under a given node and for a given unit.
	 *
	 * @Route("/ajaxgettreenodes", name="query_get_treenodes")
	 */
	public function ajaxgettreenodesAction(Request $request) {
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgettreenodesAction');
		try {
			$unitCode = $request->get('unit');
			$code = $request->request->get('node');
			$depth = $request->get('depth');
			if (empty($unitCode) || empty($code) || empty($depth)) {
				throw new \InvalidArgumentException("The 'unit', 'node' and 'depth' parameters are required.");
			}
			$em = $this->get('doctrine.orm.metadata_entity_manager');
			$locale = $this->get('ginco.locale_listener')->getLocale();
			$unit = $em->find(Unit::class, $unitCode);
			$tree = $em->getRepository('IgnGincoBundle:Metadata\ModeTree')->getTreeChildrenModes($unit, $code, $depth ? $depth + 1 : 0, $locale);
			array_shift($tree);
			return $this->render('IgnGincoBundle:Query:ajaxgettreenodes.json.twig', array(
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
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgettaxrefnodesAction');
		try {
			$unitCode = $request->get('unit');
			$code = $request->request->get('node');
			$depth = $request->get('depth');
			if (empty($unitCode) || empty($code) || empty($depth)) {
				throw new \InvalidArgumentException("The 'unit', 'node' and 'depth' parameters are required.");
			}
			$em = $this->get('doctrine.orm.metadata_entity_manager');
			$locale = $this->get('ginco.locale_listener')->getLocale();
			$unit = $em->find(Unit::class, $unitCode);
			$tree = $em->getRepository('IgnGincoBundle:Metadata\ModeTaxref')->getTaxrefChildrenModes($unit, $code, $depth ? $depth + 1 : 0, $locale);
			array_shift($tree);
			return $this->render('IgnGincoBundle:Query:ajaxgettaxrefnodes.json.twig', array(
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
		$logger = $this->get('monolog.logger.ginco');
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
			$locale = $this->get('ginco.locale_listener')->getLocale();
			$modes = $em->getRepository(Dynamode::class)->getModesFilteredByLabel($unit, $query, $locale);
			
			$response = new JsonResponse();
			
			return $this->render('IgnGincoBundle:Query:ajaxgetcodes.json.twig', array(
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
		$logger = $this->get('monolog.logger.ginco');
		$logger->debug('ajaxgetcodesAction');
		try {
			$unitCode = $request->query->get('unit');
			$query = $request->query->get('query', null);
			if (empty($unitCode)) {
				throw new \InvalidArgumentException("The 'unit' parameter is required.");
			}
			
			$em = $this->get('doctrine.orm.metadata_entity_manager');
			$unit = $em->find(Unit::class, $unitCode);
			
			$locale = $this->get('ginco.locale_listener')->getLocale();
			
			if ($query === null) {
				$modes = $em->getRepository(Unit::class)->getModes($unit, $locale);
			} else {
				$modes = $em->getRepository('IgnGincoBundle:Metadata\Mode')->getModesFilteredByLabel($unit, $query, $locale);
			}
			
			$response = new JsonResponse();
			
			return $this->render('IgnGincoBundle:Query:ajaxgetcodes.json.twig', array(
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
		$logger = $this->get('monolog.logger.ginco');
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
			
			$locale = $this->get('ginco.locale_listener')->getLocale();
			
			// $em->getRepository(Unit::class)->getModesFilteredByLabel($unit, $query, $locale);
			$rows = $em->getRepository('IgnGincoBundle:Metadata\ModeTree')->getTreeModesSimilareTo($unit, $query, $locale, $start, $limit);
			if (count($rows) < $limit) {
				// optimisation
				$count = count($rows);
			} else {
				// TODO use a paginator ?
				$count = $em->getRepository('IgnGincoBundle:Metadata\ModeTree')->getTreeModesSimilareToCount($unit, $query, $locale);
			}
			return $this->render('IgnGincoBundle:Query:ajaxgettreecodes.json.twig', array(
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
		$logger = $this->get('monolog.logger.ginco');
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
			
			$locale = $this->get('ginco.locale_listener')->getLocale();
			
			$rows = $em->getRepository('IgnGincoBundle:Metadata\ModeTaxref')->getTaxrefModesSimilarTo($unit, $query, $locale, $start, $limit);
			if (count($rows) < $limit) {
				// optimisation
				$count = count($rows);
			} else {
				$count = $em->getRepository('IgnGincoBundle:Metadata\ModeTaxref')->getTaxrefModesCount($unit, $query, $locale);
			}
			return $this->render('IgnGincoBundle:Query:ajaxgettaxrefcodes.json.twig', array(
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
