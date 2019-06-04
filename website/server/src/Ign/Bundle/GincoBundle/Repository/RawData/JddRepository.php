<?php
namespace Ign\Bundle\GincoBundle\Repository\RawData;

use Doctrine\ORM\EntityRepository;
use Doctrine\ORM\Query\Expr;

use Ign\Bundle\GincoBundle\Entity\Website\Provider;
use Ign\Bundle\GincoBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Entity\RawData\JddField;
use Ign\Bundle\GincoBundle\Query\JddQuery;

/**
 * JddRepository
 *
 */
class JddRepository extends EntityRepository  {

	/**
	 * Get the active jdd (ie not 'deleted').
	 * Optionnaly filter by provider and/or user
	 *
	 * @param Provider|null $provider
	 * @param User|null $user
	 * @return array
	 */
	public function findActiveJdds(JddQuery $jddQuery) {

		return $this->createActiveJddsQueryBuilder($jddQuery)
			->orderBy('j.createdAt', 'DESC')
			->setMaxResults($jddQuery->getLimit())
			->setFirstResult($jddQuery->getOffset())
			->getQuery()
			->getResult()
		;
	}
	
	/**
	 * Compte les Jdds actifs
	 * @param JddQuery $jddQuery
	 * @return integer
	 */
	public function countActiveJdds(JddQuery $jddQuery) {
		
		return $this->createActiveJddsQueryBuilder($jddQuery)
			->select('COUNT(DISTINCT(j.id))')
			->getQuery()
			->getSingleScalarResult() 
		;
	}
	
	/**
	 * Créé un query builder pour compter les jdds actifs.
	 * @param JddQuery $jddQuery
	 * @return type
	 */
	private function createActiveJddsQueryBuilder(JddQuery $jddQuery) {
		
		$queryBuilder = $this->createQueryBuilder('j')
			->distinct()
			->where("j.status NOT IN ('deleted')")
		;
		
		if (!is_null($jddQuery->getUser())) {
			$queryBuilder->andWhere('j.user = :user')->setParameter('user', $jddQuery->getUser()) ;
		}
		
		if (!is_null($jddQuery->getProvider())) {
			$queryBuilder->andWhere('j.provider = :provider')->setParameter('provider', $jddQuery->getProvider()) ;
		}
		
		if (!is_null($jddQuery->getSearch())) {
			
			$andWhere = "UPPER(f.valueString) LIKE UPPER(:searchText)"
				. " OR UPPER(f.valueText) LIKE UPPER(:searchText)"
				. " OR UPPER(sf.fileName) LIKE UPPER(:searchText)"
				. " OR UPPER(p.label) LIKE UPPER(:searchText)"
				. " OR UPPER(u.login) LIKE UPPER(:searchText)"
				. " OR UPPER(u.username) LIKE UPPER(:searchText)"
			;
			if ( is_numeric($jddQuery->getSearch()) ) {
				$andWhere .= " OR f.valueInteger = :searchNum"
					. " OR f.valueFloat = :searchNum" ;
			}
			
			$queryBuilder
				->join('j.fields', 'f')
				->leftJoin('j.submissions', 's', Expr\Join::WITH, "s.step != 'CANCEL'")
				->leftJoin('s.files', 'sf')
				->join('j.user', 'u')
				->join('j.provider', 'p')
				->andWhere($andWhere)
				->setParameter('searchText', "%{$jddQuery->getSearch()}%")
			;
				
			if ( is_numeric($jddQuery->getSearch()) ) {
				$queryBuilder->setParameter('searchNum', $jddQuery->getSearch()) ;
			}
		}

		return $queryBuilder ;
	}
	

	/**
	 * Find Jdd by Field value
	 *
	 * @param array $criteria
	 * @param array|null $orderBy
	 * @param null $limit
	 * @param null $offset
	 * @return array
	 */
	public function findByField(array $criteria, array $orderBy = null, $limit = null, $offset = null)
	{
		$qb = $this->createQueryBuilder('j')
			->where('j.status != :status')
			->setParameter('status', 'deleted')
			->join('j.fields', 'f');
			// add criterias to the request
			foreach ($criteria as $key => $value) {
				$qb->andWhere('f.key = :key')
				->andWhere('(f.valueString = :valueStr OR f.valueText = :valueStr OR f.valueInteger = :valueInt OR f.valueFloat = :valueFloat)')
				->setParameter('key', $key)
				->setParameter('valueStr', (string) $value)
				->setParameter('valueInt', intval($value))
				->setParameter('valueFloat', floatval($value));
			}

		// Add order by
		foreach ((array) $orderBy as $orderKey => $direction) {
			$qb->addOrderBy('j.'.$orderKey, $direction);
		}

		if ($limit !== null) {
			$qb->setMaxResults( intval($limit) );
		}

		if ($offset !== null) {
			$qb->setFirstResult( intval($offset) );
		}

		$query = $qb->getQuery();

		return $query->getResult();
	}

	/**
	 * Find Jdd by Field value
	 * returns only the first found
	 *
	 * @param array $criteria
	 * @param array|null $orderBy
	 * @return array
	 */
	public function findOneByField(array $criteria, array $orderBy = null)
	{
		return $this->findByField($criteria, $orderBy, 1);
	}

	
	/**
	 * Find Jdd by their metadata ID.
	 * @param type $metadataId
	 * @return type
	 */
	public function findByMetadataId($metadataId) {
		
		$qb = $this->createQueryBuilder('j')
			->where('j.status != :status')
			->setParameter('status', 'deleted')
			->join('j.fields', 'f')
			->andWhere('f.key = :key')
			->andWhere('f.valueString = :valueStr')
			->setParameter('key', 'metadataId')
			->setParameter('valueStr', $metadataId)
		;

		return $qb->getQuery()->getResult();
	}
	
	/**
	 * Find ONE Jdd by their metadata ID.
	 * @param type $metadataId
	 * @return type
	 */
	public function findOneByMetadataId($metadataId) {
		
		$qb = $this->createQueryBuilder('j')
			->where('j.status != :status')
			->setParameter('status', 'deleted')
			->join('j.fields', 'f')
			->andWhere('f.key = :key')
			->andWhere('f.valueString = :valueStr')
			->setParameter('key', 'metadataId')
			->setParameter('valueStr', $metadataId)
		;

		return $qb->getQuery()->getSingleResult();
	}
	
	/**
	 * Find Jdd by Field value
	 *
	 * @param array $criteria
	 * @param array|null $orderBy
	 * @param null $limit
	 * @param null $offset
	 * @return array
	 */
	public function getActiveJddsFields($jddId = null, User $user = null) {
		
		$dql = "SELECT j FROM IgnGincoBundle:RawData\JddField j WHERE j.jdd = :jddId AND j.key NOT LIKE 'metadataCAId' ";
		$dql .= "ORDER BY j.jdd";
		$query = $this->getEntityManager()->createQuery($dql);
		
		if ($jddId != null) {
			$query->setParameter('jddId', $jddId);
		}
		return $query->getResult();
	}
	

}
