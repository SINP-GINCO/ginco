<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\EntityRepository;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\OGAMConfigurateurBundle\IgnOGAMConfigurateurBundle;

class TableFieldRepository extends EntityRepository {

	/**
	 * Get the fields of the table.
	 *
	 * @param
	 *        	tableFormat the name of the table format
	 *
	 * @return list of TableField
	 */
	public function findFieldsByTableFormat($tableFormat) {
		$em = $this->getEntityManager();
		$query = $em->createQuery('SELECT DISTINCT tfi.data as fieldName,
					dt.label as label,
					u.type as unitType, tfi.isMandatory
					FROM IgnOGAMConfigurateurBundle:TableField tfi
					LEFT JOIN IgnOGAMConfigurateurBundle:TableFormat tfo
					WITH tfo.format = tfi.tableFormat
					LEFT JOIN IgnOGAMConfigurateurBundle:Data dt
					WITH tfi.data = dt.name
					LEFT JOIN IgnOGAMConfigurateurBundle:Unit u
					WITH dt.unit = u.name
					WHERE tfi.tableFormat = :tableFormat
					ORDER BY fieldName');

		$query->setParameters(array(
			'tableFormat' => $tableFormat
		));

		return $query->getResult();
	}

	/**
	 * Get the non-technical fields of the table.
	 *
	 * @param
	 *        	tableFormat the name of the table
	 *
	 * @return result of the delete query
	 */
	public function findNonTechnicalByTableFormat($tableFormat) {
		$query = $this->_em->createQuery("SELECT t
			FROM IgnOGAMConfigurateurBundle:TableField t
			WHERE t.tableFormat =:tableFormat
			AND t.data NOT IN ('PROVIDER_ID', 'SUBMISSION_ID')
			AND t.data NOT LIKE :ogam_id");
		$query->setParameters(array(
			'tableFormat' => $tableFormat,
			'ogam_id' => TableFormat::PK_PREFIX . '%'
		));
		return $query->getResult();
	}

	/**
	 * Get the fields corresponding to keys (primary and foreigns) of the table
	 *
	 * @param
	 *        	$tableFormat
	 * @return array
	 */
	public function findKeysByTableFormat($tableFormat) {
		$query = $this->_em->createQuery("SELECT t
			FROM IgnOGAMConfigurateurBundle:TableField t
			WHERE t.tableFormat =:tableFormat
			AND t.data LIKE :ogam_id");
		$query->setParameters(array(
			'tableFormat' => $tableFormat,
			'ogam_id' => TableFormat::PK_PREFIX . '%'
		));
		return $query->getResult();
	}
	
	/**
	 * Get all table_fields for a given dataset
	 *
	 * @param
	 *        	$datasetId
	 * @return Array[TableField]
	 */
	public function getTableFieldsForModel($modelId) {
		
		$query = $this->_em->createQuery("SELECT tfi.data, d.label, u.type
				FROM IgnOGAMConfigurateurBundle:TableField tfi
				LEFT JOIN IgnOGAMConfigurateurBundle:ModelTables mt WITH tfi.tableFormat = mt.table
				LEFT JOIN IgnOGAMConfigurateurBundle:Data d WITH tfi.data = d.name
				LEFT JOIN IgnOGAMConfigurateurBundle:Unit u WITH d.unit = u.name
				WHERE mt.model = :modelId
				ORDER BY d.label");
		$query->setParameters(array(
			'modelId' => $modelId
		));

		return $query->getResult();
	}

	/**
	 * Deletes all the fields of the table.
	 *
	 * @param
	 *        	tableFormat the name of the table f
	 *
	 * @return result of the delete query
	 */
	public function deleteAllByTableFormat($tableFormat) {
		$query = $this->_em->createQuery('DELETE FROM IgnOGAMConfigurateurBundle:TableField t
			WHERE t.tableFormat =:tableFormat');
		$query->setParameters(array(
			'tableFormat' => $tableFormat
		));

		return $query->getResult();
	}

	/**
	 * Deletes all non-technical fields of the table.
	 *
	 * @param
	 *        	tableFormat the name of the table
	 *
	 * @return result of the delete query
	 */
	public function deleteNonTechnicalByTableFormat($tableFormat) {
		$query = $this->_em->createQuery("DELETE FROM IgnOGAMConfigurateurBundle:TableField t
			WHERE t.tableFormat =:tableFormat
			AND t.data NOT IN ('PROVIDER_ID', 'SUBMISSION_ID')
			AND t.data NOT LIKE :ogam_id
			AND t.data NOT IN (SELECT ta.data
			FROM IgnOGAMConfigurateurBundle:TableField ta
			INNER JOIN IgnOGAMConfigurateurBundle:ModelTables mt WITH mt.table = ta.tableFormat
			INNER JOIN IgnOGAMConfigurateurBundle:Model m WITH m.id = mt.model
			WHERE m.ref = true)");
		$query->setParameters(array(
			'tableFormat' => $tableFormat,
			'ogam_id' => TableFormat::PK_PREFIX . '%'
		));

		return $query->getResult();
	}

	/**
	 * Deletes the foreign key towards a parent table.
	 *
	 * @param
	 *        	format the name of the table
	 * @return result of the delete query
	 */
	public function deleteForeignKeysByTableFormat($format) {
		$query = $this->_em->createQuery("DELETE FROM IgnOGAMConfigurateurBundle:TableField f
			WHERE f.tableFormat =:format
			AND f.data LIKE :fkCondition
			AND f.data != :pkCondition");
		$query->setParameters(array(
			'format' => $format,
			'fkCondition' => TableFormat::PK_PREFIX . '%',
			'pkCondition' => TableFormat::PK_PREFIX . $format
		));

		return $query->getResult();
	}

	/**
	 * Get the fields listed in tables in model that are marked as reference models.
	 *
	 * @return array
	 */
	public function findReferenceFields() {
		$query = $this->_em->createQuery("SELECT t.data
			FROM IgnOGAMConfigurateurBundle:TableField t
			INNER JOIN IgnOGAMConfigurateurBundle:ModelTables mt WITH mt.table = t.tableFormat
			INNER JOIN IgnOGAMConfigurateurBundle:Model m WITH m.id = mt.model
			WHERE m.ref = true");
		return $query->getResult();
	}

	/**
	 * Deletes all non-technical and non-reference fields of the table.
	 *
	 * @param
	 *        	tableFormat the name of the table
	 *
	 * @return result of the delete query
	 */
	public function deleteNonTechnicalAndNonRefByTableFormat($tableFormat) {
		$qb = $this->_em->createQueryBuilder();
		$qb2 = $this->_em->createQueryBuilder();

		$query = $qb->select('t')
			->from('IgnOGAMConfigurateurBundle:TableField', 't')
			->where('t.tableFormat = :tableFormat')
			->andwhere("t.data NOT IN ('PROVIDER_ID', 'SUBMISSION_ID')")
			->andwhere('t.data NOT LIKE :ogam_id')
			->andwhere($qb->expr()
			->notIn('t.data', $qb2->select('tf.data')
			->from('IgnOGAMConfigurateurBundle:TableField', 'tf')
			->join('IgnOGAMConfigurateurBundle:ModelTables', 'mt', \Doctrine\ORM\Query\Expr\Join::WITH, $qb2->expr()
			->eq(' mt.table', 'tf.tableFormat'))
			->join('IgnOGAMConfigurateurBundle:Model', 'm', \Doctrine\ORM\Query\Expr\Join::WITH, $qb2->expr()
			->eq(' m.id', 'mt.model'))
			->where('m.ref = true')
			->getDQL()))
			->setParameters(array(
			'tableFormat' => $tableFormat,
			'ogam_id' => TableFormat::PK_PREFIX . '%'
		))
			->getQuery();
		$results = $query->execute();

		// Delete the results
		foreach ($results as $result) {
			$this->_em->remove($result);
		}
		// Don't forget to flush in the controller
		return true;
	}
}
