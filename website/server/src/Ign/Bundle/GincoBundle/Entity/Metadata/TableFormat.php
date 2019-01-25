<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

use Ign\Bundle\GincoBundle\Entity\Metadata\TableField;
use Ign\Bundle\GincoBundle\Entity\Metadata\Format;

use Ign\Bundle\GincoBundle\Entity\Metadata\FormatInterface;

/**
 * TableFormat
 *
 * @ORM\Table(name="metadata.table_format")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\TableFormatRepository")
 */
class TableFormat implements FormatInterface {

	// Prefix used in primary key fields names
	const PK_PREFIX = 'OGAM_ID_';

	/**
	 *
	 * The format of the table is its id. It is generated in the controller via uniqid function.
	 *
	 * @var Format 
	 * 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Format")
	 * @ORM\JoinColumn(name="format", referencedColumnName="format")
	 */
	protected $format;
	
	/**
	 * The real name of the table.
	 * 
	 * @var string @ORM\Column(name="table_name", type="string", length=36)
	 */
	private $tableName;

	/**
	 * The schema identifier.
	 * 
	 * @var TableSchema @ORM\ManyToOne(targetEntity="TableSchema")
	 *      @ORM\JoinColumn(name="schema_code", referencedColumnName="schema_code")
	 */
	private $schema;

	/**
	 * The primary key.
	 * Stored as a comma-separated list in a tring.
	 *
	 * @var string @ORM\Column(name="primary_key", type="string", length=255, nullable=true)
	 */
	private $primaryKeys;

	/**
	 * The label.
	 * 
	 * @var string @ORM\Column(name="label", type="string", length=255, nullable=true)
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
	 * @ORM\ManyToMany(targetEntity="Model", mappedBy="tables")
	 */
	private $models;
	
	/**
	 *
	 * @var ArrayCollection
	 * 
	 * @ORM\OneToMany(targetEntity="TableField", mappedBy="format")
	 */
	protected $fields ;

	/**
	 * TableFormat constructor.
	 */
	public function __construct() {
		$this->fields = new ArrayCollection();
		$this->models = new ArrayCollection();
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
	 * @return Format
	 */
	public function getFormat() {
		return $this->format;
	}

	/**
	 * Set tableName
	 *
	 * @param string $tableName        	
	 *
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
	 * Get schema
	 * 
	 * @return TableSchema
	 */
	public function getSchema() {
		return $this->schema;
	}

	/**
	 * set schema
	 * 
	 * @param TableSchema $schema        	
	 * @return TableFormat
	 */
	public function setSchema($schema) {
		$this->schema = $schema;
		return $this;
	}

	/**
	 * Get schemaCode
	 *
	 * @return string
	 */
	public function getSchemaCode() {
		return $this->getSchema()->getCode();
	}

	/**
	 * Set primaryKeys
	 *
	 * @param array $primaryKeys
	 *
	 * @return TableFormat
	 */
	public function setPrimaryKeys($primaryKeys) {
		if (!empty($primaryKeys)) {
			$this->primaryKeys = implode(",", $primaryKeys) ;
		} else {
			$this->primaryKeys = $this->getPkName() . ',PROVIDER_ID, USER_LOGIN';
		}
		
		
		return $this;
	}

	/**
	 * Get primaryKeys
	 *
	 * @return array
	 */
	public function getPrimaryKeys() {
		$primaryKeys = array();
		$pks = explode(",", $this->primaryKeys);
		foreach ($pks as $pk) {
			$primaryKeys[] = trim($pk); // we need to trim all the values
		}
		
		return $primaryKeys;
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
	 *
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
	 * @param TableField $tableField
	 * @return TableFormat
	 */
	public function addField(TableField $tableField) {
		$this->fields->add($tableField);

		return $this;
	}

	/**
	 * Remove tableFields
	 *
	 * @param \TableField $tableField
	 */
	public function removeField(TableField $tableField) {
		$this->fields->removeElement($tableField);
	}

	/**
	 * Get tableFields
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getFields() {
		return $this->fields;
	}
	
	
	/**
	 * Get mandatory and not calculated fields.
	 * @return ArrayCollection
	 */
	public function getMandatoryAndNotCalculatedFields() {
		
		return $this->fields->filter(function($field) {
			return $field->getIsMandatory() && !$field->getIsCalculated() ;
		}) ;
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

