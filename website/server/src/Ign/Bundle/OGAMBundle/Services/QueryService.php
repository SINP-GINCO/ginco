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
use Ign\Bundle\OGAMBundle\Entity\Website\User;
use Ign\Bundle\OGAMBundle\Repository\GenericRepository;
use Symfony\Component\HttpFoundation\Session\Session;
use Doctrine\ORM\NoResultException;
use Ign\Bundle\OGAMBundle\OGAMBundle;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FormFormat;
use Ign\Bundle\OGAMBundle\Entity\Mapping\LayerService;
use Ign\Bundle\OGAMBundle\Entity\Mapping\Layer;
use Ign\Bundle\OGAMBundle\Entity\Generic\BoundingBox;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequest;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Format;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequestGroupAsso;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequestGroup;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequestCriterion;
use Ign\Bundle\OGAMBundle\Entity\Website\PredefinedRequestColumn;
use Symfony\Component\HttpFoundation\ParameterBag;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Data;

/**
 * The Query Service.
 *
 * This service handles the queries used to feed the query interface with ajax requests.
 */
class QueryService {

	/**
	 * The logger.
	 *
	 * @var Logger
	 */
	protected $logger;

	/**
	 * The locale.
	 *
	 * @var locale
	 */
	protected $locale;

	/**
	 * The schema.
	 *
	 * @var schema
	 */
	protected $schema;

	/**
	 */
	protected $configuration;

	/**
	 *
	 * @var GenericService
	 */
	protected $genericService;

	/**
	 * The models.
	 *
	 * @var EntityManager
	 */
	protected $metadataModel;

	/**
	 * The doctrine service
	 *
	 * @var Service
	 */
	protected $doctrine;

	/**
	 * The generic manager
	 *
	 * @var genericModel
	 */
	protected $genericModel;

	function __construct($doctrine, $genericService, $configuration, $logger, $locale, $schema, $genericModel) {
		// Initialise the logger
		$this->logger = $logger;

		// Initialise the locale
		$this->locale = $locale;

		// Initialise the schema
		$this->schema = $schema;

		$this->genericService = $genericService;

		$this->configuration = $configuration;

		$this->doctrine = $doctrine;

		$this->genericModel = $genericModel;

		// Initialise the metadata models
		$this->metadataModel = $this->doctrine->getManager('metadata');
	}

	/**
	 * Get the list of available datasets for a given user.
	 *
	 * @return [Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset] The list of datasets
	 */
	public function getDatasets(User $user = null) {
		return $this->metadataModel->getRepository(Dataset::class)->getDatasetsForDisplay($this->locale, $user);
	}

	/**
	 * TODO: Get the list of available forms and criterias for the dataset.
	 *
	 * @param String $datasetId
	 *        	the identifier of the selected dataset
	 * @param String $requestId
	 *        	the id of the predefined request if available
	 * @return FormFormat[]
	 */
	public function getQueryForms($datasetId, $requestId) {
		if (!empty($requestId)) {
			// If request name is filled then we are coming from the predefined request screen
			// and we build the form corresponding to the request
			return $this->_getPredefinedRequest($requestId);
		} else {
			// Otherwise we get all the fields available with their default value
			return $this->metadataModel->getRepository(FormFormat::class)->getFormFormats($datasetId, $this->schema, $this->locale);
		}
	}

