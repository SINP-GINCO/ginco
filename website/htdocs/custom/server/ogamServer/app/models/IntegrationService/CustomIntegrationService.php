<?php

/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 *
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices.
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents.
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */

/**
 * This is the IntegrationService model.
 *
 * @package models
 */
include_once APPLICATION_PATH . '/models/IntegrationService/IntegrationService.php';

class Application_Model_IntegrationService_CustomIntegrationService extends Application_Model_IntegrationService_IntegrationService {

	/**
	 * Create a new data submission.
	 * Custom : Add the jdd id to the request parameter.
	 *
	 * @param
	 *        	String the provider identifier
	 * @param
	 *        	String the dataset identifier
	 * @param
	 *        	String the user login
	 * @param
	 *        	String the jdd identifier
	 * @return the generated submissionId
	 * @throws Exception if a problem occured on the server side
	 */
	public function newDataSubmissionCustom($providerId, $datasetId, $userLogin, $jddId) {
		$this->logger->debug("newDataSubmission : " . $providerId . " " . $datasetId);

		$client = new Zend_Http_Client();
		$client->setUri($this->serviceUrl . "DataServlet?action=NewDataSubmission");
		$client->setConfig(array(
			'maxredirects' => 0,
			'timeout' => 30
		));

		$client->setParameterPost('PROVIDER_ID', $providerId);
		$client->setParameterPost('DATASET_ID', $datasetId);
		$client->setParameterPost('USER_LOGIN', $userLogin);
		$client->setParameterPost('JDD_ID', $jddId);

		$this->logger->debug("HTTP REQUEST : " . $this->serviceUrl . "DataServlet?action=NewDataSubmission");

		$response = $client->request('POST');

		// Check the result status
		if ($response->isError()) {
			$this->logger->debug("Error while creating new data submission : " . $response->getMessage());
			throw new Exception("Error while creating new data submission : " . $response->getMessage());
		}

		// Extract the response body
		$body = $response->getBody();
		$this->logger->debug("HTTP RESPONSE : " . $body);

		// Check the response status
		if (strpos($body, "<Status>OK</Status>") === FALSE) {
			// Parse an error message
			$error = $this->parseErrorMessage($body);
			throw new Exception("Error while creating new data submission : " . $error->errorMessage);
		} else {
			// Parse a valid response
			$value = $this->parseValueResponse($body);
			return $value;
		}
	}
}
