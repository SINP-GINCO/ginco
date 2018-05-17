<?php
namespace Ign\Bundle\GincoBundle\Entity\Website;

use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\GincoBundle\Entity\Website\PermissionGroup;


/**
 * Permission
 *
 * @ORM\Table(name="website.permission")
 * @ORM\Entity
 */
class Permission implements \Serializable {

	/**
	 *
	 * @var string @ORM\Id
	 *      @ORM\Column(name="permission_code", type="string", length=36, unique=true)
	 */
	private $code;

	/**
	 *
	 * @var string @ORM\Column(name="permission_label", type="string", length=255, nullable=true)
	 */
	private $label;
	
	
	/**
	 * 
	 * @var PermissionGroup
	 * 
	 * @ORM\ManyToOne(targetEntity="PermissionGroup", inversedBy="permissions")
	 * @ORM\JoinColumn(name="permission_group_code", referencedColumnName="code")
	 */
	private $group ;
	
	
	/**
	 * 
	 * @var string
	 * 
	 * @ORM\Column(name="description", type="text")
	 */
	private $description ;

	/**
	 * Set code
	 *
	 * @param string $code        	
	 *
	 * @return Permission
	 */
	public function setCode($code) {
		$this->code = $code;
		
		return $this;
	}

	/**
	 * Get code
	 *
	 * @return string
	 */
	public function getCode() {
		return $this->code;
	}

	/**
	 * Set label
	 *
	 * @param string $label        	
	 *
	 * @return Permission
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
	 * Get permission group
	 * @return \Ign\Bundle\GincoBundle\Entity\Website\PermissionGroup
	 */
	public function getGroup() {
		return $this->group ;
	}
	
	/**
	 * Set permission group
	 * @param PermissionGroup $group
	 * @return \Ign\Bundle\GincoBundle\Entity\Website\Permission
	 */
	public function setGroup(PermissionGroup $group) {
		$this->group = $group ;
		return $this ;
	}

	/**
	 * Get description
	 * @return string
	 */
	public function getDescription() {
		return $this->description ;
	}
	
	/**
	 * Set description
	 * @param unknown $description
	 * @return \Ign\Bundle\GincoBundle\Entity\Website\Permission
	 */
	public function setDescription($description) {
		$this->description = $description ;
		return $this ;
	}
	
	/**
	 *
	 * @see \Serializable::serialize()
	 */
	public function serialize() {
		return serialize(array(
			$this->code,
			$this->label,
			$this->description
		));
	}

	/**
	 *
	 * @see \Serializable::unserialize()
	 */
	public function unserialize($serialized) {
		list ($this->code, $this->label) = unserialize($serialized);
	}

	public function __toString()
	{
		return $this->label;
	}
}

