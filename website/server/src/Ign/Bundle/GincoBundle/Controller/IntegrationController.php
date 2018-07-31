<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Doctrine\ORM\EntityManager;
use Ign\Bundle\GincoBundle\Form\GincoDataSubmissionType;
use Ign\Bundle\GincoBundle\Form\UploadDataShapeType;
use Ign\Bundle\GincoBundle\Entity\Metadata\Dataset;
use Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat;
use Ign\Bundle\GincoBundle\Entity\RawData\Submission;
use Ign\Bundle\GincoBundle\Entity\RawData\SubmissionFile;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Form\DataSubmissionType;
use Ign\Bundle\GincoBundle\Form\UploadDataType;
use Ign\Bundle\GincoBundle\GincoBundle;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\FormType;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;
use Symfony\Component\HttpFoundation\StreamedResponse;
use Symfony\Component\Validator\Constraints\File;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Validator\Constraints\Type;

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
		return $this->redirect($this->generateUrl('user_jdd_list'));
	}

	/**
	 * Show the create data submission page.
	 *
	 * @Route("/create-data-submission", name="integration_creation")
	 */
	public function createDataSubmissionAction(Request $request) {
		
		// Get the referer url, and put it in session to redirect to it at the end of the process
		$refererUrl = $request->headers->get('referer');
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('user_jdd_list');
		$session = $request->getSession();
		if (!$session->has('redirectToUrl'))
			$session->set('redirectToUrl', $redirectUrl);
		
		$em = $this->get('doctrine.orm.entity_manager');
		
		// Find jddid if given in GET parameters
		$jddId = intval($request->query->get('jddid', 0));
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneById($jddId);
		
		// If the model of the jdd has no published datasets, add a flash error message
		// And disable the whole form
		$formDisabled = false;
		if ($jdd != null && $jdd->getModel()
			->getImportDatasets()
			->count() == 0) {
			$this->addFlash('error', 'Integration.Submission.noDatasetsForModel');
			$formDisabled = true;
		}
		$submission = new Submission();
		$form = $this->createForm(new GincoDataSubmissionType(), $submission, array(
			'jdd' => $jdd,
			'default_provider' => $this->getUser()
				->getProvider(),
			'disabled' => $formDisabled
		));
		
		$form->handleRequest($request);
		
		if ($form->isSubmitted() && $form->isValid()) {
			// Add user relationship
			$submission->setUser($this->getUser());
			
			// Add jdd relationship
			// And update jdd "dataUpdatedAt"
			if ($form->has('jddid')) {
				$jddId = $form->get('jddid')->getData();
				$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findOneById($jddId);
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
		
		return $this->render('IgnGincoBundle:Integration:show_create_data_submission.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Show the upload data page.
	 *
	 * @Route("/show-upload-data/{id}", name="integration_upload_data")
	 */
	public function showUploadDataAction(Request $request, Submission $submission) {
		$configuration = $this->get('ginco.configuration_manager');
		$fileMaxSize = intval($this->get('ginco.configuration_manager')->getConfig('fileMaxSize', '40'));
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
					->getRepository('IgnGincoBundle:Metadata\FileField')
					->getFileFields($requestedFile->getFormat());
				foreach ($fields as $field) {
					$unit = $this->getDoctrine()
						->getRepository('IgnGincoBundle:Metadata\Unit')
						->getUnitFromFileField($field);
					$geomFieldInFile = $geomFieldInFile || $unit[0]['type'] == 'GEOM';
				}
			}
		}
		$locale = $this->get('ginco.locale_listener')->getLocale();
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
			if ($form->has('SRID')) {
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
				$this->get('ginco.integration_service')->uploadData($submission->getId(), $providerId, $requestedFiles, $srid);
			} catch (\Exception $e) {
				$this->get('logger')->error('Error during upload:' . $e, array(
					'exception' => $e
				));
				return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
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
		return $this->render('IgnGincoBundle:Integration:show_upload_data.html.twig', array(
			'id' => $submission->getId(),
			'dataset' => $dataset,
			'form' => $form->createView(),
			'files' => $files,
			'showModel' => $showModel,
			'showDetail' => $showDetail,
			'geomFieldInFile' => $geomFieldInFile
		));
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
			$this->get('ginco.integration_service')->checkDataSubmission($submissionId);
		} catch (\Exception $e) {
			$this->getLogger()->error('Error during upload: ' . $e);
			
			return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
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
	 * Validate the data and send a notification mail to the connected user
	 *
	 * @Route("/validate-data",name="integration_validate")
	 *
	 * @return Response
	 */
	public function validateDataAction(Request $request) {
		$this->getLogger()->debug('validateDataAction');
		
		// Get the submission Id
		$submissionId = $request->get("submissionId");
		
		$em = $this->get('doctrine.orm.entity_manager');
		$submission = $em->getRepository('IgnGincoBundle:RawData\Submission')->findOneById($submissionId);
		
		// Check if submission exists
		if ($submission == null) {
			$this->addFlash('error', [
				'id' => 'Integration.Submission.doesNotExist.publish'
			]);
			// Redirects to the jdd list page
			return $this->redirect($this->generateUrl('user_jdd_list'));
		}
		
		if ($submission->isValidable()) {
			
			// Send the validation request to the integration server
			try {
				$this->get('ginco.integration_service')->validateDataSubmission($submissionId);
			} catch (\Exception $e) {
				$this->getLogger()->error('Error during upload: ' . $e);
				
				return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
					'error' => $this->get('translator')
						->trans("An unexpected error occurred.")
				));
			}
			// Get the JDD Metadata Id
			$jddMetadataId = $submission->getJdd()->getField('metadataId');
			
			// -- Send the email
			$siteName = $this->get('ginco.configuration_manager')->getConfig('site_name');
			
			// Files of the submission
			$submissionFiles = $submission->getFiles();
			$fileNames = array();
			foreach ($submissionFiles as $submissionFile) {
				$fileName = basename($submissionFile->getFileName());
				$fileNames[] = $fileName;
			}
			
			// Get recipient, the connected user.
			$user = $this->getUser();
			
			// Title and body:
			// $title = (count($fileNames) > 1) ? "Intégration des fichiers " : "Intégration du fichier ";
			// $title .= implode($fileNames, ", ");
			
			// -- Attachments
			$reports = $this->get('ginco.submission_service')->getReportsFilenames($submissionId);
			$attachements = array();
			
			// (Re)Generate sensibility report each time (see #815)
			$this->get('ginco.submission_service')->generateReport($submissionId, "sensibilityReport");
			
			// (Re)Generate permanentIdsReport report
			$this->get('ginco.submission_service')->generateReport($submissionId, "permanentIdsReport");
			
			foreach ($reports as $report => $reportPath) {
				if ($report != 'integrationReport') {
					if (!is_file($reportPath)) {
						$this->getLogger()->error("Report file '$report' does not exist for submission $submissionId");
						return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
							'error' => $this->get('translator')
								->trans("An unexpected error occurred.")
						));
					}
					$attachements[] = $reportPath;
				}
			}
			
			$this->get('app.mail_manager')->sendEmail('IgnGincoBundle:Emails:publication-notification-to-user.html.twig', array(
				'metadata_uuid' => $jddMetadataId,
				'user' => $user,
				'region' => $siteName,
				'filename' => implode($fileNames, ", "),
				'file_number' => count($fileNames)
			), $user->getEmail(), $attachements);
			
			// Get the referer url
			$refererUrl = $request->headers->get('referer');
			// returns to the page where the action comes from
			$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
			return $this->redirect($redirectUrl);
		} else {
			$this->addFlash('error', [
				'id' => 'Integration.Submission.incorrectStatusAndStep.publish'
			]);
			// Redirects to the jdd list page
			return $this->redirect($this->generateUrl('user_jdd_list'));
		}
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
		
		$em = $this->get('doctrine.orm.entity_manager');
		$submission = $em->getRepository('IgnGincoBundle:RawData\Submission')->findOneById($submissionId);
		
		// Check if submission exists
		if ($submission == null) {
			$this->addFlash('error', [
				'id' => 'Integration.Submission.doesNotExist.unpublish'
			]);
			// Redirects to the jdd list page
			return $this->redirect($this->generateUrl('user_jdd_list'));
		}
		
		
		if ($submission->isInvalidable()) {
			// Send the cancel request to the integration server
			try {
				$this->get('ginco.integration_service')->invalidateDataSubmission($submissionId);
			} catch (Exception $e) {
				$this->getLogger()->error('Error during unvalidation: ' . $e);
				
				return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
					'error' => $e->getMessage()
				));
			}
			
			// Get the referer url
			$refererUrl = $request->headers->get('referer');
			// returns to the page where the action comes from
			$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
			return $this->redirect($redirectUrl);
		} else {
			$this->addFlash('error', [
				'id' => 'Integration.Submission.incorrectStatusAndStep.unpublish'
			]);
			// Redirects to the jdd list page
			return $this->redirect($this->generateUrl('user_jdd_list'));
		}
	}
	
	/**
	 * Publie (partiellement ou complètement un jeu de données).
	 * Supprime les soumissions en erreur.
	 * 
	 * @Route("/validate-jdd/{jdd}", name="integration_validate_jdd")
	 */
	public function validateJddAction(Jdd $jdd) {
		
		/* @var $user \Ign\Bundle\GincoBundle\Entity\Website\User */
		$user = $this->getUser() ;
		$userJdd = $jdd->getUser() ;
		
		if (!$this->isGranted('VALIDATE_JDD', $jdd)) {
			$this->addFlash('error', ['id' => 'Integration.Jdd.error.notAllowed']) ;
			return $this->redirectToRoute('user_jdd_list') ;
		}
		
		if (!$jdd->isActive()) {
			$this->addFlash('error', ['id' => 'Integration.Jdd.error.deleted']) ;
			return $this->redirectToRoute('user_jdd_list') ;
		}
		
		$jddService = $this->get('ginco.jdd_service') ;
		try {
			$jddService->validateJdd($jdd) ;
		} catch (Exception $ex) {
			$this->getLogger()->error('Error during jdd validation: ' . $e);
				
			return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
				'error' => $e->getMessage()
			));
		}
		
		return $this->redirectToRoute('user_jdd_list') ;
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
			
			$status = $this->get('ginco.integration_service')->getStatus($submissionId, $servletName);
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
		$locale = $this->get('ginco.locale_listener')->getLocale();
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
		$fieldInfos[0] = '//' . $fieldInfos[0];
		
		// -- Export results to a CSV file
		
		$configuration = $this->get('ginco.configuration_manager');
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');
		
		$response = new StreamedResponse();
		
		// Define the header of the response
		$fileName = 'CSV_Model_' . $fileFormat->getLabel() . '_' . date('dmy_Hi') . '.csv';
		$disposition = sprintf('%s; filename="%s"', ResponseHeaderBag::DISPOSITION_ATTACHMENT, str_replace('"', '\\"', $fileName));
		$disposition .= sprintf("; filename*=utf-8''%s", rawurlencode($fileName));
		
		$response->headers->set('Content-Disposition', $disposition);
		$response->headers->set('Content-Type', 'text/csv;charset=' . $charset . ';application/force-download;');
		
		$response->setCallback(function () use($charset, $fieldNames, $fieldInfos) {
			// Opens the standard output as a file flux
			$out = fopen('php://output', 'w');
			
			// add BOM to fix UTF-8 in Excel
			// Removed -> With UTF-8 BOM, column names are not recognized
			// fputs($out, $bom = (chr(0xEF) . chr(0xBB) . chr(0xBF)));
			
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

	/**
	 * @Route("/cancel-data-submission", name="integration_cancel")
	 */
	public function cancelDataSubmissionAction(Request $request) {
		$this->get('logger')->debug('cancelDataSubmissionAction');
		// Desactivate the timeout
		set_time_limit(0);
		
		// Get the submission Id
		$submissionId = $request->get("submissionId");
		
		$em = $this->get('doctrine.orm.entity_manager');
		$submission = $em->getRepository('IgnGincoBundle:RawData\Submission')->findOneById($submissionId);
		
		// Check if submission exists
		if ($submission == null) {
			$this->addFlash('error', [
				'id' => 'Integration.Submission.doesNotExist.delete'
			]);
			// Redirects to the jdd list page
			return $this->redirect($this->generateUrl('user_jdd_list'));
		}
		
		// Check if submission is validable
		$user = $this->getUser();
		$notValidateCancel = $submission->getStep() != Submission::STEP_VALIDATED && $submission->getStep() != Submission::STEP_CANCELLED;
		$allowedOwnCancel = $user->isAllowed('CANCEL_VALIDATED_SUBMISSION') && $submission->getProvider()->getId() == $user->getProvider()->getId();
		$allowedOtherCancel = $user->isAllowed('CANCEL_OTHER_PROVIDER_SUBMISSION');
		
		if ($notValidateCancel && ($allowedOwnCancel || $allowedOtherCancel)) {
			
			// Send the cancel request to the integration server
			try {
				$this->get('ginco.integration_service')->cancelDataSubmission($submissionId);
			} catch (\Exception $e) {
				$this->get('logger')->error('Error during upload: ' . $e);
				
				return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
					'error' => $this->get('translator')
						->trans("An unexpected error occurred.")
				));
			}
			
			// Update "DataUpdatedAt" field for jdd
			$em = $this->get('doctrine.orm.entity_manager');
			$submission = $em->getRepository('IgnGincoBundle:RawData\Submission')->findOneById($submissionId);
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
		} else {
			$this->addFlash('error', [
				'id' => 'Integration.Submission.incorrectStatusAndStep.delete'
			]);
			// Redirects to the jdd list page
			return $this->redirect($this->generateUrl('user_jdd_list'));
		}
	}

	/**
	 * Import shapefile
	 *
	 * @Route("/import-shapefile/{id}", name="import_shapefile")
	 */
	public function importShapefileAction(Request $request, Submission $submission) {
		$this->get('logger')->debug('importShapefileAction');
		
		$configuration = $this->get('ginco.configuration_manager');
		$fileMaxSize = intval($this->get('ginco.configuration_manager')->getConfig('fileMaxSize', '40'));
		$showModel = $configuration->getConfig('showUploadFileModel', true) == 1;
		$dataset = $submission->getDataset();
		
		$geomFieldInFile = true;
		
		$locale = $this->get('ginco.locale_listener')->getLocale();
		$submissionFiles = $this->getDoctrine()
			->getRepository(FileFormat::class)
			->getFileFormats($dataset->getId(), $locale);
		
		$files = [];
		
		foreach ($submissionFiles as $file) {
			$files[$file->getFormat()] = $file;
		}

		$optionsForm['submission'] = $submission;
		$optionsForm['fileMaxSize'] = $fileMaxSize;
		$form = $this->createForm(UploadDataShapeType::class, $optionsForm);
		$form->handleRequest($request);
		
		if ($form->isValid() && $form->isSubmitted()) {
			// Get the configuration info
			$uploadDir = $configuration->getConfig('uploadDir', '/var/www/html/upload');
			
			// For each requested file
			$requestedFiles = $submission->getDataset()->getFiles();
			foreach ($requestedFiles as $key => $requestedFile) {
				$file = $form[$requestedFile->getFormat()]->getData();
				// Get the uploaded filename
				
				$filename = $file->getClientOriginalName();
				
				// Custom validator to check uploaded file extension
				if (substr($filename, -4) != '.zip') {
					// We add an error to the form
					$errorMessage = $this->get('translator')->trans('import.format.shp.extension');
					$form->get($requestedFile->getFormat())
						->addError(new FormError($errorMessage));
					
					// And print the form again with an error
					return $this->render('IgnGincoBundle:Integration:import_shapefile.html.twig', array(
						'id' => $submission->getId(),
						'dataset' => $dataset,
						'form' => $form->createView(),
						'files' => $files,
						'showModel' => $showModel
					));
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
					
					// Extract shapefile files from zip archive
					$zip = new \ZipArchive();
					if ($zip->open($targetPath . '/' . $filename) === TRUE) {
						$zip->extractTo($targetPath);
						$zip->close();
					}
					
					// Custom validator to check shapefile files names and extensions in zip archive
					$pathWithoutExtension = substr($targetPath . '/' . $filename, 0, -3);
					if (!file_exists($pathWithoutExtension . 'shp') || !file_exists($pathWithoutExtension . 'dbf') || !file_exists($pathWithoutExtension . 'shx') || !file_exists($pathWithoutExtension . 'prj')) {
						// We add an error to the form
						$errorMessage = $this->get('translator')->trans('import.format.shp.files');
						$form->get($requestedFile->getFormat())
							->addError(new FormError($errorMessage));
						
						// And print the form again with an error
						return $this->render('IgnGincoBundle:Integration:import_shapefile.html.twig', array(
							'id' => $submission->getId(),
							'dataset' => $dataset,
							'form' => $form->createView(),
							'files' => $files,
							'showModel' => $showModel
						));
					}
					
					// Transform the upload file in CSV with GDAL (ogr2ogr)
					$inputPath = preg_replace('"\.zip$"', '.shp', $targetPath . '/' . $filename);
					$outputPath = preg_replace('"\.zip$"', '.csv', $targetPath . '/' . $filename);
					$this->get('ginco.ogr2ogr')->shp2csv('"' . $inputPath . '"', '"' . $outputPath . '"');
					
					$requestedFile->filePath = $outputPath; // TODO : clean this fake filePath property
				}
			}
			try {
				$providerId = $submission->getProvider()->getId();
				$srid = '4326';
				$extension = ".zip";
				$this->get('ginco.integration_service')->uploadData($submission->getId(), $providerId, $requestedFiles, $srid, $extension);
			} catch (\Exception $e) {
				$this->get('logger')->error('Error during upload:' . $e, array(
					'exception' => $e
				));
				return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
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
		
		return $this->render('IgnGincoBundle:Integration:import_shapefile.html.twig', array(
			'id' => $submission->getId(),
			'dataset' => $dataset,
			'form' => $form->createView(),
			'files' => $files,
			'showModel' => $showModel
		));
	}
}
