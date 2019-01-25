<?php
namespace Ign\Bundle\GincoBundle\Entity\Generic;

use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableField;
use Ign\Bundle\GincoBundle\Entity\Metadata\Format;

/**
 * A generic table format is a GincoBundle\Entity\Metadata\TableFormat with some additional information.
 */
class GenericTableFormat extends GenericFormat {

	/**
	 * Create a GenericFormat
	 *
	 * @param string $datasetId
	 *        	The identifier of the dataset
	 * @param Format $metadata
	 *        	The format metadata
	 */
	function __construct($datasetId, $metadata) {
		if (is_a($metadata, TableFormat::class)) {
			parent::__construct($datasetId, $metadata);
		} else {
			throw new \InvalidArgumentException('The second argument must be of type \'TableFormat\'.');
		}
	}

	/**
	 * Add a identifier field.
	 * (GenericField with a metadata field of type TableField)
	 * 
	 * @param GenericField $field
	 *        	a field
	 */
	public function addIdField(GenericField $field) {
		if (is_a($field->getMetadata(), TableField::class)) {
			parent::addIdField($field);
		} else {
			throw new \InvalidArgumentException('The GenericField must have a metadata field of type \'TableField\'.');
		}
	}

	/**
	 * Add a field.
	 * (GenericField with a metadata field of type TableField)
	 * 
	 * @param GenericField $field
	 *        	a field
	 */
	public function addField(GenericField $field) {
		if (is_a($field->getMetadata(), TableField::class)) {
			parent::addField($field);
		} else {
			throw new \InvalidArgumentException('The GenericField must have a metadata field of type \'TableField\'.');
		}
	}

	/**
	 * Build and return the datum id
	 *
	 * @return String the datum identifier
	 */
	public function getId() {
		return 'SCHEMA/' . $this->getMetadata()->getSchemaCode() . '/' . parent::getId();
	}

	/**
	 * Return the table format.
	 *
	 * @return the TableFormat
	 */
	public function getTableFormat() {
		return parent::getMetadata();
	}
}
