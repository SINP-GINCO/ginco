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
package fr.ifn.ogam.common.database.checks;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

/**
 * Data Access Object used to get checks description.
 */
public class ChecksDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Get all check labels.
	 */
	private static final String GET_DESCRIPTION_STMT = "SELECT check_id, description FROM checks";

	/**
	 * Get the checks for a provider and a dataset.
	 */
	private static final String GET_CHECKS_STMT = "SELECT check_id, step, name, label, description, statement, importance " + //
			"FROM checks_per_provider " + //
			"LEFT JOIN checks USING (check_id) " + //
			"WHERE (dataset_id = ? OR dataset_id = '*') " + //
			"AND (provider_id = ? OR provider_id = '*')";

	/**
	 * Get a connexion to the database.
	 * 
	 * @return The <code>Connection</code>
	 * @throws NamingException
	 * @throws SQLException
	 */
	public Connection getConnection() throws NamingException, SQLException {

		Context initContext = new InitialContext();
		DataSource ds = (DataSource) initContext.lookup("java:/comp/env/jdbc/metadata");
		Connection cx = ds.getConnection();

		return cx;
	}

	/**
	 * Get the descriptions of all the check errors.
	 * 
	 * @return a map with the descriptions of all the check errors
	 */
	public Map<Integer, String> getDescriptions() {
		Map<Integer, String> errorLabels = new HashMap<Integer, String>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			// Insert the check error in the table
			ps = con.prepareStatement(GET_DESCRIPTION_STMT);
			logger.trace(GET_DESCRIPTION_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				Integer checkId = rs.getInt("check_id");
				String label = rs.getString("description");
				errorLabels.put(checkId, label);
			}
		} catch (Exception ignored) {
			logger.error("Error while storing check error", ignored);
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing statement : " + e.getMessage());
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
				logger.error("Error while closing statement : " + e.getMessage());
			}
		}
		return errorLabels;
	}

	/**
	 * Return the list of checks to do for a dataset and a provider.
	 * 
	 * @param datasetId
	 *            the dataset identifier
	 * @param providerId
	 *            the provider identifier
	 * @return the list of checks to do
	 */
	public List<CheckData> getChecks(String datasetId, String providerId) {
		List<CheckData> checksList = new ArrayList<CheckData>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			// Insert the check error in the table
			ps = con.prepareStatement(GET_CHECKS_STMT);
			ps.setString(1, datasetId);
			ps.setString(2, providerId);
			logger.trace(GET_CHECKS_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				CheckData check = new CheckData();
				check.setCheckId(rs.getInt("check_id"));
				check.setStep(rs.getString("step"));
				check.setName(rs.getString("name"));
				check.setLabel(rs.getString("label"));
				check.setDescription(rs.getString("description"));
				check.setStatement(rs.getString("statement"));
				check.setImportance(rs.getString("importance"));
				checksList.add(check);
			}
		} catch (Exception ignored) {
			logger.error("Error while getting checks list", ignored);
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
		return checksList;
	}

	/**
	 * Execute the checks of the step(s).
	 * 
	 * @param submissionId
	 *            The submission identifier
	 * @param checksList
	 *            The list of checks to execute
	 */
	public void executeChecks(int submissionId, List<CheckData> checksList) throws Exception {

		Connection con = null;
		Statement ps = null;
		ResultSet rs = null;
		CheckData check = null;
		try {
			con = getConnection();
			ps = con.createStatement();

			Iterator<CheckData> checksListIter = checksList.iterator();
			while (checksListIter.hasNext()) {
				Date begin = new Date();
				check = (CheckData) checksListIter.next();
				String query = check.getStatement();
				query = query.replaceAll("\\?submissionid\\?", Integer.toString(submissionId));
				logger.debug("********** QUERY *******");
				logger.debug(query);
				logger.debug("************************");
				ps.execute(query);
				Date end = new Date();
				logger.debug("Check : " + check.getCheckId() + " executed in : " + (end.getTime() - begin.getTime()) + " ms");
			}

			logger.debug(checksList.size() + " check(s) found and executed.");
		} catch (Exception e) {
			logger.error("Error while executing checks for submission : " + submissionId, e);
			if (check != null) {
				logger.error("Error while executing checks : " + check.getCheckId() + "\n" + check.getStatement());
			}
			throw e;
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
