<?php

namespace Ign\Bundle\GincoBundle\Services\DEEGeneration;

use Ign\Bundle\GincoBundle\Services\DEEGeneration\AbstractDEEGenerator;
use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\Website\Message;
use Ign\Bundle\GincoBundle\Services\Ogr2ogr;

/**
 * Description of DEEGeneratorHabitat
 *
 * @author rpas
 */
class DEEGeneratorHabitat extends AbstractDEEGenerator {
	
	private $habitatModel = array(
		"identifianthabsinp"	=> "idHabSINP",
		"nomcite"				=> "nomCite",
		"preuvenumerique"		=> "uRLPreuve",
		"cdhab"					=> "cdHab",
		"typedeterm"			=> "typeDeterm",
		"determinateur"			=> "determinateur",
		"techniquecollecte"		=> "techniqueCollecte",
		"precisiontechnique"	=> "precisionTechnique",
		"recouvrement"			=> "recouvrement",
		"abondancehabitat"		=> "abondanceHabitat",
		"identifiantorigine"	=> "identifiantOrigine",
		"releveespeces"			=> "releveEspeces",
		"relevephyto"			=> "relevePhyto",
		"sensibilitehab"		=> "sensibiliteHab"
	);
	
	
	private $stationModel = array(
		"natureobjetgeo"			=> "NATOBJGEO",
		"acidite"					=> "ACIDITE",
		"altitudemax"				=> "ALTMAX",
		"altitudemin"				=> "ALTMIN",
		"altitudemoyenne"			=> "ALTMOY",
		"commentaire"				=> "COMMENT",
		"jourdatedebut"				=> "DATEDEBUT",
		"jourdatefin"				=> "DATEFIN",
		"dateimprecise"				=> "DATEIMPREC",
		"dspublique"				=> "DSPUBLIQUE",
		"echellenumerisation"		=> "ECHELLENUM",
		"exposition"				=> "EXPOSITION",
		"geologie"					=> "GEOLOGIE",
		"jddmetadonneedeeid"		=> "IDMTD",
		"identifiantoriginestation" => "IDORIGSTA",
		"identifiantstasinp"		=> "IDSTASINP",
		"estcomplexehabitats"		=> "ISCOMPLEX",
		"methodecalculsurface"		=> "METHCALC",
		"nomstation"				=> "NOMSTATION",
		"observateur"				=> "OBSNOMORG",
		"precisiongeometrie"		=> "PRECISGEOM",
		"profondeurmax"				=> "PROFMAX",
		"profondeurmin"				=> "PRODMIN",
		"profondeurmoyenne"			=> "PROFMOY",
		"referencebiblio"			=> "REFBIBLIO",
		"surface"					=> "SURFACE",
		"typesol"					=> "TYPESOL",
		"usage"						=> "USAGE",
		"geometrie"					=> "WKT"
 	);

	
	/**
	 *
	 * @var Ogr2ogr
	 */
	private $ogr2ogr ;
	
	public function __construct($em, $configuration, $genericService, $queryService, $logger, $ogr2ogr) {
		
		parent::__construct($em, $configuration, $genericService, $queryService, $logger);
		$this->ogr2ogr = $ogr2ogr ;
	}
	
