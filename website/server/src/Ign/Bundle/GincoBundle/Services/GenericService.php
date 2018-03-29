<?php
namespace Ign\Bundle\GincoBundle\Services;

use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Query;
use Ign\Bundle\GincoBundle\Entity\Generic\GenericField;
use Ign\Bundle\GincoBundle\Entity\Generic\GenericFieldMapping;
use Ign\Bundle\GincoBundle\Entity\Generic\GenericFieldMappingSet;
use Ign\Bundle\GincoBundle\Entity\Generic\GenericFormField;
use Ign\Bundle\GincoBundle\Entity\Generic\GenericGeomField;
use Ign\Bundle\GincoBundle\Entity\Generic\GenericTableFormat;
use Ign\Bundle\GincoBundle\Entity\Generic\QueryForm;
use Ign\Bundle\GincoBundle\Entity\Metadata\Dynamode;
use Ign\Bundle\GincoBundle\Entity\Metadata\FormField;
use Ign\Bundle\GincoBundle\Entity\Metadata\Mode;
use Ign\Bundle\GincoBundle\Entity\Metadata\ModeTaxref;
use Ign\Bundle\GincoBundle\Entity\Metadata\ModeTree;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableField;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableTree;
use Ign\Bundle\GincoBundle\Entity\Metadata\Unit;
use Ign\Bundle\GincoBundle\GincoBundle;
use Ign\Bundle\GincoBundle\Repository\Metadata\DynamodeRepository;

/**
 * The Generic Service.
 *
 * This service handles transformations between data objects and generate generic SQL requests from the metadata.
 */
class GenericService {

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
	 * The models.
	 *
	 * @var EntityManager
	 */
	protected $metadataModel;
	
	/**
	 * The projection systems.
	 *
	 * @var String
	 */
	protected $visualisationSRS;
	
	/**
	 *
	 * @var ConfigurationManager
	 */
	protected $configuration;
	
	/**
	 */
	function __construct($em, $configuration, $logger, $locale) {
		// Initialise the logger
		$this->logger = $logger;
	
		// Initialise the locale
		$this->locale = $locale;
	
		// Initialise the metadata models
		$this->metadataModel = $em;
	
		$this->configuration = $configuration;
	
		// Configure the projection systems
		$this->visualisationSRS = $configuration->getConfig('srs_visualisation', '3857');
	}
	
	/**
	 * Build an empty data object.
	 *
	 * @param String $schema
	 *        	the name of the schema
	 * @param String $format
	 *        	the name of the format
	 * @param String $datasetId
	 *        	the dataset identifier
	 * @return GenericTableFormat the DataObject structure (with no values set)
	 */
	public function buildGenericTableFormat($schema, $format, $datasetId = null) {
	
		// Get the description of the table
		$tableFormat = $this->metadataModel->getRepository(TableFormat::class)->findOneBy(array(
			'schema' => $schema,
			'format' => $format
		));
	
		// Prepare a data object to be filled
		$gTable = new GenericTableFormat($datasetId, $tableFormat);
	
		// Get all the description of the Table Fields corresponding to the format
		$tableFields = $this->metadataModel->getRepository(TableField::class)->getTableFields($schema, $format, $datasetId, $this->locale);
	
		// Separate the keys from other values
		foreach ($tableFields as $tableField) {
			$format = $tableField->getFormat()->getFormat();
			$data = $tableField->getData()->getData();
			if ($tableField->getData()
				->getUnit()
				->getType() !== "GEOM") {
					$tableRowField = new GenericField($format, $data);
				} else {
					$tableRowField = new GenericGeomField($format, $data);
				}
				$tableRowField->setMetadata($tableField, $this->locale);
				if (in_array($tableRowField->getData(), $gTable->getTableFormat()->getPrimaryKeys())) {
					// Primary keys are displayed as info fields
	
					$gTable->addIdField($tableRowField);
				} else {
					// Editable fields are displayed as form fields
					$gTable->addField($tableRowField);
				}
		}
	
		return $gTable;
	}
	
	/**
	 * Return an Array object corresponding to a SQL string.
	 *
	 * Example : {"Boynes", "Ascoux"} => Array ( [0] => Boynes, [1] => Ascoux )
	 *
	 * @param String $value
	 *        	an array of values.
	 * @return the String representation of the array
	 */
	public function stringToArray($value) {
		$values = str_replace("{", "", $value);
		$values = str_replace("}", "", $values);
		$values = str_replace('"', "", $values);
		$values = trim($values);
		$valuesArray = explode(",", $values);
	
		foreach ($valuesArray as $v) {
			$v = trim($v);
		}
	
		return $valuesArray;
	}
	
	/**
	 * Find the labels corresponding to the code value.
	 *
	 * @param TableField $tableField
	 *        	a table field descriptor
	 * @param String|Array $code
	 *        	a mode code
	 * @return String|Array The labels
	 */
	public function getValueLabel(TableField $tableField, $code) {
		// If empty, no label
		if ($code === null || $code === '') {
			return "";
		}
	
		// By default we keep the code as a label
		$valueLabel = $code;
	
		// For the CODE and ARRAY fields, we get the labels in the metadata
		$unit = $tableField->getData()->getUnit();
		if (in_array($unit->getType(), array("CODE","ARRAY")) &&
			in_array($unit->getSubtype(), array("DYNAMIC", "TREE", "TAXREF", "MODE"))) {
	
				// Get the modes labels
				$modesLabels = $this->metadataModel->getRepository(Unit::class)->getModesLabelsFilteredByCode($unit, $code, $this->locale);
					
				// Populate the labels of the currently selected values
				if (is_array($code)) {
					$labels = array();
					if (isset($code)) {
						foreach ($code as $c) {
							if (isset($modesLabels[$c])) {
								$labels[] = $modesLabels[$c];
							}
						}
						$valueLabel = $labels;
					}
				} else {
					if (isset($modesLabels[$code])) {
						$valueLabel = $modesLabels[$code];
					}
				}
			}
	
			return $valueLabel;
	}
	
	/**
	 * Build the SELECT clause.
	 *
	 * @param Array[TableFields] $tableFields
	 *        	a list of result columns.
	 * @return String the SELECT part of the SQL query
	 */
	public function buildSelect($tableFields) {
		$sql = "";
	
		// Iterate through the fields
		foreach ($tableFields as $field) {
			$sql .= $this->buildSelectItem($field) . ", ";
		}
	
		// Remove the last comma
		$sql = substr($sql, 0, -2);
	
		return $sql;
	}
	
