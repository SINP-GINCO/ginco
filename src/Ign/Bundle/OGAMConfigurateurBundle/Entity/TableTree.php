<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * TableTree
 *
 * @ORM\Table(name="metadata_work.table_tree")
 * @ORM\Entity
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMConfigurateurBundle\Entity\TableTreeRepository")
 */
class TableTree {
	/**
	 *
	 * @var string @ORM\JoinColumn(name="schema_code", referencedColumnName="schema_code")
	 *      @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="TableSchema")
	 *      @ORM\JoinColumn(name="schema_code", referencedColumnName="schema_code")
	 */
	private $schemaCode;

	/**
	 *
	 * @var string @ORM\Column(name="child_table", type="string", length=36, nullable=false)
	 *      @ORM\Id
	 */
	private $childTable;

	/**
	 *
	 * @var string @ORM\Column(name="parent_table", type="string", length=36, nullable=false)
	 */
	private $parentTable;

	/**
	 *
	 * @var string @ORM\Column(name="join_key", type="string", length=255, nullable=true)
	 */
	private $joinKey;

	/**
	 *
	 * @var string @ORM\Column(name="comment", type="string", length=255, nullable=true)
	 */
	private $comment;

	/**
	 * Set schemaCode
	 *
	 * @param string $schemaCode
	 * @return TableTree
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
	 * Set childTable
	 *
	 * @param string $childTable
	 * @return TableTree
	 */
	public function setChildTable($childTable) {
		$this->childTable = $childTable;

		return $this;
	}

	/**
	 * Get childTable
	 *
	 * @return string
	 */
	public function getChildTable() {
		return $this->childTable;
	}

	/**
	 * Set parentTable
	 *
	 * @param string $parentTable
	 * @return TableTree
	 */
	public function setParentTable($parentTable) {
		$this->parentTable = $parentTable;

		return $this;
	}

	/**
	 * Get parentTable
	 *
	 * @return string
	 */
	public function getParentTable() {
		return $this->parentTable;

	}

	/**
	 * Set joinKey
	 *
	 * @param string $joinKey
	 * @return TableTree
	 */
	public function setJoinKey($joinKey) {
		$this->joinKey = $joinKey;

		return $this;
	}

	/**
	 * Get joinKey
	 *
	 * @return string
	 */
	public function getJoinKey() {
		return $this->joinKey;
	}

	/**
	 * Set comment
	 *
	 * @param string $comment
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
