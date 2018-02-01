package fr.ifn.ogam.integration.business;

import org.apache.log4j.Logger;
import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.website.ApplicationParametersDAO;
import fr.ifn.ogam.common.business.checks.CheckException;
import java.util.Map;
import java.net.URL;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.io.IOException;

/**
 * Service used to perform specific GINCO treatments for jdd.
 *
 * @author amouget
 *
 */
public class GenerateReportsService implements IntegrationEventListener {

	/***
	 * The logger used to log the errors or several information.**
	 *
	 * @see org.apache.log4j.Logger
	 */
	private final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 *  Data Access Object.
	 */
	private ApplicationParametersDAO parameterDAO = new ApplicationParametersDAO();
	
	/**
	 * Event called before the integration of a submission of data.
	 * Get the metadataId from submissionId
	 *
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	public void beforeIntegration(Integer submissionId) throws Exception {
		// DO NOTHING
	}

	/**
	 * Event called after the integration of a submission of data.
	 *
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	public void afterIntegration(Integer submissionId) throws Exception {
		try {
			String baseUrl = parameterDAO.getApplicationParameter("site_url");
			// TODO: the URL is false in dev env (/app_dev.php is missing). Thus reports are not generated here in dev, but when downloaded.
			URL myURL = new URL(baseUrl + "/submission/generate-reports?submissionId=" + submissionId);
			HttpURLConnection conn = (HttpURLConnection) myURL.openConnection();
			int responseCode = conn.getResponseCode();
		} catch (MalformedURLException e) {
			// new URL() failed
			logger.debug("Malformed URL exception", e);
		} catch (IOException e) {
			// openConnection() failed
			logger.debug("IOException", e);
		}
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
	public void checkLine(Integer submissionId, Map<String, GenericData> values) throws Exception, CheckException {
		// DO NOTHING
	}

	/**
	 * Event called before each insertion of a line of data.
	 * Add or Update the field 'jddmetadonneedeeid' for the data in the Java map given.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @param values
	 *            Entry values
	 * @throws Exception,
	 *             CheckException CheckException in case of database error
	 */
	public void beforeLineInsertion(Integer submissionId, Map<String, GenericData> values) throws Exception, CheckException {
		// DO NOTHING
	}

	/**
	 * 
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
	public void afterLineInsertion(Integer submissionId, String format, String tableName, Map<String, GenericData> values, String id) throws Exception{
		// DO NOTHING
	}
}
