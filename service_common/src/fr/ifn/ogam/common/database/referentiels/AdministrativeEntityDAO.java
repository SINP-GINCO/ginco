/**
 * 
 */
package fr.ifn.ogam.common.database.referentiels;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.database.GenericDAO;

/**
 * 
 * DAO for methods involving administrative entities such as communes, departement, maille. Handles JDBC connections.
 * 
 * @author gpastakia
 *
 */
public class AdministrativeEntityDAO {

	/***
	 * The logger used to log the errors or several information.**
	 * 
	 * @see org.apache.log4j.Logger
	 */
	protected final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Gets a connexion to the database.
	 * 
	 * @return The <code>Connection</code>
	 * @throws NamingException
	 * @throws SQLException
	 */
	public Connection getConnection() throws NamingException, SQLException {
		Context initContext = new InitialContext();
		DataSource ds = (DataSource) initContext.lookup("java:/comp/env/jdbc/metadata");
		return ds.getConnection();
	}

	/**
	 * Closes a JDBC connection.
	 * 
	 * @param conn
	 *            the connection to close
	 * @throws Exception
	 */
	public void closeConnection(Connection conn) throws Exception {

		try {
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException e) {
			logger.error("Error while closing connexion : " + e.getMessage());
		}
	}

	/***
	 * The connection used for the SQL treatments.
	 * 
	 * @see java.sql.Connection
	 */
	protected Connection conn;

	/**
	 * DAO for generic requests
	 * 
	 * @see GenericDao
	 */
	protected GenericDAO genericDao = new GenericDAO();

}
