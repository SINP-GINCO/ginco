<?php
namespace Ign\Bundle\GincoBundle\Services;

use Psr\Log\LoggerInterface;
use Ign\Bundle\GincoBundle\Entity\Error;
use Ign\Bundle\GincoBundle\Entity\ProcessStatus;

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
 * This is a model allowing to access a java service.
 */
class AbstractService {

	/**
	 * The logger.
	 *
	 * @var LoggerInterface
	 */
	protected $logger;

	public function getLogger() {
		return $this->logger;
	}

	public function setLogger(LoggerInterface $logger) {
		$this->logger = $logger;
		return $this;
	}

	/**
	 * Parse an error response.
	 *
	 * @param
	 *        	String the XML body
	 * @return an error object.
	 * @throws an exception if the return message is not a valid XML
	 */
	protected function parseErrorMessage($body) {
		try {
			// Parse la chaîne en un arbre DOM
			$dom = new \SimpleXMLElement(utf8_encode($body), LIBXML_NOERROR); // Suppress warnings, 'utf8_encode' avoid the malformed UTF-8 characters, possibly incorrectly encoded into the error message
		} catch (\Exception $e) {
			$this->logger->debug("Error during parsing: " . $e->getMessage());
			throw new \Exception("Error during parsing: " . $e->getMessage());
		}
		
		$error = new Error();
		$error->errorCode = $dom->ErrorCode;
		$error->errorMessage = $dom->ErrorMessage;
		
		return $error;
	}

	/**
	 * Parse a valid response where a value is expected as a result.
	 *
	 * @param
	 *        	String the XML body
	 * @return the value.
	 * @throws an exception if the return message is not a valid XML
	 */
	protected function parseValueResponse($body) {
		try {
			// Parse la chaîne en un arbre DOM
			$dom = new \SimpleXMLElement($body); // Suppress warnings
		} catch (\Exception $e) {
			$this->logger->debug("Error during parsing: " . $e->getMessage());
			throw new \Exception("Error during parsing: " . $e->getMessage());
		}
		
		return (string) $dom->Value;
	}

	/**
	 * Parse a response indicating the status of the process.
	 *
	 * @param
	 *        	String the XML body
	 * @return ProcessStatus the status.
	 * @throws an exception if the return message is not a valid XML
	 */
	protected function parseStatusResponse($body) {
		try {
			// Parse la chaîne en un arbre DOM
			$dom = new \SimpleXMLElement($body);
		} catch (\Exception $e) {
			$this->logger->debug("Error during parsing: " . $e->getMessage());
			throw new \Exception("Error during parsing: " . $e->getMessage());
		}
		
		$status = new ProcessStatus();
		$status->status = (string) $dom->Value;
		
		if ($dom->TaskName !== null && $dom->TaskName !== "") {
			$status->taskName = (string) $dom->TaskName;
			$status->currentCount = (string) $dom->CurrentCount;
			$status->totalCount = (string) $dom->TotalCount;
		}
		
		return $status;
	}
}
