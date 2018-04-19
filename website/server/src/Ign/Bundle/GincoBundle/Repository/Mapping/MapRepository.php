<?php
namespace Ign\Bundle\GincoBundle\Repository\Mapping;

use Ign\Bundle\GincoBundle\Repository\GenericRepository;

/**
 * Class MapRepository
 */
class MapRepository extends GenericRepository {

	/**
	 * Get the precise bbox calculated with all the results linked with session id.
	 *
	 * @param int $projection
	 *        	the projection used for the results
	 * @param string $resultLayer
	 *        	the layer for which the bbox is to be calculated
	 * @param string $sessionId
	 *        	the session id
	 */
	public function getResultsBbox($projection, $sessionId, $resultLayer = 'departement') {
		$conn = $this->getConnection();

		$req = "SELECT st_astext(st_extent(st_transform(geom, $projection ))) as wkt
				FROM bac_$resultLayer bac
				INNER JOIN observation_$resultLayer obs ON obs.id_$resultLayer = bac.id_$resultLayer
				INNER JOIN results res ON res.table_format =  obs.table_format
				AND res.id_provider = obs.id_provider
				AND res.id_observation = obs.id_observation
				INNER JOIN requests req ON res.id_request = req.id
				WHERE req.session_id = ?";

		$query = $conn->prepare($req);
		$query->execute(array(
			$sessionId
		));
		$result = $query->fetchColumn(0);
		return $result;
	}
}