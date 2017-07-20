<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\HttpFoundation\JsonResponse;
use Ign\Bundle\OGAMBundle\Entity\Generic\QueryForm;

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
class SubmissionController extends Controller {

	/**
	 * Generate the post-integration reports
	 * and write them to files.
	 *
	 * This action is called in the Integration Service (java)
	 * No rights are checked for it in security.yml
	 *
	 * @Route("/generate-reports", name = "generate-reports")
	 */
	public function generateReportsAction(Request $request) {
		// Configure memory and time limit because the program asks a lot of resources
		ini_set("memory_limit", $this->get('ogam.configuration_manager')->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", 0);
		
		// Get the submission Id
		$submissionId = $request->query->getInt("submissionId");
		
		// Get the submission
		$submissionRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\RawData\Submission', 'raw_data');
		$submission = $submissionRepo->find($submissionId);
		$this->get('logger')->debug('generateReportsAction, submission: ' . $submissionId);
		
		// The directory where we are going to store the reports, and the filenames
		$reportsDirectory = $this->get('ginco.submission_service')->getReportsDirectory($submissionId);
		$filenames = $this->get('ginco.submission_service')->getReportsFilenames($submissionId);
		
		// Create it if not exists
		$pathExists = is_dir($reportsDirectory) || mkdir($reportsDirectory, 0755, true);
		if (!$pathExists) {
			$this->getLogger()->error("Error: could not create directory: $reportsDirectory");
			return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
				'error' => $this->get('translator')->trans("An unexpected error occurred.")
			));
		}
		
		// Generate Integration report (always)
		$this->get('ginco.submission_service')->writeIntegrationReport($submissionId, $filenames['integrationReport']);
		
		// only if status=OK
		if ($submission->getStatus() == "OK") {
			// Generate sensibility report
			$this->get('ginco.submission_service')->writeSensibilityReport($submissionId, $filenames['sensibilityReport']);
			
			// Generate id report
			$this->get('ginco.submission_service')->writePermanentIdsReport($submissionId, $filenames['permanentIdsReport']);
		}
		
		return new Response();
	}

	/**
	 * Generic action to download reports
	 * Call with GET parameters:
	 * - submissionId: the id of the submission
	 * - report: type of report, ie: sensibilityReport | permanentIdsReport | integrationReport
	 *
	 * Authorized for logged users with both view_sensitive and data_integration rights
	 * 
	 * @Route("/download-report", name = "download-report")
	 */
	function downloadReportAction(Request $request) {
		// Configure memory and time limit because the program asks a lot of resources
		ini_set("memory_limit", $this->get('ogam.configuration_manager')->getConfig('memory_limit', '1024M'));
		ini_set("max_execution_time", 0);
				
		// Get the submission Id
		$submissionId = $request->query->getInt("submissionId");
		
		// Get the report name
		$report = $request->query->get("report");
		$this->get('logger')->debug("downloadReportAction: submission: $submissionId, report: $report");
		
		// Get File Name
		$filenames = $this->get('ginco.submission_service')->getReportsFilenames($submissionId);
		$filePath = $filenames[$report];
		$this->get('logger')->debug("filePath: $filePath");
		
		// Regenerate sensibility report each time (see #815)
		if ($report == "sensibilityReport") {
			$this->get('ginco.submission_service')->generateReport($submissionId, $report);
		}
		
		// Test the existence of the file
		if (!is_file($filePath)) {
			$this->get('logger')->debug("downloadReportAction: sensibility report file $filePath does not exist, trying to generate them");
			// We try to generate the reports, and then re-test
			$this->get('ginco.submission_service')->generateReport($submissionId, $report);
			if (!is_file($filePath)) {
				$this->getLogger()->error("Report file '$report' does not exist for submission $submissionId");
				return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
					'error' => $this->get('translator')->trans("An unexpected error occurred.")
				));
			}
		}
		
		// Get File type from its name
		$fileType = pathinfo($filePath, PATHINFO_EXTENSION); // csv or pdf
		$contentType = (strtolower($fileType) == 'csv') ? 'text/csv;charset=utf-8' : 'application/pdf';
		
		// -- Download the file
		
		// Define the header of the response
		$response = new Response();
		$response->headers->set('Cache-control', 'private');
		$response->headers->set('Content-transfer-encoding', 'binary');
		$response->headers->set('Content-Type', $contentType . ';application/force-download;', true);
		$response->headers->set('Content-disposition', 'attachment; filename=' . pathinfo($filePath, PATHINFO_BASENAME), true);
		
		if (strtolower($fileType) == 'csv') {
			// Prepend the Byte Order Mask to inform Excel that the file is in UTF-8
			if ($this->get('ogam.configuration_manager')->getConfig('csvExportCharset', 'UTF-8') == 'UTF-8') {
				echo (chr(0xEF));
				echo (chr(0xBB));
				echo (chr(0xBF));
			}
			
			$file = fopen($filePath, "rb");
			while (!feof($file)) {
				print(@fread($file, 1024 * 8));
			}
			fclose($file);
		} else {
			$response->setContent(file_get_contents($filePath));
		}
		
		return $response;
	}
}