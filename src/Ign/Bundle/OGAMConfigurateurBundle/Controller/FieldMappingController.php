<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\FileFormat;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableFormat;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Dataset;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\FieldMapping;
use Ign\Bundle\OGAMConfigurateurBundle\Form\FieldMappingType;
use Ign\Bundle\OGAMConfigurateurBundle\Form\FieldMappingAutoType;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

class FieldMappingController extends Controller {


	/**
	 * Gestion des mappings du fichier
	 * - Liste (avec boutons modifier et supprimer)
	 * - Formulaire de mapping automatique
	 * - Formulaire de mapping manuel de création/édition
	 *
	 * Pré-remplir le formulaire de mapping manuel: passer les paramètres du mapping dans la requête :
	 * ?srcData=champ1&dstFormat=format&dstData=champ2
	 *
	 * @Route("datasetsimport/{datasetId}/files/{format}/mappings/", name="configurateur_file_mappings")
	 */
	public function manageMappingsAction($datasetId, $format, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata_work');
		$file = $em->getRepository('IgnOGAMConfigurateurBundle:FileFormat')->find($format);
		$dataset = $em->getRepository('IgnOGAMConfigurateurBundle:Dataset')->find($datasetId);

		// Parameters to pass to the template
		$params = array(
			'dataset' => $dataset,
			'file' => $file,
		);

		// Complete parameters in each dedicated method
		$params = array_merge($params, $this->listMappings($file));

		$params = array_merge($params, $this->autoMappingForm($dataset, $file));

		$params = array_merge($params, $this->manualMappingForm($dataset, $file, $request));

		return $this->render('IgnOGAMConfigurateurBundle:FieldMapping:mappings.html.twig', $params);
	}

	/**
	 * Returns in a parameters array, the list of current mappings of the file
	 *
	 * @param FileFormat $file
	 * @return array : the parameters array
	 */
	public function listMappings(FileFormat $file)
	{
		$em = $this->getDoctrine()->getManager('metadata_work');
		$fieldMappings = $em->getRepository('IgnOGAMConfigurateurBundle:FieldMapping')->findMappings($file->getFormat(), 'FILE');
		$fms = $fieldMappings;

		// Rewrite mappings on "OGAM_ID_..." (keys)
		foreach ($fieldMappings as $index => $fm) {
			if (strpos($fm['dstData'], TableFormat::PK_PREFIX )=== 0) {
				$format = substr($fm['dstData'], strlen(TableFormat::PK_PREFIX));
				$tableFormat = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($format);
				$tableLabel = $tableFormat->getLabel();
				// Primary key or foreign key ?
				if ($format == $fm['dstFormat'])
					$fms[$index]['dstDataLabel'] =  $this->get('Translator')->trans('data.primary_key', array('%tableLabel%' => $tableLabel ));
				else
					$fms[$index]['dstDataLabel'] = $this->get('Translator')->trans('data.foreign_key', array('%tableLabel%' => $tableLabel ));
			}
		}

		return array('fieldMappings' => $fms);
	}

	/**
	 * Returns in parameters array, the form view of the aut-mapping form
	 *
	 * @param Dataset $dataset
	 * @param FileFormat $file
	 * @return array : the parameters array
	 */
	public function autoMappingForm(Dataset $dataset, FileFormat $file)
	{
		$formOptions = array(
				'modelId' => $dataset->getModel()->getId(),
				'action' => $this->generateUrl('configurateur_field_automapping', array(
						'datasetId' => $dataset->getId(),
						'fileFormat' => $file->getFormat(),
				)),
		);
		$autoMappingForm = $this->createForm(FieldMappingAutoType::class, null, $formOptions);

		return array('autoMappingForm' => $autoMappingForm->createView());
	}

