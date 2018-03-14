<?php
namespace Ign\Bundle\GincoBundle\Repository\Mapping;

use Doctrine\ORM\Query\ResultSetMapping;
use Doctrine\ORM\NoResultException;
use Doctrine\ORM\Query\ResultSetMappingBuilder;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableField;
use Doctrine\DBAL\Schema\Schema;

/**
 * ResultRepository
 */
class ResultRepository extends \Doctrine\ORM\EntityRepository {

	/**
	 * Clean the previous results
	 *
	 * @param String $session_id
	 *        	the session id
	 */
	function cleanPreviousResults($session_id) {
		$qm = $this->getEntityManager();

		// Deleting from requests also delete from results because of the
		// ON DELETE CASCADE in the definition of the table
		$sql = "DELETE FROM requests
				WHERE session_id = ? OR (_creationdt < CURRENT_TIMESTAMP - INTERVAL '2 days')";
		$query = $qm->createNativeQuery($sql, new ResultSetMapping());
		$query->execute(array(
			$session_id
		));
	}

	/**
	 * Insert results in the result table.
	 *
	 * @param int $reqId
	 *        	the id of the request
	 * @param string $tableFormat
	 *        	the table format
	 * @param array $keys
	 *        	the name of the primary keys of the table
	 * @param int $defaultHidingLevel
	 *        	the default hiding level
	 * @param string $from
	 *        	the FROM part of the SQL request
	 * @param string $where
	 *        	the WHERE part of the SQL Request
	 */
	public function insert($reqId, $tableFormat, $keys, $defaultHidingLevel, $from, $where) {
		$em = $this->getEntityManager();
		$sql = "INSERT INTO results (id_request, id_observation, id_provider, table_format, hiding_level)
				SELECT DISTINCT $reqId, " . $tableFormat . "." . $keys['id_observation'] . "
				, $tableFormat." . $keys['id_provider'] . ", ? , $defaultHidingLevel $from $where;";


		$query = $em->createNativeQuery($sql, new ResultSetMapping());
		$query->execute(array($tableFormat));
	}

	/**
	 * Updates the hiding_level column for all values given.
	 *
	 * @param array $tableValues
	 *        	the list of the values of the primary key fields
	 * @param String $tableFormat
	 *        	the format of the table
	 * @param String $sessionId
	 *        	the id of the user session
	 * @param array $permissions
	 *        	the user permissions
	 */
	public function bulkUpdate($tableValues, $tableFormat, $sessionId, $permissions) {
		$em = $this->getEntityManager();
		$fullRequest = "";
		if ($permissions['logged']) {
			$minHidingLevel = 0;
		} else {
			$minHidingLevel = 1;
		}

		for ($i = 0; $i < count($tableValues); $i ++) {
			if ($tableValues[$i]['hiding_level'] > $minHidingLevel) {
				$fullRequest .= "UPDATE results AS res SET hiding_level = " . $tableValues[$i]['hiding_level'] . " FROM requests AS req ";
				$fullRequest .= "WHERE res.id_provider = '" . $tableValues[$i]['id_provider'] . "' ";
				$fullRequest .= "AND res.id_observation = '" . $tableValues[$i]['id_observation'] . "' ";
				$fullRequest .= "AND res.table_format = '" . $tableFormat . "' ";
				$fullRequest .= "AND res.id_request = req.id AND req.session_id = '" . $sessionId . "';";
			}
		}

		if (!empty($fullRequest)) {
			$em->getConnection()->exec($fullRequest);
// 			$query = $em->createNativeQuery($fullRequest, new ResultSetMapping());
// 			$query->execute();
		}
	}

	/**
	 * Deletes the rows that should not appear on the map or in the results table.
	 * Criteria for deleting rows is based on the calculation of the maximum level of
	 * precision asked by the user. If this maximum level is inferior to the hiding_level
	 * of the row, the row will be deleted.
	 * All rows where hiding_level calculated is exactly 4 (no result should be returned) are
	 * also deleted.
	 *
	 * @param string $reqId
	 *        	the id of the request
	 * @param string $maxPrecisionLevel
	 *        	the maximum level of
	 *        	precision asked by the user
	 */
	public function deleteUnshowableResults($reqId, $maxPrecisionLevel) {
		$sql = "DELETE FROM results WHERE hiding_level > ? AND id_request = ?";

		$em = $this->getEntityManager();
		$query = $em->createNativeQuery($sql, new ResultSetMapping());
		$query->execute(array(
			$maxPrecisionLevel,
			$reqId
		));

		$sql = "DELETE FROM results WHERE hiding_level = 4 AND id_request = ?";
		$query = $em->createNativeQuery($sql, new ResultSetMapping());
		$query->execute(array(
			$reqId
		));
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

		$sql = "SELECT count(*) FROM results
 				INNER JOIN requests ON results.id_request = requests.id
 				WHERE session_id = ?";
		$query = $this->_em->createNativeQuery($sql, $rsm);
		$query->setParameter(1, $sessionId);

		return $query->getSingleScalarResult();
	}

	protected function getSchema() {
		$websiteSession = new Zend_Session_Namespace('website');
		return $websiteSession->schema;
	}

	protected function getQueryCriterias() {
		$websiteSession = new Zend_Session_Namespace('website');
		return $websiteSession->formQuery->criterias;
	}
}
