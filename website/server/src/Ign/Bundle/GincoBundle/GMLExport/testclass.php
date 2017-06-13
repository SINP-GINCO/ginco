<?php
namespace Ign\Bundle\GincoBundle\GMLExport;

use OldSound\RabbitMqBundle\RabbitMq\ConsumerInterface;
use PhpAmqpLib\Message\AMQPMessage;

class testclass implements ConsumerInterface
{
	private $logger; // Monolog-logger.

	// Init:
	public function __construct( $logger )
	{
		$this->logger = $logger;
		echo "testclass is listening...";
	}

	public function execute(AMQPMessage $msg)
	{
		$message = unserialize($msg->body);
		$userid = $message['user_id'];
		echo $userid;
	}
}