	/**
	 * Returns in parameters array, the form view of the manual mapping form
	 *
	 * @param Dataset $dataset
	 * @param FileFormat $file
	 * @return array : the parameters array
	 */
	public function manualMappingForm(Dataset $dataset, FileFormat $file, Request $request)
	{
		$em = $this->getDoctrine()->getManager('metadata_work');
		$model = $dataset->getModel();

		// Create fieldMapping form
		$fieldMapping = new FieldMapping();

		// Pre-fill form if parameters are passed in the query
		if (null !== $request->query->get('srcData')) {
			$fieldMapping->setSrcData($request->query->get('srcData'));
		}
		if (null !== $request->query->get('dstData')) {
			$fieldMapping->setDstData($request->query->get('dstData'));
		}
		if (null !== $request->query->get('dstFormat')) {
			$fieldMapping->setDstFormat($request->query->get('dstFormat'));
		}

		$formOptions = array(
				'action' => $this->generateUrl('configurateur_field_mapping_new', array(
						'datasetId' => $dataset->getId(),
						'fileFormat' => $file->getFormat(),
				)),
				'fileFormat' => $file->getFormat(),
				'modelId' => $model->getId(),
				'em' => $em
		);

		$fieldMappingForm = $this->createForm(FieldMappingType::class, $fieldMapping, $formOptions);
		$fieldMappingForm->handleRequest($request);

		return array('fieldMappingForm' => $fieldMappingForm->createView());
	}

	/**
	 * Creates a new mapping relation.
	 *
	 * @param string $datasetId
	 * @param string $fileFormat
	 * @param Request $request
	 *        	@Route("datasetsimport/{datasetId}/files/{fileFormat}/mapping/new", name="configurateur_field_mapping_new")
	 */
	public function newAction($datasetId, $fileFormat, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata_work');
		$dataset = $em->getRepository('IgnOGAMConfigurateurBundle:Dataset')->find($datasetId);
		$model = $dataset->getModel();

		// Create fieldMapping form
		$fieldMapping = new FieldMapping();
		$formOptions = array(
				'action' => $this->generateUrl('configurateur_field_mapping_new', array(
						'datasetId' => $datasetId,
						'fileFormat' => $fileFormat,
				)),
				'fileFormat' => $fileFormat,
				'modelId' => $model->getId(),
				'em' => $em
		);
		$fieldMappingForm = $this->createForm(FieldMappingType::class, $fieldMapping, $formOptions);
		$fieldMappingForm->handleRequest($request);
		$fieldMapping->setMappingType('FILE');

		if ($fieldMappingForm->isValid()) {
			$em->persist($fieldMapping);
			$em->flush();

			return $this->redirectToRoute('configurateur_file_mappings', array(
					'datasetId' => $datasetId,
					'format' => $fileFormat
			));
		}
		else {
			return $this->redirectToRoute('configurateur_file_mappings', array(
					'datasetId' => $datasetId,
					'format' => $fileFormat,
					'request' => $request,
			), 307); // 307 preserve the request method (POST)
		}
	}

	/**
	 * Mapping relation editing, ie delete + recreate
	 *
	 * @param string $datasetId
	 * @param string $fileFormat
	 * @param string $field
	 * @param string $table
	 * @param string $tableField
	 * @param Request $request
	 *        	@Route("datasetsimport/{datasetId}/files/{fileFormat}/mapping/edit/{field}/{table}/{tableField}", name="configurateur_field_mapping_edit")
	 */
	public function editAction($datasetId, $fileFormat, $field, $table, $tableField, Request $request) {
		// First delete the mapping
		$this->forward('IgnOGAMConfigurateurBundle:FieldMapping:remove', array(
				'datasetId' => $datasetId,
				'fileFormat' => $fileFormat,
				'field' => $field,
				'table' => $table,
				'tableField' => $tableField
		));

		// Then redirects to main mapping page, with query to pre-fill manuel mapping form
		return $this->redirect($this->generateUrl('configurateur_file_mappings', array(
						'datasetId' => $datasetId,
						'format' => $fileFormat,
				)) . '?srcData='.$field.'&dstFormat='.$table.'&dstData='.$tableField);
	}

	/**
	 * Removes a mapping relation.
	 *
	 * @param string $datasetId
	 * @param string $fileFormat
	 * @param string $field
	 * @param string $table
	 * @param string $tableField
	 *        	@Route("/datasetsimport/{datasetId}/files/{fileFormat}/mapping/remove/{field}/{table}/{tableField}", name="configurateur_field_mapping_remove")
	 */
	public function removeAction($datasetId, $fileFormat, $field, $table, $tableField) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$mapping = $em->getRepository("IgnOGAMConfigurateurBundle:FieldMapping")->findOneBy(array(
			"srcFormat" => $fileFormat,
			'srcData' => $field,
			'dstFormat' => $table,
			'dstData' => $tableField
		));

