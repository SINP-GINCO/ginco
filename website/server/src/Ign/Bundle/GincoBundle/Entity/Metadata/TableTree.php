<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableSchema;

/**
 * TableTreeData
 *
 * @ORM\Table(name="metadata.table_tree")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\TableTreeRepository")
 */
class TableTree {

	/**
	 * @ORM\ManyToOne(targetEntity="TableSchema")
	 * @ORM\JoinColumn(name="schema_code", referencedColumnName="schema_code")
	 * @ORM\Id
	 */
	private $schema;

	/**
	 * @ORM\ManyToOne(targetEntity="TableFormat")
	 * @ORM\JoinColumn(name="child_table", referencedColumnName="format")
	 * @ORM\Id
	 */
	private $childTable;

	/**
	 * @ORM\ManyToOne(targetEntity="TableFormat")
	 * @ORM\JoinColumn(name="parent_table", referencedColumnName="format", nullable=true)
	 */
	private $parentTable;

	/**
	 *
	 * @var string @ORM\Column(name="join_key", type="string", length=255)
	 */
	private $joinKey;

	/**
	 *
	 * @var string @ORM\Column(name="comment", type="string", length=255)
	 */
	private $comment;

	
	/**
	 * Get schema
	 * @return TableSchema
	 */
	public function getSchema() {
		return $this->schema ;
	}
	
	
	/**
	 * Set schema
	 * @param TableSchema $schema
	 * @return $this
	 */
	public function setSchema(TableSchema $schema) {
		$this->schema = $schema ;
		return $this ;
	}
	
	/**
	 * Set tableFormat
	 *
	 * @param TableFormat $tableFormat        	
	 *
	 * @return TableTree
	 */
	public function setChildTable(TableFormat $tableFormat) {
		$this->childTable = $tableFormat;
		
		return $this;
	}

	/**
	 * Get child table
	 *
	 * @return TableFormat
	 */
	public function getChildTable() {
		return $this->childTable;
	}

	/**
	 * Set parentTableFormat
	 *
	 * @param TableFormat $parentTableFormat        	
	 *
	 * @return TableTree
	 */
	public function setParentTable($parentTableFormat) {
		$this->parentTable = $parentTableFormat;
		
		return $this;
	}

	/**
	 * Get parent table
	 *
	 * @return TableFormat
	 */
	public function getParentTable() {
		return $this->parentTable;
	}

	/**
	 * Set joinKeys
	 *
	 * @param string $joinKeys        	
	 *
	 * @return TableTree
	 */
	public function setJoinKey($joinKey) {
		$this->joinKey = $joinKey;
		
		return $this;
	}

	/**
	 * Get joinKeys
	 *
	 * @return array
	 */
	public function getJoinKey() {
		return $this->joinKey ;
	}

	/**
	 * Set comment
	 *
	 * @param string $comment        	
	 *
	 * @return TableTree
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
}

