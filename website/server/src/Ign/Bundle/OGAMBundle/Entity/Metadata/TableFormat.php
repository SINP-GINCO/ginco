<?php
namespace Ign\Bundle\OGAMBundle\Entity\Metadata;

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\ORM\Mapping as ORM;

/**
 * TableFormat
 *
 * @ORM\Table(name="metadata.table_format")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMBundle\Repository\Metadata\TableFormatRepository")
 */
class TableFormat extends Format {

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
	 * @ORM\ManyToMany(targetEntity="Model", mappedBy="tables")
	 */
	private $models;

	/**
	 * TableFormat constructor.
	 */
	public function __construct() {
		$this->models = new ArrayCollection();
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
		$this->primaryKeys = implode(",", $primaryKeys);
		
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

