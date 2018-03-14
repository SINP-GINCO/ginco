<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

/**
 * @ORM\Table(name="metadata.model")
 * @ORM\Entity
 */
class Model {

	/**
	 *
	 * @var string @ORM\Column(name="id", type="string", nullable=false)
	 *      @ORM\Id
	 */
	private $id;

	/**
	 *
	 * @var string @ORM\Column(name="name", type="string", length=128, nullable=false)
	 */
	private $name;

	/**
	 *
	 * @var string @ORM\Column(name="description", type="string", length=1024, nullable=true)
	 */
	private $description;

	/**
	 *
	 * @var string @ORM\Column(name="is_ref", type="boolean", nullable=true)
	 */
	private $ref;

	/**
	 * @ORM\ManyToMany(targetEntity="TableFormat", inversedBy="models", cascade={"all"})
	 * @ORM\JoinTable(name="metadata.model_tables",
	 * joinColumns={@ORM\JoinColumn(name="model_id", referencedColumnName="id")},
	 * inverseJoinColumns={@ORM\JoinColumn(name="table_id", referencedColumnName="format", unique=true)})
	 */
	private $tables;

	/**
	 * @ORM\ManyToMany(targetEntity="Dataset")
	 * @ORM\JoinTable(name="metadata.model_datasets",
	 * joinColumns={@ORM\JoinColumn(name="model_id", referencedColumnName="id")},
	 * inverseJoinColumns={@ORM\JoinColumn(name="dataset_id", referencedColumnName="dataset_id", unique=true)})
	 */
	private $datasets;

	/**
	 * @ORM\ManyToOne(targetEntity="TableSchema")
	 * @ORM\JoinColumn(name="schema_code", referencedColumnName="schema_code")
	 */
	private $schema;

	public function __construct() {
		$this->tables = new ArrayCollection();
		$this->datasets = new \Doctrine\Common\Collections\ArrayCollection();
		$this->ref = false;
	}

	/**
	 * Get id
	 *
	 * @return string
	 */
	public function getId() {
		return $this->id;
	}

	/**
	 * Set name
	 *
	 * @param string $name
	 * @return Model
	 */
	public function setName($nom) {
		$this->name = $nom;

		return $this;
	}

	/**
	 * Get name
	 *
	 * @return string
	 */
	public function getName() {
		return $this->name;
	}

	/**
	 * Set description
	 *
	 * @param string $description
	 * @return Model
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
	 * Set ref
	 *
	 * @param boolean $ref
	 * @return Model
	 */
	public function setRef($ref) {
		$this->ref = $ref;

		return $this;
	}

	/**
	 * Get ref
	 *
	 * @return string
	 */
	public function getRef() {
		return $this->ref;
	}

	/**
	 * Add tables
	 *
	 * @param TableFormat $tables
	 * @return Model
	 */
	public function addTable(TableFormat $tables) {
		$this->tables[] = $tables;

		return $this;
	}

	/**
	 * Remove tables
	 *
	 * @param TableFormat $tables
	 */
	public function removeTable(TableFormat $tables) {
		$this->tables->removeElement($tables);
	}

	/**
	 * Get tables
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getTables() {
		return $this->tables;
	}

	/**
	 * Set schema
	 *
	 * @param string $schema
	 * @return \TableFormat $schema
	 */
	public function setSchema($schema) {
		$this->schema = $schema;
		return $this;
	}

	/**
	 * Get schema
	 *
	 * @return string
	 */
	public function getSchema() {
		return $this->schema;
	}

	/**
	 * Add datasets
	 *
	 * @param Dataset $datasets
	 * @return Model
	 */
	public function addDataset(Dataset $datasets) {
		$this->datasets[] = $datasets;

		return $this;
	}

	/**
	 * Remove datasets
	 *
	 * @param Dataset $datasets
	 */
	public function removeDataset(Dataset $datasets) {
		$this->datasets->removeElement($datasets);
	}

	/**
	 * Get all datasets
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getDatasets() {
		return $this->datasets;
	}

	/**
	 * Get import datasets, ie those with at least one file
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getImportDatasets() {
		$isImport = function (Dataset $dataset) {
			return !$dataset->getFiles()->isEmpty();
		};
		return $this->getDatasets()->filter($isImport);

	}

	public function __toString()
	{
		return $this->getId()." (" . $this->getName() . ")";
	}

}
