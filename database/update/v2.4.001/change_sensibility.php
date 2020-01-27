<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";


$config = loadPropertiesFromArgs();

$dsn = "pgsql:host={$config['db.host']};port={$config['db.port']};dbname={$config['db.name']}" ;
$pdo = new PDO($dsn, $config['db.adminuser'], $config['db.adminuser.pw']) ;

$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION) ;

// Application name
$pdo->exec("SET application_name = 'sensibility'") ;

// Création du type sensible_type.
$pdo->exec("CREATE TYPE sensible_type AS (
	sensible VARCHAR, 
	sensiniveau VARCHAR, 
	sensidateattribution DATE, 
	sensireferentiel VARCHAR, 
	sensiversionreferentiel VARCHAR, 
	sensimanuelle VARCHAR, 
	sensialerte VARCHAR
)");

// Création de la fonction de calcul de la sensibilité. 
$sql = "CREATE OR REPLACE FUNCTION raw_data.sensitive_update(
        cdnom VARCHAR, 
        cdref VARCHAR, 
        codedepartementcalcule _VARCHAR, 
        jourdatefin DATE, 
        occstatutbiologique VARCHAR, 
        sensiniveau VARCHAR
    )
    RETURNS sensible_type
    LANGUAGE plpgsql
    AS \$function\$

    DECLARE
        rule_codage integer;
        rule_autre character varying(500);
        rule_cd_occ integer;
        rule_full_citation character varying(500);
        rule_cd_doc integer;

        ret sensible_type ;

    BEGIN
        
        -- We get the referential applied for the data departement
        SELECT especesensiblelistes.full_citation, especesensiblelistes.cd_doc INTO rule_full_citation, rule_cd_doc
        FROM referentiels.especesensible
        LEFT JOIN referentiels.especesensiblelistes ON especesensiblelistes.cd_sl = especesensible.cd_sl
        WHERE especesensible.cd_dept = ANY (codedepartementcalcule)
        LIMIT 1;

        
        -- by default a data is not sensitive
        ret.sensible = '0';
        ret.sensiniveau = '0';
        ret.sensidateattribution = now();
        ret.sensireferentiel = rule_full_citation;
        ret.sensiversionreferentiel = rule_cd_doc;
        ret.sensimanuelle = '0';
        ret.sensialerte = '0';

        
        -- Does the data deals with sensitive taxon for the departement and is under the sensitive duration ?
        SELECT especesensible.codage, especesensible.autre, especesensible.cd_occ_statut_biologique INTO rule_codage, rule_autre, rule_cd_occ
        FROM referentiels.especesensible
        LEFT JOIN referentiels.especesensiblelistes ON especesensiblelistes.cd_sl = especesensible.cd_sl
        WHERE 
            (CD_NOM = cdNom
            OR CD_NOM = cdRef
            OR CD_NOM = ANY (
                WITH RECURSIVE node_list( code, parent_code, lb_name, vernacular_name) AS (
                    SELECT code, parent_code, lb_name, vernacular_name
                    FROM metadata.mode_taxref
                    WHERE code = cdnom
            
                    UNION ALL
            
                    SELECT parent.code, parent.parent_code, parent.lb_name, parent.vernacular_name
                    FROM node_list, metadata.mode_taxref parent
                    WHERE node_list.parent_code = parent.code
                    AND node_list.parent_code != '349525'
                    )
                SELECT parent_code
                FROM node_list
                ORDER BY code
                )
            )
            AND CD_DEPT = ANY (codedepartementcalcule)
            AND (DUREE IS NULL OR (jourdatefin::date + DUREE * '1 year'::INTERVAL > now()))
            AND (occstatutbiologique IS NULL OR occstatutbiologique IN ( '0', '1', '2') OR cd_occ_statut_biologique IS NULL OR occstatutbiologique = CAST(cd_occ_statut_biologique AS text))
        
        --  Quand on a plusieurs règles applicables il faut choisir en priorité
        --  Les règles avec le codage le plus fort
        --  Parmi elles, la règle sans commentaire (rule_autre is null)
        --  Voir #579
        ORDER BY codage DESC, autre DESC
        --  on prend la première règle, maintenant qu'elles ont été ordonnées
        LIMIT 1;
        
            
        -- No rules found, the obs is not sensitive
        IF NOT FOUND THEN
            RETURN ret ;
        End if;

        -- A rule has been found, the obs is sensitive
        ret.sensible = '1';
        ret.sensiniveau = rule_codage;

        -- If there is a comment, sensitivity must be defined manually
        -- If the rule has a cd_occ_statut_biologique and not the data, sensitivity must be defined manually
        If (rule_autre IS NOT NULL OR (occstatutbiologique IS NULL AND rule_cd_occ IS NOT NULL)) Then
            ret.sensialerte = '1';
        End if ;

        RETURN ret ;

    END;
    \$function\$
