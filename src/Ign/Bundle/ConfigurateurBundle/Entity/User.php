<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\ArrayCollection;
use Symfony\Component\Security\Core\User\UserInterface;

/**
 * @ORM\Table(name="website.users")
 * @ORM\Entity
 */
class User implements UserInterface {

	/**
	 * @ORM\Column(name="user_login", type="string")
	 * @ORM\Id
	 */
	private $id;

	/**
	 * @ORM\Column(name="user_name", type="string", length=255, unique=true)
	 */
	private $username;

	private $password;

	private $salt;

	/**
	 * @ORM\ManyToMany(targetEntity="Role", inversedBy="users")
	 * @ORM\JoinTable(name="website.role_to_user",
	 * 	joinColumns={@ORM\JoinColumn(name="user_login", referencedColumnName="user_login")},
	 * 	inverseJoinColumns={@ORM\JoinColumn(name="role_code", referencedColumnName="role_code")}
	 * )
	 */
	private $roles; // = array('ROLE_ADMIN');

	public function __construct() {
		$this->roles = new ArrayCollection();
	}

	public function getId() {
		return $this->id;
	}

	public function setId($id) {
		$this->id = $id;
		return $this;
	}

	public function getUsername() {
		return $this->username;
	}

	public function setUsername($username) {
		$this->username = $username;
		return $this;
	}

	public function getPassword() {
		return $this->password;
	}

	public function setPassword($password) {
		$this->password = $password;
		return $this;
	}

	public function getSalt() {
		return $this->salt;
	}

	public function setSalt($salt) {
		$this->salt = $salt;
		return $this;
	}

	/**
	 * Add role
	 *
	 * @param \Role $role
	 * @return User
	 */
	public function addRole(Role $role) {
		if(!$this->roles->contains($role)){
			$this->roles->add($role);
			$role->addUser($this);
		}

		return $this;
	}

	/**
	 * Remove role
	 *
	 * @param \Role $role
	 */
	public function removeRole(Role $role) {
		if($this->roles->contains($role)){
			$this->roles->remove($role);
			$role->removeUser($this);
		}
	}

	/**
	 * Get roles
	 *
	 * @return ArrayCollection()
	 */
	public function getRoles() {
		return $this->roles;
	}

	// Les getters et setters
	public function eraseCredentials() {}
}