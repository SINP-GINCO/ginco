<?php
namespace Ign\Bundle\OGAMBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Form\Form;
use Symfony\Component\Form\FormBuilder;
use Ign\Bundle\OGAMBundle\Entity\Metadata\TableField;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FormField;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type as FType;
use Symfony\Component\Validator\Constraints as Assert;
use Zend\Validator\Date;
use Symfony\Component\Serializer\Serializer;
use Symfony\Component\Serializer\Normalizer\ObjectNormalizer;
use Ign\Bundle\OGAMBundle\Form\AjaxType;
use Symfony\Component\HttpFoundation\Response;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Security;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericTableFormat;
use Symfony\Component\Serializer\Normalizer\PropertyNormalizer;

/**
 * @Route ("/dataedition")
 */
class DataEditionController extends GincoController {

	/**
	 * Parse request parameters and build the corresponding data object.
	 *
	 * @param Request $request
	 *        	The request object.
	 * @return GenericTableFormat the data object
	 */
	protected function getDataFromRequest($request) {
		$params = array();
		$id = $request->attributes->get('id');
		if (is_string($id)) {
			$list = explode('/', $id); // will be like key1/value1/key2/value2
			if (count($list) % 2) { // is an key+value list so odd is error
				$this->createNotFoundException('DataObject not found');
			}
			$params = array_column(array_chunk($list, 2), 1, 0); // make array key =>value
		}

		$schema = $params["SCHEMA"];
		$format = $params["FORMAT"];

		$data = $this->get('ogam.generic_service')->buildGenericTableFormat($schema, $format);

		// Complete the primary key info with the session values
		foreach ($data->getIdFields() as $infoField) {
			if (!empty($params[$infoField->getData()])) {
				$infoField->setValue($params[$infoField->getData()]);
			}
		}

		// Complete the other fields with the session values (particulary join_keys)
		foreach ($data->getFields() as $editableField) {
			if (!empty($params[$editableField->getData()])) {
				$editableField->setValue($params[$editableField->getData()]);
			}
		}

		return $data;
	}

	/**
	 * Edit a data.
	 *
	 * A data here is the content of a table, or if a dataset is selected the table filtrered with the dataset elements.
	 *
	 * @param GenericTableFormat $data
	 *        	The data to display (optional)
	 * @param String $message
	 *        	a confirmation/warning message to display (optional)
	 * @return Response @Route("/show-edit-data/{id}", requirements={"id"= ".*"}, name="dataedition_showEditData")
	 */
	public function showEditDataAction(Request $request, $data = null, $message = '') {
		$genericModel = $this->get('ogam.manager.generic');
		$mode = 'EDIT';
		// If data is set then we don't need to read from database
		if ($data === null) {
			$data = $this->getDataFromRequest($request);
			$genericModel->getDatum($data);
		}

		// If the objet is not existing then we are in create mode instead of edit mode

		// Get the ancestors of the data objet from the database (to generate a summary)
		$ancestors = $genericModel->getAncestors($data);

		// Get the childs of the data objet from the database (to generate links)
		$children = $genericModel->getChildren($data);

		// Get the labels linked to the children table (to display the links)
		$childrenTableLabels = $this->get('doctrine.orm.metadata_entity_manager')
			->getRepository('OGAMBundle:Metadata\TableTree')
			->getChildrenTableLabels($data->getTableFormat());

		return $this->render('OGAMBundle:DataEdition:edit_data.html.php', array(
			'dataId' => $data->getId(),
			'tableFormat' => $data->getTableFormat(),
			'ancestors' => $ancestors,
			'data' => $data,
			'children' => $children,
			'childrenTableLabels' => $childrenTableLabels,
			'mode' => $mode,
			'message' => $message
		));
	}

