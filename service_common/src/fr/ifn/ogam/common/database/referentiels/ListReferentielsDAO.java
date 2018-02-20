/**
 * 
 */
package fr.ifn.ogam.common.database.referentiels;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

/**
 * DAO for methods involving list of referentiels.
 * 
 * @author severine
 *
 */
public class ListReferentielsDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Get the label and version of a referentiel (by table_name)
	 */
	private static final String GET_REFERENTIEL_DATA_BY_TABLE_NAME_STMT = "SELECT label, version " +
			"FROM referentiels.liste_referentiels " +
			"WHERE table_name = ?";

	/**
	 * Get a connexion to the database.
	 *
	 * @return The <code>Connection</code>
	 * @throws NamingException
	 * @throws SQLException
	 */
	private Connection getConnection() throws NamingException, SQLException {

		Context initContext = new InitialContext();
		DataSource ds = (DataSource) initContext.lookup("java:/comp/env/jdbc/metadata");
		Connection cx = ds.getConnection();

		return cx;
	}


	/**
	 * Get a referentiel label
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 * @return the submission
	 */
	public String getReferentielLabel(String table_name) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_REFERENTIEL_DATA_BY_TABLE_NAME_STMT);
			ps.setString(1, table_name);

			logger.trace(GET_REFERENTIEL_DATA_BY_TABLE_NAME_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = rs.getString("label");
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
	 * Get a referentiel version
	 *
	 * @param submissionId
	 *            the identifier of the submission
	 * @return the submission
	 */
	public String getReferentielVersion(String table_name) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_REFERENTIEL_DATA_BY_TABLE_NAME_STMT);
			ps.setString(1, table_name);

			logger.trace(GET_REFERENTIEL_DATA_BY_TABLE_NAME_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = rs.getString("version");
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
