<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\EntityRepository;
use Ign\Bundle\OGAMConfigurateurBundle\IgnOGAMConfigurateurBundle;

class ModelRepository extends EntityRepository {

	/**
	 * Find the list of import models ordered by their name.
	 *
	 * @return array of string
	 */
	public function findAllOrderedByName() {
		return $this->getEntityManager()
			->createQuery('SELECT m FROM IgnOGAMConfigurateurBundle:Model m ORDER BY m.name ASC')
			->getResult();
	}
}
