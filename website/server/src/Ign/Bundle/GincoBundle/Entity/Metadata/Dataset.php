<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

use Symfony\Component\Validator\Constraints as Assert;

use Ign\Bundle\OGAMConfigurateurBundle\Validator\CaseInsensitive;

/**
 * Dataset.
 *
 * @ORM\Table(name="metadata.dataset")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\DatasetRepository")
 * @CaseInsensitive(message = "dataset.label.caseinsensitive")
 */
class Dataset implements \JsonSerializable {
	
	const TYPE_QUERY = 'QUERY' ;
	const TYPE_IMPORT = 'IMPORT' ; 

	CONST PUBLISHED = 'published';
	CONST UNPUBLISHED = 'unpublished';

	/**
	 * The identifier of the dataset.
	 *
	 * @var string @ORM\Column(name="dataset_id", type="string", length=36, nullable=false)
	 *      @ORM\Id
	 */
	private $id;

	/**
	 * The label.
	 *
	 * @var string @ORM\Column(name="label", type="string", length=255, nullable=true)
	 *      @Assert\NotBlank(message="dataset.label.notBlank")
	 *      @Assert\Length(max="255", maxMessage="dataset.label.maxLength")
	 */
	private $label;

	/**
	 * Indicate if the dataset is displayed by default.
	 *
	 * @var bool @ORM\Column(name="is_default", type="boolean", nullable=true)
	 */
	private $isDefault;

	/**
	 * The definition.
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=512, nullable=true)
	 */
	private $definition;
	
	/**
	 *
	 * @var string @ORM\Column(name="type", type="string", length=36, nullable=true)
	 */
	private $type;

	/**
	 * The list of files linked to this dataset.
	 *
	 *
	 * @ORM\ManyToMany(targetEntity="FileFormat", cascade={"all"}, inversedBy="datasets")
	 * @ORM\OrderBy({"position" = "ASC"})
	 * @ORM\JoinTable(
	 *		name="metadata.dataset_files",
	 *		joinColumns={@ORM\JoinColumn(name="dataset_id", referencedColumnName="dataset_id")},
	 *		inverseJoinColumns={@ORM\JoinColumn(name="format", referencedColumnName="format", unique=true)}
	 * )
	 */
	private $files;

	/**
	 * @ORM\ManyToMany(targetEntity="Model")
	 * @ORM\JoinTable(
	 *		name = "metadata.model_datasets",
	 *		joinColumns = {@ORM\JoinColumn(name="dataset_id", referencedColumnName="dataset_id", unique=true)},
	 *		inverseJoinColumns = {@ORM\JoinColumn(name="model_id", referencedColumnName="id")}
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
	 * Constructor
	 */
	public function __construct() {
		
		$this->id = uniqid('dataset_') ;
		$this->status = self::UNPUBLISHED ;
		$this->files = new ArrayCollection();
		$this->model = new ArrayCollection();
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
	 * Set label
	 *
	 * @param string $label        	
	 *
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
	 * @param boolean $isDefault        	
	 *
	 * @return Dataset
	 */
	public function setIsDefault($isDefault) {
		$this->isDefault = $isDefault;
		
		return $this;
	}

	/**
	 * Get isDefault
	 *
	 * @return bool
	 */
	public function getIsDefault() {
		return $this->isDefault;
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
	 * Set definition
	 *
	 * @param string $definition        	
	 *
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
	 * Serialize the object as a JSON string
	 *
	 * @return string JSON string
	 */
	public function jsonSerialize() {
		return [
			'id' => $this->id,
			'label' => $this->label,
			'definition' => $this->definition,
			'is_default' => $this->isDefault
		];
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
	 * Add file
	 *
	 * @param FileFormat $file
	 *
	 * @return Dataset
	 */
	public function addFile(FileFormat $file) {
		$this->files->add($file);
		
		return $this;
	}

	/**
	 * Remove file
	 *
	 * @param FileFormat $file
	 */
	public function removeFile(FileFormat $file) {
		$this->files->removeElement($file);
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
	 * Has files ?
	 * @return boolean
	 */
	public function hasFiles() {
		return ! $this->files->isEmpty() ;
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
