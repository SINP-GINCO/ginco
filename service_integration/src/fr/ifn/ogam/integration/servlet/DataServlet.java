/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 * 
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices. 
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents. 
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */
package fr.ifn.ogam.integration.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;

import fr.ifn.ogam.common.business.AbstractThread;
import fr.ifn.ogam.common.business.ThreadLock;
import fr.ifn.ogam.common.business.submissions.SubmissionStatus;
import fr.ifn.ogam.common.database.website.ApplicationParametersDAO;
import fr.ifn.ogam.common.servlet.AbstractUploadServlet;
import fr.ifn.ogam.integration.business.IntegrationEventListener;
import fr.ifn.ogam.integration.business.IntegrationEventNotifier;
import fr.ifn.ogam.integration.business.submissions.datasubmission.DataService;
import fr.ifn.ogam.integration.business.submissions.datasubmission.DataServiceCancelThread;
import fr.ifn.ogam.integration.business.submissions.datasubmission.DataServiceThread;
import fr.ifn.ogam.integration.database.metadata.EventListenerDAO;
import fr.ifn.ogam.integration.database.metadata.EventListenerData;

/**
 * Data Servlet.
 */
public class DataServlet extends AbstractUploadServlet {

	/**
	 * The serial version ID used to identify the object.
	 */
	protected static final long serialVersionUID = -123484792196121244L;

	/**
	 * The business object related to plot locations.
	 */
	private transient DataService dataService = new DataService();

	/**
	 * Input parameters.
	 */
	private static final String ACTION = "action";
	private static final String ACTION_NEW_DATA_SUBMISSION = "NewDataSubmission";
	private static final String ACTION_UPLOAD_DATA = "UploadData";
	private static final String ACTION_CANCEL_DATA_SUBMISSION = "CancelDataSubmission";
	private static final String ACTION_VALIDATE_DATA_SUBMISSION = "ValidateDataSubmission";
	private static final String ACTION_INVALIDATE_DATA_SUBMISSION = "InvalidateDataSubmission";
	private static final String ACTION_STATUS = "status";

	private static final String SUBMISSION_ID = "SUBMISSION_ID";
	private static final String SRID = "SRID";
	private static final String EXTENSION = "EXTENSION";
	private static final String PROVIDER_ID = "PROVIDER_ID";
	private static final String DATASET_ID = "DATASET_ID";
	private static final String USER_LOGIN = "USER_LOGIN";

	/**
	 * Initialize the integration server.
	 * 
	 * Register the event listeners.
	 */
	@Override
	public void init() throws ServletException {

		super.init();

		// Register the event listeners for the integration process
		try {
			// Get the list of listeners to register
			EventListenerDAO eventDAO = new EventListenerDAO();
			List<EventListenerData> eventListenerList = eventDAO.getEventListeners();
			for (EventListenerData eventListenerName : eventListenerList) {

				// Instanciate the class
				Class<?> clazz = Class.forName(eventListenerName.getClassName());
				IntegrationEventListener eventListener = (IntegrationEventListener) clazz.newInstance();

				logger.debug("Registered event listener : " + eventListenerName.getId());

				// Add it to the list
				IntegrationEventNotifier.addListener(eventListener);
			}

		} catch (Exception e) {
			logger.error(e);
		}

		logger.debug("#######################################");
		logger.debug(" Integration Server initialized        ");
		logger.debug("#######################################");
	}

