<?php

namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\ORM\EntityManagerInterface ;
use Doctrine\Common\Persistence\ManagerRegistry;

use Psr\Log\LoggerInterface;

use Ign\Bundle\GincoConfigurateurBundle\Utils\TablesGeneration;
use Ign\Bundle\GincoBundle\Entity\Metadata\Model;
use Ign\Bundle\GincoBundle\Entity\Metadata\FileField;

/**
 * Description of ImportModelManager
 *
 * @author rpas
 */
class ImportModelManager {
	
	
		/**
	 *
	 * @var EntityManagerInterface
	 */
	private $entityManager ;
	
	
	
	
	/**
	 *
	 * @var TablesGeneration 
	 */
	private $tablesGeneration ;
	
	
	/**
	 *
	 * @var LoggerInterface
	 */
	private $logger ;
	
	
	public function __construct(
		ManagerRegistry $managerRegistry, 
		TablesGeneration $tablesGeneration,
		LoggerInterface $logger
	) {
		
		$this->entityManager = $managerRegistry->getManager('metadata') ;
		$this->tablesGeneration = $tablesGeneration ;
		$this->logger = $logger ;
	}
	
	
	/**
	 * Retire un champ d'un modèle d'import.
	 * @param FileField $fileField
	 */
	public function removeField(FileField $fileField) {
		
		$dataset = $fileField->getFormat()->getDataset() ;
		$fileFormat = $fileField->getFormat()->getFormat()->getFormat() ;
		$data = $fileField->getData()->getData() ;
		
		// Suppression field_mapping
		$fieldMappingRepository = $this->entityManager->getRepository("IgnGincoBundle:Metadata\FieldMapping") ;
		$fieldMappingRepository->removeAllByFileField($fileFormat, $data) ;
		
		$field = $this->entityManager->find("IgnGincoBundle:Metadata\Field", array(
			'data' => $data,
			'format' => $fileFormat
		));
		if ($field) {
			$this->entityManager->remove($field) ;
		}
		
		$this->entityManager->remove($fileField) ;
		
		$this->entityManager->flush() ;
	}
}
