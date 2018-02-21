<?php
namespace Ign\Bundle\OGAMBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * Metadata.unit
 *
 * @ORM\Table(name="metadata.unit")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMBundle\Repository\Metadata\UnitRepository")
 */
class Unit implements \JsonSerializable {

	/**
	 *
	 * @var string @ORM\Column(name="unit", type="string", length=36, nullable=false)
	 *      @ORM\Id
	 */
	private $unit;

	/**
	 *
	 * @var string @ORM\Column(name="type", type="string", length=36, nullable=true)
	 */
	private $type;

	/**
	 *
	 * @var string @ORM\Column(name="subtype", type="string", length=36, nullable=true)
	 */
	private $subtype;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=60, nullable=true)
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=255, nullable=true)
	 */
	private $definition;

	/**
	 *
	 * @var Range @ORM\OneToOne(targetEntity="Range", fetch="EAGER")
	 *      @ORM\JoinColumn(name="unit", referencedColumnName="unit", nullable=true)
	 */
	private $range;

	/**
	 *
	 * @var Dynamode @ORM\OneToOne(targetEntity="Dynamode", fetch="EAGER")
	 *      @ORM\JoinColumn(name="unit", referencedColumnName="unit", nullable=true)
	 */
	private $dynamode;

	/**
	 *
	 * @var [OGAMBundle\Entity\Metadata\Mode]
	 */
	private $modes = null;

	/**
	 * Get unit
	 *
	 * @return string
	 */
	public function getUnit() {
		return $this->unit;
	}

	/**
	 * Set unit
	 *
	 * @param string $unit        	
	 * @return Unit
	 */
	public function setUnit($unit) {
		$this->unit = $unit;
		
		return $this;
	}

	/**
	 * Get type
	 *
	 * @return string
	 */
	public function getType() {
		return $this->type;
	}

	/**
	 * Set subtype
	 *
	 * @param string $subtype        	
	 * @return Unit
	 */
	public function setSubtype($subtype) {
		$this->subtype = $subtype;
		
		return $this;
	}

	/**
	 * Get subtype
	 *
	 * @return string
	 */
	public function getSubtype() {
		return $this->subtype;
	}

	/**
	 * Set label
	 *
	 * @param string $label        	
	 * @return Unit
	 */
	public function setLabel($label) {
		$this->label = $label;
		
		return $this;
	}

	/**
	 * Get label
	 *
	 * @return string
	 */
	public function getLabel() {
		return $this->label;
	}

	/**
	 * Set definition
	 *
	 * @param string $definition        	
	 * @return Unit
	 */
	public function setDefinition($definition) {
		$this->definition = $definition;
		
		return $this;
	}

	/**
	 * Get definition
	 *
	 * @return string
	 */
	public function getDefinition() {
		return $this->definition;
	}

	/**
	 * Set type
	 *
	 * @param string $type        	
	 * @return Unit
	 */
	public function setType($type) {
		$this->type = $type;
		
		return $this;
	}

	/**
	 * Return concatenation of name and label
	 *
	 * @return string
	 */
	public function __toString() {
		return ($this->label) ? $this->name . ': ' . $this->label : $this->name;
	}

	/**
	 * Get the range
	 *
	 * @return Range
	 */
	public function getRange() {
		return $this->range;
	}

	/**
	 * Set the range
	 *
	 * @param
	 *        	OGAMBundle\Entity\Metadata\Range
	 */
	public function setRange($range) {
		$this->range = $range;
		return $this;
	}

	/**
	 * Get the modes
	 *
	 * @return Mode[]
	 */
	public function getModes() {
		return $this->modes;
	}

	/**
	 * Set the modes
	 *
	 * @param
	 *        	[OGAMBundle\Entity\Metadata\Mode]
	 */
	public function setModes($modes) {
		$this->modes = $modes;
		return $this;
	}

	/**
	 *
	 * @return Dynamode
	 */
	public function getDynamode() {
		return $this->dynamode;
	}

	/**
	 *
	 * @param Dynamode $dynamode
	 */
	public function setDynamode(Dynamode $dynamode) {
		$this->dynamode = $dynamode;
		return $this;
	}

	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string: JSON string
	 */
	public function jsonSerialize() {
		return [
			'id' => $this->unit,
			'unit' => $this->unit,
			'type' => $this->type,
			'subtype' => $this->subtype,
			'label' => $this->label,
			'definition' => $this->definition,
			'range' => $this->getRange()
		];
	}
}