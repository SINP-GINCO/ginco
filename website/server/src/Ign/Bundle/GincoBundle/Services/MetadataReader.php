<?php

namespace Ign\Bundle\GincoBundle\Services;
use GuzzleHttp\Client;
use Ign\Bundle\GincoBundle\Exception\MetadataException;

/**
 * Class MetadataReader
 *
 * Loads and reads a Metadata Jdd file, from the INPN metadata service.
 *
 * @author SCandelier
 */
class MetadataReader
{
	/**
	 * The configuration manager service
	 * @var
	 */
    protected $configurationManager;

	/**
	 * The logger
	 * @var
	 */
	protected $logger;

	/**
	 * Guzzle connection options (same as curl options)
	 * @var
	 */
	protected $options;

	/**
	 * MetadataReader constructor.
	 * @param $configurationManager
	 * @param $logger
	 */
    public function __construct($configurationManager, $logger)
    {
        $this->configurationManager = $configurationManager;
		$this->logger = $logger;

		$this->options = array(
			'http_errors' => false // Disable Guzzle exceptions
		);
		// Add proxy if needed
		$httpsProxy = $this->configurationManager->getConfig('https_proxy', '');
		if (!empty($httpsProxy)) {
			$this->options['proxy'] = $httpsProxy;
		}
    }

	/**
	 * Get the content of the XML file from the API
	 *
	 * @param $metadataId
	 * @return string
	 * @throws MetadataException
	 * @throws \Exception
	 */
    public function getXmlFile($metadataId)
	{
		$this->logger->info('Getting XML metadata file for id: ' . $metadataId);

		// Get the url of the metadata service
		// exemple: https://inpn2.mnhn.fr/mtd/cadre/jdd/export/xml/GetRecordById?id=
		try {
			$metadataServiceUrl = $this->configurationManager->getConfig('jddMetadataFileDownloadServiceURL');
		} catch (\Exception $e) {
			$this->logger->error('No jddmetadata file download service URL found: PLEASE FIX CONFIGURATION');
			throw $e;
		}

		// Call the MTD webservice to get the XML metadata file
		$client = new Client($this->options);
		$response = $client->request( 'GET', $metadataServiceUrl . $metadataId );

		if (!$response) {
			$this->logger->addError("INPN metadata service is not accessible, URL : ".$metadataServiceUrl . $metadataId );
			throw new MetadataException('MetadataException.FailedDownload');
		}
		$code = $response->getStatusCode();
		if ($code !== 200) {
			$this->logger->addError("INPN metadata service returned a HTTP code: $code, URL : ".$metadataServiceUrl . $metadataId );
			$this->logger->addError($response->getBody()->getContents());
			throw new MetadataException("MetadataException.FailedDownload");
		}
		return $response->getBody()->getContents();
	}


	public function getMetadata($metadataId)
	{
		// Get the file from INPN website
		$xmlStr = $this->getXmlFile($metadataId);

		// Read and parse the file, to extract values in $fields
		$fields = array();

		try {
			$doc = new \DOMDocument();
			$doc->loadXML($xmlStr);
			$xpath = new \DOMXpath($doc);

			// Get schema version, as field names depend on it
			$xsdVersion = $xpath->query('@xsi:schemaLocation')->item(0)->nodeValue;

			// 1.3.1, used in production
			if ($xsdVersion == "http://inpn.mnhn.fr mtd_jdd_1_3_1.xsd") {
				
				$metadataIdNodeList = $xpath->query('//mtdjdd:JeuDeDonnees/mtdjdd:identifiantJeuDeDonnees') ;
				$titleNodeList = $xpath->query('//mtdjdd:JeuDeDonnees/mtdjdd:nomComplet') ;
				$metadataCAId = $xpath->query('//mtdjdd:JeuDeDonnees/mtdjdd:identifiantCadreAcquisition') ;
				
				$fields['metadataId'] = $metadataIdNodeList->length > 0 ? $metadataIdNodeList->item(0)->nodeValue : null ;
				$fields['title'] = $titleNodeList->length > 0 ? $titleNodeList->item(0)->nodeValue : null ;
				$fields['metadataCAId'] = $metadataCAId->length > 0 ? $metadataCAId->item(0)->nodeValue : null ;
			}
			// > 1.3.1, new field definition
			else {
				
				$metadataIdNodeList = $xpath->query('//jdd:JeuDeDonnees/jdd:identifiantJdd') ;
				$titleNodeList = $xpath->query('//jdd:JeuDeDonnees/jdd:libelle') ;
				$metadataCAId = $xpath->query('//jdd:JeuDeDonnees/jdd:identifiantCadre') ;
				
				$fields['metadataId'] = $metadataIdNodeList->length > 0 ? $metadataIdNodeList->item(0)->nodeValue : null ;
				$fields['title'] = $titleNodeList->length > 0 ? $titleNodeList->item(0)->nodeValue : null ;
				$fields['metadataCAId'] = $metadataCAId->length > 0 ? $metadataCAId->item(0)->nodeValue : null ;
			}

		} catch (\Exception $e) {
			$this->logger->error("The jdd metadata XML file contains errors could not be parsed for $metadataId :" . $e->getMessage());
			throw new MetadataException('MetadataException.ParsingError');
		}

		return $fields;
	}
}