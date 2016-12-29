<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\FileFormat;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\DataRepository;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Dataset;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Format;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\FileField;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Field;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Data;
use Ign\Bundle\OGAMConfigurateurBundle\Form\FileFormatType;
use Ign\Bundle\OGAMConfigurateurBundle\Form\DatasetImportType;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Assetic\Exception\Exception;

class FileFieldController extends Controller {

	/**
	 * Adds the fields given as argument to the file.
	 * Redirects to file fields page.
	 * @Route("datasetsimport/{datasetId}/files/{format}/fields/add/{addedFields}/update/{fields}/{mandatorys}/{masks}/{orders}/", name="configurateur_file_add_fields_and_update", options={"expose"=true})
	 * @Route("datasetsimport/{datasetId}/files/{format}/fields/add/{addedFields}/", name="configurateur_file_add_fields", options={"expose"=true})
	 * @Template()
	 */
	public function addFieldsAction($datasetId, $addedFields, $fields = null, $mandatorys = null, $masks = null, $orders = null, $format) {
		$em = $this->getDoctrine()->getManager();

		$dataRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Data');

		$file = $em->getRepository('IgnOGAMConfigurateurBundle:FileFormat')->find($format);
		$format = $em->getRepository('IgnOGAMConfigurateurBundle:Format')->find($format);

		// get position for the added field (use if it is a new one)
		$existingFields = $em->getRepository('IgnOGAMConfigurateurBundle:FileField')->findBy(array(
			'fileFormat' => $format->getFormat()
		), array(
			'position' => 'DESC'
		));
		if (!$existingFields) {
			$position = '1';
		} else {
			$position = $existingFields[0]->getPosition() + 1;
		}

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
				// check if the field has already been added to keep is old position
				$existingField = $em->getRepository('IgnOGAMConfigurateurBundle:FileField')->findOneBy(array(
					'fileFormat' => $format->getFormat(),
					'data' => $dataField->getName()
				));
				if (!$existingField) {
					$fileField->setPosition($position);
					$position = $position + 1;
				} else {
					$fileField->setPosition($existingField->getPosition());
				}

				$fileField->setData($dataField->getName());
				$fileField->setFileFormat($file->getFormat());

				if ($dataField->getUnit()->getName() == 'Date') {
					$fileField->setMask('yyyy-MM-dd');
				} elseif ($dataField->getUnit()->getName() == 'DateTime') {
					$fileField->setMask("yyyy-MM-dd'T'HH:mmZ");
				} elseif ($dataField->getUnit()->getName() == 'Time') {
					$fileField->setMask("HH:mm");
 				}  else {
					$fileField->setMask('');
				}

				$fileField->setIsMandatory("0");

				$em->merge($fileField);
			}
			$em->flush();
		}

		if ($fields === null) {
			return $this->redirectToRoute('configurateur_file_fields', array(
				'datasetId' => $datasetId,
				'format' => $format->getFormat()
			));
		}

		// Remove trailing comas
		$fields = rtrim($fields, ",");
		$mandatorys = rtrim($mandatorys, ",");
		$orders = rtrim($orders, ",");
		$masks = substr($masks, 0, -1);

		return $this->redirectToRoute('configurateur_file_update_fields', array(
			'datasetId' => $datasetId,
			'fields' => $fields,
			'mandatorys' => $mandatorys,
			'masks' => $masks,
			'orders' => $orders,
			'format' => $format->getFormat(),
			'toMapping' => 'false'
		));
	}

	/**
	 * Updates the fields given as argument to the file.
	 * Redirects to import model edition page.
	 * @Route("datasetsimport/{datasetId}/files/{format}/fields/update/{fields}/{mandatorys}/{masks}/{orders}/{toMapping}/", name="configurateur_file_update_fields", options={"expose"=true})
	 * @Template()
	 */
	public function updateFieldsAction($datasetId, $fields, $mandatorys = null, $masks = null, $orders = null, $format, $toMapping = false) {
		$em = $this->getDoctrine()->getManager();

		$dataRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Data');

		$file = $em->getRepository('IgnOGAMConfigurateurBundle:FileFormat')->find($format);
		$format = $em->getRepository('IgnOGAMConfigurateurBundle:Format')->find($format);

		// Handle the name of the fields
		$data = explode(",", $fields);
		$mandatorys = explode(",", $mandatorys);
		$masks = explode(",", $masks);
		$masks = array_map("urldecode", $masks);
		$orders = explode(",", $orders);

		for ($i = 0; $i < sizeof($data); $i ++) {
			$name = $data[$i];

			if ($mandatorys[$i] == 'true') {
				$mandatory = '1';
			} else {
				$mandatory = '0';
			}

			if ($masks[$i] == 'null') {
				$mask = '';
			} else {
				$mask = $masks[$i];
			}
			$order = $orders[$i];

			$fileField = new FileField();
			$field = new Field();

			$dataField = $dataRepository->find($name);

			if ($dataField !== null) {
				$field->setData($dataField);
				$field->setFormat($format);
				$field->setType('FILE');
				$em->merge($field);
			}

			$em->flush();

			if ($dataField !== null) {
				$fileField->setData($name);
				$fileField->setFileFormat($file->getFormat());
				$fileField->setMask($mask);
				$fileField->setIsMandatory($mandatory);
				$fileField->setPosition($order);

				$em->merge($fileField);
			}

			$em->flush();
		}

		$this->addFlash('notice', $this->get('translator')
			->trans('file.edit.fields.success', array(
			'%file.label%' => $file->getLabel()
		)));

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
	 * Removes all the fields of a file.
	 * (including from FileField and Field). Redirects to file fields page.
	 * @Route("/datasetsimport/{datasetId}/files/{format}/fields/removeall/", name="configurateur_file_remove_all_fields")
	 * @Template()
	 */
	public function removeAllFieldsAction($datasetId, $format) {
		$em = $this->getDoctrine()->getManager();

		$fileFieldRepository = $em->getRepository('IgnOGAMConfigurateurBundle:FileField');
		$fieldRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Field');
		$mappingRepository = $em->getRepository("IgnOGAMConfigurateurBundle:FieldMapping");

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
	 * @Route("/datasetsimport/{datasetId}/files/{format}/fields/remove/{field}/update/{fields}/{mandatorys}/{masks}/{orders}/", name="configurateur_file_remove_field_and_update", options={"expose"=true})
	 * @Template()
	 */
	public function removeFieldAction($datasetId, $field, $fields = null, $mandatorys = null, $masks = null, $orders = null, $format) {
		$em = $this->getDoctrine()->getManager();

		$fileFieldToRemove = $em->getRepository('IgnOGAMConfigurateurBundle:FileField')->findOneBy(array(
			"data" => $field,
			"fileFormat" => $format
		));

		$fieldToRemove = $em->find("IgnOGAMConfigurateurBundle:Field", array(
			"data" => $field,
			"format" => $format
		));

		// Remove trailing comas of fields to update
		$fields = rtrim($fields, ",");
		$mandatorys = rtrim($mandatorys, ",");
		$orders = rtrim($orders, ",");
		$masks = substr($masks, 0, -1);

		// Convert fields to update to arrays
		$fields = explode(',', $fields);
		$mandatorys = explode(',', $mandatorys);
		$masks = explode(',', $masks);
		$orders = explode(',', $orders);

		// Delete mapping relations first
		$mappingRepository = $em->getRepository("IgnOGAMConfigurateurBundle:FieldMapping");
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
		unset($orders[$fileFieldToRemovePosition]);
		unset($mandatorys[$fileFieldToRemovePosition]);
		unset($masks[$fileFieldToRemovePosition]);
		unset($fields[$fileFieldToRemovePosition]);

		// Re-index the update arrays
		$orders = array_values($orders);
		$mandatorys = array_values($mandatorys);
		$masks = array_values($masks);
		$fields = array_values($fields);

		// Decrease order value for each next field
		for ($i = $fileFieldToRemovePosition; $i < count($fields); $i ++) {
			$orders[$i] = strval($orders[$i] - 1);
		}

		if (count($fields) == 0) {
			return $this->redirectToRoute('configurateur_file_fields', array(
				'datasetId' => $datasetId,
				'format' => $format
			));
		}

		return $this->redirectToRoute('configurateur_file_update_fields', array(
			'datasetId' => $datasetId,
			'fields' => implode(',', $fields),
			'mandatorys' => implode(',', $mandatorys),
			'masks' => implode(',', $masks),
			'orders' => implode(',', $orders),
			'format' => $format,
			'toMapping' => 'false'
		));
	}
}
