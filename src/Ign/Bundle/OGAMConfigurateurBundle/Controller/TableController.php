<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableFormat;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\DataRepository;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Format;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableSchema;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Field;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableTree;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Data;
use Ign\Bundle\OGAMConfigurateurBundle\Form\TableFormatType;
use Ign\Bundle\OGAMConfigurateurBundle\Form\TableUpdateType;
use Ign\Bundle\OGAMConfigurateurBundle\Form\TableUpdateFieldsType;
use Ign\Bundle\OGAMConfigurateurBundle\Form\ModelType;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Form\FormError;
use Assetic\Exception\Exception;
use Doctrine\DBAL\Connection;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;

class TableController extends Controller {

	/**
	 * Table creation
	 *
	 * @param string $id,
	 *        	the identifier of the model
	 * @param Request $request
	 * @return @Route("models/{id}/tables/new/", name="configurateur_table_index", defaults={"id":0})
	 */
	public function newAction(Model $model, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$table = new TableFormat();

		// create new table form
		$formOptions = array(
			'model' => $model,
			'conn' => $conn = $this->getDoctrine()->getConnection(),
			'em' => $em
		);
		$formTable = $this->createForm(TableFormatType::class, $table, $formOptions);

		// Add a "save and manage fields" button
		$formTable->add('saveAndFields', SubmitType::class, array(
			'label' => 'table.edit.saveandfields'
		));

		// Handle request
		$formTable->handleRequest($request);

		// Custom validator to check unicity of tableName in the model
		// is impossible as tableName is set after form is valid.
		$tableFormatRepository = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat');
		$newTableName = $model->getId() . '_' . $table->getLabel();
		$existingTable = $tableFormatRepository->findByTableName($newTableName);
		if ($existingTable) {
			// tableName already exists : we add this error to the form
			$errorMessage = $this->get('translator')->trans('table.name.exists', array(
				'%modelName%' => $model->getName()
			));
			$formTable->get('label')->addError(new FormError($errorMessage));
		}

		if ($formTable->isValid()) {
			$table->setSchemaCode('RAW_DATA');
			$table->setFormat(uniqid('table_'));
			$table->setTableName($model->getId() . '_' . $table->getLabel());
			$table->setPrimaryKey();

			// create a new Format
			$format = new Format();
			$format->setFormat($table->getFormat());
			$format->setType('TABLE');

			// save an occurrence of table_format in the meta-class format
			$em->persist($format);
			$em->flush();

			// save an occurrence of table_format
			$em->persist($table);
			$model->addTable($table);
			$em->flush();

			// save an occurrence of table_tree

			$parent = $table->getParent();
			$parent = (empty($parent)) ? '*' : $parent;
			$tableTree = new TableTree();
			if ($parent == '*') {
				$tableTree->setChildTable($table->getFormat())
					->setParentTable('*')
					->setSchemaCode($em->getRepository('IgnOGAMConfigurateurBundle:TableSchema')
					->find($table->getSchemaCode()));
				$em->persist($tableTree);
			} else {
				$parent = $tableFormatRepository->find($parent);
				$tableTree->setChildTable($table->getFormat())
					->setParentTable($parent->getFormat())
					->setSchemaCode($em->getRepository('IgnOGAMConfigurateurBundle:TableSchema')
					->find($table->getSchemaCode()))
					->setJoinKey($parent->getPrimaryKey());
				$em->persist($tableTree);

				// Add foreign key (parent table primary key)
				$this->forward('IgnOGAMConfigurateurBundle:TableField:addFields', array(
					'modelId' => $model->getId(),
					'format' => $format,
					'fields' => $parent->getPKName()
				));
			}

			// Create a new DATA entry for primary key
			$data = new Data();
			$textValue = $em->getRepository('IgnOGAMConfigurateurBundle:Unit')->find('IDString');
			$label = $this->get('Translator')->trans('data.primary_key', array(
				'%tableLabel%' => $table->getLabel()
			));
			$data->setName($table->getPkName())
				->setUnit($textValue)
				->setLabel($label)
				->setDefinition($label);
			$em->persist($data);
			$em->flush();

			// add technical fields to the new table
			$fields = "PROVIDER_ID,SUBMISSION_ID," . $table->getPkName();
			$this->forward('IgnOGAMConfigurateurBundle:TableField:addFields', array(
				'modelId' => $model->getId(),
				'format' => $format,
				'fields' => $fields
			));

			$nextAction = $formTable->get('saveAndFields')->isClicked() ? 'configurateur_table_fields' : 'configurateur_table_edit';

			return $this->redirectToRoute($nextAction, array(
				'modelId' => $model->getId(),
				'format' => $format->getFormat()
			));
		}

		return $this->render('IgnOGAMConfigurateurBundle:TableFormat:new.html.twig', array(
			'tableForm' => $formTable->createView(),
			'model' => $model
		));
	}

