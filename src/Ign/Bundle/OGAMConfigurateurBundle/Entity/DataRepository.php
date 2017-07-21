<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\ORM\EntityRepository;
use Assetic\Exception\Exception;

class DataRepository extends EntityRepository {

	/**
	 * Returns all the data fields available in the table data.
	 *
	 * @return the list of all fields in the data table
	 *
	 */
	public function findAllFields() {
		$em = $this->getEntityManager();
		$query = $em->createQuery('SELECT DISTINCT dt.name as dataName,dt.label as label, u.type as unitType
    			  FROM IgnOGAMConfigurateurBundle:Data dt
				  LEFT JOIN IgnOGAMConfigurateurBundle:Unit u
    			  WITH dt.unit = u.name
				  ORDER BY dt.name');

		return $query->getResult();
	}

	/**
	 * Returns all the data fields related to a model which are not named
	 * OGAM_ID%, PROVIDER_ID, SUBMISSION_ID.
	 *
	 * todo : remove ? because not used in project
	 *
	 * @param $modelId the
	 *        	id of the model
	 * @return the list of all fields in the data table related to the model
	 *
	 */
	public function findAllForeignKeysByModelId($modelId) {
		$qb = $this->createQueryBuilder('dt')
			->select('DISTINCT dtj')
			->from('IgnOGAMConfigurateurBundle:Model', 'm')
			->innerJoin('IgnOGAMConfigurateurBundle:ModelTables', 'mt', 'WITH', 'mt.model = :modelId')
			->innerJoin('IgnOGAMConfigurateurBundle:TableFormat', 'tfo', 'WITH', 'tfo.format = mt.table')
			->innerJoin('IgnOGAMConfigurateurBundle:TableField', 'tfi', 'WITH', 'tfi.tableFormat = tfo.format')
			->innerJoin('IgnOGAMConfigurateurBundle:Data', 'dtj', 'WITH', 'dtj.name = tfi.data')
			->andWhere('dtj.name NOT IN (:provider_id, :submission_id)')
			->andWhere('dtj.name NOT LIKE :ogam_id')
			->setParameters(array(
			'modelId' => $modelId,
			'ogam_id' => TableFormat::PK_PREFIX . '%',
			'provider_id' => 'PROVIDER_ID',
			'submission_id' => 'SUBMISSION_ID'
		));

		$query = $qb->getQuery();

		return $query->getResult();
	}

	/**
	 * Returns all the data fields related to a Field
	 *
	 * @return array
	 */
	public function findAllRelatedToFields() {
		$qb = $this->createQueryBuilder('dt')
			->select('dt')
			->leftJoin('dt.fields', 'f')
			->where('f.data is not NULL')
			->orderBy('dt.label','ASC');

		return $qb->getQuery()->getResult();
	}

	/**
	 * Returns all the data fields not related to a Field
	 *
	 * @return array
	 */
	public function findAllNotRelatedToFields() {
		$qb = $this->createQueryBuilder('dt')
			->select('dt')
			->leftJoin('dt.fields', 'f')
			->where('f.data is NULL')
			->orderBy('dt.label','ASC');

		return $qb->getQuery()->getResult();
	}

}
