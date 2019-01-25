<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\Criteria;
use Doctrine\Common\Collections\ArrayCollection;

use Ign\Bundle\GincoBundle\Entity\Metadata\FormatInterface;
use Ign\Bundle\GincoBundle\Entity\Metadata\Format;

/**
 * FormFormat
 *
 * @ORM\Table(name="metadata.form_format")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\FormFormatRepository")
 */
class FormFormat implements \JsonSerializable {



	/**
	 *
	 * @var Format
	 * 
	 * @ORM\Id
	 * @ORM\OneToOne(targetEntity="Format")
	 * @ORM\JoinColumn(name="format", referencedColumnName="format")
	 */
	private $format; 
	
	/**
	 * The label of the form.
	 *
	 * @var string @ORM\Column(name="label", type="string", length=60, nullable=true)
	 */
	private $label;

	/**
	 * The definition of the form.
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=255, nullable=true)
	 */
	private $definition;

	/**
	 *
	 * @var int @ORM\Column(name="position", type="integer", nullable=true)
	 */
	private $position;

	/**
	 *
	 * @var bool @ORM\Column(name="is_opened", type="boolean", nullable=true)
	 */
	private $isOpened;
	
	
	/**
	 *
	 * @var FormField[]
	 * 
	 * @ORM\OneToMany(targetEntity="FormField", mappedBy="format")
	 */
	private $fields ;
	
	
	/**
	 * Constructor
	 */
	public function __construct() {
		$this->fields = new ArrayCollection();
	}
	

	/**
	 * Get format
	 * @return Format
	 */
	public function getFormat() {
		return $this->format ;
	}
	
	/**
	 * 
	 * @param Format $format
	 * @return $this
	 */
	public function setFormat(Format $format) {
		$this->format = $format ;
		return $this ;
	}
	
	/**
	 * Get format type (toujours FORM ici)
	 * @return string
	 */
	public function getType() {
		return $this->format->getType() ;
	}
	
	/**
	 * Set label
	 *
	 * @param string $label        	
	 *
	 * @return FormFormat
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
	 * @return FormFormat
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
	 * Set position
	 *
	 * @param integer $position        	
	 *
	 * @return FormFormat
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
	 * Set isOpened
	 *
	 * @param boolean $isOpened        	
	 *
	 * @return FormFormat
	 */
	public function setIsOpened($isOpened) {
		$this->isOpened = $isOpened;
		
		return $this;
	}

	/**
	 * Get isOpened
	 *
	 * @return bool
	 */
	public function getIsOpened() {
		return $this->isOpened;
	}

	/**
	 * Get criteria
	 *
	 * @return [GincoBundle\Entity\Metadata\FormField]
	 */
	public function getCriteria() {
		$criteria = Criteria::create()->where(Criteria::expr()->eq("isCriteria", true));
		return $this->getFields()->matching($criteria);
	}

	/**
	 * Get columns
	 *
	 * @return [GincoBundle\Entity\Metadata\FormField]
	 */
	public function getColumns() {
		$criteria = Criteria::create()->where(Criteria::expr()->eq("isResult", true));
		return $this->getFields()->matching($criteria);
	}

	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string JSON string
	 */
	public function jsonSerialize() {
		$json = [
			'id' => $this->getFormat()->getFormat(),
			'format' => $this->getFormat()->getFormat(),
			'label' => $this->label,
			'definition' => $this->definition,
			'position' => $this->position,
			'is_opened' => $this->isOpened
		];
		
		return $json ;
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