	/**
	 * @Route("models/{modelId}/tables/{format}/edit/", name="configurateur_table_edit")
	 */
	public function editAction($modelId, $format, Request $request) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$table = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($format);
		$model = $em->getRepository('IgnOGAMConfigurateurBundle:Model')->find($modelId);
		$tableTree = $em->getRepository('IgnOGAMConfigurateurBundle:TableTree')->findOneByChildTable($table->getFormat());
		if ($tableTree == null) {
			$tableTree = new TableTree();
		}
		if (!$table) {
			$errMsg = "Aucune TABLE ne correspond à : " . $format;
			throw $this->createNotFoundException($errMsg);
		}
		// Set parent manually cause not persisted in TableFormat
		if ($tableTree->getParentTable() != '*') {
			$table->setParent($tableTree->getParentTable());
		}

		// create table form
		$formOptions = array(
			'model' => $model,
			'tableFormat' => $format,
			'conn' => $conn = $this->getDoctrine()->getConnection(),
			'em' => $em
		);
		$form = $this->createForm(TableFormatType::class, $table, $formOptions);

		$form->handleRequest($request);

		// Check unicity of tableName in the model
		$tableFormatRepository = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat');
		$newTableName = $modelId . '_' . $table->getLabel();
		$existingTable = $tableFormatRepository->findByTableName($newTableName);

		if ($existingTable and $existingTable[0]->getFormat() != $table->getFormat()) {
			// tableName already exists and is not the current one: we add this error to the form
			$errorMessage = $this->get('Translator')->trans('table.name.exists', array(
				'%modelName%' => $model->getName()
			));
			$form->get('label')->addError(new FormError($errorMessage));
		}

		if ($form->isValid()) {

			$table->setTableName($newTableName);

			// Change PK label with new table name
			$data = $em->getRepository('IgnOGAMConfigurateurBundle:Data')->find($table->getPKName());
			if ($data) {
				$label = $this->get('Translator')->trans('data.primary_key', array(
					'%tableLabel%' => $table->getLabel()
				));
				$data->setLabel($label)->setDefinition($label);
				$em->flush();
			}
			$parent = $table->getParent();

			// Save relation between parent and child table in table_tree
			if (empty($parent)) {
				// Remove all references to possible former relation with former parent table, except in table data
				$em->getRepository('IgnOGAMConfigurateurBundle:TableField')->deleteForeignKeysByTableFormat($format);
				$em->getRepository('IgnOGAMConfigurateurBundle:Field')->deleteForeignKeysByFormat($format);
				$em->flush();

				// Remove entry from table_tree
				if ($em->contains($tableTree)) {
					$tableTree->setParentTable('*')->setJoinKey(null);
					$em->flush();
				}
			} else {
				$parent = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($parent);
				$tableTree->setChildTable($table->getFormat())
					->setParentTable($parent->getFormat())
					->setSchemaCode($em->getRepository('IgnOGAMConfigurateurBundle:TableSchema')
					->find($table->getSchemaCode()))
					->setJoinKey($parent->getPrimaryKey());
				$em->persist($tableTree);

				// Remove all references to possible former relation with former parent table, except in table data
				$em->getRepository('IgnOGAMConfigurateurBundle:TableField')->deleteForeignKeysByTableFormat($format);
				$em->getRepository('IgnOGAMConfigurateurBundle:Field')->deleteForeignKeysByFormat($format);
				$em->flush();

				// Add foreign key (parent table primary key)
				$this->forward('IgnOGAMConfigurateurBundle:TableField:addFields', array(
					'modelId' => $modelId,
					'format' => $format,
					'fields' => $parent->getPKName()
				));
			}
			$em->persist($table);
			try {
				$em->flush();
				$this->addFlash('notice', $this->get('translator')
					->trans('table.edit.definition.success', array(
					'%tableName%' => $table->getLabel()
				)));
			} catch (\Doctrine\DBAL\DBALException $e) {
				$this->addFlash('notice', $this->get('translator')
					->trans('table.edit.definition.fail', array(
					'%tableName%' => $table->getLabel()
				)));
			}

			return $this->redirectToRoute('configurateur_table_edit', array(
				'modelId' => $modelId,
				'format' => $format
			));
		}

