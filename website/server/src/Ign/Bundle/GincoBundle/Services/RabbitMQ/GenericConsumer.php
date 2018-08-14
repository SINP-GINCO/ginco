<?php
namespace Ign\Bundle\GincoBundle\Services\RabbitMQ;

use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Services\DEEGeneration\DEEProcess;
use Ign\Bundle\GincoBundle\Services\ExportCSV;
use OldSound\RabbitMqBundle\RabbitMq\ConsumerInterface;
use PhpAmqpLib\Message\AMQPMessage;

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
	 */
	protected $em;

	/**
	 * Configuration Manager
	 */
	protected $configuration;

	protected $DEEProcess;

	protected $exportCSV;

	public function __construct($em, $configuration, $logger, $locale) {
		// Initialise the logger
		$this->logger = $logger;
		// Initialise the locale
		$this->locale = $locale;
		// Initialise the entity manager
		$this->em = $em;
		$this->configuration = $configuration;
		
		echo "---\n";
		echo $this->datelog() . "New GenericConsumer is listening...\n";
	}

	public function setDEEProcess(DEEProcess $DEEProcess) {
		$this->DEEProcess = $DEEProcess;
	}

	public function setExportCSV(ExportCSV $exportCSV) {
		$this->exportCSV = $exportCSV;
	}

	/**
	 * Date string to prepend outputs (sent to log file)
	 */
	protected function datelog() {
		return date("Y-m-d H:i:s") . ": ";
	}

	/**
	 * Executed when a new message is received
	 *
	 * @param AMQPMessage $msg        	
	 * @return bool
	 */
	public function execute(AMQPMessage $msg) {
		// $message will be an instance of `PhpAmqpLib\Message\AMQPMessage`.
		// The $message->body contains the data sent over RabbitMQ.
		echo $this->datelog() . "Getting new message !\n";
		
		try {
			$data = unserialize($msg->body);
			// Get action and parameters
			$action = $data['action'];
			$parameters = $data['parameters'];
			
			// Get Message entity;
			$messageId = $data['message_id']; // Message id in messages table
			echo $messageId;
			$message = $this->em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId);
			if (!$message) {
				echo $this->datelog() . "Received non existant message id $messageId.\n" ;
				return false ;
			}
			echo $this->datelog() . "Received message $messageId with action '$action' and status " . $message->getStatus() . ".\n";
			
			switch ($message->getStatus()) {
				
				// if TO CANCEL, mark it CANCELLED, terminate tasks properly, and discard the message
				case Message::STATUS_TOCANCEL:
					$message->setStatus(Message::STATUS_CANCELLED);
					$this->em->flush();
					$this->onCancel($action, $parameters, $message);
					break;
				
				// if ERROR (the previous try exited with an ERROR status),
				// terminate tasks properly, and discard the message
				case Message::STATUS_ERROR:
					$this->onError($action, $parameters, $message);
					break;
				
				// if PENDING mark it as runnning...
				case Message::STATUS_PENDING:
					$message->setStatus(Message::STATUS_RUNNING);
					$this->em->flush();
				// ... and continue to RUNNING case
				
				// Perform task
				case Message::STATUS_RUNNING:
					$this->onRunning($action, $parameters, $message);
					break;
				
				default:
					// Any other status will lead to the further "return true;" and the message will be discarded
					// (for example, if message is resend with "COMPLETED" status, this way it is not stuck.
					echo $this->datelog() . " !!! Message status not catched : " . $message->getStatus() . "\n";
			}
		} catch (\Exception $e) {
			// If any of the above fails due to temporary failure, or uncaught exception,
			// increment number of tries,
			// and if max retries is not reached, set the message status to ERROR,
			// return false, which will re-queue the current message.
			echo $this->datelog() . "Error : " . $e->getMessage() . "\n\n";
			echo $e->getTraceAsString();
			echo "\n";
			
			if ($message) {
				$retry = $message->retry();
				if (!$retry) {
					$message->setStatus(Message::STATUS_ERROR);
					echo $this->datelog() . "!!! Max number of tries reached; set message in ERROR status. See previous logs for errors !!!\n";
				}
				$this->em->flush();
				
				// Requeue the message in both cases
				// (the ERROR case will be handled by the switch next time the message is received)
				return false;
			}
		}
		// Any other return value means the operation was successful and the
		// message can safely be removed from the queue.
		return true;
	}

	/**
	 * Specific code to execute when receiving a message with CANCEL or TO_CANCEL status
	 *
	 * @param
	 *        	$action
	 * @param null $parameters        	
	 * @param null $message        	
	 */
	protected function onCancel($action, $parameters = null, $message = null) {
		switch ($action) {
			// -- DEE generation: delete DEE line
			case 'deeProcess':
				// Nothing to do, we deleted the DEE line in the controller
				echo $this->datelog() . "Message cancelled... DEE already deleted.\n";
				break;
			default:
				echo $this->datelog() . "Message cancelled... discard it.\n";
		}
	}

	/**
	 * Specific code to execute when receiving a message with ERROR status
	 *
	 * @param
	 *        	$action
	 * @param null $parameters        	
	 * @param null $message        	
	 */
	protected function onError($action, $parameters = null, $message = null) {
		switch ($action) {
			// -- DEE generation: delete DEE line
			case 'deeProcess':
				$this->DEEProcess->deleteDEELineAndFiles($parameters['DEEId']);
				echo $this->datelog() . "Message in ERROR... DEE deleted.\n";
				break;
			default:
				echo $this->datelog() . "Message in ERROR... discard it.\n";
		}
	}

	/**
	 * Specific code to execute when receiving a message with RUNNING or PENDING status
	 *
	 * @param
	 *        	$action
	 * @param null $parameters        	
	 * @param null $message        	
	 */
	protected function onRunning($action, $parameters = null, $message = null) {
		switch ($action) {
			
			// -- Dummy action just to illustrate the process
			//
			case 'wait':
				$message->setLength($parameters['time']);
				$message->setProgress(0);
				$this->em->flush();
				
				for ($i = 0; $i < $parameters['time']; $i ++) {
					
					// Check if message has been cancelled externally
					$this->em->refresh($message);
					if ($message->getStatus() == Message::STATUS_TOCANCEL) {
						$message->setStatus(Message::STATUS_CANCELLED);
						$this->em->flush();
						echo $this->datelog() . "Message cancelled... stop waiting.\n";
						return true;
					}
					
					sleep(1);
					echo '.';
					$message->setProgress($i + 1);
					$this->em->flush();
				}
				$message->setStatus(Message::STATUS_COMPLETED);
				$this->em->flush();
				echo $this->datelog() . "finished\n";
				break;
			
			// -- DEE generation, archive creation and notifications
			//
			case 'deeProcess':
				
				sleep(1); // let the time to the application to update message before starting
				$this->DEEProcess->generateAndSendDEE($parameters['DEEId'], $message->getId());
				if ($message->getStatus() == Message::STATUS_RUNNING) {
					$message->setStatus(Message::STATUS_COMPLETED);
				}
				$this->em->flush();
				echo $this->datelog() . "DEE Process finished\n";
				break;
			
			// -- Export generation, archive creation and notifications
			//
			case 'exportCSV':
				
				sleep(1); // let the time to the application to update message before starting
				$request = $parameters['request'];
				$userInfos = $parameters['userInfos'];
				
				$this->exportCSV->generateCSV($request, $userInfos, $message);
				
				if ($message->getStatus() == Message::STATUS_RUNNING) {
					$message->setStatus(Message::STATUS_COMPLETED);
				}
				$this->em->flush();
				echo $this->datelog() . "Export Process finished\n";
				break;
		}
	}
}