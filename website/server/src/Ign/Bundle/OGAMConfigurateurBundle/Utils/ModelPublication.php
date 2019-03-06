<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\DBAL\DBALException;
use Doctrine\ORM\EntityManager;

use Symfony\Component\Debug\Exception\ContextErrorException;

use Ign\Bundle\GincoBundle\Entity\Metadata\Model;

use Monolog\Logger;





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
	
	/**
	 *
	 * @var EntityManager
	 */
	protected $entityManager ;

	public function __construct(EntityManager $entityManager, Logger $logger, $adminName, $adminPassword) {
		$this->entityManager = $entityManager ;
		parent::__construct($entityManager->getConnection(), $logger, $adminName, $adminPassword);
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
	public function publishModel(Model $model) {
		
		try {
			if ($this->isPublishable($model)) {
				$dbconn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());
				
				pg_query($dbconn, "BEGIN");
				
				// on ne crée le query dataset et les formulaires qu'à la première publication.
				if ($model->getQueryDatasets()->isEmpty()) {
				
					$datasetId = $this->copyUtils->createQueryDataset($model->getId(), $dbconn);
					$this->copyUtils->createFormFields($model->getId(), $datasetId, $dbconn);
				}
				
				// Generate the tables
				if ($this->tablesGeneration && $model->getPublishedAt() == null) {
					$result = $this->tablesGeneration->createTables($model->getId(), $dbconn);
					if (!$result) {
						pg_query($dbconn, "ROLLBACK");
						return false;
					}
				}
				
				pg_query($dbconn, "COMMIT");
				
				$model->setStatus(Model::PUBLISHED) ;
				$model->setPublishedAt(new \DateTime()) ;
				$this->entityManager->flush() ;
				
				return true;
			} else {
				return false;
			}
		} catch (ContextErrorException $e) {
			$this->logger->error($e);
			pg_query($dbconn, "ROLLBACK");
			return false;
		} catch (DBALException $e) {
			$this->logger->error($e);
			pg_query($dbconn, "ROLLBACK");
			return false;
		} finally {
			if (isset($dbconn)) {
				pg_close($dbconn);
			}
		}
	}

	
	/**
	 * Checks if, for a given model, every table has at least one non-technical field
	 *
	 * @param $modelId :
	 *        	the id of the model
	 * @return bool
	 */
	private function modelTablesHaveFields(Model $model) {
		$sql = "SELECT mt.table_id AS tableformat, COUNT(tfi.data) AS nbfields
				FROM metadata.model_tables mt
				LEFT JOIN metadata.table_field tfi ON mt.table_id = tfi.format
				WHERE mt.model_id = ?
				GROUP BY mt.table_id;";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $model->getId());
		$stmt->execute();
		$tablesHaveFields = true;
		while ($row = $stmt->fetch()) {
			// 4 is the nb of technical fields in each table: PROVIDER_ID, USER_LOGIN, SUBMISSION_ID, OGAM_ID
			// todo : change if necessary
			if ($row['nbfields'] <= 4) {
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
	private function modelHasGeometricalField(Model $model) {
		$sql = "SELECT COUNT(data.unit) AS nbgeomfield
				FROM metadata.model_tables mt
				LEFT JOIN metadata.field f ON mt.table_id = f.format
				LEFT JOIN metadata.data data ON f.data = data.data
				WHERE mt.model_id = ?
				AND data.unit = 'GEOM';";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $model->getId());
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
				FROM metadata.dataset d
				INNER JOIN metadata.model_datasets as md ON md.dataset_id = d.dataset_id
				INNER JOIN metadata.model as m ON m.id = md.model_id
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
	public function isPublishable(Model $model) {
		
		$publishable = (!$model->isPublished() && $model->hasTables() && $this->modelTablesHaveFields($model) && $this->modelHasGeometricalField($model));
		return $publishable;
	}



}