<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {

	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');

	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";

	foreach (array('metadata', 'metadata_work') as $schema) {
		updateTableFields($schema, 'sensible', 1, 1, 0, 0, "Calculé mais on peut éditer manuellement (attribution manuelle de la sensibilité dans les cas avec commentaires dans le référentiel)" );
		updateTableFields($schema, 'sensiniveau', 1,1 ,0 ,0, "Idem" );
		updateTableFields($schema, 'sensidateattribution', 1, 0, 0, 0, "Trigger import");
		updateTableFields($schema, 'sensireferentiel',1, 0, 0, 0, "Il doit être calculé lors de l import et non modifié ensuite");
		updateTableFields($schema, 'sensiversionreferentiel',1, 0, 0, 0, "Il doit être calculé lors de l import et non modifié ensuite");
		updateTableFields($schema, 'deedatedernieremodification', 1, 0, 0, 0, "Les règles de mise à jour de ce champ sont définies dans le ticket: #747");
		updateTableFields($schema, 'identifiantpermanent', 1, 0, 1, 0);
		updateTableFields($schema, 'geometrie', 0, 1, 1, 0);
		updateTableFields($schema, 'sensimanuelle', 1, 0, 0, 0, "Modifié par les trigger sensitive_automatic et sensitive_manual");
		updateTableFields($schema, 'sensialerte', 1, 1, 0, 0, "si lors de l import, on ne peut pas calculer automatiquement la sensibilité (commentaire dans la règle du référentiel de sensibilité), le champ sensiAlerte est mis à un. Si on édite ensuite la donnée est que la valeur de la sensibilité est modifiée, le champ sensiAlerte est mis à zéro. Mais, si on veut conserver la valeur de sensibilité calculée automatiquement, mais indiquer qu elle a été validée manuellement, il faudrait pouvoir le faire en décochant sensiAlerte manuellement. Donc ce champ doit rester editable.");
		updateTableFields($schema, 'codemaillecalcule', 1, 0, 0, 0);
		updateTableFields($schema, 'codecommunecalcule', 1, 0, 0, 0);
		updateTableFields($schema, 'nomcommunecalcule', 1, 0, 0, 0);
		updateTableFields($schema, 'codedepartementcalcule', 1, 0, 0, 0);
		updateTableFields($schema, 'nomvalide', 1, 0, 0, 0);
	}


} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


function updateTableFields($schema, $columnName, $is_calculated, $is_editable, $is_insertable, $is_mandatory, $comment="NULL") {
	echo "Updating $columnName in table table_field in schema $schema\n";

	$update = "
		UPDATE $schema.table_field
   		SET is_calculated='$is_calculated', is_editable='$is_editable', 
       		is_insertable='$is_insertable', is_mandatory='$is_mandatory', comment='$comment'
 		WHERE column_name='$columnName';
	";
	pg_query($update);
}