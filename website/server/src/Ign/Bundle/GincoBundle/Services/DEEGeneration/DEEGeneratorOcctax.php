<?php
namespace Ign\Bundle\GincoBundle\Services\DEEGeneration;


use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Mapping as ORM;

use Symfony\Bridge\Monolog\Logger;

use Ign\Bundle\GincoBundle\Services\DEEGeneration\AbstractDEEGenerator;
use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Exception\DEEException;
use Ign\Bundle\GincoBundle\Entity\Generic\QueryForm;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;

/**
 * Class DEEGenerator
 * Responsible of the GML export of the DEE
 *
 * @package Ign\Bundle\GincoBundle\Services\DEEGeneration
 */
class DEEGeneratorOcctax extends AbstractDEEGenerator {

	protected $twig; 

	
	// Class DEEModel
	protected $dee;

	// counter used to construct file-unique gml ids
	protected $gmlId;

	/**
	 * DEEGenerator constructor.
	 * @param $em
	 * @param $configuration
	 * @param $genericService
	 * @param $queryService
	 * @param $logger
	 */
	public function __construct($em, $configuration, $genericService, $queryService, $logger) {

		parent::__construct($em, $configuration, $genericService, $queryService, $logger) ;

		// Instantiate a twig environment (independant from the one which renders the site)
		$loader = new \Twig_Loader_Filesystem(__DIR__ . '/templates');
        $this->twig = new \Twig_Environment($loader, array(
            // 'cache' => __DIR__ . '/templates/cache',
            'cache' => false,
            'debug' => true,
        ));

		// Instantiate DEEModel
 		$this->dee = new DEEModel();
		
		// gmlId is generated as a sequence of integer
		$this->gmlId = 1;
	}

