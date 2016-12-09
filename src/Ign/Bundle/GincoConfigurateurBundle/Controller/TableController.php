<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Controller;

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
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Ign\Bundle\ConfigurateurBundle\Controller\TableController as TableControllerBase;

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
		$em = $this->getDoctrine()->getManager();

		$table = $em->getRepository('IgnConfigurateurBundle:TableFormat')->find($format);
		$model = $em->getRepository('IgnConfigurateurBundle:Model')->find($modelId);

		if (!$table) {
			$errMsg = "Aucune TABLE ne correspond à : " . $format;
			throw $this->createNotFoundException($errMsg);
		}

		$dataRepository = $em->getRepository('IgnConfigurateurBundle:Data');
		// Get data dictionnary
		$allFields = $dataRepository->findAllFields();
		$fieldsForm = $this->createForm(TableUpdateFieldsType::class, null);
		// Get table fields
		$tableFieldRepository = $em->getRepository('IgnConfigurateurBundle:TableField');
		$tableFields = $tableFieldRepository->findFieldsByTableFormat($table->getFormat());
		// Check if these fields are derived from a reference model
		$referenceFields = $tableFieldRepository->findReferenceFields();
		for ($i = 0; $i < count($tableFields); $i ++) {
			$tableField = $tableFields[$i];
			if (in_array($tableField['fieldName'], array_column($referenceFields, 'data'))) {
				$tableFields[$i]['ref'] = true;
			} else {
				$tableFields[$i]['ref'] = false;
			}
		}
		return $this->render('IgnConfigurateurBundle:TableFormat:fields.html.twig', array(
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
