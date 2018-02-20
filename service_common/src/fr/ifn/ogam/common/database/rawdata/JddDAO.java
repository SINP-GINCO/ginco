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

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.submissions.SubmissionStep;

/**
 * Data Access Object used to access the jdd table (specific to Ginco).
 * 
 * @author gautam
 */
public class JddDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Get the jdd_metadata_id linked to the submission_id.
	 */
	private static final String GET_JDD_METADATA_ID_BY_SUBMISSION_ID_STMT = "SELECT value_string " +
			"FROM raw_data.jdd_field " +
			"INNER JOIN raw_data.jdd " +
			"ON jdd_field.jdd_id = jdd.id " +
			"INNER JOIN raw_data.submission " +
			"ON submission.jdd_id = jdd.id " +
			"WHERE submission_id = ? " +
			"AND key='metadataId'";
	
	/**
	 * Get the tps_id linked to the submission_id.
	 */
	private static final String GET_TPS_ID_BY_SUBMISSION_ID_STMT = "SELECT value_integer " +
			"FROM raw_data.jdd_field " +
			"INNER JOIN raw_data.jdd " +
			"ON jdd_field.jdd_id = jdd.id " +
			"INNER JOIN raw_data.submission " +
			"ON submission.jdd_id = jdd.id " +
			"WHERE submission_id = ? " +
			"AND key='tpsId'";
	
	/**
	 * Get a connection to the database.
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
	 * Get the jdd_metadata_id from the submission_id.
	 * 
	 * @param submissionId
	 *            the identifier of the submission
	 * @return the jddMetadataId
	 */
	public String getJddMetadataId(Integer submissionId) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_JDD_METADATA_ID_BY_SUBMISSION_ID_STMT);
			ps.setInt(1, submissionId);

			logger.trace(GET_JDD_METADATA_ID_BY_SUBMISSION_ID_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = rs.getString("value_string");
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
	 * Get the tps_id from the submission_id.
	 * 
	 * @param submissionId
	 *            the identifier of the submission
	 * @return the tpsId
	 */
	public Integer getTpsId(Integer submissionId) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Integer result = 0;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_TPS_ID_BY_SUBMISSION_ID_STMT);
			ps.setInt(1, submissionId);

			logger.trace(GET_TPS_ID_BY_SUBMISSION_ID_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = rs.getInt("value_integer");
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

}