	/**
	 * Get the predefined request.
	 *
	 * @param String $requestId
	 *        	The request id
	 * @return Forms
	 */
	protected function _getPredefinedRequest($requestId) {
		$this->logger->debug('_getPredefinedRequest');

		// Get the predefined request
		$predefinedRequest = $this->doctrine->getRepository(PredefinedRequest::class)->getPredefinedRequest($requestId, $this->locale);

		// Get the default values for the forms
		$forms = $this->metadataModel->getRepository(FormFormat::class)->getFormFormats($predefinedRequest->getDatasetId()
			->getId(), $this->schema, $this->locale);

		// Update the default values with the saved values.
		foreach ($forms as $form) {
			foreach ($form->getCriteria() as $criterion) {
				$criterion->setIsDefaultCriteria(FALSE);
				$criterion->setDefaultValue('');

				if ($predefinedRequest->hasCriterion($criterion->getName())) {
					$pRCriterion = $predefinedRequest->getCriterion($criterion->getName());
					$criterion->setIsDefaultCriteria(TRUE);
					$criterion->setDefaultValue($pRCriterion->getValue());
					$criterion->getData()
						->getUnit()
						->setModes($pRCriterion->getData()
						->getUnit()
						->getModes());
				}
			}

			foreach ($form->getColumns() as $column) {
				$column->setIsDefaultResult(FALSE);

				if ($predefinedRequest->hasColumn($column->getName())) {
					$column->setIsDefaultResult(TRUE);
				}
			}
		}

		// return the forms
		return $forms;
	}
	
	/**
	 * Check if a criteria is empty.
	 * (not private as this function is extended in custom directory of derivated applications)
	 *
	 * @param Undef $criteria
	 * @return true if empty
	 */
	public function isEmptyCriteria($criteria) {
	    if (is_array($criteria)) {
	        $emptyArray = true;
	        foreach ($criteria as $value) {
	            if ($value != "") {
	                $emptyArray = false;
	            }
	        }
	        return $emptyArray;
	    } else {
	        return ($criteria == "");
	    }
	}
	
	/**
	 * Update and persist a predefined request object.
	 *
	 * @param PredefinedRequest $pr The predefined request
	 * @param string $datasetId The dataset id
	 * @param string $label The request label
	 * @param string $definition The request definition
	 * @param string $isPublic The request privacy
	 */
	public function updatePredefinedRequest (PredefinedRequest $pr, $datasetId, $label, $definition, $isPublic, User $user = null) {
	    $em = $this->doctrine->getManager();
	    $datasetRepository = $em->getRepository(Dataset::class);
	    $dataset = $datasetRepository->find($datasetId);
	    $pr->setDatasetId($dataset);
	    $pr->setSchemaCode($this->schema);
	    $pr->setLabel($label);
	    $pr->setDefinition($definition);
	    $pr->setIsPublic($isPublic);
	    $pr->setDate(new \DateTime());
		if ($user)
		    $pr->setUserLogin($user);
	    $em->persist($pr);
	}
	
	/**
	 * Delete the predefined request group association.
	 *
	 * @param PredefinedRequest $pr The predefined request
	 */
	public function deletePRGroupAssociations (PredefinedRequest $pr) {
	    $em = $this->doctrine->getManager();
	    $groupAssoRepo = $em->getRepository(PredefinedRequestGroupAsso::class);
	    $groupAssos = $groupAssoRepo->findBy(["requestId" => $pr->getRequestId()]);
	    foreach ($groupAssos as $index => $groupAsso) {
	        $em->remove($groupAsso);
	    }
	}
	
	/**
	 * Create and persist the predefined request group association.
	 *
	 * @param PredefinedRequest $pr The predefined request
	 * @param string $groupId The group id
	 */
	public function createPRGroupAssociation (PredefinedRequest $pr, $groupId) {
	    $em = $this->doctrine->getManager();
	    $ga = new PredefinedRequestGroupAsso();
	    $ga->setRequestId($pr);
	    $groupRepository = $em->getRepository(PredefinedRequestGroup::class);
	    $group = $groupRepository->find($groupId);
	    $ga->setGroupId($group);
	    $ga->setPosition(1);
	    $em->persist($ga);
	}
	
	/**
	 * Delete the predefined request criteria.
	 *
	 * @param PredefinedRequest $pr The predefined request
	 */
	public function deletePRCriteria (PredefinedRequest $pr) {
	    $em = $this->doctrine->getManager();
	    $prCriterionRepo = $em->getRepository(PredefinedRequestCriterion::class);
	    $criteria = $prCriterionRepo->findBy(["requestId" => $pr->getRequestId()]);
	    foreach ($criteria as $index => $criterion) {
	        $em->remove($criterion);
	    }
	}
	
