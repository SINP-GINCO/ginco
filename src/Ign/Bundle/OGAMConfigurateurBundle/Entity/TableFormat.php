<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * TableFormat
 *
 * @ORM\Table(name="metadata_work.table_format")
 * @ORM\Entity
 */
class TableFormat {

	// Prefix used in primary key fields names
	const PK_PREFIX = 'OGAM_ID_';

	/**
	 *
	 * The format of the table is its id. It is generated in the controller via uniqid function.
	 *
	 * @var string @ORM\Column(name="format", type="string", length=36, nullable=false)
	 *      @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="Format")
	 *      @ORM\JoinColumn(name="format", referencedColumnName="format")
	 *      @ORM\GeneratedValue(strategy="NONE")
	 */
	private $format;

	/**
	 *
	 * The tableName is generated. It is composed of the id of the model (preceded by an underscore) and the name of the table, as entered
	 * by the user.
	 * Note : the id of the model is preceded by an underscore as this field will be the actual name of the table once generated.
	 * because in SQL, a column or table name can't (or should not) start by a number.
	 *
	 * @var string @ORM\Column(name="table_name", type="string", length=64, nullable=true,unique=true)
	 *
	 */
	private $tableName;

	/**
	 *
	 * @var string @ORM\Column(name="schema_code", type="string", length=36, nullable=true,unique=true)
	 *      @ORM\ManyToOne(targetEntity="TableSchema")
	 *      @ORM\JoinColumn(name="schema_code", referencedColumnName="schema_code")
	 *
	 */
	private $schemaCode;

	/**
	 *
	 * @var string @ORM\Column(name="primary_key", type="string", length=255, nullable=true)
	 */
	private $primaryKey;

	/**
	 *
	 * The label contains the name of the table as entered by the user.
	 *
	 * @var string @Assert\NotBlank(message="tableFormat.label.notBlank")
	 *      @ORM\Column(name="label", type="string", length=100, nullable=true)
	 *      @Assert\Regex(pattern="/^[a-z0-9_]*$/", match=true, message="tableFormat.label.regex")
	 *      @Assert\Length(max="100", maxMessage="tableFormat.label.maxLength")
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=255, nullable=true)
	 *      @Assert\Length(max="255", maxMessage="tableFormat.description.maxLength")
	 */
	private $description;

	/**
	 * The parent attribute is not mapped.
	 * The relation between the child table and parent table is though present in table_tree table.
	 *
	 * @var string the format (id) of the parent
	 */
	private $parent;

	/**
	 *
	 * @ORM\ManyToMany(targetEntity="Model", mappedBy="tables")
	 */
	private $models;

	public function __construct() {
		$this->tableFields = new \Doctrine\Common\Collections\ArrayCollection();
		$this->models = new \Doctrine\Common\Collections\ArrayCollection();
	}

	/**
	 * Set format
	 *
	 * @return TableFormat
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
	 * Set tableName
	 *
	 * @param string $tableName
	 * @return TableFormat
	 */
	public function setTableName($tableName) {
		$this->tableName = $tableName;

		return $this;
	}

	/**
	 * Get tableName
	 *
	 * @return string
	 */
	public function getTableName() {
		return $this->tableName;
	}

	/**
	 * Set schemaCode
	 *
	 * @param string $schemaCode
	 * @return TableFormat
	 */
	public function setSchemaCode($schemaCode) {
		$this->schemaCode = $schemaCode;

		return $this;
	}

	/**
	 * Get schemaCode
	 *
	 * @return string
	 */
	public function getSchemaCode() {
		return $this->schemaCode;
	}

	/**
	 * Set primaryKey
	 *
	 * @param string $primaryKey
	 * @return TableFormat
	 */
	public function setPrimaryKey($primaryKey = '') {
		if ($primaryKey) {
			$this->primaryKey = $primaryKey;
		}
		else {
			$this->primaryKey = $this->getPkName() . ',PROVIDER_ID, USER_LOGIN';
		}
		return $this;
	}

	/**
	 * Get primaryKey
	 *
	 * @return string
	 */
	public function getPrimaryKey() {
		return $this->primaryKey;
	}

	/**
	 * Get how should be named the observation part of the primary key
	 * i.e. pk can be composed of several fields : this one is not provider_id or submission_id
	 *
	 * @return string
	 */
	public function getPkName() {
		return self::PK_PREFIX . $this->getFormat();
	}

	/**
	 * Set label
	 *
	 * @param string $label
	 * @return TableFormat
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
	 * Set description
	 *
	 * @param string $description
	 * @return TableFormat
	 */
	public function setDescription($description) {
		$this->description = $description;

		return $this;
	}

	/**
	 * Get description
	 *
	 * @return string
	 */
	public function getDescription() {
		return $this->description;
	}

	/**
	 * Set parent
	 *
	 * @param string $parent
	 * @return TableFormat
	 */
	public function setParent($parent) {
		$this->parent = $parent;

		return $this;
	}

	/**
	 * Get parent
	 *
	 * @return string
	 */
	public function getParent() {
		return $this->parent;
	}

	/**
	 * Add tableFields
	 *
	 * @param \Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField $tableFields
	 * @return TableFormat
	 */
	public function addTableField(\Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField $tableFields) {
		$this->tableFields[] = $tableFields;

		return $this;
	}

	/**
	 * Remove tableFields
	 *
	 * @param \Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField $tableFields
	 */
	public function removeTableField(\Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField $tableFields) {
		$this->tableFields->removeElement($tableFields);
	}

	/**
	 * Get tableFields
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getTableFields() {
		return $this->tableFields;
	}

    /**
     * Get model
	 * Relation is a ManytoMany, with uniqueness, so in fact a ManyToOne
	 * getModel returns the first and only element of the $models arrayCollection
     *
     * @return \Doctrine\Common\Collections\Collection
     */
    public function getModel()
    {
        return $this->models->first();
    }
}
