<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Utils;

use Symfony\Component\DependencyInjection;
use \Symfony\Component\Config\FileLocator;
use Doctrine\DBAL\Connection;
use Monolog\Logger;
use Symfony\Component\HttpFoundation\RequestStack;
use Ign\Bundle\ConfigurateurBundle\Utils\TablesGeneration as TableGenerationBase2;
use Assetic\Exception\Exception;

/**
 * Extends table generation class for predefined request service.
 * GINCO specific class
 *
 * A predefined request deals with 5 tables :
 * predefined_request_group : group the requests (one group for one query dataset)
 * predefined_request : the requests (dataset_id is stocked here, it would have been more logical to
 * put it in request_group_asso : we would have been able to use the same request
 * for different datasets !)
 * predefined_request_group_asso : link a request to a group
 * predefined_request_criteria : the criteria of the request
 * predefined_request_result : the result of a request
 */
class PredefinedRequestGeneration extends TableGenerationBase2 {

	/**
	 * Creates the custom predefined requests
	 * For each request, the developer needs to give the criteria, results, label, requestName
	 *
	 * @param string $modelId
	 * @param string $tableName
	 */
	public function createPredefinedRequests($modelId, $tableSchema, $dbconn) {

		// Get the query dataset_id linked to the $modelId
		$sql = "SELECT dataset.dataset_id, dataset.label
					FROM metadata.dataset, metadata.model_datasets md
					WHERE dataset.type = 'QUERY'
					AND md.dataset_id = dataset.dataset_id
					AND md.model_id = $1";
		pg_prepare($dbconn, "", $sql);
		$result = pg_execute($dbconn, "", array(
			$modelId
		));
		$row = pg_fetch_assoc($result);
		$datasetId = $row['dataset_id'];
		$datasetLabel = $row['label'];

		// Add a group for the predefined request of the dataset
		$this->addPredefinedRequestGroup($datasetId, $datasetLabel, $datasetLabel, '1', $dbconn);

		// Describe custom requests
		// REQUEST 1 : group request
		$criteria = array(
			'cdnom',
			'geometrie',
			'nomcommune',
			'codedepartement',
			'codeen',
			'jourdatedebut',
			'jourdatefin',
			'occstatutbiogeographique',
			'organismegestionnairedonnee'
		);
		$results = array(
			'jourdatedebut',
			'jourdatefin',
			'nomcite',
			'observateuridentite',
			'observateurnomorganisme',
			'statutobservation',
			'dspublique',
			'identifiantpermanent',
			'jddmetadonneedeeid',
			'organismegestionnairedonnee',
			'orgtransformation',
			'sensible',
			'sensiniveau',
			'statutsource'
		);
		$label = 'critères les plus fréquents';
		$requestName = $datasetId . '_group_request';
		$this->createPredefinedRequest($datasetId, $tableSchema, $requestName, $criteria, $results, $label, $dbconn);

		// REQUEST 2 : par période
		$criteria = array(
			'cdnom',
			'jourdatedebut',
			'jourdatefin'
		);
		$label = 'par période d\'\'observation';
		$requestName = $datasetId . '_periode';
		$this->createPredefinedRequest($datasetId, $tableSchema, $requestName, $criteria, $results, $label, $dbconn);

		// REQUEST 3 : biogeographique
		$criteria = array(
			'cdnom',
			'occstatutbiogeographique'
		);
		$label = 'par statut bio-géographique';
		$requestName = $datasetId . '_biogeo';
		$this->createPredefinedRequest($datasetId, $tableSchema, $requestName, $criteria, $results, $label, $dbconn);

		// REQUEST 4 : organisme producteur de données
		$criteria = array(
			'cdnom',
			'organismegestionnairedonnee'
		);
		$label = 'par organisme producteur de données';
		$requestName = $datasetId . '_producteur';
		$this->createPredefinedRequest($datasetId, $tableSchema, $requestName, $criteria, $results, $label, $dbconn);

		// REQUEST 5 : par localisation
		$criteria = array(
			'cdnom',
			'geometrie',
			'nomcommune',
			'codedepartement',
			'codeen'
		);
		$label = 'par localisation';
		$requestName = $datasetId . '_localisation';
		$this->createPredefinedRequest($datasetId, $tableSchema, $requestName, $criteria, $results, $label, $dbconn);

		// REQUEST 6 : sensibilité
		$criteria = array(
			'sensialerte',
			'jddid'
		);
		$results = array(
			'cdnom',
			'cdref',
			'codedepartement',
			'jourdatefin',
			'identifiantpermanent',
			'occstatutbiologique',
			'PROVIDER_ID',
			'sensialerte',
			'sensible',
			'sensidateattribution',
			'sensimanuelle',
			'sensiniveau',
			'sensireferentiel',
			'sensiversionreferentiel'
		);
		$label = 'données à sensibiliser';
		$requestName = $datasetId . '_donnees_a_sensibiliser';
		$this->createPredefinedRequest($datasetId, $tableSchema, $requestName, $criteria, $results, $label, $dbconn);
	}

