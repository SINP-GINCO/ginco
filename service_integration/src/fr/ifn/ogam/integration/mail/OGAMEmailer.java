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
package fr.ifn.ogam.integration.mail;

import javax.mail.Session;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.util.Emailer;
import fr.ifn.ogam.common.database.rawdata.SubmissionData;
import fr.ifn.ogam.common.database.website.ApplicationParametersDAO;

/**
 * Class used to send the emails.
 */
public class OGAMEmailer {

	/**
	 * The local logger.
	 */
	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The emailer.
	 */
	private Emailer emailer = new Emailer();
	private static final String FROM_NAME = "[OGAM]";

	/**
	 * The DAOs.
	 */
	private ApplicationParametersDAO parameterDAO = new ApplicationParametersDAO();

	/**
	 * Sends an email to the administrator.
	 * 
	 * @param title
	 *            The title of the mail
	 * @param submission
	 *            the submission object
	 */
	public void send(String title, SubmissionData submission) {
		try {
			String toMail = parameterDAO.getApplicationParameter("toMail");
			String fromMail = parameterDAO.getApplicationParameter("fromMail");

			StringBuffer message = new StringBuffer("A new submission has been done on the web site\n\n");
			message.append("The submission id is: " + submission.getSubmissionId() + "\n");

			try {

				message.append("\n\n");
				message.append("Provider : " + submission.getProviderId() + "\n");
				message.append("Dataset : " + submission.getDatasetId() + "\n");
				message.append("Step : " + submission.getStep() + "\n");
				message.append("Status : " + submission.getStatus() + "\n");

			} catch (Exception e) {
				logger.error("Error while getting submission information for the email " + e.getMessage());
			}

			Session session = emailer.getTomcatSession();
			emailer.sendEmail(session, fromMail, FROM_NAME, toMail, title, message.toString());

		} catch (Exception ignored) {
			// The mailer is used to send error alerts, it should never throw an exception
			logger.error("Error while sending the mail : " + ignored.getMessage());
		}
	}

}
