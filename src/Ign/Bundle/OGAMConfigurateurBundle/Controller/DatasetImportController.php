<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\Dataset;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\FileFormat;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Format;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Form\DatasetImportType;
use Ign\Bundle\OGAMConfigurateurBundle\Form\DatasetImportUploadType;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class DatasetImportController extends Controller {

	/**
	 * @Route("/datasetsimport/", name="configurateur_dataset_import_index")
	 */
	public function indexAction($datasets = null) {
		// get import models list
		$em = $this->getDoctrine()->getManager('metadata_work');
		$repository = $em->getRepository('IgnOGAMConfigurateurBundle:Dataset');
		$datasets = $repository->findByTypeAndOrderedByName('IMPORT');

		$mpService = $this->get('app.importmodelPublication');

		// Check if import models are published and/or publishable
		$importModelsPubState = array();
		$importModelsPublishable = array();
		$modelsPermissions = array();

		foreach ($datasets as $importModel) {
			$importModelId = $importModel->getId();
			$importModelsPubState[$importModelId] = $mpService->isPublished($importModelId);
			$importModelsPublishable[$importModelId] = $mpService->isPublishable($importModel);
			$modelsPermissions[$importModelId]['editable'] = $this->get('app.permissions')->isImportModelEditable($importModelId);
			$modelsPermissions[$importModelId]['editableMessage'] = $this->get('app.permissions')->getMessage();
			$modelsPermissions[$importModelId]['editableCode'] = $this->get('app.permissions')->getCode();
			$modelsPermissions[$importModelId]['deletable'] = $this->get('app.permissions')->isImportModelDeletable($importModelId);
			$modelsPermissions[$importModelId]['deletableMessage'] = $this->get('app.permissions')->getMessage();
			$modelsPermissions[$importModelId]['deletableCode'] = $this->get('app.permissions')->getCode();
		}

		// form for file upload
		$uploadForm = $this->createForm(DatasetImportUploadType::class);

		return $this->render('IgnOGAMConfigurateurBundle:DatasetImport:index.html.twig', array(
			'datasets' => $datasets,
			'pubStates' => $importModelsPubState,
			'publishable' => $importModelsPublishable,
			'permissions' => $modelsPermissions,
			'upload_form' => $uploadForm->createView()
		));
	}

	/**
	 * @Route("/datasetsimport/new/", name="configurateur_dataset_import_new")
	 */
	public function newAction(Request $request) {

		// empty import model initialization
		$dataset = new Dataset();

		$em = $this->getDoctrine()->getManager('metadata_work');

		$form = $this->createForm(DatasetImportType::class, $dataset, array(
			'isNew' => true
		));

		$form->handleRequest($request);

		if ($form->isValid()) {

			$dataset->setType('IMPORT');
			$dataset->setIsDefault(0);

			$em->persist($dataset);
			$em->flush();
			$id = $dataset->getId();

			return $this->redirectToRoute('configurateur_dataset_import_edit', array(
				'id' => $id
			));
		}

		return $this->render('IgnOGAMConfigurateurBundle:DatasetImport:new.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * @Route("/datasetsimport/{id}/edit/", name="configurateur_dataset_import_edit")
	 */
	public function editAction($id, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$datasetRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Dataset');
		$dataset = $datasetRepository->find($id);
		if (!$dataset) {
			throw $this->createNotFoundException('Aucun modèle d\'import trouvé pour cet id : ' . $id);
		}

		if (!$this->get('app.permissions')->isImportModelEditable($id)) {
			$this->addFlash('error', $this->get('app.permissions')
				->getMessage());
			return $this->redirectToRoute('configurateur_dataset_import_index');
		}

		// Save initial target model to check if it is changed on validation
		$initialTargetDataModel = $dataset->getModel()->getId();

		$mpService = $this->get('app.importmodelPublication');

		$pubState = $mpService->isPublished($id);
		$modelPubState = $mpService->isImportModelDataModelPublished($id);

		$datasetLabel = $dataset->getLabel();
		$form = $this->createForm(DatasetImportType::class, $dataset);

		$form->handleRequest($request);

		if ($form->isValid()) {
			// Check if target data model has been modified
			$finalTargetDataModel = $form->get('model')->getViewData();
			if ($initialTargetDataModel != $finalTargetDataModel) {
				// Delete the mappings of this model
				$fieldsRemoved = false;
				$fmRepository = $em->getRepository("IgnOGAMConfigurateurBundle:FieldMapping");
				$ffRepository = $em->getRepository("IgnOGAMConfigurateurBundle:FileField");

				foreach ($dataset->getFiles() as $file) {
					// Check if there are fields in the file
					$fields = $ffRepository->findFieldsByFileFormat($file->getFormat());
					if (count($fields) > 0) {
						// Check if there are mappings to delete
 						$mappings = $fmRepository->findMappings($file->getFormat(), 'FILE');
 						if (count($mappings) > 0) {
 							$fmRepository->removeAllByFileFormat($file->getFormat());
 						}
 						// Delete fields
 						$ffRepository->deleteAllByFileFormat($file->getFormat());
 						$fieldsRemoved = true;
					}
				}
				if ($fieldsRemoved) {
					$this->addFlash('warning', $this->get('translator')
						->trans('importmodel.edit.file_fields_removed'));
				}
			}
			$em->flush();
			$datasetLabel = $dataset->getLabel();
		}

		$files = $dataset->getFiles();

		return $this->render('IgnOGAMConfigurateurBundle:DatasetImport:edit.html.twig', array(
			'datasetForm' => $form->createView(),
			'datasetLabel' => $datasetLabel,
			'dataset' => $dataset,
			'files' => $files,
			'pubState' => $pubState,
			'modelPubState' => $modelPubState,
			'publishable' => $mpService->isPublishable($dataset),
			'id' => $id,
			'initialTargetDataModel' => $initialTargetDataModel
		));
	}

	/**
	 * @Route("/datasetsimport/{id}/delete/", name="configurateur_dataset_import_delete")
	 * @Template()
	 */
	public function deleteAction($id) {
		$em = $this->getDoctrine()->getManager('metadata_work');
		$repository = $em->getRepository('IgnOGAMConfigurateurBundle:Dataset');
		$dataset = $repository->find($id);

		// Check if import model is published
		$mpService = $this->get('app.importmodelPublication');
		$published = $mpService->isPublished($id);

		if (!$this->get('app.permissions')->isImportModelDeletable($id)) {
			$this->addFlash('error', $this->get('app.permissions')
				->getMessage());
		} else {
			$datasetName = $dataset->getLabel();

			foreach ($dataset->getFiles() as $file) {
				$this->forward('IgnOGAMConfigurateurBundle:File:delete', array(
					'datasetId' => $id,
					'fileFormat' => $file->getFormat()
				));
			}

			$dataset->getFiles()->clear();

			$em->remove($dataset);
			$em->flush();

			$this->addFlash('notice', $this->get('translator')
				->trans('importmodel.delete.success', array(
				'%modelName%' => $datasetName
			)));
		}

		// return to import model list
		return $this->redirectToRoute('configurateur_dataset_import_index');
	}

	/**
	 * Publishes an import model into the production database.
	 * Adds flash messages to notice user about success or fail of action.
	 * Redirects to index.
	 * @Route("/datasetsimport/{importModelId}/publish/", name="configurateur_dataset_import_publish")
	 * @Template()
	 */
	public function publishAction($importModelId) {
		$importModel = $this->getDoctrine()
			->getManager('metadata_work')
			->getRepository('IgnOGAMConfigurateurBundle:Dataset')
			->find($importModelId);
		if ($importModel) {
			$mpService = $this->get('app.importmodelPublication');
			$importModelName = $importModel->getLabel();
			if ($mpService->isPublishable($importModel) == true) {

				// Reset tomcat caches
				$cachesCleared = $this->get('app.resettomcatcaches')->performRequest();

				if ($cachesCleared == false) {
					$this->addFlash('error', $this->get('translator')
						->trans('importmodel.resetCaches.fail'));
				} else {

					$successStatus = $this->get('app.importModelPublication')->publishImportModel($importModel);

					if ($successStatus == true) {
						$this->addFlash('notice', $this->get('translator')
							->trans('importmodel.publish.success', array(
							'%importModelName%' => $importModelName
						)));
					} else {
						$this->addFlash('error', $this->get('translator')
							->trans('importmodel.publish.fail', array(
							'%importModelName%' => $importModelName
						)));
					}
				}
			} else {
				$this->addFlash('error', $this->get('translator')
					->trans('importmodel.publish.fail', array(
					'%importModelName%' => $importModelName
				)));
			}
		} else {
			$this->addFlash('error', $this->get('translator')
				->trans('importmodel.publish.badid', array(
				'%importModelId%' => $importModelId
			)));
		}

		return $this->redirectToRoute('configurateur_dataset_import_index');
	}

	/**
	 * Unpublishes an import model from the production database.
	 * Checks if there are any running uploads before unpublishing.
	 * Changes state of button 'unpublish' to 'publish'.
	 * This action is also called when a data model unpublication is called.
	 * @Route("/datasetsimport/{importModelId}/unpublish/{redirectToEdit}", name="configurateur_dataset_import_unpublish")
	 * @Template()
	 *
	 * @param boolean $unpublishFromModel
	 *        	if the unpublication call comes from the data model unpublication action call
	 * @param boolean $redirectToEdit
	 *        	optional
	 *        	parameter. if true, will redirect to edit page after unpublication
	 *
	 */
	public function unpublishAction($importModelId, $unpublishFromModel = false, $redirectToEdit = false) {
		// Get the model to check if it exists
		$importModel = $this->getDoctrine()
			->getManager('metadata_work')
			->getRepository('IgnOGAMConfigurateurBundle:Dataset')
			->find($importModelId);
		if ($importModel) {
			// Check if a file is being uploaded
			$muService = $this->get('app.importmodelUnpublication');
			if ($muService->hasRunningFileUpload($importModelId)) {
				$this->addFlash('error', $this->get('translator')
					->trans('importmodel.unpublish.uploadrunning', array(
					'%importModelId%' => $importModelId
				)));
				if ($unpublishFromModel) {
					return $this->redirectToRoute('configurateur_model_index');
				} else {
					return $this->redirectToRoute('configurateur_dataset_import_index');
				}
			}

			// Unpublish the import model
			$successStatus = $this->get('app.importModelUnpublication')->unpublishImportModel($importModelId);

			// Send a flash message depending on the result of the unpublication
			$importModelName = $importModel->getLabel();
			if ($successStatus == 'SUCCESS') {
				$this->addFlash('notice', $this->get('translator')
					->trans('importmodel.unpublish.success', array(
					'%importModelName%' => $importModelName
				)));
			} else if ($successStatus == 'FAIL') {
				$this->addFlash('error', $this->get('translator')
					->trans('importmodel.unpublish.fail', array(
					'%importModelName%' => $importModelName
				)));
			}
		} else {
			$this->addFlash('error', $this->get('translator')
				->trans('importmodel.unpublish.badid', array(
				'%importModelId%' => $importModelId
			)));
		}
		if ($redirectToEdit) {
			return $this->redirectToRoute('configurateur_dataset_import_edit', array(
				'id' => $importModelId
			));
		} else {
			return $this->redirectToRoute('configurateur_dataset_import_index');
		}
	}

	/**
	 * @Route("/datasetsimport/{id}/view/", name="configurateur_dataset_import_view")
	 */
	public function viewAction($id) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$datasetRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Dataset');
		$dataset = $datasetRepository->find($id);
		if (!$dataset) {
			throw $this->createNotFoundException('Aucun modèle d\'import trouvé pour cet id : ' . $id);
		}

		$datasetLabel = $dataset->getLabel();
		$files = $dataset->getFiles();

		return $this->render('IgnOGAMConfigurateurBundle:DatasetImport:view.html.twig', array(
			'datasetLabel' => $datasetLabel,
			'dataset' => $dataset,
			'files' => $files,
			'id' => $id
		));
	}

	/**
	 * Updates the position attribute of each file from a dataset.
	 * @Route("/datasetsimport/{id}/edit/fields/update/{formats}/{orders}/", name="configurateur_dataset_import_update_file_order", options={"expose"=true})
	 */
	public function updateFileOrderAction($id, $formats, $orders = null) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$datasetRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Dataset');
		$dataset = $datasetRepository->find($id);
		if (!$dataset) {
			throw $this->createNotFoundException('Aucun modèle d\'import trouvé pour cet id : ' . $id);
		}

		// Handle the formats
		$data = explode(",", $formats);
		$orders = explode(",", $orders);
		for ($i = 0; $i < count($data); $i ++) {
			$format = $data[$i];
			$order = $orders[$i];

			$file = $em->getRepository('IgnOGAMConfigurateurBundle:FileFormat')->find($format);

			try {
				if ($file !== null) {
					$file->setPosition($order);
					$em->merge($file);
				}

				$em->flush();
			} catch (\Doctrine\ORM\ORMException $e) {
				$this->addFlash('error', $this->get('translator')
					->trans('importmodel.saveOrder.fail'));
				return $this->redirectToRoute('configurateur_dataset_import_edit', array(
					'id' => $id
				));
			}
		}

		$this->addFlash('notice', $this->get('translator')
			->trans('importmodel.saveOrder.success'));
		return $this->redirectToRoute('configurateur_dataset_import_edit', array(
			'id' => $id
		));
	}
}
