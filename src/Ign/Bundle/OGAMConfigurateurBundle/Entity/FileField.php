<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * FileField
 *
 * @ORM\Table(name="metadata_work.file_field")
 * @ORM\Entity(repositoryClass="Ign\Bundle\ConfigurateurBundle\Entity\FileFieldRepository")
 */
class FileField {

	/**
	 *
	 * @var string @ORM\Column(name="format", type="string", length=256, nullable=false)
	 *      @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="FileFormat", inversedBy="fileFields")
	 *      @ORM\JoinColumn(name="fileFormat", referencedColumnName="format")
	 *      @ORM\GeneratedValue(strategy="NONE")
	 */
	private $fileFormat;

	/**
	 *
	 * @var string @ORM\Column(name="data", type="string", length=174, nullable=false)
	 *      @ORM\Id
	 *      @ORM\ManyToOne(targetEntity="Field")
	 *      @ORM\JoinColumn(name="data", referencedColumnName="data")
	 *      @ORM\GeneratedValue(strategy="NONE")
	 */
	private $data;

	/**
	 *
	 * @var string @ORM\Column(name="is_mandatory", type="string", length=1, nullable=true)
	 */
	private $isMandatory;

	/**
	 *
	 * @var string @ORM\Column(name="mask", type="string", length=100, nullable=true)
	 */
	private $mask;

	/**
	 *
	 * @var integer @ORM\Column(name="position", type="integer", nullable=true)
	 */
	private $position;

	/**
	 * Get format
	 *
	 * @return string
	 */
	public function getFileFormat() {
		return $this->fileFormat;
	}

	/**
	 * Set format
	 *
	 * @param string $fileFormat        	
	 * @return FileField
	 */
	public function setFileFormat($fileFormat) {
		$this->fileFormat = $fileFormat;
		
		return $this;
	}

	/**
	 * Set data
	 *
	 * @param string $data        	
	 * @return FileField
	 */
	public function setData($data) {
		$this->data = $data;
		
		return $this;
	}

	/**
	 * Get data
	 *
	 * @return string
	 */
	public function getData() {
		return $this->data;
	}

	/**
	 * Set isMandatory
	 *
	 * @param string $isMandatory        	
	 * @return FileField
	 */
	public function setIsMandatory($isMandatory) {
		$this->isMandatory = $isMandatory;
		
		return $this;
	}

	/**
	 * Get isMandatory
	 *
	 * @return string
	 */
	public function getIsMandatory() {
		return $this->isMandatory;
	}

	/**
	 * Set mask
	 * Explicitly replaces empty string ('') by null value.
	 * (Ogam needs it)
	 *
	 * @param string $mask
	 * @return FileField
	 */
	public function setMask($mask) {

		$this->mask = empty($mask) ? null : $mask;
		
		return $this;
	}

	/**
	 * Get mask
	 *
	 * @return string
	 */
	public function getMask() {
		return $this->mask;
	}

	/**
	 * Set position
	 *
	 * @param integer $position        	
	 * @return FileField
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
}
