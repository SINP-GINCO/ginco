<?php
namespace Ign\Bundle\GincoBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;

use Ign\Bundle\GincoBundle\Entity\Website\Permission;

/**
 * 
 * @author rpas
 *
 * @ORM\Entity
 * @ORM\Table(name="website.permission_group")
 */
class PermissionGroup {
	
	/**
	 * 
	 * @var string
	 * 
	 * @ORM\Column(name="code", type="text")
	 * @ORM\Id
	 * @ORM\GeneratedValue(strategy="NONE")
	 */
	private $code ;
	
	/**
	 * 
	 * @var string
	 * 
	 * @ORM\Column(name="label", type="text")
	 */
	private $label ;
	
	/**
	 * 
	 * @var ArrayCollection
	 * 
	 * @ORM\OneToMany(targetEntity="Permission", mappedBy="group")
	 */
	private $permissions ;
	
	
	public function __construct() {
		$this->permissions = new ArrayCollection() ;
	}
	
	/**
	 * Get code
	 * @return string
	 */
	public function getCode() {
		return $this->code ;
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
	 * @return \src\Ign\Bundle\GincoBundle\Entity\Website\PermissionGroup
	 */
	public function setLabel($label) {
		$this->label = $label ;
		return $this ;
	}
	
	
	/**
	 * Get permissions associated to group.
	 * @return \Doctrine\Common\Collections\ArrayCollection
	 */
	public function getPermissions() {
		return $this->permissions ;		
	}
	
	/**
	 * Set permissions
	 * @param ArrayCollection $permissions
	 */
	public function setPermissions(ArrayCollection $permissions) {
		$this->permissions = $permissions ;
		return $this ;
	}
	
	/**
	 * Add new permission to group.
	 * @param Permission $permission
	 * @return \src\Ign\Bundle\GincoBundle\Entity\Website\PermissionGroup
	 */
	public function addPermission(Permission $permission) {
		
		if (!$this->permissions->contains($permission)) {
			$this->permissions->add($permission) ;
		}
		return $this ;
	}
}

