<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

use Ign\Bundle\GincoBundle\Entity\Metadata\Data;
use Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat;

use Ign\Bundle\GincoBundle\Entity\Metadata\FieldInterface;

/**
 * FileField
 *
 * @ORM\Table(name="metadata.file_field")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\FileFieldRepository")
 */
class FileField implements FieldInterface {

	/**
	 *
	 * @var int @ORM\Column(name="is_mandatory", type="integer", nullable=true)
	 */
	private $isMandatory;

	/**
	 *
	 * @var string @ORM\Column(name="mask", type="string", length=100, nullable=true)
	 */
	private $mask;
	
	/**
	 *
	 * @var int @ORM\Column(name="label_csv", type="string", nullable=true)
	 */
	private $labelCSV;
	
	/**
	 *
	 * @var string 
	 * 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="Data")
	 * @ORM\JoinColumn(name="data", referencedColumnName="data")
	 */
	private $data;

	/**
	 *
	 * @var FileFormat 
	 * 
	 * @ORM\Id
	 * @ORM\ManyToOne(targetEntity="FileFormat", inversedBy="fields")
	 * @ORM\JoinColumn(name="format", referencedColumnName="format")
	 */
	private $format;

	/**
	 * Set isMandatory
	 *
	 * @param integer $isMandatory        	
	 *
	 * @return FileField
	 */
	public function setIsMandatory($isMandatory) {
		$this->isMandatory = $isMandatory;
		
		return $this;
	}

	/**
	 * Get isMandatory
	 *
	 * @return int
	 */
	public function getIsMandatory() {
		return $this->isMandatory;
	}

	/**
	 * Set mask
	 *
	 * @param string $mask        	
	 *
	 * @return FileField
	 */
	public function setMask($mask) {
		$this->mask = $mask;
		
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
	 * Set labelCSV
	 *
	 * @param integer $labelCSV        	
	 *
	 * @return FileField
	 */
	public function setLabelCSV($labelCSV) {
		$this->labelCSV = $labelCSV;
		
		return $this;
	}

	/**
	 * Get labelCSV
	 *
	 * @return int
	 */
	public function getLabelCSV() {
		return $this->labelCSV;
	}

	
	/**
	 * Set data
	 *
	 * @param Data $data
	 *
	 * @return field
	 */
	public function setData(Data $data) {
		$this->data = $data;

		return $this;
	}

	/**
	 * Get data
	 *
	 * @return Data
	 */
	public function getData() {
		return $this->data;
	}

	/**
	 * Set format
	 *
	 * @param FileFormat $format
	 *
	 * @return field
	 */
	public function setFormat($format) {
		$this->format = $format;

		return $this;
	}

	/**
	 * Get format
	 *
	 * @return FileFormat
	 */
	public function getFormat() {
		return $this->format;
	}
	
	/**
	 * Return the unique identifier of the field.
	 *
	 * @return String the identifier of the field
	 */
	function getName() {
		return $this->getFormat()->getFormat()->getFormat() . '__' . $this->getData()->getData();
	}
	
	
	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string JSON string
	 */
	public function toJSON() {
		$json = '"name":' . json_encode($this->getName());
		$json .= ',"format":' . json_encode($this->format->getFormat());
		$json .= ',"label":' . json_encode($this->label);
		$json .= ',"labelCSV":' . json_encode($this->labelCSV);
		$json .= ',"isMandatory":' . json_encode($this->isMandatory);
		$json .= ',"definition":' . json_encode($this->definition);
		$json .= ',"mask":' . json_encode($this->mask);
		
		return $json;
	}
}

