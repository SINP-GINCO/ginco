<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Controller\TableController as TableControllerBase;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Data;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\DataRepository;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Format;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableFormat;
use Ign\Bundle\OGAMConfigurateurBundle\Form\TableUpdateFieldsType;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class TableController extends TableControllerBase {

	/**
	 * #600 : Forbid access to table creation.
	 * User is not allowed to add new tables to models.
	 *
	 * @param string $id,
	 *        	the identifier of the model
	 * @param Request $request
	 * @return @Route("models/{id}/tables/new/", name="configurateur_table_index", defaults={"id":0})
	 */
	public function newAction(Model $model, Request $request) {
		$this->addFlash('error', $this->get('translator')
			->trans('table.new.forbidden'));

		return $this->redirectToRoute('configurateur_model_edit', array(
			'id' => $model->getId()
		));
	}

	/**
	 * @Route("models/{modelId}/tables/{format}/fields/", name="configurateur_table_fields")
	 */
	public function manageFieldsAction($modelId, $format) {
		$em = $this->getDoctrine()->getManager('metadata');

		$table = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($format);
		$model = $em->getRepository('IgnGincoBundle:Metadata\Model')->find($modelId);

		if (!$table) {
			$errMsg = "Aucune TABLE ne correspond à : " . $format;
			throw $this->createNotFoundException($errMsg);
		}

		$dataRepository = $em->getRepository('IgnGincoBundle:Metadata\Data');
		// Get data dictionnary
		$allFields = $dataRepository->findAllFieldsNotInTableFormat($table);
		$fieldsForm = $this->createForm(TableUpdateFieldsType::class, null);
		// Get table fields
		$tableFieldRepository = $em->getRepository('IgnGincoBundle:Metadata\TableField');
		$tableFields = $tableFieldRepository->findFieldsByTableFormat($table->getFormat());
		// Check if these fields are derived from a reference model
		$referenceFields = $tableFieldRepository->findReferenceFields($table);
		for ($i = 0; $i < count($tableFields); $i ++) {
			$tableField = $tableFields[$i];
			if (in_array($tableField['fieldName'], array_column($referenceFields, 'data'))) {
				$tableFields[$i]['ref'] = true;
			} else {
				$tableFields[$i]['ref'] = false;
			}
		}
		return $this->render('IgnOGAMConfigurateurBundle:TableFormat:fields.html.twig', array(
			'table' => $table,
			'allFields' => $allFields,
			'tableFields' => $tableFields,
			'model' => $model,
			'fieldsForm' => $fieldsForm->createView()
		));
	}

	/**
	 * #600 : Forbid access to table deletion.
	 * User is not allowed to delete tables.
	 *
	 * @Route("/models/{model_id}/tables/{id}/delete/", name="configurateur_table_delete")
	 */
	public function deleteAction($model_id, $id, $fromDeleteModel = false) {
		if ($fromDeleteModel == true) {
			return parent::deleteAction($model_id, $id, $fromDeleteModel);
		} else {
			$this->addFlash('error', $this->get('translator')
				->trans('table.delete.forbidden'));

			return $this->redirectToRoute('configurateur_model_edit', array(
				'id' => $model_id
			));
		}
	}
}
