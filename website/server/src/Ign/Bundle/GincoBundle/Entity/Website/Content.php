<?php
namespace Ign\Bundle\OGAMBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;

/**
 * Content
 *
 * @ORM\Table(name="website.content")
 * @ORM\Entity
 */
class Content {

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="name", type="string", length=50, unique=true)
	 */
	private $name;

	/**
	 *
	 * @var string @ORM\Column(name="value", type="text", nullable=true)
	 */
	private $value;

	/**
	 *
	 * @var string @ORM\Column(name="description", type="string", length=500, nullable=true)
	 */
	private $description;

	/**
	 * Set name
	 *
	 * @param string $name        	
	 *
	 * @return Content
	 */
	public function setName($name) {
		$this->name = $name;
		
		return $this;
	}

	/**
	 * Get name
	 *
	 * @return string
	 */
	public function getName() {
		return $this->name;
	}

	/**
	 * Set value
	 *
	 * @param string $value        	
	 *
	 * @return Content
	 */
	public function setValue($value) {
		$this->value = $value;
		
		return $this;
	}

	/**
	 * Get value
	 *
	 * @return string
	 */
	public function getValue() {
		return $this->value;
	}

	/**
	 * Set description
	 *
	 * @param string $description        	
	 *
	 * @return Content
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
}