	/**
	 * Build the SELECT part for one field.
	 *
	 * @param TableField $field
	 *        	a table field descriptor.
	 * @param Array $options
	 *        	options about formatting
	 *        	"geometry_format" => "wkt" / "gml" (default "wkt")
	 *        	"geometry_srs" => output SRS for geometry fields (default: srs_raw_data from application_parameters )
	 *        	"date_format" => SQL date format for date fields (default 'YYYY/MM/DD')
	 *        	"datetime_format" => SQL date format for datetime field (default like date_format; to use ISO 8601 : 'YYYY-MM-DD"T"HH24:MI:SSTZ')
	 *        	"time_format"=>'HH24:mi:ss'
	 * @return String the SELECT part corresponding to the field.
	 */
	public function buildSelectItem($field, $options = array()) {
		$sql = "";
	
		// Merge $options with defaults
		$defaults = array(
			"geometry_format" => "wkt",
			"geometry_srs" => $this->configuration->getConfig('srs_results', '4326'),
			"gml_version" => 3,
			"gml_precision" => 15,
			"gml_options" => 0,
			"gml_prefix" => 'null',
			"gml_id" => 'null',
			"date_format" => 'YYYY/MM/DD',
			"datetime_format" => 'YYYY/MM/DD',
			"time_format" => 'HH24:mi:ss'
		);
		$options = array_replace($defaults, $options);
	
		$fieldName = $field->getFormat()->getFormat() . '.' . $field->getColumnName();
		$unit = $field->getData()->getUnit();
		if ($unit->getType() === "DATE") {
			if ($unit->getUnit() === "DateTime") {
				$sql .= "to_char(" . $fieldName . ", '" . $options['datetime_format'] . "') as " . $field->getName();
			} else {
				$sql .= "to_char(" . $fieldName . ", '" . $options['date_format'] . "') as " . $field->getName();
			}
		} else if ($unit->getType() === "GEOM") {
			// Location is used for visualisation - don't change it
			$sql .= "st_asText(st_transform(" . $fieldName . "," . $this->visualisationSRS . ")) as location, ";
			// Special case for THE_GEOM
			switch ($options['geometry_format']) {
				case "gml":
					$sql .= "st_asGML(" . $options['gml_version'] . ", st_transform($fieldName," . $options['geometry_srs'] . ")" . ", " . $options['gml_precision'] . ", " . $options['gml_options'] . ", " . $options['gml_prefix'] . ", " . $options['gml_id'] . ") as " . $field->getName() . ", ";
					break;
				case "wkt":
				default:
					$sql .= "st_asText(st_transform(" . $fieldName . "," . $options['geometry_srs'] . ")) as " . $field->getName() . ", ";
			}
			$sql .= "st_ymin(box2d(st_transform(" . $fieldName . "," . $this->visualisationSRS . '))) as ' . $field->getName() . '_y_min, ';
			$sql .= "st_ymax(box2d(st_transform(" . $fieldName . "," . $this->visualisationSRS . '))) as ' . $field->getName() . '_y_max, ';
			$sql .= "st_xmin(box2d(st_transform(" . $fieldName . "," . $this->visualisationSRS . '))) as ' . $field->getName() . '_x_min, ';
			$sql .= "st_xmax(box2d(st_transform(" . $fieldName . "," . $this->visualisationSRS . '))) as ' . $field->getName() . '_x_max ';
		} else if ($unit->getType() === 'TIME') {
			$sql .= "to_char(" . $fieldName . ", '" . $options['time_format'] . "') as " . $field->getName();
		} else {
			$sql .= $fieldName . " as " . $field->getName();
		}
	
		return $sql;
	}
	
	/**
	 * Build the WHERE clause corresponding to a list of criterias.
	 *
	 * @param String $schemaCode
	 *        	the schema.
	 * @param Array[GenericField] $criterias
	 *        	the criterias.
	 * @return String the WHERE part of the SQL query
	 */
	public function buildWhere($schemaCode, $criterias) {
		$sql = "";
	
		// Build the WHERE clause with the info from the PK.
		foreach ($criterias as $tableField) {
			$sql .= $this->buildWhereItem($schemaCode, $tableField->getMetadata(), $tableField->getValue(), true); // exact match
		}
	
		return $sql;
	}
	
