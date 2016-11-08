<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;
use Doctrine\Common\Collections\ArrayCollection;
use Ign\Bundle\ConfigurateurBundle\Validator\CaseInsensitive;

/**
 * @ORM\Table(name="metadata_work.model")
 * @ORM\Entity(repositoryClass="Ign\Bundle\ConfigurateurBundle\Entity\ModelRepository")
 * @ORM\HasLifecycleCallbacks()
 * @CaseInsensitive(message = "model.name.caseinsensitive")
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
	 *      @Assert\NotBlank(message="model.name.notBlank")
	 *      @Assert\Length(max="128", maxMessage="model.name.maxLength")
	 *      @Assert\Regex(pattern="/[^<>]*$/", match=true, message="modelName.label.regex")
	 */
	private $name;

	/**
	 *
	 * @var string @ORM\Column(name="description", type="string", length=1024, nullable=true)
	 *      @Assert\Length(max="1024", maxMessage="model.description.maxLength")
	 */
	private $description;

	/**
	 * @ORM\ManyToMany(targetEntity="TableFormat", inversedBy="models", cascade={"all"})
	 * @ORM\JoinTable(name="metadata_work.model_tables",
	 * joinColumns={@ORM\JoinColumn(name="model_id", referencedColumnName="id")},
	 * inverseJoinColumns={@ORM\JoinColumn(name="table_id", referencedColumnName="format", unique=true)})
	 */
	private $tables;

	/**
	 * @ORM\ManyToMany(targetEntity="Dataset")
	 * @ORM\JoinTable(name="metadata_work.model_datasets",
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
	 * @ORM\PrePersist()
	 * Cette annotation permet de lancer la fonction
	 * ci-dessous (quelque soit son name) lorsque
	 * l'entité est persistée.
	 * La classe doit porter l'annotation
	 * HasLifecycleCallbacks()
	 */
	public function addId() {
		$this->id = uniqid('model_');
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
	 * Add tables
	 *
	 * @param \TableFormat $tables
	 * @return Model
	 */
	public function addTable(TableFormat $tables) {
		$this->tables[] = $tables;

		return $this;
	}

	/**
	 * Remove tables
	 *
	 * @param \TableFormat $tables
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
	 * @param \Dataset $datasets
	 * @return Model
	 */
	public function addDataset(Dataset $datasets) {
		$this->datasets[] = $datasets;

		return $this;
	}

	/**
	 * Remove datasets
	 *
	 * @param \Dataset $datasets
	 */
	public function removeDataset(Dataset $datasets) {
		$this->datasets->removeElement($datasets);
	}

	/**
	 * Get datasets
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getDatasets() {
		return $this->datasets;
	}
}