	/**
	 * Main function of the servlet.
	 * 
	 * @param request
	 *            the request done to the servlet
	 * @param response
	 *            the response sent
	 */
	public void service(HttpServletRequest request, HttpServletResponse response) throws IOException {

		// Permet de stocker temporairement le nom des parametres
		Map<String, String> requestParameters = new HashMap<String, String>();

		String action = null;

		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		ServletOutputStream out = response.getOutputStream();

		logRequestParameters(request);

		try {
			logger.debug("Data Servlet called");

			action = request.getParameter(ACTION);
			if (action == null) {
				throw new Exception("The " + ACTION + " parameter is mandatory");
			}

			// Check the content-type
			String contentType = request.getHeader("content-type");

			//
			// New Submission
			//
			if (action.equals(ACTION_NEW_DATA_SUBMISSION)) {

				String providerId = request.getParameter(PROVIDER_ID);
				if (providerId == null) {
					throw new Exception("The " + PROVIDER_ID + " parameter is mandatory");
				}

				String datasetId = request.getParameter(DATASET_ID);
				if (datasetId == null) {
					throw new Exception("The " + DATASET_ID + " parameter is mandatory");
				}

				String userLogin = request.getParameter(USER_LOGIN);
				if (userLogin == null) {
					throw new Exception("The " + USER_LOGIN + " parameter is mandatory");
				}

				Integer newSubmissionId = dataService.newSubmission(providerId, datasetId, userLogin);

				out.print(generateResult("" + newSubmissionId));

			} else

			//
			// Cancel the submission
			//
			if (action.equals(ACTION_CANCEL_DATA_SUBMISSION)) {

				// Get the posted form parameters
				String submissionIDStr = request.getParameter(SUBMISSION_ID);

				if (submissionIDStr == null) {
					throw new Exception("The " + SUBMISSION_ID + " parameter is mandatory");
				}
				// Try to get the instance of the upload process for this submissionId
				Thread thread = ThreadLock.getInstance().getProcess(submissionIDStr);
				AbstractThread uploadProcess = null;

				if(thread instanceof DataServiceThread){
					// Cancel the upload process
					uploadProcess = (DataServiceThread) ThreadLock.getInstance().getProcess(submissionIDStr);
					ThreadLock.getInstance().releaseProcess(submissionIDStr);
					uploadProcess.setCancelled(true);
					// Join the thread so the other thread will wait until this one ends
					uploadProcess.join();
				}

				// Create a new thread for cancelling the submission
				AbstractThread cancelProcess = null;
				Integer submissionID = Integer.valueOf(submissionIDStr);
				// Launch the thread
				cancelProcess = new DataServiceCancelThread(submissionID);
				cancelProcess.start();

				// Register the running thread
				ThreadLock.getInstance().lockProcess(submissionIDStr, cancelProcess);

				// Output the current status of the check service
				out.print(generateResult(SubmissionStatus.RUNNING));

				out.print(generateResult("OK"));
			} else

			//
			// Validate the submission
			//
			if (action.equals(ACTION_VALIDATE_DATA_SUBMISSION)) {

				// Get the posted form parameters
				String submissionIDStr = request.getParameter(SUBMISSION_ID);

				if (submissionIDStr == null) {
					throw new Exception("The " + SUBMISSION_ID + " parameter is mandatory");
				}

				Integer submissionID = Integer.valueOf(submissionIDStr);

				dataService.validateSubmission(submissionID);

				out.print(generateResult("OK"));
			} else

			//
			// Invalidate the submission
			//
			if (action.equals(ACTION_INVALIDATE_DATA_SUBMISSION)) {

				// Get the posted form parameters
				String submissionIDStr = request.getParameter(SUBMISSION_ID);

				if (submissionIDStr == null) {
					throw new Exception("The " + SUBMISSION_ID + " parameter is mandatory");
				}

				Integer submissionID = Integer.valueOf(submissionIDStr);

				dataService.invalidateSubmission(submissionID);

				out.print(generateResult("OK"));
			} else

			//
			// Get the STATUS of the process for a submission
			//
			if (action.equals(ACTION_STATUS)) {

				// Get the posted form parameters
				String submissionIDStr = request.getParameter(SUBMISSION_ID);

				if (submissionIDStr == null) {
					throw new Exception("The " + SUBMISSION_ID + " parameter is mandatory");
				}

				Integer submissionID = Integer.valueOf(submissionIDStr);

				// Try to get the instance of the checkservice for this submissionId$
				Thread thread = ThreadLock.getInstance().getProcess(submissionIDStr);
				AbstractThread process = null;

				if(thread instanceof DataServiceThread){
					process = (DataServiceThread) ThreadLock.getInstance().getProcess(submissionIDStr);
				} else if (thread instanceof DataServiceCancelThread){
					process = (DataServiceCancelThread) ThreadLock.getInstance().getProcess(submissionIDStr);
				}
				if (process != null) {
					// There is a running thread, we get its current status.
					out.print(generateResult(SubmissionStatus.RUNNING, process));
				} else {
					// We try to get the status of the submission
					out.print(generateResult(dataService.getSubmission(submissionID).getStatus()));
				}

			} else

			//
			// Upload some data
			//
			if (action.equals(ACTION_UPLOAD_DATA) && contentType.matches("multipart/form-data.*")) {

				// Parse the multipart message and store the parts in two lists
				List<?> uploadedItems = fileUpload.parseRequest(request);
				List<FileItem> fileFieldsList = new ArrayList<FileItem>();
				List<FileItem> formFieldsList = new ArrayList<FileItem>();
				Iterator<?> iter = uploadedItems.iterator();
				while (iter.hasNext()) {
					FileItem item = (FileItem) iter.next();
					if (item.isFormField()) {
						formFieldsList.add(item);
					} else {
						fileFieldsList.add(item);
					}
				}

				// Store the form items in the Map
				Iterator<FileItem> formIter = formFieldsList.iterator();
				while (formIter.hasNext()) {
					FileItem item = formIter.next();
					String fieldName = item.getFieldName().trim();
					String fieldValue = item.getString().trim();
					requestParameters.put(fieldName, fieldValue);
				}

				String submissionIDStr = requestParameters.get(SUBMISSION_ID);

				if (submissionIDStr == null) {
					throw new Exception("The " + SUBMISSION_ID + " parameter is mandatory");
				}
				Integer submissionId = Integer.valueOf(submissionIDStr);

				// The PROVIDER_ID will be detected as a source data
				String providerId = requestParameters.get(PROVIDER_ID);
				if (providerId == null) {
					throw new Exception("The " + PROVIDER_ID + " parameter is mandatory");
				}

				String userSridStr = requestParameters.get(SRID);
				String userExtensionStr = requestParameters.get(EXTENSION);

				if (userSridStr == null || userSridStr.isEmpty()) {
					// Pick the default parameter
					ApplicationParametersDAO parameterDao = new ApplicationParametersDAO();
					userSridStr = parameterDao.getApplicationParameter("srs_raw_data");
				}
				Integer userSrid = Integer.valueOf(userSridStr);
				
				if (userExtensionStr == null || userExtensionStr.isEmpty()) {
					// Pick the default parameter
					userExtensionStr = ".csv";
				}
				String userExtension = userExtensionStr;

				// Upload the file items in the directory
				Iterator<FileItem> fileIter = fileFieldsList.iterator();
				while (fileIter.hasNext()) {
					FileItem item = fileIter.next();
					String fileType = item.getFieldName().trim();
					String filePath = pathFileDirectory + separator + submissionId + separator + fileType + separator + item.getName().trim();
					uploadFile(item, filePath);
					requestParameters.put(fileType, filePath);

				}

				// Check if a thread is already running
				Thread process = ThreadLock.getInstance().getProcess(submissionIDStr);
				if (process != null) {
					throw new Exception("A process is already running for this provider and dataset");
				}

				// Launch the thread
				process = new DataServiceThread(submissionId, userSrid, requestParameters, userExtension);
				process.start();

				// Register the running thread
				ThreadLock.getInstance().lockProcess(submissionIDStr, process);

				// Output the current status of the check service
				out.print(generateResult(SubmissionStatus.RUNNING));

			} else {
				throw new Exception("The action type is unknown or does not match the expected mime type, valid actions are " + //
						ACTION_NEW_DATA_SUBMISSION + ", " + //
						ACTION_UPLOAD_DATA + ", " + //
						ACTION_CANCEL_DATA_SUBMISSION);
			}

		} catch (Exception e) {
			logger.error("Error during data upload", e);
			out.print(generateErrorMessage(e.getMessage()));
		}
	}
}
