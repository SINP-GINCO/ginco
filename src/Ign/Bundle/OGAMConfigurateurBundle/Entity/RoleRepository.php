<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\ORM\EntityRepository;
use Ign\Bundle\ConfigurateurBundle\IgnConfigurateurBundle;
use Doctrine\ORM\Query\ResultSetMappingBuilder;
use Doctrine\ORM\Query\ResultSetMapping;

class RoleRepository extends EntityRepository {

	/**
	 * Get the permissions (roles in Symfony) of a user.
	 *
	 * @param
	 *        	user the id of the user
	 *
	 * @return array of string
	 */
	public function findPermissionsByUser($user) {
		$em = $this->getEntityManager();
		// Construct the request
		$sql = "SELECT ppr.permission_code
				FROM website.role as r
				INNER JOIN website.permission_per_role AS ppr ON ppr.role_code = r.role_code
				INNER JOIN website.role_to_user AS rtu ON rtu.role_code = r.role_code
				INNER JOIN website.users AS u ON u.user_login = rtu.user_login
				WHERE u.user_login = :user";

		$rsm = new ResultSetMapping();
		// Define which columns should be returned
		$rsm->addScalarResult('permission_code', 'permission');
		// Get the results
		$query = $em->createNativeQuery($sql, $rsm);
		$query->setParameter(':user', $user->getId());
		$result = $query->getScalarResult();
		$roles = array();
		// Append ROLE_ prefix to each roles so Symfony Security bundle understand them
		foreach($result as $row){
			array_push($roles, 'ROLE_'.$row['permission']);
		}
		return $roles;
	}

}
