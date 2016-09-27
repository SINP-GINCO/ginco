<?php
namespace Ign\Bundle\ConfigurateurBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\ORM\EntityRepository;
use Ign\Bundle\ConfigurateurBundle\IgnConfigurateurBundle;

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
					FROM IgnConfigurateurBundle:TableField tfi
					LEFT JOIN IgnConfigurateurBundle:TableFormat tfo
					WITH tfo.format = tfi.tableFormat
					LEFT JOIN IgnConfigurateurBundle:Data dt
					WITH tfi.data = dt.name
					LEFT JOIN IgnConfigurateurBundle:Unit u
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
			FROM IgnConfigurateurBundle:TableField t
			WHERE t.tableFormat =:tableFormat
			AND t.data NOT IN ('PROVIDER_ID', 'SUBMISSION_ID')
			AND t.data NOT LIKE :ogam_id");
		$query->setParameters(array(
			'tableFormat' => $tableFormat,
			'ogam_id' => TableFormat::PK_PREFIX . '%',
		));
		return $query->getResult();
	}

	/**
	 * Get the fields corresponding to keys (primary and foreigns) of the table
	 *
	 * @param $tableFormat
	 * @return array
	 */
	public function findKeysByTableFormat($tableFormat) {
		$query = $this->_em->createQuery("SELECT t
			FROM IgnConfigurateurBundle:TableField t
			WHERE t.tableFormat =:tableFormat
			AND t.data LIKE :ogam_id");
		$query->setParameters(array(
			'tableFormat' => $tableFormat,
			'ogam_id' => TableFormat::PK_PREFIX . '%',
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
		$query = $this->_em->createQuery('DELETE FROM IgnConfigurateurBundle:TableField t
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
		$query = $this->_em->createQuery("DELETE FROM IgnConfigurateurBundle:TableField t
			WHERE t.tableFormat =:tableFormat
			AND t.data NOT IN ('PROVIDER_ID', 'SUBMISSION_ID')
			AND t.data NOT LIKE :ogam_id");
		$query->setParameters(array(
			'tableFormat' => $tableFormat,
			'ogam_id' => TableFormat::PK_PREFIX . '%',
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
		$query = $this->_em->createQuery("DELETE FROM IgnConfigurateurBundle:TableField f
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
}
