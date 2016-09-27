<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\ORM\EntityRepository;
use Ign\Bundle\ConfigurateurBundle\IgnConfigurateurBundle;
use Doctrine\ORM\Query\ResultSetMappingBuilder;
use Doctrine\ORM\Query\ResultSetMapping;

class ModelRepository extends EntityRepository {

	/**
	 * Find the list of import models ordered by their name.
	 *
	 * @return array of string
	 */
	public function findAllOrderedByName() {
		return $this->getEntityManager()
			->createQuery('SELECT m FROM IgnConfigurateurBundle:Model m ORDER BY m.name ASC')
			->getResult();
	}
}
