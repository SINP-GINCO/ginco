<?php
namespace Ign\Bundle\OGAMBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Ign\Bundle\OGAMBundle\Entity\HarmonizedData\HarmonizationProcess;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

/**
 * @Route("/harmonization")
 *
 * @author FBourcier
 *
 */
class HarmonizationController extends Controller {

	/**
	 * @Route("/", name="harmonization_home")
	 */
	public function indexAction(Request $request) {
		return $this->showHarmonizationPageAction($request);
	}

	/**
	 * @Route("/show-harmonization-page", name="harmonization_dashboard")
	 */
	public function showHarmonizationPageAction(Request $request) {
		$activeSubmissions = $this->getDoctrine()
			->getRepository('OGAMBundle:RawData\Submission', 'raw_data')
			->getSubmissionsForHarmonization();
		$HarmoRepo = $this->getDoctrine()->getRepository('OGAMBundle:HarmonizedData\HarmonizationProcess', 'harmonized_data');
		$harmonisationProcesses = array();

		foreach ($activeSubmissions as $activeSubmission) {
			$criteria = new \Doctrine\Common\Collections\Criteria();
			$criteria->where($criteria->expr()
				->eq('providerId', $activeSubmission->getProvider()
				->getId()));
			$criteria->andWhere($criteria->expr()
				->eq('dataset', $activeSubmission->getDataset()));
			$criteria->andWhere($criteria->expr()
				->notIn('status', array(
				'ERROR',
				'REMOVED'
			)));
			$criteria->orderBy(array(
				'harmonizationId' => 'DESC'
			));
			$harmonisationProcess = $HarmoRepo->matching($criteria)->first();

			if (empty($harmonisationProcess)) {
				$harmonisationProcess = new HarmonizationProcess();
				$harmonisationProcess->setProviderId($activeSubmission->getProvider()
					->getId())
					->setDataset($activeSubmission->getDataset())
					->addSubmission($activeSubmission);
			}
			$harmonisationProcesses[] = $harmonisationProcess;
		}

		// Add the configuration parameters to the session for the map proxies (mapserverProxy and tilecacheProxy)
		if (!$request->getSession()->has('proxy_ConfigurationParameters')) {
			$configuration = $this->get('ogam.configuration_manager');
			$request->getSession()->set('proxy_ConfigurationParameters', $configuration->getParameters());
		}

		return $this->render('OGAMBundle:Harmonization:show_harmonization_page.html.twig', array(
			'harmonizations' => $harmonisationProcesses
		));
	}

	/**
	 * Launch the harmonization process.
	 *
	 * @Route("/launch-harmonization", name="harmonization_launch")
	 */
	public function launchHarmonizationAction(Request $request) {
		// Get the submission Id
		$providerId = $request->query->get("PROVIDER_ID");
		$datasetId = $request->query->get("DATASET_ID");

		$service = $this->get('ogam.harmonization_service');
		// Send the cancel request to the integration server
		try {
			$service->harmonizeData($providerId, $datasetId, FALSE);
		} catch (\Exception $e) {
			$this->get('logger')->error('Error during harmonization: ' . $e, array(
				'exception' => $e,
				'provider' => $providerId,
				'dataset' => $datasetId
			));

			return $this->render('OGAMBundle:Harmonization:show_harmonization_process_error.html.twig', array(
			    'errorMessage' => $this->get('translator')->trans("An unexpected error occurred.")
			));
		}

		// Forward the user to the next step
		return $this->redirectToRoute('harmonization_dashboard');
	}

	/**
	 * Remove the generated data.
	 *
	 * @Route("/remove-harmonization-data", name="harmonization_removeharmonizationdata")
	 */
	public function removeHarmonizationDataAction(Request $request) {
		// Get the submission Id
		$providerId = $request->query->get("PROVIDER_ID");
		$datasetId = $request->query->get("DATASET_ID");

		$service = $this->get('ogam.harmonization_service');
		// Send the cancel request to the integration server
		try {
			$service->harmonizeData($providerId, $datasetId, TRUE);
		} catch (\Exception $e) {
			$this->get('logger')->error('Error during harmonization: ' . $e, array(
				'exception' => $e,
				'provider' => $providerId,
				'dataset' => $datasetId
			));

			return $this->render('OGAMBundle:Harmonization:show_harmonization_process_error.html.twig', array(
			    'errorMessage' => $this->get('translator')->trans("An unexpected error occurred.")
			));
		}

		// Forward the user to the next step
		return $this->redirectToRoute('harmonization_dashboard');
	}

	/**
	 * Gets the integration status.
	 *
	 * @Route("/get-status", name="harmonization_getstatus")
	 */
	public function getStatusAction(Request $request) {
		// Get the submission Id
		$providerId = $request->request->get("PROVIDER_ID");
		$datasetId = $request->request->get("DATASET_ID");

		$service = $this->get('ogam.harmonization_service');
		// Send the cancel request to the integration server
		try {
			$status = $service->getStatus($datasetId, $providerId);

			$data = array(
				'success' => TRUE,
				'status' => $status->status
			);
			// Echo the result as a JSON
			if ($status->status === "OK") {
				return $this->json($data);
			} else {
				$data['taskName'] = $status->taskName;
				if ($status->currentCount != null) {
					$data["currentCount"] = $status->currentCount;
				}
				if ($status->totalCount != null) {
					$data['totalCount'] = $status->totalCount;
				}
				return $this->json($data);
			}
		} catch (\Exception $e) {
			$this->get('logger')->error('Error during get: ' . $e, array(
				'exception' => $e,
				'provider' => $providerId,
				'dataset' => $datasetId
			));

			return $this->json(array(
				'success' => FALSE,
			    'errorMessage' => $this->get('translator')->trans("An unexpected error occurred.")
			)
			);
		}
	}

	/**
	 * Returns a JsonResponse that uses the serializer component if enabled, or json_encode.
	 *
	 * @param mixed $data
	 *        	The response data
	 * @param int $status
	 *        	The status code to use for the Response
	 * @param array $headers
	 *        	Array of extra headers to add
	 * @param array $context
	 *        	Context to pass to serializer when using serializer component
	 *
	 * @return JsonResponse //import from symfony 3.1
	 */
	protected function json($data, $status = 200, $headers = array(), $context = array()) {
		return new JsonResponse($data, $status, $headers);
	}
}
