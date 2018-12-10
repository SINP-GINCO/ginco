<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication as ModelUnpublicationBase;

/**
 * Extends utility class for copying and publishing metadata.
 *
 * GINCO specific feature :
 * Group form fields if they belong to the data of the dee standard
 */
class ModelUnpublication extends ModelUnpublicationBase {

	/**
	 * Returns true if it is possible to unpublish a model.
	 * The model :
	 * - must be published OR
	 * - OR MUST NOT contain indirectly data OR
	 * - OR MUST NOT linked to a non-deleted jdd.
	 *
	 * @param $modelId: the
	 *        	of the model
	 * @return boolean
	 */
	public function isUnpublishable($modelId) {
		$unpublishable = (!$this->isUnpublished($modelId) && !$this->modelHasData($modelId) && !$this->modelHasJdd($modelId));

		return $unpublishable;
	}

	/**
	 * Checks if a model has a non-deleted jdd linked.
	 *
	 * @param string $modelId
	 *        	: the id of the model
	 * @return boolean
	 */
	public function modelHasJdd($modelId) {
		$hasJdd = false;

		$sql = "SELECT count(id) FROM jdd WHERE model_id = ? AND status <> 'deleted'";
		$stmt = $this->adminConn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		if ($stmt->fetchColumn(0) > 0) {
			$hasJdd = true;
		}

		$this->conn->close();

		return $hasJdd;
	}
}