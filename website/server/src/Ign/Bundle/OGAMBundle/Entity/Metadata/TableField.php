<?php
namespace Ign\Bundle\OGAMBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * TableField
 *
 * @ORM\Table(name="metadata.table_field")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMBundle\Repository\Metadata\TableFieldRepository")
 */
class TableField extends Field {

	/**
	 *
	 * @var string @ORM\Column(name="column_name", type="string", length=36, nullable=true)
	 */
	private $columnName;

	/**
	 *
	 * @var bool @ORM\Column(name="is_calculated", type="boolean", nullable=true)
	 */
	private $isCalculated;

	/**
	 *
	 * @var bool @ORM\Column(name="is_editable", type="boolean", nullable=true)
	 */
	private $isEditable;

	/**
	 *
	 * @var bool @ORM\Column(name="is_insertable", type="boolean", nullable=true)
	 */
	private $isInsertable;

	/**
	 *
	 * @var bool @ORM\Column(name="is_mandatory", type="boolean", nullable=true)
	 */
	private $isMandatory;

	/**
	 *
	 * @var integer @ORM\Column(name="position", type="integer", nullable=true)
	 */
	private $position;

	/**
	 *
	 * @var integer @ORM\Column(name="comment", type="text", nullable=true)
	 */
	private $comment;

	/**
	 *
	 * @var Format @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="TableFormat")
	 *      @ORM\JoinColumns({@ORM\JoinColumn(name="format", referencedColumnName="format")})
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
		return $this->isCalculated;
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
		return $this->isEditable;
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
		return $this->isInsertable;
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
		return $this->isMandatory;
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
}

