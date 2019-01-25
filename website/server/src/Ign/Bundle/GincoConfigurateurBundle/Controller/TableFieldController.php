<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Controller\TableFieldController as TableFieldControllerBase;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Component\HttpFoundation\Request;

class TableFieldController extends TableFieldControllerBase {

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

		$mappingRepository->removeAllExceptRefMappingsByTableFormat($format);
		$tableFieldRepository->deleteNonTechnicalAndNonRefByTableFormat($format);
		$fieldRepository->deleteNonTechnicalAndNonRefByTableFormat($format);

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

		// Check if the field is not derived from a field included in a reference model
		$tableFieldRepository = $em->getRepository('IgnGincoBundle:Metadata\TableField');
		$referenceFields = $tableFieldRepository->findReferenceFields();
		if (in_array($field, array_column($referenceFields, 'data'))) {
			$this->addFlash('error', $this->get('translator')
				->trans('data.delete.ref.forbidden', array(
				'%dataName%' => $field
			)));
		} else {
			// remove mapping relations first
			$mappingRepository = $em->getRepository("IgnGincoBundle:Metadata\FieldMapping");
			$mappingRepository->removeAllByTableField($format, $field);

			$tableFieldToRemove = $em->find("IgnGincoBundle:Metadata\TableField", array(
				"data" => $field,
				"format" => $format
			));
			$em->remove($tableFieldToRemove);
			$em->flush();

			$fieldToRemove = $em->find("IgnGincoBundle:Metadata\Field", array(
				"data" => $field,
				"format" => $format
			));
			$em->remove($fieldToRemove);
			$em->flush();
		}

		return $this->redirectToRoute('configurateur_table_update_fields', array(
			'modelId' => $modelId,
			'format' => $format,
			'request' => $request
		), 307);
	}
}
