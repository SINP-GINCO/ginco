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

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.IOException;
import java.net.MalformedURLException;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.AbstractService;
import fr.ifn.ogam.common.business.MappingTypes;
import fr.ifn.ogam.common.business.Schemas;
import fr.ifn.ogam.common.business.processing.ProcessingService;
import fr.ifn.ogam.common.business.processing.ProcessingStep;
import fr.ifn.ogam.common.business.submissions.SubmissionStatus;
import fr.ifn.ogam.common.business.submissions.SubmissionStep;
import fr.ifn.ogam.common.database.GenericDAO;
import fr.ifn.ogam.common.database.mapping.GeometryDAO;
import fr.ifn.ogam.common.database.metadata.FileFormatData;
import fr.ifn.ogam.common.database.metadata.MetadataDAO;
import fr.ifn.ogam.common.database.metadata.TableFormatData;
import fr.ifn.ogam.common.database.rawdata.SubmissionDAO;
import fr.ifn.ogam.common.database.rawdata.SubmissionData;
import fr.ifn.ogam.common.database.referentiels.CommuneDAO;
import fr.ifn.ogam.common.database.referentiels.DepartementDAO;
import fr.ifn.ogam.common.database.referentiels.MailleDAO;
import fr.ifn.ogam.common.database.referentiels.AdministrativeEntityDAO;
import fr.ifn.ogam.integration.business.IntegrationEventNotifier;
import fr.ifn.ogam.integration.business.IntegrationService;
import fr.ifn.ogam.common.database.website.ApplicationParametersDAO;

/**
 * Service managing plot and tree data.
 */
public class DataService extends AbstractService {

	/**
	 * The logger used to log the errors or several information.
	 * 
	 * @see org.apache.log4j.Logger
	 */
	private final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The Data Access Objects.
	 */
	private SubmissionDAO submissionDAO = new SubmissionDAO();
	private MetadataDAO metadataDAO = new MetadataDAO();
	private GenericDAO genericDAO = new GenericDAO();
	private ApplicationParametersDAO parameterDAO = new ApplicationParametersDAO();

	/**
	 * The integration service.
	 */
	private IntegrationService integrationService = new IntegrationService();

	/**
	 * The post-processing service.
	 */
	private ProcessingService processingService = new ProcessingService();

	/**
	 * Event notifier
	 */
	private IntegrationEventNotifier eventNotifier = new IntegrationEventNotifier();

	/**
	 * Constructor.
	 */
	public DataService() {
		super();
	}

	/**
	 * Constructor.
	 * 
	 * @param thread
	 *            The thread that launched the service
	 */
	public DataService(DataServiceThread thread) {
		super(thread);
	}
	
	/**
	 * Constructor.
	 * 
	 * @param thread
	 *            The thread that launched the service
	 */
	public DataService(DataServiceCancelThread thread) {
		super(thread);
	}

	/**
	 * Get a submission.
	 * 
	 * @param submissionId
	 *            the identifier of the submission
	 * @return the data submission object
	 */
	public SubmissionData getSubmission(Integer submissionId) throws Exception {

		return submissionDAO.getSubmission(submissionId);

	}

	/**
	 * Create a new data submission.
	 * 
	 * @param providerId
	 *            the dataset identifier
	 * @param datasetId
	 *            the identifier of the dataset
	 * @param userLogin
	 *            the login of the user who creates the submission
	 * @return the identifier of the created submission
	 */
	public Integer newSubmission(String providerId, String datasetId, String userLogin) throws Exception {

		// Clear caches to be sure providerId is known
		metadataDAO.clearCaches();

		// Create the submission
		Integer submissionId = submissionDAO.newSubmission(providerId, datasetId, userLogin);

		logger.debug("New data submission created : " + submissionId);

		return submissionId;

	}

	/**
	 * Validate a data submission.
	 * 
	 * @param submissionId
	 *            the identifier of the submission
	 */
	public void validateSubmission(Integer submissionId) throws Exception {

		// Update the status of the submission
		submissionDAO.validateSubmission(submissionId);

		logger.debug("Data submission validated : " + submissionId);

	}

	/**
	 * Invalidate a data submission.
	 * 
	 * @param submissionId
	 *            the identifier of the submission
	 */
	public void invalidateSubmission(Integer submissionId) throws Exception {

		// Update the status of the submission
		submissionDAO.invalidateSubmission(submissionId);

		logger.debug("Data submission invalidated : " + submissionId);

	}

