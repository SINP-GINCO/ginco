<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\RawData\Submission;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Custom Submission Controller for GINCO
 * Performs actions on submissions :
 * - Create reports
 * - Post-treatments after integration
 *
 * These actions are not restricted to logged in users,
 * as they can be called from the Java Integration service.
 *
 * @Route("/submission")
 */
class SubmissionController extends GincoController {

	/**
	 * Generate the post-integration reports
	 * and write them to files.
	 *
	 * This action is called in the Integration Service (java)
	 * No rights are checked for it in security.yml
	 *
	 * @Route("/generate-reports/{submission}", name = "generate-reports")
	 */
	public function generateReportsAction(Submission $submission, Request $request) {
		// Configure memory and time limit because the program asks a lot of resources
		ini_set("memory_limit", $this->get('ginco.configuration_manager')->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", 0);

		$this->get('logger')->debug('generateReportsAction, submission: ' . $submission->getId());
		
		// The directory where we are going to store the reports, and the filenames
		$reportsDirectory = $this->get('ginco.submission_service')->getReportsDirectory($submission);
		$filenames = $this->get('ginco.submission_service')->getReportsFilenames($submission);
		
		// Create it if not exists
		$pathExists = is_dir($reportsDirectory) || mkdir($reportsDirectory, 0755, true);
		if (!$pathExists) {
			$this->getLogger()->error("Error: could not create directory: $reportsDirectory");
			return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
				'error' => $this->get('translator')
					->trans("An unexpected error occurred.")
			));
		}
		
		// only if status=OK
		if ($submission->getStatus() == "OK") {
			// Generate sensibility report
			$this->get('ginco.submission_service')->writeSensibilityReport($submission, $filenames['sensibilityReport']);
			
			// Generate id report
			$this->get('ginco.submission_service')->writePermanentIdsReport($submission, $filenames['permanentIdsReport']);
		}
		
		return new Response();
	}

	/**
	 * Generic action to download reports
	 * Call with GET parameters:
	 * - submissionId: the id of the submission
	 * - report: type of report, ie: sensibilityReport | permanentIdsReport | integrationReport
	 *
	 * Authorized for logged users with data_integration right (see security.yml)
	 *
	 * @Route("/download-report/{submission}", name = "download-report")
	 */
	function downloadReportAction(Submission $submission, Request $request) {
		// Configure memory and time limit because the program asks a lot of resources
		ini_set("memory_limit", $this->get('ginco.configuration_manager')->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", 0);
		
		// Get the user
		$user = $this->getUser();
		
		$this->get('logger')->debug('DownloadReport, submission: ' . $submission->getId());
		
		// Check if submission exists
		if ($submission == null) {
			$this->addFlash('error', [
				'id' => 'Integration.Submission.doesNotExist.report'
			]);
			// Redirects to the jdd list page
			return $this->redirect($this->generateUrl('user_jdd_list'));
		}
		
		// Get the report name
		$report = $request->query->get("report");
		$this->get('logger')->debug("downloadReportAction: submission: {$submission->getId()}, report: $report");
		
		// Check if report is accessible
		$unstableSteps = array(
			Submission::STEP_CANCELLED,
			Submission::STATUS_RUNNING,
			Submission::STEP_INIT
		);
		
		$reportsDenied = array(
			'integrationReport' => true,
			'permanentIdsReport' => true,
			'sensibilityReport' => true
		);
		
		if (!in_array($submission->getStep(), $unstableSteps) && $user->isAllowed('DATA_INTEGRATION')) {
			$reportsDenied['integrationReport'] = false;
			if ($submission->getStatus() == Submission::STATUS_OK) {
				$reportsDenied['permanentIdsReport'] = false;
				if ($this->getUser()->isAllowed('VIEW_SENSITIVE')) {
					$reportsDenied['sensibilityReport'] = false;
				}
			}
		}
		
		if ($reportsDenied[$report] == true) {
			$this->addFlash('error', [
				'id' => 'Integration.Submission.incorrectStatusAndStep.report'
			]);
			// Redirects to the jdd list page
			return $this->redirect($this->generateUrl('user_jdd_list'));
		}
		
		// Get File Name
		$filenames = $this->get('ginco.submission_service')->getReportsFilenames($submission);
		$filePath = $filenames[$report];
		$this->get('logger')->debug("filePath: $filePath");
		
		// Regenerate sensibility report each time (see #815)
		if ($report == "sensibilityReport") {
			$this->get('ginco.submission_service')->generateReport($submission, $report);
		}
		
		// Test the existence of the file
		if (!is_file($filePath)) {
			$this->get('logger')->debug("downloadReportAction: report file $filePath does not exist, trying to generate them");
			// We try to generate the reports, and then re-test
			$this->get('ginco.submission_service')->generateReport($submission, $report);
			if (!is_file($filePath)) {
				$this->get('logger')->error("Report file '$report' does not exist for submission {$submission->getId()}");
				return $this->render('IgnGincoBundle:Integration:data_error.html.twig', array(
					'error' => $this->get('translator')
						->trans("An unexpected error occurred.")
				));
			}
		}
		
		// Get File type from its name
		$fileType = pathinfo($filePath, PATHINFO_EXTENSION); // csv or pdf
		$contentType = (strtolower($fileType) == 'csv') ? 'text/csv;charset=utf-8' : 'application/pdf';
		$prependBOM = (strtolower($fileType) == 'csv' && $this->get('ginco.configuration_manager')->getConfig('csvExportCharset', 'UTF-8') == 'UTF-8') ? chr(0xEF) . chr(0xBB) . chr(0xBF) : '';
		
		// -- Download the file
		
		$response = new Response();
		$response->headers->set('Cache-control', 'private');
		$response->headers->set('Content-transfer-encoding', 'binary');
		$response->headers->set('Content-Type', $contentType . ';application/force-download;', true);
		$response->headers->set('Content-disposition', 'attachment; filename=' . pathinfo($filePath, PATHINFO_BASENAME), true);
		$response->setContent($prependBOM . file_get_contents($filePath));
		
		return $response;
	}

	/**
	 *
	 * @Route("/view-error-report/{submission}", name = "submission_view-error-report")
	 */
	public function viewErrorReport(Submission $submission, Request $request) {
		
		if ($submission == null || !$submission->isInError()) {
			throw $this->createNotFoundException("La donnée n'existe pas");
		}
		
		$errorRepository = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\RawData\CheckError', 'raw_data');
		$errors = $errorRepository->findBySubmission($submission->getId(), array());
		$errorCounts = $errorRepository->getErrorCounts($submission);
		
		return $this->render('IgnGincoBundle:Submission:error_report.html.twig', array(
			'submission' => $submission,
			'errors' => $errors,
			'errorCounts' => $errorCounts
		));
	}
}