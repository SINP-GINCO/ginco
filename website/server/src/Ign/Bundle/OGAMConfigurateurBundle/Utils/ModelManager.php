<?php

namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\ORM\EntityManagerInterface ;
use Doctrine\Common\Persistence\ManagerRegistry;

use Psr\Log\LoggerInterface;

use Ign\Bundle\GincoConfigurateurBundle\Utils\TablesGeneration;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ImportModelManager;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelDuplication;
use Ign\Bundle\GincoConfigurateurBundle\Utils\CopyUtils;

use Ign\Bundle\GincoBundle\Entity\Metadata\Model;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableField;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\Data;
use Ign\Bundle\GincoBundle\Entity\Metadata\Field;

/**
 * Description of ModelManager
 *
 * @author rpas
 */
class ModelManager {
	
	/**
	 *
	 * @var EntityManagerInterface
	 */
	private $entityManager ;
	
	
	/**
	 *
	 * @var ImportModelManager
	 */
	private $importModelManager ;
	
	
	/**
	 *
	 * @var TablesGeneration 
	 */
	private $tablesGeneration ;
	
	
	/**
	 *
	 * @var ModelDuplication
	 */
	private $modelDuplication ;
	
	/**
	 *
	 * @var CopyUtils
	 */
	private $copyUtils ;
	
	
	/**
	 *
	 * @var LoggerInterface
	 */
	private $logger ;
	
	
	private $adminUser ;
	
