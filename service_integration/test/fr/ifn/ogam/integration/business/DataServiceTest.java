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
package fr.ifn.ogam.integration.business;

import java.util.HashMap;
import java.util.Map;

import fr.ifn.ogam.integration.AbstractEFDACTest;
import fr.ifn.ogam.integration.business.checks.CheckService;
import fr.ifn.ogam.integration.business.submissions.datasubmission.DataService;
import fr.ifn.ogam.common.business.submissions.SubmissionStatus;
import fr.ifn.ogam.common.business.submissions.SubmissionStep;
import fr.ifn.ogam.common.database.rawdata.SubmissionDAO;
import fr.ifn.ogam.common.database.rawdata.SubmissionData;

//
// Note : In order to use this Test Class correctly under Eclipse, you need to change the working directory to
// ${workspace_loc:EFDAC - Framework Contract for forest data and services/service_integration}
//

/**
 * Test cases for the Data service.
 */
public class DataServiceTest extends AbstractEFDACTest {

	// The services
	private DataService dataService = new DataService();
	private CheckService checkService = new CheckService();

	// The DAOs
	private SubmissionDAO submissionDAO = new SubmissionDAO();

	/**
	 * Constructor
	 * 
	 * @param name
	 */
	public DataServiceTest(String name) {
		super(name);
	}

	/**
	 * Test the data submission function.
	 */
	public void testDataSubmission() throws Exception {

		// Parameters
		String providerId = "test_provider";
		String locationFile = "../database/Sample Data/small/location.csv";
		String plotFile = "../database/Sample Data/small/plot_data.csv";
		String speciesFile = "../database/Sample Data/small/species_data.csv";

		String requestId = "SPECIES";
		String userLogin = "Test user";

		Integer dataSubmissionId = null;
		Integer userSrid = 3857;
		
		try {

			// Create a new data submission
			dataSubmissionId = dataService.newSubmission(providerId, requestId, userLogin);

			// Simulate the data servlet request parameters
			Map<String, String> dataParameters = new HashMap<String, String>();
			dataParameters.put(SUBMISSION_ID, "" + dataSubmissionId);
			dataParameters.put(PROVIDER_ID, providerId);
			dataParameters.put(REF_YEAR_BEGIN, "2006");
			dataParameters.put(REF_YEAR_END, "2009");
			dataParameters.put(Formats.LOCATION_FILE, locationFile);
			dataParameters.put(Formats.PLOT_FILE, plotFile);
			dataParameters.put(Formats.SPECIES_FILE, speciesFile);

			// Submit Data
			dataService.submitData(dataSubmissionId, userSrid, dataParameters);

			// Get the data submission status
			SubmissionData submission = dataService.getSubmission(dataSubmissionId);

			// Check that the step is "DATA_INSERTED"
			assertEquals(submission.getStep(), SubmissionStep.DATA_INSERTED);
			assertEquals(submission.getStatus(), SubmissionStatus.OK);

			// Check the submission
			checkService.runChecks(dataSubmissionId);

			// Get the data submission status
			String submissionStatus = checkService.checkSubmissionStatus(dataSubmissionId);

			// Check that the step is "DATA_CHECKED"
			assertEquals(submissionStatus, SubmissionStatus.OK);

			// Validate the submission
			dataService.validateSubmission(dataSubmissionId);

			// Get the data submission status
			submission = submissionDAO.getSubmission(dataSubmissionId);

			// Check that the step is "DATA_VALIDATED"
			assertEquals(submission.getStep(), SubmissionStep.DATA_VALIDATED);
			assertEquals(submission.getStatus(), SubmissionStatus.OK);

		} catch (Exception e) {
			logger.error(e);
			assertTrue(false);
		} finally {

			// Cancel the data submission
			if (dataSubmissionId != null) {
				dataService.cancelSubmission(dataSubmissionId);
			}

		}

	}

}
