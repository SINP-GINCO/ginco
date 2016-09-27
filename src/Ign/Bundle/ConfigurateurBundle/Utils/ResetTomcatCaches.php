<?php
namespace Ign\Bundle\ConfigurateurBundle\Utils;

use Doctrine\ORM\ORMException;
use Monolog\Logger;
use Doctrine\DBAL\Connection;

/**
 * Utility class to reset tomcat caches after model publication.
 *
 * @author Anna Mouget
 *        
 */
class ResetTomcatCaches {

	protected $conn;

	protected $logger;

	/**
	 * Reset Tomcat Caches Constructor.
	 *
	 * @param Connection $conn        	
	 * @param logger $logger        	
	 */
	public function __construct(Connection $conn, Logger $logger) {
		$this->conn = $conn;
		$this->logger = $logger;
	}

	/**
	 * Call OGAM URL for tomcat caches reset
	 *
	 * @return true if URL call succeded, false otherwise
	 */
	public function performRequest() {
		try {
			// the name of the integration service is in application_parameters table
			$sql = "SELECT value
				FROM website.application_parameters
				WHERE name = 'integrationService_url'";
			$stmt = $this->conn->prepare($sql);
			$stmt->execute();
			$rows = $stmt->fetch();
			
			$ResetCachesUrl = $rows['value'] . "/MetadataServlet?action=ResetCaches";
			
			// use cURL to call external URL
			$req = curl_init();
			curl_setopt($req, CURLOPT_URL, $ResetCachesUrl);
			curl_exec($req);
			
			// check that the URL called exists
			$http_status = curl_getinfo($req, CURLINFO_HTTP_CODE);
			if ($http_status != 200) {
				return false;
			}
			
			curl_close($req);
		} catch (ORMException $e) {
			return false;
		}
		
		return true;
	}
}