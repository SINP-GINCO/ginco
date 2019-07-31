<?php

namespace Ign\Bundle\GincoBundle\Services\DEEGeneration;

use Symfony\Bridge\Monolog\Logger;

use Doctrine\ORM\EntityManagerInterface ;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
use Ign\Bundle\GincoBundle\Services\GenericService;
use Ign\Bundle\GincoBundle\Services\QueryService;


/**
 * Description of AbstractDEEGenerator
 *
 * @author rpas
 */
abstract class AbstractDEEGenerator {
	//put your code here
	
	/**
	 * @var Logger
	 */
	protected $logger;


	/**
	 * @var ConfigurationManager
	 */
	protected $configuration;

	/**
	 * The models.
	 *
	 * @var EntityManagerInterface
	 */
	protected $em;

	/**
	 *
	 * @var GenericService
	 */
	protected $genericService;

	/**
	 *
	 * @var QueryService
	 */
	protected $queryService;
	
	
	/**
	 * 
	 * @param type $em
	 * @param type $configuration
	 * @param type $genericService
	 * @param type $queryService
	 * @param type $logger
	 */
	public function __construct($em, $configuration, $genericService, $queryService, $logger) {

		$this->em = $em;
		$this->configuration = $configuration;
		$this->genericService = $genericService;
		$this->queryService = $queryService;		
		$this->logger = $logger;
	}
	
	
	abstract public function generateDee(DEE $dee, $filePath, Message $message = null) ;
}
