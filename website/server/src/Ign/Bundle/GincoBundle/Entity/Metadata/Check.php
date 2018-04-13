<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * Check
 *
 * @ORM\Table(name="metadata.check")
 * @ORM\Entity
 */
class Check  {
    
    /**
     * @ORM\Column(name="check_id")
     * @ORM\Id
     * 
     * @var integer 
     */        
    private $id;
    
    /**
     *
     * @var string 
     */
    private $step;
    
    /**
     *
     * @var string 
     */
    private $name;
    
    /**
     *
     * @var string 
     */
    private $label;

    /**
     *
     * @var string 
     */
    private $description;

    /**
     *
     * @var string 
     */    
    private $importance;
    
    /**
     * @ORM\Column(name="_creationdt", type="datetime")
     * 
     * @var \DateTime 
     */
    private $creationDate;

    /**
     * 
     * @return integer
     */
    function getId() {
        return $this->id;
    }

    /**
     * 
     * @return string
     */
    function getStep() {
        return $this->step;
    }

    /**
     * 
     * @param string $step
     * @return $this
     */
    function setStep($step) {
        $this->step = $step;
        return $this;
    }

    /**
     * 
     * @return string
     */
    function getName() {
        return $this->name;
    }

    /**
     * 
     * @param string $name
     * @return $this
     */
    function setName($name) {
        $this->name = $name;
        return $this;
    }

    /**
     * 
     * @return string
     */
    function getLabel() {
        return $this->label;
    }

    /**
     * 
     * @param string $label
     * @return $this
     */
    function setLabel($label) {
        $this->label = $label;
        return $this;
    }

    /**
     * 
     * @return string
     */
    function getDescription() {
        return $this->description;
    }

    /**
     * 
     * @param string $description
     * @return $this
     */
    function setDescription($description) {
        $this->description = $description;
        return $this;
    }

    /**
     * 
     * @return type
     */
    function getImportance() {
        return $this->importance;
    }

    /**
     * 
     * @param string $importance
     * @return $this
     */
    function setImportance($importance) {
        $this->importance = $importance;
        return $this;
    }

    /**
     * 
     * @return \DateTime
     */
    function getCreationDate() {
        return $this->creationDate;
    }

    /**
     * 
     * @param \DateTime $creationDate
     * @return $this
     */
    function setCreationDate(\DateTime $creationDate) {
        $this->creationDate = $creationDate;
        return $this;
    }


}

