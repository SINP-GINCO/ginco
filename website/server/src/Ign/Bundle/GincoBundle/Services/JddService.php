<?php

namespace Ign\Bundle\GincoBundle\Services;

use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Entity\RawData\Submission;
use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Services\Integration;

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
	 */
	protected $configuration;

	/**
	 *
	 * @var Doctrine entity manager 
	 */
	protected $entityManager;
	
	/**
	 *
	 * @var Integration
	 */
	protected $integrationService ;


	/**
	 *
	 * @var translator
	 */
	protected $translator;

	function __construct($logger, $configuration, $entityManager, $integrationService) {
		// Initialise the logger
		$this->logger = $logger;
		
		// Initialise the configuration
		$this->configuration = $configuration;
		
		// Initialise the rawdata entity manager
		$this->entityManager = $entityManager;
		
		$this->integrationService = $integrationService ;
	}
	
	
	/**
	 * Valide un JDD :
	 *   - supprime les soumissions en erreur
	 *   - prend le statut "Publié" ou "Partiellement publié" en fonction du statut des soumissions.
	 * @param Jdd $jdd
	 * @throws \Exception
	 */
	public function validateJdd(Jdd $jdd) {
		
		$this->logger->debug("Validating jdd {$jdd->getId()}") ;
		
		$submissions = $jdd->getSubmissions() ;
		
		if ($jdd->hasRunningSubmissions()) {
			throw new \Exception("Can't publish JDD because of running submissions.") ;
		}
		
		$validatedSubmissions = 0 ;
		$notValidatedSubmissons = 0 ;
		foreach ($submissions as $submission) {
			
			if ($submission->isInError()) {
				$this->integrationService->cancelDataSubmission($submission) ;
				continue ;
			}
			
			if (!$submission->isActive()) {
				continue ;
			}
			
			if ($submission->isValidated()) {
				$validatedSubmissions++ ;
			} else {
				$notValidatedSubmissons++ ;
			}
		}
		
		if ($validatedSubmissions > 0 && $notValidatedSubmissons == 0) {
			$jdd->setStatus(Jdd::STATUS_VALIDATED) ;
		} else if ($validatedSubmissions > 0 && $notValidatedSubmissons > 0) {
			$jdd->setStatus(Jdd::STATUS_PARTIALLY_VALIDATED) ;
		} else {
			$jdd->setValidationStatus(Jdd::VALIDATION_STATUS_NOT_VALIDATED) ;
		}
		
		$this->entityManager->flush() ;
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
}
