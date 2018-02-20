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
package fr.ifn.ogam.common.database.website;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.util.LocalCache;

/**
 * Data Access Object used to access the application parameters.
 */
public class ApplicationParametersDAO {

	/**
	 * Local cache, used to avoid connecting too frequently to the database.
	 */
	private static LocalCache applicationParametersCache = LocalCache.getLocalCache();

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Get an application parameter.
	 */
	private static final String GET_APPLICATION_PARAMETERS_STMT = "SELECT value " + //
			" FROM application_parameters " + //
			" WHERE name = ? ";

	/**
	 * Get a connexion to the database.
	 * 
	 * @return The <code>Connection</code>
	 * @throws NamingException
	 * @throws SQLException
	 */
	public Connection getConnection() throws NamingException, SQLException {

		Context initContext = new InitialContext();
		DataSource ds = (DataSource) initContext.lookup("java:/comp/env/jdbc/website");
		Connection cx = ds.getConnection();

		return cx;
	}

	/**
	 * Get an application parameter.
	 * 
	 * @param parameterName
	 *            the name of the parameter
	 * @return the value of the parameter
	 */
	public String getApplicationParameter(String parameterName) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		String unite = (String) applicationParametersCache.get(parameterName);

		if (unite == null) {

			try {

				con = getConnection();

				// Preparation of the request
				ps = con.prepareStatement(GET_APPLICATION_PARAMETERS_STMT);
				ps.setString(1, parameterName);

				rs = ps.executeQuery();

				if (rs.next()) {
					String res = rs.getString(1);
					if (res != null) {
						unite = res.trim();
					} else {
						unite = "";
					}
				}

				applicationParametersCache.put(parameterName, unite);

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
		}

		return unite;
	}
}