	/**
	 * Build the WHERE clause corresponding to one criteria.
	 *
	 * @param String $schemaCode
	 *        	the schema.
	 * @param TableField $tableField
	 *        	a criteria.
	 * @param Boolean $exact
	 *        	if true, will use an exact equal (no like %% and no IN (xxx) for trees).
	 * @return String the WHERE part of the SQL query (ex : 'AND BASAL_AREA = 6.05')
	 */
	public function buildWhereItem($schemaCode, $tableField, $value, $exact = false) {
		$sql = "";
	
		$column = $tableField->getFormat()->getFormat() . "." . $tableField->getColumnName();
	
		// Set the projection for the geometries in this schema
		$configuration = $this->configuration;
		if ($schemaCode === 'RAW_DATA') {
			$databaseSRS = $configuration->getConfig('srs_raw_data', '4326');
		} else {
			throw new \InvalidArgumentException('Invalid schema code.');
		}
		// TODO use or implement queryBuilder ?
		// $builder = $this->metadataModel->getConnection()->getExpressionBuilder();
		$unit = $tableField->getData()->getUnit();
		if ($value !== null && $value !== '' && $value !== array()) {
				
			switch ($unit->getType()) {
	
				case "BOOLEAN":
					// Value is 1 or 0, stored in database as a char(1)
					if (is_array($value)) {
						$value = $value[0];
						$sql .= " AND " . $column . " = '" . $value . "'";
					} else if (is_bool($value)) {
						$sql .= " AND " . $column . " = '" . $value . "'";
					} else {
						$sql .= " AND " . $column . " = '" . $value . "'";
					}
					break;
	
				case "DATE":
					// Numeric values
					if (is_array($value)) {
						// Case of a list of values
						$sql2 = '';
						foreach ($value as $val) {
							if (!empty($val)) {
								$sql2 .= $this->_buildDateWhereItem($tableField, $val) . " OR ";
							}
						}
						if ($sql2 !== '') {
							$sql2 = substr($sql2, 0, -4); // remove the last OR
							$sql .= " AND (" . $sql2 . ")";
						}
					} else {
						// Single value
						if (!empty($value)) {
							$sql .= " AND " . $this->_buildDateWhereItem($tableField, $value);
						}
					}
					break;
				case "TIME":
					// time values
					if (is_array($value)) {
						// Case of a list of values
						$sql2 = '';
						foreach ($value as $val) {
							if (!empty($val)) {
								$sql2 .= $this->_buildTimeWhereItem($tableField, $val) . " OR ";
							}
						}
						if ($sql2 !== '') {
							$sql2 = substr($sql2, 0, -4); // remove the last OR
							$sql .= " AND (" . $sql2 . ")";
						}
					} else {
						// Single value
						if (!empty($value)) {
							$sql .= " AND " . $this->_buildTimeWhereItem($tableField, $value);
						}
					}
					break;
				case "INTEGER":
				case "NUMERIC":
					// Numeric values
					if (is_array($value)) {
	
						// Case of a list of values
						$sql2 = '';
						foreach ($value as $val) {
							if ($val !== null && $val !== '') {
								$sql2 .= $this->_buildNumericWhereItem($tableField, $val) . " OR ";
							}
						}
						if ($sql2 !== '') {
							$sql2 = substr($sql2, 0, -4); // remove the last OR
						}
						$sql .= " AND (" . $sql2 . ")";
					} else {
						// Single value
						if (is_numeric($value) || is_string($value)) {
							$sql .= " AND (" . $this->_buildNumericWhereItem($tableField, $value) . ")";
						}
					}
					break;
				case "ARRAY":
						
					// Case of a code in a generic TREE
					if ($unit->getSubtype() === 'TREE') {
	
						if (is_array($value)) {
							$value = $value[0];
						}
	
						if ($exact) {
							$sql .= " AND " . $column . " = ". $this->quote($value);
						} else {
							// Get all the children of a selected node
							$nodeModes = $this->metadataModel->getRepository(ModeTree::class)->getTreeChildrenModes($unit, $value, 0, $this->locale);
								
							$nodeModesArray = [];
							foreach ($nodeModes as $nodeMode) {
								$nodeModesArray[] .= $nodeMode->getCode();
							}
								
							// Case of a list of values
							$stringValue = $this->_arrayToSQLString($nodeModesArray);
							$sql .= " AND " . $column . " && " . $stringValue;
						}
					} else if ($unit->getSubtype() === 'TAXREF') {
						// Case of a code in a Taxonomic referential
						if (is_array($value)) {
							$value = $value[0];
						}
	
						if ($exact) {
							$sql .= " AND " . $column . " = ". $this->quote($value);
						} else {
							// Get all the children of a selected taxon
							$nodeModes = $this->metadataModel->getRepository(ModeTaxref::class)->getChildrenCodesSqlQuery($unit, $value, 0);
							$sql2 = $nodeModes->getSql();
							foreach($nodeModes->getParameters() as $param) {
								$sql2 = str_replace(":".$param->getName(), $this->quote($nodeModes->processParameterValue($param->getValue())), $sql2);
							}
								
							$alias = 'arraymodes'.crc32($column);
							$sql .= " AND $column && ( select array_agg(code) from ("  . $sql2 . ") $alias) ";
							//try the next one  if you have "stupid" performence probleme as with `$columncode_taxref IN ($list)`  in particular case
							//$sql .= " AND EXISTS ($sql2 WHERE code = ANY($column) ) ";
						}
					} else if ($unit->getSubtype() === 'STRING') {
						if (is_array($value)) {
							$value = $value[0];
						}
						if ($exact) {
							$sql .= " AND $value = ANY($column)";
						} else {
							$sql .= " AND EXISTS (SELECT elem FROM unnest($column) AS elem WHERE elem ILIKE '$value%')";
						}
					} else {
	
						$stringValue = $this->_arrayToSQLString($value);
						if (is_array($value)) {
							// Case of a list of values
							if ($exact) {
								$sql .= " AND " . $column . " = " . $stringValue;
							} else {
								$sql .= " AND " . $column . " && " . $stringValue;
							}
						} else if (is_string($value)) {
							// Single value
							if ($exact) {
								$sql .= " AND " . $column . " = " . $stringValue;
							} else {
								$sql .= " AND $stringValue = ANY(" . $column . ")";
							}
						}
					}
						
					break;
				case "CODE":
						
					// Case of a code in a generic TREE
					if ($unit->getSubtype() === 'TREE') {
	
						if (is_array($value)) {
							$value = $value[0];
						}
	
						if ($exact) {
							$sql .= " AND " . $column . " = " .$this->quote($value);
						} else {
							// Get all the children of a selected node
							$nodeModes = $this->metadataModel->getRepository(ModeTree::class)->getTreeChildrenModes($unit, $value, 0, $this->locale);
								
							$sql2 = '';
							foreach ($nodeModes as $nodeMode) {
								$sql2 .= $this->quote($nodeMode->getCode()) . ", ";
							}
							$sql2 = substr($sql2, 0, -2); // remove last comma
								
							$sql .= " AND " . $column . " IN (" . $sql2 . ")";
						}
					} else if ($unit->getSubtype() === 'TAXREF') {
						// Case of a code in a Taxonomic referential
						if (is_array($value)) {
							$value = $value[0];
						}
	
						if ($exact) {
							$sql .= " AND " . $column . " = " .$this->quote($value);
						} else {
								
							// Get all the children of a selected taxon
							$nodeModes = $this->metadataModel->getRepository(ModeTaxref::class)->getChildrenCodesSqlQuery($unit, $value, 0);
								
							$sql2 = $nodeModes->getSql();
							foreach($nodeModes->getParameters() as $param) {
								$sql2 = str_replace(":".$param->getName(), $this->quote($nodeModes->processParameterValue($param->getValue())), $sql2);
							}
	
							//$sql .= " AND " . $column . " IN ( "  . $sql2 . ") ";
							//WHERE EXISTS (IN may have poor perf with  lotsof data/but no row selected and limit/order)
							$sql .=  " AND EXISTS ($sql2 WHERE $column = code) ";
								
	
						}
					} else {
	
						// String
						if (is_array($value)) {
							// Case of a list of values
							$values = '';
							foreach ($value as $val) {
								if ($val !== null && $val !== '' && is_string($val)) {
									$values .= $this->quote($val) . ", ";
								}
							}
							if ($values !== '') {
								$values = substr($values, 0, -2); // remove the last comma
								$sql .= " AND " . $column . " IN (" . $values . ")";
							}
						} else {
							// Single value
							$sql .= " AND " . $column . " = " .$this->quote($value);
						}
					}
					break;
				case "GEOM":
					if (is_array($value)) {
						// Case of a list of geom
						$sql .= " AND (";
						$oradded = false;
						foreach ($value as $val) {
							if ($val !== null && $val !== '' && is_string($val)) {
								if ($exact) {
									$sql .= "ST_Equals(" . $column . ", ST_Transform(ST_GeomFromText('" . $val . "', " . $this->visualisationSRS . "), " . $databaseSRS . "))";
								} else {
									// The ST_Buffer(0) is used to correct the "Relate Operation called with a LWGEOMCOLLECTION type" error.
									$sql .= "ST_Intersects(" . $column . ", ST_Buffer(ST_Transform(ST_GeomFromText('" . $val . "', " . $this->visualisationSRS . "), " . $databaseSRS . "), 0))";
								}
								$sql .= " OR ";
								$oradded = true;
							}
						}
						if ($oradded) {
							$sql = substr($sql, 0, -4); // remove the last OR
						}
						$sql .= ")";
					} else {
						if (is_string($value)) {
							if ($exact) {
								$sql .= " AND (ST_Equals(" . $column . ", ST_Transform(ST_GeomFromText('" . $value . "', " . $this->visualisationSRS . "), " . databaseSRS . ")))";
							} else {
								$sql .= " AND (ST_Intersects(" . $column . ", ST_Buffer(ST_Transform(ST_GeomFromText('" . $value . "', " . $this->visualisationSRS . "), " . $databaseSRS . "), 0)))";
							}
						}
					}
					break;
				case "STRING":
				default:
					// String
					if (is_array($value)) {
						// Case of a list of values
						$sql .= " AND (";
						$oradded = false;
						foreach ($value as $val) {
							if ($val !== null && $val !== '' && is_string($val)) {
								if ($exact) {
									$sql .= $column . ' = '.$this->quote($val);
								} else {
									$sql .= $column . ' ILIKE '.$this->quote('%' . $val . '%');
								}
								$sql .= " OR ";
								$oradded = true;
							}
						}
						if ($oradded) {
							$sql = substr($sql, 0, -4); // remove the last OR
						}
						$sql .= ")";
					} else {
						if (is_string($value)) {
							// Single value
							$sql .= " AND (" . $column;
							if ($exact) {
								$sql .= ' = '.$this->quote($value);
							} else {
								$sql .= ' ILIKE '.$this->quote('%' . $value . '%');
							}
							$sql .= ")";
						}
					}
					break;
			}
		}
	
		return $sql;
	}
	
	protected function validateDate($date, $format = 'Y-m-d H:i:s') {
		$d = \DateTime::createFromFormat($format, $date);
		return $d && $d->format($format) == $date;
	}
	