	public function generateDee(DEE $dee, $filePath, Message $message = null) {
		
		// Préparation de l'avancement du message.
		$pdo = $this->em->getConnection() ;
		$sth = $pdo->query("SELECT sum(nb_line) AS total FROM raw_data.submission_file WHERE submission_id IN (" . implode(',', $dee->getSubmissions()) . ")") ;
		$result = $sth->fetch() ;
		$total = $result['total'] ;
		$progress = 0 ;
		$message->setLength($total) ;
		$message->setProgress($progress) ;
		$this->em->flush() ;
		
		// Création du répertoire de sortie
		$pathExists = is_dir($filePath) || mkdir($filePath, 0755, true);
		if (!$pathExists) {
			throw new DEEException("Error: could not create directory: $filePath");
		}
		
		// Récupération des tables du modèle.
		$tableHabitat = null ;
		$tableStation = null ;
		$tables = $dee->getJdd()->getModel()->getTables() ;
		foreach ($tables as $table) {
			if ("habitat" == $table->getLabel()) {
				$tableHabitat = $table ;
			} else if ("station" == $table->getLabel()) {
				$tableStation = $table ;
			}
		}
				
		// Requête pour les habitats.
		$sqlHabitat = "SELECT s.identifiantstasinp AS idStaSINP" ;
		foreach ($this->habitatModel as $field => $label) {
			$sqlHabitat .= ", h.$field AS $label " ;
		}
		$sqlHabitat .= " FROM {$tableHabitat->getTableName()} h " ;
		$sqlHabitat .= " JOIN {$tableStation->getTableName()} s USING (clestation, SUBMISSION_ID) " ;
		$sqlHabitat .= " WHERE h.submission_id IN (" . implode(",", $dee->getSubmissions()) . ")" ;
		
		$csvHabitat = $filePath . DIRECTORY_SEPARATOR . "Habitat_soh_1_0.csv" ;
		$this->generateCsv($sqlHabitat, $csvHabitat, array_merge(["identifiantstasinp" => "idStaSINP"], $this->habitatModel), $message) ;
		if (Message::STATUS_TOCANCEL == $message->getStatus()) {
			return;
		}
		
		// Requête stations base
		$sqlStation = "SELECT " ;
        $fields = array() ;
        foreach ($this->stationModel as $column => $label) {
            $fields[] = "s.$column AS $label" ;
        }
        $sqlStation .= implode(", ", $fields) ;
		$sqlStation .= " FROM {$tableStation->getTableName()} s " ;
		$sqlStation .= " WHERE s.submission_id IN (" . implode(",", $dee->getSubmissions()) . ") " ;
		
		// Stations points
		$sqlStationPoints = $sqlStation . " AND st_geometrytype(st_multi(s.geometrie)) = 'ST_MultiPoint'" ;
		$shpStationPoints = $filePath . DIRECTORY_SEPARATOR . "shp_point_soh.shp" ;
        $this->ogr2ogr->pg2shp($sqlStationPoints, $shpStationPoints, 'EPSG:4326') ;
        if (Message::STATUS_TOCANCEL == $message->getStatus()) {
			return;
		}
		
		// Stations lignes
		$sqlStationLignes = $sqlStation . " AND st_geometrytype(st_multi(s.geometrie)) = 'ST_MultiLineString'" ;
		$shpStationLignes = $filePath . DIRECTORY_SEPARATOR . "shp_ligne_soh.shp" ;
        $this->ogr2ogr->pg2shp($sqlStationLignes, $shpStationLignes, 'EPSG:4326') ;
        if (Message::STATUS_TOCANCEL == $message->getStatus()) {
			return;
		}
		
		// Stations polygones
		$sqlStationPolygones = $sqlStation . " AND st_geometrytype(st_multi(s.geometrie)) = 'ST_MultiPolygon'" ;
		$shpStationPolygones = $filePath . DIRECTORY_SEPARATOR . "shp_polygone_soh.shp" ;
        $this->ogr2ogr->pg2shp($sqlStationPolygones, $shpStationPolygones, 'EPSG:4326') ;
        if (Message::STATUS_TOCANCEL == $message->getStatus()) {
			return;
		}
		
	}


	/**
	 * Writes CSV file from SQL.
	 * @param type $sql
	 * @param type $outputFile
	 */
	private function generateCsv($sql, $outputFile, $model, Message $message) {
		
		$pdo = $this->em->getConnection() ; 
		
		$progress = $message->getProgress() ;
		$total = $message->getLength() ;
		
		$file = new \SplFileObject($outputFile, "w") ;
		$file->setCsvControl(";") ;
		
		$sth = $pdo->prepare($sql) ;
		$sth->execute() ;
		$firstLine = true ;
		while ($row = $sth->fetch(\PDO::FETCH_ASSOC)) {
			
			if (empty($row)) {
				continue ;
			}
			
			if ($firstLine) {
				$file->fputcsv(array_values($model)) ;
				$firstLine = false ;
			}
			
			$file->fputcsv(array_values($row)) ;
			
			++$progress ;
			if (($total <= 100) || ($total <= 1000 && ($progress % 10 == 0)) || ($total <= 10000 && ($progress % 100 == 0)) || ($progress % 1000 == 0)) {

				// Check if message has been cancelled externally; if yes, just return
				// (DEE cancellation is done at a upper level)
				$this->em->refresh($message);
				if (Message::STATUS_TOCANCEL == $message->getStatus()) {
					return;
				}

				// Report message progress if given
				$message->setProgress($progress);
				$this->em->flush();
			}
		}
		
		$message->setProgress($progress) ;
		$this->em->flush() ;
	}
}
