<?php
namespace Ign\Bundle\GincoBundle\Services\RabbitMQ;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Services\DEEGeneration\DEEProcess;
use OldSound\RabbitMqBundle\RabbitMq\ConsumerInterface;
use PhpAmqpLib\Message\AMQPMessage;
// use Ign\Bundle\GincoBundle\GMLExport\GMLExport;

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

	protected $DEEProcess;

	public function __construct($em, $configuration, $logger, $locale) {
		// Initialise the logger
		$this->logger = $logger;
		// Initialise the locale
		$this->locale = $locale;
		// Initialise the entity manager
		$this->em = $em;
		$this->configuration = $configuration;

		echo "GenericConsumer is listening...\n";
	}


	public function setDEEProcess(DEEProcess $DEEProcess) {
		$this->DEEProcess = $DEEProcess;
	}


	public function execute(AMQPMessage $msg) {
		// $message will be an instance of `PhpAmqpLib\Message\AMQPMessage`.
		// The $message->body contains the data sent over RabbitMQ.
		echo "Getting new message !\n";

		try {
 			$data = unserialize($msg->body);
			// Get action and parameters
			$action = $data['action'];
			$parameters = $data['parameters'];

			// Get Message entity;
			$messageId = $data['message_id']; // Message id in messages table
			$message = $this->em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId);
			echo "Received message $messageId with action '$action' and status ".$message->getStatus(). ".\n";

			// if PENDING mark it as runnning
			if ($message->getStatus() == Message::STATUS_PENDING) {
				$message->setStatus(Message::STATUS_RUNNING);
				$this->em->flush();
			}

			// if TO CANCEL, mark it CANCELLED, terminate tasks properly, and discard the message
			else if ($message->getStatus() == Message::STATUS_TOCANCEL) {
				$message->setStatus(Message::STATUS_CANCELLED);
				$this->em->flush();

				switch ($action) {
					// -- DEE generation: delete DEE line
					case 'deeProcess':
						// Nothing to do, we deleted the DEE line in the controller
						echo "Message cancelled... DEE deleted.\n";
						break;
					default:
						echo "Message cancelled... discard it.\n";
				}
				return true;
			}

			// Perform task
			switch ($action) {

				// -- Dummy action just to illustrate the process
				//
				case 'wait':
					$message->setLength($parameters['time']);
					$message->setProgress(0);
					$this->em->flush();

					for ($i=0; $i<$parameters['time']; $i++) {

						// Check if message has been cancelled externally
						$this->em->refresh($message);
						if ($message->getStatus() == Message::STATUS_TOCANCEL) {
							$message->setStatus(Message::STATUS_CANCELLED);
							$this->em->flush();
							echo "Message cancelled... stop waiting.\n";
							return true;
						}

						sleep(1);
						echo '.';
						$message->setProgress($i+1);
						$this->em->flush();
					}
					$message->setStatus(Message::STATUS_COMPLETED);
					$this->em->flush();
					echo "finished\n";
					break;

				// -- DEE generation, archive creation and notifications
				//
				case 'deeProcess':

					sleep(1); // let the time to the application to update message before starting
					$this->DEEProcess->generateAndSendDEE($parameters['DEEId'], $messageId);

					echo "DEE Process finished\n";
					break;
			}
		} catch (\Exception $e) {
			// If any of the above fails due to temporary failure, return false,
			// which will re-queue the current message.
			echo "Error : " . $e->getMessage() . "\n\n";
			echo $e->getTraceAsString();
			echo "\n";
			return false;
		}
		// Any other return value means the operation was successful and the
		// message can safely be removed from the queue.
		return true;
	}
}