<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Range
 *
 * @ORM\Table(name="metadata_work.range")
 * @ORM\Entity
 */
class Range {

	/**
	 *
	 * @var string @ORM\Column(name="unit", type="string", length=36, nullable=false)
	 *      @ORM\Id
	 *      @ORM\GeneratedValue(strategy="SEQUENCE")
	 *      @ORM\SequenceGenerator(sequenceName="metadata.range_unit_seq", allocationSize=1, initialValue=1)
	 */
	private $unit;

	/**
	 *
	 * @var float @ORM\Column(name="min", type="float", precision=10, scale=0, nullable=true)
	 */
	private $min;

	/**
	 *
	 * @var float @ORM\Column(name="max", type="float", precision=10, scale=0, nullable=true)
	 */
	private $max;

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
}
