<?php
namespace Ign\Bundle\OGAMBundle\Entity\Generic;

/**
 * A data object is used to store a values of a line of data (from any table of a database).
 */
class GenericFieldMappingSet {

	/**
	 * The schema use to filter the mapping
	 *
	 * @var string
	 */
	private $schema;

	/**
	 * The field mapping array
	 *
	 * @var GenericFieldMapping[]
	 */
	private $fieldMappingArray;

	/**
	 * Construct a generic field mapping set.
	 *
	 * @param GenericFieldMapping[] $fieldMappingArray        	
	 * @param string $schema        	
	 */
	function __construct(array $fieldMappingArray, $schema) {
		$this->fieldMappingArray = $fieldMappingArray;
		$this->schema = $schema;
	}

	/**
	 * Return the schema.
	 *
	 * @return string The schema
	 */
	public function getSchema() {
		return $this->schema;
	}

	/**
	 * Return the field mapping array.
	 *
	 * @return the field mapping array
	 */
	public function getFieldMappingArray() {
		return $this->fieldMappingArray;
	}

	/**
	 * Return the mapping corresponding to the source field.
	 *
	 * @param GenericField $srcField        	
	 * @return GenericFieldMapping|NULL
	 */
	protected function getFieldMapping(GenericField $srcField) {
		for ($i = 0; $i < count($this->fieldMappingArray); $i ++) {
			if ($this->fieldMappingArray[$i]->getSrcField()->getId() === $srcField->getId()) {
				return $this->fieldMappingArray[$i];
			}
		}
		return null;
	}

	/**
	 * Checks if a field mapping is already set
	 *
	 * @param GenericField $srcField        	
	 * @return boolean
	 */
	protected function hasFieldMapping(GenericField $srcField) {
		if ($this->getFieldMapping($srcField) !== null) {
			return true;
		}
		return false;
	}

	/**
	 * Return the destination field corresponding to the source field.
	 *
	 * @param GenericField $srcField        	
	 * @return GenericField|NULL
	 */
	public function getDstField(GenericField $srcField) {
		return $this->getFieldMapping($srcField)->getDstField();
	}

	/**
	 * Return the sub field mapping set corresponding to the source fields.
	 *
	 * @param GenericField[] $srcFields        	
	 * @return GenericFieldMappingSet
	 */
	protected function getSubFieldMappingSet(array $srcFields) {
		$subFieldMappingSetArray = [];
		for ($i = 0; $i < count($srcFields); $i ++) {
			$subFieldMappingSetArray[] = $this->getFieldMapping($srcFields[$i]);
		}
		return new GenericFieldMappingSet($subFieldMappingSetArray, $this->schema);
	}

	/**
	 * Return the destination fields corresponding to the source fields.
	 *
	 * @param GenericField[] $srcFields        	
	 * @return GenericField[] the destination fields
	 */
	public function getDstFields(array $srcFields) {
		$dstFields = [];
		$subFieldMappingSetArray = $this->getSubFieldMappingSet($srcFields)->getFieldMappingArray();
		for ($i = 0; $i < count($subFieldMappingSetArray); $i ++) {
			$dstFields[] = $subFieldMappingSetArray[$i]->getDstField();
		}
		return $dstFields;
	}

	/**
	 * Add a field mapping set to this mapping set.
	 *
	 * @param GenericFieldMappingSet $fieldMappingSet        	
	 * @return GenericFieldMappingSet
	 */
	public function addFieldMappingSet(GenericFieldMappingSet $fieldMappingSet) {
		if ($fieldMappingSet->getSchema() === $this->schema) {
			$fieldMappingArray = $fieldMappingSet->getFieldMappingArray();
			for ($i = 0; $i < count($fieldMappingArray); $i ++) {
				$fieldMapping = $fieldMappingArray[$i];
				if (!$this->hasFieldMapping($fieldMapping->getSrcField())) {
					$this->fieldMappingArray[] = $fieldMapping;
				}
			}
		} else {
			throw new \Exception("The schema of the added mapping set is different of the schema of the current mapping set.");
		}
		return $this;
	}
}