	/**
	 * Build a WHERE criteria for a single date value.
	 *
	 * @param TableField $tableField
	 *        	a criteria field.
	 * @param String $value
	 *        	a date criterium.
	 *
	 *        	Examples of values :
	 *        	YYYY/MM/DD : for equality
	 *        	>= YYYY/MM/DD : for the superior value
	 *        	<= YYYY/MM/DD : for the inferior value
	 *        	YYYY/MM/DD - YYYY/MM/DD : for the interval
	 */
	protected function _buildDateWhereItem($tableField, $value) {
		$sql = "";
		$value = trim($value);
		$column = $tableField->getFormat()->getFormat() . "." . $tableField->getColumnName();
	
		if (!empty($value)) {
			if (strlen($value) === 10) {
				// Case "YYYY/MM/DD"
				if ($this->validateDate($value, 'Y/m/d')) {
					// One value, we make an equality comparison
					$sql .= "(" . $column . " = to_date('" . $value . "', 'YYYY/MM/DD'))";
				}
			} else if (strlen($value) === 13 && substr($value, 0, 2) === '>=') {
				// Case ">= YYYY/MM/DD"
				$beginDate = substr($value, 3, 10);
				if ($this->validateDate($beginDate, 'Y/m/d')) {
					$sql .= "(" . $column . " >= to_date('" . $beginDate . "', 'YYYY/MM/DD'))";
				}
			} else if (strlen($value) === 13 && substr($value, 0, 2) === '<=') {
				// Case "<= YYYY/MM/DD"
				$endDate = substr($value, 3, 10);
				if ($this->validateDate($endDate, 'Y/m/d')) {
					$sql .= "(" . $column . " <= to_date('" . $endDate . "', 'YYYY/MM/DD'))";
				}
			} else if (strlen($value) === 23) {
				// Case "YYYY/MM/DD - YYYY/MM/DD"
				$beginDate = substr($value, 0, 10);
				$endDate = substr($value, 13, 10);
				if ($this->validateDate($beginDate, 'Y/m/d') && $this->validateDate($endDate, 'Y/m/d')) {
					$sql .= "(" . $column . " >= to_date('" . $beginDate . "', 'YYYY/MM/DD') AND " . $column . " <= to_date('" . $endDate . "', 'YYYY/MM/DD'))";
				}
			}
		}
	
		if ($sql === "") {
			throw new \Exception("Invalid data format");
		}
	
		return $sql;
	}
	
	/**
	 * Build a WHERE criteria for a single time value.
	 *
	 * @param TableField $tableField
	 *        	a criteria field.
	 * @param String $value
	 *        	a time criterium.
	 *
	 * @tutorial examples of values :
	 *           HH:mm:ss : for equality
	 *           >= HH:mm:ss : for the superior value
	 *           <= HH:mm:ss : for the inferior value
	 *           HH:mm:ss - HH:mm:ss : for the interval
	 */
	protected function _buildTimeWhereItem($tableField, $value) {
		$sql = "";
		$timeFormat = 'HH:mm:ss';
		$gtOperator = '>=';
		$ltOperator = '<=';
		$value = trim($value);
		$column = $tableField->getFormat()->getFormat() . "." . $tableField->getColumnName();
	
		if (!empty($value)) {
			if (strlen($value) === strlen($timeFormat)) {
				// Case "HH:mm:ss"
				if ($this->validateDate($value, 'H:i:s')) {
					// One value, we make an equality comparison
					$sql .= "(" . $column . " = TIME '" . $value . "')";
				}
			} else if (strlen($value) === strlen("$gtOperator $timeFormat") && strpos($value, $gtOperator) === 0) {
				// Case ">= HH:mm:ss"
				$beginDate = substr($value, -strlen($timeFormat));
				if ($this->validateDate($beginDate, 'H:i:s')) {
					$sql .= "(" . $column . " >= TIME '" . $beginDate . "')";
				}
			} else if (strlen($value) === strlen("$ltOperator $timeFormat") && strpos($value, $ltOperator) === 0) {
				// Case "<= HH:mm:ss"
				$endDate = substr($value, -strlen($timeFormat));
				if ($this->validateDate($endDate, 'H:i:s')) {
					$sql .= "(" . $column . " <= TIME '" . $endDate . "')";
				}
			} else if (strlen($value) === strlen("$timeFormat - $timeFormat")) {
				// Case "HH:mm:ss - HH:mm:ss"
				$beginDate = substr($value, 0, strlen($timeFormat));
				$endDate = substr($value, -strlen($timeFormat));
				if ($this->validateDate($beginDate, 'H:i:s') && $this->validateDate($endDate, 'H:i:s')) {
					$sql .= "(" . $column . " >= TIME '" . $beginDate . "' AND " . $column . " <= TIME '" . $endDate . "')";
				}
			}
		}
	
		if ($sql === "") {
			throw new \Exception("Invalid data format");
		}
	
		return $sql;
	}
	
	/**
	 * Build a WHERE criteria for a single numeric value.
	 *
	 * @param TableField $tableField
	 *        	a criteria field.
	 * @param String $value
	 *        	a numeric criterium.
	 *
	 *        	Examples of values :
	 *        	12
	 *        	12.5
	 *        	12.5 - 17.9 (will generate a min - max criteria)
	 */
	protected function _buildNumericWhereItem($tableField, $value) {
		$sql = "";
		$posBetween = strpos($value, " - ");
		$posInf = strpos($value, "<=");
		$posSup = strpos($value, ">=");
	
		// Cas où les 2 valeurs sont présentes
		if ($posBetween !== false) {
				
			$minValue = substr($value, 0, $posBetween);
			$maxValue = substr($value, $posBetween + 3);
			$sql2 = '';
				
			if (($minValue !== null) && ($minValue !== '')) {
				$sql2 .= $tableField->getFormat()->getFormat() . "." . $tableField->getColumnName() . " >= " . $minValue;
			}
			if (($maxValue !== null) && ($maxValue !== '')) {
				if ($sql2 !== '') {
					$sql2 .= ' AND ';
				}
				$sql2 .= $tableField->getFormat()->getFormat() . "." . $tableField->getColumnName() . " <= " . $maxValue;
			}
			$sql .= '(' . $sql2 . ')';
		} else if ($posInf !== false) {
			// Cas où on a juste un max
			$maxValue = trim(substr($value, $posInf + 2));
			if (($maxValue !== null) && ($maxValue !== '')) {
				$sql .= $tableField->getFormat()->getFormat() . "." . $tableField->getColumnName() . " <= " . $maxValue;
			}
		} else if ($posSup !== false) {
			// Cas où on a juste un min
			$minValue = trim(substr($value, $posSup + 2));
			if (($minValue !== null) && ($minValue !== '')) {
				$sql .= $tableField->getFormat()->getFormat() . "." . $tableField->getColumnName() . " >= " . $minValue;
			}
		} else {
			// One value, we make an equality comparison
			$sql .= $tableField->getFormat()->getFormat() . "." . $tableField->getColumnName() . " = " . $value;
		}
	
		return $sql;
	}
	
	/**
	 * Return the SQL String representation of an array.
	 *
	 * Example : Array ( [0] => Boynes, [1] => Ascoux ) => {"Boynes", "Ascoux"}
	 *
	 * @param Array[String] $value
	 *        	an array of values.
	 * @return the String representation of the array (already quote)
	 */
	protected function _arrayToSQLString($arrayValues) {
		$string = "{";
	
		if (is_array($arrayValues)) {
			foreach ($arrayValues as $value) {
				$string .= '"' . $value . '",';
			}
			if (!empty($arrayValues)) {
				$string = substr($string, 0, -1); // Remove last comma
			}
		} else {
			$string .= $arrayValues;
		}
		$string .= "}";
	
		return  $this->quote($string);
	}
	
