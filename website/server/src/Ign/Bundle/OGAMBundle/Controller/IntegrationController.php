<?php
namespace Ign\Bundle\OGAMBundle\Controller;

use Doctrine\ORM\EntityManager;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset;
use Ign\Bundle\OGAMBundle\Entity\RawData\SubmissionFile;
use Ign\Bundle\OGAMBundle\Entity\RawData\Submission;
use Ign\Bundle\OGAMBundle\OGAMBundle;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\FormType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Constraints\File;
use Symfony\Component\HttpFoundation\JsonResponse;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FileFormat;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;
use Symfony\Component\HttpFoundation\StreamedResponse;
use Ign\Bundle\OGAMBundle\Form\DataSubmissionType;
use Symfony\Component\Validator\Constraints\Type;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Ign\Bundle\OGAMBundle\Form\UploadDataType;

/**
 * @Route("/integration")
 */
class IntegrationController extends GincoController {

	/**
	 * get the underline entity manager related with
	 *
	 * @return EntityManager
	 */
	function getEntityManger() {
		return $this->get('doctrine.orm.raw_data_entity_manager');
	}

	function getLogger() {
		return $this->get('logger');
	}

	/**
	 * Default action.
	 *
	 * @Route("/", name = "integration_home")
	 */
	public function indexAction() {
		// Redirects to the jdd list page
		return $this->redirect($this->generateUrl('jdd_list'));
	}

	/**
	 * Show the data submission page.
	 *
	 * @Route("/show-data-submission-page", name="integration_list")
	 */
	public function showDataSubmissionPageAction() {
		$submissions = $this->getEntityManger()
			->getRepository('OGAMBundle:RawData\Submission')
			->getActiveSubmissions();

		return $this->render('OGAMBundle:Integration:show_data_submission_page.html.twig', array(
			'submissions' => $submissions
		));
	}

	/**
	 * Show the create data submission page.
	 *
	 * @Route("/create-data-submission", name="integration_creation")
	 */
	public function createDataSubmissionAction(Request $request) {

		// Get the referer url, and put it in session to redirect to it at the end of the process
		$refererUrl = $request->headers->get('referer');
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		$session = $request->getSession();
		if (!$session->has('redirectToUrl'))
			$session->set('redirectToUrl', $redirectUrl);

		$em = $this->get('doctrine.orm.entity_manager');

		// Find jddid if given in GET parameters
		$jddId = intval($request->query->get('jddid', 0));
		$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);

		// If the model of the jdd has no published datasets, add a flash error message
		// And disable the whole form
		$formDisabled = false;
		if ($jdd != null && $jdd->getModel()
			->getImportDatasets()
			->count() == 0) {
			$this->addFlash('error', 'Warning! No dataset for chosen data model. Please contact the administrator.');
			$formDisabled = true;
		}

		$submission = new Submission();
		$form = $this->createForm(new DataSubmissionType(), $submission, array(
			'jdd' => $jdd,
			'disabled' => $formDisabled
		));

		$form->handleRequest($request);

		if ($form->isSubmitted() && $form->isValid()) {

			// Add user and provider relationship
			$submission->setUser($this->getUser());
			$submission->setProvider($this->getUser()
				->getProvider());

			// Add jdd relationship
			// And update jdd "dataUpdatedAt"
			if ($form->has('jddid')) {
				$jddId = $form->get('jddid')->getData();
				$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);
				$submission->setJdd($jdd);
				$jdd->setDataUpdatedAt(new \DateTime());
				$em->merge($jdd);
			}

			// writes the submission to the database
			// merge because cascade persist is not set in the entity
			// and get the merged object to access auto-generated id
			$attachedSubmission = $em->merge($submission);
			$em->flush();

