<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * Range
 *
 * @ORM\Table(name="metadata.range")
 * @ORM\Entity
 */
class Range implements \JsonSerializable {

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="unit", type="string", length=36, unique=true)
	 */
	private $unit;

	/**
	 *
	 * @var float @ORM\Column(name="min", type="float", nullable=true)
	 */
	private $min;

	/**
	 *
	 * @var float @ORM\Column(name="max", type="float", nullable=true)
	 */
	private $max;

	/**
	 * Set unit
	 *
	 * @param string $unit        	
	 *
	 * @return Range
	 */
	public function setUnit($unit) {
		$this->unit = $unit;
		
		return $this;
	}

	/**
	 * Get unit
	 *
	 * @return string
	 */
	public function getUnit() {
		return $this->unit;
	}

	/**
	 * Set min
	 *
	 * @param float $min        	
	 *
	 * @return Range
	 */
	public function setMin($min) {
		$this->min = $min;
		
		return $this;
	}

	/**
	 * Get min
	 *
	 * @return float
	 */
	public function getMin() {
		return $this->min;
	}

	/**
	 * Set max
	 *
	 * @param float $max        	
	 *
	 * @return Range
	 */
	public function setMax($max) {
		$this->max = $max;
		
		return $this;
	}

	/**
	 * Get max
	 *
	 * @return float
	 */
	public function getMax() {
		return $this->max;
	}

	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string JSON string
	 */
	public function jsonSerialize() {
		return [
			'id' => $this->unit,
			'unit' => $this->unit,
			'min' => $this->min,
			'max' => $this->max
		];
	}
}

