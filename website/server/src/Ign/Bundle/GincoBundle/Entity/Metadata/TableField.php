<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

use Ign\Bundle\GincoBundle\Entity\Metadata\Data;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\Field;
use Ign\Bundle\GincoBundle\Entity\Metadata\FieldInterface;

/**
 * TableField
 *
 * @ORM\Table(name="metadata.table_field")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\TableFieldRepository")
 */
class TableField implements FieldInterface {

	/**
	 *
	 * @var string @ORM\Column(name="column_name", type="string", length=36, nullable=true)
	 */
	private $columnName;

	/**
	 *
	 * @var bool @ORM\Column(name="is_calculated", type="string", length=1, nullable=true)
	 */
	private $isCalculated;

	/**
	 *
	 * @var bool @ORM\Column(name="is_editable", type="string", length=1, nullable=true)
	 */
	private $isEditable;

	/**
	 *
	 * @var bool @ORM\Column(name="is_insertable", type="string", length=1, nullable=true)
	 */
	private $isInsertable;

	/**
	 *
	 * @var bool @ORM\Column(name="is_mandatory", type="string", length=1, nullable=true)
	 */
	private $isMandatory;

	/**
	 *
	 * @var integer @ORM\Column(name="position", type="integer", nullable=true)
	 */
	private $position;
	
	/**
	 *
	 * @var string @ORM\Column(name="default_value", type="string", length=255, nullable=true)
	 */
	private $defaultValue;
	
	/**
	 *
	 * @var integer @ORM\Column(name="comment", type="text", nullable=true)
	 */
	private $comment;
	
	/**
	 *
	 * @var Data
	 * 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Data")
	 * @ORM\JoinColumn(name="data", referencedColumnName="data")
	 */
	protected $data;
	
	
	/**
	 *
	 * @var TableFormat
	 * 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="TableFormat", inversedBy="fields")
	 * @ORM\JoinColumn(name="format", referencedColumnName="format")
	 */
	protected $format;
	
	/**
	 * Set columnName
	 *
	 * @param string $columnName        	
	 *
	 * @return TableField
	 */
	public function setColumnName($columnName) {
		$this->columnName = $columnName;
		
		return $this;
	}

	/**
	 * Get columnName
	 *
	 * @return string
	 */
	public function getColumnName() {
		return $this->columnName;
	}

	/**
	 * Set isCalculated
	 *
	 * @param boolean $isCalculated        	
	 *
	 * @return TableField
	 */
	public function setIsCalculated($isCalculated) {
		$this->isCalculated = $isCalculated;
		
		return $this;
	}

	/**
	 * Get isCalculated
	 *
	 * @return bool
	 */
	public function getIsCalculated() {
		return boolval($this->isCalculated);
	}

	/**
	 * Set isEditable
	 *
	 * @param boolean $isEditable        	
	 *
	 * @return TableField
	 */
	public function setIsEditable($isEditable) {
		$this->isEditable = $isEditable;
		
		return $this;
	}

	/**
	 * Get isEditable
	 *
	 * @return bool
	 */
	public function getIsEditable() {
		return boolval($this->isEditable);
	}

	/**
	 * Set isInsertable
	 *
	 * @param boolean $isInsertable        	
	 *
	 * @return TableField
	 */
	public function setIsInsertable($isInsertable) {
		$this->isInsertable = $isInsertable;
		
		return $this;
	}

	/**
	 * Get isInsertable
	 *
	 * @return bool
	 */
	public function getIsInsertable() {
		return boolval($this->isInsertable);
	}

	/**
	 * Set isMandatory
	 *
	 * @param boolean $isMandatory        	
	 *
	 * @return TableField
	 */
	public function setIsMandatory($isMandatory) {
		$this->isMandatory = $isMandatory;
		
		return $this;
	}

	/**
	 * Get isMandatory
	 *
	 * @return bool
	 */
	public function getIsMandatory() {
		return boolval($this->isMandatory);
	}

	/**
	 *
	 * @return the integer
	 */
	public function getPosition() {
		return $this->position;
	}

	/**
	 *
	 * @param integer $position        	
	 */
	public function setPosition($position) {
		$this->position = $position;
		return $this;
	}

	/**
	 *
	 * @return string
	 */
	public function getComment() {
		return $this->comment;
	}

	/**
	 *
	 * @param string $comment        	
	 */
	public function setComment($comment) {
		$this->comment = $comment;
		return $this;
	}

	
	/**
	 * Set data
	 * @param \Ign\Bundle\GincoBundle\Entity\Metadata\Data $data
	 * @return $this
	 */
	public function setData(Data $data) {
		$this->data = $data ;
		return $this ;
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
	 * Set data
	 * @param $format
	 * @return $this
	 */
	public function setFormat($format) {
		$this->format = $format ;
		return $this ;
	}
	
	/**
	 * Get format
	 * @return TableFormat
	 */
	public function getFormat() {
		return $this->format ;
	}
	

	
	public function getType() {
		return $this->data->getUnit()->getType() ;
	}

	
	/**
	 * Return the unique identifier of the field.
	 * ATTENTION : DUPLIQUE DEPUIS ENTITE Field
	 *
	 * @return String the identifier of the field
	 */
	function getName() {
		return $this->getFormat()->getFormat()->getFormat() . '__' . $this->getData()->getData();
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
	 * Get defaultValue
	 * @return String
	 */
	
	public function getDefaultValue() {
	    return $this->defaultValue;
	}
	
	/**
	 * Set DefaultValue
	 * @param string $defaultValue
	 *
	 */
	public function setDefaultValue($defaultValue) {
	    $this->defaultValue = $defaultValue;
	    return $this;
	}
}

