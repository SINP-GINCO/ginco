<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

use Ign\Bundle\GincoBundle\Entity\Metadata\Data;
use Ign\Bundle\GincoBundle\Entity\Metadata\Format;
use Ign\Bundle\GincoBundle\Entity\Metadata\FieldInterface ;

/**
 * Field
 * @ORM\Table(name="metadata.field")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\FieldRepository")
 */
class Field implements FieldInterface {

	/**
	 *
	 * @var Data 
	 * 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Data", inversedBy="fields")
	 * @ORM\JoinColumn(name="data", referencedColumnName="data")
	 */
	protected $data;

	/**
	 *
	 * @var Format 
	 * 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Format")
	 * @ORM\JoinColumn(name="format", referencedColumnName="format")
	 */
	protected $format;
	
	/**
	 * The type of the field (FILE, FORM or TABLE).
	 *
	 * @var string 
	 * 
	 * @ORM\Column(name="type", type="string", length=36, nullable=true)
	 */
	protected $type;

	/**
	 * Set data
	 *
	 * @param Data $data
	 *
	 * @return field
	 */
	public function setData(Data $data) {
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
	 * Set type
	 *
	 * @param string $type
	 * @return Field
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