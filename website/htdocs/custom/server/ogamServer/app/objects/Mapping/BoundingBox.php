<?php

/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 *
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices.
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents.
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */

/**
 * Represent a Bounding Box.
 *
 * @SuppressWarnings checkUnusedVariables
 *
 * @package Application_Object
 * @subpackage Mapping
 */
class Application_Object_Mapping_BoundingBox {

	/**
	 * X Min.
	 *
	 * @var int
	 */
	var $xmin = 0;

	/**
	 * Y Min.
	 *
	 * @var int
	 */
	var $ymin = 0;

	/**
	 * X Max.
	 *
	 * @var int
	 */
	var $xmax = 0;

	/**
	 * Y Max.
	 *
	 * @var int
	 */
	var $ymax = 0;

	/**
	 * Zoom Level (optional).
	 *
	 * @var int
	 */
	var $zoomLevel = 1;

	/**
	 * Create a new BoundingBox object with default values.
	 *
	 * @return Application_Object_Mapping_BoundingBox the BoundingBox
	 */
	public static function createDefaultBoundingBox() {

		// Get the parameters from configuration file
		$configuration = Zend_Registry::get("configuration");

		$xMin = $configuration->getConfig('bbox_x_min');
		$xMax = $configuration->getConfig('bbox_x_max');
		$yMin = $configuration->getConfig('bbox_y_min');
		$yMax = $configuration->getConfig('bbox_y_max');

		return Application_Object_Mapping_BoundingBox::createBoundingBox($xMin, $xMax, $yMin, $yMax);
	}

	/**
	 * Create a new BoundingBox object, making sure that the Box is square.
	 *
	 * @param Integer $xmin
	 *        	x min position
	 * @param Integer $xmax
	 *        	x max position
	 * @param Integer $ymin
	 *        	y min position
	 * @param Integer $ymax
	 *        	y max position
	 * @param Integer $minSize
	 *        	min size (default to 10 000)
	 * @return Application_Object_Mapping_BoundingBox the BoundingBox
	 */
	public static function createBoundingBox($xmin, $xmax, $ymin, $ymax, $minSize = 10000) {
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

		$bb = new Application_Object_Mapping_BoundingBox();
		$bb->xmin = $xmin;
		$bb->ymin = $ymin;
		$bb->xmax = $xmax;
		$bb->ymax = $ymax;

		return $bb;
	}

	/**
	 * Create a new BoundingBox object from a WKT string,
	 * the string must be a POINT or a rectangle POLYGON
	 *
	 * @param Integer $wkt
	 *        	the WKT string
	 * @param Integer $margin
	 *        	add a margin around the bbox
	 * @param Integer $minSize
	 *        	min size (default to 10 000) the minSze applies after the margin.
	 * @return Application_Object_Mapping_BoundingBox the BoundingBox
	 */
	public static function createBoundingBoxFromWKT($wkt, $margin = 5000, $minSize = 10000) {

		// The WKT is a point or rectangle polygon (because it is already a bounding box)
		if (preg_match('/POINT\(([-.0-9]+) ([-.0-9]+)\)/i', $wkt, $matches)) {
			$xmin = $xmax = $matches[1];
			$ymin = $ymax = $matches[2];
		}
		else if (preg_match('/POLYGON\(\(([-.0-9]+) ([-.0-9]+),([-.0-9]+) ([-.0-9]+),([-.0-9]+) ([-.0-9]+),([-.0-9]+) ([-.0-9]+),([-.0-9]+) ([-.0-9]+)\)\)/i', $wkt, $matches)) {
			$x = array(
					$matches[1],
					$matches[3],
					$matches[5],
					$matches[7]
			);
			$y = array(
					$matches[2],
					$matches[4],
					$matches[6],
					$matches[8]
			);
			$xmin = min($x);
			$xmax = max($x);
			$ymin = min($y);
			$ymax = max($y);
		}
		else {
			$xmin = $xmax = $ymin = $ymax = 0;
		}

		if ($margin > 0) {
			$xmin -= $margin;
			$ymin -= $margin;
			$xmax += $margin;
			$ymax += $margin;
		}
		return Application_Object_Mapping_BoundingBox::createBoundingBox($xmin,$xmax,$ymin,$ymax,$minSize);
	}
}