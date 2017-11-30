<?php
namespace Ign\Bundle\GincoBundle\Services;

use Ign\Bundle\GincoBundle\Entity\Mapping\Request;
use Ign\Bundle\GincoBundle\Entity\Mapping\Result;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericFormField;
use Ign\Bundle\OGAMBundle\Entity\Generic\QueryForm;
use Ign\Bundle\OGAMBundle\Entity\Mapping\Layer;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Format;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FormField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Unit;
use Ign\Bundle\OGAMBundle\Entity\Website\User;
use Ign\Bundle\OGAMBundle\OGAMBundle;
use Symfony\Component\HttpFoundation\Session\Session;
use Ign\Bundle\OGAMBundle\Services\ConfigurationManager;
use Symfony\Component\Validator\Constraints\Length;

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
		return $result;
	}
	
	public function urlParameterSearch($field_label = null, $columns = null,$start = null) {
		
		$urlSearch = self::urlINPN;
		//Result in JSON 
		$urlSearch .="wt=json";
		if ($field_label !=null){
			$urlSearch .="&q=libelleLong:*".$field_label."*&q=libelleCourt:*".$field_label."";
		}
		
		/* url with parameters optionnels*/
		if ($columns != null) {
			$urlSearch .="&rows=".$columns;
		}
		if ($start !=null) {
			$url .="&start=".$start;
		}
		
		return $urlSearch;
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
	/* Get Information on a organism by UUID
	 * Strict Information
	 */
	public function getInfosByUUID($uuid){
		$urlUUID= self::urlINPN;
		$urlUUID .= "wt=json&q=codeOrganisme:".$uuid;
		$resultJson = $this->callINPN($urlUUID);
		return $resultJson;
	}
	
	public function searchOrganism($field_label,$columns = null,$start=null) {
		$urlSearch = $this->urlParameterSearch($field_label,$columns,$start);
		$this->logger->debug($urlSearch);
		$resultJson = $this->callINPN($urlSearch);
		
		
		return $resultJson;
		
	}
}