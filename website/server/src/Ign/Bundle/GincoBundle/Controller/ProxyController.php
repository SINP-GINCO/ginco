<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;

/**
 * @Route("/proxy")
 */
class ProxyController extends GincoController {

	/**
	 * @Route("/", name = "proxy_home")
	 */
	public function indexAction() {
		return $this->redirectToRoute('homepage');
	}

	/**
	 * Show a PDF report for the data submission.
	 *
	 * @Route("/show-report", name = "proxy_show-report")
	 */
	function showReportAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('showreportAction');

		// Get the configuration parameters
		$configuration = $this->get('ginco.configuration_manager');
		$reportServiceURL = $configuration->getConfig('reportGenerationService_url', 'http://localhost:8080/OGAMRG/');
		$errorReport = $configuration->getConfig('errorReport', 'ErrorReport.rptdesign');

		// Get the request parameter
		$submissionId = $request->query->getInt("submissionId");

		// Build the report URL
		$reportURL = $reportServiceURL . "/run?__format=pdf&__report=report/" . $errorReport . "&submissionid=" . $submissionId;
		$logger->debug('redirect showreport : ' . $reportURL);

		// Set the header
		set_time_limit(0);
		$response = new Response();
		$response->headers->set('Cache-control', 'private');
		$response->headers->set('Content-Type', 'application/pdf');
		$response->headers->set('Content-transfer-encoding', 'binary');
		$response->headers->set('Content-disposition', 'attachment; filename=Error_Report_' . $submissionId . '.pdf');

		try {
			$method = $request->getRealMethod(); // GET or POST
			if ($method == 'GET') {
				$result = $this->sendGET($reportURL);
			} else {
				$result = $this->sendPOST($reportURL, $request->getContent());
			}
			$response->setContent($result);
		} catch (\Exception $e) {
			$logger->error('Error while creating the PDF report for the data submission : ' . $e);

			return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
			    'error' => $this->get('translator')->trans("An unexpected error occurred.")
			));
		}

		return $response;
	}

	/**
	 * Simulate a GET.
	 *
	 * Not private because can be used by custom controllers.
	 *
	 * @param String $url
	 *        	the url to call
	 * @return The content of the response
	 * @throws Exception
	 */
	protected function sendGET($url) {
		$logger = $this->get('logger');
		$logger->debug('sendGET : ' . $url);

		$result = "";
		$handle = fopen($url, "rb");
		$result = stream_get_contents($handle);
		fclose($handle);

		return $result;
	}

	/**
	 * Simulate a POST.
	 *
	 * Not private because can be used by custom controllers.
	 *
	 * @param String $url
	 *        	the url to call
	 * @param Array $data
	 *        	the post data
	 * @return The content of the response
	 * @throws Exception
	 */
	protected function sendPOST($url, $data) {
		$logger = $this->get('logger');
		$logger->debug('sendPOST : ' . $url . " data : " . $data);

		$contentType = "application/xml";

		$opts = array(
			'http' => array(
				'method' => "POST",
				'header' => "Content-Type: " . $contentType . "\r\n" . "Content-length: " . strlen($data) . "\r\n",
				'content' => $data
			)
		);
		ini_set('user_agent', $_SERVER['HTTP_USER_AGENT']);
		$context = stream_context_create($opts);
		$fp = fopen($url, 'r', false, $context);
		$result = "";
		if ($fp) {
			while ($str = fread($fp, 1024)) {
				$result .= $str;
			}
			fclose($fp);
		} else {
			return "Error opening url : " . $url;
		}

		return $result;
	}
}
