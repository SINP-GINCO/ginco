<?php
namespace Ign\Bundle\OGAMBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;

/**
 * ApplicationParameter
 *
 * @ORM\Table(name="website.application_parameters")
 * @ORM\Entity(repositoryClass="Ign\Bundle\OGAMBundle\Repository\Website\ApplicationParameterRepository")
 */
class ApplicationParameter {

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="name", type="string", length=50, unique=true)
	 */
	private $name;

	/**
	 *
	 * @var string @ORM\Column(name="value", type="string", length=500, nullable=true)
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
	 * @return ApplicationParameter
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
	 * @return ApplicationParameter
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
	 * @return ApplicationParameter
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

