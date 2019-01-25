<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\OGAMConfigurateurBundle\Validator\CaseInsensitive;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * Dataset (is renamed in the application as 'Import model')
 *
 * @ORM\Table(name="metadata.dataset")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMConfigurateurBundle\Entity\DatasetRepository")
 * @ORM\HasLifecycleCallbacks()
 * @CaseInsensitive(message = "dataset.label.caseinsensitive")
 */
class Dataset {

	CONST PUBLISHED = 'published';
	CONST UNPUBLISHED = 'unpublished';

	/**
	 *
	 * @var string @ORM\Column(name="dataset_id", type="string", length=36, nullable=false)
	 *      @ORM\Id
	 */
	private $id;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=255, nullable=true)
	 *      @Assert\NotBlank(message="dataset.label.notBlank")
	 *      @Assert\Length(max="255", maxMessage="dataset.label.maxLength")
	 *
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="is_default", type="string", length=1, nullable=true)
	 */
	private $isDefault;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=512, nullable=true)
	 *      @Assert\Length(max="255", maxMessage="dataset.definition.maxLength")
	 */
	private $definition;

	/**
	 *
	 * @var string @ORM\Column(name="type", type="string", length=36, nullable=true)
	 */
	private $type;

	/**
	 * @ORM\ManyToMany(targetEntity="FileFormat", cascade={"all"}, inversedBy="datasets")
	 * @ORM\OrderBy({"position" = "ASC"})
	 * @ORM\JoinTable(name="metadata.dataset_files",
	 * joinColumns={@ORM\JoinColumn(name="dataset_id", referencedColumnName="dataset_id")},
	 * inverseJoinColumns={@ORM\JoinColumn(name="format", referencedColumnName="format", unique=true)})
	 */
	private $files;

	/**
	 * @ORM\ManyToMany(targetEntity="Model")
	 * @ORM\JoinTable(name="metadata.model_datasets",
	 * joinColumns={@ORM\JoinColumn(name="dataset_id", referencedColumnName="dataset_id", unique=true)},
	 * inverseJoinColumns={@ORM\JoinColumn(name="model_id", referencedColumnName="id")}
	 * )
	 * The relation ManyToMany with the unicity constraint on the dataset equals a ManyToOne relation.
	 * Nevertheless, doctrine expects that $model must be an Array, what explains the constructor,
	 * and the getter and setter which deals with a table. Only the first Object of the Array is useful.
	 */
	private $model;

	/**
	 *
	 * @var string @ORM\Column(name="status", type="string", length=12, nullable=false)
	 */
	private $status;

	/**
	 * Set id
	 *
	 * @param string $id
	 * @return Dataset
	 */
	public function setId($id) {
		$this->id = $id;

		return $this;
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
	 * ci-dessous (quelque soit son nom) lorsque
	 * l'entité est persistée.
	 * La classe doit porter l'annotation
	 * HasLifecycleCallbacks()
	 */
	public function addId() {
		$this->id = uniqid('dataset_');
		return $this;
	}

	/**
	 * Set label
	 *
	 * @param string $label
	 * @return Dataset
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
	 * Set isDefault
	 *
	 * @param string $isDefault
	 * @return Dataset
	 */
	public function setIsDefault($isDefault) {
		$this->isDefault = $isDefault;

		return $this;
	}

	/**
	 * Get isDefault
	 *
	 * @return string
	 */
	public function getIsDefault() {
		return $this->isDefault;
	}

	/**
	 * Set definition
	 *
	 * @param string $definition
	 * @return Dataset
	 */
	public function setDefinition($definition) {
		$this->definition = $definition;

		return $this;
	}

	/**
	 * Get definition
	 *
	 * @return string
	 */
	public function getDefinition() {
		return $this->definition;
	}

	/**
	 * Set type
	 *
	 * @param string $type
	 * @return Dataset
	 */
	public function setType($type) {
		$this->type = $type;

		return $this;
	}

	/**
	 * Get type
	 *
	 * @return string
	 */
	public function getType() {
		return $this->type;
	}

	/**
	 * Constructor
	 */
	public function __construct() {
		$this->files = new ArrayCollection();
		$this->model = new ArrayCollection();
	}

	/**
	 * Get model
	 * The ManyToMany relation expects an Array, but only the first object is usefull.
	 *
	 * @return Model
	 */
	public function getModel() {
		return $this->model[0];
	}

	/**
	 * Set model
	 *
	 * @return Dataset
	 */
	public function setModel(Model $model) {
		$this->model[0] = $model;

		return $this;
	}

	/**
	 * Add files
	 *
	 * @param \FileFormat $files
	 * @return Dataset
	 */
	public function addFile(FileFormat $files) {
		$this->files[] = $files;

		return $this;
	}

	/**
	 * Remove files
	 *
	 * @param \FileFormat $files
	 */
	public function removeFile(FileFormat $files) {
		$this->files->removeElement($files);
	}

	/**
	 * Get files
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getFiles() {
		return $this->files;
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

}
