<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\Metadata\Field;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableField;
use Ign\Bundle\GincoBundle\Entity\Metadata\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelManager;

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

		$table = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($format);
		$dataField = $em->getRepository('IgnGincoBundle:Metadata\Data')->find($data);
		
		$modelManager = $this->get(ModelManager::class) ;
		$modelManager->addField($dataField, $table) ;

		return $this->redirectToRoute('configurateur_table_fields', array(
			'modelId' => $modelId,
			'format' => $table->getFormat()->getFormat()
		));
	}

	/**
	 * Adds the fields given as argument to the table.
	 * Redirects to table edition page.
	 * @Route("models/{modelId}/tables/{format}/fields/add/", name="configurateur_table_add_fields", options={"expose"=true})
	 */
	public function addFieldsAction($modelId, $format, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata');

		$modelManager = $this->get(ModelManager::class) ;
		$dataRepository = $em->getRepository('IgnGincoBundle:Metadata\Data');
		$table = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($format);
		$fields = $request->get('addedNames');

		// Handle the name of the fields
		$names = explode(",", $fields);
		foreach ($names as $value) {
			
			$dataField = $dataRepository->find($value);
			$modelManager->addField($dataField, $table) ;
		}

		return $this->redirectToRoute('configurateur_table_update_fields', array(
			'modelId' => $modelId,
			'format' => $table->getFormat()->getFormat(),
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
		$defaultValues = $request->get('defaultValues');

		// Handle the name of the fields
		$data = explode(",", $fields);
		$mandatorys = explode(",", $mandatorys);
		$defaultValues = explode(",", $defaultValues) ;

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
				$defaultValue = empty($defaultValues[$i]) ? null : $defaultValues[$i] ;
				$tableField->setDefaultValue($defaultValue) ;
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
}
