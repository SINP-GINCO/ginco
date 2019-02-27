<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\DBAL\Connection;
use Doctrine\ORM\ORMException;
use Doctrine\ORM\EntityManager;

use Ign\Bundle\GincoBundle\Entity\Metadata\Dataset;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\FileField;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableField;

/**
 * Utility class for publication of an import model into a database.
 *
 * @author Gautam Pastakia
 *
 */
class ImportModelPublication extends DatabaseUtils {
	
	/**
	 *
	 * @var EntityManager
	 */
	private $entityManager ;

	public function __construct(EntityManager $entityManager, $adminName, $adminPassword) {
		$this->entityManager = $entityManager ;
		parent::__construct($entityManager->getConnection(), $adminName, $adminPassword);
	}

	/**
	 * Publishes an import model by copying all the data related to a specific import model.
	 *
	 * @param Dataset : the	import model object
	 * @return true if publication succeded, false otherwise
	 */
	public function publishImportModel(Dataset $importModel) {
		
		if (!$this->isPublishable($importModel)) {
			return false ;
		}

		$importModel->setStatus(Dataset::PUBLISHED) ;
		$this->entityManager->flush() ;

		return true ;	

	}



	/**
	 * Checks if, for a given import model, every file has at least one non-technical field
	 *
	 * @param $modelId : the id of the import model
	 * @return bool
	 */
	private function importModelFilesHaveFields(Dataset $dataset) {
		
		$filesHaveFields = true ;
		$files = $dataset->getFiles() ;
		foreach ($files as $file) {
			$filesHaveFields = $filesHaveFields && $file->hasFields() ;
		}

		return $filesHaveFields;
	}

	/**
	 * Checks if, for a given import model, every file has at least one field mapped
	 *
	 * @param $modelId : the id of the import model
	 * @return bool
	 */
	public function importModelFilesAreMapped(Dataset $dataset) {
		
		$modelId = $dataset->getId() ;
		$sql = "SELECT df.format AS fileformat, fm.mapping_type AS type, COUNT(fm.src_data) AS nbmappings
				FROM metadata.dataset_files df
				LEFT JOIN metadata.field_mapping fm ON df.format = fm.src_format
				WHERE df.dataset_id = ?
				GROUP BY df.format, fm.mapping_type;";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		$filesAllMapped = true;
		while ($row = $stmt->fetch()) {
			// no technical fields, unlike data tables.
			if ( ($row['type'] == 'FILE' || empty($row['type']) ) && $row['nbmappings'] == 0 ) {
				$filesAllMapped = false;
			}
		}
		return $filesAllMapped;
	}

	/**
	 * Checks if, for a given import model, all the non-calculated mandatory fields from the model
	 * linked to the import model are present in the configurated files of the import model.
	 *
	 * @param $importModelId : the import model id
	 * @param $tableFormat : the format of the table
	 * @return bool
	 */
	public function importModelFilesContainAllMandatoryFields(Dataset $dataset, TableFormat $tableFormat) {
		
		$MNCFields = $tableFormat->getMandatoryAndNotCalculatedFields()->filter(function(TableField $field) {
			return !in_array($field->getData()->getData(), array(
				'PROVIDER_ID',
				'USER_LOGIN',
				'SUBMISSION_ID'
			));
		}) ;

		$filesFieldsList = array();

		$files = $dataset->getFiles() ;
		/* @var $file \Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat */
		foreach ($files as $file) {
			$fields = $file->getFields() ;
			/* @var $field \Ign\Bundle\GincoBundle\Entity\Metadata\FileField */
			foreach ($fields as $field) {
				$filesFieldsList[] = $field->getData()->getData() ;
			}
		}

		$containAllMNCF = true;
		foreach($MNCFields as $MNC){
			if(!in_array($MNC->getData()->getData(), $filesFieldsList)){
				$containAllMNCF = false;
				break;
			}
		}

		return $containAllMNCF;
	}

	/**
	 * Returns true if it is possible to publish the import model.
	 * The import model :
	 * - must NOT be published
	 * - must have its associated data model published
	 * - must have at least one file
	 * - must have at least one field in all its files.
	 * - must have at least one mapped field in all its files.
	 * - must contain all the non-calculated mandatory model fields
	 *
	 * @param Dataset : the	import model object
	 * @return boolean
	 */
	public function isPublishable(Dataset $importModel) {
		$importModelId = $importModel->getId();
		$tableFormat = $importModel->getModel()->getTables()[0];
		$publishable = (
			!$importModel->isPublished()
			&& $importModel->getModel()->isPublished()
			&& $importModel->hasFiles()
			&& $this->importModelFilesHaveFields($importModel)
			&& $this->importModelFilesAreMapped($importModel)
			&& $this->importModelFilesContainAllMandatoryFields($importModel, $tableFormat)
		);

		return $publishable;
	}
}