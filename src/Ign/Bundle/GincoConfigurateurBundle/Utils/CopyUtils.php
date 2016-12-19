<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Utils;

use Monolog\Logger;
use Ign\Bundle\ConfigurateurBundle\Utils\TypesConvert;
use Ign\Bundle\ConfigurateurBundle\Utils\CopyUtils as CopyUtilsBase;
use Assetic\Exception\Exception;

/**
 * Extends utility class for copying and publishing metadata.
 *
 * GINCO specific feature :
 * Group form fields if they belong to the data of the dee standard
 */
class CopyUtils extends CopyUtilsBase {

	// Groups = Form_Format
	protected $dee_groups = array(
		'observation' => array(
			'label' => 'Observation',
			'definition' => 'Groupement des champs d\'observation',
			'position' => 1,
			'is_opened' => 1
		),
		'localisation' => array(
			'label' => 'Localisation',
			'definition' => 'Groupement des champs de localisation',
			'position' => 2,
			'is_opened' => 1
		),
		'regroupements' => array(
			'label' => 'Regroupements',
			'definition' => 'Groupement des champs de regroupement',
			'position' => 3,
			'is_opened' => 1
		),
		'standardisation' => array(
			'label' => 'Standardisation',
			'definition' => 'Groupement des champs de standardisation',
			'position' => 4,
			'is_opened' => 1
		),
		'dsr' => array(
			'label' => 'Attributs Additionnels DSR',
			'definition' => 'Groupement des champs Attributs Additionnels DSR',
			'position' => 5,
			'is_opened' => 1
		),
		'autres' => array(
			'label' => 'Autres',
			'definition' => 'Autres champs',
			'position' => 6,
			'is_opened' => 1
		)
	);