	/**
	 * Cancel a data submission.
	 * 
	 * @param submissionId
	 *            the identifier of the submission
	 */
	public void cancelSubmission(Integer submissionId) throws Exception {

		// Get some info about the submission
		submissionDAO.updateSubmissionStatus(submissionId, SubmissionStep.SUBMISSION_CANCELLED, SubmissionStatus.RUNNING);

		// Get the list of potential destination tables
		List<TableFormatData> destinationTables = new ArrayList<TableFormatData>();
		destinationTables = metadataDAO.getAllTables();

		// Get the tables with their ancestors sorted in the right order
		List<String> toDeleteFormats = integrationService.getSortedAncestors(Schemas.RAW_DATA, destinationTables);

		// Delete data for the raw_data tables in the right order
		Iterator<String> tableIter = toDeleteFormats.iterator();
		while (tableIter.hasNext()) {
			String tableFormat = tableIter.next();
			TableFormatData tableFormatData = metadataDAO.getTableFormat(tableFormat);
			deleteFromGincoBacsData(tableFormatData, submissionId);
			genericDAO.deleteRawData(tableFormatData.getTableName(), submissionId);
		}

		// Update the status of the submission
		submissionDAO.updateSubmissionStatus(submissionId, SubmissionStep.SUBMISSION_CANCELLED, SubmissionStatus.OK);
			
		logger.debug("Submission " + submissionId + " cancelled");

	}

	/**
	 * Specific to GINCO. Deletes all data related to the submission inside tables used for visualization.
	 * 
	 * @param tableFormatData
	 *            the tableFormatData
	 * @throws Exception
	 */
	public void deleteFromGincoBacsData(TableFormatData tableFormat, Integer submissionId) throws Exception {

		GeometryDAO geometryDAO = new GeometryDAO();
		CommuneDAO communeDAO = new CommuneDAO();
		DepartementDAO departementDAO = new DepartementDAO();
		MailleDAO mailleDAO = new MailleDAO();
		AdministrativeEntityDAO administrativeEntityDAO = new AdministrativeEntityDAO();
		Connection conn = administrativeEntityDAO.getConnection();

		geometryDAO.deleteGeometriesFromFormat(tableFormat, submissionId, conn);
		communeDAO.deleteCommunesFromFormat(tableFormat, submissionId, conn);
		departementDAO.deleteDepartmentsFromFormat(tableFormat, submissionId, conn);
		mailleDAO.deleteMaillesFromFormat(tableFormat, submissionId, conn);
		administrativeEntityDAO.closeConnection(conn);
	}

	/**
	 * Submit new data.
	 * 
	 * @param submissionId
	 *            the identifier of the submission
	 * @param userSrid
	 *            the srid given by the user
	 * @param userExtension
	 *            the extension given
	 * @param requestParameters
	 *            the map of static parameter values (the upload path, ...)
	 * @return the created submission object
	 */
	public SubmissionData submitData(Integer submissionId, Integer userSrid, String userExtension, Map<String, String> requestParameters) {

		try {
			
			// Clear caches to be sure providerId is known
			metadataDAO.clearCaches();
			
			boolean isSubmitValid = true;

			submissionDAO.updateSubmissionStatus(submissionId, SubmissionStep.DATA_INSERTED, SubmissionStatus.RUNNING);

			// Check the status of the submission
			SubmissionData submission = submissionDAO.getSubmission(submissionId);
			if (submission == null) {
				throw new Exception("The submission number " + submissionId + " doest not exist");
			}

			// Notify the event listeners that we are going to insert data
			eventNotifier.beforeIntegration(submissionId);

			// Get the expected CSV formats for the request
			List<FileFormatData> fileFormats = metadataDAO.getDatasetFiles(submission.getDatasetId());
			Iterator<FileFormatData> fileIter = fileFormats.iterator();
			while (fileIter.hasNext()) {

				FileFormatData fileFormat = fileIter.next();

				// Get the path of the file
				String filePath = requestParameters.get(fileFormat.getFormat());

				// Insert the data in database with automatic mapping ...
				isSubmitValid = isSubmitValid && integrationService.insertData(submissionId, userSrid, filePath, userExtension, fileFormat.getFormat(),
						fileFormat.getFileType(), requestParameters, this.thread);

			}

			// Update the submission status
			if (isSubmitValid) {
				submissionDAO.updateSubmissionStatus(submissionId, SubmissionStep.DATA_INSERTED, SubmissionStatus.OK);
			} else {
				// Immediately cancel the submission data
				cancelSubmission(submissionId);

				if (this.thread != null && this.thread.isCancelled()) {
					submissionDAO.updateSubmissionStatus(submissionId, SubmissionStep.SUBMISSION_CANCELLED, SubmissionStatus.ERROR);
				} else {
					submissionDAO.updateSubmissionStatus(submissionId, SubmissionStep.DATA_INSERTED, SubmissionStatus.ERROR);
				}
			}

			// Launch post-processing (if not cancelled)
			if (this.thread == null || !this.thread.isCancelled()) {
				// SQL post-processing (table metadata.process)
				processingService.processData(ProcessingStep.INTEGRATION, submission, this.thread);

				// Notify the event listeners that insertion is done
				eventNotifier.afterIntegration(submissionId);
			}

			logger.debug("data submitted");

		} catch (Exception e) {
			logger.error("Error during upload process", e);
			try {
				submissionDAO.updateSubmissionStatus(submissionId, SubmissionStep.DATA_INSERTED, SubmissionStatus.ERROR);
			} catch (Exception ignored) {
				logger.error("Error while updating process status", e);
			}
		}

		// Return the status of the submission
		if (submissionId != null) {
			try {
				return submissionDAO.getSubmission(submissionId);
			} catch (Exception ignored) {
				return null;
			}
		} else {
			return null;
		}
	}
}
