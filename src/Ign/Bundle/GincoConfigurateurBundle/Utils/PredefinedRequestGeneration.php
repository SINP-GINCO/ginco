<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Utils\TablesGeneration as TableGenerationBase2;

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
	 * For each request, the developer needs to give the criteria, results, label, requestId
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

		// Get predefined request group next val sequence id
		$sqlPRGroupIdNextval = "SELECT nextval('predefined_request_group_group_id_seq');";
		pg_prepare($dbconn, "", $sqlPRGroupIdNextval);
		$stmtPRGroupIdNextval = pg_execute($dbconn, "", array());
		$groupId = pg_fetch_row($stmtPRGroupIdNextval)[0] +1;


		// Add a group for the predefined request of the dataset
		$this->addPredefinedRequestGroup($datasetLabel, $datasetLabel, '1', $dbconn);

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
		//$requestId = $datasetId . '_group_request';
		$this->createPredefinedRequest($groupId, $datasetId, $tableSchema, $criteria, $results, $label, $dbconn);

		// REQUEST 2 : par période
		$criteria = array(
			'cdnom',
			'jourdatedebut',
			'jourdatefin'
		);
		$label = 'par période d\'\'observation';
		//$requestId = $datasetId . '_periode';
		$this->createPredefinedRequest($groupId, $datasetId, $tableSchema, $criteria, $results, $label, $dbconn);

		// REQUEST 3 : biogeographique
		$criteria = array(
			'cdnom',
			'occstatutbiogeographique'
		);
		$label = 'par statut bio-géographique';
		//$requestId = $datasetId . '_biogeo';
		$this->createPredefinedRequest($groupId, $datasetId, $tableSchema, $criteria, $results, $label, $dbconn);

		// REQUEST 4 : organisme producteur de données
		$criteria = array(
			'cdnom',
			'organismegestionnairedonnee'
		);
		$label = 'par organisme producteur de données';
		//$requestId = $datasetId . '_producteur';
		$this->createPredefinedRequest($groupId, $datasetId, $tableSchema, $criteria, $results, $label, $dbconn);

		// REQUEST 5 : par localisation
		$criteria = array(
			'cdnom',
			'geometrie',
			'nomcommune',
			'codedepartement',
			'codeen'
		);
		$label = 'par localisation';
		//$requestId = $datasetId . '_localisation';
		$this->createPredefinedRequest($groupId, $datasetId, $tableSchema, $criteria, $results, $label, $dbconn);

		// REQUEST 6 : sensibilité
		$criteria = array(
			'sensialerte',
			'jddid'
		);
		$results = array(
			'cdnom',
			'cdref',
			'codedepartementcalcule',
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
		//$requestId = $datasetId . '_donnees_a_sensibiliser';
		$this->createPredefinedRequest($groupId, $datasetId, $tableSchema, $criteria, $results, $label, $dbconn);
	}

	/**
	 * Add a predefined request
	 *
	 * @param string $groupId
	 * @param string $datasetId
	 * @param string $tableSchema
	 * @param string $criteria
	 * @param string $results
	 * @param string $label
	 */
	public function createPredefinedRequest($groupId, $datasetId, $tableSchema, $criteria, $results, $label, $dbconn) {
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

			// Get the sequence nextval for request_id
			$sqlPRIdNextval = "SELECT nextval('predefined_request_request_id_seq');";
			pg_prepare($dbconn, "", $sqlPRIdNextval);
			$stmtPRIdNextval = pg_execute($dbconn, "", array());
			$requestId = pg_fetch_row($stmtPRIdNextval)[0]+1;

			// Add the predefined request
			$this->addPredefinedRequest($tableSchema, $datasetId, $label, $dbconn);

			// Link the request with the group
			$this->addPredefinedRequestGroupAsso($groupId, $requestId, $dbconn);

			// Add the criteria
			while ($row = pg_fetch_assoc($stmtCriteria)) {
				$data = $row['data'];
				$form = $row['format'];
				if ($data == 'cdnom') {
					$value = '183716';
				} elseif ($data == 'sensialerte') {
					$value = '1';
				} else {
					$value = '';
				}
				$this->addPredefinedRequestCriterion($requestId, $form, $data, $value, $dbconn);
			}

			// Add the results
			while ($row = pg_fetch_assoc($stmtResults)) {
				$data = $row['data'];
				$form = $row['format'];
				$this->addPredefinedRequestColumn($requestId, $form, $data, $dbconn);
			}
		}
	}

	/**
	 * Add a predefined request group
	 *
	 * @param string $label
	 *        	the datasetLabel
	 * @param string $definition
	 *        	the datasetLabel
	 * @param string $position
	 *        	always 1
	 */
	public function addPredefinedRequestGroup($label, $definition, $position, $dbconn) {
		// Add predefined request group (the dataset)
		$sql = "INSERT INTO website.predefined_request_group(label, definition, position) VALUES ('" . $label . "','" . $definition . "', '" . $position . "');";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}

	/**
	 * Add values in predefined_request table
	 *
	 * @param string $requestId
	 * @param string $schemaCode
	 * @param string $datasetId
	 * @param string $abel
	 */
	public function addPredefinedRequest($schemaCode, $datasetId, $label, $dbconn) {
		// Add the predefined request
		$sql = "INSERT INTO website.predefined_request (schema_code, dataset_id, label, definition, date, user_login, is_public) VALUES ('" . $schemaCode . "','" . $datasetId . "', '" . $label . "', null,  now(), null, TRUE);";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}

	/**
	 * Add values in predefined_request_group_asso table
	 *
	 * @param string $groupId
	 * @param string $requestId
	 */
	public function addPredefinedRequestGroupAsso($groupId, $requestId, $dbconn) {
		// Link the request with the group
		$sql = "INSERT INTO website.predefined_request_group_asso(group_id, request_id, position) VALUES ('" . $groupId . "', '" . $requestId . "', 1);";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}

	/**
	 * Add criterion to the request
	 *
	 * @param string $requestId
	 * @param string $format
	 * @param string $data
	 * @param string $value
	 */
	public function addPredefinedRequestCriterion($requestId, $format, $data, $value, $dbconn) {
		// Add the predefined request criterion
		$sql = "INSERT INTO website.predefined_request_criterion (request_id, format, data, value) VALUES ('" . $requestId . "','" . $format . "','" . $data . "','" . $value . "');";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}

	/**
	 * Add result to the request
	 *
	 * @param string $requestId
	 * @param string $format
	 * @param string $data
	 */
	public function addPredefinedRequestColumn($requestId, $format, $data, $dbconn) {
		// Add the predefined request results
		$sql = "INSERT INTO website.predefined_request_column (request_id, format, data) VALUES ('" . $requestId . "','" . $format . "','" . $data . "');";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}
}