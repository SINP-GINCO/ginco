<?php

namespace Ign\Bundle\GincoBundle\Query ;

use Doctrine\Bundle\DoctrineBundle\Registry;

use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Query\TableFormatQueryBuilder ;

/**
 * Description of TableFormatQuery
 *
 * @author rpas
 */
class TableFormatQuery {
	
	
	/**
	 *
	 * @var Registry
	 */
	protected $doctrine ;

	
	public function __construct(Registry $doctrine) {
		
		$this->doctrine = $doctrine ;
	}

	/**
	 * Exécute une requete sur une table de données 
	 * @param TableFormatQueryBuilder $queryBuilder
	 * @return type
	 */
	public function query(TableFormatQueryBuilder $queryBuilder) {
		
		$entityManager = $this->doctrine->getManager("raw_data") ;
		$pdo = $entityManager->getConnection()->getWrappedConnection() ;
		
		$sth = $pdo->prepare($queryBuilder->getSQL()) ;
		$sth->execute($queryBuilder->getParemeters()) ;
		
		return $sth->fetchAll() ;
	}
}
