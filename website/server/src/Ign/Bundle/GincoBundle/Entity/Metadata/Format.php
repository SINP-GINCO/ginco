<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

/**
 * Represent an abstract Format.
 *
 * @ORM\MappedSuperclass
 */
class Format {

	/**
	 * The format identifier.
	 * (Must stay private to pass the entity validation)
	 * 
	 * @var string @ORM\Id
	 *      @ORM\Column(name="format", type="string", length=36, unique=true)
	 */
	private $format;

	protected $fields;

	/**
	 * Constructor
	 */
	public function __construct() {
		$this->fields = new ArrayCollection();
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

