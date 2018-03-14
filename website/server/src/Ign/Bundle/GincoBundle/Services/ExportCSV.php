<?php
namespace Ign\Bundle\GincoBundle\Services;

use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\GincoBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
use Ign\Bundle\GincoBundle\Services\MailManager;
use Symfony\Bridge\Monolog\Logger;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class ExportCSV
 * Responsible of the process of exporting asynchronously results into CSV file:
 *
 * - create file name
 * - generate export in the file
 * - create zip archive with the file
 * - send email to the user
 *
 * @package Ign\Bundle\GincoBundle\Services
 */
class ExportCSV {

	/**
	 *
	 * @var EntityManager
	 */
	protected $em;

	/**
	 *
	 * @var ConfigurationManager
	 */
	protected $configuration;

	/**
	 *
	 * @var MailManager
	 */
	protected $mailManager;

	/**
	 *
	 * @var Logger
	 */
	protected $queryService;

	/**
	 *
	 * @var Logger
	 */
	protected $logger;

	/**
	 *
	 * @var locale
	 */
	protected $locale;

	/**
	 *
	 * @var translator
	 */
	protected $translator;

	/**
	 * Asynchronous export CSV constructor
	 *
	 * @param
	 *        	$em
	 * @param
	 *        	$configuration
	 * @param
	 *        	$mailManager
	 * @param
	 *        	$queryService
	 * @param
	 *        	$logger
	 * @param
	 *        	$locale
	 * @param
	 *        	$translator
	 */
	public function __construct($em, $configuration, $mailManager, $queryService, $logger, $locale, $translator) {
		$this->em = $em;
		$this->configuration = $configuration;
		$this->mailManager = $mailManager;
		$this->queryService = $queryService;
		$this->logger = $logger;
		$this->locale = $locale;
		$this->translator = $translator;
		$logger->debug('construct');
	}

	/**
	 * Whole process for generating the export and sending notification to the user
	 *
	 * @param Request $request        	
	 * @param unknown $userInfos        	
	 * @param unknown $message     	
	 */
	public function generateCSV(Request $request, $userInfos, $message) {
		$this->logger->info("asynchronousExportCSV");
		
		// We clone the request object to keep the values even if another research is launched
		$exportRequest = clone $request;
		
		// Number of results to export
		$total = $exportRequest->getSession()->get('query_Count');
		$this->logger->debug('Expected lines : ' . $total);
		
		// Start writing output (CSV file)
		$exportFilePath = $this->generateFilePath($message->getId());
		
		$exportFile = fopen($exportFilePath, 'w');
		
		// Set encoding to UTF-8 BOM
		$BOM = $this->configuration->getConfig('csvExportCharset', 'UTF-8') == 'UTF-8' ?
		chr(0xEF) . chr(0xBB) . chr(0xBF) : '';
		fwrite($exportFile, $BOM);
		
		if (!$userInfos['EXPORT_RAW_DATA']) {
			fputcsv($exportFile, '// No permissions', ";", '"');
		} else {
			
			// Get the request from the session
			$queryForm = $exportRequest->getSession()->get('query_QueryForm');
			
			// Get the mappings for the query form fields
			$queryForm = $this->queryService->setQueryFormFieldsMappings($queryForm);
			
			// Write the header
			fputcsv($exportFile, [
				'// *************************************************'
			], ";", '"');
			fputcsv($exportFile, [
				'// ' . $this->translator->trans('Data Export')
			], ";", '"');
			fputcsv($exportFile, [
				'// *************************************************'
			], ";", '"');
			
			// Export the request criterias
			$criteria = $this->csvExportCriterias($request);
			$exportCriteriaLines = explode("\n", $criteria);
			
			foreach ($exportCriteriaLines as $exportCriteriaLine) {
				$exportCriteria = explode(";", $exportCriteriaLine);
				fputcsv($exportFile, $exportCriteria, ";", '"');
			}
			
			// Export the column names
			$line = array();
			foreach ($queryForm->getColumns() as $genericFormField) {
				$genericTableField = $queryForm->getFieldMappingSet()->getDstField($genericFormField);
				$tableField = $genericTableField->getMetadata();
				$line[] = $tableField->getLabel();
			}
			
			fputcsv($exportFile, $line, ";", '"');
			
			fclose($exportFile);
			// Query by $maxLines batches
			$maxLines = 5000;
			$pagesTotal = ceil($total / $maxLines);
			
			for ($page = 0; $page < $pagesTotal; $page ++) {
				
				// Get requested data
				// they come in the form of a json; convert them associative array and then to csv
				// C'est ça qui prend du temps (notamment récupérer le label de chaque code...)
				$data = $this->queryService->getResultRowsGinco($page * $maxLines, $maxLines, null, null, $exportRequest->getSession(), $userInfos, $this->locale);
				
				if ($data != null) {
					$exportFile = fopen($exportFilePath, 'a');
					
					// Write each line in the csv
					foreach ($data as $line) {
						// keep only the first count($resultColumns), because there is 2 or 3 technical fields sent back (after the result columns).
						$line = array_slice($line, 0, count($queryForm->getColumns()));
						// implode all arrays
						foreach ($line as $index => $value) {
							if (is_array($value)) {
								$line[$index] = join(",", $value); // just use join because we don't want double enclosure...
							}
						}
						
						// Write csv line to output
						// Remove original enclosing character from fields
						$line = array_map(function ($field) {
							return trim($field, '"');
						}, $line);
						
						// use the default csv handler
						fputcsv($exportFile, $line, ";", '"');
					}
					fclose($exportFile);
				}
			}
		}
		
		// Generate the archive and set the download path of the export
		$archiveFileSystemPath = $this->createCSVArchive($exportFilePath);
		
		// Send mail notification to the user
		$this->sendExportNotificationMail($archiveFileSystemPath, $userInfos, $message);
		echo "User notification (sent to " . $userInfos['email'] . ")...\n";
		
		return true;
	}

