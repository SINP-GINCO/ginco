<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * Mode.
 *
 * @ORM\Table(name="metadata.mode")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\ModeRepository")
 */
class Mode {

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="unit", type="string", length=36)
	 */
	private $unit;

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="code", type="string", length=36)
	 */
	private $code;

	/**
	 *
	 * @var int @ORM\Column(name="position", type="integer", nullable=true)
	 */
	private $position;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=255, nullable=true)
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=255, nullable=true)
	 */
	private $definition;

	public function getId() {
		return $this->getUnit() . '__' . $this->getCode();
	}

	/**
	 * Set unit
	 *
	 * @param string $unit        	
	 *
	 * @return Mode
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
	 * Set code
	 *
	 * @param string $code        	
	 *
	 * @return Mode
	 */
	public function setCode($code) {
		$this->code = $code;
		
		return $this;
	}

	/**
	 * Get code
	 *
	 * @return string
	 */
	public function getCode() {
		return $this->code;
	}

	/**
	 * Set position
	 *
	 * @param integer $position        	
	 *
	 * @return Mode
	 */
	public function setPosition($position) {
		$this->position = $position;
		
		return $this;
	}

	/**
	 * Get position
	 *
	 * @return int
	 */
	public function getPosition() {
		return $this->position;
	}

	/**
	 * Set label
	 *
	 * @param string $label        	
	 *
	 * @return Mode
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
	 *
	 * @return Mode
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
}

