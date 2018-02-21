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
namespace Ign\Bundle\OGAMBundle\Services;

use Zend\Http\Client;

/**
 * This is a model allowing to access the integration service via HTTP calls.
 */
class Integration extends AbstractService {

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
	 * Create a new data submission.
	 *
	 * @param
	 *        	String the provider identifier
	 * @param
	 *        	String the dataset identifier
	 * @param
	 *        	String the user login
	 * @return the generated submissionId
	 * @throws Exception if a problem occured on the server side
	 */
	public function newDataSubmission($providerId, $datasetId, $userLogin) {
		$this->logger->debug("newDataSubmission : " . $providerId . " " . $datasetId);

		$client = new Client();
		$client->setUri($this->serviceUrl . "DataServlet?action=NewDataSubmission");
		$client->setOptions(array(
			'maxredirects' => 0,
			'timeout' => 30
		));

		$client->setParameterPost(array(
			'PROVIDER_ID' => $providerId,
			'DATASET_ID' => $datasetId,
			'USER_LOGIN' => $userLogin
		));

		$this->logger->debug("HTTP REQUEST : " . $this->serviceUrl . "DataServlet?action=NewDataSubmission");

		$client->setMethod('POST');
		$response = $client->send();

		// Check the result status
		if (!$response->isSuccess()) {
			$this->logger->debug("Error while creating new data submission : " . $response->getReasonPhrase());
			throw new \Exception("Error while creating new data submission : " . $response->getReasonPhrase());
		}

		// Extract the response body
		$body = $response->getBody();
		$this->logger->debug("HTTP RESPONSE : " . $body);

		// Check the response status
		if (strpos($body, "<Status>OK</Status>") === FALSE) {
			// Parse an error message
			$error = $this->parseErrorMessage($body);
			throw new \Exception("Error while creating new data submission : " . $error->errorMessage);
		} else {
			// Parse a valid response
			$value = $this->parseValueResponse($body);
			return $value;
		}
	}

	/**
	 * Upload one or more data file.
	 *
	 * @param $submissionId String
	 *        	the identifier of the submission
	 * @param $providerId String
	 *        	the identifier of the data provider
	 * @param $dataFiles Array[DatasetFile]
	 *        	the list of files to upload
	 * @param $srid String
	 *        	the srid given by the user
	 * @return true if the upload was OK
	 * @throws Exception if a problem occured on the server side
	 */
	public function uploadData($submissionId, $providerId, $dataFiles, $srid, $extension = '.csv') {
		$this->logger->debug("uploadData : " . $submissionId . " - " . $providerId . " - " . $srid);
		$client = new Client();
		$client->setUri($this->serviceUrl . "DataServlet?action=UploadData");
		$client->setEncType('multipart/form-data');
		$client->setOptions(array(
			'maxredirects' => 0,
			'timeout' => 30
		));
		$postParam = array(
			'SUBMISSION_ID' => $submissionId,
			'PROVIDER_ID' => $providerId,
			'SRID' => $srid,
			'EXTENSION' => $extension
		);

		$client->setParameterPost($postParam);

		foreach ($dataFiles as $dataFile) {
			$this->logger->debug("adding file : " . $dataFile->filePath);
			$client->setFileUpload($dataFile->filePath, $dataFile->getFormat());
		}

		$this->logger->debug("HTTP REQUEST : " . $this->serviceUrl . "DataServlet?action=UploadData");

		$response = $client->setMethod('POST')->send();

		// Check the result status
		if (!$response->isOk()) {
			$this->logger->debug("Error while creating new data submission : " . $response->getReasonPhrase());
			throw new \Exception("Error while creating new data submission : " . $response->getReasonPhrase());
		}

		// Extract the response body
		$body = $response->getBody();
		$this->logger->debug("HTTP RESPONSE : " . $body);

		// Check the response status
		if (strpos($body, "<Status>OK</Status>") === FALSE) {
			// Parse an error message
			$error = $this->parseErrorMessage($body);
			throw new \Exception("Error while creating new data submission : " . $error->errorMessage);
		} else {
			return true;
		}
	}

	/**
	 * Cancel a data submission.
	 *
	 * @param
	 *        	string the submission identifier
	 * @return true if the cancel was OK
	 * @throws Exception if a problem occured on the server side
	 */
	public function cancelDataSubmission($submissionId) {
		$this->logger->debug("cancelDataSubmission : " . $submissionId);

		$client = new Client();
		$client->setUri($this->serviceUrl . "DataServlet?action=CancelDataSubmission");
		$client->setOptions(array(
			'maxredirects' => 0,
			'timeout' => 300
		));

		$client->setParameterPost(array(
			'SUBMISSION_ID' => $submissionId
		));

		$this->logger->debug("HTTP REQUEST : " . $this->serviceUrl . "DataServlet?action=CancelDataSubmission");

		$response = $client->setMethod('POST')->send();

		// Check the result status
		if (!$response->isSuccess()) {
			$this->logger->debug("Error while cancelling the data submission : " . $response->getReasonPhrase());
			throw new \Exception("Error while cancelling the data submission : " . $response->getReasonPhrase());
		}

		// Extract the response body
		$body = $response->getBody();
		$this->logger->debug("HTTP RESPONSE : " . $body);

		// Check the response status
		if (strpos($body, "<Status>OK</Status>") === FALSE) {
			// Parse an error message
			$error = $this->parseErrorMessage($body);
			throw new \Exception("Error while cancelling the data submission : " . $error->errorMessage);
		} else {
			return true;
		}
	}

