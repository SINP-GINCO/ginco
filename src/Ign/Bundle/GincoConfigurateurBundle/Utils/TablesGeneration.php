<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Utils\TablesGeneration as TablesGenerationBase;
use Monolog\Logger;
use Symfony\Component\HttpFoundation\RequestStack;

/**
 * Extends utility class for table generation service.
 *
 * GINCO specific feature :
 * add a trigger on tables containing the "identifiantPermanent" Field,
 * to fill it with a uuid as defined for Ginco project.
 */
class TablesGeneration extends TablesGenerationBase {

	protected $requestStack;

	public function setRequest(RequestStack $requestStack) {
		$this->requestStack = $requestStack;
	}

	protected $predefinedRequestGeneration;

	public function setPredefinedRequestGeneration(PredefinedRequestGeneration $predefinedRequestGeneration) {
		$this->predefinedRequestGeneration = $predefinedRequestGeneration;
	}

	/**
	 * Gets all the tables related to a model, and then generates each one.
	 * Adds foreign key constraints afterwise.
	 *
	 * @param string $modelId
	 */
	public function createTables($modelId, $dbconn) {
		$stmt = $this->selectTablesFormat($modelId, $dbconn);
		$numberOfTables = 0;
		while ($row = pg_fetch_assoc($stmt)) {
			$numberOfTables++;
			$tableFormat = $row['format'];
			$tableSchema = $row['schema_code'];
			$tableName = $row['table_name'];
			$tableLabel = $row['label'];
			$tablePrimaryKey = $row['primary_key'];
			// The "OGAM_ID_xxx" field, part of the pkey.
			$pkeyParts = array_map('trim', explode(',', $tablePrimaryKey));
			$OGAM_ID = 'OGAM_ID_' . $tableFormat; // default, but not always (duplicated model)
			foreach ($pkeyParts as $pkeyPart) {
				if (substr($pkeyPart, 0, 7) == 'OGAM_ID') {
					$OGAM_ID = $pkeyPart;
				}
			}
			try {
				$this->createTable($tableFormat, $tableName, $tableSchema, $tablePrimaryKey, $dbconn);
				$this->createPrimaryKeyTrigger($tableSchema, $OGAM_ID, $tableName, $dbconn);
				$this->createGeometryColumn($tableName, $tableSchema, $tableFormat, $dbconn);
				$this->createIdentifierTrigger($tableSchema, $tableFormat, $tableName, $dbconn); // Ginco specific
				$this->createSensitiveTriggers($tableSchema, $tableFormat, $tableName, $tableLabel, $dbconn); // Ginco specific
				$this->createInitTrigger($tableSchema, $tableFormat, $tableName, $tableLabel, $dbconn); // Ginco specific
				$this->grantAllRights($tableSchema, $dbconn);
			} catch (\Exception $e) {
				$this->logger->debug($e);
				return false;
			}
		}
		try {
			if ($this->predefinedRequestGeneration && $numberOfTables > 0) {
				$this->predefinedRequestGeneration->createPredefinedRequests($modelId, $tableSchema, $dbconn); // Ginco specific
			}
			$this->addConstraints($modelId, $dbconn);
		} catch (\Exception $e) {
			$this->logger->debug($e);
			return false;
		}
		return true;
	}

	/**
	 *
	 * Creates a trigger on the field "identifiantpermanent" (permanent identifier).
	 * If it is not given at insert time, the trigger creates an identifier like :
	 *
	 * http(s)://region.ogam-sinp.ign.fr/occtax/99855cf6-a7e0-11e5-aa6e-7824af3388df
	 *
	 * [protocol][ site host name ][const][ uuid (ISO/IEC 9834‐8:2008) ]
	 *
	 * @param string $tableName
	 * @param string $tableSchema
	 * @param string $tableFormat
	 */
	public function createIdentifierTrigger($tableSchema, $tableFormat, $tableName, $dbconn) {
		// Will the table contain the "identifiantpermanent" column?
		$sql = "SELECT count(*)
				FROM metadata.table_field
				WHERE table_field.data = 'identifiantpermanent'
				AND table_field.format = $1";
		pg_prepare($dbconn, "", $sql);
		$result = pg_execute($dbconn, "", array(
			$tableFormat
		));
		// The identifier column is present in the table
		if (pg_fetch_row($result)[0] > 0) {

			$request = $this->requestStack->getCurrentRequest();

			// Prefix is siteUrl
			// $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
			$protocol = 'http://'; // Always http because redirections exists from http to https, but not reverse.
			$domainName = ($request) ? strtolower($request->getHttpHost()) : 'test'; // strtolower($_SERVER['SERVER_NAME']);
			$siteUrl = $protocol . $domainName . '/';

			$sql = "CREATE OR REPLACE FUNCTION " . $tableSchema . ".perm_id_generate" . $tableName . "()
				RETURNS TRIGGER
				LANGUAGE plpgsql
				AS $$
				BEGIN
				IF (NEW.identifiantpermanent IS NULL OR NEW.identifiantpermanent = '') THEN
				 NEW.identifiantpermanent  := concat('" . $siteUrl . "occtax/',uuid_generate_v1());
				END IF;
				RETURN NEW;
				END;
				$$;";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array());

			$sql = "CREATE TRIGGER perm_id_generate" . $tableName . " BEFORE INSERT ON " . $tableSchema . "." . $tableName . "
				FOR EACH ROW
				EXECUTE PROCEDURE " . $tableSchema . ".perm_id_generate" . $tableName . "();";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array());
		}
	}

