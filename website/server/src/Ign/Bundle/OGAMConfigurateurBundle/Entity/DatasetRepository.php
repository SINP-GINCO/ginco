<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\EntityRepository;
use Ign\Bundle\OGAMConfigurateurBundle\IgnOGAMConfigurateurBundle;

class DatasetRepository extends EntityRepository {

	/**
	 * Find the list of dataset models for a type and ordered by their name.
	 *
	 * @param $type the type of the dataset
	 * @return array of string
	 */
	public function findByTypeAndOrderedByName($type) {
		return $this->getEntityManager()
		->createQuery('SELECT d FROM IgnOGAMConfigurateurBundle:Dataset d WHERE d.type = :type ORDER BY d.label ASC')
		->setParameter(':type', $type)
		->getResult();
	}
}
