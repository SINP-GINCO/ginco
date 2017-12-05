<?php
namespace Ign\Bundle\GincoBundle\Services;

use Ign\Bundle\OGAMBundle\Services\ConfigurationManager;

/**
 * Class OrganismeService
 *
 * This service search the organism in platform inpn
 */
class ProviderService {
	
	/**
	 * The configuration manager service
	 * @var ConfigurationManager
	 */
	protected $configurationManager;
	/**
	 * @var Logger
	 */
	protected $logger;
	
	
	/**
	 * @var EntityManager
	 */
	protected $em;
	
	const urlINPN= "https://test-odata-inpn.mnhn.fr/solr-ws/organismes/records?" ;
	/**
	 * OrganismeService
	 * @param $logger
	 * @param $configurationManager
	 */
	public function __construct($em,$logger,$configurationManager)
	{
		$this->em=$em;
		$this->configurationManager = $configurationManager;
		$this->logger = $logger;
	}

	/**
	 * Returns the result of the call to the INPN webservice
	 * and transform the json to get only the fields used in Ginco
	 *
	 * @param $urlSearch: the url with query parameters
	 * @return mixed
	 */
	private function callINPN($urlSearch) {
		$ch = curl_init();
		$curlOptions = array(
			CURLOPT_URL => $urlSearch,
			CURLOPT_SSL_VERIFYPEER => false,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_CONNECTTIMEOUT => 2,
			CURLOPT_TIMEOUT => 4
		);
		
		// Add proxy if needed
		$httpsProxy = $this->configurationManager->getConfig('https_proxy', '');
		if ($httpsProxy) {
			$curlOptions[CURLOPT_PROXY] = $httpsProxy;
		}
		
		curl_setopt_array($ch, $curlOptions);
		
		// Execute request
		$result= curl_exec($ch);
		$httpCode = "" . curl_getinfo($ch, CURLINFO_HTTP_CODE);
		$this->logger->info("The HTTP code returned is " . $httpCode);
		
		// Close the cURL channel and file
		curl_close($ch);

		// Transform the response to keep only the fields used in Ginco
		$results = json_decode($result, true);
		$providersList = $results['response']['docs'];

		if ($providersList) {
			foreach ($providersList as $index => $provider) {
				$providersList[$index]['label'] = $provider['libelleLong'] . ' - ' . $provider['libelleCourt'];
				$providersList[$index]['uuid'] = $provider['codeOrganisme'];
				$providersList[$index]['description'] = (isset($provider['descriptionOrganisme'])) ? $provider['descriptionOrganisme'] : "";
				// Unset unused fields
				foreach ($provider as $key => $value) {
					if (!in_array($key, ['id', 'label', 'uuid', 'description'])) {
						unset($providersList[$index][$key]);
					}
				}
			}
		}
		return $providersList;
	}

	/**
	 * Constructs the url to query the INPN providers webservices
	 * with query parameters
	 *
	 * @param null $search: the search string (search in libelleCourt and libelleLong)
	 * @param null $columns: max number of results returned
	 * @param null $start: start position
	 * @return string
	 */
	public function urlParameterSearch($search = "", $columns = null,$start = null) {
		
		// Query parameters
		$query = array(
			"wt" => "json",
		);

		// First sanitize string: trim and replace accents
		$search = trim($search);
		$normalizeChars = array(
			'Š'=>'S', 'š'=>'s', 'Ð'=>'Dj','Ž'=>'Z', 'ž'=>'z', 'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A',
			'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E', 'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I',
			'Ï'=>'I', 'Ñ'=>'N', 'Ń'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O', 'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U',
			'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss','à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a',
			'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e', 'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i',
			'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ń'=>'n', 'ò'=>'o', 'ó'=>'o', 'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u',
			'ú'=>'u', 'û'=>'u', 'ü'=>'u', 'ý'=>'y', 'ý'=>'y', 'þ'=>'b', 'ÿ'=>'y', 'ƒ'=>'f',
			'ă'=>'a', 'î'=>'i', 'â'=>'a', 'ș'=>'s', 'ț'=>'t', 'Ă'=>'A', 'Î'=>'I', 'Â'=>'A', 'Ș'=>'S', 'Ț'=>'T',
		);
		$search = strtr($search, $normalizeChars);

		// Building a query to search all terms in search (AND),
		// with and without * to match exact words and "words beginning with"
		$terms = preg_split('/\s+/', $search);
		$termsWithWilcard =array_map(function($x) {return "($x OR $x*)";}, $terms);
		if (count($termsWithWilcard) > 1) {
			$searchAllTerms = "(" . implode(" AND ", $termsWithWilcard) . ")";
		}
		else {
			$searchAllTerms = $termsWithWilcard[0];
		}
		$q = 'libelleLong:' . $searchAllTerms . ' OR libelleCourt:' . $searchAllTerms;  // can't use Solr DISMAX because of the *

		// Adding an exact search over id, if only one word given and if it is an integer
		if (count($terms) == 1 && intval($search) > 0) {
			$q .= ' OR id:' . $search;
		}
		$query['q'] = $q;

		/* url with parameters optionnels*/
		if ($columns != null) {
			$query['rows'] = $columns;
		}
		if ($start != null) {
			$query['start'] = $start;
		}
		
		return self::urlINPN . http_build_query($query);
	}
	
	
	/* Get Information on a organism by ID 
	 * Strict Information
	 * 
	 */
	public function getInfosById($idOrganism) {
		/* Build url to get infos */ 
		$urlInfosId = self::urlINPN;
		$urlInfosId .= "wt=json&q=id:".$idOrganism;
		$resultJson = $this->callINPN($urlInfosId);
		return $resultJson;
		
		
		
	}
	/**
	 * Get Information on a organism by UUID
	 * Strict Information
	 */
	public function getInfosByUUID($uuid){
		$urlUUID= self::urlINPN;
		$urlUUID .= "wt=json&q=codeOrganisme:".$uuid;
		$resultJson = $this->callINPN($urlUUID);
		return $resultJson;
	}

	/**
	 * Performs a search in INPN directory, based on search terms entered by the user
	 *
	 * @param $terms : search terms entered by user
	 * @param null $columns
	 * @param null $start
	 * @return mixed
	 */
	public function searchOrganism($terms,$columns = null,$start=null) {
		$urlSearch = $this->urlParameterSearch($terms,$columns,$start);
		$this->logger->debug($urlSearch);
		$resultJson = $this->callINPN($urlSearch);
		return $resultJson;
		
	}
}