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
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.database.metadata.TableFormatData;
import fr.ifn.ogam.common.util.DSRConstants;
import fr.ifn.ogam.common.util.LocalCache;

/**
 * Data Access Object used to get grids description.
 */
public class GeometryDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Get the definition of one grid.
	 */
	private static final String GET_SRID_STMT = "SELECT srid FROM geometry_columns WHERE f_table_name ilike ? AND f_geometry_column ilike ?";

	/**
	 * Local cache, for static data.
	 */
	private static LocalCache sridCache = LocalCache.getLocalCache();

	/**
	 * Get a connexion to the database.
	 * 
	 * @return The <code>Connection</code>
	 * @throws NamingException
	 * @throws SQLException
	 */
	public Connection getConnection() throws NamingException, SQLException {

		Context initContext = new InitialContext();
		DataSource ds = (DataSource) initContext.lookup("java:/comp/env/jdbc/rawdata");
		Connection cx = ds.getConnection();

		return cx;
	}

	/**
	 * Get the SRID expected for the table.
	 * 
	 * @param tableName
	 *            the name of the table
	 * @param columnName
	 *            the name of the geometry column
	 * @return a SRID
	 */
	public Integer getSRID(String tableName, String columnName) throws Exception {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Integer result = null;
		try {

			String key = tableName + "_" + columnName;
			result = (Integer) sridCache.get(key);

			if (result == null) {

				con = getConnection();

				// Insert the check error in the table
				ps = con.prepareStatement(GET_SRID_STMT);
				ps.setString(1, tableName);
				ps.setString(2, columnName);
				logger.trace(GET_SRID_STMT);
				rs = ps.executeQuery();

				if (rs.next()) {
					result = rs.getInt("srid");
					sridCache.put(key, result);
				} else {
					throw new Exception("SRID not found for geometry column " + columnName + " of table " + tableName);
				}

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
	 * Get the geometry in WKT in the raw_data srid.
	 * 
	 * @param geomColValue
	 *            the geometry
	 * @return a geom in WKT
	 */
	public String getGeomWktInTableSrid(String geomColValue) throws Exception {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result = null;
		try {
			con = getConnection();

			StringBuffer stmt = new StringBuffer();
			stmt.append("SELECT ST_AsText(" + geomColValue + ")");

			ps = con.prepareStatement(stmt.toString());
			rs = ps.executeQuery();
			rs.next();
			result = rs.getString("st_astext");

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
	 * Get the geometry type of a geometry.
	 * 
	 * @param geometry
	 *            the geometry for which the type will be given
	 * @return the type of the geometry
	 */
	public String getGeometryType(String geometry) throws Exception {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result = null;
		try {

			con = getConnection();

			StringBuffer stmt = new StringBuffer();
			stmt.append("SELECT GeometryType(ST_GeomFromText('" + geometry + "', 4326)) as type");

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();
			rs.next();
			result = rs.getString("type");

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
	 * Deletes from tables "observation_geometrie" and "bac_geometrie" all the geometries and associations linked to the format. Deleting from "bac_geometrie"
	 * has a cascade effect on "observation_geometrie". Code is executed only if tables above exist.
	 * 
	 * @param format
	 *            the table format
	 * @param submissionId
	 *            the identifier of the submission
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void deleteGeometriesFromFormat(TableFormatData tableFormat, Integer submissionId, Connection con) throws Exception {
		logger.debug("deleteGeometriesFromFormat");

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			String tableName = tableFormat.getTableName();
			String format = tableFormat.getFormat();

			StringBuffer stmt = new StringBuffer();

			stmt.append("SELECT to_regclass('mapping.observation_geometrie') as og_reg, to_regclass('mapping.bac_geometrie') as bg_reg");
			ps = con.prepareStatement(stmt.toString());
			logger.debug(stmt.toString());
			rs = ps.executeQuery();
			String ogReg;
			String bgReg;

			if (rs.next()) {
				ogReg = rs.getString("og_reg");
				bgReg = rs.getString("bg_reg");
				if (ogReg != null && bgReg != null) {
					stmt = new StringBuffer();
					stmt.append("DELETE FROM mapping.bac_geometrie ");
					stmt.append("USING mapping.observation_geometrie as og, raw_data." + tableName + " as rd ");
					stmt.append("WHERE og.table_format = '" + format + "' ");
					stmt.append("AND og.id_observation = rd.ogam_id_" + format + " ");
					stmt.append("AND og.id_provider = rd.provider_id ");
					stmt.append("AND id_geometrie = og.id_geom ");
					stmt.append("AND submission_id = " + submissionId + ";");
					ps = con.prepareStatement(stmt.toString());
					logger.debug(stmt.toString());
					ps.executeUpdate();

				}
			}
			rs.close();
			ps.close();

		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}

	}
}
