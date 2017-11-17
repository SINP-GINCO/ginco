<?php
namespace Ign\Bundle\GincoBundle\Controller;


use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Exception\DEEException;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;

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
		$deeProcess = $this->get('ginco.dee_process');

		// Create a line in the DEE table
		$newDEE = $deeProcess->createDEELine($jdd, $this->getUser(), 'commentaire');
		$deeProcess->generateAndSendDEE($newDEE->getId());

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

		// Create a line in the DEE table
		$newDEE = $this->get('ginco.dee_process')->createDEELine($jdd, $this->getUser(), $comment);

		// Publish the message to RabbitMQ
		$messageId = $this->get('old_sound_rabbit_mq.ginco_generic_producer')->publish('deeProcess', [
					'DEEId' => $newDEE->getId(),
				]
		);
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

		// If DEE generation is still PENDING, we remove the DEE line now
		if ($message->getStatus() == Message::STATUS_PENDING) {
			$em->remove($lastDEE);
			$em->flush();
		}

		// For the message, we update his status to: TO CANCEL
		$message->setStatus(Message::STATUS_TOCANCEL);
		$em->flush();

		return new JsonResponse($this->getStatus($jddId, $lastDEE));
	}

	/**
	 * Delete the DEE for a Jdd
	 * i.e. create a new DEE version with status 'DELETED'.
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
			->setComment($comment)
			->setUser($this->getUser());
		$em->persist($newDEE);
		$em->flush();

		// Send notification mail to INPN
		$this->get('ginco.dee_process')->sendDEENotificationMail($newDEE);

		return new JsonResponse($this->getStatus($jddId, $newDEE));
	}


	/**
	 * Download the zip archive of a DEE for a jdd
	 * Note: direct downloading is prohibited by apache configuration, except for a list of IPs
	 *
	 * @param DEE $DEE
	 * @return BinaryFileResponse
	 * @throws DEEException
	 *
	 * @Route("/{id}/download", name = "dee_download", requirements={"id": "\d+"})
	 */
	public function downloadDEE(DEE $DEE)
	{
		// Get archive
		$archivePath = $DEE->getFilePath();
		if (!$archivePath) {
			throw new DEEException("No archive file path for this DEE: " . $DEE->getId());
		}

		// tests the existence of the zip file
		$fileName = pathinfo($archivePath, PATHINFO_BASENAME);
		$archiveFilePath =  $this->get('ogam.configuration_manager')->getConfig('deePublicDirectory') . '/' . $fileName;
		if (!is_file( $archiveFilePath )) {
			throw new DEEException("DEE archive file does not exist for this DEE: " . $DEE->getId());
		}

		// -- Get back the file
		$response = new BinaryFileResponse($archiveFilePath);
		$response->setContentDisposition(
			ResponseHeaderBag::DISPOSITION_ATTACHMENT,
			$fileName
		);
		return $response;
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
			// Do the JDD has validated submissions ?
			// If yes, the DEE can be generated
			$json['canGenerateDEE'] =  $jdd->getValidatedSubmissions()->count() > 0;

			if (!$DEE) {
				// Get last version of DEE attached to the jdd
				$DEE = $deeRepo->findLastVersionByJdd($jdd);
			}

			if (!$DEE) {
				$json['dee'] = array(
					'status' => DEE::STATUS_NO_DEE,
					'fullCreated' => new \DateTime("1970-01-01T00:00:00+01:00")
				);
			}
			else {
				$json['dee'] = array(
					'id' => $DEE->getId(),
					'status' => $DEE->getStatus(),
					'created' => $DEE->getCreatedAt()->format('d/m/Y H:i'),
					'fullCreated' => $DEE->getCreatedAt(),
					'comment' => $DEE->getComment(),
				);
				// DEE action : creation or update
				if ($DEE->getStatus() == DEE::STATUS_DELETED) {
					$action = 'Suppression';
				} else if ($DEE->getVersion() == 1) {
					$action = 'Création';
				} else {
					$previousDEE = $em->getRepository('IgnGincoBundle:RawData\DEE')->findOneBy(array(
							'jdd' => $jdd,
							'version' => $DEE->getVersion() - 1
						)
					);
					$action = ($previousDEE->getStatus() == DEE::STATUS_DELETED) ? 'Création' : 'Mise à jour';
				}
				$json['dee']['action'] = $action;

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