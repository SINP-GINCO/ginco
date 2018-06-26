<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";


$config = loadPropertiesFromArgs();

$dsn = "pgsql:host={$config['db.host']};port={$config['db.port']};dbname={$config['db.name']}" ;
$pdo = new PDO($dsn, $config['db.adminuser'], $config['db.adminuser.pw']) ;

$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION) ;

// On récupère le nom de la table des observations.
$sth = $pdo->query("SELECT table_name FROM metadata.table_format") ;
$tableNames = $sth->fetchAll() ;

// Begin transaction
$pdo->beginTransaction() ;

try {
	
	foreach ($tableNames as $index => $value) {

		$tableName = $value['table_name'] ;
		
		// Cas A) Lorsque TYPE_CHANGE=MODIFICATION et CHAMP=CD_REF, il faut : trouver les données telles que cdRef valent VALEUR_INIT. Pour ces données, mettre :
		//	¤ cdRefCalcule=VALEUR_FINAL
		//	¤ TaxoStatut=Diffusé
		//	¤ TaxoModif=Modification TAXREF
		//	¤ TaxoAlerte=NON
		//	¤ DEEDateDerniereModification=<now()>.
		$casA = $pdo->prepare("UPDATE raw_data.$tableName SET
				cdrefcalcule = :valeurFinal,
				taxostatut = '0',
				taxomodif = '0',
				taxoalerte = '1',
				deedatedernieremodification = now()
			WHERE cdref = :valeurInit
		");

		// Cas B1) Lorsque TYPE_CHANGE=RETRAIT (on a alors que des CHAMP=CD_NOM), il faut : trouver les données telles que cdNom vaut VALEUR_INIT
		// et CD_NOM correspond à un CD_NOM de CDNOM_DISPARUS et que CD_RAISON_SUPPRESSION = 1, auquel cas il faut mettre :
		// ¤ cdNomCalcule=CD_NOM_REMPLACEMENT
		// ¤ mettre à jour cdRefCalcule et nomValide à partir du nouveau cdNomCalcule.
		// ¤ TaxoStatut=Diffusé
		// ¤ TaxoModif=Modification TAXREF
		// ¤ TaxoAlerte=NON
		// ¤ DEEDateDerniereModification=<now()>.
		$casB1 = $pdo->prepare("UPDATE raw_data.$tableName SET
				cdnomcalcule = :cdNomRemplacement::varchar,
				cdrefcalcule = :cdNomRemplacement,
				nomValide = (SELECT nom_valide FROM referentiels.taxref WHERE cd_nom = :cdNomRemplacement),
				taxostatut = '0',
				taxomodif = '0',
				taxoalerte = '1',
				deedatedernieremodification = now()
			WHERE cdnom = :valeurInit
		");     

		// Cas B2) Lorsque TYPE_CHANGE=RETRAIT (on a alors que des CHAMP=CD_NOM), il faut : trouver les données telles que cdNom vaut VALEUR_INIT
		// et CD_NOM correspond à un CD_NOM de CDNOM_DISPARUS et que CD_RAISON_SUPPRESSION = 3, auquel cas il faut mettre :
		// ¤ cdNomCalcule à NULL
		// ¤ cdRef_Calcule à NULL
		// ¤ nomValide à NULL
		// ¤ TaxoStatut =‘Gel’ ???
		// ¤ TaxoModif = ‘Gel TAXREF’
		// ¤ DEEDateDerniereModification est mis à jour
		// ¤ taxoAlerte = OUI.
		$casB2 = $pdo->prepare("UPDATE raw_data.$tableName SET
				cdnomcalcule = NULL,
				cdrefcalcule = NULL,
				nomvalide = NULL,
				taxostatut = '1',
				taxomodif = '1',
				taxoalerte = '0',
				deedatedernieremodification = now()
			WHERE cdnom = :valeurInit
		");

		// Cas B3) Lorsque TYPE_CHANGE=RETRAIT (on a alors que des CHAMP=CD_NOM), il faut : trouver les données telles que cdNom vaut VALEUR_INIT.
		// Pour ces données, mettre :
		// ¤ cdNomCalcule à NULL
		// ¤ cdRef_Calcule à NULL
		// ¤ nomValide à NULL
		// ¤ TaxoStatut =‘Gel’
		// ¤ TaxoModif = ‘Gel TAXREF’
		// ¤ DEEDateDerniereModification est mis à jour
		// ¤ taxoAlerte = OUI.
		$casB3 = $pdo->prepare("UPDATE raw_data.$tableName SET
				cdnomcalcule = NULL,
				cdrefcalcule = NULL,
				nomvalide = NULL,
				taxostatut = '1',
				taxomodif = '1',
				taxoalerte = '0',
				deedatedernieremodification = now()
			WHERE cdnom = :valeurInit
		");


		// Cas C) Lorsque TYPE_CHANGE=MODIFICATION et CHAMP=LB_NOM, il faut : trouver les données telles que cdNom valent CD_NOM. Pour ces données, mettre :
		// ¤ nomValid=VALEUR_FINAL.
		$casC = $pdo->prepare("UPDATE raw_data.$tableName SET
				nomvalide = :valeurFinal
			WHERE cdnom = :cdNom
		");

		$file = new SplFileObject('all_changes.csv', 'r') ;
		$file->setFlags(SplFileObject::READ_CSV) ;
		$header = $file->fgetcsv() ;
		while ($row = $file->fgetcsv()) {

			if (empty($row) || count($row) != count($header)) {
				continue ;
			}

			$data = array_combine($header, $row) ;

			$cdNom = $data['cd_nom'] ;
			$typeChange = $data['type_change'] ;
			$champ = $data['champ'] ;
			$cdRaisonSuppression = $data['cd_raison_suppression'] ;
			$valeurInit = $data['valeur_init'] ;
			$valeurFinal = $data['valeur_final'] ;
			$cdNomRemplacement = $data['cd_nom_remplacement'] ;

			// Cas A		
			if ('MODIFICATION' == $typeChange && 'CD_REF' == $champ) {	
				$casA->execute(array(
					'valeurInit' => $valeurInit,
					'valeurFinal' => $valeurFinal
				));
			}

			// Cas B1
			if ('RETRAIT' == $typeChange && !empty($cdRaisonSuppression) && '1' == $cdRaisonSuppression) {
				$casB1->execute(array(
					'cdNomRemplacement' => $cdNomRemplacement,
					'valeurInit' => $valeurInit
				));
			}

			// Cas B2
			if ('RETRAIT' == $typeChange && !empty($cdRaisonSuppression) && '3' == $cdRaisonSuppression) {
				$casB2->execute(array(
					'valeurInit' => $valeurInit
				));
			}

			// Cas B3
			if ('RETRAIT' == $typeChange && (empty($cdRaisonSuppression) || '2' == $cdRaisonSuppression)) {
				$casB3->execute(array(
					'valeurInit' => $valeurInit
				));
			}

			// Cas C
			if ('MODIFICATION' == $typeChange && 'LB_NOM' == $champ) {
				$casC->execute(array(
					'valeurFinal' => $valeurFinal,
					'cdNom' => $cdNom
				));
			}

		}
	}
	
    
} catch (PDOException $e) {
	
	$pdo->rollback() ;
	
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


// Commit transaction
$pdo->commit() ;



