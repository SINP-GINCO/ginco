<?php

namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

use Ign\Bundle\GincoBundle\Entity\Metadata\Model;


/**
 * @ORM\Entity
 * @ORM\Table(name="metadata.standard")
 */
class Standard {
	
	public const STANDARD_OCCTAX = 'occtax' ;
	public const STANDARD_HABITAT = 'habitat' ;




	/**
	 *
	 * @var string
	 * 
	 * @ORM\Id
	 * @ORM\Column(name="name", type="text")
	 */
	private $name ;
	
	/**
	 *
	 * @var string
	 * 
	 * @ORM\Column(name="label", type="text")
	 */
	private $label ;
	
	
	/**
	 *
	 * @var string
	 * @ORM\Column(name="version", type="text")
	 */
	private $version ;
	
	
	/**
	 *
	 * @var ArrayCollection
	 * 
	 * @ORM\OneToMany(targetEntity="Model", mappedBy="standard")
	 */
	private $models ;
	
	
	public function __construct() {
		$this->models = new ArrayCollection() ;
	}
		
	
	/**
	 * Get standard name
	 * @return string
	 */
	public function getName() {
		return $this->name ;
	}
	
	/**
	 * Set standard name
	 * @param string $name
	 * @return $this
	 */
	public function setName($name) {
		$this->name = $name ;
		return $this ;
	}
	
	
	/**
	 * Get label
	 * @return string
	 */
	public function getLabel() {
		return $this->label ;
	}
	
	/**
	 * Set label
	 * @param string $label
	 * @return $this
	 */
	public function setLabel($label) {
		$this->label = $label ;
		return $this ;
	}
	
	/**
	 * Get version
	 * @return string
	 */
	public function getVersion() {
		return $this->version ;
	}
	
	
	/**
	 * Set version
	 * @param string $version
	 * @return $this
	 */
	public function setVersion($version) {
		$this->version = $version ;
		return $this ;
	}
	
	/**
	 * Get associated modelss
	 * @return ArrayCollection
	 */
	public function getModels() {
		return $this->models ;
	}
	
	/**
	 * Get default model for this standard.
	 * @return Model
	 */
	public function getDefaultModel() {
		
		foreach ($this->models as $model) {
			if ($model->getRef() === true) {
				return $model ;
			}
		}
		return null ;
	}
}
