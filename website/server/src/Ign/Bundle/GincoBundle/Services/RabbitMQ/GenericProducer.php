<?php

namespace Ign\Bundle\GincoBundle\Services\RabbitMQ;

use Doctrine\ORM\EntityManager;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use OldSound\RabbitMqBundle\RabbitMq\Producer;

/**
 * Customised Producer, that publishes AMQP Messages
 * but also:
 * - writes an entry in the Message table
 */
class GenericProducer extends Producer
{
	/**
	 * @var Producer
	 */
	protected $producer;

	/**
	 * @var EntityManager
	 */
	protected $em;

	/**
	 * GenericProducer constructor.
	 * @param Producer $producer
	 * @param EntityManager $entityManager
	 */
	public function __construct(Producer $producer, EntityManager $entityManager)
	{
		$this->producer = $producer;
		$this->em = $entityManager;
	}

	/**
	 * Publishes the message and merges additional properties with basic properties
	 * And also:
	 * - writes an entry in the Message table
	 *
	 * @param string $action
	 * @param array $parameters
	 * @param string $routingKey
	 * @param array $additionalProperties
	 * @param array|null $headers
	 */
    public function publish($action, $parameters = array() , $routingKey = '', $additionalProperties = array(), array $headers = null)
	{
		$message = new Message();
		$message->setAction($action)
			->setParameters($parameters);
		$this->em->persist($message);
		$this->em->flush();

		$msgBody = array(
			'action' => $action,
			'parameters' => $parameters,
			'message_id' => $message->getId(),
		);
		$this->producer->publish(serialize($msgBody), $routingKey, $additionalProperties, $headers);

		return $message->getId();
	}
}