<?php
namespace Ign\Bundle\GincoBundle\Services;

use Doctrine\ORM\ORMException;
use GuzzleHttp\Client;
use Ign\Bundle\GincoBundle\Exception\ProviderWebserviceException;
use Ign\Bundle\OGAMBundle\Entity\Mapping\ProviderMapParameters;
use Ign\Bundle\OGAMBundle\Entity\Website\Provider;
use Ign\Bundle\OGAMBundle\Services\ConfigurationManager;

/**
 * Class INPNProviderService
 * Search provider in INPN directory using the webservice
 *
 * @package Ign\Bundle\GincoBundle\Services
 */
class INPNProviderService {

	protected $doctrine;
	protected $configManager;
	protected $logger;
	
	const urlINPN= "https://preprod-odata-inpn.mnhn.fr/solr-ws/organismes/records?" ;

	protected $options;

	/**
	 * OrganismeService
	 * @param $logger
	 * @param $configurationManager
	 */
	public function __construct($doctrine,$configManager,$logger)
	{
		$this->doctrine = $doctrine;
		$this->configManager = $configManager;
		$this->logger = $logger;

		$this->options = array();
		// Add proxy if needed
		$httpsProxy = $this->configManager->getConfig('https_proxy', '');
		if (!empty($httpsProxy)) {
			$this->options['proxy'] = $httpsProxy;
		}

	}

	/**
	 * Returns the result of the call to the INPN webservice
	 * and transform the json to get only the fields used in Ginco
	 *
	 * @param $urlSearch: the url with SOLR query parameters
	 * @return mixed
	 */
	protected function callINPN($urlSearch) {

		// Call the INPN authentication webservice to
		// get all attributes of the user ($distantUser)
		$client = new Client($this->options);
		$response = $client->request('GET', $urlSearch);

		if (!$response) {
			$this->logger->addError("INPN providers webservice is not accessible, URL : ".$urlSearch);
			throw new ProviderWebserviceException("INPN providers webservice is not accessible.");
		}
		$code = $response->getStatusCode();
		if ($code !== 200) {
			$this->logger->addError("INPN providers webservice returned a HTTP code: $code, URL : ".$urlSearch);
			throw new ProviderWebserviceException("INPN providers webservice returned a HTTP code: $code");
		}
		$string = $response->getBody()->getContents();
		$results = json_decode($string, true);

		// Transform the response to keep only the fields used in Ginco
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

	/**
	 * Get Information on a organism by ID
	 * Strict Information
	 *
	 * @param $idOrganism
	 * @return mixed
	 */
	public function getInfosById($idOrganism) {
		/* Build url to get infos */ 
		$urlInfosId = self::urlINPN;
		$urlInfosId .= "wt=json&q=id:".$idOrganism;
		$resultJson = $this->callINPN($urlInfosId);
		// Return unique result (else null)
		if (is_array($resultJson) && count($resultJson)==1) {
			$resultJson = $resultJson[0];
		}
		return $resultJson;
	}

	/**
	 * Get Information on a organism by UUID
	 * Strict Information
	 *
	 * @param $uuid
	 * @return mixed
	 */
	public function getInfosByUUID($uuid){
		$urlUUID= self::urlINPN;
		$urlUUID .= "wt=json&q=codeOrganisme:".$uuid;
		$resultJson = $this->callINPN($urlUUID);
		// return unique result (else null)
		if (is_array($resultJson) && count($resultJson)==1) {
			$resultJson = $resultJson[0];
		}
		return $resultJson;
	}

	/**
	 * Performs a search in INPN directory, based on search terms entered by the user
	 *
	 * @param $terms : search terms entered by user
	 * @param null $columns: nb of results to return
	 * @param null $start: start in list of results
	 * @return mixed
	 */
	public function searchOrganism($terms,$columns = null,$start=null) {
		$urlSearch = $this->urlParameterSearch($terms,$columns,$start);
		$this->logger->debug($urlSearch);
		$resultJson = $this->callINPN($urlSearch);
		// return a list of the results (or null)
		return $resultJson;
		
	}

	/**
	 * Update or create local provider from webservice informations,
	 * and persist it in database.
	 *
	 * @param $id
	 * @return Provider|null
	 * @throws ORMException
	 */
	public function updateOrCreateLocalProvider($id) {

		// Call the INPN directory webservice to
		// get all attributes of the provider ($distantProvider)
		$distantProvider = $this->getInfosById($id);

		// Check if returned provider is not null (inexisting id) todo: better check
		// And is not 1 (todo : what do we do with the "1" - default provider).
		if (empty($distantProvider)) {
			return null;
		}

		// OK, now we got a real distant provider, let's go !
		// ----------------------------------------------
		$em = $this->doctrine->getManager();
		$providerRepo = $this->doctrine->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Provider', 'website');

		// Tests if user exists in database; if not create it
		$provider = $providerRepo->find($id);
		$newProvider = false;
		if (!$provider) {
			$provider = new Provider();
			$newProvider = true;
		}

		// Create or synchronize local Provider with distant provider from webservice
		$provider
			->setId($id)
			->setLabel($distantProvider['label'])
			->setDefinition($distantProvider['description'])
			->setUUID($distantProvider['uuid']);

		// Save the provider map params
		if ($newProvider) {
			$bbox = $this->createDefaultBoundingBox();
			$bbox->setProviderId($id);
			$em->persist($bbox);
		}

		try {
			$em->persist($provider);
			$em->flush();
		}
		catch (ORMException $e) {
			$this->logger->addError("Impossible to persist provider in database ; \n
				Doctrine Exception: " . $e->getMessage());
			throw $e;
		}
		return $provider;
	}


	/**
	 * Create a new BoundingBox object with default values from database.
	 *
	 * @return \Ign\Bundle\OGAMBundle\Entity\Generic\BoundingBox
	 */
	public function createDefaultBoundingBox() {

		// Get the parameters from configuration file
		$xMin = $this->configManager->getConfig('default_provider_bbox_x_min');
		$xMax = $this->configManager->getConfig('default_provider_bbox_x_max');
		$yMin = $this->configManager->getConfig('default_provider_bbox_y_min');
		$yMax = $this->configManager->getConfig('default_provider_bbox_y_max');
		$zoomLevel = $this->configManager->getConfig('default_provider_zoom_level');

		$em = $this->doctrine->getManager();
		$zoomLevel = $em->find('Ign\Bundle\OGAMBundle\Entity\Mapping\ZoomLevel', $zoomLevel);

		$bb = new ProviderMapParameters();
		return $bb->createBoundingBox($xMin, $xMax, $yMin, $yMax, $zoomLevel);
	}

}