	/**
	 * Build the update part of a SQL request corresponding to a table field.
	 *
	 * @param string $schema
	 *        	the schema.
	 * @param GenericField $tableField
	 *        	a criteria.
	 * @return String the update part of the SQL query (ex : BASAL_AREA = 6.05)
	 */
	public function buildSQLValueItem($schema, $tableField) {
		$sql = "";
	
		$value = $tableField->getValue();
		// $column = $tableField->getColumnName();
	
		// Set the projection for the geometries in this schema
		$configuration = $this->configuration;
		if ($schema === 'RAW_DATA') {
			$databaseSRS = $configuration->getConfig('srs_raw_data', '4326');
		} else {
			throw new \InvalidArgumentException('Invalid schema code.');
		}
	
		switch ($tableField->getMetadata()
			->getData()
			->getUnit()
			->getType()) {
				
				case "BOOLEAN":
					// Value is 1 or 0, stored in database as a char(1)
					$sql = ($value == true ? '1' : '0');
					break;
				case "DATE":
					if ($value === "" || $value === null) {
						$sql = "NULL";
					} else {
						$sql = " to_date({$this->quote($value)}, 'YYYY/MM/DD')";
					}
					break;
				case "TIME":
					if ($value === "" || $value === null) {
						$sql = "NULL";
					} else {
						$sql = $this->quote($value);
					}
					break;
				case "INTEGER":
				case "NUMERIC":
				case "RANGE":
					if ($value === "" || $value === null) {
						$sql = "NULL";
					} else { // 0 is valid here
						$value = str_replace(",", ".", $value);
						$sql = $value;
					}
					break;
				case "ARRAY":
					$sql = $this->_arrayToSQLString($value);
					break;
				case "CODE":
					if ($value === ""){
						$sql = "NULL";
					} else {
						$sql = $this->quote($value);
					}
					break;
				case "GEOM":
					if ($value === "" || $value === null) {
						$sql = "NULL";
					} else {
						$sql = " ST_transform(ST_GeomFromText( " . $this->quote($value) . " , " . $this->visualisationSRS . "), " . $databaseSRS . ")";
					}
					break;
				case "STRING":
				default:
					// Single value
					$sql = $this->quote($value);
					break;
		}
	
		return $sql;
	}
	
	/**
	 * Get the form field corresponding to the table field.
	 * Ginco : add the selection of form_label and form_position.
	 * MIGRATION TO DO.
	 *
	 * @param GenericField $tableRowField
	 *        	the a valuable table row field
	 * @param Boolean $copyValues
	 *        	is true the values will be copied
	 * @return GenericFormField
	 */
	public function getTableToFormMapping(GenericField $tableRowField, $copyValues = false) {
		$this->logger->debug('getTableToFormMapping custom');
		$tableField = $tableRowField->getMetadata();
		// Get the description of the form field
		$req = "SELECT ff, fofo.label as form_label, fofo.position as form_position
				FROM IgnGincoBundle:Metadata\FormField ff
				JOIN IgnGincoBundle:Metadata\FieldMapping fm WITH fm.mappingType = 'FORM'
 				JOIN IgnGincoBundle:Metadata\FormFormat fofo WITH fofo.format = ff.format
				WHERE fm.srcData = ff.data
				AND fm.srcFormat = ff.format
				AND fm.dstFormat = :format
				AND fm.dstData = :data";
		$formField = $this->metadataModel->createQuery($req)
			->setParameters(array(
			'format' => $tableField->getFormat()
				->getFormat(),
			'data' => $tableField->getData()
				->getData()
		))
			->getOneOrNullResult();
		foreach($formField as $row){
			if(is_string($row)){
				$this->logger->debug($row);
			}
		}

		$valuedField = null;
		// Clone the object to avoid modifying existing object
		if ($formField[0] !== null) {
			$valuedField = new GenericFormField($formField[0]->getFormat()->getFormat(), $formField[0]->getData()->getData());
			$valuedField->setMetadata($formField[0], $this->locale);
			$valuedField->setFormPosition($formField['form_position']);
			$valuedField->setFormLabel($formField['form_label']);
		}

		// Copy the values
		if ($copyValues === true && $formField[0] !== null && $tableRowField->getValue() !== null) {

			// Copy the value and label
			$valuedField->setValue($tableRowField->getValue());
			$valuedField->setValueLabel($tableRowField->getValueLabel());
		}

		return $valuedField;
	}
	
	/**
	 * Return the fields mappings in the provided schema
	 *
	 * @param string $schema
	 * @param [\IgnGincoBundle\Entity\Generic\GenericField] $formFields
	 * @return GenericFieldMappingSet
	 */
	public function getFieldsFormToTableMappings($schema, $formFields) {
		$fieldsMappings = [];
		foreach ($formFields as $formField) {
			// Get the description of the corresponding table field
			$tableField = $this->metadataModel->getRepository(TableField::class)->getFormToTableMapping($schema, $formField, $this->locale);
			$dstField = new GenericField($tableField->getFormat()->getFormat(), $tableField->getData()->getData());
			$dstField->setMetadata($tableField, $this->locale);
				
			// Create the field mapping
			$fieldMapping = new GenericFieldMapping($formField, $dstField, $schema);
			$fieldsMappings[] = $fieldMapping;
		}
	
		return new GenericFieldMappingSet($fieldsMappings, $schema);
	}
	
	/**
	 * Get the hierarchy of tables needed for a data object.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param GenericFieldMapping[] $fieldsMappings
	 *        	the fields mappings
	 * @return Array[String => TableTreeData] The list of formats (including ancestors) potentially used
	 */
	public function getAllFormats($schema, $fieldsMappings) {
		$this->logger->info('getAllFormats : ' . $schema);
	
		// Prepare the list of needed tables
		$tables = array();
		foreach ($fieldsMappings as $fieldMapping) {
			$TableFormat = $fieldMapping->getDstField()->getFormat();
			if (!array_key_exists($TableFormat, $tables)) {
	
				// Get the ancestors of the table
				$ancestors = $this->metadataModel->getRepository(TableTree::class)->getAncestors($TableFormat, $schema);
	
				// Reverse the order of the list and store by indexing with the table name
				// The root table (LOCATION) should appear first
				$ancestors = array_reverse($ancestors);
				foreach ($ancestors as $ancestor) {
					$tables[$ancestor->getTableFormat()->getFormat()] = $ancestor;
				}
			}
		}
	
		return $tables;
	}
	
