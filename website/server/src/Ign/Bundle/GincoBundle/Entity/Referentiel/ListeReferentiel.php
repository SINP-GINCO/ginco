<?php

namespace Ign\Bundle\GincoBundle\Entity\Referentiel;

use Doctrine\ORM\Mapping as ORM;

/**
 * Description of ListeReferentiel
 * 
 * @ORM\Table(name="referentiels.liste_referentiels")
 * @ORM\Entity
 *
 * @author rpas
 */
class ListeReferentiel {
	
	
	/**
	 * @var string
	 * @ORM\Column(name="table_name", type="string", length=50)
	 * @ORM\Id
	 */
	private $tableName ;
	
	
	/**
	 * @var string
	 * @ORM\Column(name="name", type="string", length=50)
	 */
	private $name ;
	
	/**
	 * @var string
	 * @ORM\Column(name="label", type="string")
	 */
	private $label ;
	
	/**
	 * @var string
	 * @ORM\Column(name="description", type="text")
	 */
	private $description ;
	
	
	/**
	 * @var string
	 * @ORM\Column(name="version", type="string", length=50)
	 */
	private $version ;
	
	
	/**
	 * @var string
	 * @ORM\Column(name="type", type="string", length=20)
	 */
	private $type ;
	
	/**
	 * @var \DateTime
	 * @ORM\Column(name="updated_at", type="date")
	 */
	private $updatedAt ;
	
	/**
	 * @var string
	 * @ORM\Column(name="url", type="string")
	 */
	private $url ;
	
	
	public function __construct($tableName) {
		$this->tableName = $tableName ;
	}
	
	
	/**
	 * Get name
	 * @return string
	 */
	public function getName() {
		return $this->name ;
	}
	
	/**
	 * Get label
	 * @return string
	 */
	public function getLabel() {
		return $this->label ;
	}
	
	/**
	 * Get description 
	 * @return string
	 */
	public function getDescription() {
		return $this->description ;
	}
	
	/**
	 * Get Version
	 * @return string
	 */
	public function getVersion() {
		return $this->version ;
	}
	
	/**
	 * Get type
	 * @return string
	 */
	public function getType() {
		return $this->type ;
	}
	
	/**
	 * Get uploaded date
	 * @return \DateTime
	 */
	public function getUpdatedAt() {
		return $this->updatedAt ;
	}
	
	/**
	 * Get referentiel url
	 * @return string
	 */
	public function getUrl() {
		return $this->url ;
	}
}
