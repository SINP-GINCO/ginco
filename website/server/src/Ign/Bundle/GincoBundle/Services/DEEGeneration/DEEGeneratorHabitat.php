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
		$this->generateCsv($sqlHabitat, $csvHabitat, array_merge(["identifiantstasinp" => "idStaSINP"], $this->habitatModel)) ;
		
		// Requête stations base
		$sqlStation = "SELECT " ;
		$sqlStation .= implode(", ", array_keys($this->stationModel)) ;
		$sqlStation .= " FROM {$tableStation->getTableName()} s " ;
		$sqlStation .= " WHERE s.submission_id IN (" . implode(",", $dee->getSubmissions()) . ") " ;
		
		// Stations points
		$sqlStationPoints = $sqlStation . " AND st_geometrytype(st_multi(s.geometrie)) = 'ST_MultiPoint'" ;
		$csvStationPoints = $filePath . DIRECTORY_SEPARATOR . "shp_point_soh.csv" ;
		$this->generateCsv($sqlStationPoints, $csvStationPoints, $this->stationModel) ;
		$shpStationPoints = $filePath . DIRECTORY_SEPARATOR . "shp_point_soh.shp" ;
		$this->ogr2ogr->csv2shp($csvStationPoints, $shpStationPoints) ;
		$this->addPrj($filePath, $shpStationPoints) ;
		unlink($csvStationPoints) ;
		
		// Stations lignes
		$sqlStationLignes = $sqlStation . " AND st_geometrytype(st_multi(s.geometrie)) = 'ST_MultiLineString'" ;
		$csvStationLignes = $filePath . DIRECTORY_SEPARATOR . "shp_ligne_soh.csv" ;
		$this->generateCsv($sqlStationLignes, $csvStationLignes, $this->stationModel) ;
		$shpStationLignes = $filePath . DIRECTORY_SEPARATOR . "shp_ligne_soh.shp" ;
		$this->ogr2ogr->csv2shp($csvStationLignes, $shpStationLignes) ;
		$this->addPrj($filePath, $shpStationLignes) ;
		unlink($csvStationLignes) ;
		
		// Stations polygones
		$sqlStationPolygones = $sqlStation . " AND st_geometrytype(st_multi(s.geometrie)) = 'ST_MultiPolygon'" ;
		$csvStationPolygones = $filePath . DIRECTORY_SEPARATOR . "shp_polygone_soh.csv" ;
		$this->generateCsv($sqlStationPolygones, $csvStationPolygones, $this->stationModel) ;
		$shpStationPolygones = $filePath . DIRECTORY_SEPARATOR . "shp_polygone_soh.shp" ;
		$this->ogr2ogr->csv2shp($csvStationPolygones, $shpStationPolygones) ;
		$this->addPrj($filePath, $shpStationPolygones) ;
		unlink($csvStationPolygones) ;
		
	}


	/**
	 * Writes CSV file from SQL.
	 * @param type $sql
	 * @param type $outputFile
	 */
	private function generateCsv($sql, $outputFile, $model) {
		
		$pdo = $this->em->getConnection() ; 
		
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
		}
	}
	
	/**
	 * Ajoute le fichier prj au shapefile.
	 * @param type $filePath
	 * @param type $filename
	 */
	private function addPrj($filePath, $shapefile) {
		
		if (!file_exists($shapefile)) {
			return ;
		}
		$prj = $filePath . DIRECTORY_SEPARATOR . basename($shapefile, ".shp") . ".prj" ;
		$file = new \SplFileObject($prj, "w") ;
		$file->fwrite('GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]]') ;
	}
}