	/**
	 * Generate the SQL request corresponding the distinct locations of the query result.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param [IgnGincoBundle\Entity\Generic\GenericField] $formFields
	 *        	a form fields array
	 * @param IgnGincoBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @param Array $userInfos
	 *        	Few user informations
	 * @param Array $options
	 *        	formatting options for the returned fields (see buildSelectItem)
	 * @return String a SQL request
	 */
	public function generateSQLSelectRequest($schema, $formFields, GenericFieldMappingSet $mappingSet, $userInfos, $options = array()) {
		$this->logger->debug('generateSQLSelectRequest');
	
		// Add the requested columns
		$select = "SELECT DISTINCT "; // The "distinct" is for the case where we have some criteria but no result columns selected on the last table
		foreach ($formFields as $formField) {
			$tableField = $mappingSet->getDstField($formField)->getMetadata();
			$select .= $this->buildSelectItem($tableField, $options) . ", ";
		}
		$select = substr($select, 0, -2);
	
		// Get the leaf table
		$tables = $this->getAllFormats($schema, $mappingSet->getFieldMappingArray());
		$rootTable = reset($tables);
		$reversedTable = array_reverse($tables); // Only variables should be passed by reference
		$leafTable = array_shift($reversedTable);
	
		// Get the root table fields
		$rootTableFields = $this->metadataModel->getRepository(TableField::class)->getTableFields($schema, $rootTable->getTableFormat()
			->getFormat(), null, $this->locale);
		$hasColumnProvider = array_key_exists('PROVIDER_ID', $rootTableFields);
	
		// Add the id column
		$uniqueId = "'SCHEMA/" . $schema . "/FORMAT/" . $leafTable->getTableFormat()->getFormat() . "'";
		$keys = $leafTable->getTableFormat()->getPrimaryKeys();
		foreach ($keys as $key) {
			// Concatenate the column to create a unique Id
			$uniqueId .= " || '/' || '" . $key . "/' ||" . $leafTable->getTableFormat()->getFormat() . "." . $key;
		}
		$select .= ", " . $uniqueId . " as id";
	
		// Add the location centroid column (for zooming on the map)
		$locationField = $this->metadataModel->getRepository(TableField::class)->getGeometryField($schema, array_keys($tables), $this->locale);
		$select .= ", st_astext(st_centroid(st_transform(" . $locationField->getFormat()->getFormat() . "." . $locationField->getColumnName() . "," . $this->visualisationSRS . "))) as location_centroid ";
	
		// Add the provider id column
		if (!$userInfos['DATA_EDITION_OTHER_PROVIDER'] && $hasColumnProvider) {
			$select .= ", " . $leafTable->getTableFormat()->getFormat() . ".provider_id as _provider_id";
		}
	
		// Return the completed SQL request
		return $select;
	}
	
	/**
	 * Generate the FROM clause of the SQL request corresponding to a list of parameters.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param IgnGincoBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @return String a SQL request
	 */
	public function generateSQLFromRequest($schema, GenericFieldMappingSet $mappingSet) {
		$this->logger->debug('generateSQLFromRequest');
	
		//
		// Prepare the FROM clause
		//
	
		// Prepare the list of needed tables
		$tables = $this->getAllFormats($schema, $mappingSet->getFieldMappingArray());
	
		// Add the root table;
		$rootTable = array_shift($tables);
		$from = " FROM " . $rootTable->getTableFormat()->getTableName() . " " . $rootTable->getTableFormat()->getFormat();
	
		// Add the joined tables
		$i = 0;
		foreach ($tables as $tableTreeData) {
			$i ++;
				
			// Join the table
			$from .= " JOIN " . $tableTreeData->getTableFormat()->getTableName() . " " . $tableTreeData->getTableFormat()->getFormat() . " on (";
				
			// Add the join keys
			$keys = $tableTreeData->getJoinKeys();
			foreach ($keys as $key) {
				$from .= $tableTreeData->getTableFormat()->getFormat() . "." . trim($key) . " = " . $tableTreeData->getParentTableFormat()->getFormat() . "." . trim($key) . " AND ";
			}
			$from = substr($from, 0, -5);
			$from .= ") ";
		}
	
		return $from;
	}
	
	/**
	 * Generate the WHERE clause of the SQL request corresponding to a list of parameters.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param [IgnGincoBundle\Entity\Generic\GenericField] $formFields
	 *        	a form fields array
	 * @param IgnGincoBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @return String a SQL request
	 */
	public function generateSQLWhereRequest($schemaCode, $formFields, GenericFieldMappingSet $mappingSet, $userInfos) {
		$this->logger->debug('generateSQLWhereRequest');
	
		// Prepare the list of needed tables
		$tables = $this->getAllFormats($schemaCode, $mappingSet->getFieldMappingArray());
	
		// Add the root table;
		$rootTable = array_shift($tables);
	
		// Get the root table fields
		$rootTableFields = $this->metadataModel->getRepository(TableField::class)->getTableFields($schemaCode, $rootTable->getTableFormat()
			->getFormat(), null, $this->locale);
		$hasColumnProvider = array_key_exists('PROVIDER_ID', $rootTableFields);
	
		//
		// Prepare the WHERE clause
		//
		$where = " WHERE (1 = 1)";
		foreach ($formFields as $formField) {
			$tableField = $mappingSet->getDstField($formField)->getMetadata();
			$where .= $this->buildWhereItem($schemaCode, $tableField, $formField->getValue(), false);
		}
	
		// Right management
		// Check the provider id of the logged user
		if (!$userInfos['DATA_QUERY_OTHER_PROVIDER'] && $hasColumnProvider) {
			$where .= " AND " . $rootTable->getTableFormat()->getFormat() . ".provider_id = '" . $userInfos['providerId']->getId() . "'";
		}
	
		// Return the completed SQL request
		return $where;
	}
	
	/**
	 * Generate the primary key of the left table of the query.
	 * Fields composing the pkey are prefixed with the table label
	 *
	 * @param String $schema
	 *        	the schema
	 * @param IgnGincoBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @return String a primary key
	 */
	public function generateSQLPrimaryKey($schema, $mappingSet) {
		$this->logger->debug('generateSQLPrimaryKey');
	
		// Get the left table;
		$tables = $this->getAllFormats($schema, $mappingSet->getFieldMappingArray());
		$leafTable = array_pop($tables);
	
		$keys = $leafTable->getTableFormat()->getPrimaryKeys();
		foreach ($keys as $index => $key) {
			$keys[$index] = $leafTable->getTableFormat()->getFormat() . "." . $key;
		}
	
		return implode(',', $keys);
	}

	/**
	 * Generate the SQL request corresponding the distinct locations of the query result.
	 * Ginco : add the hiding_level column.
	 * Migrated.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param [IgnGincoBundle\Entity\Generic\GenericField] $formFields
	 *        	a form fields array
	 * @param IgnGincoBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @param Array $userInfos
	 *        	Few user informations
	 * @param Array $options
	 *        	formatting options for the returned fields (see buildSelectItem)
	 * @return String a SQL request
	 */
	public function generateGincoSQLSelectRequest($schema, $formFields, GenericFieldMappingSet $mappingSet, $userInfos, $options = array()) {
		$this->logger->debug('generateGincoSQLSelectRequest');

		// Add the requested columns
		$select = "SELECT DISTINCT "; // The "distinct" is for the case where we have some criteria but no result columns selected on the last table
		foreach ($formFields as $formField) {
			$tableField = $mappingSet->getDstField($formField)->getMetadata();
			$select .= $this->buildSelectItem($tableField, $options) . ", ";
		}
		$select = substr($select, 0, -2);

		// Get the leaf table
		$tables = $this->getAllFormats($schema, $mappingSet->getFieldMappingArray());
		$rootTable = reset($tables);
		$reversedTable = array_reverse($tables); // Only variables should be passed by reference
		$leafTable = array_shift($reversedTable);

		// Get the root table fields
		$rootTableFields = $this->metadataModel->getRepository(TableField::class)->getTableFields($schema, $rootTable->getTableFormat()
			->getFormat(), null, $this->locale);
		$hasColumnProvider = array_key_exists('PROVIDER_ID', $rootTableFields);

		// Add the id column
		$uniqueId = "'SCHEMA/" . $schema . "/FORMAT/" . $leafTable->getTableFormat()->getFormat() . "'";
		$keys = $leafTable->getTableFormat()->getPrimaryKeys();
		foreach ($keys as $key) {
			// Concatenate the column to create a unique Id
			$uniqueId .= " || '/' || '" . $key . "/' ||" . $leafTable->getTableFormat()->getFormat() . "." . $key;
		}
		$select .= ", " . $uniqueId . " as id";

		// Add the location centroid column (for zooming on the map)
		$locationField = $this->metadataModel->getRepository(TableField::class)->getGeometryField($schema, array_keys($tables), $this->locale);
		$select .= ", st_astext(st_centroid(st_transform(" . $locationField->getFormat()->getFormat() . "." . $locationField->getColumnName() . "," . $this->visualisationSRS . "))) as location_centroid ";

		// Add the provider id column
		if (!$userInfos['DATA_EDITION_OTHER_PROVIDER'] && $hasColumnProvider) {
			$select .= ", " . $leafTable->getTableFormat()->getFormat() . ".provider_id as _provider_id";
		}

		// Add the hiding level (for filtering possible sensible results)
		$select .= ", hiding_level";

		// Return the completed SQL request
		return $select;
	}

