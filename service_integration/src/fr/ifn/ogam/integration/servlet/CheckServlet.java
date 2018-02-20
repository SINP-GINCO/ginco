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

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.servlet.AbstractServlet;
import fr.ifn.ogam.common.business.ThreadLock;
import fr.ifn.ogam.integration.business.checks.CheckService;
import fr.ifn.ogam.integration.business.checks.CheckServiceThread;
import fr.ifn.ogam.common.business.submissions.SubmissionStatus;

/**
 * Check Servlet.
 * <p>
 * Launch the data verification.
 */
public class CheckServlet extends AbstractServlet {

	/**
	 * The logger used to log the errors or several information.
	 * 
	 * @see org.apache.log4j.Logger
	 */
	private final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The serial version ID used to identify the object.
	 */
	private static final long serialVersionUID = -455284792196591245L;

	/**
	 * The check service.
	 */
	private transient CheckService checkService = new CheckService();

	/**
	 * Input parameters.
	 */
	private static final String ACTION = "action";
	private static final String ACTION_STATUS = "status";
	private static final String ACTION_CHECK = "check";

	private static final String SUBMISSION_ID = "SUBMISSION_ID";

	/**
	 * Main function of the servlet.
	 * 
	 * @param request
	 *            the request done to the servlet
	 * @param response
	 *            the response sent
	 */
	public void service(HttpServletRequest request, HttpServletResponse response) throws IOException {

		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");

		String action = null;
		ServletOutputStream out = response.getOutputStream();

		logRequestParameters(request);

		try {

			logger.debug("Check Servlet called");

			action = request.getParameter(ACTION);
			if (action == null) {
				throw new Exception("The " + ACTION + " parameter is mandatory");
			}

			String submissionIdStr = request.getParameter(SUBMISSION_ID);
			if (submissionIdStr == null) {
				throw new Exception("The " + SUBMISSION_ID + " parameter is mandatory");
			}

			int submissionId = Integer.parseInt(request.getParameter(SUBMISSION_ID));

			/*
			 * Get the STATE of the checks for a submission
			 */
			if (action.equals(ACTION_STATUS)) {

				// Try to get the instance of the checkservice for this submissionId
				Thread process = ThreadLock.getInstance().getProcess("" + submissionId);

				if (process != null) {
					// There is a running thread, we get its current status.
					out.print(generateResult(SubmissionStatus.RUNNING));
				} else {
					// We try to get the status of the submission in database
					out.print(generateResult(checkService.checkSubmissionStatus(submissionId)));
				}

			} else

			/*
			 * Launch a new check step
			 */
			if (action.equals(ACTION_CHECK)) {

				// Check if a thread is already running
				Thread process = ThreadLock.getInstance().getProcess("" + submissionId);
				if (process != null) {
					throw new Exception("A process is already running for this submission");
				}

				// Launch the check thread
				process = new CheckServiceThread(submissionId);
				process.start();

				// Register the running thread
				ThreadLock.getInstance().lockProcess("" + submissionId, process);

				// Output the current status of the check service
				out.print(generateResult(SubmissionStatus.RUNNING));

			} else {
				throw new Exception("The action type is unknown, valid actions are " + ACTION_STATUS + ", " + ACTION_CHECK);
			}

		} catch (Exception e) {
			logger.error("Error during check processing", e);
			out.print(generateErrorMessage(e.getMessage()));
		}
	}

}
