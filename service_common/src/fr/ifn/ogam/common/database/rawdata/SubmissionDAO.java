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
package fr.ifn.ogam.common.database.rawdata;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.submissions.SubmissionStep;

/**
 * Data Access Object used to access the application parameters.
 */
public class SubmissionDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Get the next submission id.
	 */
	private static final String GET_NEXT_SUBMISSION_ID_STMT = "SELECT nextval('submission_id_seq') as submissionid";

	/**
	 * Create a new submission.
	 */
	private static final String CREATE_SUBMISSION_STMT = "INSERT INTO submission (submission_id, provider_id, dataset_id, user_login, step) values (?, ?, ?, ?, ?)";

	/**
	 * Update the submission step and status.
	 */
	private static final String UPDATE_SUBMISSION_STATUS_STMT = "UPDATE submission SET status = ?, STEP = ? WHERE submission_id = ?";

	/**
	 * Validate the submission.
	 */
	private static final String VALIDATE_SUBMISSION_STMT = "UPDATE submission SET STEP = ?, _validationdt = ? WHERE submission_id = ?";

	/**
	 * Invalidate the submission.
	 */
	private static final String INVALIDATE_SUBMISSION_STMT = "UPDATE submission SET STEP = ?, _validationdt = ? WHERE submission_id = ?";

	/**
	 * Update the submission step.
	 */
	private static final String UPDATE_SUBMISSION_STEP_STMT = "UPDATE submission SET STEP = ? WHERE submission_id = ?";

	/**
	 * Insert information about a submission file.
	 */
	private static final String INSERT_SUBMISSION_FILE_STMT = "INSERT INTO submission_file (submission_id, file_type, file_name, nb_line) values (?, ?, ?, ?)";

	/**
	 * Update information line_number with a submission file id
	 */
	private static final String UPDATE_SUBMISSION_FILE_STMT = "UPDATE submission_file SET nb_line = ? WHERE submission_id = ?";
	
	/**
	 * Update information file_path extension with a submission file path
	 */
	private static final String UPDATE_SUBMISSION_FILE_PATH_STMT = "UPDATE submission_file SET file_name = ? WHERE submission_id = ?";

	/**
	 * Get a submission.
	 */
	private static final String GET_SUBMISSION_BY_ID_STMT = "SELECT submission_id, step, status, provider_id, dataset_id, user_login FROM submission WHERE submission_id = ?";

	/**
	 * Get the active submissions for a given provider and dataset.
	 */
	private static final String GET_ACTIVE_SUBMISSIONS_STMT = "SELECT submission_id, step, status, provider_id, dataset_id, user_login FROM submission WHERE provider_id = ? AND dataset_id = ? AND step <> 'CANCEL' AND step <> 'INIT'";

	/**
	 * Get a connexion to the database.
	 *
	 * @return The <code>Connection</code>
	 * @throws NamingException
	 * @throws SQLException
	 */
	private Connection getConnection() throws NamingException, SQLException {

		Context initContext = new InitialContext();
		DataSource ds = (DataSource) initContext.lookup("java:/comp/env/jdbc/rawdata");
		Connection cx = ds.getConnection();

		return cx;
	}

	/**
	 * Get a submission information.
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 * @return the submission
	 */
	public SubmissionData getSubmission(Integer submissionId) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		SubmissionData result = null;
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(GET_SUBMISSION_BY_ID_STMT);
			ps.setInt(1, submissionId);

			logger.trace(GET_SUBMISSION_BY_ID_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = new SubmissionData();
				result.setSubmissionId(submissionId);
				result.setStep(rs.getString("step"));
				result.setStatus(rs.getString("status"));
				result.setProviderId(rs.getString("provider_id"));
				result.setDatasetId(rs.getString("dataset_id"));
				result.setUserLogin(rs.getString("user_login"));

			}

			return result;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing resultset : " + e.getMessage());
			}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}

	/**
	 * Get the active submissions for a given provider and dataset.
	 *
	 * @param providerId
	 *            the provider
	 * @param datasetId
	 *            the dataset identifier
	 * @return the submission
	 */
	public List<SubmissionData> getActiveSubmissions(String providerId, String datasetId) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<SubmissionData> result = new ArrayList<SubmissionData>();
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(GET_ACTIVE_SUBMISSIONS_STMT);
			ps.setString(1, providerId);
			ps.setString(2, datasetId);

			logger.trace(GET_ACTIVE_SUBMISSIONS_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				SubmissionData submission = new SubmissionData();
				submission.setSubmissionId(rs.getInt("submission_id"));
				submission.setStep(rs.getString("step"));
				submission.setStatus(rs.getString("status"));
				submission.setProviderId(rs.getString("provider_id"));
				submission.setDatasetId(rs.getString("dataset_id"));
				submission.setUserLogin(rs.getString("user_login"));
				result.add(submission);
			}

			return result;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing resultset : " + e.getMessage());
			}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}

	/**
	 * Create a new submission.
	 *
	 * @param providerId
	 *            the identifier of the data provider
	 * @param datasetId
	 *            the dataset identifier
	 * @param userLogin
	 *            the user
	 * @return the identifier of the new submission
	 */
	public Integer newSubmission(String providerId, String datasetId, String userLogin) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Integer submissionId = null;
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(GET_NEXT_SUBMISSION_ID_STMT);
			logger.trace(GET_NEXT_SUBMISSION_ID_STMT);
			rs = ps.executeQuery();

			rs.next();
			submissionId = rs.getInt("submissionid");

			// close the previous statement
			if (ps != null) {
				ps.close();
			}

			// Insert the submission in the table
			// Preparation of the request
			ps = con.prepareStatement(CREATE_SUBMISSION_STMT);
			logger.trace(CREATE_SUBMISSION_STMT);
			ps.setInt(1, submissionId);
			ps.setString(2, providerId);
			ps.setString(3, datasetId);
			ps.setString(4, userLogin);
			ps.setString(5, SubmissionStep.INITIALISED);
			ps.execute();

			return submissionId;

		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing resultset : " + e.getMessage());
			}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}

	/**
	 * Update the submission step and status.
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 * @param step
	 *            the step of the submission
	 * @param status
	 *            the status of the submission
	 */
	public void updateSubmissionStatus(Integer submissionId, String step, String status) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(UPDATE_SUBMISSION_STATUS_STMT);
			logger.trace(UPDATE_SUBMISSION_STATUS_STMT);
			ps.setString(1, status);
			ps.setString(2, step);
			ps.setInt(3, submissionId);
			ps.execute();

		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}

	/**
	 * Update the submission step (don't change the status).
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 * @param step
	 *            the step of the submission
	 */
	public void updateSubmissionStep(Integer submissionId, String step) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(UPDATE_SUBMISSION_STEP_STMT);
			logger.trace(UPDATE_SUBMISSION_STEP_STMT);
			ps.setString(1, step);
			ps.setInt(2, submissionId);
			ps.execute();

		}
		catch (Exception e) {
			logger.error("Error during submission update", e);
		}
		finally {
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}

	/**
	 * Validate the submission.
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 */
	public void validateSubmission(Integer submissionId) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(VALIDATE_SUBMISSION_STMT);
			logger.trace(VALIDATE_SUBMISSION_STMT);
			ps.setString(1, SubmissionStep.DATA_VALIDATED);
			ps.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
			ps.setInt(3, submissionId);
			ps.execute();

		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}

	/**
	 * Invalidate the submission.
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 */
	public void invalidateSubmission(Integer submissionId) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(INVALIDATE_SUBMISSION_STMT);
			logger.trace(INVALIDATE_SUBMISSION_STMT);
			ps.setString(1, SubmissionStep.DATA_INVALIDATED);
			ps.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
			ps.setInt(3, submissionId);
			ps.execute();

		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}

	/**
	 * Add information about one file of the submission.
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 * @param fileType
	 *            the type of the file
	 * @param fileName
	 *            the name of the file
	 * @param lineNumber
	 *            the number of lines of data in the file
	 */
	public void addSubmissionFile(Integer submissionId, String fileType, String fileName, Integer lineNumber) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(INSERT_SUBMISSION_FILE_STMT);
			logger.trace(INSERT_SUBMISSION_FILE_STMT);
			ps.setInt(1, submissionId);
			ps.setString(2, fileType);
			ps.setString(3, fileName);
			ps.setInt(4, lineNumber);
			ps.execute();

		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}


	/**
	 * Update information lineNumber with submissionId
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 * @param lineNumber
	 *            the number of lines of data in the file
	 */
	public void updateSubmissionFile(Integer submissionId, Integer lineNumber) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(UPDATE_SUBMISSION_FILE_STMT);
			logger.trace(UPDATE_SUBMISSION_FILE_STMT);
			ps.setInt(1, lineNumber);
			ps.setInt(2, submissionId);
			ps.execute();

		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}
	
	/**
	 * Update information filePath extension with submissionId
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 * @param lineNumber
	 *            the path of the file
	 */
	public void updateSubmissionFileName(Integer submissionId, String filePath) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Get the submission ID from the sequence
			ps = con.prepareStatement(UPDATE_SUBMISSION_FILE_PATH_STMT);
			logger.trace(UPDATE_SUBMISSION_FILE_PATH_STMT);
			ps.setString(1, filePath);
			ps.setInt(2, submissionId);
			ps.execute();

		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
			}
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connexion : " + e.getMessage());
			}
		}
	}
}
