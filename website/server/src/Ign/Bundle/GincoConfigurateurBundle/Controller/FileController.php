<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Controller\FileController as FileControllerBase;
use Ign\Bundle\OGAMConfigurateurBundle\Form\FileFieldAutoType;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class FileController extends FileControllerBase {

	/**
	 *
	 * @param
	 *        	$datasetId
	 * @param
	 *        	$fileFormat
	 * @param Request $request
	 * @return \Symfony\Component\HttpFoundation\RedirectResponse @Route("/datasetsimport/{datasetId}/files/{fileFormat}/autofields/", name="configurateur_file_auto_add_fields")
	 *
	 *         Automatically adds fields to the file (same fields as the ones in the chosen table)
	 */
	public function autoAction($datasetId, $fileFormat, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata');

		$dataset = $em->getRepository('IgnGincoBundle:Metadata\Dataset')->find($datasetId);

		// Create Auto-Add-Fieldform
		$formOptions = array(
			'modelId' => $dataset->getModel()->getId(),
			'action' => $this->generateUrl('configurateur_file_fields', array(
				'datasetId' => $datasetId,
						'format' => $fileFormat,
				)),
		);
		$autoAddFieldsForm = $this->createForm(FileFieldAutoType::class, null, $formOptions);
		$autoAddFieldsForm->handleRequest($request);

		if ($autoAddFieldsForm->isValid()) {
			$tableFormat = $autoAddFieldsForm->get('table_format')->getData()->getFormat();
			$table = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($tableFormat);
			$tableFields = $em->getRepository('IgnGincoBundle:Metadata\TableField')->findFieldsByTableFormat($tableFormat);

			// Get mandatory AND not calculated fields in table fields
			$isMandatoryOnImport = function ($field) {
				return ($field['isMandatory'] == 1 && $field['isCalculated'] != '1');
			};
			$mandatoryOnImportFields = array_filter($tableFields, $isMandatoryOnImport);

			
			$fileFields = $em->getRepository('IgnGincoBundle:Metadata\FileField')->findFieldsByFileFormat($fileFormat);

			// Add only mandatory fields ?
			$mandatoryOnly = $autoAddFieldsForm->get('only_mandatory')->getData();
			if ($mandatoryOnly) {
				$tableFields = $mandatoryOnImportFields;
			}

			$tableDatas = array_column($tableFields, 'fieldName');

			// Add overwrited fields ?
			$overwritedIncluded = $autoAddFieldsForm->get('with_calculated')->getData();
			$overwritedFields = array();
			if (!$overwritedIncluded) {

				$possibleOverwritedFields = array(
					'sensible',
					'sensiniveau',
					'sensidateattribution',
					'sensireferentiel',
					'sensiversionreferentiel',
					'deedatedernieremodification',
					'sensimanuelle',
					'sensialerte',
					'codecommunecalcule',
					'codedepartementcalcule',
					'codemaillecalcule',
					'nomcommunecalcule',
					'nomvalide',
				);
				$overwritedFields = array_intersect($possibleOverwritedFields, $tableDatas);
				$tableDatas = array_diff($tableDatas, $overwritedFields);
				// var_dump($tableDatas);
			}

			// remove technical fields
			$technicalFields = array(
				'USER_LOGIN',
				'PROVIDER_ID',
				'SUBMISSION_ID'
			);
			$technicalFields = array_merge($technicalFields, $table->getPrimaryKeys());

			$tableDatas = array_diff($tableDatas, $technicalFields);

			$overwritedFieldsLabels = array();
			foreach ($overwritedFields as $data) {
				$overwritedFieldsLabels[] = $em->getRepository('IgnGincoBundle:Metadata\Data')
					->find($data)
					->getLabel();
			}

			// Generate a report
			$report = array(
				'fileLabel' => $em->getRepository('IgnGincoBundle:Metadata\FileFormat')
					->find($fileFormat)
					->getLabel(),
				'tableLabel' => $em->getRepository('IgnGincoBundle:Metadata\TableFormat')
					->find($tableFormat)
					->getLabel(),
				'mandatoryOnly' => $mandatoryOnly,
				'overwritedFields' => $overwritedFieldsLabels
			);

			// Find table fields not already added as file fields
			$fileDatas = array_column($fileFields, 'fieldName');
			$fieldsToAdd = array_diff($tableDatas, $fileDatas);

			$fieldsToAddLabels = array();
			foreach ($fieldsToAdd as $data) {
				$fieldsToAddLabels[] = $em->getRepository('IgnGincoBundle:Metadata\Data')
					->find($data)
					->getLabel();
			}

			$report = array_merge($report, array(
				'tableFields' => $tableDatas,
				'fileFields' => $fileDatas,
				'fieldsToAdd' => $fieldsToAddLabels
			));

			// Add them ; get redirection in a variable
			$redirectResponse = $this->forward('IgnOGAMConfigurateurBundle:FileField:addFields', array(
				'datasetId' => $datasetId,
				'format' => $fileFormat,
				'addedFields' => implode(',', $fieldsToAdd),
                'destinationFormat' => $tableFormat
			));

			// Update as mandatory in file the fields which are mandatory in table, but not calculated
			$mFields = array_column($mandatoryOnImportFields, 'fieldName');
			$mFields = array_intersect($fieldsToAdd, $mFields);

			foreach ($mFields as $mfield) {
				$fileField = $em->getRepository('IgnGincoBundle:Metadata\FileField')->findOneBy(array(
					'data' => $mfield,
					'format' => $fileFormat
				));
				$fileField->setIsMandatory('1');
			}
			$em->flush();

			$notice = $this->generateReportAutoAddFields($report);

			$this->addFlash('info', $notice);
		} else {
			$this->addFlash('danger', $this->get('translator')
				->trans('fileField.auto.chooseatable'));
		}

		return $this->redirectToRoute('configurateur_file_fields', array(
			'datasetId' => $datasetId,
			'format' => $fileFormat,
		));
	}

	/**
	 * Generates text report message, based on report table
	 * for auto-mapping action.
	 *
	 * @param
	 *        	$report
	 * @return string
	 */
	public function generateReportAutoAddFields($report) {
		$translator = $this->get('translator');

		if ($report['mandatoryOnly']) {
			$reportMessage = $translator->trans('fileField.auto.report.2', array(
				'%fileLabel%' => $report['fileLabel'],
				'%tableName%' => $report['tableLabel']
			));
			$reportMessage .= $translator->trans('fileField.auto.report.4', array(
				'%fileFields%' => count($report['fileFields']),
				'%tableFields%' => count($report['tableFields']) + count($report['overwritedFields'])
			));
		} else {
			$reportMessage = $translator->trans('fileField.auto.report.1', array(
				'%fileLabel%' => $report['fileLabel'],
				'%tableName%' => $report['tableLabel']
			));
			$reportMessage .= $translator->trans('fileField.auto.report.3', array(
				'%fileFields%' => count($report['fileFields']),
				'%tableFields%' => count($report['tableFields']) + count($report['overwritedFields'])
			));
		}
		if (count($report['fieldsToAdd']) == 0) {
			$reportMessage .= $translator->trans('fileField.auto.report.5');
		} else {
			$reportMessage .= $translator->trans('fileField.auto.report.6', array(
				'%fieldsAddedCount%' => count($report['fieldsToAdd']),
				'%fieldsAdded%' => implode(', ', $report['fieldsToAdd'])
			));
		}
		if ($report['overwritedFields'] != null && count($report['fieldsToAdd']) != 0) {
			$reportMessage .= $translator->trans('fileField.auto.report.8', array(
				'%overwritedFields%' => implode(', ', $report['overwritedFields']),
				'%overwritedFieldsCount%' => count($report['overwritedFields'])
			));
		}

		return $reportMessage;
	}
}
