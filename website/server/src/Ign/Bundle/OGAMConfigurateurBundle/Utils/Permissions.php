<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;


use Doctrine\DBAL\Connection;
use Monolog\Logger;

/**
 * Utility class for getting permissions on Models and Datasets.
 *
 * @author S. Candelier
 *
 */
class Permissions extends DatabaseUtils {

	/**
	 * @var : the model publication service
	 */
	protected $modelPublication;

	/**
	 * @var : the import model publication service
	 */
	protected $importModelPublication;

	/**
	 * @var : translator service
	 */
	protected $translator;

	/**
	 * @var string : a code explaining the last permission requested
	 */
	protected $code;

	/**
	 * @var string : an explanation message about the last permission requested
	 */
	protected $message;


	public function __construct(Connection $conn, Logger $logger, $adminName, $adminPassword, $translator) {
		parent::__construct($conn, $logger, $adminName, $adminPassword);
		$this->translator = $translator;
		$this->message = "";
	}

	public function setModelPublication($modelPublication)
	{
		$this->modelPublication = $modelPublication;
	}

	public function setImportModelPublication($importModelPublication)
	{
		$this->importModelPublication = $importModelPublication;
	}

	/**
	 * Returns an explanation message about the last permission required
	 * and then deletes it (to make it impossible to ask several times for the same message)
	 *
	 * @return string
	 */
	public function getMessage()
	{
		$message = $this->message;
		$this->message = "";
		return $message;
	}

	/**
	 * Returns an explanation code about the last permission required
	 * and then deletes it (to make it impossible to ask several times for the same code)
	 *
	 * @return string
	 */
	public function getCode()
	{
		$code = $this->code;
		$this->code = "";
		return $code;
	}

	/**
	 * Returns true if it is possible to edit a model.
	 * The model :
	 * - must NOT be published
	 * - that's all but check GincoConfigurateurBundle for extra conditions
	 *
	 * @param $modelId: the	id of the model
	 * @return boolean
	 */
	public function isModelEditable($modelId) {

		$editable = true;
		if ($this->modelPublication->isPublished($modelId)) {
			$editable = false;
			$this->message = $this->translator->trans('datamodel.edit.warning');
			$this->code = "published";
		}
		return $editable;
	}


	/**
	 * Returns true if it is possible to delete a model.
	 *
	 * @param $modelId: the	id of the model
	 * @return boolean
	 */
	public function isModelDeletable($modelId) {

		$deletable = $this->isModelEditable($modelId);
		if (!$deletable) {
			if ($this->code == "published") {
				$this->message = $this->translator->trans('datamodel.delete.hastounpublish');
			}
		}
		return $deletable;
	}

	/**
	 * Returns true if it is possible to edit an import model.
	 * The import model :
	 * - must NOT be published
	 * - that's all but check GincoConfigurateurBundle for extra conditions
	 *
	 * @param $importModelId: the	id of the model
	 * @return boolean
	 */
	public function isImportModelEditable($importModelId) {

		$editable = true;
		if ($this->importModelPublication->isPublished($importModelId)) {
			$editable = false;
			$this->message = $this->translator->trans('importmodel.edit.warning');
			$this->code = "published";
		}
		return $editable;
	}

	/**
	 * Returns true if it is possible to delete an import model.
	 *
	 * @param $importModelId: the	id of the model
	 * @return boolean
	 */
	public function isImportModelDeletable($importModelId) {

		$deletable = $this->isImportModelEditable($importModelId);
		if (!$deletable) {
			if ($this->code == "published") {
				$this->message = $this->translator->trans('importmodel.delete.forbidden');
			}
		}
		return $deletable;
	}

}