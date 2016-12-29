<?php
namespace Ign\Bundle\ConfigurateurBundle\Utils;

use Doctrine\DBAL\DriverManager;
use Doctrine\DBAL\Connection;
use Doctrine\ORM\ORMException;
use Ign\Bundle\ConfigurateurBundle\Entity\Dataset;
use Ign\Bundle\ConfigurateurBundle\Entity\TableFormat;
use Monolog\Logger;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Assetic\Exception\Exception;

/**
 * Utility class for publication of a model into a database.
 *
 * @author Gautam Pastakia
 *
 */
class ModelPublication extends DatabaseUtils {

	/**
	 *
	 * @var : the tables generation service
	 */
	protected $tablesGeneration;

	protected $copyUtils;

	public function __construct(Connection $conn, Logger $logger, $adminName, $adminPassword) {
		parent::__construct($conn, $logger, $adminName, $adminPassword);
	}

	public function setTablesGeneration($tablesGeneration) {
		$this->tablesGeneration = $tablesGeneration;
	}

	public function setCopyUtils($copyUtils) {
		$this->copyUtils = $copyUtils;
	}

	/**
	 * Publishes a model by copying all the data related to a specific model, then generates
	 * the model in the database.
	 *
	 * @param $modelId the
	 *        	id of the model
	 * @return true if publication succeded, false otherwise
	 */
	public function publishModel($modelId) {
		if ($this->copyUtils->isModelPresentInWorkSchema($modelId) && $this->isPublishable($modelId)) {
			$dbconn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());
			pg_query($dbconn, "BEGIN");
			if (!$this->copyUtils->copyData($modelId, $dbconn)) {
				pg_query($dbconn, "ROLLBACK");
				return false;
			}

			$destSchema = 'metadata';
			$this->copyUtils->copyFormat($modelId, $destSchema, false);
			$this->copyUtils->copyTableFormat($modelId, $destSchema, false);
			$this->copyUtils->copyTableTree($modelId, $destSchema, false);
			$this->copyUtils->copyField($modelId, $destSchema, false);
			$this->copyUtils->copyTableField($modelId, $destSchema, false);
			$this->copyUtils->copyModel($modelId, $destSchema, false);
			$this->copyUtils->copyModelTables($modelId, $destSchema, false);
			$datasetId = $this->copyUtils->createQueryDataset($modelId, $dbconn);
			$this->copyUtils->createFormFields($modelId, $datasetId, $dbconn);

			// Generate the tables
			if ($this->tablesGeneration) {
				$result = $this->tablesGeneration->createTables($modelId, $dbconn);
				if (!$result) {
					pg_query($dbconn, "ROLLBACK");
					pg_close($dbconn);
					return false;
				}
			}
			pg_query($dbconn, "COMMIT");
			pg_close($dbconn);
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Returns true if a model is published.
	 *
	 * @param $modelid the
	 *        	id of the model
	 *
	 * @return boolean
	 */
	public function isPublished($modelId) {
		$published = false;

		$sql = "SELECT count(*) from metadata.model WHERE id = ?";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		if ($stmt->fetchColumn(0) === 1) {
			$published = true;
		}

		$this->conn->close();

		return $published;
	}

	/**
	 * Returns true if it is possible to publish a model.
	 * The model :
	 * - must NOT be published
	 * - must have at least one table
	 * - must have at least on field in all its tables.
	 *
	 * @param $modelId: the
	 *        	of the model
	 * @return boolean
	 */
	public function isPublishable($modelId) {
		$publishable = (!$this->isPublished($modelId) && $this->modelHasTables($modelId) && $this->modelTablesHaveFields($modelId) && $this->modelHasGeometricalField($modelId));

		return $publishable;
	}

	/**
	 * Checks if, for a given model, the model has at least one table
	 *
	 * @param $modelId :
	 *        	the id of the model
	 * @return bool
	 */
	public function modelHasTables($modelId) {
		$sql = "SELECT count(*) from metadata_work.model_tables WHERE model_id = ?";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		$hasTables = ($stmt->fetchColumn(0) >= 1);

		$this->conn->close();

		return $hasTables;
	}

	/**
	 * Checks if, for a given model, every table has at least one non-technical field
	 *
	 * @param $modelId :
	 *        	the id of the model
	 * @return bool
	 */
	public function modelTablesHaveFields($modelId) {
		$sql = "SELECT mt.table_id AS tableformat, COUNT(tfi.data) AS nbfields
				FROM metadata_work.model_tables mt
				LEFT JOIN metadata_work.table_field tfi ON mt.table_id = tfi.format
				WHERE mt.model_id = ?
				GROUP BY mt.table_id;";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		$tablesHaveFields = true;
		while ($row = $stmt->fetch()) {
			// 3 is the nb of technical fields in each table: PROVIDER_ID, SUBMISSION_ID, OGAM_ID
			// todo : change if necessary
			if ($row['nbfields'] <= 3) {
				$tablesHaveFields = false;
			}
		}

		return $tablesHaveFields;
	}

	/**
	 * Checks if, for a given model, at least one of its tables has a geometrical field
	 *
	 * @param string $modelId
	 *        	the id of the model
	 * @return bool
	 */
	public function modelHasGeometricalField($modelId) {
		$sql = "SELECT COUNT(data.unit) AS nbgeomfield
				FROM metadata_work.model_tables mt
				LEFT JOIN metadata_work.field f ON mt.table_id = f.format
				LEFT JOIN metadata_work.data data ON f.data = data.data
				WHERE mt.model_id = ?
				AND data.unit = 'GEOM';";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		$modelHasGeometricalField = true;
		$row = $stmt->fetch();
		if ($row['nbgeomfield'] < 1) {
			$modelHasGeometricalField = false;
		}

		return $modelHasGeometricalField;
	}

	/**
	 * Returns the names of the import models related to the model that are not yet published.
	 *
	 * @param string $modelId
	 *        	the id of the model
	 * @return array the names of the unpublished import models.
	 */
	public function getUnpublishedImportModelsNames($modelId) {
		$sql = "SELECT d.label
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.model_datasets as md ON md.dataset_id = d.dataset_id
				INNER JOIN metadata_work.model as m ON m.id = md.model_id
				WHERE m.id = ?
				AND d.dataset_id NOT IN (
					SELECT d.dataset_id
					FROM metadata.dataset d
					INNER JOIN metadata.model_datasets as md ON md.dataset_id = d.dataset_id
					INNER JOIN metadata.model as m ON m.id = md.model_id
					WHERE m.id = ?
				)";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->bindValue(2, $modelId);
		$stmt->execute();

		$importModelNames = array();
		while ($row = $stmt->fetch()) {
			array_push($importModelNames, $row['label']);
		}

		return $importModelNames;
	}
}