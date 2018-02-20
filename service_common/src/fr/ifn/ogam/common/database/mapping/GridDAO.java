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
package fr.ifn.ogam.common.database.mapping;

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
 * Data Access Object used to get grids description.
 */
public class GridDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Get the definition of one grid.
	 */
	private static final String GET_GRID_STMT = "SELECT * FROM grid_definition WHERE grid_name = ?";

	/**
	 * Get all the definitions of the grids.
	 */
	private static final String GET_GRIDS_STMT = "SELECT * FROM grid_definition";

	/**
	 * Get a connexion to the database.
	 * 
	 * @return The <code>Connection</code>
	 * @throws NamingException
	 * @throws SQLException
	 */
	public Connection getConnection() throws NamingException, SQLException {

		Context initContext = new InitialContext();
		DataSource ds = (DataSource) initContext.lookup("java:/comp/env/jdbc/mapping");
		Connection cx = ds.getConnection();

		return cx;
	}

	/**
	 * Get the descriptions of the grid.
	 * 
	 * @param gridName
	 *            the logical name of the grid
	 * @return a GridData
	 */
	public GridData getGrid(String gridName) throws Exception {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		GridData result = null;
		try {

			con = getConnection();

			// Insert the check error in the table
			ps = con.prepareStatement(GET_GRID_STMT);
			ps.setString(1, gridName);
			logger.trace(GET_GRID_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = new GridData();
				result.setGridName(gridName);
				result.setGridLabel(rs.getString("grid_label"));
				result.setGridTable(rs.getString("grid_table"));
				result.setLocationColumn(rs.getString("location_column"));
				result.setAggregationLayerName(rs.getString("aggregation_layer_name"));
			}

			return result;

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

	/**
	 * Get the descriptions of the grids.
	 * 
	 * @return a GridData
	 */
	public List<GridData> getGrids() throws Exception {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<GridData> result = new ArrayList<GridData>();
		try {

			con = getConnection();

			// Insert the check error in the table
			ps = con.prepareStatement(GET_GRIDS_STMT);
			logger.trace(GET_GRIDS_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				GridData grid = new GridData();
				grid.setGridName(rs.getString("grid_name"));
				grid.setGridLabel(rs.getString("grid_label"));
				grid.setGridTable(rs.getString("grid_table"));
				grid.setLocationColumn(rs.getString("location_column"));
				grid.setAggregationLayerName(rs.getString("aggregation_layer_name"));
				result.add(grid);
			}

			return result;

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

}
