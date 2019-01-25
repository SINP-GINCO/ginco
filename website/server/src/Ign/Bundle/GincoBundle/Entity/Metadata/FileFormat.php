<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

use Symfony\Component\Validator\Constraints as Assert;

use Ign\Bundle\GincoBundle\Entity\Metadata\FormatInterface;

/**
 * FileFormat.
 *
 * @ORM\Table(name="metadata.file_format")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\FileFormatRepository")
 */
class FileFormat implements FormatInterface {

	/**
	 * The format of the table is its id. It is generated in the controller via uniqid function.
	 * @var Format 
	 * 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Format")
	 * @ORM\JoinColumn(name="format", referencedColumnName="format")
	 */
	private $format;

	/**
	 *
	 * @var string @ORM\Column(name="file_extension", type="string", length=36, nullable=true)
	 */
	private $fileExtension;

	/**
	 *
	 * @var string @ORM\Column(name="file_type", type="string", length=36, nullable=false)
	 */
	private $fileType;

	/**
	 *
	 * @var integer @ORM\Column(name="position", type="integer", nullable=false)
	 */
	private $position;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=255, nullable=true)
	 *      @Assert\NotBlank(message="fileFormat.label.notBlank")
	 *      @Assert\Length(max="36", maxMessage="fileFormat.label.maxLength")
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=255, nullable=true)
	 *      @Assert\Length(max="255", maxMessage="fileFormat.description.maxLength")
	 */
	private $description;

	/**
	 *
	 * @ORM\ManyToMany(targetEntity="Dataset", mappedBy="files")
	 */
	private $datasets;
	
	/**
	 *
	 * @var ArrayCollection
	 * 
	 * @ORM\OneToMany(targetEntity="FileField", mappedBy="format")
	 */
	private $fields;
	
	

	public function __construct() {
		$this->datasets = new ArrayCollection();
		$this->fileFields = new ArrayCollection() ;
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
	 * Set format ("<dataset_id>_<file_format>_file")
	 *
	 * @param Format $format
	 *        	: the format of the file
	 * @param string $datasetId
	 *        	: the id of the dataset
	 * @return FileFormat
	 */
	public function setFormat($format) {
		$this->format = $format;

		return $this;
	}

	/**
	 * Set fileExtension
	 *
	 * @param string $fileExtension
	 * @return FileFormat
	 */
	public function setFileExtension($fileExtension) {
		$this->fileExtension = $fileExtension;

		return $this;
	}

	/**
	 * Get fileExtension
	 *
	 * @return string
	 */
	public function getFileExtension() {
		return $this->fileExtension;
	}

	/**
	 * Set fileType
	 *
	 * @param string $fileType
	 * @return FileFormat
	 */
	public function setFileType($fileType) {
		$this->fileType = $fileType;

		return $this;
	}

	/**
	 * Get fileType
	 *
	 * @return string
	 */
	public function getFileType() {
		return $this->fileType;
	}

	/**
	 * Set position
	 *
	 * @param integer $position
	 * @return FileFormat
	 */
	public function setPosition($position) {
		$this->position = $position;

		return $this;
	}

	/**
	 * Get position
	 *
	 * @return integer
	 */
	public function getPosition() {
		return $this->position;
	}

	/**
	 * Set label
	 *
	 * @param string $label
	 * @return FileFormat
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
	 * @return FileFormat
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
	 * Get Dataset
	 * Relation is a ManytoMany, with uniqueness, so in fact a ManyToOne
	 * getDataset returns the first and only element of the $datasets arrayCollection
	 *
	 * @return \Doctrine\Common\Collections\Collection
	 */
	public function getDataset()
	{
		return $this->datasets->first();
	}
	
	
	/**
	 * Set file field
	 * @param FileField[] $fields
	 * @return $this
	 */
	public function setFields($fields) {
		$this->fields = $fields ;
		return $this ;
	}
	
	
	/**
	 * Get file fields.
	 * @return FileField[]
	 */
	public function getFields() {
		return $this->fields ;
	}
	
	
	/**
	 * has fields ?
	 * @return boolean
	 */
	public function hasFields() {
		return ! $this->fields->isEmpty() ;
	}
}

