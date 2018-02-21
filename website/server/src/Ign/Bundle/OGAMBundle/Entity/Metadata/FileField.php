<?php
namespace Ign\Bundle\OGAMBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * FileField
 *
 * @ORM\Table(name="metadata.file_field")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMBundle\Repository\Metadata\FileFieldRepository")
 */
class FileField extends Field {

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
	 * Serialize the object as a JSON string
	 *
	 * @return string JSON string
	 */
	public function toJSON() {
		$json = '"name":' . json_encode($this->getName());
		$json .= ',"format":' . json_encode($this->format);
		$json .= ',"label":' . json_encode($this->label);
		$json .= ',"labelCSV":' . json_encode($this->labelCSV);
		$json .= ',"isMandatory":' . json_encode($this->isMandatory);
		$json .= ',"definition":' . json_encode($this->definition);
		$json .= ',"mask":' . json_encode($this->mask);
		
		return $json;
	}
}