	protected $dee_fields = array(

		// ------ Observation ------------------------

		'nomcite' => 'observation',
		'typedenombrement' => 'observation',
		'objetdenombrement' => 'observation',
		'denombrementmax' => 'observation',
		'denombrementmin' => 'observation',
		'statutobservation' => 'observation',
		'heuredatedebut' => 'observation',
		'heuredatefin' => 'observation',
		'jourdatedebut' => 'observation',
		'jourdatefin' => 'observation',
		'commentaire' => 'observation',
		'observateuridentite' => 'observation',
		'observateurnomorganisme' => 'observation',
		'observateurmail' => 'observation',

		'obsdescription' => 'observation',
		'obsmethode' => 'observation',
		'obscontexte' => 'observation',
		'occmethodedetermination' => 'observation',
		'occstatutbiogeographique' => 'observation',
		'occstadedevie' => 'observation',
		'occsexe' => 'observation',
		'occnaturalite' => 'observation',
		'occstatutbiologique' => 'observation',
		'occetatbiologique' => 'observation',
		'preuvenumerique' => 'observation',
		'preuvenonnumerique' => 'observation',
		'preuveexistante' => 'observation',

		'cdnom' => 'observation',
		'cdref' => 'observation',
		'versiontaxref' => 'observation',
		'determinateuridentite' => 'observation',
		'determinateurmail' => 'observation',
		'determinateurnomorganisme' => 'observation',
		'datedetermination' => 'observation',

		// ---- Localisation --------------------------

		'altitudemin' => 'localisation',
		'altitudemax' => 'localisation',
		'altitudemoyenne' => 'localisation',
		'profondeurmin' => 'localisation',
		'profondeurmax' => 'localisation',
		'profondeurmoyenne' => 'localisation',
		'refhabitat' => 'localisation',
		'versionrefhabitat' => 'localisation',
		'codehabitat' => 'localisation',
		'codehabref' => 'localisation',

		'codecommune' => 'localisation',
		'anneerefcommune' => 'localisation',
		'typeinfogeocommune' => 'localisation',
		'nomcommune' => 'localisation',
		'typeinfogeodepartement' => 'localisation',
		'codedepartement' => 'localisation',
		'anneerefdepartement' => 'localisation',
		'typeinfogeomaille' => 'localisation',
		'versionrefmaille' => 'localisation',
		'codemaille' => 'localisation',
		'nomrefmaille' => 'localisation',
		'natureobjetgeo' => 'localisation',
		'codeme' => 'localisation',
		'precisiongeometrie' => 'localisation',
		'typeinfogeoen' => 'localisation',
		'versionen' => 'localisation',
		'codeen' => 'localisation',
		'typeen' => 'localisation',
		'typeinfogeome' => 'localisation',
		'versionme' => 'localisation',
		'dateme' => 'localisation',
		'region' => 'localisation',

		'geometrie' => 'localisation',

		'codecommunecalcule' => 'localisation',
		'codedepartementcalcule' => 'localisation',
		'codemaillecalcule' => 'localisation',
		'nomcommunecalcule' => 'localisation',

		// ----- Regroupements -------------------------

		'identifiantregroupementpermanent' => 'regroupements',
		'typeregroupement' => 'regroupements',
		'methoderegroupement' => 'regroupements',

		// ----- Standardisation -----------------------

		'identifiantpermanent' => 'standardisation',
		'validateurnomorganisme' => 'standardisation',
		'validateurmail' => 'standardisation',
		'validateuridentite' => 'standardisation',
		'organismestandard' => 'standardisation',
		'deedatedernieremodification' => 'standardisation',
		'jddmetadonneedeeid' => 'standardisation',
		'orgtransformation' => 'standardisation',
		'codeidcnpdispositif' => 'standardisation',
		'deefloutage' => 'standardisation',

		'sensible' => 'standardisation',
		'sensiniveau' => 'standardisation',
		'sensidateattribution' => 'standardisation',
		'sensireferentiel' => 'standardisation',
		'sensiversionreferentiel' => 'standardisation',
		'sensialerte' => 'standardisation',
		'sensimanuelle' => 'standardisation',

		'dspublique' => 'standardisation',
		'organismegestionnairedonnee' => 'standardisation',
		'statutsource' => 'standardisation',
		'diffusionniveauprecision' => 'standardisation',
		'identifiantorigine' => 'standardisation',
		'jddcode' => 'standardisation',
		'jddid' => 'standardisation',
		'jddsourceid' => 'standardisation',
		'referencebiblio' => 'standardisation',

		// ----- Champs additionnels DSR -----------------------
		'nomattribut' => 'dsr',
		'definitionattribut' => 'dsr',
		'valeurattribut' => 'dsr',
		'uniteattribut' => 'dsr',
		'thematiqueattribut' => 'dsr',
		'typeattribut' => 'dsr'
	);
	// todo : champs à classer ...
	/*
	 * 'provider_id' => ,
	 * 'submission_id' => ,
	 * 'ogam_id_table_observation' => ,
	 */



	// Fields shown as result columns by default
	protected $default_results = array(
		'identifiantpermanent',
		'statutobservation',
		'nomcite',
		'datedebut',
		'datefin',
		'observateuridentite',
		'observateurnomorganisme',
		'dspublique',
		'jddmetadonneedeeid',
		'organismegestionnairedonnee',
		'orgtransformation',
		'sensible',
		'sensiniveau',
		'statutsource'
	);

