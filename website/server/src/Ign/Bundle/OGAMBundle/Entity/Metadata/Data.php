<?php
namespace Ign\Bundle\OGAMBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;
use Doctrine\Common\Collections\ArrayCollection;

/**
 * Data
 *
 * @ORM\Table(name="metadata.data")
 * @ORM\Entity
 */
class Data implements \JsonSerializable {

	/**
	 *
	 * @var string @ORM\Column(name="data", type="string", length=174, nullable=false)
	 *      @ORM\Id
	 *      @Assert\NotBlank(message="data.name.notBlank")
	 *      @Assert\Length(max="174", maxMessage="data.name.maxLength")
	 *      @Assert\Regex(pattern="/^[a-z][a-z0-9_]*$/", match=true, message="data.name.regex")
	 */
	private $data;

	/**
	 *
	 * @var string @ORM\JoinColumn(name="unit", referencedColumnName="unit", nullable=false)
	 *      @ORM\ManyToOne(targetEntity="Unit")
	 *      @Assert\NotNull(message="data.unit.notNull")
	 */
	private $unit;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=60, nullable=true)
	 *      @Assert\NotBlank(message="data.label.notBlank")
	 *      @Assert\Length(max="60", maxMessage="data.label.maxLength")
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", length=255, nullable=true)
	 *      @Assert\Length(max="255", maxMessage="data.definition.maxLength")
	 */
	private $definition;

	/**
	 *
	 * @var string @ORM\Column(name="comment", type="string", length=255, nullable=true)
	 *      @Assert\Length(max="255", maxMessage="data.definition.maxLength")
	 */
	private $comment;

	private $fields;

	/**
	 * Constructor
	 */
	public function __construct() {
		$this->fields = new ArrayCollection();
	}

	/**
	 * Set data
	 *
	 * @param string $data        	
	 * @return Data
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
	 * Set label
	 *
	 * @param string $label        	
	 * @return Data
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
	 * Set definition
	 *
	 * @param string $definition        	
	 * @return Data
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
	 * Set comment
	 *
	 * @param string $comment        	
	 * @return Data
	 */
	public function setComment($comment) {
		$this->comment = $comment;
		
		return $this;
	}

	/**
	 * Get comment
	 *
	 * @return string
	 */
	public function getComment() {
		return $this->comment;
	}

	/**
	 * Set unit
	 *
	 * @param Unit $unit        	
	 * @return Data
	 */
	public function setUnit(Unit $unit = null) {
		$this->unit = $unit;
		
		return $this;
	}

	/**
	 * Get unit
	 *
	 * @return string
	 */
	public function getUnit() {
		return $this->unit;
	}

	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string JSON string
	 */
	public function jsonSerialize() {
		return [
			'id' => $this->data,
			'data' => $this->data,
			'unit' => $this->unit,
			'label' => $this->label,
			'definition' => $this->definition
		];
	}
}