	/**
	 * Generate the FROM clause of the SQL request corresponding to a list of parameters.
	 * Ginco : support for the ogam_id column and results and joined tables for filtering results;
	 * MIGRATED.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param IgnGincoBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @param Array|String $joinTables
	 *        	the extra tables to join in the request
	 * @param String $geometryTablePKeyIdWithTable
	 *        	the full name of the ogam_id primary key of the table which contains the geometry field (in the form tablename.ogam_id_<xxx>)
	 * @param String $geometryTablePKeyProviderIdWithTable
	 *        	the full name of the provider_id primary key of the table which contains the geometry field (in the form tablename.xxx)
	 * @return String a SQL request
	 */
	public function generateGincoSQLFromRequest($schema, GenericFieldMappingSet $mappingSet, $joinTables = array(), $geometryTablePKeyIdWithTable = null, $geometryTablePKeyProviderIdWithTable = null) {
		$this->logger->debug('generateGincoSQLFromRequest');

		//
		// Prepare the FROM clause
		//

		// Prepare the list of needed tables
		$tables = $this->getAllFormats($schema, $mappingSet->getFieldMappingArray());

		// Add the root table;
		$rootTable = array_shift($tables);
		$rootTableName = $rootTable->getTableFormat()->getTableName();
		$rootTableFormat = $rootTable->getTableFormat()->getFormat();
		$from = " FROM " . $rootTableName . " " . $rootTableFormat;

		// Add results table
		// $from .= ', mapping.results ';

		// Add the user asked joined tables
		if (in_array('submission', $joinTables)) {
			$from .= " LEFT JOIN $schema.submission ON submission.submission_id = $rootTableFormat.submission_id";
		}
		if (in_array('results', $joinTables)) {
			$from .= " LEFT JOIN mapping.results ON results.id_observation = $geometryTablePKeyIdWithTable AND results.id_provider = $geometryTablePKeyProviderIdWithTable";
		}

		// Add the joined tables
		$i = 0;
		foreach ($tables as $tableTreeData) {
			$i ++;

			// Join the table
			$from .= " JOIN " . $tableTreeData->getTableFormat()->getTableName() . " " . $tableTreeData->getTableFormat()->getFormat() . " on (";

			// Add the join keys
			$keys = $tableTreeData->getJoinKeys();
			foreach ($keys as $key) {
				$from .= $tableTreeData->getTableFormat()->getFormat() . "." . trim($key) . " = " . $tableTreeData->getParentTableFormat()->getFormat() . "." . trim($key) . " AND ";
			}
			$from = substr($from, 0, -5);
			$from .= ") ";
		}

		return $from;
	}

	/**
	 * Generate the WHERE clause of the SQL request corresponding to a list of parameters.
	 * Ginco : check for user permissions on submission. Exact search for id column.
	 * MIGRATED.
	 *
	 * @param String $schema
	 *        	the schema
	 * @param [IgnGincoBundle\Entity\Generic\GenericField] $formFields
	 *        	a form fields array
	 * @param IgnGincoBundle\Entity\Generic\GenericFieldMappingSet $mappingSet
	 *        	the field mapping set
	 * @return String a SQL request
	 */
	public function generateGincoSQLWhereRequest($schemaCode, $formFields, GenericFieldMappingSet $mappingSet, $userInfos, $tables) {
		$this->logger->debug('generateSQLWhereRequest ginco');

		// Add the root table;
		$rootTable = array_shift($tables);

		// Get the root table fields
		$rootTableFields = $this->metadataModel->getRepository(TableField::class)->getTableFields($schemaCode, $rootTable->getTableFormat()
			->getFormat(), null, $this->locale);

		$hasColumnProvider = array_key_exists('PROVIDER_ID', $rootTableFields);
		$hasConfirmSubmission = array_key_exists('CONFIRM_SUBMISSION', $userInfos) && $userInfos['CONFIRM_SUBMISSION'];
		$hasGrandPublicRole = array_key_exists('hasGrandPublicRole', $userInfos) && $userInfos['hasGrandPublicRole'];
		//
		// Prepare the WHERE clause
		//
		$where = " WHERE (1 = 1)";
		foreach ($formFields as $formField) {
			$tableField = $mappingSet->getDstField($formField)->getMetadata();

			if ($tableField->getData()
				->getUnit()
				->getSubType() == 'ID') {
				// Exact search
				$where .= $this->buildWhereItem($schemaCode, $tableField, $formField->getValue(), true);
			} else {
				$where .= $this->buildWhereItem($schemaCode, $tableField, $formField->getValue(), false);
			}
		}

		// Right management
		// Check the provider id of the user
		// If the user role has not the permission to see unpublished data of other provider (ie has not DATA_QUERY_OTHER_PROVIDER), he can see his own datas or other providers published datas
		// Users under Defaut organism are considered under different organisms (warning: provider.id for Defaut organism must be 1 in database)
		if (!$userInfos['DATA_QUERY_OTHER_PROVIDER'] && $hasColumnProvider) {
			$where .= " AND ((" . $rootTable->getTableFormat()->getFormat() . ".provider_id = '" . $userInfos['providerId']->getId() . "' AND '" . $userInfos['providerId']->getId() . "' != '1') OR submission.step='VALIDATE')";
		}

		// Return the completed SQL request
		return $where;
	}

	/**
	 * Generate the WHERE clause of the SQL request used for the whole request.
	 * The other where generation method is used in the subquery of the main query.
	 * It is specifc to Ginco as it only adds columns for filtering possible sensible data.
	 *
	 * @param String $rawDataTableName
	 *        	the name of the table prefixed by the schema name
	 * @param Integer $requestId
	 *        	the id of the request
	 * @param Integer $maxPrecisionLevel
	 *        	the value of the hiding_level
	 * @return String a SQL request
	 */
	public function generateSQLEndWhereRequest($rawDataTableName, $requestId, $maxPrecisionLevel) {
		$this->logger->debug('generateSQLEndWhereRequest');

		$endWhere = " AND table_format = '" . $rawDataTableName . "'";
		$endWhere .= " AND id_request = " . $requestId;
		$endWhere .= " AND hiding_level <= " . $maxPrecisionLevel;

		return $endWhere;
	}

