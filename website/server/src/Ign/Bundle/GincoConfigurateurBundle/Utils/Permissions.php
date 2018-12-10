<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Utils\Permissions as PermissionsBase;

/**
 * Extends utility class for permissions service.
 *
 * GINCO specific feature :
 *   - DEE model ($modelId = model_1) and its import model ($datasetId = dataset_1) are NEVER editable or deletable
 */
class Permissions extends PermissionsBase {


	public function isModelEditable($modelId) {

		if ($modelId == 'model_1') {
			$this->message = $this->translator->trans('dee.readOnly');
			$this->code = "dee";
			return false;
		}
		return parent::isModelEditable($modelId);
	}

	public function isModelDeletable($modelId) {

		if ($modelId == 'model_1') {
			$this->message = $this->translator->trans('dee.readOnly');
			$this->code = "dee";
			return false;
		}
		return parent::isModelDeletable($modelId);
	}

	public function isImportModelEditable($importModelId) {

		if ($importModelId == 'dataset_1' || $importModelId == 'dataset_100') {
			$this->message = $this->translator->trans('dee.readOnly');
			$this->code = "dee";
			return false;
		}
		return parent::isImportModelEditable($importModelId);
	}

	public function isImportModelDeletable($importModelId) {

		if ($importModelId == 'dataset_1' || $importModelId == 'dataset_100') {
			$this->message = $this->translator->trans('dee.readOnly');
			$this->code = "dee";
			return false;
		}
		return parent::isImportModelDeletable($importModelId);
	}
}