	/**
	 * Delete a data.
	 *
	 * @return Response @Route("/ajax-delete-data/{id}", requirements={"id"= ".*"})
	 */
	public function ajaxDeleteDataAction(Request $request) {
		$data = $this->getDataFromRequest($request);
		$genericModel = $this->get('ogam.manager.generic');

		// Complete the data object with the existing values from the database.
		$data = $genericModel->getDatum($data);

		// Check if the data has children
		$children = $genericModel->getChildren($data);

		// Count the number of existing children (not only the table definitions)
		$childrenCount = 0;
		foreach ($children as $child) {
			$childrenCount += count($child);
		}

		// Get the ancestors
		$ancestors = $genericModel->getAncestors($data);

		if ($childrenCount > 0) {
			// Redirect to the index page
			$result = [
				'success' => false,
				'errorMessage' => $this->get('translator')->trans('Item cannot be deleted because it has children')
			];
		} else {

			// Delete the images linked to the data if present
			foreach ($data->all() as $field) {
				if ($field->getMetadata()
					->getData()
					->getUnit()
					->getType() === "IMAGE" && $field->getValue() !== "") {
					$uploadDir = $this->get('ogam.configuration_manager')->getConfig('image_upload_dir', '/var/www/html/upload/images');
					$dir = $uploadDir . "/" . $data->getId() . "/" . $field->getId();
					// $this->deleteDirectory($dir);//TODO : delete related files (upload not implemented yet)
				}
			}

			// Delete the data

			try {
				$genericModel->deleteData($data);
			} catch (\Exception $e) {
				if ($this->has('logger')) {
					$this->get('logger')->error($e->getMessage());
				}
				$result = [
					'success' => false,
					'errorMessage' => $this->get('translator')->trans('Error while deleting data')
				];
				return $this->json($result);
			}

			$result = [
				'success' => true
			];

			// If the data has an ancestor, we redirect to this ancestor
			if (!empty($ancestors)) {
				$parent = $ancestors[0];
				$redirectURL = $this->get('ogam.helper.editlink')->getEditLink($parent)['url'];
				$result['redirectLink'] = $redirectURL;
			}

			$result['message'] = $this->get('translator')->trans('Data deleted');
		}
		return $this->json($result);
	}

	/**
	 * Generate a Form Element from a TableField description.
	 *
	 * This is used only to validate the submitted data.
	 * The form is not displayed, the actual form is an ExtJS component.
	 *
	 * @param FormBuilder $form
	 *        	the form(element) builder
	 * @param GenericField $tableRowField
	 *        	the table descriptor of the data
	 * @param FormField|null $formField
	 *        	the form descriptor of the data
	 * @param Boolean $isKey
	 *        	is the field a primary key ?
	 * @return FormBuilderInterface the element (builder)
	 * @todo make all fields within OGAMBundle:FormTypes\..
	 */
	protected function getFormElement($form, GenericField $tableRowField, $formField, $isKey = false) {
		$tableField = $tableRowField->getMetadata();
		if (null === $formField) {
			throw new \InvalidArgumentException('tableField is required, not null');
		}

		$option = array();
		$option['label'] = $tableField->getLabel();
		$unit = $formField->getData()->getUnit();

		// Warning : $formField can be null if no mapping is defined with $tableField
		switch ($unit->getType()) {

			case "STRING":
				// Add a regexp validator if a mask is present
				if ($formField !== null && $formField->getMask() !== null) {
					$validator = new Assert\Regex(array(
						'pattern' => $formField->getMask()
					));
					$option['constraints'][] = $validator;
				}

				// The field is a text field
				$elem = $form->create($tableRowField->getId(), FType\TextType::class, $option);

				$elem->setData($tableRowField->getValue());
				break;

			case "INTEGER":

				$option['constraints'] = new Assert\Type('int'); // digit ?
				                                                 // The field is an integer
				$elem = $form->create($tableRowField->getId(), FType\TextType::class, $option);

				$elem->setData($tableRowField->getValue());
				break;

			case "NUMERIC":
				$option['constraints'] = [
					new Assert\Type('numeric')
				];
				// The field is a numeric
				if ($unit->getSubType() === "RANGE") {

					// Check min and max
					$range = $unit->getRange();
					$option['constraints'][] = new Assert\Range(array(
						'min' => $range->getMin(),
						'max' => $range->getMax()
					));
				}

				$elem = $form->create($tableRowField->getId(), FType\TextType::class, $option);

				$elem->setData($tableRowField->getValue());
				break;

			case "DATE":

				// The field is a date

				// validate the date format
				if ($formField !== null && $formField->getMask() !== null) {
					$validator = new Assert\Date();
					/*
					 * $validator = new Assert\DateTime(array(//@version 3.1 symfony
					 * 'format' => $formField->getMask(),
					 * ));
					 */
					$option['format'] = $formField->getMask();
				} else {
					$validator = new Assert\Date();
				}
				$option['input'] = 'string';
				$option['widget'] = 'single_text';
				$option['constraints'] = $validator;

				$elem = $form->create($tableRowField->getId(), FType\DateType::class, $option);
				$elem->setData(\DateTime::createFromFormat($tableRowField->getValue(), $elem->getOption('format')));
				break;
			case 'TIME':

				// validate the date format
				if ($formField !== null && $formField->getMask() !== null) {
					// $option['format'] = $formField->getMask();//TODO: mask ? symfony3.1 ?
				} else {
					// $option['format']='HH:mm';
				}

				$option['input'] = 'string';
				$option['widget'] = 'single_text';
				$option['data'] = $tableRowField->getValue();
				// The field is a date
				$elem = $form->create($tableRowField->getId(), FType\TimeType::class, $option);

				break;

			case "CODE":

				$elem = $form->create($tableRowField->getId(), FType\TextType::class, $option); // TODO choicetype depending the subtype, modes ....
				$elem->setData($tableRowField->getValue());
				break;

			case "BOOLEAN":

				// The field is a boolean
				$elem = $form->create($tableField->getData()
					->getName(), FType\CheckboxType::class, $option);
				$elem->setData($tableRowField->getValue());
				break;

			case "ARRAY":

				//
				$option['entry_type'] = FType\TextType::class;
				$option['prototype_name'] = '';
				$option['allow_add'] = true;
				$elem = $form->create($tableRowField->getId(), FType\CollectionType::class, $option);
				$elem->setData($tableRowField->getValue());
				break;

			case "GEOM":
			default:

				// Default
				$elem = $form->create($tableRowField->getId(), FType\TextType::class, $option);
				$elem->setData($tableRowField->getValue());
		}

		// $elem->setDescription($tableField->definition);

		if ($isKey) {
			$elem->setAttribute('readonly', 'readonly');
		}

		return $elem;
	}

