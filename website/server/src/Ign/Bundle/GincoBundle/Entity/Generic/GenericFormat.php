<?php
namespace Ign\Bundle\GincoBundle\Entity\Generic;

use Ign\Bundle\GincoBundle\Entity\Metadata\Format;

/**
 * A generic format is a GincoBundle\Entity\Metadata\Format with some additional information.
 */
class GenericFormat {

	/**
	 * The identifier of the dataset.
	 */
	private $datasetId;

	/**
	 * The format identifier
	 *
	 * @var string
	 */
	private $format;

	/**
	 * The format metadata
	 *
	 * @var Format
	 */
	private $metadata;

	/**
	 * The IDs fields
	 *
	 * @var array[GenericField]
	 */
	private $idFields = array();

	/**
	 * The fields not included into the IDs fields
	 *
	 * @var array[GenericField].
	 */
	private $fields = array();

	/**
	 * Create a GenericFormat
	 *
	 * @param string $datasetId
	 *        	The identifier of the dataset
	 * @param Format $metadata
	 *        	The format metadata
	 */
	function __construct($datasetId, Format $metadata) {
		$this->datasetId = $datasetId;
		$this->metadata = $metadata;
		$this->format = $metadata->getFormat();
	}

	/**
	 * Add a identifier field.
	 *
	 * @param GenericField $field
	 *        	a field
	 */
	public function addIdField(GenericField $field) {
		$this->idFields[$field->getId()] = $field;
	}

	/**
	 * Add a field.
	 *
	 * @param GenericField $field
	 *        	a field
	 */
	public function addField(GenericField $field) {
		$this->fields[$field->getId()] = $field;
	}

	/**
	 * Build and return the datum id
	 *
	 * @return String the datum identifier
	 */
	public function getId() {
		$datumId = 'FORMAT/' . $this->metadata->getFormat();
		foreach ($this->getIdFields() as $field) {
			$datumId .= '/' . $field->getData() . '/' . $field->getValue();
		}
		return $datumId;
	}

	/**
	 * Return the format metadata.
	 *
	 * @return Format
	 */
	public function getMetadata() {
		return $this->metadata;
	}

	/**
	 * Get a identifier field.
	 *
	 * @param string $id        	
	 * @return array[GenericField]
	 */
	public function getIdField($id) {
		return $this->idFields[trim($id)];
	}

	/**
	 * Return the idFields array.
	 *
	 * @return array[GenericField] the idFields array
	 */
	public function getIdFields() {
		return $this->idFields;
	}

	/**
	 * Return a field.
	 *
	 * @param String $id
	 *        	a field identifier
	 * @return GenericField the field
	 */
	public function getField($id) {
		return $this->fields[trim($id)];
	}

	/**
	 * Return the fields array.
	 *
	 * @return array[GenericField] the fields array
	 */
	public function getFields() {
		return $this->fields;
	}

	/**
	 * Get all table fields.
	 *
	 * @return [GenericField] the table fields
	 */
	public function all() {
		return array_merge($this->idFields, $this->fields);
	}
}