	/**
	 * Delete the predefined request columns.
	 *
	 * @param PredefinedRequest $pr The predefined request
	 */
	public function deletePRColumns (PredefinedRequest $pr) {
	    $em = $this->doctrine->getManager();
	    $prColumnRepo = $em->getRepository(PredefinedRequestColumn::class);
	    $columns = $prColumnRepo->findBy(["requestId" => $pr->getRequestId()]);
	    foreach ($columns as $index => $column) {
	        $em->remove($column);
	    }
	}
	
	/**
	 * Create and persist the predefined request criteria and columns.
	 *
	 * @param PredefinedRequest $pr The predefined request
	 * @param ParameterBag $r The request parameter bag
	 */
	public function createPRCriteriaAndColumns (PredefinedRequest $pr, ParameterBag $r) {
	    foreach ($r->all() as $inputName => $inputValue) {
	        // Create the criterion entities and add its
	        if (strpos($inputName, "criteria__") === 0) {
	            $criteriaName = substr($inputName, strlen("criteria__"));
	            $split = explode("__", $criteriaName);
	            $this->createPRCriterion($pr, $split[0], $split[1], $inputValue[0]);
	        }
	        // Create the column entities and add its
	        if (strpos($inputName, "column__") === 0) {
	            $columnName = substr($inputName, strlen("column__"));
	            $split = explode("__", $columnName);
	            $this->createPRColumns($pr, $split[0], $split[1]);
	        }
	    }
	}
	
	/**
	 * Create and persist the predefined request criteria.
	 *
	 * @param PredefinedRequest $pr The predefined request
	 * @param string $format The criterion format
	 * @param string $data The criterion data
	 * @param string $value The criterion value
	 */
	public function createPRCriterion (PredefinedRequest $pr, $format, $data, $value) {
	    $em = $this->doctrine->getManager();
	    $formatRepository = $em->getRepository(Format::class);
	    $dataRepository = $em->getRepository(Data::class);
	    $formFieldRepository = $em->getRepository(FormField::class);
	    $criterion = new PredefinedRequestCriterion();
	    $criterion->setRequestId($pr);
	    $format = $formatRepository->find($format);
	    $data = $dataRepository->find($data);
	    $formField = $formFieldRepository->find(['format' => $format, 'data' => $data]);
	    $criterion->setFormat($format);
	    $criterion->setData($data);
	    $criterion->setFormField($formField);
	    $criterion->setValue($value);
	    $em->persist($criterion);
	}
	
	/**
	 * Create and persist the predefined request columns.
	 *
	 * @param PredefinedRequest $pr The predefined request
	 * @param string $format The column format
	 * @param string $data The column data
	 */
	public function createPRColumns (PredefinedRequest $pr, $format, $data) {
	    $em = $this->doctrine->getManager();
	    $formatRepository = $em->getRepository(Format::class);
	    $dataRepository = $em->getRepository(Data::class);
	    $formFieldRepository = $em->getRepository(FormField::class);
	    $column = new PredefinedRequestColumn();
	    $column->setRequestId($pr);
	    $format = $formatRepository->find($format);
	    $data = $dataRepository->find($data);
	    $formField = $formFieldRepository->find(['format' => $format, 'data' => $data]);
	    $column->setFormat($format);
	    $column->setData($data);
	    $column->setFormField($formField);
	    $em->persist($column);
	}