		return $this->render('IgnOGAMConfigurateurBundle:TableFormat:edit.html.twig', array(
			'tableForm' => $form->createView(),
			'table' => $table,
			'model' => $model
		));
	}

	/**
	 * @Route("models/{modelId}/tables/{format}/fields/", name="configurateur_table_fields")
	 */
	public function manageFieldsAction($modelId, $format) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$table = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($format);
		$model = $em->getRepository('IgnOGAMConfigurateurBundle:Model')->find($modelId);

		if (!$table) {
			$errMsg = "Aucune TABLE ne correspond à : " . $format;
			throw $this->createNotFoundException($errMsg);
		}

		$dataRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Data');
		// Get data dictionnary
		$allFields = $dataRepository->findAllFields();
		$fieldsForm = $this->createForm(TableUpdateFieldsType::class, null);
		// Get table fields
		$tableFieldRepository = $em->getRepository('IgnOGAMConfigurateurBundle:TableField');
		$tableFields = $tableFieldRepository->findFieldsByTableFormat($table->getFormat());

		return $this->render('IgnOGAMConfigurateurBundle:TableFormat:fields.html.twig', array(
			'table' => $table,
			'allFields' => $allFields,
			'tableFields' => $tableFields,
			'model' => $model,
			'fieldsForm' => $fieldsForm->createView()
		));
	}

	/**
	 * Deletes the table given by its id in the model given by its id.
	 * It will also delete all the TableField and Field (technical and non-technical) linked to the TableFormat,
	 * and also the Format. Table tree entry is also deleted.
	 * Data field created to be the primary key of the table is deleted in data table.
	 * Redirects to table edition page.
	 * @Route("/models/{model_id}/tables/{id}/delete/", name="configurateur_table_delete")
	 * @Template()
	 */
	public function deleteAction($model_id, $id, $fromDeleteModel = false) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$formatRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Format');
		$tableFormatRepository = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat');
		$modelRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Model');
		$tableFieldRepository = $em->getRepository('IgnOGAMConfigurateurBundle:TableField');
		$fieldRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Field');
		$tableTreeRepository = $em->getRepository('IgnOGAMConfigurateurBundle:TableTree');
		$dataRepository = $em->getRepository('IgnOGAMConfigurateurBundle:Data');

		$mappingRepository = $em->getRepository("IgnOGAMConfigurateurBundle:FieldMapping");
		$mappingRepository->removeAllByTableFormat($id);
		$model = $modelRepository->find($model_id);
		$format = $formatRepository->find($id);
		$table = $tableFormatRepository->find($id);
		$tableTree = $tableTreeRepository->findOneByChildTable($id);

		$tableName = $table->getLabel();

		$tableFieldRepository->deleteAllByTableFormat($format);
		$fieldRepository->deleteAllByTableFormat($format);

		// Remove data entry used for PK
		$data = $dataRepository->find($table->getPKName());
		if ($data) {
			$em->remove($data);
			$em->flush();
		}

		if ($tableTree !== null) {
			$em->remove($tableTree);
		}
		$em->flush();

		$model->removeTable($table);
		$em->remove($table);
		$em->flush();
		$em->remove($format);

		$em->merge($model);
		$em->flush();
		$this->addFlash('notice', $this->get('translator')
			->trans('table.delete.success', array(
			'%tableName%' => $tableName
		)));

		return $this->redirectToRoute('configurateur_model_edit', array(
			'id' => $model_id
		));
	}

	/**
	 * @Route("models/{modelId}/tables/{format}/view/", name="configurateur_table_view")
	 * @Template()
	 */
	public function viewAction($modelId, $format) {
		$em = $this->getDoctrine()->getManager('metadata_work');

		$table = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($format);
		if (!$table) {
			$errMsg = "Aucune TABLE ne correspond à : " . $format;
			throw $this->createNotFoundException($errMsg);
		}

		$model = $em->getRepository('IgnOGAMConfigurateurBundle:Model')->find($modelId);

		$tableTree = $em->getRepository('IgnOGAMConfigurateurBundle:TableTree')->findOneByChildTable($table->getFormat());
		if ($tableTree == null) {
			$tableTree = new TableTree();
			$parentTableName = null;
		} else {
			$parentTableFormat = $tableTree->getParentTable();

			if ($parentTableFormat == '*') {
				$parentTableName = null;
			} else {
				$parentTable = $em->getRepository('IgnOGAMConfigurateurBundle:TableFormat')->find($parentTableFormat);
				$parentTableName = $parentTable->getLabel();
			}
		}

		// Get table fields
		$tableFieldRepository = $em->getRepository('IgnOGAMConfigurateurBundle:TableField');
		$tableFields = $tableFieldRepository->findFieldsByTableFormat($table->getFormat());

		return $this->render('IgnOGAMConfigurateurBundle:TableFormat:view.html.twig', array(
			'parentTable' => $parentTableName,
			'table' => $table,
			'tableFields' => $tableFields,
			'modelId' => $modelId,
			'modelName' => $model->getName()
		));
	}
}
