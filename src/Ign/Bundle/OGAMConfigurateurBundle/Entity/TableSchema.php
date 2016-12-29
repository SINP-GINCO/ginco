<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * TableSchema
 *
 * @ORM\Table(name="metadata_work.table_schema")
 * @ORM\Entity
 */
class TableSchema {

	/**
	 *
	 * @var string @ORM\Column(name="schema_code", type="string", length=36, nullable=false)
	 *      @ORM\Id
	 */
	private $schemaCode;

	/**
	 *
	 * @var string @ORM\Column(name="schema_name", type="string", length=36, nullable=false)
	 */
	private $schemaName;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=36, nullable=true)
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="description", type="string", length=255, nullable=true)
	 */
	private $description;

	/**
	 * Set schemaCode
	 *
	 * @param string $schemaCode        	
	 * @return TableSchema
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
	 * Set schemaName
	 *
	 * @param string $schemaName        	
	 * @return TableSchema
	 */
	public function setSchemaName($schemaName) {
		$this->schemaName = $schemaName;
		return $this;
	}

	/**
	 * Get schemaName
	 *
	 * @return string
	 */
	public function getSchemaName() {
		return $this->schemaName;
	}

	/**
	 * Set label
	 *
	 * @param string $label        	
	 * @return TableSchema
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
	 * @return TableSchema
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
}