	/**
	 * Get the FROM clause, with JOINS linking youngest requested table to mapping.results table
	 *
	 * MIGRATED.
	 *
	 * @param String $schema
	 * @param string $tableFormat
	 *        	the format of the requested table
	 */
	public function getJoinToGeometryTable($schema, $tableFormat) {
		$this->logger->debug('getJoinToGeometryTable');

		$tableTreeRepo = $this->metadataModel->getRepository(TableTree::class);
		$tableFormatRepo = $this->metadataModel->getRepository(TableFormat::class);

		// Get the ancestors of the table
		$ancestors = $tableTreeRepo->getAncestors($tableFormat, $schema);

		// Get the ancestors to the geometry table only
		$ancestorsToGeometry = $this->getAncestorsToGeometry($schema, $ancestors);

		// Add the requested table (FROM)
		$ancestorsValue = array_values($ancestorsToGeometry);
		$requestedTable = array_shift($ancestorsValue);

		$logicalName = $requestedTable->getTableFormat()->getFormat();

		$from = " FROM " . $requestedTable->getTableFormat()->getTableName() . " " . $logicalName;

		// Add the joined tables (when there is ancestors)
		foreach ($ancestorsToGeometry as $tableTreeData) {
			if ($tableTreeData->getParentTableFormat()->getFormat() != '*') {
				$parentTableName = $ancestorsToGeometry[$tableTreeData->getParentTableFormat()]->getTableName();
				$from .= " JOIN " . $parentTableName . " " . $tableTreeData->getParentTableFormat()->getFormat() . " on (";
				// Add the join keys
				$keys = explode(',', $tableTreeData->getTableFormat()->getPrimaryKeys());
				foreach ($keys as $key) {
					$from .= $tableTreeData->getTableFormat()->getFormat() . "." . trim($key) . " = " . $tableTreeData->getParentTableFormat()->getFormat() . "." . trim($key) . " AND ";
				}
				$from = substr($from, 0, -5);
				$from .= ") ";
			}
		}

		// Add JOIN beetween results table and the table which contains the geometry column (last table of the list)
		$ancestorsValue = array_values($ancestorsToGeometry);
		$geometryTable = array_pop($ancestorsValue);

		$geometryTableFormat = $tableFormatRepo->findOneBy(array(
			'format' => $geometryTable->getTableFormat()
				->getFormat()
		));
		$geometryTableFormatKeys = $geometryTableFormat->getPrimaryKeys();
		foreach ($geometryTableFormatKeys as $geometryKey) {
			if (strtolower(trim($geometryKey)) != 'provider_id') {
				$geometryTablePKeyId = trim($geometryKey);
			}
		}
		$from .= " LEFT JOIN mapping.results ON results.id_observation = " . $geometryTable->getTableFormat()->getFormat() . "." . $geometryTablePKeyId . " AND results.id_provider = " . $geometryTable->getTableFormat()->getFormat() . ".provider_id";

		$this->logger->debug('getJoinToGeometryTable :' . $from);
		return $from;
	}

	/**
	 * Truncates the array of the ancestors, ends it with the table containing the geometry
	 * MIGRATED
	 * @param String $schema
	 * @param Array[Application_Object_Metadata_TableTreeData] $ancestors
	 * @return Array[Application_Object_Metadata_TableTreeData] $ancestorsToGeometry
	 */
	public function getAncestorsToGeometry($schema, $ancestors) {
		$this->logger->info('getAncestorsToGeometry');

		$ancestorsToGeometry = array();
		$ĥasGeometryColumn = 0;

		while ($ĥasGeometryColumn != 1) {
			$ancestor = array_shift($ancestors);
			$ancestorsToGeometry[$ancestor->getTableFormat()->getTableName()] = $ancestor;

			$req = " SELECT 1 as has_geometry ";
			$req .= " FROM INFORMATION_SCHEMA.COLUMNS ";
			$req .= " WHERE table_name = ? ";
			$req .= " and column_name = 'geometrie' ";
			$req .= " and table_schema = ? ";

			$this->logger->info('getAncestorsToGeometry : ' . $req);

			$conn = $this->metadataModel->getConnection();
			$results = $conn->fetchAll($req, array(
				$ancestor->getTableFormat()->getTableName(),
				strtolower($schema)
			));

			$row = $results[0];
			if ($row['has_geometry'] != null) {
				$ĥasGeometryColumn = 1;
			}
		}
		return $ancestorsToGeometry;
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
	
	/**
	 * Serialize a list of data objects as an array for a display into a Ext.GridPanel.
	 *
	 * @param String $id
	 *        	the id for the returned dataset
	 * @param List[DataObject] $data
	 *        	the data object we're looking at.
	 * @return ARRAY
	 */
	public function dataToGridDetailArray($id, $data) {
		$this->logger->info('dataToDetailArray');
	
		if (!empty($data)) {
				
			// The columns config to setup the grid columnModel
			$columns = array(
				array(
						
					'header' => 'Informations',
					'dataIndex' => 'informations',
					'editable' => false,
					'tooltip' => 'Informations',
					'width' => 150,
					'type' => 'STRING'
				)
			);
				
			// The fields config to setup the store reader
			$locationFields = array(
				'id',
				'informations'
			);
			// The data to full the store
			$locationsData = array();
			$firstData = $data[0];
				
			// Dump each row values
			foreach ($data as $datum) {
				$locationData = array();
				// Addition of the row id
				$locationData[0] = $datum->getId();
				$locationData[1] = "";
				foreach ($datum->getIdFields() as $field) {
					$locationData[1] .= $field->getValueLabel() . ', ';
				}
	
				if ($locationData[1] !== "") {
					$locationData[1] = substr($locationData[1], 0, -2);
				}
				$formFields = $this->getFormFieldsOrdered($datum->getFields());
				foreach ($formFields as $formField) {
					// We keep only the result fields (The columns availables)
					array_push($locationData, $formField->getValueLabel());
				}
				array_push($locationsData, $locationData);
			}
				
			// Add the colums description
			foreach ($formFields as $field) {
				// Set the column model and the location fields
				$dataIndex = $firstData->getTableFormat()->getFormat() . '__' . $field->getData();
	
				$column = array(
					'header' => $field->getMetadata()
					->getData()
					->getLabel(),
					'dataIndex' => $dataIndex,
					'editable' => false,
					'tooltip' => $field->getMetadata()
					->getData()
					->getDefinition(),
					'width' => 150,
					'type' => $field->getMetadata()
					->getData()
					->getUnit()
					->getType()
				);
				array_push($columns, $column);
				array_push($locationFields, $dataIndex);
			}
				
			// Check if the table has a child table
			$hasChild = false;
			$children = $this->metadataModel->getRepository(TableTree::class)->getChildrenTableLabels($firstData->getTableFormat());
			if (!empty($children)) {
				$hasChild = true;
			}
			$out = Array();
			$out['id'] = $id;
			$out['title'] = $firstData->getTableFormat()->getLabel() . ' (' . count($locationsData) . ')';
			$out['hasChild'] = $hasChild;
			$out['columns'] = array_values($columns);
			$out['fields'] = array_values($locationFields);
			$out['data'] = array_values($locationsData);
			return $out;
		} else {
			return null;
		}
	}
	
	/**
	 * quote sql value
	 * @param unknown $value
	 * @param unknown $type
	 * @return string
	 */
	protected function quote($value, $type=null){
		return $this->metadataModel->getConnection()->quote($value, $type);
	}
	
	/**
	 * Return the form fields mapped to the table fields and ordered by position
	 *
	 * @param array $tableFields
	 *        	The table fields
	 * @return array The form fields ordered
	 */
	public function getFormFieldsOrdered(array $tableFields) {
		$fieldsOrdered = array();
		foreach ($tableFields as $tableField) {
			// Get the form field corresponding to the table field
			$formField = $this->getTableToFormMapping($tableField, true);
			if ($formField !== null && $formField->getMetadata()->getIsResult()) {
				$fieldsOrdered[] = $formField;
			}
		}
		return array_values($fieldsOrdered);
	}
}