";

$pdo->exec($sql) ;

// Création des index sur la table de sensibilité. 
$pdo->exec("CREATE INDEX IF NOT EXISTS idx_especesensible_cddept ON referentiels.especesensible(cd_dept)") ;
$pdo->exec("CREATE INDEX IF NOT EXISTS idx_especesensible_cdnom ON referentiels.especesensible(cd_nom)") ;
$pdo->exec("CREATE INDEX IF NOT EXISTS idx_especesensible_cdsl ON referentiels.especesensible(cd_sl)") ;

// On récupère le nom de la table des observations.
$sth = $pdo->query("SELECT table_name, primary_key 
    FROM metadata.table_format tf
    JOIN metadata.model_tables mt ON tf.format = mt.table_id
    JOIN metadata.model m ON m.id = mt.model_id
    WHERE m.standard = 'occtax' 
") ;
$items = $sth->fetchAll() ;


foreach ($items as $item) {

    $tableName = $item['table_name'] ;
    $primaryKeys = array_map(function($e) { return trim($e) ; }, explode(',', $item['primary_key'])) ;
    $primaryKey = null ;
    foreach ($primaryKeys as $pk) {
        if (strpos($pk, 'OGAM_ID') !== false) {
            $primaryKey = $pk ;
        }
    }

    try {

        $pdo->beginTransaction() ;

        // Création table contenant les nouvelles sensibilités. 
        $sql = "CREATE TABLE tmp_sensitive_update AS
            SELECT 
                $primaryKey, 
                sensitive_update(cdnom, cdref, codedepartementcalcule, jourdatefin, occstatutbiologique, sensiniveau) 
            FROM raw_data.$tableName
        ";
        $pdo->exec($sql) ;

        // Récupération des identifiants de JDD impactés par un changement de sensibilité. 
        $sth = $pdo->query("SELECT value FROM website.application_parameters WHERE name = 'UploadDirectory'") ;
        $filePath = $sth->fetchColumn() . DIRECTORY_SEPARATOR . "jdd_modified_sensibility.txt" ;
        $file = new \SplFileObject($filePath, "w") ;

        $sql = "SELECT DISTINCT o.jddmetadonneedeeid
            FROM raw_data.$tableName o
            JOIN tmp_sensitive_update u USING($primaryKey)
            WHERE o.sensiniveau != (u).sensitive_update.sensiniveau
        ";
        $sth = $pdo->query($sql) ;
        while ($row = $sth->fetch()) {
            $file->fwrite($row['jddmetadonneedeeid'] . PHP_EOL) ;
        }        

        // Mise à jour des sensibilités dans la table. 
        $sql = "UPDATE raw_data.$tableName 
            SET sensible = (u).sensitive_update.sensible, 
                sensiniveau = (u).sensitive_update.sensiniveau, 
                sensidateattribution = (u).sensitive_update.sensidateattribution, 
                sensireferentiel = (u).sensitive_update.sensireferentiel, 
                sensiversionreferentiel = (u).sensitive_update.sensiversionreferentiel, 
                sensimanuelle = (u).sensitive_update.sensimanuelle, 
                sensialerte = (u).sensitive_update.sensialerte
            FROM tmp_sensitive_update u
            WHERE model_1_observation.$primaryKey = u.$primaryKey 
            AND sensiniveau != (u).sensitive_update.sensiniveau
        ";
        $pdo->exec($sql) ;

        // Suppression de la table temporaire.
        $pdo->exec("DROP TABLE tmp_sensitive_update") ;

        $pdo->commit() ;

    } catch (PDOException $e) {

        $pdo->rollBack() ;
        echo "$sprintDir/update_db_sprint.php\n";
        echo "exception: " . $e->getMessage() . "\n";
        echo "Echec de mise à jour de la sensibilité pour la table $tableName.\n" ;
        exit(1);
    }

}
    
