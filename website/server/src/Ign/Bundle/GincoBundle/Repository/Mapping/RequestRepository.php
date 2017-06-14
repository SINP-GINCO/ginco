<?php
namespace Ign\Bundle\GincoBundle\Repository\Mapping;

use Doctrine\ORM\NoResultException;
use Doctrine\ORM\Query\ResultSetMappingBuilder;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableField;
use Doctrine\DBAL\Schema\Schema;

/**
 * RequestRepository
 */
class RequestRepository extends \Doctrine\ORM\EntityRepository {

	/**
	 * Create a request.
	 *
	 * @param String $session_id
	 *        	the session id
	 * @return integer the id of the request inserted
	 */
	function createRequest($sessionId) {
		$em = $this->getEntityManager();

		$sql = "INSERT INTO requests (session_id) VALUES ('$sessionId') RETURNING id;";

		$reqId = $em->getConnection()->fetchColumn($sql, array(), 0);
		return $reqId;
	}

	/**
	 * Gets the id of the last request played within the current session.
	 * MIGRATED
	 *
	 * @param
	 *        	Integer the session id
	 * @return String the request id
	 */
	public function getLastRequestIdFromSession($sessionId) {
		$conn = $this->_em->getConnection();

		$sql = "SELECT id FROM requests req WHERE req.session_id = ?
				ORDER BY req.id DESC LIMIT 1";

		$stmt = $conn->prepare($sql);
		$stmt->bindParam(1, $sessionId);
		$stmt->execute(array(
			$sessionId
		));

		return $stmt->fetchColumn();
	}

	/**
	 * Returns the bounding box that bounds geometries of results table.
	 *
	 * @param
	 *        	String the user session id.
	 * @param
	 *        	String the srs_visualisation
	 * @return String the bounging box as WKT (well known text)
	 */
	public function getResultsBBox($sessionId, $projection) {
		$conn = $this->_em->getConnection();
		$sql = "SELECT st_astext(st_extent(st_transform(the_geom," . $projection . "))) as wkt FROM result_location WHERE session_id = :session_id";
		$stmt = $conn->prepare($sql);
		$stmt->bindValue("session_id", $sessionId);
		$stmt->execute();
		$bbox = $stmt->fetchColumn();
		if ($bbox !== FALSE && $bbox !== "") {
			return $bbox;
		} else {
			throw new NoResultException('No result location found for the current session.');
		}
	}

	/**
	 * Returns the number of results in the results table.
	 *
	 * @param
	 *        	String the user session id.
	 * @return Integer the number of results
	 */
	public function getResultsCount($sessionId) {
		$rsm = new ResultSetMappingBuilder($this->_em);
		$rsm->addScalarResult('count', 'count', 'integer');

		$sql = "SELECT count(*) as count FROM result_location WHERE session_id = ?";
		$query = $this->_em->createNativeQuery($sql, $rsm);
		$query->setParameter(1, $sessionId);

		return $query->getSingleScalarResult();
	}

