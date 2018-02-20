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
package fr.ifn.ogam.integration.business.checks;

import java.util.Date;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.ThreadLock;

/**
 * Thread running the checks.
 */
public class CheckServiceThread extends Thread {

	/**
	 * The Thread is always linked to a submission Id.
	 */
	private Integer submissionId;

	/**
	 * The logger used to log the errors or several information.
	 * 
	 * @see org.apache.log4j.Logger
	 */
	protected final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The Check Service.
	 */
	private CheckService checkService = new CheckService();

	/**
	 * Constructs a CheckService object.
	 * 
	 * @param submissionId
	 *            the identifier of the submission
	 * @throws Exception
	 */
	public CheckServiceThread(Integer submissionId) throws Exception {

		this.submissionId = submissionId;

	}

	/**
	 * Launch in thread mode the check(s).
	 */
	public void run() {

		try {

			Date startDate = new Date();
			logger.debug("Start of the check process " + startDate + ".");

			// SQL Conformity checks
			checkService.runChecks(submissionId);

			// Log the end the the request
			Date endDate = new Date();
			logger.debug("Check process terminated successfully in " + (endDate.getTime() - startDate.getTime()) / 1000.00 + " sec.");

		} finally {
			// Remove itself from the list of running checks
			ThreadLock.getInstance().releaseProcess("" + submissionId);

		}

	}

}
