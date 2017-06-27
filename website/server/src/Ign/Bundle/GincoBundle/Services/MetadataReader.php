<?php

namespace Ign\Bundle\GincoBundle\Services;
use Ign\Bundle\GincoBundle\Exception\MetadataException;

/**
 * Class MetadataReader
 *
 * Sends email from twig templates.
 * The "from" email adress and names are parameters of the service.
 * Can send email with attachments passed as an arry of filepaths.
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
     * MailManager constructor.
     * @param \Swift_Mailer $mailer
     * @param \Twig_Environment $twig
     * @param  $logger
     * @param $fromEmail
     * @param $fromName
     */
    public function __construct($configurationManager, $logger)
    {
        $this->configurationManager = $configurationManager;
		$this->logger = $logger;
    }


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

		// The XML metadata file url:
		$url = $metadataServiceUrl . $metadataId;

		// Try to download the XML file
		$ch = curl_init($url);

		// CURL options
		$verbose = fopen('php://temp', 'w+');
		$fileUrl = '/tmp/tempMetadata.xml';
		$file = fopen($fileUrl, 'w+');

		$curlOptions = array(
			CURLOPT_URL => $url,
			CURLOPT_SSL_VERIFYPEER => false,
			CURLOPT_FOLLOWLOCATION => true,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_CONNECTTIMEOUT => 2,
			CURLOPT_TIMEOUT => 4,
			CURLOPT_FILE => $file,
			CURLOPT_VERBOSE => true,
			CURLOPT_STDERR => $verbose
		);

		// Add proxy if needed
		$httpsProxy = $this->configurationManager->getConfig('https_proxy', '');
		if ($httpsProxy) {
			$curlOptions[CURLOPT_PROXY] = $httpsProxy;
		}

		curl_setopt_array($ch, $curlOptions);

		// Execute request
		curl_exec($ch);
		$httpCode = "" . curl_getinfo($ch, CURLINFO_HTTP_CODE);

		$this->logger->info("The HTTP code returned is " . $httpCode);

		// Close the cURL channel and file
		curl_close($ch);
		fclose($file);

		// HTTP code different from 200 means something is wrong
		if ($httpCode !== '200') {
			$this->logger->error("The download failed for metadata $metadataId");
			rewind($verbose);
			$verboseLog = stream_get_contents($verbose);
			$this->logger->error(print_r($verboseLog, true));
			throw new MetadataException('MetadataException.FailedDownload');
		}

		// Read the file, close it return its content
		$xml = file_get_contents($fileUrl);
		unlink($fileUrl);
		return $xml;
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

			$fields['metadataId'] = $xpath->query('//mtdjdd:JeuDeDonnees/mtdjdd:identifiantJeuDeDonnees')->item(0)->nodeValue;
			$fields['title'] = $xpath->query('//mtdjdd:JeuDeDonnees/mtdjdd:nomComplet')->item(0)->nodeValue;

		} catch (\Exception $e) {
			$this->logger->error("The jdd metadata XML file contains errors could not be parsed for $metadataId :" . $e->getMessage());
			throw new MetadataException('MetadataException.ParsingError');
		}

		return $fields;
	}
}