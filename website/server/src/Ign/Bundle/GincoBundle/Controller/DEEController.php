<?php
namespace Ign\Bundle\GincoBundle\Controller;


use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
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
	 * Direct generation of DEE (for testing)
	 *
	 * @Route("/{id}/generate", name = "dee_direct", requirements={"id": "\d+"})
	 */
	public function directDEEAction(Jdd $jdd) {
		$deeGenerator = $this->get('ginco.dee_generator');

		$deeGenerator->generateDeeGml($jdd->getId(), '/tmp/dee.gml');

		return $this->redirect($this->generateUrl('integration_home'));
	}


	/**
	 * DEE generation action
	 * Create a 'DEE' line and
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

		// Get comment in GET parameters
		$comment = $request->query->get('comment', '');

		// Get last version of DEE attached to the jdd
		$deeRepo = $em->getRepository('IgnGincoBundle:RawData\DEE');
		$lastDEE = $deeRepo->findLastVersionByJdd($jdd);
		$lastVersion = ($lastDEE) ? $lastDEE->getVersion() : 0;

		// Create a new DEE version and attach it to the jdd
		$newDEE = new DEE();
		$newDEE->setJdd($jdd)
			->setVersion($lastVersion + 1)
			->setComment($comment);
		//	->setUser(TODO);
		$em->persist($newDEE);
		$em->flush();

		// Dummy action; todo change by real action
		$messageId = $this->get('old_sound_rabbit_mq.ginco_generic_producer')->publish('dee', ['deeId' => $newDEE->getId(),'time' => 5]);

		$message = $em->getRepository('IgnGincoBundle:Website\Message')->findOneById($messageId);

		// Attach message id to the DEE
		$newDEE->setMessage($message);
		$em->flush();

		return new JsonResponse($this->getStatus($jddId, $newDEE));
	}

	/**
	 * Cancel DEE generation
	 * Delete the 'DEE' line and
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

		// Get DEE and RabbitMQ message attached to the jdd
		$deeRepo = $em->getRepository('IgnGincoBundle:RawData\DEE');
		$lastDEE = $deeRepo->findLastVersionByJdd($jdd);
		if ($lastDEE) {
			$message = $lastDEE->getMessage();
		}
		if (!$message) {
			return new JsonResponse(['success' => false, 'message' => 'No message found for this jdd: ' . $jddId]);
		}

		// We just delete the DEE version from the database
		$em->remove($lastDEE);

		// For the message, we update his status to: TO CANCEL
		$message->setStatus(Message::STATUS_TOCANCEL);
		$em->flush();

		return new JsonResponse($this->getStatus($jddId, $lastDEE));
	}

	/**
	 * Delete the DEE for a Jdd
	 * i.e. create a new DEE version with status 'DELETED'.
	 *
	 * TODO: send email to INPN
	 *
	 * @param Request $request
	 * @return JsonResponse
	 *
	 * GET parameter: jddId, the Jdd identifier
	 *
	 * @Route("/delete", name = "dee_delete")
	 */
	public function deleteDEE(Request $request)
	{
		$em = $this->get('doctrine.orm.entity_manager');

		// Find jddId if given in GET parameters
		$jddId = intval($request->query->get('jddId', 0));
		$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);
		if (!$jdd) {
			return new JsonResponse(['success' => false, 'message' => 'No jdd found for this id: ' . $jddId]);
		}

		// Get comment in GET parameters
		$comment = $request->query->get('comment', '');

		$deeRepo = $em->getRepository('IgnGincoBundle:RawData\DEE');
		$lastDEE = $deeRepo->findLastVersionByJdd($jdd);
		$lastVersion = ($lastDEE) ? $lastDEE->getVersion() : 0;

		// Create a new DEE version with status DELETED and attach it to the jdd
		$newDEE = new DEE();
		$newDEE->setJdd($jdd)
			->setVersion($lastVersion + 1)
			->setStatus(DEE::STATUS_DELETED)
			->setComment($comment);
		//	->setUser(TODO);
		$em->persist($newDEE);
		$em->flush();

		return new JsonResponse($this->getStatus($jddId, $newDEE));
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
		// Find jddId if given in GET parameters
		$jddId = intval($request->query->get('jddId', 0));

		return new JsonResponse($this->getStatus($jddId));
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
		// Find jddIds if given in GET parameters
		$jddIds = $request->query->get('jddIds', []);

		$json = array();
		foreach ($jddIds as $jddId ) {
			$json[] = $this->getStatus($jddId);
		}

		return new JsonResponse($json);
	}

	/**
	 * Returns a json array with informations about the DEE generation process
	 * This is the expected return of all DEE Ajax actions on the Jdd pages
	 *
	 * @param $jddId
	 * @param DEE|null $DEE
	 * @return array
	 */
	protected function getStatus($jddId, DEE $DEE = null) {

		$em = $this->get('doctrine.orm.entity_manager');
		$jddRepo = $em->getRepository('OGAMBundle:RawData\Jdd');
		$deeRepo = $em->getRepository('IgnGincoBundle:RawData\DEE');

		// The returned informations
		$json = array(
			'jddId' => $jddId,
			'success' => true
		);

		$jdd = $jddRepo->findOneById($jddId);
		if (!$jdd) {
			$json['success'] = false;
			$json['error_message'] = 'No jdd found';
		}
		else {
			if (!$DEE) {
				// Get last version of DEE attached to the jdd
				$DEE = $deeRepo->findLastVersionByJdd($jdd);
			}

			if (!$DEE) {
				$json['dee'] = array(
					'status' => DEE::STATUS_NO_DEE
				);
			}
			else {
				$json['dee'] = array(
					'status' => $DEE->getStatus(),
					'downloadLink' => $DEE->getFilePath()
				);

				// Get message if DEE is GENERATING
				if ($DEE->getStatus() == DEE::STATUS_GENERATING) {
					$message = $DEE->getMessage();

					if (!$message) {
						$json['message'] = array(
							'status' => Message::STATUS_NOTFOUND,
							'error_message' => 'No message found for this dee',
						);
					}
					else {
						$json['message'] = array(
							'status' => $message->getStatus(),
							'progress' =>$message->getProgressPercentage(),
						);
					}
				}
			}
		}
		return $json;
	}

}