	/**
	 * Add a predefined request
	 *
	 * @param string $datasetId
	 * @param string $tableSchema
	 * @param string $requestName
	 * @param string $criteria
	 * @param string $results
	 * @param string $label
	 */
	public function createPredefinedRequest($datasetId, $tableSchema, $requestName, $criteria, $results, $label, $dbconn) {
		// Will the tables contain the columns the request needs?
		$sqlCriteria = "SELECT ff.data, ff.format
					FROM metadata.form_field ff, metadata.dataset_forms df
					WHERE df.dataset_id = $1
					AND df.format = ff.format
					AND ff.data IN('" . implode("','", $criteria) . "')";
		pg_prepare($dbconn, "", $sqlCriteria);
		$stmtCriteria = pg_execute($dbconn, "", array(
			$datasetId
		));

		$sqlResults = "SELECT ff.data, ff.format
					FROM metadata.form_field ff, metadata.dataset_forms df
					WHERE df.dataset_id = $1
					AND df.format = ff.format
					AND ff.data IN('" . implode("','", $results) . "')";
		pg_prepare($dbconn, "", $sqlResults);
		$stmtResults = pg_execute($dbconn, "", array(
			$datasetId
		));

		// the fields needed are present in the tables
		if (pg_num_rows($stmtCriteria) == count($criteria) && pg_num_rows($stmtResults) == count($results)) {

			// Add the predefined request
			$this->addPredefinedRequest($requestName, $tableSchema, $datasetId, $label, $dbconn);

			// Link the request with the group
			$this->addPredefinedRequestGroupAsso($datasetId, $requestName, $dbconn);

			// Add the criteria
			while ($row = pg_fetch_assoc($stmtCriteria)) {
				$data = $row['data'];
				$form = $row['format'];
				if ($data == 'cdnom') {
					$value = '183716';
					$fixed = 'FALSE';
				} elseif ($data == 'sensialerte') {
					$value = '1';
					$fixed = 'TRUE';
				} else {
					$value = '';
					$fixed = 'FALSE';
				}
				$this->addPredefinedRequestCriterion($requestName, $form, $data, $value, $fixed, $dbconn);
			}

			// Add the results
			while ($row = pg_fetch_assoc($stmtResults)) {
				$data = $row['data'];
				$form = $row['format'];
				$this->addPredefinedRequestResult($requestName, $form, $data, $dbconn);
			}
		}
	}

	/**
	 * Add a predefined request group
	 *
	 * @param string $groupName
	 *        	the datasetId
	 * @param string $label
	 *        	the datasetLabel
	 * @param string $definition
	 *        	the datasetLabel
	 * @param string $position
	 *        	always 1
	 */
	public function addPredefinedRequestGroup($groupName, $label, $definition, $position, $dbconn) {
		// Add predefined request group (the dataset)
		$sql = "INSERT INTO website.predefined_request_group(group_name, label, definition, position) VALUES ('" . $groupName . "','" . $label . "','" . $definition . "', '" . $position . "');";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}

	/**
	 * Add values in predefined_request table
	 *
	 * @param string $requestName
	 * @param string $schemaCode
	 * @param string $datasetId
	 * @param string $abel
	 */
	public function addPredefinedRequest($requestName, $schemaCode, $datasetId, $label, $dbconn) {
		// Add the predefined request
		$sql = "INSERT INTO website.predefined_request (request_name, schema_code, dataset_id, label, definition, date) VALUES ('" . $requestName . "','" . $schemaCode . "','" . $datasetId . "', '" . $label . "', null,  now());";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}

	/**
	 * Add values in predefined_request_group_asso table
	 *
	 * @param string $groupName
	 * @param string $requestName
	 */
	public function addPredefinedRequestGroupAsso($groupName, $requestName, $dbconn) {
		// Link the request with the group
		$sql = "INSERT INTO website.predefined_request_group_asso(group_name, request_name, position) VALUES ('" . $groupName . "', '" . $requestName . "', 1);";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}

	/**
	 * Add criterion to the request
	 *
	 * @param string $requestName
	 * @param string $format
	 * @param string $data
	 * @param string $value
	 * @param string $fixed
	 */
	public function addPredefinedRequestCriterion($requestName, $format, $data, $value, $fixed, $dbconn) {
		// Add the predefined request criterion
		$sql = "INSERT INTO website.predefined_request_criteria (request_name, format, data, value, fixed) VALUES ('" . $requestName . "','" . $format . "','" . $data . "','" . $value . "','" . $fixed . "');";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}

	/**
	 * Add result to the request
	 *
	 * @param string $requestName
	 * @param string $format
	 * @param string $data
	 */
	public function addPredefinedRequestResult($requestName, $format, $data, $dbconn) {
		// Add the predefined request results
		$sql = "INSERT INTO website.predefined_request_result (request_name, format, data) VALUES ('" . $requestName . "','" . $format . "','" . $data . "');";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}
}