	/**
	 * Build and return the data form.
	 *
	 * @param GenericTableFormat $data
	 *        	The descriptor of the expected data.
	 * @param String $mode
	 *        	('ADD' or 'EDIT')
	 * @return \Symfony\Component\Form\FormInterface
	 */
	protected function getEditDataForm(GenericTableFormat $data, $mode) {
		$formBuilder = $this->get('form.factory')->createNamedBuilder('edit_data_form', AjaxType::class); // use in ajax often

		// FIXME : action needed ?
		$formBuilder->setAction($this->generateUrl('dataedition_validate_edit_data', array(
			'MODE' => $mode
		)));

		$formBuilder->setAttribute('class', 'editform');

		// Dynamically build the form
		//
		// The key elements as labels
		//
		foreach ($data->getIdFields() as $tablefield) {

			$formField = $this->get('ogam.generic_service')->getTableToFormMapping($tablefield);
			if (null !== $formField) {
				$elem = $this->getFormElement($formBuilder, $tablefield, $formField->getMetadata(), true);
				$elem->setAttribute('class', 'dataedit_key');
				$formBuilder->add($elem);
			}
		}

		//
		// The editable elements as form fields
		//
		foreach ($data->getFields() as $tablefield) {

			// Hardcoded value : We don't edit the line number (it's a technical element)
			if ($tablefield->getData() !== "LINE_NUMBER") {

				$formField = $this->get('ogam.generic_service')->getTableToFormMapping($tablefield);
				if (null !== $formField) {
					$elem = $this->getFormElement($formBuilder, $tablefield, $formField->getMetadata(), false);
					$elem->setAttribute('class', 'dataedit_field');
					$formBuilder->add($elem);
				}
			}
		}

		//
		// Add the submit element
		//
		$formBuilder->add('submit', FType\SubmitType::class, array(
			'label' => 'Submit'
		));

		return $formBuilder->getForm();
	}

