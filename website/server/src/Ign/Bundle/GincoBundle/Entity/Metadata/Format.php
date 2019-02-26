<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

use Ign\Bundle\GincoBundle\Entity\Metadata\FormatInterface;

/**
 * Represent an abstract Format.
 *
 * @ORM\Table(name="metadata.format")
 * @ORM\Entity
 */
class Format implements FormatInterface {

	/**
	 * The format identifier.
	 * (Must stay private to pass the entity validation)
	 * 
	 * @var string 
	 * 
	 * @ORM\Id
	 * @ORM\Column(name="format", type="string", length=36, unique=true)
	 */
	protected $format;
	
	/**
	 *
	 * @var string 
	 * 
	 * @ORM\Column(name="type",type="string", length=36, nullable=false)
	 */
	protected $type;

	protected $fields;

	/**
	 * Constructor
	 */
	public function __construct() {
		$this->fields = new ArrayCollection();
	}

	public function __toString() {
		return $this->format;
	}
	
	/**
	 * Set format
	 *
	 * @param string $format        	
	 *
	 * @return Format
	 */
	public function setFormat($format) {
		$this->format = $format;
		
		return $this;
	}

	/**
	 * Get format
	 *
	 * @return string
	 */
	public function getFormat() {
		return $this->format;
	}
	
		/**
	 * Set type
	 *
	 * @param string $type
	 * @return Format
	 */
	public function setType($type) {
		$this->type = $type;

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
	 *
	 * @return mixed
	 */
	public function getFields() {
		return $this->fields;
	}

	/**
	 *
	 * @param mixed $fields
	 */
	public function setFields($fields) {
		if ($fields instanceof ArrayCollection) {
			$this->fields = $fields;
		} elseif (is_array($fields)) {
			$this->fields = new ArrayCollection($fields);
		} else {
			throw new \InvalidArgumentException('Arguments must be of type Array or ArrayCollection');
		}
		return $this;
	}
}

