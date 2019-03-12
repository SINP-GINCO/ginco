<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\Metadata\Field;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableField;
use Ign\Bundle\GincoBundle\Entity\Metadata\Model;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class TableFieldController extends Controller {

	/**
	 * Add one field to the table.
	 * Redirects to table edition page.
	 * @Route("models/{modelId}/tables/{format}/fields/add/{data}", name="configurateur_table_add_field")
	 */
	public function addFieldAction($modelId, $format, $data) {
		$em = $this->getDoctrine()->getManager('metadata');

		$dataRepository = $em->getRepository('IgnGincoBundle:Metadata\Data');

		$table = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($format);
		$format = $em->getRepository('IgnGincoBundle:Metadata\Format')->find($format);

		$tableField = new TableField();
		$field = new Field();
		$dataField = $dataRepository->find($data);
		
		if ($dataField !== null) {
			
			$field->setData($dataField);
			$field->setFormat($format);
			$field->setType('TABLE');
			$em->persist($field);

			$tableField->setData($dataField);
			$tableField->setFormat($table);
			$tableField->setColumnName($dataField->getData());

			$em->getRepository('IgnGincoBundle:Metadata\TableField')->findAll();
			$em->persist($tableField);
		}
		$em->flush();
		
		/* @var $model Model */
		$model = $table->getModel() ;
		if ($model->getPublishedAt() != null) {
			// Le modèle a déjà été publié auparavant, la colone doit etre ajoutée à la table.
			$tablesGeneration = $this->get('app.tablesgeneration') ;
			$tablesGeneration->addColumn($tableField) ;
		}

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
		$em = $this->getDoctrine()->getManager('metadata');

		$dataRepository = $em->getRepository('IgnGincoBundle:Metadata\Data');

		$table = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($format);
		$model = $table->getModel() ;
		$tableFormat = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($format) ;
		$fields = $request->get('addedNames');

		// Handle the name of the fields
		$names = explode(",", $fields);
		foreach ($names as $value) {
			
			$tableField = new TableField();
			$field = new Field();
			$dataField = $dataRepository->find($value);
			
			if ($dataField !== null) {
				$field->setData($dataField);
				$field->setFormat($tableFormat->getFormat());
				$field->setType('TABLE');
				$em->persist($field);

				$tableField->setData($dataField);
				$tableField->setFormat($tableFormat);
				$tableField->setColumnName($dataField->getData());

				$dataFieldPrefix = substr($dataField->getData(), 0, 8);
				$dataFieldSuffix = substr($dataField->getData(), 8, strlen($dataField->getData())-8);

				// todo : move to input form model when he will exist
				if ($dataFieldPrefix == "OGAM_ID_") {
					if ($dataFieldSuffix == $table->getFormat()->getFormat()){
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
				} elseif ($dataField->getData() == "PROVIDER_ID") {
					$tableField->setIsMandatory("1");
					$tableField->setIsCalculated("0");
					$tableField->setIsEditable("0");
					$tableField->setIsInsertable("0");
				} elseif ($dataField->getData() == "USER_LOGIN") {
					$tableField->setIsMandatory("1");
					$tableField->setIsCalculated("0");
					$tableField->setIsEditable("0");
					$tableField->setIsInsertable("0");
				} elseif ($dataField->getData() == "SUBMISSION_ID") {
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

				$em->getRepository('IgnGincoBundle:Metadata\TableField')->findAll();
				$em->merge($tableField);
			}
			$em->flush();
			
			if ($model->getPublishedAt() != null) {
				// Le modèle a déjà été publié auparavant, la colone doit etre ajoutée à la table.
				$tablesGeneration = $this->get('app.tablesgeneration') ;
				$tablesGeneration->addColumn($tableField) ;
			}
		}

		return $this->redirectToRoute('configurateur_table_update_fields', array(
			'modelId' => $modelId,
			'format' => $tableFormat->getFormat()->getFormat(),
			'request' => $request
		), 307);
	}

	/**
	 * Updates the fields given as argument to the table.
	 * Redirects to model edition page.
	 * @Route("models/{modelId}/tables/{format}/fields/update/", name="configurateur_table_update_fields", options={"expose"=true})
	 */
	public function updateFieldsAction($modelId, $format, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata');
		
		$tablesGeneration = $this->get('app.tablesgeneration') ;

		$dataRepository = $em->getRepository('IgnGincoBundle:Metadata\Data');
		$format = $em->getRepository('IgnGincoBundle:Metadata\Format')->find($format);
		$tableFormat = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($format);
		
		$tableFieldRepository = $em->getRepository('IgnGincoBundle:Metadata\TableField') ;
		$fieldRepository = $em->getRepository('IgnGincoBundle:Metadata\Field') ;

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

			$dataField = $dataRepository->find($name);
			
			if ($dataField !== null) {
				
				$field = $fieldRepository->find(array(
					'data' => $dataField,
					'format' => $format
				));

				$field->setData($dataField);
				$field->setFormat($format);
				$field->setType('TABLE');
				
				$tableField = $tableFieldRepository->find(array(
					'data' => $dataField,
					'format' => $format
				));

				$tableField->setData($dataField);
				$tableField->setFormat($tableFormat);
				$tableField->setColumnName($dataField->getData());
				if (boolval($mandatory) && !$tableField->getIsMandatory()) {
					$tablesGeneration->addNotNull($tableField) ;
				}
				if (!boolval($mandatory) && $tableField->getIsMandatory()) {
					$tablesGeneration->dropNotNull($tableField) ;
				}
				$tableField->setIsMandatory($mandatory);
			}

			$em->flush();
		}

		$this->addFlash('notice', $this->get('translator')
			->trans('table.edit.fields.success', array('%tableName%' => $tableFormat->getLabel())));

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
		$em = $this->getDoctrine()->getManager('metadata');

		$tableFieldRepository = $em->getRepository('IgnGincoBundle:Metadata\TableField');
		$fieldRepository = $em->getRepository('IgnGincoBundle:Metadata\Field');
		$mappingRepository = $em->getRepository("IgnGincoBundle:Metadata\FieldMapping");

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
		$em = $this->getDoctrine()->getManager('metadata');

		// remove mapping relations first
		$mappingRepository = $em->getRepository("IgnGincoBundle:Metadata\FieldMapping");
		$mappingRepository->removeAllByTableField($format, $field);

		$tableFieldToRemove = $em->find("IgnGincoBundle:Metadata\TableField", array(
			"data" => $field,
			"tableFormat" => $format
		));
		$em->remove($tableFieldToRemove);
		$em->flush();

		$fieldToRemove = $em->find("IgnGincoBundle:Metadata\Field", array(
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
