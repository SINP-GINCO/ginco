<?php
namespace Ign\Bundle\GincoBundle\Services;

use OldSound\RabbitMqBundle\RabbitMq\ConsumerInterface;
use PhpAmqpLib\Message\AMQPMessage;
use Ign\Bundle\GincoBundle\GMLExport\GMLExport;

class GenericConsumer implements ConsumerInterface {

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
	 * The entity manager.
	 *
	 */
	protected $em;
	
	/**
	 * Configuration Manager
	 */
	protected $configuration;

	/**
	 *
	 * @var GenericService
	protected $genericService;

	/**
	 *
	 * @var QueryService
	protected $queryService;
	 */


	public function __construct($em, $configuration, $logger, $locale) {
		// Initialise the logger
		$this->logger = $logger;
		
		// Initialise the locale
		$this->locale = $locale;
		
		// Initialise the entity manager
		$this->em = $em;
		
		$this->configuration = $configuration;

		echo "GenericConsumer is listening...";
	}

	public function execute(AMQPMessage $msg) {
		// $message will be an instance of `PhpAmqpLib\Message\AMQPMessage`.
		// The $message->body contains the data sent over RabbitMQ.
		echo "Getting new message !\n";

		try {
 			$data = unserialize($msg->body);
			$action = $data['action'];
			$parameters = $data['parameters'];

			echo "Received message '$action'.\n";

			switch ($action) {
				case 'wait':
					for ($i=0; $i<$parameters['time']; $i++) {
						sleep(1);
						echo '.';
					}
					echo "finished\n";
			}

 			// $decodedData = unserialize($msg);

			/*
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

// 			$logger->debug("generateDEE launched...");

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
*/
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