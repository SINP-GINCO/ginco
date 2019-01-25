<?php
namespace Ign\Bundle\GincoBundle\Entity\Generic;

use Ign\Bundle\GincoBundle\Entity\Metadata\Field;
use Ign\Bundle\GincoBundle\Entity\Metadata\FieldInterface;

/**
 * A generic field is a GincoBundle\Entity\Metadata\Field with some additional information
 */
class GenericField {

	/**
	 * The format of the field
	 *
	 * @var string
	 */
	private $format;

	/**
	 * The data of the field
	 *
	 * @var string
	 */
	private $data;

	/**
	 * The value of the field
	 *
	 * @var array|string
	 */
	private $value;

	/**
	 * The label associed with the value
	 *
	 * @var string
	 */
	private $valueLabel;

	/**
	 * The metadata locale
	 *
	 * @var string
	 */
	private $locale;

	/**
	 * The field metadata
	 *
	 * @var FieldInterface
	 */
	private $metadata;

	function __construct($format, $data) {
		$this->format = $format;
		$this->data = $data;
	}

	/**
	 *
	 * @return string
	 */
	public function getId() {
		return $this->format . '__' . $this->data;
	}

	/**
	 *
	 * @return string
	 */
	public function getFormat() {
		return $this->format;
	}

	/**
	 *
	 * @return string
	 */
	public function getData() {
		return $this->data;
	}

	/**
	 *
	 * @return array|string
	 */
	public function getValue() {
		return $this->value;
	}

	/**
	 *
	 * @param mixed $value
	 */
	public function setValue($value) {
		$this->value = $value;
		return $this;
	}

	/**
	 * Return the label corresponding to the value.
	 * For a code, will return the description.
	 *
	 * @return String the label
	 */
	function getValueLabel() {
		if ($this->valueLabel != null) {
			return $this->valueLabel;
		} else {
			return $this->value;
		}
	}

	/**
	 *
	 * @return string
	 */
	public function getLocale() {
		return $this->locale;
	}

	/**
	 *
	 * @return FieldInterface
	 */
	public function getMetadata() {
		return $this->metadata;
	}

	public function setMetadata(FieldInterface $metadata, $locale) {
		$this->locale = $locale;
		$this->metadata = $metadata;
	}

	/**
	 *
	 * @param string $valueLabel
	 */
	public function setValueLabel($valueLabel) {
		$this->valueLabel = $valueLabel;
		return $this;
	}

	/**
	 * Check if the field has a value
	 *
	 * @return Boolean True is the field is empty.
	 */
	function isEmpty() {
		return empty($this->value);
	}

	/**
	 * Convert the object to string
	 *
	 * @return string
	 */
	function __toString() {
	    return $this->getId() . ': ' . $this->getValue() . ($this->valueLabel != null ? ' ('.$this->valueLabel.')':'');
	}
}
