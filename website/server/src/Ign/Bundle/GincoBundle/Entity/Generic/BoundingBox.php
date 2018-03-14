<?php
namespace Ign\Bundle\GincoBundle\Entity\Generic;

/**
 * Represent a bounding box.
 */
class BoundingBox {

	/**
	 * The xmin coordinate of the bounding box.
	 *
	 * @var float
	 */
	private $xmin = 0;

	/**
	 * The ymin coordinate of the bounding box.
	 *
	 * @var float
	 */
	private $ymin = 0;

	/**
	 * The xmax coordinate of the bounding box.
	 *
	 * @var float
	 */
	private $xmax = 0;

	/**
	 * The ymax coordinate of the bounding box.
	 *
	 * @var float
	 */
	private $ymax = 0;

	/**
	 * The center of the bounding box ([$x, $y]).
	 *
	 * @var array
	 */
	private $center = [];

	/**
	 * Create a new BoundingBox object
	 *
	 * @param Integer $xmin
	 *        	x min position
	 * @param Integer $xmax
	 *        	x max position
	 * @param Integer $ymin
	 *        	y min position
	 * @param Integer $ymax
	 *        	y max position
	 * @return BoundingBox A BoundingBox object
	 */
	function __construct($xmin, $xmax, $ymin, $ymax) {
		$this->xmin = $xmin;
		$this->ymin = $ymin;
		$this->xmax = $xmax;
		$this->ymax = $ymax;

		// Set the center
		$x = (($this->xmin + $this->xmax) / 2);
		$y = (($this->ymin + $this->ymax) / 2);
		$this->center = [
			$x,
			$y
		];

		return $this;
	}

	/**
	 * Return a square bounding box object.
	 *
	 * @param Integer $minSize
	 *        	min size (default to 0)
	 * @return BoundingBox A BoundingBox object
	 */
	function getSquareBoundingBox($minSize = 0) {
		$xmin = $this->xmin;
		$ymin = $this->ymin;
		$xmax = $this->xmax;
		$ymax = $this->ymax;

		$diffX = abs($xmax - $xmin);
		$diffY = abs($ymax - $ymin);

		// Enlarge the bb if it's too small (like for the point)
		if ($diffX < $minSize) {
			$addX = ($minSize - $diffX) / 2;
			$xmin = $xmin - $addX;
			$xmax = $xmax + $addX;
			$diffX = $minSize;
		}
		if ($diffY < $minSize) {
			$addY = ($minSize - $diffY) / 2;
			$ymin = $ymin - $addY;
			$ymax = $ymax + $addY;
			$diffY = $minSize;
		}

		// Setup the bb like a square
		$diffXY = $diffX - $diffY;

		if ($diffXY < 0) {
			// The bb is highter than large
			$xmin = $xmin + $diffXY / 2;
			$xmax = $xmax - $diffXY / 2;
		} else if ($diffXY > 0) {
			// The bb is larger than highter
			$ymin = $ymin - $diffXY / 2;
			$ymax = $ymax + $diffXY / 2;
		}

		return new BoundingBox($xmin, $xmax, $ymin, $ymax);
	}

	/**
	 * Returns the bounding box as a string
	 *
	 * @return string
	 */
	public function toString() {
		return $this->xmin . ',' . $this->ymin . ',' . $this->xmax . ',' . $this->ymax;
	}

	/**
	 * Returns the center of the bounding box ([$x, $y]).
	 *
	 * @return array
	 */
	public function getCenter() {
		return $this->center;
	}

	/**
	 * Returns the xmin coordinate of the bounding box.
	 *
	 * @return float
	 */
	public function getXmin() {
		return $this->xmin;
	}

	/**
	 * Returns the ymin coordinate of the bounding box.
	 *
	 * @return float
	 */
	public function getYmin() {
		return $this->ymin;
	}

	/**
	 * Returns the xmax coordinate of the bounding box.
	 *
	 * @return float
	 */
	public function getXmax() {
		return $this->xmax;
	}

	/**
	 * Returns the ymax coordinate of the bounding box.
	 *
	 * @return float
	 */
	public function getYmax() {
		return $this->ymax;
	}
}
