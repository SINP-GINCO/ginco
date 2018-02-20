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
package fr.ifn.ogam.integration.business.submissions.datasubmission;

import java.util.Date;
import java.util.Map;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.AbstractThread;
import fr.ifn.ogam.common.business.ThreadLock;
import fr.ifn.ogam.common.database.rawdata.SubmissionData;
import fr.ifn.ogam.integration.mail.OGAMEmailer;

/**
 * Thread running the data submission cancellation.
 */
public class DataServiceCancelThread extends AbstractThread {

	/**
	 * Local variables.
	 */
	private Integer submissionId;

	/**
	 * The logger used to log the errors or several information.
	 * 
	 * @see org.apache.log4j.Logger
	 */
	protected final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Constructs a DataServiceThread object.
	 * 
	 * @param submissionId
	 *            the identifier of the submission
	 * @throws Exception
	 */
	public DataServiceCancelThread(Integer submissionId) throws Exception {

		this.submissionId = submissionId;
	}

	/**
	 * Launch in thread mode the check(s).
	 */
	public void run() {

		try {

			Date startDate = new Date();
			logger.debug("Start of the data cancel process " + startDate + ".");

			// Submit the data
			DataService dataService = new DataService(this);
			try {
				dataService.cancelSubmission(this.submissionId);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			// Log the end the the request
			Date endDate = new Date();
			logger.debug("Submission cancel process terminated successfully in " + (endDate.getTime() - startDate.getTime()) / 1000.00 + " sec.");

		} finally {
			// Remove itself from the list of running checks
			ThreadLock.getInstance().releaseProcess("" + submissionId);

		}

	}

}
