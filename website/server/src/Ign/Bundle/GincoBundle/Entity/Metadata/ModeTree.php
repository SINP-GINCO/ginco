<?php
namespace Ign\Bundle\GincoBundle\Entity\Metadata;

use Doctrine\ORM\Mapping as ORM;

/**
 * ModeTree
 *
 * @ORM\Table(name="metadata.mode_tree")
 * @ORM\Entity(repositoryClass="Ign\Bundle\GincoBundle\Repository\Metadata\ModeTreeRepository")
 */
class ModeTree extends Mode {

	/**
	 *
	 * @var string @ORM\Column(name="parent_code", type="string", length=255)
	 */
	private $parentCode;

	/**
	 *
	 * @var bool @ORM\Column(name="is_leaf", type="boolean", nullable=true)
	 */
	private $isLeaf;

	/**
	 * Set parentCode
	 *
	 * @param string $parentCode        	
	 *
	 * @return ModeTree
	 */
	public function setParentCode($parentCode) {
		$this->parentCode = $parentCode;
		
		return $this;
	}

	/**
	 * Get parentCode
	 *
	 * @return string
	 */
	public function getParentCode() {
		return $this->parentCode;
	}

	/**
	 * Set isLeaf
	 *
	 * @param boolean $isLeaf        	
	 *
	 * @return ModeTree
	 */
	public function setIsLeaf($isLeaf) {
		$this->isLeaf = $isLeaf;
		
		return $this;
	}

	/**
	 * Get isLeaf
	 *
	 * @return bool
	 */
	public function getIsLeaf() {
		return $this->isLeaf;
	}
}

