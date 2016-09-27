<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\ORM\EntityRepository;

class FieldRepository extends EntityRepository {

	/**
	 * Deletes all the fields of the table.
	 *
	 * @param
	 *        	format the name of the table f
	 *
	 * @return result of the delete query
	 */
	public function deleteAllByTableFormat($format) {
		$query = $this->_em->createQuery('DELETE FROM IgnConfigurateurBundle:Field f
			WHERE f.format =:format');
		$query->setParameter('format', $format);

		return $query->getResult();
	}

	/**
	 * Deletes all the fields of the file.
	 *
	 * @param
	 *        	format the name of the file f
	 *
	 * @return result of the delete query
	 */
	public function deleteAllByFileFormat($format) {
		$query = $this->_em->createQuery('DELETE FROM IgnConfigurateurBundle:Field f
			WHERE f.format =:format');
		$query->setParameters(array(
			'format' => $format
		));

		return $query->getResult();
	}


	/**
	 * Deletes all non-technical fields of the table.
	 *
	 * @param
	 *        	format the name of the table f
	 *
	 * @return result of the delete query
	 */
	public function deleteNonTechnicalByTableFormat($format) {
		$qb = $this->_em->createQueryBuilder();
		$query = $qb->select('f')
				->from('IgnConfigurateurBundle:Field', 'f')
				->innerJoin('f.data', 'd')
				->where('f.format = :format')
				->andwhere("d.name NOT IN ('PROVIDER_ID', 'SUBMISSION_ID')")
				->andwhere('d.name NOT LIKE :fkCondition')
				->setParameters(array(
						'format' => $format,
						'fkCondition' => TableFormat::PK_PREFIX . '%',
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

	/**
	 * Deletes the foreign key towards a parent table.
	 *
	 * @param
	 *        	format the name of the table
	 * @return result of the delete query
	 */
	public function deleteForeignKeysByFormat($format) {
		$qb = $this->_em->createQueryBuilder();
		$query = $qb->select('f')
			->from('IgnConfigurateurBundle:Field', 'f')
			->innerJoin('f.data', 'd')
			->where('f.format = :format')
			->andwhere('d.name LIKE :fkCondition')
			->andwhere('d.name != :pkCondition')
			->setParameters(array(
				'format' => $format,
				'fkCondition' => TableFormat::PK_PREFIX . '%',
				'pkCondition' => TableFormat::PK_PREFIX . $format,
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
