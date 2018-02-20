package fr.ifn.ogam.integration.business;

import java.util.Map;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.database.GenericData;

/**
 * Demonstration listener for integration events.
 */
public class SimpleEventLogger implements IntegrationEventListener {

	/**
	 * The logger used to log the errors or several information.
	 * 
	 * @see org.apache.log4j.Logger
	 */
	protected final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Event called before the integration of a submission of data.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	@Override
	public void beforeIntegration(Integer submissionId) {
		logger.debug("beforeIntegration event called for submission " + submissionId);
	}

	/**
	 * Event called after the integration of a submission of data.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	@Override
	public void afterIntegration(Integer submissionId) {
		logger.debug("afterIntegration event called for submission " + submissionId);

	}

	/**
	 * Event called when checking  a line of data.
	 *
	 * @param submissionId
	 *            the submission identifier
	 * @param values
	 *            Entry values
	 * @throws Exception,
	 *             CheckException CheckException in case of database error
	 */
	@Override
	public void checkLine(Integer submissionId, Map<String, GenericData> values) throws Exception, CheckException {
		logger.debug("checkLine event called for submission " + submissionId);
	}

	/**
	 * Event called before each insertion of a line of data.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @param values
	 *            Entry values
	 * @throws Exception, CheckException
	 *             in case of database error
	 */
	@Override
	public void beforeLineInsertion(Integer submissionId, Map<String, GenericData> values) throws Exception, CheckException {
		logger.debug("beforeLineInsertion event called for submission " + submissionId);
	}

	/**

	 * Event called after each insertion of a line of data.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @param format
	 *            The format
	 * @param tableName
	 *            The table name
	 * @param values
	 *            Entry values
	 * @param id
	 *            The identifier corresponding to the ogamId
	 * @throws Exception
	 *             in case of database error
	 */
	@Override
	public void afterLineInsertion(Integer submissionId, String format, String tableName, Map<String, GenericData> values, String id) throws Exception {
		logger.debug("afterLineInsertion event called for submission " + submissionId + " and format " + format);
	}

}
