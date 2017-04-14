<?php
namespace Ign\Bundle\GincoBundle\Repository\RawData;

use Doctrine\ORM\Query\ResultSetMapping;
use Ign\Bundle\OGAMBundle\Repository\GenericRepository;

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
	public function getPreciseBbox($projection, $resultLayer, $sessionId) {
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

	/**
	 * Get the bbox calculated with the envelope of the region given.
	 *
	 * @param int $projection
	 *        	the projection used for the results
	 * @param string $regionCode
	 *        	the code of the region (in GEOFLA)
	 */
	public function getRegionBbox($projection, $regionCode) {
		$conn = $this->getConnection();

		$req = "SELECT st_astext(st_envelope(st_transform(geom, $projection))) as wkt
				FROM referentiels.geofla_region
				WHERE code_reg = ?";

		$query = $conn->prepare($req);
		$query->execute(array(
			$regionCode
		));
		$result = $query->fetchColumn(0);
		return $result;
	}

	/**
	 * Get the bbox calculated by getting the envelope of all regions
	 * contained in the French metropolitan area.
	 *
	 * @param int $projection
	 *        	the projection used for the results
	 */
	public function getMetropolitanBbox($projection) {
		$conn = $this->getConnection();

		$req = "SELECT st_astext(st_extent(st_transform(geom, 3857))) as wkt
				FROM referentiels.geofla_region
				WHERE code_reg NOT LIKE '0%'";

		$query = $conn->prepare($req);
		$query->execute();
		$result = $query->fetchColumn(0);

		return $result;
	}
}