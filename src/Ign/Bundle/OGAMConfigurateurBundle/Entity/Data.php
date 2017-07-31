<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * Data
 *
 * @ORM\Table(name="metadata_work.data")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMConfigurateurBundle\Entity\DataRepository")
 * @UniqueEntity("name", message = "data.name.unique")
 */
class Data {

	/**
	 *
	 * @var string @ORM\Column(name="data", type="string", length=174, nullable=false)
	 *      @ORM\Id
	 * 		@Assert\NotBlank(message="data.name.notBlank")
	 *      @Assert\Length(max="174", maxMessage="data.name.maxLength")
	 *      @Assert\Regex(pattern="/^[a-z][a-z0-9_]*$/", match=true, message="data.name.regex")
	 */
	private $name;

	/**
	 *
	 * @var string @ORM\JoinColumn(name="unit", referencedColumnName="unit", nullable=false)
	 *      @ORM\ManyToOne(targetEntity="Unit")
	 * 		@Assert\NotNull(message="data.unit.notNull")
	 */
	private $unit;

	/**
	 *
	 * @var string @ORM\Column(name="label", type="string", length=60, nullable=true)
	 * 		@Assert\NotBlank(message="data.label.notBlank")
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


	/**
	 * @ORM\OneToMany(targetEntity="Field", mappedBy="data")
	 */
	private $fields = array();

	/**
	 * Constructor
	 */
	public function __construct()
	{
		$this->fields = new ArrayCollection();
	}

	/**
	 * Set data
	 *
	 * @param string $data
	 * @return Data
	 */
	public function setName($data) {
		$this->name = $data;

		return $this;
	}

	/**
	 * Set the property 'name', used as PK
	 *
	 * @return string
	 */
	public function setId($data) {
		return $this->setName($data);
	}

	/**
	 * Get data
	 *
	 * @return string
	 */
	public function getName() {
		return $this->name;
	}

	/**
	 * Get the property 'name', used as PK
	 *
	 * @return string
	 */
	public function getId() {
		return $this->getName();
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
	 * @param \Ign\Bundle\OGAMConfigurateurBundle\Entity\Unit $unit
	 * @return Data
	 */
	public function setUnit(\Ign\Bundle\OGAMConfigurateurBundle\Entity\Unit $unit = null) {
		$this->unit = $unit;

		return $this;
	}

	/**
	 * Get unit
	 *
	 * @return \Ign\Bundle\OGAMConfigurateurBundle\Entity\Unit
	 */
	public function getUnit() {
		return $this->unit;
	}


    /**
     * Add fields
     *
     * @param \Ign\Bundle\OGAMConfigurateurBundle\Entity\Field $fields
     * @return Data
     */
    public function addField(\Ign\Bundle\OGAMConfigurateurBundle\Entity\Field $fields)
    {
        $this->fields[] = $fields;

        return $this;
    }

    /**
     * Remove fields
     *
     * @param \Ign\Bundle\OGAMConfigurateurBundle\Entity\Field $fields
     */
    public function removeField(\Ign\Bundle\OGAMConfigurateurBundle\Entity\Field $fields)
    {
        $this->fields->removeElement($fields);
    }

    /**
     * Get fields
     *
     * @return \Doctrine\Common\Collections\Collection
     */
    public function getFields()
    {
        return $this->fields;
    }

	/**
	 * Return whether current Data object is used as a field in the model;
	 * if not, it can be safely deleted.
	 *
	 * @return bool
	 */
	public function isDeletable()
	{
		return ($this->fields->count() == 0);
	}

	/**
	 * Same criteria as isDeletable
	 *
	 * @return bool
	 */
	public function isEditable()
	{
		return $this->isDeletable();
	}
}
