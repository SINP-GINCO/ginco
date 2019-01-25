<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\Data;
use Ign\Bundle\OGAMConfigurateurBundle\Form\DataType;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Form\Extension\Core\Type\HiddenType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\HttpFoundation\Request;
use Monolog\Logger;

/**
 * Data controller.
 *
 * @Route("/data")
 */
class DataController extends Controller {

	/**
	 * Lists all Data entities.
	 * Separate in two tables editable and non editable entities.
	 * (editable = deletable = the entity is not used in any Field)
	 *
	 * @Route("", name="configurateur_data_index")
	 */
	public function indexAction() {
		$em = $this->getDoctrine()->getManager('metadata');
		$entities = $em->getRepository('IgnGincoBundle:Metadata\Data')->findAll();

		$editableDatas = $em->getRepository('IgnGincoBundle:Metadata\Data')->findAllNotRelatedToFields();
		$notEditableDatas = $em->getRepository('IgnGincoBundle:Metadata\Data')->findAllRelatedToFields();

		return $this->render('IgnOGAMConfigurateurBundle:Data:index.html.twig', array(
			'datas' => $entities,
			'editable' => $editableDatas,
			'not_editable' => $notEditableDatas
		));
	}

	/**
	 * Creates a new Data entity.
	 * Optionnal GET or POST parameters :
	 * "add_to_format" : the format of a table or file to attach the field to.
	 *
	 * @Route("/new", name="configurateur_data_new")
	 * @Route("/new/addto/{format}", name="configurateur_data_new_addtoformat")
	 */
	public function newAction(Request $request, $format = "") {
		$entity = new Data();
		$form = $this->createCreateForm($entity, $format);
		$form->handleRequest($request);

		if ($form->isValid()) {
			$em = $this->getDoctrine()->getManager('metadata');
			$em->persist($entity);
			$em->flush();

			// Attach the new Data to a table ?
			$attachField = false;

			if ($form->has('add_to_format')) {
				// Checks if the table exists and is editable
				$formatSubmitted = $form->get('add_to_format')->getData();
				$theFormat = $em->getRepository('IgnGincoBundle:Metadata\Format')->find($formatSubmitted);
				$type = ($theFormat) ? $theFormat->getType() : "";
				$tableFormat = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($formatSubmitted);
				if ($tableFormat) {
					// Do you have the right to modify the tableFormat object ?
					$modelsPubState = $tableFormat->getModel()->isPublished() ;
					$modelsHasData = $this->get('app.modelunpublication')->modelHasData($tableFormat->getModel()
						->getId());
					if (!$modelsPubState && !$modelsHasData) {
						$attachField = true;
					}
				}
			}

			// Redirects to "Add Fields to the table" page (which then redirects to the "edit table" page).
			if ($attachField) {
				$this->addFlash('notice', $this->get('translator')
					->trans('data.add.attachsuccess.table', array(
					'%dataName%' => $entity->getName()
				)));

				return $this->redirectToRoute('configurateur_table_add_field', array(
					'modelId' => $tableFormat->getModel()
						->getId(),
					'format' => $formatSubmitted,
					'data'=> $entity->getName()
				));
			} else			// Redirects to the Data Dictionnary index
			{
				$this->addFlash('notice', $this->get('translator')
					->trans('data.add.success', array(
					'%dataName%' => $entity->getName()
				)));

				return $this->redirectToRoute('configurateur_data_index');
			}
		}

		return $this->render('IgnOGAMConfigurateurBundle:Data:edit.html.twig', array(
			'title' => $this->get('translator')
				->trans('data.add.title'),
			'data' => $entity,
			'form' => $form->createView()
		));
	}

	/**
	 * Creates a form to create a Data entity.
	 *
	 * @param Data $entity
	 *        	The entity
	 * @param $format Name
	 *        	of a table or file to attach the new $entity to
	 * @return \Symfony\Component\Form\Form The form
	 */
	private function createCreateForm(Data $entity, $format) {
		$form = $this->createForm(DataType::class, $entity, array(
			'method' => 'POST'
		));

		// label of the submit button
		$label = 'Add';

		// A hidden field to add the new Data entity to a table
		if ($format) {
			// Checks if the table/file exists and is editable
			$em = $this->getDoctrine()->getManager('metadata');
			$theFormat = $em->getRepository('IgnGincoBundle:Metadata\Format')->find($format);
			$type = ($theFormat) ? $theFormat->getType() : "";
			switch ($type) {
				case 'TABLE':
					$tableFormat = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($format);
					if ($tableFormat) {
						// Do you have the right to modify the tableFormat object ?
						$modelsPubState = $tableFormat->getModel()->isPublished();
						$modelsHasData = $this->get('app.modelunpublication')->modelHasData($tableFormat->getModel()
							->getId());
						if (!$modelsPubState && !$modelsHasData) {

							$form->add('add_to_format', HiddenType::class, array(
								'data' => $format,
								'mapped' => false
							));
							$label = 'data.add.attach.table';
						}
					}
					break;
				case 'FILE':
					$fileFormat = $em->getRepository('IgnGincoBundle:Metadata\FileFormat')->find($format);
					if ($fileFormat) {
						// Do you have the right to modify the tableFormat object ?
						$importModelPubState = $fileFormat->getDataset()->isPublished();
						if (!$importModelPubState) {

							$form->add('add_to_format', HiddenType::class, array(
								'data' => $format,
								'mapped' => false
							));
							$label = 'data.add.attach.file';
						}
					}
					break;
			}
		}
		$form->add('submit', SubmitType::class, array(
			'label' => $label
		));
		return $form;
	}

