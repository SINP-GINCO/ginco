<?php
namespace Ign\Bundle\GincoBundle\Entity\Mapping;

use Doctrine\ORM\Mapping as ORM;

/**
 * Service
 *
 * @ORM\Table(name="mapping.layer_service")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Mapping\LayerServiceRepository")
 */
class LayerService implements \JsonSerializable {

	/**
	 * The name of the service.
	 * 
	 * @var string @ORM\Id
	 *      @ORM\Column(name="name", type="string", length=50, unique=true)
	 */
	private $name;

	/**
	 * The configuration with base url and parameters of the service.
	 * 
	 * @var string @ORM\Column(name="config", type="string", length=1000, nullable=true)
	 */
	private $config;

	/**
	 * Get id
	 *
	 * @return string
	 */
	public function getId() {
		return $this->name;
	}

	/**
	 * Set name
	 *
	 * @param string $name        	
	 *
	 * @return LayerService
	 */
	public function setServiceName($name) {
		$this->name = $name;
		
		return $this;
	}

	/**
	 * Get name
	 *
	 * @return string
	 */
	public function getname() {
		return $this->name;
	}

	/**
	 * Set config
	 *
	 * @param string $config        	
	 *
	 * @return LayerService
	 */
	public function setconfig($config) {
		$this->config = $config;
		
		return $this;
	}

	/**
	 * Get config
	 *
	 * @return string
	 */
	public function getconfig() {
		return $this->config;
	}

	/**
	 * Serialize the object as a JSON string
	 *
	 * @return string: JSON string
	 */
	public function jsonSerialize() {
		return [
			'id' => $this->getId(),
			'name' => $this->name,
			'config' => json_decode($this->config)
		];
	}
}