	/**
	 * Creates entries in Form_Field table, and also in Form_Format.
	 * Needed by OGAM to query the data.
	 *
	 * All fields with their data in the dee model are grouped in
	 * thematic groups.
	 *
	 * All other fields are in a last group.
	 *
	 * @param
	 *        	$modelId
	 */
	public function createFormFields($modelId, $datasetId, $dbconn) {
		// Find all table_field of the model
		$sql = "SELECT tfo.schema_code, tfo.format, tfi.data, d.label, u.type, u.subtype
				FROM metadata_work.table_format tfo
				INNER JOIN metadata_work.model_tables mt ON mt.table_id = tfo.format
				INNER JOIN metadata_work.table_field tfi ON tfi.format = tfo.format
				INNER JOIN metadata_work.data d ON d.data = tfi.data
				INNER JOIN metadata_work.unit u ON d.unit = u.unit
				WHERE mt.model_id = $1
				ORDER BY d.label"; // order by : fields will appear in alphabetical order in ogam
		pg_prepare($dbconn, "", $sql);
		$results = pg_execute($dbconn, "", array(
			$modelId
		));
		$tfis = pg_fetch_all($results);

		// Find all table_format of the model.
		$sql = "SELECT tfo.format, tfo.label
				FROM metadata_work.table_format tfo
				INNER JOIN metadata_work.model_tables mt ON mt.table_id = tfo.format
				WHERE mt.model_id = $1
				ORDER BY tfo.format";
		pg_prepare($dbconn, "", $sql);
		$results = pg_execute($dbconn, "", array(
			$modelId
		));
		$tfos = pg_fetch_all($results);
		$tablesCount = count($tfos);

		// Initialization of potential groups :
		// they are composed of dee_groups x table_formats
		$groups = array();

		foreach ($this->dee_groups as $index => $group) {
			$groups[$index] = array();
			foreach ($tfos as $count => $tfo) {
				$groups[$index][$tfo['format']] = array(
					"label" => ($tablesCount > 1) ? $group['label'] . " (table " . $tfo['label'] . ")" : $group['label'],
					"definition" => ($tablesCount > 1) ? $group['definition'] . " (table " . $tfo['label'] . ")" : $group['definition'],
					"active" => false,
					"position" => ($group['position'] - 1) * $tablesCount + $count + 1,
					"is_opened" => $group['is_opened']
				);
			}
		}

		// Define which groups will be active.
		foreach ($tfis as $tfi) {
			if (array_key_exists($tfi['data'], $this->dee_fields)) {
				$groups[$this->dee_fields[$tfi['data']]][$tfi['format']]['active'] = true;
			} else {
				$groups['autres'][$tfi['format']]['active'] = true;
			}
		}

		// Create a form_format entry for each active group
		foreach ($groups as $indexGroup => $formats) {
			foreach ($formats as $tableFormat => $group) {
				if (! $group['active']) {
					continue;
				}
				// Generate a new format using uniquid()
				$format = uniqid('form_');
				$groups[$indexGroup][$tableFormat]['format'] = $format;

				// Inserting a format
				$sql = "INSERT INTO metadata.format(format, type)
					VALUES ($1, 'FORM')";
				pg_prepare($dbconn, "", $sql);
				pg_execute($dbconn, "", array(
					$format
				));

				// Inserting the corresponding form_format
				$sql = "INSERT INTO metadata.form_format(format, label, definition, position, is_opened)
					VALUES ($1, $2, $3, $4, $5)";
				pg_prepare($dbconn, "", $sql);
				pg_execute($dbconn, "", array(
					$format,
					$group['label'],
					$group['definition'],
					$group['position'],
					$group['is_opened']
				));

				// Create dataset_forms
				$sql = "INSERT INTO metadata.dataset_forms(dataset_id, format)
					VALUES ($1, $2)";
				pg_prepare($dbconn, "", $sql);
				pg_execute($dbconn, "", array(
					$datasetId,
					$format
				));
			}
		}

		// Now create a form field for each table_field, linked to the form_format (group) it belongs to
		foreach ($tfis as $count => $row) {

			if (array_key_exists($row['data'], $this->dee_fields)) {
				$format = $groups[$this->dee_fields[$row['data']]][$row['format']]['format'];
			} else {
				$format = $groups['autres'][$row['format']]['format'];
			}

			// Insert the field
			$sql = "INSERT INTO metadata.field(data, format, type)
					VALUES ($1, $2, 'FORM')";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array(
				$row['data'],
				$format
			));

			// Insert the form_field
			$convert = new TypesConvert();
			$type = $convert->UnitToInput($row['type'], $row['subtype']);
			$defaultResult = (in_array($row['data'], $this->default_results)) ? 1 : 0;
			$mask = ($type == 'DATE') ? 'yyyy-MM-dd' : null;
			$position = $count + 1;

			$sql = "INSERT INTO metadata.form_field(data, format, is_criteria, is_result,
					input_type, position, is_default_criteria, is_default_result, mask)
					VALUES ($1, $2, 1, 1, $3, $4, 0, $5, $6)";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array(
				$row['data'],
				$format,
				$type,
				$position,
				$defaultResult,
				$mask
			));

			// Insert the field mapping
			$sql = "INSERT INTO metadata.field_mapping(src_data, src_format, dst_data, dst_format, mapping_type)
					VALUES ($1, $2, $3, $4, 'FORM')";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array(
				$row['data'],
				$format,
				$row['data'],
				$row['format']
			));
		}
	}
}