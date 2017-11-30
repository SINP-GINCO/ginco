<?php
namespace Ign\Bundle\GincoBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;

/**
 * ProviderInpn
 *
 * @ORM\Table(name="website.providers")
 * @ORM\Entity
 * @UniqueEntity(fields="label", message="administration.provider.label")
 */
class ProviderInpn {

	/**
	 *
	 * @var string @ORM\Column(name="id", type="string")
	 *      @ORM\Id
	 */
	private $id;

	
	/**
	 *
	 * @var string @Assert\NotBlank()
	 *      @ORM\Column(name="label", type="string", unique=true,nullable=false)
	 */
	private $label;

	/**
	 *
	 * @var string @ORM\Column(name="definition", type="string", nullable=true)
	 */
	private $definition;

	/**
	 *
	 * @var string @ORM\Column(name="uuid", type="string", unique=true, nullable=true)
	 */
	private $UUID;

	/**
	 * Get id
	 *
	 * @return string
	 */
	public function getId() {
		return $this->id;
	}

	/**
	 * Set idl
	 *
	 * @param string $id
	 *
	 * @return Provider
	 */
	public function setId($id) {
		$this->id = $id;
		
		return $this;
	}
	/**
	 * Set label
	 *
	 * @param string $label        	
	 *
	 * @return Provider
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
	 *
	 * @return Provider
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
	 * Set UUID
	 *
	 * @param string $UUID	
	 *
	 * @return Provider
	 */
	public function setUUID($UUID) {
		$this->uuid = $UUID;
		
		return $this;
	}

	/**
	 * Get UUID
	 *
	 * @return string
	 */
	public function getUUID($UUID) {
		return $uuid->uuid;
	}
	

	public function __toString()
	{
		return $this->getLabel() . " (" . $this->getId(). ")";
	}

}
