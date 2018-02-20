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
package fr.ifn.ogam.common.database.processing;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

/**
 * Data Access Object used to get process descriptions.
 */
public class ProcessingDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Get all processes to run for a given step.
	 */
	private static final String GET_PROCESSES_STMT = "SELECT * FROM process WHERE step = ?";

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
	 * Get all the post-processing treatments to run for a given step.
	 * 
	 * @return a list of processes
	 */
	public List<ProcessData> getProcesses(String step) {
		List<ProcessData> result = new ArrayList<ProcessData>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_PROCESSES_STMT);
			logger.trace(GET_PROCESSES_STMT);
			ps.setString(1, step);
			rs = ps.executeQuery();

			while (rs.next()) {
				ProcessData process = new ProcessData();
				process.setProcessId(rs.getString("process_id"));
				process.setStep(rs.getString("step"));
				process.setLabel(rs.getString("label"));
				process.setDescription(rs.getString("description"));
				process.setStatement(rs.getString("statement"));
				result.add(process);
			}
		} catch (Exception ignored) {
			logger.error("Error while getting post-process treatments", ignored);
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
		return result;
	}

	/**
	 * Execute the post-process treatment.
	 * 
	 * @param process
	 *            The process to execute
	 */
	public void executeProcess(ProcessData process) throws Exception {

		Connection con = null;
		Statement ps = null;
		try {
			con = getConnection();
			ps = con.createStatement();
			logger.debug("Executing post-process treatment : " + process.getStatement());
			ps.execute(process.getStatement());

		} catch (Exception e) {
			logger.error("Error while executing post-process treatment : " + process.getLabel(), e);
			throw e;
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
