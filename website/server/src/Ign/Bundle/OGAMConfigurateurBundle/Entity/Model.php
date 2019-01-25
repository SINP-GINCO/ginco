<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\OGAMConfigurateurBundle\Validator\CaseInsensitive;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * @ORM\Table(name="metadata.model")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMConfigurateurBundle\Entity\ModelRepository")
 * @ORM\HasLifecycleCallbacks()
 * @CaseInsensitive(message = "model.name.caseinsensitive")
 */
class Model {

	CONST PUBLISHED = 'published';
	CONST UNPUBLISHED = 'unpublished';
	CONST SOFT_DELETED = 'soft-deleted';

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

	/**
	 *
	 * @var string @ORM\Column(name="status", type="string", length=12, nullable=false)
	 */
	private $status;

	public function __construct() {
		$this->tables = new ArrayCollection();
		$this->datasets = new \Doctrine\Common\Collections\ArrayCollection();
		$this->status = self::UNPUBLISHED;
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
	 * Set ref
	 *
	 * @param boolean $ref
	 * @return Model
	 */
	public function setRef($ref) {
		$this->ref = false;

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

	/**
	 * 
	 */
	public function getStatus(){
		return $this->status;
	}

	/**
	 * 
	 */
	public function setStatus($status){
		$this->status = $status;
		return $this;
	}

	/**
	 * 
	 */
	public function isPublished(){
		return $this->getStatus() == self::PUBLISHED;
	}

		/**
	 * 
	 */
	public function isUnpublished(){
		return $this->getStatus() == self::UNPUBLISHED;
	}

	/**
	 * 
	 */
	public function isSoftDeleted(){
		return $this->getStatus() == self::SOFT_DELETED;
	}
}
