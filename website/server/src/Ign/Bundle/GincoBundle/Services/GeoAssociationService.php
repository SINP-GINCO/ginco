<?php
namespace Ign\Bundle\GincoBundle\Services;

use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Mapping as ORM;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
use Symfony\Bridge\Monolog\Logger;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class GeoAssociation
 * Computing geo associations:
 *
 * 1- Fill mapping.observation_<entity> tables (with entity in {geometrie, commune, maille, departement})
 * (#523) Lors de l'intégration des données, le calcul des rattachements administratifs est effectué selon l'algo suivant :
 * Pour chaque observation :
 * - si une géométrie est présente : selon le type de géométrie, un calcul est effectué pour rattacher aux communes, aux mailles et aux départements.
 * - si soit typeinfogeocommune = 1 ou typeinfogeomaille = 1 ou typeinfogeodepartement = 1, alors on calcule les rattachements à toutes les couches inférieures et supérieures à la couche qui à son typeinfogeo à 1, en prenant comme base de calcul cette couche.
 * puis, dans le cas où il n'y a ni géométrie, ni typeinfogeo à 1 , alors :
 * - si le champ "codeCommune" est renseigné, un calcul est effectué pour rattacher aux communes, aux mailles et aux départements.
 * - si le champ "codeMaille" est renseigné, un calcul est effectué pour rattacher aux communes, aux mailles et aux départements.
 * - si le champ "codeDepartement" est renseigné, un calcul est effectué pour rattacher aux communes, aux mailles et aux départements.
 * 
 * 2- fill calculated fields in raw_data tables
 *
 * @package Ign\Bundle\GincoBundle\Services
 */
class GeoAssociationService {

	/**
	 * The doctrine service
	 *
	 * @var Service
	 */
	protected $doctrine;

	/**
	 *
	 * @var Logger
	 */
	protected $logger;

	/**
	 *
	 * @var Connexion
	 */
	protected $conn;

	/**
	 * Geo association constructor
	 *
	 * @param
	 *        	$em
	 * @param
	 *        	$configuration
	 * @param
	 *        	$queryService
	 * @param
	 *        	$logger
	 */
	public function __construct($doctrine, $logger) {
		$this->logger = $logger;
		$this->doctrine = $doctrine;
		$this->conn = $this->doctrine->getManager()->getConnection();
	}
	
	// Define geo association conditions for each entity
	protected $geoAssociationFromCommuneFilter = " WHERE m.geometrie IS NULL 
		AND (m.typeinfogeocommune = '1'
			OR (m.codecommune IS NOT NULL 
				AND m.typeinfogeomaille is distinct from '1' 
				AND m.typeinfogeodepartement is distinct from '1')) ";

	protected $geoAssociationFromMailleFilter = " WHERE m.geometrie IS NULL 
		AND m.typeinfogeocommune is distinct from '1' 
		AND (m.typeinfogeomaille = '1' 
			OR (m.codecommune IS NULL
				AND m.codemaille IS NOT NULL 
				AND m.typeinfogeodepartement is distinct from '1')) ";

	protected $geoAssociationFromDepartementFilter = " WHERE m.geometrie IS NULL 
		AND m.typeinfogeocommune is distinct from '1' 
		AND m.typeinfogeomaille is distinct from '1' 
		AND (m.typeinfogeodepartement = '1'
			OR (m.codecommune IS NULL
				AND m.codemaille IS NULL
				AND m.codedepartement IS NOT NULL))";

	/**
	 * Compute geo associations
	 * - delete existing associations according to input parameters
	 * - calculate and create (insert) new geo associations
	 *
	 * @param unknown $providerId        	
	 * @param unknown $submission        	
	 * @param unknown $jdd        	
	 * @param String $entity        	
	 */
	public function computeGeoAssociation($providerId, $submission, $jdd, $entity = null) {
		$this->logger->debug('computeGeoAssociation');
		
		/* ------- Get concerned submission(s) and table(s) in raw_data -------- */
		
		// Compute geo associations for a jdd
		if ($jdd != null) {
			
			$submissionId = null;
			$submissionIdArray = array();
			
			$submissions = $jdd->getActiveSubmissions();
			foreach ($submissions as $key => $valuesField) {
				$submissionIdArray[] = $valuesField->getId();
			}
			
			$tableFormats = $jdd->getModel()->getTables();
			
		// Compute geo associations for a submission
		} elseif ($submission != null) {
			
			$submissionId = $submission->getId();
			$submissionIdArray = array();
			
			$tableFormats = $submission->getJdd()
				->getModel()
				->getTables();
			
		// Compute geo association for an entity (commune or departement)
		} elseif ($entity != null) {
			if ($entity != 'commune' and $entity != 'departement') {
				$this->logger->debug("Error while computing geo associations : entity not known");
				throw new \Exception("Error while computing geo associations : entity not known");
			}
			
			$submissionId = null;
			$submissionIdArray = array();
			$tableFormats = $this->doctrine->getRepository('Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat', 'metadata')->getAllTableFormats();
			
		// All input parameters are null : throw exception
		} else {
			$this->logger->debug("Error while computing geo associations : submission, jdd and entity are null");
			throw new \Exception("Error while computing geo associations : submission, jdd and entity are null");
		}
		
		// Get filters corresponding to input parameters
		$filter = $this->filter($providerId, $submissionId, $submissionIdArray);
		
		/* ------------- DELETE ------------ */
		$deleteObsGeometrie = "DELETE FROM mapping.observation_geometrie AS obs";
		$deleteObsCommune = "DELETE FROM mapping.observation_commune AS obs";
		$deleteObsMaille = "DELETE FROM mapping.observation_maille AS obs";
		$deleteObsDepartement = "DELETE FROM mapping.observation_departement AS obs";
		
		// Commune referential update
		if ($entity == 'commune') {
			$this->deleteForReferentielUpdate($deleteObsCommune, $this->geoAssociationFromCommuneFilter, $tableFormats);
		}
		
		// Departement referential update
		if ($entity == 'departement') {
			$this->deleteForReferentielUpdate($deleteObsDepartement, $this->geoAssociationFromDepartementFilter, $tableFormats);
		}
		
		// Delete geo associations to calculate it again (update for a submission or a jdd)
		if ($entity == null) {
			
			$obsToDeleteArray = array(
				$deleteObsGeometrie,
				$deleteObsCommune,
				$deleteObsMaille,
				$deleteObsDepartement
			);
			
			foreach ($tableFormats as $tableFormat) {
				foreach ($obsToDeleteArray as $obsToDelete) {
					$delete = "";
					$delete .= $obsToDelete;
					$leftJoin = " USING raw_data." . $tableFormat->getTableName() . " AS m WHERE m." . $tableFormat->getPrimaryKeys()[0] . " = obs.id_observation ";
					$delete .= $leftJoin . $filter . ";
					";
					$this->logger->debug('delete : ' . $delete);
					$stmt = $this->conn->prepare($delete);
					$stmt->execute();
				}
			}
		}
		
		/* ------------- CALCULATE ------------------ */
		foreach ($tableFormats as $tableFormat) {
			// Calculate from and to commune
			if ($entity == 'commune') {
				$this->entityToGeom('commune', $tableFormat, $filter);
				$this->entityAToEntityB('commune', 'commune', $tableFormat, $filter);
				$this->entityAToEntityB('commune', 'maille', $tableFormat, $filter);
				$this->entityAToEntityB('commune', 'departement', $tableFormat, $filter);
				$this->geomToEntity('commune', $tableFormat, $filter);
				$this->entityAToEntityB('maille', 'commune', $tableFormat, $filter);
				$this->entityAToEntityB('departement', 'commune', $tableFormat, $filter);
			}
			// Calculate from and to departement
			if ($entity == 'departement') {
				$this->entityToGeom('departement', $tableFormat, $filter);
				$this->entityAToEntityB('departement', 'commune', $tableFormat, $filter);
				$this->entityAToEntityB('departement', 'maille', $tableFormat, $filter);
				$this->entityAToEntityB('departement', 'departement', $tableFormat, $filter);
				$this->geomToEntity('departement', $tableFormat, $filter);
				$this->entityAToEntityB('commune', 'departement', $tableFormat, $filter);
				$this->entityAToEntityB('maille', 'departement', $tableFormat, $filter);
			}
			// Calculate all
			if ($entity == null) {
				$this->entityToGeom('geom', $tableFormat, $filter);
				$this->entityToGeom('commune', $tableFormat, $filter);
				$this->entityToGeom('maille', $tableFormat, $filter);
				$this->entityToGeom('departement', $tableFormat, $filter);
				$this->geomToEntity('commune', $tableFormat, $filter);
				$this->entityAToEntityB('commune', 'commune', $tableFormat, $filter);
				$this->entityAToEntityB('maille', 'commune', $tableFormat, $filter);
				$this->entityAToEntityB('departement', 'commune', $tableFormat, $filter);
				$this->geomToEntity('maille', $tableFormat, $filter);
				$this->entityAToEntityB('commune', 'maille', $tableFormat, $filter);
				$this->entityAToEntityB('maille', 'maille', $tableFormat, $filter);
				$this->entityAToEntityB('departement', 'maille', $tableFormat, $filter);
				$this->geomToEntity('departement', $tableFormat, $filter);
				$this->entityAToEntityB('commune', 'departement', $tableFormat, $filter);
				$this->entityAToEntityB('maille', 'departement', $tableFormat, $filter);
				$this->entityAToEntityB('departement', 'departement', $tableFormat, $filter);
			}
			// Fill calculated fields
			$this->communeCalcule($tableFormat, $filter);
			$this->codeMailleCalcule($tableFormat, $filter);
			$this->codeDepartementCalcule($tableFormat, $filter);
		}
		return true;
	}

	/**
	 * Delete geo associations from and to a referential in observation_ tables.
	 * Used to update commune or departement referential
	 *
	 * @param String $deleteObsEntity        	
	 * @param String $geoAssociationFromEntityFilter        	
	 * @param Array[TableFormat] $tableFormats        	
	 */
	public function deleteForReferentielUpdate($deleteObsEntity, $geoAssociationFromEntityFilter, $tableFormats) {
		$this->logger->debug('deleteForReferentielUpdate');
		$deleteFromEntity = "";
		// Get uuid of observations whose geo associations are based on the updated referential
		foreach ($tableFormats as $tableFormat) {
			$deleteFromEntity .= " (SELECT " . $tableFormat->getPrimaryKeys()[0] . "
				FROM raw_data." . $tableFormat->getTableName() . " AS m
				" . $geoAssociationFromEntityFilter . ") UNION ";
		}
		$deleteFromEntity = substr($deleteFromEntity, 0, -6);
		
		// Delete all in observation_<entity> table, with <entity> the updated referential
		$this->logger->debug('deleteObsEntity : ' . $deleteObsEntity);
		$stmt = $this->conn->prepare($deleteObsEntity . ";");
		$stmt->execute();
		
		// Delete lines in the other observation_ tables when calculated from the updated referential.
		$obsTables = array(
			'observation_geometrie',
			'observation_commune',
			'observation_maille',
			'observation_departement'
		);
		
		foreach ($obsTables as $obsTable) {
			$delete = "";
			$delete = "DELETE FROM mapping." . $obsTable . " WHERE id_observation IN (" . $deleteFromEntity . ");";
			
			$this->logger->debug('delete : ' . $delete);
			$stmt = $this->conn->prepare($delete);
			$stmt->execute();
		}
		
		return $delete;
	}

	/**
	 * Create SQL filters depending on the parameters given to the service
	 *
	 * @param unknown $providerId        	
	 * @param unknown $submissionId        	
	 * @param unknown $submissionIdArray        	
	 */
	public function filter($providerId, $submissionId, $submissionIdArray) {
		$filter = "";
		if ($providerId != null) {
			$filter .= " AND m.provider_id = '" . $providerId . "'";
		}
		if ($submissionId != null) {
			$filter .= " AND m.submission_id = '" . $submissionId . "'";
		}
		if (!empty($submissionIdArray)) {
			$filter .= " AND m.submission_id = ANY ('{" . implode(',', $submissionIdArray) . "}')";
		}
		
		return $filter;
	}

	/**
	 * Compute geoAssociations
	 * geomToCommune or geomToMaille or geomToDept
	 *
	 * @param String $entity        	
	 * @param TableFormat $tableFormat        	
	 * @param String $filter        	
	 */
	public function geomToEntity($entity, $tableFormat, $filter) {
		$geomToEntity = "INSERT INTO mapping.observation_" . $entity . "
			SELECT m." . $tableFormat->getPrimaryKeys()[0] . ",  m.provider_id, '" . $tableFormat->getFormat() . "', ref.id_" . $entity . ", 1
			FROM mapping.bac_" . $entity . " AS ref, raw_data." . $tableFormat->getTableName() . " AS m
			WHERE m.geometrie IS NOT NULL
			AND St_Intersects(St_Transform(m.geometrie, 3857), ref.geom) = true " . $filter . ";
				";
		
		$this->logger->debug('geomToEntity : ' . $geomToEntity);
		$stmt = $this->conn->prepare($geomToEntity);
		$stmt->execute();
		
		return $geomToEntity;
	}

	/**
	 * Compute geo associations
	 * geomToGeom, communeToGeom, mailleToGeom or departementToGeom
	 *
	 * @param String $entity        	
	 * @param TableFormat $tableFormat        	
	 * @param String $filter        	
	 */
	public function entityToGeom($entity, $tableFormat, $filter) {
		$fillGeomTable = "CREATE TEMP TABLE IF NOT EXISTS bac_obs_geom (
		  id_observation character varying NOT NULL, 
		  id_provider character varying NOT NULL, 
		  id_geometrie integer NOT NULL DEFAULT nextval('bac_geometrie_id_geometrie_seq'::regclass),
		  geom geometry(Geometry,3857)
		) ;";
		
		$this->logger->debug('entityToGeom : ' . $fillGeomTable);
		$stmt = $this->conn->prepare($fillGeomTable);
		$stmt->execute();
		
		if ($entity == 'geom') {
			$joinAndWhere = " WHERE m.geometrie IS NOT NULL ";
			$geometrie = "m.geometrie";
		} elseif ($entity == 'commune') {
			$joinAndWhere = "  JOIN mapping.bac_commune AS ref ON ref.id_commune = ANY(m.codecommune::text[])
				" . $this->geoAssociationFromCommuneFilter;
			$geometrie = "St_Envelope(ref.geom)";
		} elseif ($entity == 'maille') {
			$joinAndWhere = " JOIN mapping.bac_maille AS ref ON ref.id_maille = ANY(m.codemaille::text[])
   				" . $this->geoAssociationFromMailleFilter;
			$geometrie = "St_Envelope(ref.geom)";
		} elseif ($entity = 'departement') {
			$joinAndWhere = " JOIN mapping.bac_departement AS ref ON ref.id_departement = ANY(m.codedepartement::text[])
				" . $this->geoAssociationFromDepartementFilter;
			$geometrie = "St_Envelope(ref.geom)";
		}
		
		$fillGeomBacAndObsTables = "WITH rows AS (
		  INSERT INTO bac_obs_geom (id_observation, id_provider, geom)
		    SELECT m." . $tableFormat->getPrimaryKeys()[0] . ", m.provider_id, St_Transform(" . $geometrie . ", 3857) 
		    FROM raw_data." . $tableFormat->getTableName() . " AS m 
		   	" . $joinAndWhere . $filter . "
		  RETURNING *
		), insert_bac AS (
		  INSERT INTO mapping.bac_geometrie
		    SELECT id_geometrie, geom
		    FROM rows
		)
		INSERT INTO mapping.observation_geometrie
		  SELECT id_observation, id_provider, '" . $tableFormat->getFormat() . "', id_geometrie
		  FROM rows
		  		;";
		
		$this->logger->debug('entityToGeom : ' . $fillGeomBacAndObsTables);
		$stmt = $this->conn->prepare($fillGeomBacAndObsTables);
		$stmt->execute();
		
		return $fillGeomBacAndObsTables;
	}

	/**
	 * Compute geo association
	 * communeToCommune, communeToMaille, communeToDepartement,
	 * mailleToCommune, mailleToMaille, mailleToDepartement,
	 * departementToCommune, departementToMaille or departementToDepartement
	 *
	 * @param String $entityA        	
	 * @param String $entityB        	
	 * @param TableFormat $tableFormat        	
	 * @param String $filter        	
	 */
	public function entityAToEntityB($entityA, $entityB, $tableFormat, $filter) {
		if ($entityA == 'commune') {
			$where = $this->geoAssociationFromCommuneFilter;
			if ($entityB == 'commune') {
				$assoTable = 'bac_commune';
			} elseif ($entityB == 'maille') {
				$assoTable = 'commune_maille';
			} elseif ($entityB == 'departement') {
				$assoTable = 'bac_commune';
			}
		} elseif ($entityA == 'maille') {
			$where = $this->geoAssociationFromMailleFilter;
			if ($entityB == 'commune') {
				$assoTable = 'commune_maille';
			} elseif ($entityB == 'maille') {
				$assoTable = 'bac_maille';
			} elseif ($entityB == 'departement') {
				$assoTable = 'maille_departement';
			}
		} elseif ($entityA = 'departement') {
			$where = $this->geoAssociationFromDepartementFilter;
			if ($entityB == 'commune') {
				$assoTable = 'bac_commune';
			} elseif ($entityB == 'maille') {
				$assoTable = 'maille_departement';
			} elseif ($entityB == 'departement') {
				$assoTable = 'bac_departement';
			}
		}
		
		$entityAToEntityB = "INSERT INTO mapping.observation_" . $entityB . "
		SELECT m." . $tableFormat->getPrimaryKeys()[0] . ",  m.provider_id, '" . $tableFormat->getFormat() . "', asso.id_" . $entityB . ", 1
		FROM raw_data." . $tableFormat->getTableName() . " AS m, mapping." . $assoTable . " AS asso
		" . $where . "
		AND asso.id_" . $entityA . " = ANY(m.code" . $entityA . "::text[]) " . $filter . "
		GROUP BY m." . $tableFormat->getPrimaryKeys()[0] . ",  m.provider_id, asso.id_" . $entityB . ";
		";
		
		$this->logger->debug('entityAToEntityB : ' . $entityAToEntityB);
		$stmt = $this->conn->prepare($entityAToEntityB);
		$stmt->execute();
		
		return $entityAToEntityB;
	}

	/**
	 * Fill codemaillecalcule
	 *
	 * @param tableFormat $tableFormat        	
	 * @param String $filter        	
	 */
	public function codeMailleCalcule($tableFormat, $filter) {
		$sql = "UPDATE raw_data." . $tableFormat->getTableName() . " AS m 
			SET codemaillecalcule = ARRAY(SELECT o.id_maille 
			    FROM mapping.observation_maille AS o
			    WHERE m." . $tableFormat->getPrimaryKeys()[0] . " = o.id_observation 
			    AND m.provider_id = o.id_provider
			    AND o.table_format = '" . $tableFormat->getFormat() . "'
			 	) WHERE true " . $filter . ";
				";
		
		$this->logger->debug('codeMailleCalcule : ' . $sql);
		$stmt = $this->conn->prepare($sql);
		$stmt->execute();
		
		return $sql;
	}

	/**
	 * Fill codecommunecalcule and nomcommunecalcule
	 *
	 * @param Tableformat $tableFormat        	
	 * @param String $filter        	
	 */
	public function communeCalcule($tableFormat, $filter) {
		$sql = "UPDATE raw_data." . $tableFormat->getTableName() . " AS m 
			SET codecommunecalcule = ARRAY(SELECT o.id_commune 
			    FROM mapping.observation_commune AS o
			    WHERE m." . $tableFormat->getPrimaryKeys()[0] . " = o.id_observation 
			    AND m.provider_id = o.id_provider
			    AND o.table_format = '" . $tableFormat->getFormat() . "'
			),
			nomcommunecalcule = ARRAY(SELECT c.nom_com 
			    FROM referentiels.commune_carto_2017 AS c 
			    LEFT JOIN mapping.observation_commune AS o ON c.insee_com = o.id_commune  
			 WHERE m." . $tableFormat->getPrimaryKeys()[0] . " = o.id_observation 
			    AND m.provider_id = o.id_provider
			    AND o.table_format = '" . $tableFormat->getFormat() . "'
			    ) WHERE true " . $filter . ";
				";
		
		$this->logger->debug('communeCalcule : ' . $sql);
		$stmt = $this->conn->prepare($sql);
		$stmt->execute();
		
		return $sql;
	}

	/**
	 * Fill codedepartementcalcule
	 *
	 * @param TableFormat $tableFormat        	
	 * @param String $filter        	
	 */
	public function codeDepartementCalcule($tableFormat, $filter) {
		$sql = "UPDATE raw_data." . $tableFormat->getTableName() . " AS m 
			SET codedepartementcalcule = ARRAY(SELECT o.id_departement 
			FROM mapping.observation_departement AS o
			WHERE m." . $tableFormat->getPrimaryKeys()[0] . " = o.id_observation 
			AND m.provider_id = o.id_provider
			AND o.table_format = '" . $tableFormat->getFormat() . "'
			) WHERE true " . $filter . ";
			";
		
		$this->logger->debug('codeDepartementCalcule : ' . $sql);
		$stmt = $this->conn->prepare($sql);
		$stmt->execute();
		
		return $sql;
	}
}