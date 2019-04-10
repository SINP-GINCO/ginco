<?php

namespace Ign\Bundle\GincoBundle\Services;

use Monolog\Logger;

use Doctrine\ORM\EntityManager;

use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Services\Integration;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
use Ign\Bundle\GincoBundle\Services\MetadataReader;

/**
 * Description of JddManager
 *
 * @author rpas
 */
class JddService {
	
	/**
	 * The logger.
	 *
	 * @var Logger
	 */
	protected $logger;

	/**
	 * @var ConfigurationManager
	 */
	protected $configuration;

	/**
	 *
	 * @var EntityManager 
	 */
	protected $entityManager;
	
	/**
	 *
	 * @var Integration
	 */
	protected $integrationService ;
	
	/**
	 *
	 * @var MetadataReader 
	 */
	protected $metadataReader ;


	/**
	 *
	 * @var translator
	 */
	protected $translator;

	function __construct(
		Logger $logger, 
		ConfigurationManager $configuration, 
		EntityManager $entityManager, 
		Integration $integrationService,
		MetadataReader $metadataReader
	) {
		// Initialise the logger
		$this->logger = $logger;
		
		// Initialise the configuration
		$this->configuration = $configuration;
		
		// Initialise the rawdata entity manager
		$this->entityManager = $entityManager;
		
		$this->integrationService = $integrationService ;
		
		$this->metadataReader = $metadataReader ;
	}
	
	
	/**
	 * Valide un JDD :
	 *   - supprime les soumissions en erreur
	 *   - prend le statut "Publié"
	 * @param Jdd $jdd
	 * @throws \Exception
	 */
	public function validateJdd(Jdd $jdd) {
		
		$this->logger->info("Validating jdd {$jdd->getId()}") ;
		
		$submissions = $jdd->getSubmissions() ;
		
		if ($jdd->hasRunningSubmissions()) {
			throw new \Exception("Can't publish JDD because of running submissions.") ;
		}
		
		$validatedSubmissions = [] ;
		
		try {
			
			foreach ($submissions as $submission) {

				if ($submission->isInError()) {
					$this->integrationService->cancelDataSubmission($submission) ;
					continue ;
				}

				if (!$submission->isActive()) {
					continue ;
				}

				if ($submission->isSuccessful()) {
					$this->integrationService->validateDataSubmission($submission) ;
					$validatedSubmissions[] = $submission ;
				}
			}

			if (count($validatedSubmissions) > 0) {
				$jdd->setStatus(Jdd::STATUS_VALIDATED) ;
			}

			$this->entityManager->flush() ;
		
		} catch (\Exception $e) {
			
			$this->logger->error("Error while validating JDD {$jdd->getId()}") ;
			// En cas d'erreur (souvent un timeout du serveur de BDD) on dépublie les soumissions déjà publiées, pour éviter les états incohérents.
			foreach ($validatedSubmissions as $submission) {
				$this->integrationService->invalidateDataSubmission($submission) ;
			}
		}
	}
	
	
	/**
	 * Invalide un JDD
	 * @param Jdd $jdd
	 */
	public function invalidateJdd(Jdd $jdd) {
		
		$this->logger->info("Invalidating jdd {$jdd->getId()}") ;
		
		$submissions = $jdd->getSubmissions() ;
		
		if ($jdd->hasRunningSubmissions()) {
			throw new \Exception("Can't publish JDD because of running submissions.") ;
		}
		
		$invalidatedSubmissions = [] ;
		
		try {
		
			foreach ($submissions as $submission) {

				if ($submission->isValidated()) {
					$this->integrationService->invalidateDataSubmission($submission) ;
					$invalidatedSubmissions[] = $submission ;
				}	
			}

			$jdd->setStatus(Jdd::STATUS_ACTIVE) ;

			$this->entityManager->flush() ;
		
		} catch (\Exception $e) {
			
			$this->logger->error("Error while invalidating JDD {$jdd->getId()}") ;
			// En cas d'erreur (souvent timeout du serveur de BDD), on republie les soumissions déjà dépubliées pour éviter les états incohérents.
			foreach ($invalidatedSubmissions as $submission) {
				$this->integrationService->validateDataSubmission($submission) ;
			}
		}
		
	}
	
	
	/**
	 * Teste si le JDD est supprimable, en vérifiant les DEE associés.
	 * @param Jdd $jdd
	 * @return boolean
	 */
	public function isDeletable(Jdd $jdd) {
		
		// Basic deletability: Jdd has no active submissions
		if (!$jdd->isDeletable()) {
			return false;
		}

		// Do the jdd has an active DEE ?
		$deeRepo = $this->entityManager->getRepository('IgnGincoBundle:RawData\DEE');
		// Get last version of DEE attached to the jdd
		$DEE = $deeRepo->findLastVersionByJdd($jdd);
		if ($DEE && $DEE->getStatus() != DEE::STATUS_DELETED) {
			return false;
		}
		return true;
	}
	
	
	/**
	 * Met à jour les champs associés au JDD.
	 * @param Jdd $jdd
	 */
	public function updateMetadataFields(Jdd $jdd) {
		
		$metadataId = $jdd->getField('metadataId') ;
		if (!$metadataId) {
			return ;
		}
		
		$fields = $this->metadataReader->getMetadata($metadataId) ;
		foreach ($fields as $key => $value) {
			$jdd->setField($key, $value);
		}
		
		$this->entityManager->flush() ;
	}
}
