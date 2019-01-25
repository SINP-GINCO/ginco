<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\Metadata\Field;
use Ign\Bundle\GincoBundle\Entity\Metadata\FieldMapping;
use Ign\Bundle\GincoBundle\Entity\Metadata\FileField;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class FileFieldController extends Controller {

	/**
	 * Adds the fields given as argument to the file.
	 * Redirects to file fields page.
	 * @Route("datasetsimport/{datasetId}/files/{format}/fields/addAndUpdate/", name="configurateur_file_add_fields_and_update", options={"expose"=true})
	 * @Route("datasetsimport/{datasetId}/files/{format}/fields/add/", name="configurateur_file_add_fields", options={"expose"=true})
	 */
	public function addFieldsAction($datasetId, $format, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata');

		$dataRepository = $em->getRepository('IgnGincoBundle:Metadata\Data');

		$file = $em->getRepository('IgnGincoBundle:Metadata\FileFormat')->find($format);
		$format = $em->getRepository('IgnGincoBundle:Metadata\Format')->find($format);

		// Retrieve data from form
		$addedFields = $request->get('addedFields');
		$fields = $request->get('fields');
		$labelCSVs = $request->get('labelCSVs');
		$mandatorys = $request->get('mandatorys');
		$masks = $request->get('masks');

		// Handle the name of the fields
		$data = explode(",", $addedFields);
		foreach ($data as $value) {

			$fileField = new FileField();
			$field = new Field();
			$dataField = $dataRepository->find($value);
			if ($dataField !== null) {
				$field->setData($dataField);
				$field->setFormat($format);
				$field->setType('FILE');
				$em->merge($field);
			}
			$em->flush();

			if ($dataField !== null) {
				$fileField->setData($dataField);
				$fileField->setFormat($file);
				$fileField->setLabelCSV($dataField->getLabel());

				if ($dataField->getUnit()->getUnit() == 'Date') {
					$fileField->setMask('yyyy-MM-dd');
				} elseif ($dataField->getUnit()->getUnit() == 'DateTime') {
					$fileField->setMask("yyyy-MM-dd'T'HH:mmZ");
				} elseif ($dataField->getUnit()->getUnit() == 'Time') {
					$fileField->setMask("HH:mm");
				} else {
					$fileField->setMask(null);
				}

				$fileField->setIsMandatory("0");

				$em->merge($fileField);
			}
			$em->flush();
		}

		if ($fields === null) {

			$dataset = $em->getRepository('IgnGincoBundle:Metadata\Dataset')->find($datasetId);
			$tables = $dataset->getModel()->getTables();
			foreach ($tables as $table) {
				$this->doAutoMapping($table->getFormat(), $format->getFormat());
			}

			return $this->redirectToRoute('configurateur_file_fields', array(
				'datasetId' => $datasetId,
				'format' => $format->getFormat()
			));
		}

		// Remove trailing comas
		$fields = rtrim($fields, ",");
		$labelCSVs = rtrim($labelCSVs, ",");
		$mandatorys = rtrim($mandatorys, ",");
		$masks = substr($masks, 0, -1);

		return $this->redirectToRoute('configurateur_file_update_fields', array(
			'datasetId' => $datasetId,
			'format' => $format->getFormat(),
			'request' => $request
		), 307);
	}

	/**
	 * Updates the fields given as argument to the file.
	 * Redirects to import model edition page.
	 * @Route("datasetsimport/{datasetId}/files/{format}/fields/update/", name="configurateur_file_update_fields", options={"expose"=true})
	 */
	public function updateFieldsAction($datasetId, $format, $toMapping = false, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata');

		$dataRepository = $em->getRepository('IgnGincoBundle:Metadata\Data');

		$file = $em->getRepository('IgnGincoBundle:Metadata\FileFormat')->find($format);
		$format = $em->getRepository('IgnGincoBundle:Metadata\Format')->find($format);

		// Retrieve data from form
		$fields = $request->get('fields');
		$labelCSVs = $request->get('labelCSVs');
		$mandatorys = $request->get('mandatorys');
		$masks = $request->get('masks');

		// Handle the name of the fields
		$data = explode(",", $fields);
		$labelCSVs = explode(",", $labelCSVs);
		$mandatorys = explode(",", $mandatorys);
		$masks = explode(",", $masks);
		$masks = array_map("urldecode", $masks);

		for ($i = 0; $i < sizeof($data); $i ++) {
			$name = $data[$i];

			if ($labelCSVs[$i] == 'null') {
				$labelCSV = $data[$i];
			} else {
				$labelCSV = $labelCSVs[$i];
			}

			// Custom validator to check unicity of labelCSV in the file
			// Entity constraint is impossible to use as labelCSV is set after form is valid.
			$fileFieldRepository = $em->getRepository('IgnGincoBundle:Metadata\FileField');
			$existingLabelCSVFileField = $fileFieldRepository->findOneBy(array(
				'labelCSV' => $labelCSV,
				'format' => $format->getFormat()
			));
			if ($existingLabelCSVFileField && $existingLabelCSVFileField->getData()->getData() != $name) {
				// labelCSV already exists : we add a flash error
				$this->addFlash('error', $this->get('translator')
					->trans('fileField.labelCSV.unique', array(
					'%existingLabelCSV%' => $existingLabelCSVFileField->getLabelCSV()
				)));
				return $this->redirectToRoute('configurateur_file_fields', array(
					'datasetId' => $datasetId,
					'format' => $format->getFormat()
				));
			}

			if ($mandatorys[$i] == 'true') {
				$mandatory = '1';
			} else {
				$mandatory = '0';
			}

			if ($masks[$i] == 'null') {
				$mask = null;
			} else {
				$mask = $masks[$i];
			}

			$fileField = new FileField();
			$field = new Field();

			$dataField = $dataRepository->find($name);

			if ($dataField !== null) {
				$field->setData($dataField);
				$field->setFormat($format);
				$field->setType('FILE');
				$em->merge($field);
			}

			if ($dataField !== null) {
				$fileField->setData($dataField);
				$fileField->setLabelCSV($labelCSV);
				$fileField->setFormat($file);
				$fileField->setMask($mask);
				$fileField->setIsMandatory($mandatory);

				$em->merge($fileField);
			}

			$em->flush();
		}

		$this->addFlash('notice', $this->get('translator')
			->trans('file.edit.fields.success', array(
			'%file.label%' => $file->getLabel()
		)));

		$dataset = $em->getRepository('IgnGincoBundle:Metadata\Dataset')->find($datasetId);
		$tables = $dataset->getModel()->getTables();
		foreach ($tables as $table) {
			$this->doAutoMapping($table->getFormat(), $format->getFormat());
		}

		if ($toMapping == 'true') {
			return $this->redirectToRoute('configurateur_file_mappings', array(
				'datasetId' => $datasetId,
				'format' => $format->getFormat()
			));
		} else {
			return $this->redirectToRoute('configurateur_file_fields', array(
				'datasetId' => $datasetId,
				'format' => $format->getFormat()
			));
		}
	}

	/**
	 * Performs auto-mapping between table with format $tableFormat, file with format $fileFormat
	 *
	 * @param
	 *        	$tableFormat
	 * @param
	 *        	$fileFormat
	 * @return string : the report to show to the user
	 */
	public function doAutoMapping($tableFormat, $fileFormat) {
		$this->get('monolog.logger.ginco')->debug('doAutoMapping');
		$em = $this->getDoctrine()->getManager('metadata');

		$tableFields = $em->getRepository('IgnGincoBundle:Metadata\TableField')->findFieldsByTableFormat($tableFormat);

		$fieldMappings = $em->getRepository('IgnGincoBundle:Metadata\FieldMapping')->findMappings($fileFormat, 'FILE');
		$notMappedFields = $em->getRepository('IgnGincoBundle:Metadata\FieldMapping')->findNotMappedFields($fileFormat, 'FILE');

		// We try to auto-map the notMappedFields
		foreach ($notMappedFields as $fileField) {
			$srcData = $fileField['data'];

			// Search same DATA in tableFields
			$destField = null;
			$alreadyMapped = false;

			foreach ($tableFields as $tableField) {
				if ($tableField['fieldName'] == $srcData) {
					$destField = $tableField;
					// Is this tableField already mapped in the file ?
					foreach ($fieldMappings as $fieldMapping) {
						if ($fieldMapping['dstData'] == $srcData && $fieldMapping['dstFormat'] == $tableFormat) {
							$alreadyMapped = true;
						}
					}
				}
			}

			if ($destField && !$alreadyMapped) {
				// Create a new mapping
				$fieldMapping = new FieldMapping();
				$fieldMapping->setSrcFormat($fileFormat);
				$fieldMapping->setSrcData($srcData);
				$fieldMapping->setDstFormat($tableFormat);
				$fieldMapping->setDstData($srcData);
				$fieldMapping->setMappingType('FILE');
				$em->persist($fieldMapping);
				$em->flush();
			}
		}
	}

	/**
	 * Removes all the fields of a file.
	 * (including from FileField and Field). Redirects to file fields page.
	 * @Route("/datasetsimport/{datasetId}/files/{format}/fields/removeall/", name="configurateur_file_remove_all_fields")
	 */
	public function removeAllFieldsAction($datasetId, $format) {
		$em = $this->getDoctrine()->getManager('metadata');

		$fileFieldRepository = $em->getRepository('IgnGincoBundle:Metadata\FileField');
		$fieldRepository = $em->getRepository('IgnGincoBundle:Metadata\Field');
		$mappingRepository = $em->getRepository("IgnGincoBundle:Metadata\FieldMapping");

		$mappingRepository->removeAllByFileFormat($format);
		$fileFieldRepository->deleteAllByFileFormat($format);
		$fieldRepository->deleteAllByFileFormat($format);

		$em->flush();

		return $this->redirectToRoute('configurateur_file_fields', array(
			'datasetId' => $datasetId,
			'format' => $format
		));
	}

	/**
	 * Removes a field from a file and updates also the file fields.
	 * (including from FileField and Field).
	 * @Route("/datasetsimport/{datasetId}/files/{format}/fields/remove/{field}/", name="configurateur_file_remove_field_and_update", options={"expose"=true})
	 */
	public function removeFieldAction($datasetId, $field, $format, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata');

		$fileFieldToRemove = $em->getRepository('IgnGincoBundle:Metadata\FileField')->findOneBy(array(
			"data" => $field,
			"format" => $format
		));

		$fieldToRemove = $em->find("IgnGincoBundle:Metadata\Field", array(
			"data" => $field,
			"format" => $format
		));

		$fields = $request->get('fields');
		$labelCSVs = $request->get('labelCSVs');
		$mandatorys = $request->get('mandatorys');
		$masks = $request->get('masks');

		// Remove trailing comas of fields to update
		$fields = rtrim($fields, ",");
		$labelCSVs = rtrim($labelCSVs, ",");
		$mandatorys = rtrim($mandatorys, ",");
		$masks = substr($masks, 0, -1);

		// Convert fields to update to arrays
		$fields = explode(',', $fields);
		$labelCSVs = explode(',', $labelCSVs);
		$mandatorys = explode(',', $mandatorys);
		$masks = explode(',', $masks);

		// Delete mapping relations first
		$mappingRepository = $em->getRepository("IgnGincoBundle:Metadata\FieldMapping");
		$mappingRepository->removeAllByFileField($format, $field);

		// Remove from FileField
		$em->remove($fileFieldToRemove);
		$em->flush();

		// Remove from Field
		$em->remove($fieldToRemove);
		$em->flush();

		// Manage only the positions of the next fields
		$fileFieldToRemovePosition = array_search($fileFieldToRemove->getData(), $fields);

		// Remove from update arrays
		unset($labelCSVs[$fileFieldToRemovePosition]);
		unset($mandatorys[$fileFieldToRemovePosition]);
		unset($masks[$fileFieldToRemovePosition]);
		unset($fields[$fileFieldToRemovePosition]);

		// Re-index the update arrays
		$labelCSVs = array_values($labelCSVs);
		$mandatorys = array_values($mandatorys);
		$masks = array_values($masks);
		$fields = array_values($fields);

		if (count($fields) == 0) {
			return $this->redirectToRoute('configurateur_file_fields', array(
				'datasetId' => $datasetId,
				'format' => $format
			));
		}

		return $this->redirectToRoute('configurateur_file_update_fields', array(
			'datasetId' => $datasetId,
			'request' => $request,
			'format' => $format
		), 307);
	}
}
