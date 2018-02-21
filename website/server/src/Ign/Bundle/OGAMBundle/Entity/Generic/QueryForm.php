<?php
namespace Ign\Bundle\OGAMBundle\Entity\Generic;

/**
 * A Form Query is the list of criteria and columns
 */
class QueryForm {

	/**
	 * The dataset identifier.
	 * String.
	 */
	private $datasetId;

	/**
	 * The asked criteria.
	 * Array[OGAMBundle\Entity\Generic\Field]
	 */
	private $criteria = array();

	/**
	 * The asked columns.
	 * Array[OGAMBundle\Entity\Generic\Field]
	 */
	private $columns = array();

	/**
	 * The field mapping set (Form -> Table)
	 * 
	 * @var GenericFieldMappingSet
	 */
	private $fieldMappingSet;

	/**
	 * Return the dataset Id
	 * 
	 * @return string the dataset Id
	 */
	public function getDatasetId() {
		return $this->datasetId;
	}

	/**
	 * Set the datasetId
	 * 
	 * @param string $datasetId        	
	 */
	public function setDatasetId($datasetId) {
		$this->datasetId = $datasetId;
		return $this;
	}

	/**
	 * Add a new criterion.
	 *
	 * @param String $format
	 *        	the criterion form format
	 * @param String $data
	 *        	the criterion form data
	 * @param String $value
	 *        	the criterion value
	 */
	public function addCriterion($format, $data, $value) {
		$formField = new GenericField($format, $data);
		$formField->setValue($value);
		$this->criteria[] = $formField;
	}

	/**
	 * Add a new column.
	 *
	 * @param String $format
	 *        	the column form format
	 * @param String $data
	 *        	the column form data
	 */
	public function addColumn($format, $data) {
		$formField = new GenericField($format, $data);
		$this->columns[] = $formField;
	}

	/**
	 * Get all table fields.
	 *
	 * @return array[Ign\Bundle\OGAMBundle\Entity\Generic\Field] the form fields
	 */
	public function getFields() {
		return array_merge($this->criteria, $this->columns);
	}

	/**
	 * Get the criteria.
	 *
	 * @return array[Ign\Bundle\OGAMBundle\Entity\Generic\Field] the form fields
	 */
	public function getCriteria() {
		return $this->criteria;
	}

	/**
	 * Get the columns.
	 *
	 * @return array[Ign\Bundle\OGAMBundle\Entity\Generic\Field] the form fields
	 */
	public function getColumns() {
		return $this->columns;
	}

	/**
	 * Get the field mapping set (Form -> Table)
	 *
	 * @return GenericFieldMappingSet
	 */
	public function getFieldMappingSet() {
		return $this->fieldMappingSet;
	}

	/**
	 * Set the field mapping set (Form -> Table)
	 *
	 * @param GenericFieldMappingSet $fieldMappingSet        	
	 */
	public function setFieldMappingSet(GenericFieldMappingSet $fieldMappingSet) {
		$this->fieldMappingSet = $fieldMappingSet;
		return $this;
	}

	/**
	 * Get the column destination fields
	 *
	 * @return GenericField[]
	 */
	public function getColumnsDstFields() {
		return $this->fieldMappingSet->getDstFields($this->columns);
	}

	/**
	 * Get the request validity.
	 *
	 * @return Boolean True if the request is valid.
	 */
	public function isValid() {
		return !empty($this->getColumns());
	}
}