	/**
	 * Export the request criterias in the CSV file.
	 *
	 * @return String the criterias
	 */
	public function csvExportCriterias(Request $request) {
		$this->logger->debug('csvExportCriterias');
		$criteriasLine = "";
		
		// Get the request from the session
		$queryForm = $request->getSession()->get('query_QueryForm');
		
		if ($queryForm->getCriteria()) {
			$criteriasLine .= '// ' . $this->translator->trans('Request Criterias') . "\n";
		}
		
		// List all the criterias
		foreach ($queryForm->getCriteria() as $genericFormField) {
			
			$genericTableField = $queryForm->getFieldMappingSet()->getDstField($genericFormField);
			$tableField = $genericTableField->getMetadata();
			
			// Get the descriptor of the form field
			$criteriasLine .= '// ' . $tableField->getLabel() . ';';
			
			if (is_array($genericFormField->getValueLabel())) {
				$criteriasLine .= implode(', ', $genericFormField->getValueLabel());
			} else {
				$criteriasLine .= $genericFormField->getValueLabel();
			}
			
			$criteriasLine .= "\n";
		}
		
		return $criteriasLine;
	}

	/**
	 * Construct the filepath of the export file
	 *
	 * @param $messageId       	
	 * @return string
	 */
	public function generateFilePath($messageId = '0') {
		$this->logger->debug('generateFilePath');
		
		$regionCode = $this->configuration->getConfig('regionCode', 'REGION');
		$now = new \DateTime();
		$date = $now->format('Y-m-d_H-i-s');
		
		$filePath = $this->configuration->getConfig('exportPublicDirectory');
		
		$fileNameWithoutExtension = $regionCode . '_' . $date . '_' . $messageId;
		$filename = $fileNameWithoutExtension . '.csv';
		
		return $filePath . '/' . $filename;
	}

	/**
	 * Create a gzipped archive containing:
	 * - the exported csv file
	 *
	 * @param $fileName string
	 *        	file for the export
	 *        	
	 * @return string
	 */
	public function createCSVArchive($fileName) {
		$this->logger->debug('createCSVArchive');
		
		// Get fileName without extension
		$fileNameWithoutExtension = pathinfo($fileName, PATHINFO_FILENAME);
		
		// Public directory to store the archive
		$exportDir = $this->configuration->getConfig('exportPublicDirectory');
		$exportName = $fileNameWithoutExtension . '.csv';
		
		// Create an archive of the directory
		$parentDir = dirname($fileName);
		$archiveName = $exportDir . '/' . $fileNameWithoutExtension . '.zip';
		try {
			chdir($parentDir);
			$this->logger->debug("zip -r $archiveName $exportName");
			system("zip -r $archiveName $exportName");
		} catch (\Exception $e) {
			throw new Exception("Could not create archive $archiveName:" . $e->getMessage());
		}
		// Delete CSV file
		unlink($fileName);
		
		return $archiveName;
	}

	/**
	 * Send notification email after creation of the export CSV archive:
	 * - to the user who made the export
	 * 
	 * @param unknown $exportFilePath
	 * @param unknown $userInfos
	 * @param unknown $message
	 */
	public function sendExportNotificationMail($exportFilePath, $userInfos, $message) {
		$this->logger->debug('sendExportNotificationMail');
		
		// Parameters for email notifications
		$parameters = array(
			'region' => $this->configuration->getConfig('regionCode', 'REGION'),
			'provider' => $userInfos['providerId'],
			'email' => $userInfos['email'],
			'created' => $message->getCreatedAt()
		);
		
		// Checksum of the export archive
		$exportDir = $this->configuration->getConfig('exportPublicDirectory');
		$fileName = pathinfo($exportFilePath, PATHINFO_BASENAME);
		$checksum = md5_file($exportDir . '/' . $fileName);
		
		$parameters += array(
			'filename' => $fileName,
			'download_url' => $this->configuration->getConfig('site_url') . "/export/" . $fileName,
			'checksum' => $checksum
		);
		
		// Send mail notification to user
		if (!empty($userInfos['email'])) {
			$this->mailManager->sendEmail('IgnGincoBundle:Emails:export-result-notification.html.twig', $parameters, $userInfos['email']);
		}
	}
}