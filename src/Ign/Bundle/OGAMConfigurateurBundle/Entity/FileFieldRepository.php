<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Entity;

use Doctrine\ORM\EntityRepository;
use Ign\Bundle\OGAMConfigurateurBundle\IgnOGAMConfigurateurBundle;

class FileFieldRepository extends EntityRepository {

	/**
	 * Get the fields of the file.
	 *
	 * @param
	 *        	fileFormat the name of the file format
	 *
	 * @return list of FileField
	 */
	public function findFieldsByFileFormat($fileFormat) {
		$em = $this->getEntityManager();
		$query = $em->createQuery('SELECT DISTINCT tfi.data as fieldName,
						dt.label as label,
						u.type as unitType, tfi.isMandatory,
						tfi.mask, tfi.position
					FROM IgnOGAMConfigurateurBundle:FileField tfi
					LEFT JOIN IgnOGAMConfigurateurBundle:FileFormat tfo
						WITH tfo.format = tfi.fileFormat
					LEFT JOIN IgnOGAMConfigurateurBundle:Data dt
						WITH tfi.data = dt.name
					LEFT JOIN IgnOGAMConfigurateurBundle:Unit u
						WITH dt.unit = u.name
					WHERE tfi.fileFormat = :fileFormat
					ORDER BY tfi.position');

		$query->setParameters(array(
			'fileFormat' => $fileFormat
		));

		return $query->getResult();
	}

	/**
	 * Deletes all the fields of the file.
	 *
	 * @param
	 *        	fileFormat the name of the file f
	 *
	 * @return result of the delete query
	 */
	public function deleteAllByFileFormat($fileFormat) {
		$query = $this->_em->createQuery('DELETE FROM IgnOGAMConfigurateurBundle:FileField t
			WHERE t.fileFormat =:fileFormat');
		$query->setParameters(array(
			'fileFormat' => $fileFormat
		));

		return $query->getResult();
	}

	/**
	 * Deletes the foreign key towards a parent file.
	 *
	 * @param
	 *        	format the name of the file
	 * @return result of the delete query
	 */
	public function deleteForeignKeysByFileFormat($format) {
		$query = $this->_em->createQuery("DELETE FROM IgnOGAMConfigurateurBundle:FileField f
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