	private $adminPassword ;
	
	
	public function __construct(
		ManagerRegistry $managerRegistry, 
		ImportModelManager $importModelManager,
		TablesGeneration $tablesGeneration,
		ModelDuplication $modelDuplication,
		CopyUtils $copyUtils,
		LoggerInterface $logger,
		$adminUser,
		$adminPassword
	) {
		
		$this->entityManager = $managerRegistry->getManager('metadata') ;
		$this->importModelManager = $importModelManager ;
		$this->tablesGeneration = $tablesGeneration ;
		$this->modelDuplication = $modelDuplication ;
		$this->copyUtils = $copyUtils ;
		$this->logger = $logger ;
		$this->adminUser = $adminUser ;
		$this->adminPassword = $adminPassword ;
	}
	
	
	/**
	 * Initialise un nouveau modèle :
	 *   - crée les formulaires
	 *   - crée les tables en base
	 * @param Model $model
	 * @return boolean
	 */
	public function initModel(Model $model) {
	
		try {
			
			$conn = $this->entityManager->getConnection() ;
			$dbconn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $this->adminUser . " password=" . $this->adminPassword) or die('Connection is impossible : ' . pg_last_error());

			pg_query($dbconn, "BEGIN");

			// generate query dataset (formulaires)
			if ($model->getQueryDatasets()->isEmpty()) {
				$datasetId = $this->copyUtils->createQueryDataset($model->getId(), $dbconn);
				$this->copyUtils->createFormFields($model->getId(), $datasetId, $dbconn);
			}

			// Generate the tables
			$result = $this->tablesGeneration->createTables($model->getId(), $dbconn);
			if (!$result) {
				pg_query($dbconn, "ROLLBACK");
				return false;
			}

			pg_query($dbconn, "COMMIT");
			
			$model->setCreatedAt(new \DateTime()) ;
			$this->entityManager->flush() ;

			return true;

		} catch (ContextErrorException $e) {
			$this->logger->error($e);
			pg_query($dbconn, "ROLLBACK");
			return false;
		} catch (DBALException $e) {
			$this->logger->error($e);
			pg_query($dbconn, "ROLLBACK");
			return false;
		} finally {
			if (isset($dbconn)) {
				pg_close($dbconn);
			}
		}
	}
	
	
	/**
	 * Ajoute un champ dans le modèle
	 * @param Data $data
	 * @param TableFormat $tableFormat
	 */
	public function addField(Data $data, TableFormat $tableFormat) {
		
		$format = $tableFormat->getFormat();

		$tableField = new TableField();
		$field = new Field();
		
		if ($data !== null) {
			
			$field->setData($data);
			$field->setFormat($format);
			$field->setType('TABLE');
			$this->entityManager->persist($field);

			$tableField->setData($data);
			$tableField->setFormat($tableFormat);
			$tableField->setColumnName($data->getData());
			
			$dataFieldPrefix = substr($data->getData(), 0, 8);
				$dataFieldSuffix = substr($data->getData(), 8, strlen($data->getData())-8);

				// todo : move to input form model when he will exist
				if ($dataFieldPrefix == "OGAM_ID_") {
					if ($dataFieldSuffix == $tableFormat->getFormat()->getFormat()){
						// primary key
						$tableField->setIsMandatory("1");
						$tableField->setIsCalculated("1");
						$tableField->setIsEditable("0");
						$tableField->setIsInsertable("0");
					} else {
						// foreign key
						$tableField->setIsMandatory("1");
						$tableField->setIsCalculated("0");
						$tableField->setIsEditable("0");
						$tableField->setIsInsertable("0");
					}
				} elseif ($data->getData() == "PROVIDER_ID") {
					$tableField->setIsMandatory("1");
					$tableField->setIsCalculated("0");
					$tableField->setIsEditable("0");
					$tableField->setIsInsertable("0");
				} elseif ($data->getData() == "USER_LOGIN") {
					$tableField->setIsMandatory("1");
					$tableField->setIsCalculated("0");
					$tableField->setIsEditable("0");
					$tableField->setIsInsertable("0");
				} elseif ($data->getData() == "SUBMISSION_ID") {
					$tableField->setIsMandatory("0");
					$tableField->setIsCalculated("1");
					$tableField->setIsEditable("0");
					$tableField->setIsInsertable("0");
				} else {
					$tableField->setIsMandatory("0");
					$tableField->setIsCalculated("0");
					$tableField->setIsEditable("1");
					$tableField->setIsInsertable("1");
				}

			$this->entityManager->persist($tableField);
		}
		$this->entityManager->flush();
		
        $model = $tableFormat->getModel() ;
        if (!$model->hasNeverBeenPublished()) {
            $this->tablesGeneration->addColumn($tableField) ;
        }
	}
	
	
	/**
	 * Retire un champ d'un modèle, des formulaires, et des modèles d'import associés.
	 * @param TableField $tableField
	 */
	public function removeField(TableField $tableField) {

		$data = $tableField->getData() ;
		$format = $tableField->getFormat() ;
		$model = $format->getModel() ;
		
		$this->logger->info("Remove field {$tableField->getColumnName()} from model {$model->getId()}") ;
	
		// Suppression liens dataset_fields
		$sql = "DELETE FROM metadata.dataset_fields WHERE data = :data AND format = :format" ;
		$connection = $this->entityManager->getConnection() ;
		$sth = $connection->prepare($sql) ;
		$sth->execute(array(
			'data' => $data->getData(),
			'format' => $format->getFormat()->getFormat()
		));
				
		// remove mapping relations first
		$mappingRepository = $this->entityManager->getRepository('IgnGincoBundle:Metadata\FieldMapping') ;
		$mappingRepository->removeAllByTableField($format->getFormat()->getFormat(), $data->getData());
		
		// retrait  FormField
		$formFieldToRemove = $this->entityManager->find("IgnGincoBundle:Metadata\FormField", array(
			"data" => $data->getData(),
			"format" => $format->getFormat()->getFormat()
		));
		if ($formFieldToRemove) {
			$this->entityManager->remove($formFieldToRemove);
		}
				

		// retrait  TableField
		$tableFieldToRemove = $this->entityManager->find("IgnGincoBundle:Metadata\TableField", array(
			"data" => $data->getData(),
			"format" => $format->getFormat()->getFormat()
		));
		$this->entityManager->remove($tableFieldToRemove);

		// Retrait Field
		$fieldToRemove = $this->entityManager->find("IgnGincoBundle:Metadata\Field", array(
			"data" => $data->getData(),
			"format" => $format->getFormat()->getFormat()
		));
		$this->entityManager->remove($fieldToRemove);
		
		
		
		$this->entityManager->flush();
		
		// Retrait "physique" de la colonne.
        if (!$model->hasNeverBeenPublished()) {
            $this->tablesGeneration->removeColumn($tableFieldToRemove) ;
        }
	}
	
}
