<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

/**
 * Field
 * @ORM\MappedSuperclass
 */
class Field {

	/**
	 *
	 * @var Data @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="Data")
	 *      @ORM\JoinColumns({@ORM\JoinColumn(name="data", referencedColumnName="data")})
	 */
	protected $data;

	/**
	 *
	 * @var Format @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="Format")
	 *      @ORM\JoinColumns({@ORM\JoinColumn(name="format", referencedColumnName="format")})
	 */
	protected $format;

	/**
	 * Set data
	 *
	 * @param Data $data
	 *
	 * @return field
	 */
	public function setData($data) {
		$this->data = $data;

		return $this;
	}

	/**
	 * Get data
	 *
	 * @return Data
	 */
	public function getData() {
		return $this->data;
	}

	/**
	 * Set format
	 *
	 * @param Format $format
	 *
	 * @return field
	 */
	public function setFormat($format) {
		$this->format = $format;

		return $this;
	}

	/**
	 * Get format
	 *
	 * @return Format
	 */
	public function getFormat() {
		return $this->format;
	}

	/**
	 * Return the unique identifier of the field.
	 *
	 * @return String the identifier of the field
	 */
	function getName() {
		return $this->getFormat()->getFormat() . '__' . $this->getData()->getData();
	}

	/**
	 * Return the label.
	 *
	 * @return String the label
	 */
	function getLabel() {
		if (isset($this->label)) {
			return $this->label;
		} else {
			return $this->getData()->getLabel();
		}
	}
}