	/**
	 * Copy the locations of the result in a temporary table.
	 *
	 * @param \OGAMBundle\Entity\Generic\QueryForm $queryForm
	 *        	the form request object
	 * @param Array $userInfos
	 *        	Few user informations
	 */
	public function prepareResultLocations($queryForm, $userInfos) {
		$this->logger->debug('prepareResultLocations');

		// Get the mappings for the query form fields
		$mappingSet = $queryForm->getFieldMappingSet();

		// Configure the projection systems
		$visualisationSRS = $this->configuration->getConfig('srs_visualisation', '3857');
		$visualisationSRS = '3857';

		// Generate the SQL Request
		$from = $this->genericService->generateSQLFromRequest($this->schema, $mappingSet);
		$where = $this->genericService->generateSQLWhereRequest($this->schema, $queryForm->getCriteria(), $mappingSet, $userInfos);

		// Clean previously stored results
		$sessionId = session_id();
		$this->logger->debug('SessionId : ' . $sessionId);
		$this->doctrine->getRepository(ResultLocation::class, 'mapping')->cleanPreviousResults($sessionId);

		// Identify the field carrying the location information
		$tables = $this->genericService->getAllFormats($this->schema, $mappingSet->getFieldMappingArray());
		$locationFields = $this->metadataModel->getRepository(TableField::class)->getGeometryFields($this->schema, array_keys($tables), $this->locale);
		foreach ($locationFields as $locationField) {
			$locationTableInfo = $this->metadataModel->getRepository(TableFormat::class)->getTableFormat($this->schema, $locationField->getFormat()
				->getFormat(), $this->locale);
			// Run the request to store a temporary result table (for the web mapping)
			$this->doctrine->getRepository(ResultLocation::class, 'result_location')->fillLocationResult($from . $where, $sessionId, $locationField, $locationTableInfo, $visualisationSRS);
		}
	}

