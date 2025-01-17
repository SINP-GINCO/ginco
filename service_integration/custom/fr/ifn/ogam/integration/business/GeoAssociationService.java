package fr.ifn.ogam.integration.business;

import org.apache.log4j.Logger;
import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.website.ApplicationParametersDAO;
import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.database.rawdata.SubmissionDAO;
import fr.ifn.ogam.common.business.submissions.SubmissionStep;
import fr.ifn.ogam.common.business.submissions.SubmissionStatus;
import java.util.Map;
import java.net.URL;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.MalformedURLException;
import java.net.Proxy;
import java.io.IOException;

/**
 * Service used to perform specific GINCO treatments for submission.
 *
 * @author amouget
 *
 */
public class GeoAssociationService implements IntegrationEventListener {

	/***
	 * The logger used to log the errors or several information.**
	 *
	 * @see org.apache.log4j.Logger
	 */
	private final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Data Access Object.
	 */
	private ApplicationParametersDAO parameterDAO = new ApplicationParametersDAO();
	private SubmissionDAO submissionDAO = new SubmissionDAO();

	/**
	 * Event called before the integration of a submission of data. Get the metadataId from submissionId
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
		logger.debug("GeoAssociationService, afterIntegration");

		int responseCode = 0;
		
		String baseUrl = parameterDAO.getApplicationParameter("site_url");
		
		Proxy proxy = null ;
		String proxyStr = parameterDAO.getApplicationParameter("https_proxy") ;
		if (!proxyStr.isEmpty()) {
			String[] proxyParams = proxyStr.split(":") ;
			String httpProxy = proxyParams[0] ;
			int httpPort = Integer.parseInt(proxyParams[1]) ;
			if (!baseUrl.contains("localhost") && !baseUrl.contains("127.0.0.1")) {
				proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(httpProxy, httpPort)) ;
			}
		}

		try {
			// Call prod url first
			URL myURL = new URL(baseUrl + "/geo-association/compute?submissionId=" + submissionId);
			logger.debug("Calling url: " + myURL);
			if (proxy != null) {
				HttpURLConnection conn = (HttpURLConnection) myURL.openConnection(proxy);
				responseCode = conn.getResponseCode();
				logger.debug("Response code: " + responseCode);
			} else {
				HttpURLConnection conn = (HttpURLConnection) myURL.openConnection();
				responseCode = conn.getResponseCode();
				logger.debug("Response code: " + responseCode);
			}
		} catch (MalformedURLException e) {
			// new URL() failed
			logger.debug("Malformed URL exception", e);
		} catch (IOException e) {
			// openConnection() failed
			logger.debug("IOException", e);
		}

		// Call dev URL if prod URL did not succeed
		if (responseCode != 200 && !submissionDAO.getSubmission(submissionId).getStep().equals("GEO-ASSOCIATION")) {
			try {
				URL myURL = new URL(baseUrl + "/app_dev.php/geo-association/compute?submissionId=" + submissionId);
				logger.debug("Calling url: " + myURL);
				if (proxy != null) {
					HttpURLConnection conn = (HttpURLConnection) myURL.openConnection(proxy);
					responseCode = conn.getResponseCode();
					logger.debug("Response code: " + responseCode);
				} else {
					HttpURLConnection conn = (HttpURLConnection) myURL.openConnection();
					responseCode = conn.getResponseCode();
					logger.debug("Response code: " + responseCode);
				}
			} catch (MalformedURLException e) {
				// new URL() failed
				logger.debug("Malformed URL exception", e);
			} catch (IOException e) {
				// openConnection() failed
				logger.debug("IOException", e);
			}
		}

		// Set submission status to ERROR if dev URL did not succeed either
		if (responseCode != 200 && !submissionDAO.getSubmission(submissionId).getStep().equals("GEO-ASSOCIATION")) {
			submissionDAO.updateSubmissionStatus(submissionId, SubmissionStep.DATA_INSERTED, SubmissionStatus.ERROR);
		}
	}

	/**
	 * Event called when checking a line of data.
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
	 * Event called before each insertion of a line of data. Add or Update the field 'jddmetadonneedeeid' for the data in the Java map given.
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
	public void afterLineInsertion(Integer submissionId, String format, String tableName, Map<String, GenericData> values, String id) throws Exception {
		// DO NOTHING
	}
}
