<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Security\Core\Role\RoleInterface;
use Doctrine\Common\Collections\ArrayCollection;
use Symfony\Component\Config\Definition\Exception\Exception;

/**
 * @ORM\Table(name="website.role")
 * @ORM\Entity(repositoryClass="Ign\Bundle\ConfigurateurBundle\Entity\RoleRepository")
 */
class Role implements RoleInterface {

	/**
	 * @ORM\Column(name="role_code", type="string")
	 * @ORM\Id
	 */
	private $role;

	/**
	 * @var unknown
	 *
	 * @ORM\ManyToMany(targetEntity="User", mappedBy="roles")
	 */
	private $users;

	public function getRole() {
		return $this->role;
	}

	public function setRole($role) {
		$this->role = $role;
		return $this;
	}

	public function __construct() {
		$this->users = new ArrayCollection();
	}

	/**
	 * Add user.
	 *
	 * @param User $user
	 * @return User
	 */
	public function addUser(User $user) {
		if(!$this->users->contains($user)){
			$this->users->add($user);
			$user->addRole($this);
		}

		return $this;
	}

	/**
	 * Remove user
	 *
	 * @param User $user
	 */
	public function removeUser(User $user) {
		if($this->users->contains($user)){
			$this->users->remove($user);
			$user->removeRole($this);
		}
	}

	/**
	 * Get users
	 *
	 * @return ArrayCollection()
	 */
	public function getUsers() {
		return $this->users;
	}

}