		$em->remove($mapping);
		$em->flush();

		return $this->redirectToRoute('configurateur_file_mappings', array(
			'datasetId' => $datasetId,
			'format' => $fileFormat
		));
	}

	/**
	 * Removes all mapping relations for the file.
	 *
	 * @param string $datasetId
	 * @param string $fileFormat
	 *        	@Route("/datasetsimport/{datasetId}/files/{fileFormat}/mapping/removeall", name="configurateur_field_mapping_remove_all")
	 */
	public function removeAllAction($datasetId, $fileFormat) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$em->getRepository("IgnOGAMConfigurateurBundle:FieldMapping")->removeAllByFileFormatAndType($fileFormat, 'FILE');

		$this->addFlash('notice', 'Tous les mappings du fichier ont bien été supprimés.');

		return $this->redirectToRoute('configurateur_file_mappings', array(
			'datasetId' => $datasetId,
			'format' => $fileFormat
		));
	}

	/**
	 * Performs auto-mapping and redirects to mapping edition page
	 * (action called from form on mapping edition page)
	 *
	 * @param $datasetId
	 * @param $fileFormat
	 * @param Request $request
	 * @return \Symfony\Component\HttpFoundation\RedirectResponse
	 *
	 * 			@Route("/datasetsimport/{datasetId}/files/{fileFormat}/automapping/", name="configurateur_field_automapping")
	 *
	 */
	public function autoAction($datasetId, $fileFormat, Request $request) {

		$em = $this->getDoctrine()->getManager('metadata_work');

		$dataset = $em->getRepository('IgnOGAMConfigurateurBundle:Dataset')->find($datasetId);


		// Create Auto-Field Mapping form
		$formOptions = array(
			'modelId' => $dataset->getModel()->getId(),
			'action' => $this->generateUrl('configurateur_field_automapping', array(
				'datasetId' => $datasetId,
				'fileFormat' => $fileFormat,
			)),
		);
		$autoMappingForm = $this->createForm(FieldMappingAutoType::class, null, $formOptions);
		$autoMappingForm->handleRequest($request);

		if ($autoMappingForm->isValid()) {
			$tableFormat = $autoMappingForm->get('dst_format')->getData()->getFormat();

			$report = $this->doAutoMapping($tableFormat, $fileFormat);

			$this->addFlash('notice-automapping', $report);
		}
		else {
			$this->addFlash('error-automapping', $this->get('translator')->trans('fieldMapping.auto.chooseatable'));
		}

		return $this->redirectToRoute('configurateur_file_mappings', array(
				'datasetId' => $datasetId,
				'format' => $fileFormat,
			));
	}


	/**
	 * Performs auto-mapping and redirects to mapping edition page
	 * (action called from direct link on fields edition page)
	 *
	 * @param $datasetId
	 * @param $fileFormat
	 * @param $tableFormat
	 * @return \Symfony\Component\HttpFoundation\RedirectResponse
	 *
	 * 	@Route("/datasetsimport/{datasetId}/files/{fileFormat}/automapping/{tableFormat}", name="configurateur_field_automapping_direct")
	 */
	public function directAutoMappingAction($datasetId, $fileFormat, $tableFormat)
	{
		$report = $this->doAutoMapping($tableFormat, $fileFormat);
		$this->addFlash('notice-automapping', $report);
		return $this->redirectToRoute('configurateur_file_mappings', array(
				'datasetId' => $datasetId,
				'format' => $fileFormat,
		));
	}


	/**
	 * Performs auto-mapping between table with format $tableFormat, file with format $fileFormat
	 *
	 * @param $tableFormat
	 * @param $fileFormat
	 * @return string : the report to show to the user
	 */
	public function doAutoMapping($tableFormat, $fileFormat)
	{
		$em = $this->getDoctrine()->getManager('metadata_work');

		$tableFields = $em->getRepository('IgnOGAMConfigurateurBundle:TableField')->findFieldsByTableFormat($tableFormat);

		$fieldMappings = $em->getRepository('IgnOGAMConfigurateurBundle:FieldMapping')->findMappings($fileFormat, 'FILE');
		$notMappedFields = $em->getRepository('IgnOGAMConfigurateurBundle:FieldMapping')->findNotMappedFields($fileFormat, 'FILE');

		// Generate a report
		$report = array(
				'fileLabel' => $em->getRepository('IgnOGAMConfigurateurBundle:FileFormat')->find($fileFormat)->getLabel(),
				'tableLabel' => $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($tableFormat)->getLabel(),
				'already_mapped' => $fieldMappings,
				'to_map' => $notMappedFields,
				'auto_mapped' => array(),
				'already_mapped_in_table' => array(),
				'not_found_in_table' => array(),
				'not_mapped_in_file' => array(),
				'not_mapped_in_table' => array(),
		);

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
							$report['already_mapped_in_table'][] = $tableField['fieldName'];
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
				$report['auto_mapped'][] = $srcData;
			} else if (!$destField) {
				$dataRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Data');
				$report['not_found_in_table'][] = $dataRepository->find($srcData)->getLabel();
			}
		}

		// Complete report with not-mapped fields in file and destination table :
		$getData = function($arr) { return $arr['label']; };
		$report['not_mapped_in_file'] = array_map($getData, $em->getRepository('IgnOGAMConfigurateurBundle:FieldMapping')->findNotMappedFields($fileFormat, 'FILE'));
		$report['not_mapped_in_table'] = array_map($getData, $em->getRepository('IgnOGAMConfigurateurBundle:FieldMapping')->findNotMappedFieldsInTable($tableFormat, 'FILE'));

		return $this->generateReportAutoMapping($report);
	}


	/**
	 * Generates text report message, based on report table
	 * for auto-mapping action.
	 *
	 * @param $report
	 * @return string
	 */
	public function generateReportAutoMapping($report) {
		$translator =  $this->get('translator');

		$reportMessage = $translator->trans('fieldMapping.auto.report.1',
				array( '%fileLabel%' => $report['fileLabel'],
						'%tableName%' => $report['tableLabel'])
		);
		$reportMessage .= $translator->trans('fieldMapping.auto.report.2',
				array( '%alreadyMapped%' => count($report['already_mapped']),
						'%toMap%' => count($report['to_map']))
		);
		$reportMessage .= $translator->trans('fieldMapping.auto.report.3.1',
				array( '%autoMapped%' => count($report['auto_mapped']))
		);
		if ( count($report['already_mapped_in_table']) > 0 ) {
			$reportMessage .= $translator->trans('fieldMapping.auto.report.3.2',
					array( '%alreadyMappedInTable%' => count($report['already_mapped_in_table']),
							'%alreadyMappedInTableList%' => implode(', ',$report['already_mapped_in_table'])));
		}
		if ( count($report['not_found_in_table']) > 0 ) {
			$reportMessage .= $translator->trans('fieldMapping.auto.report.3.3',
					array( '%notFoundInTable%' => count($report['not_found_in_table']),
							'%notFoundInTableList%' => implode(', ',$report['not_found_in_table'])));
		}
		$reportMessage .= $translator->trans('fieldMapping.auto.report.3.4');
		if ( count($report['not_mapped_in_file']) == 0 && count($report['not_mapped_in_table']) == 0 ) {
			$reportMessage .= $translator->trans('fieldMapping.auto.report.4.1');
		}
		else {
			$reportMessage .= $translator->trans('fieldMapping.auto.report.4.2');
			if ( count($report['not_mapped_in_file']) > 0 ) {
				$reportMessage .= $translator->trans('fieldMapping.auto.report.4.3',
						array('%notMappedInFile%' => count($report['not_mapped_in_file']),
								'%notMappedInFileList%' => implode(', ',$report['not_mapped_in_file'])));
			}
			if ( count($report['not_mapped_in_table']) > 0 ) {
				$reportMessage .= $translator->trans('fieldMapping.auto.report.4.4',
						array('%notMappedInTable%' => count($report['not_mapped_in_table']),
								'%notMappedInTableList%' => implode(', ',$report['not_mapped_in_table'])));
			}
			$reportMessage .= $translator->trans('fieldMapping.auto.report.4.5');
		}
		return $reportMessage;
	}
}
