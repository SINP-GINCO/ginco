<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\Dataset;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableSchema;
use Ign\Bundle\OGAMConfigurateurBundle\Form\ModelType;
use Ign\Bundle\OGAMConfigurateurBundle\Form\ModelUploadType;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class ModelController extends Controller {

	/**
	 * Shows the list of the models and actions related to them.
	 * @Route("/models/", name="configurateur_model_index", defaults={"publicationStatus" = null})
	 */
	public function indexAction($models = null) {
		$em = $this->getDoctrine()->getManager('metadata_work');
		$repository = $em->getRepository('IgnOGAMConfigurateurBundle:Model');
		$models = $repository->findAllOrderedByName();
		// Check if models are published and contains data
		// And if they are publishable, ie: not published, at least one table, at least one non-technical field in each table
		$modelsPubState = array();
		$modelsPublishable = array();
		$modelsFilled = array();
		$modelsPermissions = array();
		foreach ($models as $model) {
			$modelId = $model->getId();
			$modelsPubState[$modelId] = $this->get('app.modelpublication')->isPublished($modelId);
			$modelsPublishable[$modelId] = $this->get('app.modelpublication')->isPublishable($modelId);
			$modelsUnpublishable[$modelId] = $this->get('app.modelunpublication')->isUnpublishable($modelId);
			$modelsPermissions[$modelId] = array();
			$modelsPermissions[$modelId]['editable'] = $this->get('app.permissions')->isModelEditable($modelId);
			$modelsPermissions[$modelId]['editableMessage'] = $this->get('app.permissions')->getMessage();
			$modelsPermissions[$modelId]['editableCode'] = $this->get('app.permissions')->getCode();
			$modelsPermissions[$modelId]['deletable'] = $this->get('app.permissions')->isModelDeletable($modelId);
			$modelsPermissions[$modelId]['deletableMessage'] = $this->get('app.permissions')->getMessage();
			$modelsPermissions[$modelId]['deletableCode'] = $this->get('app.permissions')->getCode();
		}
		$uploadForm = $this->createForm(ModelUploadType::class);
		return $this->render('IgnOGAMConfigurateurBundle:Model:index.html.twig', array(
			'models' => $models,
			'pubStates' => $modelsPubState,
			'publishable' => $modelsPublishable,
			'unpublishable' => $modelsUnpublishable,
			'permissions' => $modelsPermissions,
			'upload_form' => $uploadForm->createView()
		));
	}

	/**
	 * Creates a new model.
	 * @Route("/models/new/", name="configurateur_model_new")
	 */
	public function newAction(Request $request) {
		$model = new Model();
		$schema = new TableSchema();

		$em = $this->getDoctrine()->getManager('metadata_work');

		$schema = $em->getRepository('IgnOGAMConfigurateurBundle:TableSchema')->find("RAW_DATA");

		if (!$schema) {
			throw $this->createNotFoundException('schema not found in table_schema' . $schema);
		}

		$model->setSchema($schema);

		$form = $this->createForm(ModelType::class, $model);

		$form->handleRequest($request);

		if ($form->isValid()) {
			$em->persist($model);
			$em->flush();
			$id = $model->getId();
			return $this->redirectToRoute('configurateur_model_edit', array(
				'id' => $id
			));
		}

		return $this->render('IgnOGAMConfigurateurBundle:Model:new.html.twig', array(
			'form' => $form->createView(),
			'method' => 'Creation'
		));
	}

	/**
	 * Edits a model.
	 * @Route("/models/{id}/edit/", name="configurateur_model_edit")
	 */
	// la première partie de la page de la maquette est faite dans updateAction => à transposer ici ?
	public function editAction($id, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$modelRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Model');
		$model = $modelRepository->find($id);

		if (!$this->get('app.permissions')->isModelEditable($id)) {
			$this->addFlash('error', $this->get('app.permissions')
				->getMessage());
			return $this->redirectToRoute('configurateur_model_index');
		}

		if (!$model) {
			throw $this->createNotFoundException($this->get('translator')
				->trans('datamodel.notFound', array(
				'%modelId%' => $id
			)));
		}

		// Delete the mappings of this model
		$mappingsRemoved = false;
		$fmRepository = $em->getRepository("IgnOGAMConfigurateurBundle:FieldMapping");
		$tfRepository = $em->getRepository("IgnOGAMConfigurateurBundle:TableField");

		foreach ($model->getTables() as $table) {
			// Check if there are fields in the table
			$fields = $tfRepository->findFieldsByTableFormat($table->getFormat());
			if (count($fields) > 0) {
				// Check if there are mappings to delete
				$mappings = $fmRepository->findNotMappedFieldsInTable($table->getFormat(), 'FILE');
				if (count($mappings) == 0) {
					$fmRepository->removeAllByTableFormat($table->getFormat());
					$mappingsRemoved = true;
				}
			}
		}
		if ($mappingsRemoved) {
			$this->addFlash('warning', $this->get('translator')
				->trans('datamodel.edit.mappings_removed'));
		}

		$modelName = $model->getName();

		$form = $this->createForm(ModelType::class, $model);
		$form->setData($model);

		$form->handleRequest($request);

		if ($form->isValid()) {
			$em->persist($model);
			$em->flush();
			$modelName = $model->getName();
		}

		$tables = $model->getTables();

		return $this->render('IgnOGAMConfigurateurBundle:Model:edit.html.twig', array(
			'modelForm' => $form->createView(),
			'modelName' => $modelName,
			'model' => $model,
			'tables' => $tables,
			'id' => $id,
			'publishable' => $this->get('app.modelPublication')
				->isPublishable($id)
		));
	}

	/**
	 * Publishes a model into the production database.
	 * Adds flash messages to notice user about success or fail of action.
	 * Redirects to index.
	 * @Route("/models/{modelId}/publish/", name="configurateur_model_publish")
	 */
	public function publishAction($modelId) {
		$model = $this->getDoctrine()
			->getManager('metadata_work')
			->getRepository('IgnOGAMConfigurateurBundle:Model')
			->find($modelId);
		if ($model) {
			// Reset tomcat caches
			$cachesCleared = $this->get('app.resettomcatcaches')->performRequest();
			if ($cachesCleared == false) {
				$this->addFlash('error', $this->get('translator')
					->trans('datamodel.resetCaches.fail'));
			} else {

				$successStatus = $this->get('app.modelpublication')->publishModel($modelId);
				$modelName = $model->getName();
				if ($successStatus == true) {
					$this->addFlash('notice', $this->get('translator')
						->trans('datamodel.publish.success', array(
						'%modelName%' => $modelName
					)));
					// Show import models that are not yet published
					$imNames = $this->get('app.modelpublication')->getUnpublishedImportModelsNames($modelId);
					if (count($imNames) > 0) {
						$nameList = join(' ' . $this->get('translator')->trans('and') . ' ', array_filter(array_merge(array(
							join(', ', array_slice($imNames, 0, -1))
						), array_slice($imNames, -1)), 'strlen'));
						if (count($imNames) == 1) {
							$this->addFlash('notice', $this->get('translator')
								->trans('datamodel.publish.unpublishedImportModel', array(
								'%imName%' => $nameList
							)));
						} else {
							$this->addFlash('notice', $this->get('translator')
								->trans('datamodel.publish.unpublishedImportModels', array(
								'%imNames%' => $nameList
							)));
						}
					}
				} else {
					$this->addFlash('error', $this->get('translator')
						->trans('datamodel.publish.fail', array(
						'%modelName%' => $modelName
					)));
				}
			}
		} else {
			$this->addFlash('error', $this->get('translator')
				->trans('datamodel.publish.badid', array(
				'%modelId%' => $modelId
			)));
		}

		return $this->redirectToRoute('configurateur_model_index');
	}

	/**
	 * Unpublishes a model from the production database.
	 * Unpublishes also all the related import models.
	 * TODO Unpublishes also all the related form models (see story #243).
	 *
	 * @param boolean $redirectToEdit
	 *        	optional
	 *        	parameter. if true, will redirect to edit page after unpublication
	 *
	 * @Route("/models/{modelId}/unpublish/{redirectToEdit}", name="configurateur_model_unpublish")
	 *        	
	 */
	public function unpublishAction($modelId, $redirectToEdit = false) {
		$logger = $this->get('monolog.logger.ginco');
		$model = $this->getDoctrine()
			->getManager('metadata_work')
			->getRepository('IgnOGAMConfigurateurBundle:Model')
			->find($modelId);
		if ($model) {
			// Check if model has data. If yes, then stop unpublishing
			if ($this->get('app.modelunpublication')->modelHasData($modelId)) {
				$this->addFlash('error', $this->get('translator')
					->trans('datamodel.unpublish.hasData', array(
					'%modelName%' => $model->getName()
				)));
				return $this->redirectToRoute('configurateur_model_index');
			} else {
				// Unpublish the import models
				$importModelIds = $this->get('app.modelunpublication')->getImportModelsFromDataModel($modelId);
				foreach ($importModelIds as $importModelId) {
					$this->forward('IgnOGAMConfigurateurBundle:DatasetImport:unpublish', array(
						'importModelId' => $importModelId,
						'unpublishFromModel' => true
					));
					$importModelName = $this->getDoctrine()
						->getManager('metadata_work')
						->getRepository('IgnOGAMConfigurateurBundle:Dataset')
						->find($importModelId)
						->getLabel();
					// If there is an error message, process it and stop the model unpublication
					$flashBag = $this->get('session')
						->getFlashBag()
						->get('error');
					if (sizeof($flashBag) == 1) {
						$flashMessage = $flashBag[0];
						$failErrorMessage = $this->get('translator')->trans('importmodel.unpublish.fail', array(
							'%importModelName%' => $importModelName
						));
						$uploadErrorMessage = $this->get('translator')->trans('importmodel.unpublish.uploadrunning');
						$logger->debug('error message ' . $failErrorMessage);
						$logger->debug('flash message ' . $flashMessage);
						$logger->debug('upload error message ' . $uploadErrorMessage);
						if ($flashMessage == $failErrorMessage) {
							$this->addFlash('error', $this->get('translator')
								->trans('datamodel.unpublish.failduetoimportmodel', array(
								'%importModelName%' => $importModelName,
								'%modelName%' => $model->getName()
							)));
							return $this->redirectToRoute('configurateur_model_index');
						} else if ($flashMessage == $uploadErrorMessage) {
							$this->addFlash('error', $this->get('translator')
								->trans('importmodel.unpublish.uploadrunning', array(
								'%importModelId%' => $importModelId
							)));
							return $this->redirectToRoute('configurateur_model_index');
						}
					}
				}
				// TODO Unpublish the saisie models
				// Unpublish the model
				$successStatus = $this->get('app.modelunpublication')->unpublishModel($modelId);
				$modelName = $model->getName();
				if ($successStatus == true) {
					$this->addFlash('notice', $this->get('translator')
						->trans('datamodel.unpublish.success', array(
						'%modelName%' => $modelName
					)));
				} else {
					$this->addFlash('error', $this->get('translator')
						->trans('datamodel.unpublish.fail', array(
						'%modelName%' => $modelName
					)));
				}
			}
		} else {
			$this->addFlash('error', $this->get('translator')
				->trans('datamodel.unpublish.badid', array(
				'%modelId%' => $modelId
			)));
		}
		if ($redirectToEdit) {
			return $this->redirectToRoute('configurateur_model_edit', array(
				'id' => $modelId
			));
		} else {
			return $this->redirectToRoute('configurateur_model_index');
		}
	}

	/**
	 * Deletes the model.
	 * Delete the associated unpublished import models.
	 * Deletes all the tables from a model, then the model.
	 * Returns to the model index page.
	 * @Route("/models/{id}/delete/", name="configurateur_model_delete")
	 */
	public function deleteAction($id) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$model = $em->getRepository('IgnOGAMConfigurateurBundle:Model')->find($id);

		if (!$this->get('app.permissions')->isModelDeletable($id)) {
			$this->addFlash('error', $this->get('app.permissions')
				->getMessage());
		} else {
			$modelName = $model->getName();

			// Delete the import models
			$importModelIds = $this->get('app.modelunpublication')->getImportModelsFromDataModel($id);
			foreach ($importModelIds as $importModelId) {
				$importModelName = $this->getDoctrine()
					->getManager('metadata_work')
					->getRepository('IgnOGAMConfigurateurBundle:Dataset')
					->find($importModelId)
					->getLabel();

				$this->forward('IgnOGAMConfigurateurBundle:DatasetImport:delete', array(
					'id' => $importModelId
				));

				// If there is an error message, process it and stop the model deletion
				$flashBag = $this->get('session')
					->getFlashBag()
					->get('error');
				if (count($flashBag) == 1) {
					$flashMessage = $flashBag[0];
					$forbiddenErrorMessage = $this->get('translator')->trans('importmodel.delete.forbidden');
					if ($flashMessage == $forbiddenErrorMessage) {
						$this->addFlash('error', $this->get('translator')
							->trans('datamodel.unpublish.failDueToImportModel', array(
							'%importModelName%' => $importModelName,
							'%modelName%' => $modelName
						)));
					}
				}
			}
			// TODO Delete the saisie models
			// Delete the model
			foreach ($model->getTables() as $table) {
				$this->forward('IgnOGAMConfigurateurBundle:Table:delete', array(
					'model_id' => $id,
					'id' => $table->getFormat(),
					'fromDeleteModel' => true
				));
			}
			$model->getTables()->clear();

			$em->remove($model);
			$em->flush();

			$this->addFlash('notice', $this->get('translator')
				->trans('datamodel.delete.success', array(
				'%modelName%' => $modelName
			)));
		}

		return $this->redirectToRoute('configurateur_model_index');
	}

	/**
	 * @Route("/models/{id}/import/", name="configurateur_model_import")
	 */
	public function importAction() {
		// le formulaire pour l'upload de fichier
		$form = $this->createForm(ModelUploadType::class);

		if ($form->isValid()) {
			return $this->forward('IgnOGAMConfigurateurBundle:Model:index');
		}

		return $this->render('IgnOGAMConfigurateurBundle:Model:upload.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Shows a model.
	 * @Route("/models/{id}/view/", name="configurateur_model_view")
	 */
	public function viewAction($id) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$modelRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Model');
		$model = $modelRepository->find($id);
		if (!$model) {
			throw $this->createNotFoundException($this->get('translator')
				->trans('datamodel.notFound', array(
				'%modelId%' => $id
			)));
		}

		$modelName = $model->getName();
		$tables = $model->getTables();

		return $this->render('IgnOGAMConfigurateurBundle:Model:view.html.twig', array(
			'modelName' => $modelName,
			'model' => $model,
			'tables' => $tables,
			'id' => $id
		));
	}

	/**
	 * @Route("/models/{id}/duplicate/", name="configurateur_model_duplicate")
	 */
	public function duplicateAction($id, Request $request) {
		$model = $this->getDoctrine()
			->getManager('metadata_work')
			->getRepository('IgnOGAMConfigurateurBundle:Model')
			->find($id);
		if ($model) {

			// Create a new model only to activate assertions on the entity
			$modelNew = new Model();
			$form = $this->createForm(ModelType::class, $modelNew);

			$form->handleRequest($request);

			if ($form->isValid()) {
				$copyModelName = $form->getData()->getName();
				$copyModelDescription = $form->getData()->getDescription();
				$successStatus = $this->get('app.modelduplication')->duplicateModel($model, $copyModelName, $copyModelDescription);
				$modelName = $model->getName();
				if ($successStatus == 'datamodel.duplicate.success') {
					$this->addFlash('notice', $this->get('translator')
						->trans($successStatus, array(
						'%modelName%' => $modelName
					)));
				} else if ($successStatus == 'datamodel.duplicate.fail') {
					$this->addFlash('error', $this->get('translator')
						->trans($successStatus, array(
						'%modelId%' => $id
					)));
				} else if ($successStatus == 'datamodel.duplicate.hasCopy') {
					$this->addFlash('error', $this->get('translator')
						->trans($successStatus, array(
						'%modelName%' => $modelName
					)));
				}
				// Redirect to list of models
				return $this->redirectToRoute('configurateur_model_index');
			}

			return $this->render('IgnOGAMConfigurateurBundle:Model:new.html.twig', array(
				'form' => $form->createView(),
				'method' => 'Duplication'
			));
		} else {
			$this->addFlash('error', $this->get('translator')
				->trans('datamodel.duplicate.badid', array(
				'%modelId%' => $id
			)));
		}
	}
}