	/**
	 * Validate a data submission.
	 *
	 * @param
	 *        	string the submission identifier
	 * @return true if the validation was OK
	 * @throws Exception if a problem occured on the server side
	 */
	public function validateDataSubmission($submissionId) {
		$this->logger->debug("validateDataSubmission : " . $submissionId);

		$client = new Client();
		$client->setUri($this->serviceUrl . "DataServlet?action=ValidateDataSubmission");
		$client->setOptions(array(
			'maxredirects' => 0,
			'timeout' => 30
		));

		$client->setParameterPost(array(
			'SUBMISSION_ID' => $submissionId
		));

		$this->logger->debug("HTTP REQUEST : " . $this->serviceUrl . "DataServlet?action=ValidateDataSubmission");

		$response = $client->setMethod('POST')->send();

		// Check the result status
		if (!$response->isSuccess()) {
			$this->logger->debug("Error while validating the data submission : " . $response->getReasonPhrase());
			throw new \Exception("Error while validating the data submission : " . $response->getReasonPhrase());
		}

		// Extract the response body
		$body = $response->getBody();
		$this->logger->debug("HTTP RESPONSE : " . $body);

		// Check the response status
		if (strpos($body, "<Status>OK</Status>") === FALSE) {
			// Parse an error message
			$error = $this->parseErrorMessage($body);
			throw new \Exception("Error while validating the data submission : " . $error->errorMessage);
		} else {
			return true;
		}
	}

	/**
	 * Invalidate a data submission.
	 *
	 * @param
	 *        	string the submission identifier
	 * @return true if the invalidation was OK
	 * @throws Exception if a problem occured on the server side
	 */
	public function invalidateDataSubmission($submissionId) {
		$this->logger->debug("invalidateDataSubmission : " . $submissionId);

		$client = new Client();
		$client->setUri($this->serviceUrl . "DataServlet?action=InvalidateDataSubmission");
		$client->setOptions(array(
			'maxredirects' => 0,
			'timeout' => 30
		));

		$client->setParameterPost(array(
			'SUBMISSION_ID' => $submissionId
		));

		$this->logger->debug("HTTP REQUEST : " . $this->serviceUrl . "DataServlet?action=InvalidateDataSubmission");

		$response = $client->setMethod('POST')->send();

		// Check the result status
		if (!$response->isSuccess()) {
			$this->logger->debug("Error while invalidating the data submission : " . $response->getReasonPhrase());
			throw new \Exception("Error while invalidating the data submission : " . $response->getReasonPhrase());
		}

		// Extract the response body
		$body = $response->getBody();
		$this->logger->debug("HTTP RESPONSE : " . $body);

		// Check the response status
		if (strpos($body, "<Status>OK</Status>") === FALSE) {
			// Parse an error message
			$error = $this->parseErrorMessage($body);
			throw new \Exception("Error while invalidating the data submission : " . $error->errorMessage);
		} else {
			return true;
		}
	}

	/**
	 * Check the data of a submission.
	 *
	 * @param
	 *        	string the submission identifier
	 * @return true if the check was OK
	 * @throws Exception if a problem occured on the server side
	 */
	public function checkDataSubmission($submissionId) {
		$this->logger->debug("checkDataSubmission : " . $submissionId);

		$client = new Client();
		$client->setUri($this->serviceUrl . "CheckServlet?action=check");
		$client->setOptions(array(
			'maxredirects' => 0,
			'timeout' => 30
		));

		$client->setParameterPost(array(
			'SUBMISSION_ID' => $submissionId
		));

		$this->logger->debug("HTTP REQUEST : " . $this->serviceUrl . "CheckServlet?action=check");

		$response = $client->setMethod('POST')->send();

		// Check the result status
		if (!$response->isSuccess()) {
			$this->logger->debug("Error while checking the data submission : " . $response->getReasonPhrase());
			throw new \Exception("Error while checking the data submission : " . $response->getReasonPhrase());
		}

		// Extract the response body
		$body = $response->getBody();
		$this->logger->debug("HTTP RESPONSE : " . $body);

		// Check the response status
		if (strpos($body, "<Status>OK</Status>") === FALSE) {
			// Parse an error message
			$error = $this->parseErrorMessage($body);
			throw new \Exception("Error while checking the data submission : " . $error->errorMessage);
		} else {
			return true;
		}
	}

	/**
	 * Launch the get status process.
	 *
	 * @param $submissionId the
	 *        	submission identifier
	 * @param $servletName The
	 *        	name of the servlet to call
	 * @param $actionName The
	 *        	name of the action
	 * @return ProcessStatus the status of the process
	 * @throws Exception if a problem occured on the server side
	 */
	public function getStatus($submissionId, $servletName, $actionName = "status") {
		$this->logger->debug("getStatus : " . $submissionId);

		$client = new Client();
		$client->setUri($this->serviceUrl . $servletName . "?action=" . $actionName . "&");
		$client->setOptions(array(
			'maxredirects' => 0,
			'timeout' => 30
		));

		$client->setParameterPost(array(
			'SUBMISSION_ID' => $submissionId
		));

		$this->logger->debug("HTTP REQUEST : " . $this->serviceUrl . $servletName . "?action=" . $actionName);

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