	/**
	 * Create the GML of the DEE for jdd with the id given.
	 * Write it in file $fileName.
	 * 
	 * Optionally, a message id can be passed to the function, in which case
	 * the function reports its progress percentage into the message table
	 *
	 * Principle:
	 * - create 4 intermediate files :
	 * - header and end of the gml file (independent from the submission)
	 * - observations
	 * - groups (computed from observations)
	 * - concatenate the intermediate files and delete them
	 *
	 * @param DEE $DEE
	 * @param $filePath
	 * @param Message|null $message RabbitMQ Message entity
	 * @return bool
	 * @throws DEEException
	 */
	public function generateDee(DEE $DEE, $filePath, Message $message = null) {
		
		$fileName = $filePath . DIRECTORY_SEPARATOR . basename($filePath) . ".xml" ;
		
		// Configure memory and time limit because the program ask a lot of resources
		ini_set("memory_limit", $this->configuration->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", 0);

		// Validated (published) submissions in the jdd, stored in the DEE line
		$submissionsIds= $DEE->getSubmissions();

		// Get the jdd and the data model
		$jdd = $DEE->getJdd();
		$model = $jdd->getModel();

		// -- Create a query object : the query must find all lines with given submission_ids
		// And print a list of all fields in the model
		$queryForm = new QueryForm();

		// Get all table fields for model
		$tableFields = $this->em->getRepository('IgnGincoBundle:Metadata\TableField')->getTableFieldsForModel($model);
		// Get all Form Fields for Model
		$formFields = $this->em->getRepository('IgnGincoBundle:Metadata\FormField')->getFormFieldsFromModel($model->getId());

		// -- Criteria fields for the query : we only add SUBMISSION_ID
		// -- Result fields for the query : all fields of the model
		foreach ($formFields as $formField) {
			$data = $formField->getData()->getData();
			$format = $formField->getFormat()->getFormat();

			// Search criteria
			switch ($data) {
				case 'SUBMISSION_ID':
					// Add submissions ids as an array, it will result in a x OR y OR z
					$queryForm->addCriterion($format, 'SUBMISSION_ID', $submissionsIds);
					break;
			}
			// Result columns
			$queryForm->addColumn($format, $data);
		}

		// -- Generate the SQL Request
		
		// To generate unique ids for the gml, we put a marker wich is replaced by an id afterwards
		$gml_id = "'ID#GMLID#'"; // enclose it in simple quotes to be recognized as a string in ST_AsGML
		
		$options = array(
			'geometry_format' => 'gml',
			'geometry_srs' => 4326,
			'gml_precision' => 8,
			'gml_id' => $gml_id,
			'datetime_format' => 'YYYY-MM-DD"T"HH24:MI:SSTZ'
		);

		// Get the mappings for the query form fields
		$queryForm = $this->queryService->setQueryFormFieldsMappings($queryForm);
		$mappingSet = $queryForm->getFieldMappingSet($queryForm);

		// Fake user params, OK
		$userInfos = [
			"providerId" => NULL,
			"DATA_QUERY_OTHER_PROVIDER" => true,
			"EDIT_DATA_OWN" => true,
			"EDIT_DATA_PROVIDER" => true,
			"EDIT_DATA_ALL" => true
		];
		
		$select = $this->genericService->generateSQLSelectRequest('RAW_DATA', $queryForm->getColumns(), $mappingSet, $userInfos, $options);
		$from = $this->genericService->generateSQLFromRequest('RAW_DATA', $mappingSet);
		$where = $this->genericService->generateSQLWhereRequest('RAW_DATA', $queryForm->getCriteria(), $mappingSet, $userInfos);
		$sqlPKey = $this->genericService->generateSQLPrimaryKey('RAW_DATA', $mappingSet);
		$order = " ORDER BY " . $sqlPKey;
		$sql = $select . $from . $where . $order;

		// Count Results
		$total = $this->queryService->getQueryResultsCount($from, $where);

		// Report message progress if given
		if ($message) {
			$message->setLength($total);
			$message->setProgress(0);
			$this->em->flush();
		}
		
		// -- Export results to a GML file
		
		if ($total != 0) {
			
			// Opens a file for observations ($filename."_observations")
			$pathExists = is_dir($filePath) || mkdir($filePath, 0755, true);
			if (!$pathExists) {
				throw new DEEException("Error: could not create directory: $filePath");
			}
			$fileNameObservations = $fileName . "_observations";
			$out = fopen($fileNameObservations, 'w');
			if (!$out) {
				throw new DEEException("Error: could not open (w) file: $fileName");
			}
			fclose($out);
			
			// (Re)start gmlId for each file
			$this->gmlId = 1;
			
			// array of groups (regroupements)
			$groups = array();
			
			// -- Write beginning and end of the GML
			$fileNameHeader = $fileName . "_header";
			$this->generateHeaderGML($fileNameHeader);
			
			$fileNameEnd = $fileName . "_end";
			$this->generateEndGML($fileNameEnd);
			
			// -- Batch execute the request, and write observations to the output file
			$batchLines = 1000;
			$batches = ceil($total / $batchLines);

			// Stop if message has been cancelled externally
			$stop = false;

			for ($i = 0; $i < $batches; $i ++) {
				if ($message) {
					// Check if message has been cancelled externally; if yes, just exit the loop
					// (DEE cancellation is done after)
					$this->em->refresh($message);
					if ($message->getStatus() == Message::STATUS_TOCANCEL) {
						$stop = true;
						break;
					}
				}
				
				$batchSQL = $sql . " LIMIT $batchLines OFFSET " . $i * $batchLines;
				
				// -- Execute query and put results in a formatted array of strings
				$results = $this->queryService->getQueryResults($batchSQL);

				// Put lines in a formatted array
				$resultsArray = array();
				foreach ($results as $line) {
					$resultLine = array();
					foreach ($tableFields as $tableField) {
						$key = strtolower($tableField->getName());
						$value = $line[$key];
						$data = $tableField->getData()->getData();

						if ($value == null) {
							$resultLine[$data] = '';
						} else {
							$type = $tableField->getData()->getUnit()->getType();
							switch ($type) {
								case 'ARRAY':
									// Just sanitize string (remove "", {}, and [])
									$bad = array("[", "]", "\"", "'", "{", "}");
									$value = str_replace($bad, "", $value);
									$resultLine[$data] = $value;
									break;
								
								case "CODE":
								default:
									// Default case : String or numeric value
									$resultLine[$data] = $value;
									break;
							}
						}
					}
					$resultsArray[] = $resultLine;
				}
				
				// Write the GML in the output file
				$params = array(
					'site_name' => $this->configuration->getConfig('site_name', 'Plateforme GINCO-SINP')
				);
				$this->generateObservationsGML($resultsArray, $fileNameObservations, $params, $message, $i * $batchLines, $total);
				
				// Generate Group of observations (identified by "identifiantregroupementpermanent")
				// for each batch step, complete the $groups array
				$groups = $this->dee->groupObservations($resultsArray, $groups, $params);
			}

			// -- Write the "groups" file
			$fileNameGroups = $fileName . "_groups";
			if (!$stop) {
				$this->generateGroupsGML($groups, $fileNameGroups);
			}

			// -- Put the 4 intermediate files together and delete them
			if (!$stop) {
				system("cat $fileNameHeader $fileNameGroups $fileNameObservations $fileNameEnd > $fileName");
			}
			if (is_file($fileNameHeader)) unlink($fileNameHeader);
			if (is_file($fileNameGroups)) unlink($fileNameGroups);
			if (is_file($fileNameObservations)) unlink($fileNameObservations);
			if (is_file($fileNameEnd)) unlink($fileNameEnd);
		}
		return $total != 0;
	}

	/**
	 * Generate the observations part of the gml for the DEE
	 * and write it to an output (intermediate) file.
	 * Write in "append" mode, so the file can be writed to by batches.
	 *
	 * @param $observations array batch of observations
	 * @param $outputFile string file name to write.
	 * @param null $params array associative id of parameters
	 * @param null $message Message
	 * @param int $startLine start line of the batch in the entire list of observations
	 * @param int $total total nb of the entire list of observations
	 * @throws DEEException
	 */
	protected function generateObservationsGML($observations, $outputFile, $params = null, $message= null, $startLine = 0, $total = 0) {
		// Open the file in append mode
		$out = fopen($outputFile, 'a');
		if (!$out) {
			throw new DEEException("Error: could not open (a) file: $outputFile");
		}
		
		// Write Observations
		foreach ($observations as $index => $observation) {
			$observation = $this->dee->formatDates($observation);
			$observation = $this->dee->transformCodes($observation);
			
			if (!empty($observation['orgtransformation'])) {
				$orgTransformation = $observation['orgtransformation'];
			} else {
				$orgTransformation = (isset($params['site_name'])) ? $params['site_name'] : 'Plateforme GINCO-SINP';
			}
			$observation = $this->dee->fillValues($observation, array(
				'orgtransformation' => $orgTransformation
			));
			
			$observation = $this->dee->fillValues($observation, array(
				'deedatetransformation' => (date('c'))
			));
			$observation = $this->dee->specialCharsXML($observation);
			$observation = $this->dee->structureObservation($observation);
			
			fwrite($out, $this->strReplaceBySequence("#GMLID#", $this->generateObservation($observation)));
			
			if ($message) {
				// Every 1, 10, 100 or 1000 lines: check if message has been cancelled, and report progress
				$progress = $startLine + $index + 1;
				if (($total <= 100) || ($total <= 1000 && ($progress % 10 == 0)) || ($total <= 10000 && ($progress % 100 == 0)) || ($progress % 1000 == 0)) {

					// Check if message has been cancelled externally; if yes, just return
					// (DEE cancellation is done at a upper level)
					$this->em->refresh($message);
					if ($message->getStatus() == Message::STATUS_TOCANCEL) {
						fclose($out);
						return;
					}

					// Report message progress if given
					$message->setProgress($progress);
					$this->em->flush();
					// uncomment to see process runnning.. slowly
					// sleep(1);
				}
			}
		}
		// Close
		fclose($out);
	}

	/**
	 * Generate the groups part of the gml for the DEE
	 * and write it to an output (intermediate) file.
	 *
	 * @param
	 *        	$groups
	 * @param
	 *        	$outputFile
	 * @throws DEEException
	 */
	protected function generateGroupsGML($groups, $outputFile) {
		// Open the file in write mode
		$out = fopen($outputFile, 'w');
		if (!$out) {
			throw new DEEException("Error: could not open (w) file: $outputFile");
		}
		// Write groups
		foreach ($groups as $group) {
			fwrite($out, $this->strReplaceBySequence("#GMLID#", $this->generateRegroupement($group)));
		}
		// Close
		fclose($out);
	}

	/**
	 * Generate the header part of the gml for the DEE
	 * and write it to an output (intermediate) file.
	 *
	 * @param
	 *        	$outputFile
	 * @throws DEEException
	 */
	protected function generateHeaderGML($outputFile) {
		// Open the file in write mode
		$out = fopen($outputFile, 'w');
		if (!$out) {
			throw new DEEException("Error: could not open (w) file: $outputFile");
		}
		// Write GML header
		fwrite($out, $this->strReplaceBySequence("#GMLID#", $this->twig->render('header.xml')));
		
		// Close
		fclose($out);
	}

	/**
	 * Generate the end part of the gml for the DEE
	 * and write it to an output (intermediate) file.
	 *
	 * @param
	 *        	$outputFile
	 * @throws DEEException
	 */
	protected function generateEndGML($outputFile) {
		// Open the file in write mode
		$out = fopen($outputFile, 'w');
		if (!$out) {
			throw new DEEException("Error: could not open (w) file: $outputFile");
		}
		// Write GML header
		fwrite($out, $this->twig->render('end.xml'));
		// Close
		fclose($out);
	}

	/**
	 * Generate a string of the GML for one group
	 *
	 * @param
	 *        	$group
	 * @return string
	 */
	protected function generateRegroupement($group) {
		$part = $this->twig->render('regroupement.xml.twig', array(
			'regroupement' => $group
		));
		return $part;
	}

	/**
	 * Generate a string of the GML for one observation
	 *
	 * @param
	 *        	$observation
	 * @return string
	 */
	protected function generateObservation($observation) {
		$part = $this->twig->render('sujet_observation.xml.twig', array(
			'observation' => $observation
		));
		return $part;
	}

	/**
	 * Replaces all occurences of the string $needle
	 * by a sequence of integers starting at $this->gmlId
	 * Ex : "#NEEDLE#, #NEEDLE# and #NEEDLE#" => "1, 2 and 3"
	 * http://codepad.org/BjVwEy8u
	 *
	 * @param string $needle        	
	 * @param string $str        	
	 * @return string
	 */
	protected function strReplaceBySequence($needle, $str) {
		while (($pos = strpos($str, $needle)) !== false) {
			$str = substr_replace($str, $this->gmlId, $pos, strlen($needle));
			$this->gmlId ++;
		}
		return $str;
	}
}