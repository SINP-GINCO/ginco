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
package fr.ifn.ogam.integration.database.rawdata;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.checks.CheckException;

/**
 * Data Access Object used to store check errors.
 */
public class CheckErrorDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Create a new submission.
	 */
	private static final String CREATE_CHECK_ERROR_STMT = "INSERT INTO check_error (check_id, submission_id, line_number, src_format, src_data, found_value, expected_value, error_message, plot_code) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";

	/**
	 * Counts the number of errors or warnings for a step and for a specified submission id.
	 */
	private static final String COUNT_STEP_IMPORTANCE_PER_CHECK = "SELECT COUNT(*) " + //
			" FROM check_error " + //
			" LEFT JOIN checks using (check_id) " + //
			" WHERE submission_id = ? " + //
			" AND step = ? " + //
			" AND importance = ?";

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
	 * Insert a a new check exception in database.
	 * 
	 * @param ce
	 *            the check exception
	 */
	public void createCheckError(CheckException ce) {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Insert the check error in the table
			ps = con.prepareStatement(CREATE_CHECK_ERROR_STMT);
			ps.setInt(1, ce.getCheckCode());
			ps.setInt(2, ce.getSubmissionId());
			ps.setInt(3, ce.getLineNumber());
			ps.setString(4, ce.getSourceFormat());
			ps.setString(5, ce.getSourceData());
			ps.setString(6, ce.getFoundValue());
			ps.setString(7, ce.getExpectedValue());
			ps.setString(8, ce.getMessage());
			ps.setString(9, ce.getPlotCode());

			logger.trace(CREATE_CHECK_ERROR_STMT);
			ps.execute();

		} catch (Exception ignored) {
			logger.error("Error while storing check error", ignored);
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
	 * Counts the number of conformity errors for a specified submission id, step(s) and importance.
	 * 
	 * @param submissionId
	 *            The submission identifier
	 * @param steps
	 *            The step(s) of check ('CONFORMITY' or 'COMPLIANCE')
	 * @param importance
	 *            The importance of the check(s) ('WARNING' or 'ERROR')
	 * @return The total of errors for a specified submission id, step(s) and importance
	 */
	public int countPerCheck(int submissionId, String steps, String importance) throws NamingException, SQLException {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = getConnection();

			// Preparation of the request
			ps = con.prepareStatement(COUNT_STEP_IMPORTANCE_PER_CHECK);
			ps.setInt(1, submissionId);
			ps.setString(2, steps);
			ps.setString(3, importance);
			rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt(1);
			} else {
				return -1;
			}
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

}
