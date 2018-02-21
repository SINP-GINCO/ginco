<?php
namespace Ign\Bundle\OGAMBundle\Services;

use Zend\Http\Client;

/**
 * This is a model allowing to access the harmonization service via HTTP calls.
 */
class Harmonization extends AbstractService {

	/**
	 * The URL of the service.
	 *
	 * @var String
	 */
	private $serviceUrl;

	/**
	 * Class constructor
	 */
	function __construct($url) {
		
		// Initialise the service URL
		$this->serviceUrl = $url;
	}

	/**
	 * Launch the harmonization process.
	 *
	 * @param String $providerId
	 *        	the provider identifier
	 * @param String $datasetId
	 *        	the dataset identifier
	 * @param Boolean $removeOnly
	 *        	remove the data without adding new one
	 * @return true if the process was OK
	 * @throws Exception if a problem occured on the server side
	 */
	public function harmonizeData($providerId, $datasetId, $removeOnly) {
		$this->logger->debug("harmonizeData : " . $providerId . " " . $datasetId);
		
		$client = new Client();
		$uri = $this->serviceUrl . "HarmonizationServlet?action=HarmonizeData";
		if ($removeOnly) {
			$uri = $this->serviceUrl . "HarmonizationServlet?action=RemoveHarmonizeData";
		}
		$client->setUri($uri);
		$client->setOptions(array(
			'maxredirects' => 0,
			'timeout' => 30
		));
		
		$client->setParameterPost(array(
			'PROVIDER_ID' => $providerId,
			'DATASET_ID' => $datasetId
		));
		
		$this->logger->debug("HTTP REQUEST : " . $uri);
		
		$response = $client->setMethod('POST')->send();
		
		// Check the result status
		if (!$response->isSuccess()) {
			$this->logger->debug("Error while harmonizing data : " . $response->getReasonPhrase());
			throw new \Exception("Error while harmonizing data : " . $response->getReasonPhrase());
		}
		
		// Extract the response body
		$body = $response->getBody();
		$this->logger->debug("HTTP RESPONSE : " . $body);
		
		// Check the response status
		if (strpos($body, "<Status>OK</Status>") === FALSE) {
			// Parse an error message
			$error = $this->parseErrorMessage($body);
			throw new \Exception("Error while harmonizing data : " . $error->errorMessage);
		} else {
			return true;
		}
	}

	/**
	 * Get the status of the harmonisation process.
	 *
	 * @param String $datasetId
	 *        	The identifier of the dataset
	 * @param String $providerId
	 *        	The identifier of the data provider
	 * @param String $servletName
	 *        	The name of the servlet to call
	 * @return ProcessStatus the status of the process.
	 * @throws Exception if a problem occured on the server side
	 */
	public function getStatus($datasetId, $providerId, $servletName = 'HarmonizationServlet') {
		$this->logger->debug("getStatus : " . $datasetId);
		
		$client = new Client();
		$client->setUri($this->serviceUrl . $servletName . "?action=status");
		$client->setOptions(array(
			'maxredirects' => 0,
			'timeout' => 30
		));
		
		$client->setParameterPost(array(
			'DATASET_ID' => $datasetId,
			'PROVIDER_ID' => $providerId
		));
		
		$this->logger->debug("HTTP REQUEST : " . $this->serviceUrl . $servletName . "?action=status");
		
		$response = $client->setMethod('POST')->send();
		
		// Check the result status
		if (!$response->isSuccess()) {
			$this->logger->debug("Error while getting the status : " . $response->getReasonPhrase());
			throw new \Exception("Error while getting the status : " . $response->getReasonPhrase());
		}
		
		// Extract the response body
		$body = $response->getBody();
		$this->logger->debug("HTTP RESPONSE : " . $body);
		
		// Check the response status
		if (strpos($body, "<Status>OK</Status>") === FALSE) {
			// Parse an error message
			$error = $this->parseErrorMessage($body);
			throw new \Exception("Error while getting the status : " . $error->errorMessage);
		} else {
			return $this->parseStatusResponse($body);
		}
	}
}