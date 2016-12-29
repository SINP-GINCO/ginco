<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Metadata.unit
 *
 * @ORM\Table(name="metadata_work.unit")
 * @ORM\Entity
 */
class Unit {

	/**
	 *
	 * @var string @ORM\Column(name="unit", type="string", length=36, nullable=false)
	 *      @ORM\Id
	 */
	private $name;

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
	 * Get unit
	 *
	 * @return string
	 */
	public function getName() {
		return $this->name;
	}

	/**
	 * Set name
	 *
	 * @param string $name        	
	 * @return Unit
	 */
	public function setName($name) {
		$this->name = $name;
		
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
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }

	/**
	 * Return concatenation of name and label
	 *
	 * @return string
	 */
	public function __toString() {
		return ($this->label) ? $this->name.': '.$this->label : $this->name;
	}
}