	/**
	 * Save the edited data in database.
	 *
	 * @return the HTML view
	 *         @Route("/ajax-validate-edit-data", name="dataedition_validate_edit_data")
	 */
	public function ajaxValidateEditDataAction(Request $request) {
		// Get the mode
		$mode = $request->request->getAlpha('MODE');

		// Get back info from the session
		$websiteSession = $request->getSession()/*->getBag('website')*/;
		$data = $websiteSession->get('data');

		// Validate the form
		$form = $this->getEditDataForm($data, $mode);

		// $form->handleRequest($request);//FIXME :$form->handleRequest don't set isSubmit === true
		// $form->submit($request->request->all(), false);
		// HotFIX
		$form->submit(null, true);
		foreach ($form->all() as $field) {
			$value = $request->request->get($form->getName(), null);
			if (null !== $value) {
				$field->submit($value);
			}
		}

		if (!$form->isSubmitted()) {
			return $this->json([
				'success' => false,
			    'errorMessage' => $this->get('translator')->trans("Form not submitted")
			]);
		}

		if (!$form->isValid()) {
			return $this->json([
				'success' => false,
				'errorMessage' => $this->get('translator')->trans("Invalid form"),
				'errors' => $form->getErrors(true, true)
			]);
		} else {

			try {
				$genericModel = $this->get('ogam.manager.generic');
				if ($mode === 'ADD') {
					// Insert the data
					$values = $form->getData();
					// join_keys values must not be erased
					$joinKeys = $genericModel->getJoinKeys($data);

					foreach ($data->all() as $field) {
						$isNotJoinKey = !in_array($field->getMetadata()->getColumnName(), $joinKeys);

						if ($isNotJoinKey) {
							// Update the data descriptor with the values submitted
							$field->setValue($request->request->get($field->getId(), null));
						}
					}

					$data = $genericModel->insertData($data);
				} else {
					// Edit the data
					$values = $form->getData();
					// Update the data descriptor with the values submitted (for editable fields only)
					foreach ($data->getFields() as $field) {
						$field->setValue($request->request->get($field->getId(), null));
					}

					$genericModel->updateData($data);
				}

				$view = [
					'success' => true
				];

				// Manage redirections

				// Check the number of children
				$children = $genericModel->getChildren($data);

				// After a creation if no more children possible
				if (count($children) === 0 && $mode === 'ADD') {
					// We redirect to the parent
					$ancestors = $genericModel->getAncestors($data);
					if (!empty($ancestors)) {
						$ancestor = $ancestors[0];
						$redirectURL = '#edition-edit/' . $ancestor->getId();
					} else {
						$redirectURL = '#edition-edit/' . $data->getId();
					}
					$view['redirectLink'] = $redirectURL;
				} else {
					// We redirect to the newly created or edited item
					$view['redirectLink'] = '#edition-edit/' . $data->getId();
				}

				// Add a message
				$view['message'] = $this->get('translator')->trans("Data saved");
				return $this->json($view);
			} catch (\Exception $e) {
				if ($this->has('logger')) {
					$this->get('logger')->error($e->getMessage());
				}

				if (stripos($e->getMessage(), 'SQLSTATE[23505]') !== false) {
					// Traitement du cas d'un doublon pour PostgreSQL
					return $this->json([
						'success' => false,
						'errorMessage' => $this->get('translator')->trans('Error inserting data duplicate key')
					]);
				} else {
					// Cas général
					return $this->json([
						'success' => false,
					    'errorMessage' => $this->get('translator')->trans("An unexpected error occurred.")
					]);
				}
			}
		}
	}

	/**
	 * Add a new data.
	 *
	 * A data here is the content of a table, or if a dataset is selected the table filtrered with the dataset elements.
	 *
	 * @param GenericTableFormat $data
	 *        	The data to display (optional)
	 * @param String $message
	 *        	A confirmation/warning message to display
	 * @return the HTML view
	 *         @Route("/show-add-data/{id}", requirements={"id"= ".*"}, name="dataedition_showAddData")
	 *         @Template(engine="php")
	 */
	public function showAddDataAction(Request $request, GenericTableFormat $data = null, $message = '') {
		$mode = 'ADD';

		// If data is set then we don't need to read from database
		if ($data === null) {
			$data = $this->getDataFromRequest($request);
		}

		// If the objet is not existing then we are in create mode instead of edit mode

		// Get the ancestors of the data objet from the database (to generate a summary)
		$ancestors = $this->get('ogam.manager.generic')->getAncestors($data);

		// Get the labels linked to the children table (to display the links)
		$childrenTableLabels = $this->get('doctrine.orm.metadata_entity_manager')
			->getRepository('OGAMBundle:Metadata\TableTree')
			->getChildrenTableLabels($data->getTableFormat());
		$response = $this->render('OGAMBundle:DataEdition:edit_data.html.php', array(
			'dataId' => $data->getId(),
			'tableFormat' => $data->getTableFormat(),
			'ancestors' => $ancestors,
			'data' => $data,
			'children' => array(), // No children in add mode
			'childrenTableLabels' => $childrenTableLabels,
			'mode' => $mode,
			'message' => $message
		));
		$session = $request->getSession();
		$session->set('data', $data);
		$session->set('ancestors', $ancestors);

		return $response;
	}

