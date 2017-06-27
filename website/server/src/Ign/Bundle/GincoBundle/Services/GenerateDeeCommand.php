<?php
namespace Ign\Bundle\GincoBundle\Services;

use OldSound\RabbitMqBundle\RabbitMq\ConsumerInterface;
use PhpAmqpLib\Message\AMQPMessage;
use Ign\Bundle\GincoBundle\GMLExport\GMLExport;

//class GenerateDeeCommand implements ConsumerInterface {
class GenerateDeeCommand {
	
	/**
	 * The logger.
	 *
	 * @var Logger
	 */
	protected $logger;
	
	/**
	 * The locale.
	 *
	 * @var locale
	 */
	protected $locale;

	/**
	 * The models.
	 * 
	 * @var EntityManager
	 */
	protected $rawDataModel;
	
	/**
	 *
	 * @var ConfigurationManager
	 */
	protected $configuration;
	
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
	 * @var \Twig_Environment
	 */
	protected $twig;
	
	// Init:
	public function __construct($em, $emm, $configuration, $logger, $locale, $genericService, $queryService) {
		// Initialise the logger
		$this->logger = $logger;
		
		// Initialise the locale
		$this->locale = $locale;
		
		// Initialise the metadata models
		$this->rawDataModel = $em;
		$this->metadataModel = $emm;
		
		$this->configuration = $configuration;
		
		$this->genericService = $genericService;

		$this->queryService = $queryService;

		echo "GenerateDeeCommand consumer is listening...";
	}
//	public function execute(AMQPMessage $msg) {
	public function execute($msg) {
		// Getting here means the picture has successfully been uploaded.
		// Now we can proceed with the rest of the operations.
		// $message will be an instance of `PhpAmqpLib\Message\AMQPMessage`.
		// The $message->body contains the data sent over RabbitMQ.
		try {
 			//$decodedData = unserialize($msg->body);
 			$decodedData = unserialize($msg);
 			//TODO : add if for null values
 			$command = $decodedData['command'];
 			$jddId = $decodedData['jdd_id'];
 			$fileName = $decodedData['filePath'];
			$userLogin = $decodedData['user_login'];
			$deeAction = $decodedData['dee_action'];
			$comment = $decodedData['comment'];
			
 			echo $command;
			echo $jddId;
			echo $fileName;
			echo $userLogin;
			echo $deeAction;
			echo $comment;

			// Generate DEE
			
			// Configure memory and time limit because the program ask a lot of resources
// 			$configuration = $this->get("ogam.configuration_manager");
// 			ini_set("memory_limit", $configuration->getConfig('memory_limit', '1024M'));
// 			ini_set("max_execution_time", 0); // Not really useful because the script is used in CLI (max_execution_time is already 0)
			
// 			// Initialise the logger
// 			//$logger = Zend_Registry::get("logger");
// 			$logger->debug("generateDEE launched...");
			
// 			// Initialise the job manager
// 			$jm = new Application_Service_JobManagerService();
			
// 			// Options from the command line :
// 			// m : jdd_id
// 			// f : file name to write
// 			// u : user_login for e-mail
// 			// y : is dee yet existing ? update : create
// 			// c : user comment
// 			// j (optional) : job id in the job queue
// 			$options = getopt("j::m:f:u:y:c:");
			
// 			// Get the jddId
// 			$jddId = intval($options['m']);
			
// 			// Get the filename
// 			$fileName = $options['f'];
			
// 			// Get the user_login
// 			$userLogin = $options['u'];
			
// 			// Get is dee yet created
// 			$deeAction = $options['y'];
// 			$logger->debug("GML created for jdd deeAction:" . $deeAction);
			
// 			// Get comment
// 			$comment = $options['c'];
// 			$logger->debug("GML created for jdd comment:" . $comment);
			
// 			// Get the job id (in the job queue)
// 			$jobId = isset($options['j']) ? $options['j'] : null;
			$jobId = null;
			
			// Generate DEE GML
			$gml = new GMLExport($this->logger, $this->locale, $this->configuration, $this->rawDataModel, $this->metadataModel, $this->genericService, $this->queryService);
			$dateCreated = time();
			$gml->generateDeeGml($jddId, $fileName, $jobId, $userLogin);
			$this->logger->debug("GML created for jdd $jddId: $fileName");
			
			// Create the archive and put it in the DEE download directory
// 			$archivePath = $gml->createArchiveDeeGml($jddId, $fileName, $comment);
// 			$logger->debug("GML Archive created for jdd $jddId: $archivePath");
			
// 			// Send notification emails to the user and to the MNHN
// 			$gml->sendDEENotificationMail($jddId, $archivePath, $dateCreated, $userLogin, $deeAction, $comment);
// 			$logger->debug("GML Notification mail sent");
			
// 			if ($jobId) {
// 				$jm->setJobCompleted($jobId);
// 			}
			
// 			// Sleep a little time after complete, to avoid being seen as "aborted"
// 			sleep(2);
// 			$logger->debug("End of generateDEE.");

		} catch (\Exception $e) {
			// If any of the above fails due to temporary failure, return false,
			// which will re-queue the current message.
			echo 'échec...';
			return false;
		}
		// Any other return value means the operation was successful and the
		// message can safely be removed from the queue.
		return true;
	}
}