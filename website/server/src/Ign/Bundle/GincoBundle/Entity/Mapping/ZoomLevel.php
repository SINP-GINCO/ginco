<?php
namespace Ign\Bundle\GincoBundle\Entity\Mapping;

use Doctrine\ORM\Mapping as ORM;

/**
 * Layer
 *
 * @ORM\Table(name="mapping.zoom_level")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Mapping\ZoomLevelRepository")
 */
class ZoomLevel implements \JsonSerializable {

	/**
	 * The zoom level number.
	 * 
	 * @var integer @ORM\Id
	 *      @ORM\Column(name="zoom_level", type="integer", unique=true, nullable=false, options={"comment"="The level of zoom"})
	 */
	private $zoomLevel;

	/**
	 * The zoom level resolution.
	 * 
	 * @var float @ORM\Column(name="resolution", type="decimal", nullable=false)
	 */
	private $resolution;

	/**
	 * The approximate scale denominator value corresponding to the resolution
	 * 
	 * @var integer @ORM\Column(name="approx_scale_denom", type="integer", nullable=false)
	 */
	private $approximateScaleDenominator;

	/**
	 * Label used for the zoom level
	 * 
	 * @var string @ORM\Column(name="scale_label", type="string", length=10, nullable=true)
	 */
	private $scaleLabel;

	/**
	 * Indicates if that zoom level must be used for the map
	 * 
	 * @var integer @ORM\Column(name="is_map_zoom_level", type="boolean", nullable=false)
	 */
	private $isMapZoomLevel;

	/**
	 * Get id
	 *
	 * @return string
	 */
	public function getId() {
		return $this->zoomLevel;
	}

	/**
	 *
	 * @return integer
	 */
	public function getZoomLevel() {
		return $this->zoomLevel;
	}

	/**
	 *
	 * @param integer $zoomLevel        	
	 */
	public function setZoomLevel($zoomLevel) {
		$this->zoomLevel = $zoomLevel;
		return $this;
	}

	/**
	 *
	 * @return float
	 */
	public function getResolution() {
		return $this->resolution;
	}

	/**
	 *
	 * @param
	 *        	$resolution
	 */
	public function setResolution($resolution) {
		$this->resolution = $resolution;
		return $this;
	}

	/**
	 *
	 * @return integer
	 */
	public function getApproximateScaleDenominator() {
		return $this->approximateScaleDenominator;
	}

	/**
	 *
	 * @param integer $approximateScaleDenominator        	
	 */
	public function setApproximateScaleDenominator($approximateScaleDenominator) {
		$this->approximateScaleDenominator = $approximateScaleDenominator;
		return $this;
	}

	/**
	 *
	 * @return string
	 */
	public function getScaleLabel() {
		return $this->scaleLabel;
	}

	/**
	 *
	 * @param
	 *        	$scaleLabel
	 */
	public function setScaleLabel($scaleLabel) {
		$this->scaleLabel = $scaleLabel;
		return $this;
	}

	/**
	 *
	 * @return integer
	 */
	public function getIsMapZoomLevel() {
		return $this->isMapZoomLevel;
	}

	/**
	 *
	 * @param integer $isMapZoomLevel        	
	 */
	public function setIsMapZoomLevel($isMapZoomLevel) {
		$this->isMapZoomLevel = $isMapZoomLevel;
		return $this;
	}

	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string JSON
	 */
	public function jsonSerialize() {
		return [
			'id' => $this->id,
			'zoomLevel' => $this->zoomLevel,
			'resolution' => $this->resolution,
			'approximateScaleDenominator' => $this->approximateScaleDenominator,
			'scaleLabel' => $this->scaleLabel,
			'isMapZoomLevel' => $this->isMapZoomLevel
		];
	}
}