	/**
	 *
	 * Creates the call of the triggers which calculate the sensitivity of an observation.
	 *
	 * @param string $tableName
	 * @param string $tableSchema
	 * @param string $tableFormat
	 * @param string $tableLabel
	 */
	public function createSensitiveTriggers($tableSchema, $tableFormat, $tableName, $tableLabel, $dbconn) {
		// Will the table contains the columns the trigger needs?
		$sql = "SELECT count(table_field.data)
					FROM metadata.table_field
					WHERE table_field.format = $1
					AND table_field.data IN ('sensible', 'sensiniveau','sensidateattribution','sensireferentiel',
					'sensiversionreferentiel', 'sensimanuelle', 'sensialerte', 'cdnom', 'cdref', 'codedepartementcalcule',
					'jourdatefin', 'occstatutbiologique', 'deedatedernieremodification')";
		pg_prepare($dbconn, "", $sql);
		$result = pg_execute($dbconn, "", array(
			$tableFormat
		));

		// the fields needed are present in the table
		if (pg_fetch_row($result)[0] == 13) {

			// Add automatic calcul trigger
			$sql = "CREATE TRIGGER sensitive_automatic" . $tableName . " BEFORE UPDATE OF codedepartementcalcule, cdnom, cdref, jourdatefin, occstatutbiologique ON " . $tableSchema . "." . $tableName . "
						FOR EACH ROW
						EXECUTE PROCEDURE " . $tableSchema . ".sensitive_automatic();";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array());

			// Add manual calcul trigger
			$sql = "CREATE TRIGGER sensitive_manual" . $tableName . " BEFORE UPDATE OF sensiniveau, sensimanuelle ON " . $tableSchema . "." . $tableName . "
						FOR EACH ROW
						EXECUTE PROCEDURE " . $tableSchema . ".sensitive_manual();";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array());
		}
	}

	/**
	 *
	 * Creates the call of the triggers which init mandatory fields
	 *
	 * @param string $tableName
	 * @param string $tableSchema
	 * @param string $tableFormat
	 * @param string $tableLabel
	 */
	public function createInitTrigger($tableSchema, $tableFormat, $tableName, $tableLabel, $dbconn) {
		// Will the table contains the columns the trigger needs?
		$sql = "SELECT count(table_field.data)
					FROM metadata.table_field
					WHERE table_field.format = $1
					AND table_field.data IN (
					'sensible',
					'sensiniveau',
					'deedatedernieremodification')";
		pg_prepare($dbconn, "", $sql);
		$result = pg_execute($dbconn, "", array(
			$tableFormat
		));

		// the fields needed are present in the table
		if (pg_fetch_row($result)[0] == 3) {
			// Add automatic calcul trigger
			$sql = "CREATE TRIGGER init_trigger" . $tableName . " BEFORE INSERT ON " . $tableSchema . "." . $tableName . "
						FOR EACH ROW
						EXECUTE PROCEDURE " . $tableSchema . ".init_trigger();";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array());
		}
	}

	/**
	 * Returns the Postgres type corresponding to Ogam type.
	 *
	 * @param $ogamType ogam
	 *        	type coming from unit table type column.
	 *
	 * @return Postgres type
	 */
	public function getPostgresTypeFromOgamType($ogamType, $ogamUnit, $columnName) {
		switch ($ogamType) {
			case "NUMERIC":
				$result = "float8";
				break;
			case "ARRAY":
				$result = "varchar(255)[]";
				break;
			case "CODE":
				$result = "varchar(255)";
				break;
			case "STRING":
				switch ($columnName) {
					case "commentaire":
						$result = "text";
						break;
					default:
						$result = "varchar(255)";
				}
				break;
			case "DATE":
				switch ($ogamUnit) {
					case "Date":
						$result = "date";
						break;
					case "DateTime":
						$result = "timestamp with time zone";
						break;
					default:
						$result = "date";
				}
				break;
			case "TIME":
				$result = "time";
				break;
			case "INTEGER":
				$result = "int8";
				break;
			default:
				$result = "varchar(255)";
		}
		return $result;
	}
}