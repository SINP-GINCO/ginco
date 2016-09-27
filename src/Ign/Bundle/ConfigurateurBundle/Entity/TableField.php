<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * TableField
 *
 * @ORM\Table(name="metadata_work.table_field")
 * @ORM\Entity(repositoryClass="Ign\Bundle\ConfigurateurBundle\Entity\TableFieldRepository")
 */
class TableField {

	/**
	 *
	 * @var string @ORM\Column(name="data", type="string", length=277, nullable=false)
	 *      @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="Field")
	 *      @ORM\JoinColumn(name="data", referencedColumnName="data")
	 *      @ORM\GeneratedValue(strategy="NONE")
	 */
	private $data;

	/**
	 *
	 * @var string @ORM\Column(name="format", type="string", length=255, nullable=false)
	 *      @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="TableFormat", inversedBy="tableFields")
	 *      @ORM\JoinColumn(name="tableFormat", referencedColumnName="format")
	 *      @ORM\GeneratedValue(strategy="NONE")
	 */
	private $tableFormat;

	/**
	 *
	 * @var string @ORM\Column(name="column_name", type="string", length=277, nullable=true)
	 */
	private $columnName;

	/**
	 *
	 * @var string @ORM\Column(name="is_calculated", type="string", length=1, nullable=true)
	 */
	private $isCalculated;

	/**
	 *
	 * @var string @ORM\Column(name="is_editable", type="string", length=1, nullable=true)
	 */
	private $isEditable;

	/**
	 *
	 * @var string @ORM\Column(name="is_insertable", type="string", length=1, nullable=true)
	 */
	private $isInsertable;

	/**
	 *
	 * @var string @ORM\Column(name="is_mandatory", type="string", length=1, nullable=true)
	 */
	private $isMandatory;

	/**
	 *
	 * @var integer @ORM\Column(name="position", type="integer", nullable=true)
	 */
	private $position;

	/**
	 *
	 * @var string @ORM\Column(name="comment", type="string", length=255, nullable=true)
	 */
	private $comment;


	/**
	 * Set data
	 *
	 * @param string $data
	 * @return TableField
	 */
	public function setData($data) {
		$this->data = $data;

		return $this;
	}

	/**
	 * Get data
	 *
	 * @return string
	 */
	public function getData() {
		return $this->data;
	}

	/**
	 * Set format
	 *
	 * @param string $tableFormat
	 * @return TableField
	 */
	public function setTableFormat($tableFormat) {
		$this->tableFormat = $tableFormat;

		return $this;
	}

	/**
	 * Get tableFormat
	 *
	 * @return string
	 */
	public function getTableFormat() {
		return $this->tableFormat;
	}

	/**
	 * Set columnName
	 *
	 * @param string $columnName
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
	 * @param string $isCalculated
	 * @return TableField
	 */
	public function setIsCalculated($isCalculated) {
		$this->isCalculated = $isCalculated;

		return $this;
	}

	/**
	 * Get isCalculated
	 *
	 * @return string
	 */
	public function getIsCalculated() {
		return $this->isCalculated;
	}

	/**
	 * Set isEditable
	 *
	 * @param string $isEditable
	 * @return TableField
	 */
	public function setIsEditable($isEditable) {
		$this->isEditable = $isEditable;

		return $this;
	}

	/**
	 * Get isEditable
	 *
	 * @return string
	 */
	public function getIsEditable() {
		return $this->isEditable;
	}

	/**
	 * Set isInsertable
	 *
	 * @param string $isInsertable
	 * @return TableField
	 */
	public function setIsInsertable($isInsertable) {
		$this->isInsertable = $isInsertable;

		return $this;
	}

	/**
	 * Get isInsertable
	 *
	 * @return string
	 */
	public function getIsInsertable() {
		return $this->isInsertable;
	}

	/**
	 * Set isMandatory
	 *
	 * @param string $isMandatory
	 * @return TableField
	 */
	public function setIsMandatory($isMandatory) {
		$this->isMandatory = $isMandatory;

		return $this;
	}

	/**
	 * Get isMandatory
	 *
	 * @return string
	 */
	public function getIsMandatory() {
		return $this->isMandatory;
	}

	/**
	 * Set position
	 *
	 * @param integer $position
	 * @return TableField
	 */
	public function setPosition($position) {
		$this->position = $position;

		return $this;
	}

	/**
	 * Get position
	 *
	 * @return integer
	 */
	public function getPosition() {
		return $this->position;
	}

	/**
	 * Set comment
	 *
	 * @param string $comment
	 * @return TableField
	 */
	public function setComment($comment) {
		$this->comment = $comment;

		return $this;
	}

	/**
	 * Get comment
	 *
	 * @return string
	 */
	public function getComment() {
		return $this->comment;
	}

	/**
	 * Rewrite primary keys data
	 *
	 * @return string
	 */
	public function __toString() {
		// If this field is a key (primary or foreign), overwrites it for readability
		if (strpos($this->getData(), TableFormat::PK_PREFIX) === 0) {
			$format = substr($this->getData(), strlen(TableFormat::PK_PREFIX));
			// Ugly but no other solution...
			global $kernel;
			if ('AppCache' == get_class($kernel)) {
				$kernel = $kernel->getKernel();
			}
			$em = $kernel->getContainer()->get( 'doctrine.orm.entity_manager' );
			$tableFormat = $em->getRepository('IgnConfigurateurBundle:TableFormat')->find($format);
			$tableLabel = $tableFormat->getLabel();

			$trans = $kernel->getContainer()->get('translator');

			// Primary key or foreign key ?
			if ($format == $this->getTableFormat())
				return $trans->trans('data.primary_key', array('%tableLabel%' => $tableLabel));
			else
				return $trans->trans('data.foreign_key', array('%tableLabel%' => $tableLabel));
		}
		else {
			return $this->getData();
		}
	}
}
