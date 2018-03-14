<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * ModeTaxref
 *
 * @ORM\Table(name="metadata.mode_taxref")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\ModeTaxrefRepository")
 */
class ModeTaxref extends ModeTree {

	/**
	 *
	 * @var string @ORM\Column(name="complete_name", type="string", length=255, nullable=true)
	 */
	private $completeName;

	/**
	 *
	 * @var string @ORM\Column(name="vernacular_name", type="string", length=255, nullable=true)
	 */
	private $vernacularName;
	
	/**
	 *
	 * @var string @ORM\Column(name="lb_name", type="string", length=255, nullable=true)
	 */
	private $scientificName;

	/**
	 *
	 * @var bool @ORM\Column(name="is_reference", type="boolean", nullable=true)
	 */
	private $isReference;

	/**
	 * Set completeName
	 *
	 * @param string $completeName        	
	 *
	 * @return ModeTaxref
	 */
	public function setCompleteName($completeName) {
		$this->completeName = $completeName;
		
		return $this;
	}

	/**
	 * Get completeName
	 *
	 * @return string
	 */
	public function getCompleteName() {
		return $this->completeName;
	}

	/**
	 * Set vernacularName
	 *
	 * @param string $vernacularName        	
	 *
	 * @return ModeTaxref
	 */
	public function setVernacularName($vernacularName) {
		$this->vernacularName = $vernacularName;
		
		return $this;
	}

	/**
	 * Get vernacularName
	 *
	 * @return string
	 */
	public function getVernacularName() {
		return $this->vernacularName;
	}
	
	/**
	 * Set scientificName
	 *
	 * @param string $scientificName
	 *
	 * @return ModeTaxref
	 */
	public function setScientificName($scientificName) {
		$this->scientificName = $scientificName;
	
		return $this;
	}
	
	/**
	 * Get scientificName
	 *
	 * @return string
	 */
	public function getScientificName() {
		return $this->scientificName;
	}

	/**
	 * Set isReference
	 *
	 * @param boolean $isReference        	
	 *
	 * @return ModeTaxref
	 */
	public function setIsReference($isReference) {
		$this->isReference = $isReference;
		
		return $this;
	}

	/**
	 * Get isReference
	 *
	 * @return bool
	 */
	public function getIsReference() {
		return $this->isReference;
	}
}