	/**
	 * Build the request.
	 *
	 * @param QueryForm $queryForm
	 *        	the request form
	 * @param Array $userInfos
	 *        	Few user informations
	 * @param Session $session
	 *        	the current session
	 */
	public function buildRequest(QueryForm $queryForm, $userInfos, Session $session) {
		$this->logger->debug('buildRequest');

		// Get the mappings for the query form fields
		$mappingSet = $queryForm->getFieldMappingSet();

		// Generate the SQL Request
		$select = $this->genericService->generateSQLSelectRequest($this->schema, $queryForm->getColumns(), $mappingSet, $userInfos);
		$from = $this->genericService->generateSQLFromRequest($this->schema, $mappingSet);
		$where = $this->genericService->generateSQLWhereRequest($this->schema, $queryForm->getCriteria(), $mappingSet, $userInfos);
		$sqlPKey = $this->genericService->generateSQLPrimaryKey($this->schema, $mappingSet);

		// Identify the field carrying the location information
		$tables = $this->genericService->getAllFormats($this->schema, $mappingSet->getFieldMappingArray());
		$locationField = $this->metadataModel->getRepository(TableField::class)->getGeometryField($this->schema, array_keys($tables), $this->locale);

		$this->logger->debug('$select : ' . $select);
		$this->logger->debug('$from : ' . $from);
		$this->logger->debug('$where : ' . $where);

		// Calculate the number of lines of result
		$countResult = $this->getQueryResultsCount($from, $where);

		// Store the metadata in session for subsequent requests
		// $session->set('query_schema', $this->schema); used?
		// $session->set('query_queryForm', $queryForm); still done into the action ajaxbuildrequest
		// $session->set('query_QueryFormMappingSet', $select);
		$session->set('query_SQLSelect', $select);
		$session->set('query_SQLFrom', $from);
		$session->set('query_SQLWhere', $where);
		$session->set('query_SQLPkey', $sqlPKey);
		$session->set('query_locationField', $locationField); // used in the KML export
		$session->set('query_Count', $countResult); // result count

		// old
			                                            // $session->set('queryObject', $queryObject);
			                                            // $session->set('resultColumns', $queryObject->editableFields); Not need can be find with $queryForm->getColumns()
			                                            // $session->set('datasetId', $queryForm->getDatasetId());
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
	public function getQueryResultsCount($from, $where) {
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
	 * @param Array $userInfos
	 *        	Few user informations
	 * @return JSON
	 */
	public function getResultRows($start, $length, $sort, $sortDir, $session, $userInfos) {
		$this->logger->debug('getResultRows');

		// Get the request from the session
		$queryForm = $session->get('query_QueryForm');

		// Get the mappings for the query form fields
		$queryForm = $this->setQueryFormFieldsMappings($queryForm);

		// Retrieve the SQL request from the session
		$select = $session->get('query_SQLSelect');
		// Il ne doit pas y avoir de DISTINCT pour pouvoir faire un Index Scan
		$select = str_replace(" DISTINCT", "", $select);

		$from = $session->get('query_SQLFrom');
		$where = $session->get('query_SQLWhere');

		// Subquery (for getting desired rows)
		$pKey = $session->get('query_SQLPkey');
		$subquery = "SELECT " . $pKey . $from . $where;

		$order = "";
		if (!empty($sort)) {
			// $sort contains the form format and field
			$split = explode("__", $sort);
			$formField = new GenericField($split[0], $split[1]);
			$dstField = $queryForm->getFieldMappingSet()->getDstField($formField);
			$key = $dstField->getFormat() . "." . $dstField->getData();
			$order .= " ORDER BY " . $key . " " . $sortDir;
		} else {
			$order .= " ORDER BY " . $pKey;
		}

		$filter = "";
		if (!empty($length)) {
			$filter .= " LIMIT " . $length;
		}
		if (!empty($start)) {
			$filter .= " OFFSET " . $start;
		}

		// Build complete query
		$query = $select . $from . " WHERE (" . $pKey . ") IN (" . $subquery . $order . $filter . ")" . $order;

		// Execute the request
		$result = $this->getQueryResults($query);

		// Retrive the session-stored info
		$columnsDstFields = $queryForm->getColumnsDstFields();

		$resultRows = [];
		foreach ($result as $line) {
			$resultRow = [];
			foreach ($columnsDstFields as $columnDstField) {

				$tableField = $columnDstField->getMetadata();
				$key = strtolower($tableField->getName());
				$value = $line[$key];

				// Manage code traduction
				if ($tableField->getData()
					->getUnit()
					->getType() === "CODE" && $value != "") {
					$label = $this->genericService->getValueLabel($tableField, $value);
					$resultRow[] = $label === null ? '' : $label;
				} else if ($tableField->getData()
					->getUnit()
					->getType() === "ARRAY" && $value != "") {
					// Split the array items
					$arrayValues = explode(",", preg_replace("@[{-}]@", "", $value));
					$label = '';
					foreach ($arrayValues as $arrayValue) {
						$label .= $this->genericService->getValueLabel($tableField, $arrayValue);
						$label .= ',';
					}
					if ($label !== '') {
						$label = substr($label, 0, -1);
					}
					$label = '[' . $label . ']';

					$resultRow[] = $label === null ? '' : $label;
				} else {
					$resultRow[] = $value;
				}
			}

			// Add the line id
			$resultRow[] = $line['id'];

			// Add the location centroid in WKT
			$resultRow[] = $line['location_centroid']; // The last column is the location center

			// Add the provider id of the data
			if ($userInfos['DATA_EDITION_OTHER_PROVIDER'] || $userInfos['DATA_QUERY_OTHER_PROVIDER']) {
				$resultRow[] = isset($line['_provider_id']) ? $line['_provider_id'] : '';
			}

			$resultRows[] = $resultRow;
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
	 * ********************* EDITION ************************************************************************************
	 */

	/**
	 * Get the form fields for a data to edit.
	 *
	 * @param GenericTableFormat $data
	 *        	the data object to edit
	 * @return array Serializable.
	 */
	public function getEditForm($data, User $user = null) {
		$this->logger->debug('getEditForm');

		return $this->_generateEditForm($data, $user);
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
				$return->append($this->_generateEditField($formField, $tablefield, $user));
			}
		}
		foreach ($data->getFields() as $tablefield) {
			$formField = $this->genericService->getTableToFormMapping($tablefield); // get some info about the form
			if (!empty($formField)) {
				$return->append($this->_generateEditField($formField, $tablefield, $user));
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
	protected function _convertDateFormat($format) {
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
	protected function _generateEditField($formEntryField, $tableRowField, User $user = null) {
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
			if ($field->defaultValue === '%LOGIN%' && $user !== null) {
				$field->value = $user->getLogin();
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
		$this->genericModel->getDatum($gTableFormat);

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
	protected function _decodeId($id) {
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