	/**
	 * AJAX function : Get the AJAX structure corresponding to the edition form.
	 *
	 * @return JSON The list of forms
	 *         @Route("/ajax-get-edit-form/{id}", requirements={"id"= ".*"}, name="dataedition_ajaxGetEditForm")
	 */
	public function ajaxGetEditFormAction(Request $request, $id = null) {
		$data = $this->getDataFromRequest($request);

		// Complete the data object with the existing values from the database.
		$genericModel = $this->get('ogam.manager.generic');
		$data = $genericModel->getDatum($data);

		// The service used to manage the query module
		$res = $this->getQueryService()->getEditForm($data, $this->getUser());

		$bag = $request->getSession();
		json_encode($data);
		$ser = new Serializer(array(
			new PropertyNormalizer(),
			new ObjectNormalizer()
		));
		$ser->normalize($data); // FIXME : treewalker force loading proxy element ...
		$bag->set('data', $data);
		return $this->json($res);
	}

	/**
	 * AJAX function : Get the AJAX structure corresponding to the add form.
	 *
	 * @return JSON The list of forms
	 *         @Route("/ajax-get-add-form/{id}", requirements={"id"= ".*"}, name="dataedition_ajaxGetAddForm")
	 */
	public function ajaxGetAddFormAction(Request $request, $id = null) {
		$data = $this->getDataFromRequest($request);

		$res = $this->getQueryService()->getEditForm($data, $this->getUser());
		$bag = $request->getSession();
		json_encode($data);
		$ser = new Serializer(array(
			new ObjectNormalizer(),
			new PropertyNormalizer()
		));
		$ser->normalize($data); // FIXME : treewalker force loading proxy element ...
		$bag->set('data', $data);
		return $this->json($res);
	}

	/**
	 * Get the parameters.
	 * @Route("/getParameters")
	 */
	public function getparametersAction() {
		$user = $this->getUser();
		return $this->render('OGAMBundle:DataEdition:edit_parameters.js.twig', array(
			'checkEditionRights' => ($user && $user->isAllowed('DATA_EDITION_OTHER_PROVIDER')) ? FALSE : TRUE,
			'userProviderId' => $user->getProvider()
				->getId()
		));
	}

	/**
	 * Upload an image and store it on the disk.
	 *
	 * @return JSON @Route("/ajaximageupload")
	 */
	public function ajaximageuploadAction() {
		return $this->json(array(
			'success' => TRUE
		));
	}

	protected function getQueryService() {
		return $this->get('ogam.query_service');
	}

	/**
	 * Returns a JsonResponse that uses the serializer component if enabled, or json_encode.
	 *
	 * @param mixed $data
	 *        	The response data
	 * @param int $status
	 *        	The status code to use for the Response
	 * @param array $headers
	 *        	Array of extra headers to add
	 * @param array $context
	 *        	Context to pass to serializer when using serializer component
	 *
	 * @return JsonResponse //import from symfony 3.1
	 */
	protected function json($data, $status = 200, $headers = array(), $context = array()) {
		if ($this->has('serializer')) {
			// symfony 3.1 proprerty
			$json = $this->get('serializer')->serialize($data, 'json', array_merge(array(
				'json_encode_options' => 15 /* JsonResponse::DEFAULT_ENCODING_OPTIONS */,//symfony 3.1 proprerty
            ), $context));
			return (new JsonResponse($json, $status, $headers, true))->setContent($json); // to prior 3.1...
		}
		return new JsonResponse($data, $status, $headers);
	}
}
