<?php
namespace Ign\Bundle\ConfigurateurBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Ign\Bundle\ConfigurateurBundle\Entity\TableFormat;
use Ign\Bundle\ConfigurateurBundle\Entity\DataRepository;
use Ign\Bundle\ConfigurateurBundle\Entity\Model;
use Ign\Bundle\ConfigurateurBundle\Entity\Format;
use Ign\Bundle\ConfigurateurBundle\Entity\TableSchema;
use Ign\Bundle\ConfigurateurBundle\Entity\TableField;
use Ign\Bundle\ConfigurateurBundle\Entity\Field;
use Ign\Bundle\ConfigurateurBundle\Entity\TableTree;
use Ign\Bundle\ConfigurateurBundle\Entity\Data;
use Ign\Bundle\ConfigurateurBundle\Form\TableFormatType;
use Ign\Bundle\ConfigurateurBundle\Form\TableUpdateType;
use Ign\Bundle\ConfigurateurBundle\Form\TableUpdateFieldsType;
use Ign\Bundle\ConfigurateurBundle\Form\ModelType;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Form\FormError;
use Assetic\Exception\Exception;
use Doctrine\DBAL\Connection;

class TableFieldController extends Controller {

	/**
	 * Adds the fields given as argument to the table.
	 * Redirects to table edition page.
	 * @Route("models/{modelId}/tables/{format}/fields/add/{fields}/", name="configurateur_table_add_fields", options={"expose"=true})
	 * @Template()
	 */
	public function addFieldsAction($modelId, $format, $fields) {
		$em = $this->getDoctrine()->getManager();

		$dataRepository = $em->getRepository('IgnConfigurateurBundle:Data');

		$table = $em->getRepository('IgnConfigurateurBundle:TableFormat')->find($format);
		$format = $em->getRepository('IgnConfigurateurBundle:Format')->find($format);

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
				
				$em->getRepository('IgnConfigurateurBundle:TableField')->findAll();
				$em->merge($tableField);
			}
			$em->flush();
		}

		return $this->redirectToRoute('configurateur_table_fields', array(
			'modelId' => $modelId,
			'format' => $format->getFormat()
		));
	}

	/**
	 * Updates the fields given as argument to the table.
	 * Redirects to model edition page.
	 * @Route("models/{modelId}/tables/{format}/fields/update/{fields}/{mandatorys}/", name="configurateur_table_update_fields", options={"expose"=true})
	 * @Template()
	 */
	public function updateFieldsAction($modelId, $fields, $mandatorys = null, $format) {
		$em = $this->getDoctrine()->getManager();

		$dataRepository = $em->getRepository('IgnConfigurateurBundle:Data');
		$format = $em->getRepository('IgnConfigurateurBundle:Format')->find($format);
		$tableName = $em->getRepository('IgnConfigurateurBundle:TableFormat')->find($format)->getLabel();

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
	 * @Template()
	 */
	public function removeAllFieldsAction($modelId, $format) {
		$em = $this->getDoctrine()->getManager();

		$tableFieldRepository = $em->getRepository('IgnConfigurateurBundle:TableField');
		$fieldRepository = $em->getRepository('IgnConfigurateurBundle:Field');
		$mappingRepository = $em->getRepository("IgnConfigurateurBundle:FieldMapping");

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
	 * @Route("/models/{modelId}/tables/{format}/fields/remove/{field}", name="configurateur_table_remove_field")
	 * @Template()
	 */
	public function removeFieldAction($modelId, $field, $format) {
		$em = $this->getDoctrine()->getManager();

		// remove mapping relations first
		$mappingRepository = $em->getRepository("IgnConfigurateurBundle:FieldMapping");
		$mappingRepository->removeAllByTableField($format, $field);

		$tableFieldToRemove = $em->find("IgnConfigurateurBundle:TableField", array(
			"data" => $field,
			"tableFormat" => $format
		));
		$em->remove($tableFieldToRemove);
		$em->flush();

		$fieldToRemove = $em->find("IgnConfigurateurBundle:Field", array(
			"data" => $field,
			"format" => $format
		));
		$em->remove($fieldToRemove);
		$em->flush();

		return $this->redirectToRoute('configurateur_table_fields', array(
			'modelId' => $modelId,
			'format' => $format
		));
	}
}