	/**
	 * Returns the intersected location information.
	 *
	 * @param String $sessionId
	 *        	The session id
	 * @param Float $lon
	 *        	the longitude
	 * @param Float $lat
	 *        	the latitude
	 * @param TableField $locationField
	 *        	the location table field
	 * @param String $schema
	 *        	the current Schema
	 * @param ConfigurationManager $configuration
	 *        	the configuration manager
	 * @param String $locale
	 *        	the current locale
	 * @return Array
	 * @throws Exception
	 */
	public function getLocationInfo($sessionId, $lon, $lat, $locationField, $schema, $configuration, $locale) {
		$projection = $configuration->getConfig('srs_visualisation', 3857);
		$selectMode = $configuration->getConfig('featureinfo_selectmode', 'buffer');
		$margin = $configuration->getConfig('featureinfo_margin', '1000');

		$locationTableFormat = $locationField->getFormat()->getFormat();
		// Get the location table infos
		$locationTableInfo = $this->_em->getRepository(TableFormat::class)->getTableFormat($schema, $locationTableFormat, $locale);
		// Get the location table columns
		$tableFields = $this->_em->getRepository(TableField::class)->getTableFields($schema, $locationTableFormat, null, $locale);

		// Setup the location table columns for the select
		$cols = '';
		$joinForMode = '';
		$i = 0;
		foreach ($tableFields as $tableField) {
			if ($tableField->getColumnName() != $locationField->getColumnName() && $tableField->getColumnName() != 'SUBMISSION_ID' && $tableField->getColumnName() != 'PROVIDER_ID' && $tableField->getColumnName() != 'LINE_NUMBER') {
				// Get the mode label if the field is a modality
				$tableFieldUnit = $tableField->getData()->getUnit();
				if ($tableFieldUnit->getType() === 'CODE' && $tableFieldUnit->getSubtype() === 'MODE') {
					$modeAlias = 'm' . $i;
					$translateAlias = 't' . $i;
					$cols .= 'COALESCE(' . $translateAlias . '.label, ' . $modeAlias . '.label) as ' . $tableField->getColumnName() . ', ';
					$joinForMode .= 'LEFT JOIN mode ' . $modeAlias . ' ON ' . $modeAlias . '.CODE = ' . $tableField->getColumnName() . ' AND ' . $modeAlias . '.UNIT = \'' . $tableFieldUnit->getUnit() . '\' ';
					$joinForMode .= 'LEFT JOIN translation ' . $translateAlias . ' ON (' . $translateAlias . '.lang = \'' . $locale . '\' AND ' . $translateAlias . '.table_format = \'MODE\' AND ' . $translateAlias . '.row_pk = ' . $modeAlias . '.unit || \',\' || ' . $modeAlias . '.code) ';
					$i ++;
				} elseif ($tableFieldUnit->getType() === "DATE") {
					$cols .= 'to_char(' . $tableField->getColumnName() . ', \'YYYY/MM/DD\') as ' . $tableField->getColumnName() . ', ';
				} else {
					$cols .= $tableField->getColumnName() . ', ';
				}
			}
		}

		// Setup the location table pks for the join on the location table
		// and for the pk column
		$pkscols = '';
		foreach ($locationTableInfo->getPrimaryKeys() as $primaryKey) {
			$pkscols .= "l." . $primaryKey . "::varchar || '__' || ";
			$cols .= "'" . strtoupper($primaryKey) . "/' || " . $primaryKey . " || '/' || ";
		}
		if ($pkscols != '') {
			$pkscols = substr($pkscols, 0, -11);
		} else {
			throw new \Exception('No pks columns found for the location table.');
		}
		if ($cols != '') {
			$cols = substr($cols, 0, -11) . " as pk ";
		} else {
			throw new \Exception('No columns found for the location table.');
		}

		$req = "SELECT " . $cols . " ";
		if ($selectMode === 'distance') {
			$req .= ", ST_Distance(r.the_geom, ST_SetSRID(ST_Point(?, ?)," . $projection . ")) as dist ";
		}
		$req .= "FROM result_location r ";
		$req .= "LEFT JOIN " . $locationTableInfo->getTableName() . " l on (r.format = '" . $locationTableInfo->getFormat() . "' AND r.pk = " . $pkscols . ") ";
		$req .= $joinForMode;
		$req .= "WHERE r.session_id = ? ";
		if ($selectMode === 'buffer') {
			$req .= "and ST_DWithin(r.the_geom, ST_SetSRID(ST_Point(?, ?)," . $projection . "), " . $margin . ")";
		} elseif ($selectMode === 'distance') {
			$req .= "and ST_Distance(r.the_geom, ST_SetSRID(ST_Point(?, ?)," . $projection . ")) < " . $margin;
			$req .= "ORDER BY dist";
		}

		$conn = $this->_em->getConnection();
		$stmt = $conn->prepare($req);

		if ($selectMode === 'buffer') {
			$stmt->execute(array(
				$sessionId,
				$lon,
				$lat
			));
		} elseif ($selectMode === 'distance') {
			$stmt->execute(array(
				$lon,
				$lat,
				$sessionId,
				$lon,
				$lat
			));
		}

		return $stmt->fetchAll();
	}
}
