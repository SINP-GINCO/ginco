<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\Data;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\DataRepository;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Field;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Format;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableFormat;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class TableFieldController extends Controller {

	/**
	 * Add one field to the table.
	 * Redirects to table edition page.
	 * @Route("models/{modelId}/tables/{format}/fields/add/{data}", name="configurateur_table_add_field")
	 */
	public function addFieldAction($modelId, $format, $data) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$dataRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Data');

		$table = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($format);
		$format = $em->getRepository('IgnOGAMConfigurateurBundle:Format')->find($format);

		$tableField = new TableField();
		$field = new Field();
		$dataField = $dataRepository->find($data);
		if ($dataField !== null) {
			$field->setData($dataField);
			$field->setFormat($format);
			$field->setType('TABLE');
			$em->merge($field);
		}
		$em->flush();

		if ($dataField !== null) {
			$tableField->setData($dataField->getName());
			$tableField->setTableFormat($table->getFormat());
			$tableField->setColumnName($dataField->getName());

			$em->getRepository('IgnOGAMConfigurateurBundle:TableField')->findAll();
			$em->merge($tableField);
		}
		$em->flush();

		return $this->redirectToRoute('configurateur_table_fields', array(
			'modelId' => $modelId,
			'format' => $format->getFormat()
		));
	}

	/**
	 * Adds the fields given as argument to the table.
	 * Redirects to table edition page.
	 * @Route("models/{modelId}/tables/{format}/fields/add/", name="configurateur_table_add_fields", options={"expose"=true})
	 */
	public function addFieldsAction($modelId, $format, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$dataRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Data');

		$table = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($format);
		$format = $em->getRepository('IgnOGAMConfigurateurBundle:Format')->find($format);
		$fields = $request->get('addedNames');

		// Handle the name of the fields
		$names = explode(",", $fields);
		foreach ($names as $value) {
			$tableField = new TableField();
			$field = new Field();
			$dataField = $dataRepository->find($value);
			if ($dataField !== null) {
				$field->setData($dataField);
				$field->setFormat($format);
				$field->setType('TABLE');
				$em->merge($field);
			}
			$em->flush();

			if ($dataField !== null) {
				$tableField->setData($dataField->getName());
				$tableField->setTableFormat($table->getFormat());
				$tableField->setColumnName($dataField->getName());

				$dataFieldPrefix = substr($dataField->getName(), 0, 8);
				$dataFieldSuffix = substr($dataField->getName(), 8, strlen($dataField->getName())-8);

				// todo : move to input form model when he will exist
				if ($dataFieldPrefix == "OGAM_ID_") {
					if ($dataFieldSuffix == $table->getFormat()){
						// primary key
						$tableField->setIsMandatory("1");
						$tableField->setIsCalculated("1");
						$tableField->setIsEditable("0");
						$tableField->setIsInsertable("0");
					} else {
						// foreign key
						$tableField->setIsMandatory("1");
						$tableField->setIsCalculated("0");
						$tableField->setIsEditable("0");
						$tableField->setIsInsertable("0");
					}
				} elseif ($dataField->getName() == "PROVIDER_ID") {
					$tableField->setIsMandatory("1");
					$tableField->setIsCalculated("0");
					$tableField->setIsEditable("0");
					$tableField->setIsInsertable("0");
				} elseif ($dataField->getName() == "USER_LOGIN") {
					$tableField->setIsMandatory("1");
					$tableField->setIsCalculated("0");
					$tableField->setIsEditable("0");
					$tableField->setIsInsertable("0");
				} elseif ($dataField->getName() == "SUBMISSION_ID") {
					$tableField->setIsMandatory("0");
					$tableField->setIsCalculated("1");
					$tableField->setIsEditable("0");
					$tableField->setIsInsertable("0");
				} else {
					$tableField->setIsMandatory("0");
					$tableField->setIsCalculated("0");
					$tableField->setIsEditable("1");
					$tableField->setIsInsertable("1");
				}

				$em->getRepository('IgnOGAMConfigurateurBundle:TableField')->findAll();
				$em->merge($tableField);
			}
			$em->flush();
		}

		return $this->redirectToRoute('configurateur_table_update_fields', array(
			'modelId' => $modelId,
			'format' => $format->getFormat(),
			'request' => $request
		), 307);
	}

	/**
	 * Updates the fields given as argument to the table.
	 * Redirects to model edition page.
	 * @Route("models/{modelId}/tables/{format}/fields/update/", name="configurateur_table_update_fields", options={"expose"=true})
	 */
	public function updateFieldsAction($modelId, $format, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$dataRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Data');
		$format = $em->getRepository('IgnOGAMConfigurateurBundle:Format')->find($format);
		$tableName = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($format)->getLabel();

		$fields = $request->get('fields');
		$mandatorys = $request->get('mandatorys');

		// Handle the name of the fields
		$data = explode(",", $fields);
		$mandatorys = explode(",", $mandatorys);

		for($i = 0; $i < sizeof($data); $i++){
			$name = $data[$i];
			if($mandatorys[$i] =='true'){
				$mandatory = '1';
			} else {
				$mandatory = '0';
			}
			$tableField = new TableField();
			$field = new Field();
			$dataField = $dataRepository->find($name);

			if ($dataField !== null) {
				$field->setData($dataField);
				$field->setFormat($format);
				$field->setType('TABLE');
				$em->merge($field);
			}

			$em->flush();

			if ($dataField !== null) {

				$tableField->setData($name);
				$tableField->setTableFormat($format->getFormat());
				$tableField->setColumnName($dataField->getName());
				$tableField->setIsMandatory($mandatory);
				$tableField->setIsCalculated("0");
				$tableField->setIsEditable("1");
				$tableField->setIsInsertable("1");

				$em->merge($tableField);
			}

			$em->flush();
		}

		$this->addFlash('notice', $this->get('translator')
			->trans('table.edit.fields.success', array('%tableName%' => $tableName)));

		return $this->redirectToRoute('configurateur_table_fields', array(
			'modelId' => $modelId,
			'format' => $format->getFormat()
		));
	}

	/**
	 * Removes all the non-technical fields of a table.
	 * (including from TableField and Field). Redirects to table edition page.
	 * @Route("/models/{modelId}/tables/{format}/fields/removeall/", name="configurateur_table_remove_all_fields")
	 */
	public function removeAllFieldsAction($modelId, $format) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$tableFieldRepository = $em->getRepository('IgnOGAMConfigurateurBundle:TableField');
		$fieldRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Field');
		$mappingRepository = $em->getRepository("IgnOGAMConfigurateurBundle:FieldMapping");

		$mappingRepository->removeAllByTableFormat($format);
		$tableFieldRepository->deleteNonTechnicalByTableFormat($format);
		$fieldRepository->deleteNonTechnicalByTableFormat($format);

		$em->flush();

		return $this->redirectToRoute('configurateur_table_fields', array(
			'modelId' => $modelId,
			'format' => $format
		));
	}

	/**
	 * Removes a field from a table.
	 * (including from TableField and Field). Redirects to table edition page.
	 * @Route("/models/{modelId}/tables/{format}/fields/remove/{field}", name="configurateur_table_remove_field_and_update", options={"expose"=true})
	 */
	public function removeFieldAction($modelId, $field, $format, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		// remove mapping relations first
		$mappingRepository = $em->getRepository("IgnOGAMConfigurateurBundle:FieldMapping");
		$mappingRepository->removeAllByTableField($format, $field);

		$tableFieldToRemove = $em->find("IgnOGAMConfigurateurBundle:TableField", array(
			"data" => $field,
			"tableFormat" => $format
		));
		$em->remove($tableFieldToRemove);
		$em->flush();

		$fieldToRemove = $em->find("IgnOGAMConfigurateurBundle:Field", array(
			"data" => $field,
			"format" => $format
		));
		$em->remove($fieldToRemove);
		$em->flush();

		return $this->redirectToRoute('configurateur_table_update_fields', array(
			'modelId' => $modelId,
			'format' => $format,
			'request' => $request
		), 307);
	}
}
