<?php
namespace Ign\Bundle\GincoBundle\Repository\Metadata;

use Doctrine\ORM\EntityRepository;

class ModelRepository extends EntityRepository {

	/**
	 * Find the list of import models ordered by their name.
	 *
	 * @return array of string
	 */
	public function findAllOrderedByName() {
		
		return $this->createQueryBuilder('m')
			->orderBy('m.name', 'ASC')
			->getQuery()
			->getResult()
		;
	}
}
