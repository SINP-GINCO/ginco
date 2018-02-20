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
package fr.ifn.ogam.integration.database.metadata;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

/**
 * Data Access Object used get event listenenrs.
 */
public class EventListenerDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Get all the listeners.
	 */
	private static final String GET_EVENT_LISTENERS_STMT = "SELECT listener_id, classname FROM metadata.event_listener";

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
	 * Get the list of Event Listeners.
	 * 
	 * @return The registered event listeners
	 * @throws Exception
	 *             In case of error with the database
	 */
	public List<EventListenerData> getEventListeners() throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<EventListenerData> result = new ArrayList<EventListenerData>();

		try {
			con = getConnection();

			// Preparation of the request
			ps = con.prepareStatement(GET_EVENT_LISTENERS_STMT);

			rs = ps.executeQuery();

			while (rs.next()) {

				EventListenerData el = new EventListenerData();
				el.setId(rs.getString("listener_id"));
				el.setClassName(rs.getString("classname"));

				result.add(el);
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
