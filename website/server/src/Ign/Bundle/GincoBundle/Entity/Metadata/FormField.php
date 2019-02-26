<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

use Ign\Bundle\GincoBundle\Entity\Metadata\Data;
use Ign\Bundle\GincoBundle\Entity\Metadata\FieldInterface;

/**
 * FormField
 *
 * @ORM\Table(name="metadata.form_field")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\FormFieldRepository")
 */
class FormField implements \JsonSerializable, FieldInterface {
	
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
	 * @var FormFormat 
	 * 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="FormFormat", inversedBy="fields")
	 * @ORM\JoinColumn(name="format", referencedColumnName="format")
	 */
	protected $format;

	/**
	 *
	 * @var bool @ORM\Column(name="is_criteria", type="boolean", nullable=true)
	 */
	private $isCriteria;

	/**
	 *
	 * @var bool @ORM\Column(name="is_result", type="boolean", nullable=true)
	 */
	private $isResult;

	/**
	 *
	 * @var string @ORM\Column(name="input_type", type="string", length=128, nullable=true)
	 */
	private $inputType;

	/**
	 *
	 * @var int @ORM\Column(name="position", type="integer", nullable=true)
	 */
	private $position;

	/**
	 *
	 * @var bool @ORM\Column(name="is_default_criteria", type="boolean", nullable=true)
	 */
	private $isDefaultCriteria;

	/**
	 *
	 * @var bool @ORM\Column(name="is_default_result", type="boolean", nullable=true)
	 */
	private $isDefaultResult;

	/**
	 *
	 * @var string @ORM\Column(name="default_value", type="string", length=255, nullable=true)
	 */
	private $defaultValue;

	/**
	 *
	 * @var int @ORM\Column(name="decimals", type="integer", nullable=true)
	 */
	private $decimals;

	/**
	 *
	 * @var string @ORM\Column(name="mask", type="string", length=100, nullable=true)
	 */
	private $mask;

	
	/**
	 * Get data
	 * @return Data
	 */
	public function getData() {
		return $this->data ;
	}
	
	/**
	 * Set Data
	 * @param Data $data
	 * @return $this
	 */
	public function setData(Data $data) {
		$this->data = $data ;
		return $this ;
	}
	
	/**
	 * Get format
	 * @return FormFormat
	 */
	public function getFormat() {
		return $this->format;
	}
	
	/**
	 * Set format
	 * @param FormFormat $format
	 * @return $this
	 */
	public function setFormat($format) {
		$this->format = $format;
		return $this ;
	}
	
	/**
	 * Set isCriteria
	 *
	 * @param boolean $isCriteria        	
	 *
	 * @return FormField
	 */
	public function setIsCriteria($isCriteria) {
		$this->isCriteria = $isCriteria;
		
		return $this;
	}

	/**
	 * Get isCriteria
	 *
	 * @return bool
	 */
	public function getIsCriteria() {
		return $this->isCriteria;
	}

	/**
	 * Set isResult
	 *
	 * @param boolean $isResult        	
	 *
	 * @return FormField
	 */
	public function setIsResult($isResult) {
		$this->isResult = $isResult;
		
		return $this;
	}

	/**
	 * Get isResult
	 *
	 * @return bool
	 */
	public function getIsResult() {
		return $this->isResult;
	}

	/**
	 * Set inputType
	 *
	 * @param string $inputType        	
	 *
	 * @return FormField
	 */
	public function setInputType($inputType) {
		$this->inputType = $inputType;
		
		return $this;
	}

	/**
	 * Get inputType
	 *
	 * @return string
	 */
	public function getInputType() {
		return $this->inputType;
	}

	/**
	 * Set position
	 *
	 * @param integer $position        	
	 *
	 * @return FormField
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
	 * Set isDefaultCriteria
	 *
	 * @param boolean $isDefaultCriteria        	
	 *
	 * @return FormField
	 */
	public function setIsDefaultCriteria($isDefaultCriteria) {
		$this->isDefaultCriteria = $isDefaultCriteria;
		
		return $this;
	}

	/**
	 * Get isDefaultCriteria
	 *
	 * @return bool
	 */
	public function getIsDefaultCriteria() {
		return $this->isDefaultCriteria;
	}

	/**
	 * Set isDefaultResult
	 *
	 * @param boolean $isDefaultResult        	
	 *
	 * @return FormField
	 */
	public function setIsDefaultResult($isDefaultResult) {
		$this->isDefaultResult = $isDefaultResult;
		
		return $this;
	}

	/**
	 * Get isDefaultResult
	 *
	 * @return bool
	 */
	public function getIsDefaultResult() {
		return $this->isDefaultResult;
	}

	/**
	 * Set defaultValue
	 *
	 * @param integer $defaultValue        	
	 *
	 * @return FormField
	 */
	public function setDefaultValue($defaultValue) {
		$this->defaultValue = $defaultValue;
		
		return $this;
	}

	/**
	 * Get defaultValue
	 *
	 * @return int
	 */
	public function getDefaultValue() {
		return $this->defaultValue;
	}

	/**
	 * Set decimals
	 *
	 * @param integer $decimals        	
	 *
	 * @return FormField
	 */
	public function setDecimals($decimals) {
		$this->decimals = $decimals;
		
		return $this;
	}

	/**
	 * Get decimals
	 *
	 * @return int
	 */
	public function getDecimals() {
		return $this->decimals;
	}

	/**
	 * Set mask
	 *
	 * @param string $mask        	
	 *
	 * @return FormField
	 */
	public function setMaks($mask) {
		$this->mask = $mask;
		
		return $this;
	}

	/**
	 * Get mask
	 *
	 * @return string
	 */
	public function getMask() {
		return $this->mask;
	}

	/**
	 * Set mask
	 *
	 * @param string $mask        	
	 *
	 * @return FormField
	 */
	public function setMask($mask) {
		$this->mask = $mask;
		
		return $this;
	}

	/**
	 * Get id
	 *
	 * @return string
	 */
	public function getId() {
		$id = $this->format->getFormat()->getFormat() . '__' . $this->data->getData();
		return $id ;
	}
	
	/**
	 * Return the unique identifier of the field.
	 *
	 * @return String the identifier of the field
	 */
	function getName() {
		return $this->getId() ;
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

	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string JSON string
	 */
	public function jsonSerialize() {
		return [
			'id' => $this->getId(),
			'data' => $this->data->getData(),
			'format' => $this->format->getFormat()->getFormat(),
			'is_criteria' => $this->isCriteria,
			'is_result' => $this->isResult,
			'input_type' => $this->inputType,
			'position' => $this->position,
			'is_default_criteria' => $this->isDefaultCriteria,
			'is_default_result' => $this->isDefaultResult,
			'default_value' => $this->defaultValue,
			'decimals' => $this->decimals,
			'mask' => $this->mask
		];
	}
}
