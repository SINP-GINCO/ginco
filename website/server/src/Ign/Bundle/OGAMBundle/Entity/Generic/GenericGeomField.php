<?php
namespace Ign\Bundle\OGAMBundle\Entity\Generic;

/**
 * A generic geom field is a generic field with some additional information
 */
class GenericGeomField extends GenericField {

	/**
	 * The bounding box of the value (geometry).
	 *
	 * @var BoundingBox
	 */
	private $valueBoundingBox;

	/**
	 * Return the bounding box of the value.
	 *
	 * @return BoundingBox
	 */
	public function getValueBoundingBox() {
		return $this->valueBoundingBox;
	}

	/**
	 * Set the bounding box of the value.
	 *
	 * @param BoundingBox $valueBoundingBox        	
	 */
	public function setValueBoundingBox(BoundingBox $valueBoundingBox) {
		$this->valueBoundingBox = $valueBoundingBox;
		return $this;
	}
}
