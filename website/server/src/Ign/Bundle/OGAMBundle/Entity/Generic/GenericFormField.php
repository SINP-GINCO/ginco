<?php
namespace Ign\Bundle\OGAMBundle\Entity\Generic;

/**
 * A generic form field is a generic field with form_position and form_label.
 */
class GenericFormField extends GenericField {

	/**
	 * The position in the form
	 *
	 * @var int
	 */
	private $formPosition;

	/**
	 * The label of the form
	 *
	 * @var string
	 */
	private $formLabel;

	/**
	 * Return the form position.
	 *
	 * @return int
	 */
	public function getFormPosition() {
		return $this->formPosition;
	}

	/**
	 * Set the form position of the value.
	 *
	 * @param int $formPosition
	 */
	public function setFormPosition($formPosition) {
		$this->formPosition = $formPosition;
		return $this;
	}

	/**
	 * Return the form label.
	 *
	 * @return string
	 */
	public function getFormLabel() {
		return $this->formLabel;
	}

	/**
	 * Set the form label.
	 *
	 * @param string $formLabel
	 */
	public function setFormLabel($formLabel) {
		$this->formLabel = $formLabel;
		return $this;
	}
}