	/**
	 * Finds and displays a Data entity.
	 * Shows Fields it in used into.
	 *
	 * @Route("/{id}", name="configurateur_data_show")
	 */
	public function showAction($id) {
		$em = $this->getDoctrine()->getManager('metadata');
		$entity = $em->getRepository('IgnGincoBundle:Metadata\Data')->find($id);

		if (!$entity) {
			throw $this->createNotFoundException('Aucun champ du dictionnaire de données trouvé pour cet id : ' . $id);
		}

		// -- Get Tables and Files where Data is used
		$fields = $entity->getFields()->toArray();
		$tables = array();
		$files = array();
		foreach ($fields as $index => $field) {
			// Gets the logical name of the format from Format obj
			$formatName = $field->getFormat()->getFormat();
			// Now gets the TableFormat object of the same logical name
			$tableFormat = $em->getRepository('IgnGincoBundle:Metadata\TableFormat')->find($formatName);
			if ($tableFormat) {
				$tables[$index]['table'] = $tableFormat;
				$tables[$index]['model'] = $tableFormat->getModel();
				// Do you have the right to modify the tableFormat object ?
				$modelsPubState = $tableFormat->getModel()->isPublished();
				$modelsHasData = $this->get('app.modelunpublication')->modelHasData($tableFormat->getModel()
					->getId());
				$tables[$index]['editable'] = (!$modelsPubState && !$modelsHasData);
			}
			// And/or the FileFormat object of the same logical name
			$fileFormat = $em->getRepository('IgnGincoBundle:Metadata\FileFormat')->find($formatName);
			if ($fileFormat) {
				$files[$index]['file'] = $fileFormat;
				$files[$index]['dataset'] = $fileFormat->getDataset();
				// Do you have the right to modify the FileFormat object ?
				$importModelPubState = $fileFormat->getDataset()->isPublished();
				$files[$index]['editable'] = (!$importModelPubState);
			}
		}

		return $this->render('IgnOGAMConfigurateurBundle:Data:show.html.twig', array(
			'title' => $this->get('translator')
				->trans('data.show.title', array(
				'%dataName%' => $entity->getName()
			)),
			'data' => $entity,
			'tables' => $tables,
			'files' => $files
		));
	}

	/**
	 * Displays a form to edit an existing Data entity.
	 * @Route("/{id}/edit", name="configurateur_data_edit")
	 */
	public function editAction($id, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata');

		$entity = $em->getRepository('IgnGincoBundle:Metadata\Data')->find($id);

		if (!$entity) {
			throw $this->createNotFoundException('Aucun champ du dictionnaire de données trouvé pour cet id : ' . $id);
		}

		if ($entity->isEditable()) {
			$form = $this->createEditForm($entity);

			$form->handleRequest($request);

			if ($form->isValid()) {
				$em->flush();

				$this->addFlash('notice', $this->get('translator')
					->trans('data.edit.success', array(
					'%dataName%' => $entity->getName()
				)));

				return $this->redirect($this->generateUrl('configurateur_data_index'));
			}
		} else {
			$this->addFlash('error', $this->get('translator')
				->trans('data.edit.forbidden', array(
				'%dataName%' => $entity->getName()
			)));

			return $this->redirectToRoute('configurateur_data_index');
		}

		return $this->render('IgnOGAMConfigurateurBundle:Data:edit.html.twig', array(
			'title' => $this->get('translator')
				->trans('data.edit.title'),
			'data' => $entity,
			'form' => $form->createView()
		));
	}

	/**
	 * Creates a form to edit a Data entity.
	 *
	 * @param Data $entity
	 *        	The entity
	 *
	 * @return \Symfony\Component\Form\Form The form
	 */
	private function createEditForm(Data $entity) {
		$form = $this->createForm(DataType::class, $entity, array(
			'action' => $this->generateUrl('configurateur_data_edit', array(
				'id' => $entity->getId()
			))
		));

		$form->add('submit', SubmitType::class, array(
			'label' => $this->get('translator')
				->trans('Edit')
		));

		return $form;
	}

	/**
	 * Deletes a Data entity.
	 * @Route("/{id}/delete", name="configurateur_data_delete")
	 */
	public function deleteAction($id) {
		$em = $this->getDoctrine()->getManager('metadata');

		$entity = $em->getRepository('IgnGincoBundle:Metadata\Data')->find($id);
		if (!$entity) {
			throw $this->createNotFoundException('Aucun champ du dictionnaire de données trouvé pour cet id : ' . $id);
		}

		if ($entity->isDeletable()) {
			$em->remove($entity);
			$em->flush();

			$this->addFlash('notice', $this->get('translator')
				->trans('data.delete.success', array(
				'%dataName%' => $entity->getName()
			)));

			return $this->redirectToRoute('configurateur_data_index');
		} else {

			$fields_format = array();
			/*
			 * foreach ($entity->getFields() as $field) {
			 * $fields_format[] = $field->getFormat()->getFormat();
			 * }
			 */

			$this->addFlash('error', $this->get('translator')
				->trans('data.delete.forbidden', array(
				'%dataName%' => $entity->getName(),
				'%fieldsFormat%' => implode(',', $fields_format)
			)));

			return $this->redirectToRoute('configurateur_data_index');
		}
	}
}
