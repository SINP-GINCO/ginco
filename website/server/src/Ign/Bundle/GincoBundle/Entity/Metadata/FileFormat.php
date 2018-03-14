<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * FileFormat.
 *
 * @ORM\Table(name="metadata.file_format")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\FileFormatRepository")
 */
class FileFormat extends Format {

	/**
	 *
	 * @var string @ORM\Column(name="file_extension", type="string", length=36, nullable=true)
	 */
	private $fileExtension;

	/**
	 *
	 * @var string @ORM\Column(name="file_type", type="string", length=36, nullable=true)
	 */
	private $fileType;

	/**
	 *
	 * @var int @ORM\Column(name="position", type="integer", nullable=true)
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
	 * Set fileExtension
	 *
	 * @param string $fileExtension        	
	 *
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
	 *
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
	 *
	 * @return FileFormat
	 */
	public function setPosition($position) {
		$this->position = $position;
		
		return $this;
	}

	/**
	 * Get position
	 *
	 * @return int
	 */
	public function getPosition() {
		return $this->position;
	}

	/**
	 * Set label
	 *
	 * @param string $label        	
	 *
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
}