			// Redirects to page 2 of the form: upload data
			return $this->redirect($this->generateUrl('integration_upload_data', array(
				'id' => $attachedSubmission->getId()
			)));
		}

		return $this->render('OGAMBundle:Integration:show_create_data_submission.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Show the upload data page.
	 *
	 * @Route("/show-upload-data/{id}", name="integration_upload_data")
	 */
	public function showUploadDataAction(Request $request, Submission $submission) {
		$configuration = $this->get('ogam.configuration_manager');
		$fileMaxSize = intval($this->get('ogam.configuration_manager')->getConfig('fileMaxSize', '40'));
		$showDetail = $configuration->getConfig('showUploadFileDetail', true) == 1;
		$showModel = $configuration->getConfig('showUploadFileModel', true) == 1;
		$dataset = $submission->getDataset();
		$this->get('logger')->debug('$showDetail : ' . $showDetail);
		$this->get('logger')->debug('$showModel : ' . $showModel);

		$geomFieldInFile = false;

		$requestedFiles = $submission->getDataset()->getFiles();
		foreach ($requestedFiles as $requestedFile) {
			// Checks if geom unit field is present in the file
			if (!$geomFieldInFile) {
				$fields = $this->getDoctrine()
					->getRepository('OGAMBundle:Metadata\FileField')
					->getFileFields($requestedFile->getFormat());
				foreach ($fields as $field) {
					$unit = $this->getDoctrine()
						->getRepository('OGAMBundle:Metadata\Unit')
						->getUnitFromFileField($field);
					$geomFieldInFile = $geomFieldInFile || $unit[0]['type'] == 'GEOM';
				}
			}
		}
		$locale = $this->get('ogam.locale_listener')->getLocale();
		$submissionFiles = $this->getDoctrine()
			->getRepository(FileFormat::class)
			->getFileFormats($dataset->getId(), $locale);

		$files = [];

		foreach ($submissionFiles as $file) {
			$files[$file->getFormat()] = $file;
		}
		$optionsForm['submission'] = $submission;
		$optionsForm['geomFieldInFile'] = $geomFieldInFile;
		$optionsForm['fileMaxSize'] = $fileMaxSize;
		$form = $this->createForm(UploadDataType::class, $optionsForm);
		$form->handleRequest($request);

		if ($form->isValid() && $form->isSubmitted()) {
			// Get the configuration info
			$uploadDir = $configuration->getConfig('uploadDir', '/var/www/html/upload');
			$srid = '';
			if($form->has('SRID')){
				$srid = $form->get('SRID')->getData();
			}

			// For each requested file

			$requestedFiles = $submission->getDataset()->getFiles();
			foreach ($requestedFiles as $key => $requestedFile) {
				$file = $form[$requestedFile->getFormat()]->getData();
				// Get the uploaded filename

				$filename = $file->getClientOriginalName();

				// Print it only if it is not an array (ie: nothing has been selected by the user)
				if (!is_array($filename)) {
					$this->getLogger()->debug('uploaded filename ' . $filename);
				}

				// Check that the file is present
				if (empty($file) || !$file->isValid()) {
					$this->getLogger()->debug('File ' . $requestedFile->format . ' is missing, skipping');
					unset($requestedFiles[$key]);
				} else {
					// Move the file to the upload directory on the php server
					$targetPath = $uploadDir . DIRECTORY_SEPARATOR . $submission->getId() . DIRECTORY_SEPARATOR . $requestedFile->getFileType();
					$targetName = $targetPath . DIRECTORY_SEPARATOR . $filename;
					@mkdir($uploadDir . DIRECTORY_SEPARATOR . $submission->getId()); // create the submission dir
					@mkdir($targetPath);
					$file->move($targetPath, $filename);
					$this->getLogger()->debug('renamed to ' . $targetName);
					$requestedFile->filePath = $targetName; // TODO : clean this fake filePath property
				}
			}
			try {
				$providerId = $submission->getProvider()->getId();
				$this->get('ogam.integration_service')->uploadData($submission->getId(), $providerId, $requestedFiles, $srid);
			} catch (\Exception $e) {
				$this->get('logger')->error('Error during upload:' . $e, array(
					'exception' => $e
				));
				return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
					'error' => $e->getMessage()
				));
			}

			// Returns to the page where the action comes from in the first place
			// (get it from session)
			$session = $request->getSession();
			$redirectUrl = $session->get('redirectToUrl', $this->generateUrl('integration_home'));
			$session->remove('redirectToUrl');
			return $this->redirect($redirectUrl);
		}
		return $this->render('OGAMBundle:Integration:show_upload_data.html.twig', array(
			'dataset' => $dataset,
			'form' => $form->createView(),
			'files' => $files,
			'showModel' => $showModel,
			'showDetail' => $showDetail,
			'geomFieldInFile' => $geomFieldInFile
		));
	}

	/**
	 * @Route("/cancel-data-submission", name="integration_cancel")
	 */
	public function cancelDataSubmissionAction(Request $request) {
		$this->get('logger')->debug('cancelDataSubmissionAction');
		// Desactivate the timeout
		set_time_limit(0);

		// Get the submission Id
		$submissionId = $request->get("submissionId");

		// Send the cancel request to the integration server
		try {
			$this->get('ogam.integration_service')->cancelDataSubmission($submissionId);
		} catch (\Exception $e) {
			$this->get('logger')->error('Error during upload: ' . $e);

			return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
				'error' => $this->get('translator')
					->trans("An unexpected error occurred.")
			));
		}

		// Update "DataUpdatedAt" field for jdd
		$em = $this->get('doctrine.orm.entity_manager');
		$submission = $em->getRepository('OGAMBundle:RawData\Submission')->findOneById($submissionId);
		$jdd = $submission->getJdd();
		if ($jdd) {
			$jdd->setDataUpdatedAt(new \DateTime());
			$em->merge($jdd);
			$em->flush();
		}

		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		return $this->redirect($redirectUrl);
	}

	/**
	 * @Route("/check-submission", name="integration_check")
	 */
	public function checkSubmissionAction(Request $request) {
		$this->getLogger()->debug('checkSubmissionAction');

		// Get the submission Id
		$submissionId = $request->get("submissionId");

		// Send the cancel request to the integration server
		try {
			$this->get('ogam.integration_service')->checkDataSubmission($submissionId);
		} catch (\Exception $e) {
			$this->getLogger()->error('Error during upload: ' . $e);

			return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
				'error' => $this->get('translator')
					->trans("An unexpected error occurred.")
			));
		}
		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		return $this->redirect($redirectUrl);
	}

	/**
	 * Validate the data.
	 * @Route("/validate-data",name="integration_validate")
	 *
	 * @return Response
	 */
	public function validateDataAction(Request $request) {
		$this->getLogger()->debug('validateDataAction');

		// Get the submission Id
		$submissionId = $request->get("submissionId");

		// Send the cancel request to the integration server
		try {
			$this->get('ogam.integration_service')->validateDataSubmission($submissionId);
		} catch (\Exception $e) {
			$this->getLogger()->error('Error during upload: ' . $e);

			return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
				'error' => $this->get('translator')
					->trans("An unexpected error occurred.")
			));
		}

		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		return $this->redirect($redirectUrl);
	}

	/**
	 * Invalidate the data.
	 * @Route("/invalidate-data",name="integration_invalidate")
	 *
	 * @return Response
	 */
	public function invalidateDataAction(Request $request) {
		$this->getLogger()->debug('invalidateDataAction');

		// Get the submission Id
		$submissionId = $request->get("submissionId");

		// Send the cancel request to the integration server
		try {
			$this->get('ogam.integration_service')->invalidateDataSubmission($submissionId);
		} catch (Exception $e) {
			$this->getLogger()->error('Error during unvalidation: ' . $e);

			return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
				'error' => $e->getMessage()
			));
		}

		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		return $this->redirect($redirectUrl);
	}

	/**
	 * Gets the integration status.
	 *
	 * @param String $servletName
	 *        	the name of the servlet
	 * @return JSON the status of the process
	 */
	protected function getStatus($servletName) {
		$this->getLogger()->debug('getStatusAction');

		// Send the cancel request to the integration server
		try {
			$submissionId = $this->get('request_stack')
				->getCurrentRequest()
				->get("submissionId");

			$status = $this->get('ogam.integration_service')->getStatus($submissionId, $servletName);
			$data = array(
				'success' => TRUE,
				'status' => $status->status
			);
			// Echo the result as a JSON
			if ($status->status === "OK") {
				return $this->json($data);
			} else {
				$data['taskName'] = $status->taskName;
				if ($status->currentCount != null) {
					$data["currentCount"] = $status->currentCount;
				}
				if ($status->totalCount != null) {
					$data['totalCount'] = $status->totalCount;
				}
				return $this->json($data);
			}
		} catch (\Exception $e) {
			$this->getLogger()->error('Error during get: ' . $e);

			return $this->json(array(
				'success' => FALSE,
				"errorMessage" => $this->get('translator')
					->trans("An unexpected error occurred.")
			));
		}
	}

	/**
	 * Gets the data integration status.
	 * @Route("/get-data-status", name="integration_status")
	 */
	public function getDataStatusAction() {
		return $this->getStatus('DataServlet');
	}

	/**
	 * Gets the check status.
	 * @Route("/check-data-status", name="integration_checkstatus")
	 */
	public function getCheckStatusAction() {
		return $this->getStatus('CheckServlet');
	}

	/**
	 * Generate a CSV file, model for import files,
	 * with as first line (commented), the names of the expected fields, with mandatory fields (*) and date formats.
	 * Param : file format
	 *
	 * @Route("/export-file-model", name="integration_exportfilemodel")
	 */
	public function exportFileModelAction(Request $request) {
		// TODO : add a permission for this action ?

		// -- Get the file
		$fileFormatName = $request->query->get("fileFormat");
		$locale = $this->get('ogam.locale_listener')->getLocale();
		$fileFormat = $this->getDoctrine()
			->getRepository(FileFormat::class)
			->getFileFormat($fileFormatName, $locale);

		// -- Get file infos and fields - ordered by position
		$fieldNames = array();
		$fieldInfos = array();

		$fields = $fileFormat->getFields();
		foreach ($fields as $field) {
			$fieldNames[] = $field->getLabelCSV();
			$fieldInfos[] = (!empty($field->getMask()) ? ' (' . $field->getMask() . ') ' : '') . (($field->getIsMandatory() == 1) ? '*' : '');
		}
		// -- Comment this line
		$fieldInfos[0] = '// ' . $fieldInfos[0];

		// -- Export results to a CSV file

		$configuration = $this->get('ogam.configuration_manager');
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');

		$response = new StreamedResponse();

		// Define the header of the response
		$fileName = 'CSV_Model_' . $fileFormat->getLabel() . '_' . date('dmy_Hi') . '.csv';
		$disposition = sprintf('%s; filename="%s"', ResponseHeaderBag::DISPOSITION_ATTACHMENT, str_replace('"', '\\"', $fileName));
		$disposition .= sprintf("; filename*=utf-8''%s", rawurlencode($fileName));

		$response->headers->set('Content-Disposition', $disposition);
		$response->headers->set('Content-Type', 'text/csv;charset=' . $charset . ';application/force-download;');

		$response->setCallback(function () use ($charset, $fieldNames, $fieldInfos) {
			// Prepend the Byte Order Mask to inform Excel that the file is in UTF-8
			if ($charset == 'UTF-8') {
				echo (chr(0xEF));
				echo (chr(0xBB));
				echo (chr(0xBF));
			}

			// Opens the standard output as a file flux
			$out = fopen('php://output', 'w');
			fputcsv($out, $fieldNames, ';');
			fputcsv($out, $fieldInfos, ';');
			fclose($out);
		});

		return $response->send();
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
		/*
		 * cannot set jsoncontent on v2.8 only object..
		 * if ($this->has('serializer')) {
		 * $json = $this->get('serializer')->serialize($data, 'json', array_merge(array(
		 * 'json_encode_options' => JsonResponse::DEFAULT_ENCODING_OPTIONS,
		 * ), $context));
		 * return new JsonResponse($json, $status, $headers, true);
		 * }
		 */
		return new JsonResponse($data, $status, $headers);
	}
}
