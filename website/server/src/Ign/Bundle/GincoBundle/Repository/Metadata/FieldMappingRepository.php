<?php
namespace Ign\Bundle\GincoBundle\Repository\Metadata;

use Doctrine\ORM\EntityRepository;

use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;

class FieldMappingRepository extends EntityRepository {

	/**
	 * Get mapping relations.
	 *
	 * @param
	 *        	fileFormat the name of the file format
	 *
	 * @return list of FileField
	 */
	public function findMappings($fileFormat, $mappingType) {
		$em = $this->getEntityManager();
		$query = $em->createQuery(
			'SELECT fm.srcData as srcData,
					fm.srcFormat as srcFormat, 
					fm.dstData as dstData,
					fm.dstFormat as dstFormat, 
					tf.label as label,
					dt.label as srcDataLabel, 
					dt2.label as dstDataLabel
			FROM IgnGincoBundle:Metadata\FieldMapping fm
			LEFT JOIN IgnGincoBundle:Metadata\TableFormat tf WITH fm.dstFormat = tf.format
			LEFT JOIN IgnGincoBundle:Metadata\Data dt WITH dt.data = fm.srcData
			LEFT JOIN IgnGincoBundle:Metadata\Data dt2 WITH dt2.data = fm.dstData
			WHERE fm.mappingType = :mappingType
			AND fm.srcFormat = :fileFormat
			ORDER BY fm.srcData'
		);

		$query->setParameters(array(
			'fileFormat' => $fileFormat,
			'mappingType' => $mappingType
		));

		return $query->getResult();
	}

	/**
	 * Get file fields with no mapping relations.
	 *
	 * @param
	 *        	fileFormat the name of the file format
	 *
	 * @return list of FileField
	 */
	public function findNotMappedFields($fileFormat, $mappingType) {
		$em = $this->getEntityManager();
		$query = $em->createQuery(
			'SELECT dt.data, dt.label as label
			FROM IgnGincoBundle:Metadata\FileField ff
			LEFT JOIN IgnGincoBundle:Metadata\Data dt WITH dt.data = ff.data
			WHERE ff.data NOT IN (
				SELECT fm.srcData
				FROM IgnGincoBundle:Metadata\FieldMapping fm
				WHERE fm.mappingType = :mappingType
				AND fm.srcFormat = :fileFormat
			)
			AND ff.format = :fileFormat
			ORDER BY dt.data'
		);

		$query->setParameters(array(
			'fileFormat' => $fileFormat,
			'mappingType' => $mappingType
		));

		return $query->getResult();
	}

	/**
	 * Get table fields with no mapping relations.
	 *
	 * @param
	 *        	tableFormat the name of the table format
	 *
	 * @return list of TableField
	 */
	public function findNotMappedFieldsInTable($tableFormat, $mappingType) {
		$em = $this->getEntityManager();
		$query = $em->createQuery("SELECT dt.data, dt.label as label
					FROM IgnGincoBundle:Metadata\TableField tf
					LEFT JOIN IgnGincoBundle:Metadata\Data dt
						WITH dt.data = tf.data
					WHERE tf.data NOT IN (
						SELECT fm.dstData
						FROM IgnGincoBundle:Metadata\FieldMapping fm
						WHERE fm.mappingType = :mappingType
						AND fm.dstFormat = :tableFormat)
					AND tf.format = :tableFormat
					AND tf.data NOT IN ('PROVIDER_ID', 'USER_LOGIN', 'SUBMISSION_ID')
					AND dt.data NOT LIKE :ogam_id
					ORDER BY tf.data");

		$query->setParameters(array(
			'tableFormat' => $tableFormat,
			'mappingType' => $mappingType,
			'ogam_id' => TableFormat::PK_PREFIX . '%'
		));

		return $query->getResult();
	}

	/**
	 * Deletes all the mappings linked with the file.
	 *
	 * @param
	 *        	fileFormat the name of the file
	 *
	 * @return result of the delete query
	 */
	public function removeAllByFileFormat($fileFormat) {
		$query = $this->_em->createQuery('DELETE FROM IgnGincoBundle:Metadata\FieldMapping fm
			WHERE fm.srcFormat =:fileFormat');
		$query->setParameters(array(
			'fileFormat' => $fileFormat
		));

		return $query->getResult();
	}

	/**
	 * Deletes all the mappings linked with the file
	 * and of given type.
	 *
	 * @param
	 *        	fileFormat the name of the file
	 *
	 * @return result of the delete query
	 */
	public function removeAllByFileFormatAndType($fileFormat, $mappingType) {
		$query = $this->_em->createQuery('DELETE FROM IgnGincoBundle:Metadata\FieldMapping fm
			WHERE fm.srcFormat =:fileFormat
			AND fm.mappingType =:mappingType');
		$query->setParameters(array(
			'fileFormat' => $fileFormat,
			'mappingType' => $mappingType
		));

		return $query->getResult();
	}

	/**
	 * Deletes all the mappings linked with a field of a file.
	 *
	 * @param
	 *        	fileFormat the name of the file
	 * @param
	 *        	field the name of the field
	 *
	 * @return result of the delete query
	 */
	public function removeAllByFileField($fileFormat, $field) {
		$query = $this->_em->createQuery('DELETE FROM IgnGincoBundle:Metadata\FieldMapping fm
			WHERE fm.srcFormat =:fileFormat
			AND fm.srcData =:field');
		$query->setParameters(array(
			'fileFormat' => $fileFormat,
			'field' => $field
		));

		return $query->getResult();
	}

	/**
	 * Deletes all the mappings linked with the table.
	 *
	 * @param
	 *        	tableFormat the name of the table
	 *
	 * @return result of the delete query
	 */
	public function removeAllByTableFormat($tableFormat) {
		$query = $this->_em->createQuery('DELETE FROM IgnGincoBundle:Metadata\FieldMapping fm
			WHERE fm.dstFormat =:tableFormat');
		$query->setParameters(array(
			'tableFormat' => $tableFormat
		));

		return $query->getResult();
	}

	/**
	 * Deletes all the mappings linked with a field of a table.
	 *
	 * @param
	 *        	tableFormat the name of the table
	 * @param
	 *        	field the name of the field
	 *
	 * @return result of the delete query
	 */
	public function removeAllByTableField($tableFormat, $field) {
		$query = $this->_em->createQuery('DELETE FROM IgnGincoBundle:Metadata\FieldMapping fm
			WHERE fm.dstFormat =:tableFormat
			AND fm.dstData =:field');
		$query->setParameters(array(
			'tableFormat' => $tableFormat,
			'field' => $field
		));

		return $query->getResult();
	}

	/**
	 * Deletes all the mappings linked with the table except the mapping linked to a reference field.
	 *
	 * @param
	 *        	tableFormat the name of the table
	 *
	 * @return result of the delete query
	 */
	public function removeAllExceptRefMappingsByTableFormat($tableFormat) {
		$query = $this->_em->createQuery('DELETE FROM IgnGincoBundle:Metadata\FieldMapping fm
			WHERE fm.dstFormat =:tableFormat
			AND fm.srcData NOT IN (SELECT ta.data
				FROM IgnGincoBundle:Metadata\TableField ta
				INNER JOIN IgnGincoBundle:Metadata\ModelTables mt WITH mt.table = ta.tableFormat
				INNER JOIN IgnGincoBundle:Metadata\Model m WITH m.id = mt.model
				WHERE m.ref = true)');
		$query->setParameters(array(
			'tableFormat' => $tableFormat
		));

		return $query->getResult();
	}
}
