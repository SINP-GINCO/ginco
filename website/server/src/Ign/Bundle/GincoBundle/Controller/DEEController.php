<?php
namespace Ign\Bundle\GincoBundle\Controller;


use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

/**
 * @Route("/dee")
 */
class DEEController extends Controller
{
	/**
	 * DEE generation action
	 * Publish a RabbitMQ message to generate the DEE in background
	 *
	 * @param Request $request
	 * @return JsonResponse
	 *
	 * GET parameter: jddId, the Jdd identifier
	 *
	 * @Route("/generate", name = "dee_generate")
	 */
	public function generateDEE(Request $request)
	{
		$em = $this->get('doctrine.orm.entity_manager');

		// Find jddId if given in GET parameters
		$jddId = intval($request->query->get('jddId', 0));
		$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);
		if (!$jdd) {
			return new JsonResponse(['success' => false, 'message' => 'No jdd found for this id: ' . $jddId]);
		}

		// Dummy action; todo change by real action
		$messageId = $this->get('old_sound_rabbit_mq.ginco_generic_producer')->publish('wait', ['time' => 20]);

		// Attach message id to the jdd
		$jdd->setField('DEEgenerationMessageId', $messageId);
		$em->flush();

		return new JsonResponse([
			'success' => true,
			'status' => 'PENDING'
		]);
	}

	/**
	 * Cancel DEE generation
	 * Sets the status of the RabbitMQ Message to 'TO CANCEL';
	 * the consumer must handle it and terminate the task in a 'cancel' way.
	 *
	 * @param Request $request
	 * @return JsonResponse
	 *
	 * GET parameter: jddId, the Jdd identifier
	 *
	 * @Route("/cancel", name = "dee_cancel_generation")
	 */
	public function cancelDEEGeneration(Request $request)
	{
		$em = $this->get('doctrine.orm.entity_manager');

		// Find jddId if given in GET parameters
		$jddId = intval($request->query->get('jddId', 0));
		$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);
		if (!$jdd) {
			return new JsonResponse(['success' => false, 'message' => 'No jdd found for this id: ' . $jddId]);
		}

		// Get RabbitMQ message attached to the jdd
		$messageId = intval($jdd->getField('DEEgenerationMessageId'));
		$message =  $em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId);
		if (!$message) {
			return new JsonResponse(['success' => false, 'message' => 'No message found for this jdd: ' . $jddId]);
		}

		// We got a message, we update his status to: TO CANCEL
		$message->setStatus(Message::STATUS_TOCANCEL);
		$em->flush();

		return new JsonResponse(['success' => true]);
	}

	/**
	 * DEE generation - get status of the background task
	 *
	 * @param Request $request
	 * @return JsonResponse
	 *
	 * GET parameter: jddId, the Jdd identifier
	 *
	 * @Route("/status", name = "dee_status")
	 */
	public function getDEEStatus(Request $request)
	{
		$em = $this->get('doctrine.orm.entity_manager');

		$return = array();

		// Find jddId if given in GET parameters
		$jddId = intval($request->query->get('jddId', 0));
		$return['jddId'] = $jddId;

		$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);
		if (!$jdd) {
			$return['status'] = Message::STATUS_NOTFOUND;
			$return['error_message'] = 'No jdd found';
			return new JsonResponse($return);
		}
		// Get RabbitMQ message attached to the jdd
		$messageId = intval($jdd->getField('DEEgenerationMessageId'));
		$message =  $em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId);
		if (!$message) {
			$return['status'] = Message::STATUS_NOTFOUND;
			$return['error_message'] = 'No message found for this jdd';
			return new JsonResponse($return);
		}

		// We got a message, just send back the infos
		$return['status'] = $message->getStatus();
		$return['progress'] = $message->getProgressPercentage();
		return new JsonResponse($return);
	}

	/**
	 * DEE generation - get status of a set of background task
	 *
	 * @param Request $request
	 * @return JsonResponse
	 *
	 * GET parameter: jddIds, an array of Jdd identifiers
	 *
	 * @Route("/status/all", name = "dee_status_all")
	 */
	public function getDEEStatusAll(Request $request)
	{
		$em = $this->get('doctrine.orm.entity_manager');

		// Find jddIds if given in GET parameters
		$jddIds = $request->query->get('jddIds', []);

		$return = array();

		foreach ($jddIds as $jddId ) {
			$part = array();
			$part['jddId'] = $jddId;

			$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);
			if (!$jdd) {
				$part['status'] = Message::STATUS_NOTFOUND;
			}
			else {
				// Get RabbitMQ message attached to the jdd
				$messageId = intval($jdd->getField('DEEgenerationMessageId'));
				$message = $em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId);
				if (!$message) {
					$part['status'] = Message::STATUS_NOTFOUND;
				}
				else {
					// We got a message, just send back the infos
					$part['status'] = $message->getStatus();
					$part['progress'] = $message->getProgressPercentage();
				}
			}
			$return[] = $part;
		}
		return new JsonResponse($return);
	}
}