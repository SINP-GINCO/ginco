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
package fr.ifn.ogam.common.database;

import static fr.ifn.ogam.common.business.UnitTypes.ARRAY;
import static fr.ifn.ogam.common.business.UnitTypes.BOOLEAN;
import static fr.ifn.ogam.common.business.UnitTypes.CODE;
import static fr.ifn.ogam.common.business.UnitTypes.DATE;
import static fr.ifn.ogam.common.business.UnitTypes.GEOM;
import static fr.ifn.ogam.common.business.UnitTypes.IMAGE;
import static fr.ifn.ogam.common.business.UnitTypes.INTEGER;
import static fr.ifn.ogam.common.business.UnitTypes.NUMERIC;
import static fr.ifn.ogam.common.business.UnitTypes.STRING;
import static fr.ifn.ogam.common.business.UnitTypes.TIME;
import static fr.ifn.ogam.common.business.checks.CheckCodes.DUPLICATE_ROW;
import static fr.ifn.ogam.common.business.checks.CheckCodes.INTEGRITY_CONSTRAINT;
import static fr.ifn.ogam.common.business.checks.CheckCodes.INVALID_GEOMETRY;
import static fr.ifn.ogam.common.business.checks.CheckCodes.INVALID_TYPE_FIELD;
import static fr.ifn.ogam.common.business.checks.CheckCodes.MANDATORY_FIELD_MISSING;
import static fr.ifn.ogam.common.business.checks.CheckCodes.STRING_TOO_LONG;
import static fr.ifn.ogam.common.business.checks.CheckCodes.TRIGGER_EXCEPTION;
import static fr.ifn.ogam.common.business.checks.CheckCodes.UNEXPECTED_SQL_ERROR;
import static fr.ifn.ogam.common.business.checks.CheckCodes.WRONG_GEOMETRY_SRID;
import static fr.ifn.ogam.common.business.checks.CheckCodes.WRONG_GEOMETRY_TYPE;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.postgis.PGgeometry;
import org.postgresql.util.PGobject;

import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.geom.Envelope;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.io.WKTReader;

import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.database.mapping.GeometryDAO;
import fr.ifn.ogam.common.database.metadata.TableFieldData;
import fr.ifn.ogam.common.util.SqlStateSQL99;

/**
 * Data Access Object allowing to acces the raw_data tables.
 */
public class GenericDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	// DAOs
	private GeometryDAO geometryDAO = new GeometryDAO();

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
	 * Insert a line of data in a destination table.
	 * 
	 * @param schema
	 *            the name of the schema
	 * @param tableFormat
	 *            the format of the destination table
	 * @param tableName
	 *            the name of the destination table
	 * @param tableColumns
	 *            the descriptor of the columns of the destination table
	 * @param valueColumns
	 *            the list of values to insert in the table
	 * @param userSrid
	 *            the srid given by the user
	 * @return id the id returned by the insert request
	 * 
	 * @throws Exception
	 */
	public String insertData(String schema, String tableFormat, String tableName, Map<String, TableFieldData> tableColumns,
			Map<String, GenericData> valueColumns, Integer userSrid) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Prepare the SQL values
			StringBuffer colNames = new StringBuffer();
			StringBuffer colValues = new StringBuffer();
			Iterator<String> columnsIter = tableColumns.keySet().iterator();
			while (columnsIter.hasNext()) {
				String sourceData = columnsIter.next();

				GenericData colData = valueColumns.get(sourceData);

				// If colData is null, the field is not mapped and is probably not expected (we hope)
				if (colData != null) {

					if (!colNames.toString().equalsIgnoreCase("")) {
						colNames.append(", ");
						colValues.append(", ");
					}

					colNames.append(colData.getColumnName());
					if (colData.getType().equalsIgnoreCase(GEOM)) {
						// TODO : Check the format
						if (colData.getValue() == null || colData.getValue().equals("")) {
							colValues.append("null");
						} else {

							if (colData.getValue().getClass().getName().equals("org.postgresql.util.PGobject")) {

								TableFieldData tableData = tableColumns.get(sourceData);
								Integer tableSrid = geometryDAO.getSRID(tableData.getTableName(), tableData.getColumnName());

								if (tableSrid.equals(userSrid)) {
									// copy directly the binary blob
									colValues.append("'" + colData.getValue().toString() + "'");
								} else {
									// transform imported geometry to match table srid
									PGgeometry pggeom = new PGgeometry(((PGobject) colData.getValue()).getValue());

									colValues.append("ST_Transform(ST_GeomFromText('" + pggeom.toString() + "', " + userSrid + "), " + tableSrid + ")");

								}

							} else {
								// Checks the WKT
								TableFieldData tableData = tableColumns.get(sourceData);
								checkGeomValidity(colData.getValue().toString(), tableData.getSubtype());

								String geomColValue = null;
								Integer tableSrid = geometryDAO.getSRID(tableData.getTableName(), tableData.getColumnName());
								if (tableSrid.equals(userSrid)) {
									geomColValue = "ST_GeomFromText('" + colData.getValue() + "', " + tableSrid + ")";
								} else {
									// transform imported geometry to match table srid
									geomColValue = "ST_Transform(ST_GeomFromText('" + colData.getValue() + "', " + userSrid + "), " + tableSrid + ")";
								}

								if (tableSrid == 4326) {
									// checks transformed geometry is in degrees
									String geom = geometryDAO.getGeomWktInTableSrid(geomColValue);
									checkGeomDegree(geom);
								}
								colValues.append(geomColValue);
							}
						}
					} else {
						colValues.append("?");
					}

				}
			}

			// Build the SQL INSERT
			String statement = "INSERT INTO " + tableName + " (" + colNames.toString() + ") VALUES (" + colValues.toString();
			// Return value of OGAM_ID if OGAM_ID key is present
			String ogamId = "OGAM_ID_" + tableFormat;
			if (tableColumns.keySet().contains(ogamId)) {
				statement += ") RETURNING " + ogamId + " AS id;";
			} else {
				statement += ");";
			}

			logger.trace(statement);

			// Prepare the statement
			ps = con.prepareStatement(statement);

			// Set the values
			columnsIter = tableColumns.keySet().iterator();
			int count = 1;
			while (columnsIter.hasNext()) {
				String sourceData = columnsIter.next();
				GenericData colData = valueColumns.get(sourceData);

				if (colData != null) {

					if (colData.getType().equalsIgnoreCase(STRING)) {
						ps.setString(count, (String) colData.getValue());
					} else if (colData.getType().equalsIgnoreCase(CODE)) {
						ps.setString(count, (String) colData.getValue());
					} else if (colData.getType().equalsIgnoreCase(IMAGE)) {
						ps.setString(count, (String) colData.getValue());
					} else if (colData.getType().equalsIgnoreCase(NUMERIC)) {
						if (colData.getValue() == null) {
							ps.setNull(count, java.sql.Types.DECIMAL);
						} else {
							ps.setBigDecimal(count, (BigDecimal) colData.getValue());
						}
					} else if (colData.getType().equalsIgnoreCase(INTEGER)) {
						if (colData.getValue() == null) {
							ps.setNull(count, java.sql.Types.INTEGER);
						} else {
							ps.setInt(count, (Integer) colData.getValue());
						}
					} else if (colData.getType().equalsIgnoreCase(DATE)) {
						if (colData.getValue() == null) {
							ps.setNull(count, java.sql.Types.DATE);
						} else {
							Date date = (Date) colData.getValue();
							ps.setTimestamp(count, new java.sql.Timestamp(date.getTime()));
						}
					} else if (colData.getType().equalsIgnoreCase(TIME)) {
						if (colData.getValue() == null) {
							ps.setNull(count, java.sql.Types.TIME);
						} else {
							Date date = (Date) colData.getValue();
							ps.setTime(count, new java.sql.Time(date.getTime()));
						}
					} else if (colData.getType().equalsIgnoreCase(BOOLEAN)) {
						if (colData.getValue() == null) {
							ps.setNull(count, java.sql.Types.BOOLEAN);
						} else {
							String bool = ((Boolean) colData.getValue()) ? "1" : "0";
							ps.setString(count, bool);
						}
					} else if (colData.getType().equalsIgnoreCase(ARRAY)) {
						if (colData.getValue() == null) {
							ps.setNull(count, java.sql.Types.ARRAY);
						} else {
							String[] value = (String[]) colData.getValue();
							java.sql.Array array = con.createArrayOf("varchar", value);
							ps.setArray(count, array);
						}
					} else if (colData.getType().equalsIgnoreCase(GEOM)) {
						// Do nothing and don't increment the count
						count--;
					} else {
						throw new Exception("Unexpected type");
					}

					count++;
				}

			}

			// Execute the query
			if (tableColumns.keySet().contains(ogamId)) {
				ResultSet rs = ps.executeQuery();
				rs.next();
				return rs.getString("id");
			} else {
				ps.execute();
				return null;
			}

		} catch (SQLException sqle) {

			// Log the exception
			logger.error("Error while inserting generic data", sqle);

			if (SqlStateSQL99.ERRCODE_UNIQUE_VIOLATION.equalsIgnoreCase(sqle.getSQLState())) {
				throw new CheckException(DUPLICATE_ROW);
			} else if (SqlStateSQL99.ERRCODE_DATATYPE_MISMATCH.equalsIgnoreCase(sqle.getSQLState())) {
				throw new CheckException(INVALID_TYPE_FIELD);
			} else if (SqlStateSQL99.ERRCODE_STRING_DATA_RIGHT_TRUNCATION.equalsIgnoreCase(sqle.getSQLState())) {
				throw new CheckException(STRING_TOO_LONG);
			} else if (SqlStateSQL99.ERRCODE_NOT_NULL_VIOLATION.equalsIgnoreCase(sqle.getSQLState())) {
				throw new CheckException(MANDATORY_FIELD_MISSING);
			} else if (SqlStateSQL99.ERRCODE_FOREIGN_KEY_VIOLATION.equalsIgnoreCase(sqle.getSQLState())) {
				String message = sqle.getMessage();
				// remove message header
				int pos = message.indexOf(": ");
				if (pos != -1) {
					message = message.substring(pos + 2);
				}
				CheckException ce = new CheckException(INTEGRITY_CONSTRAINT, message);
				throw ce;
			} else if (SqlStateSQL99.ERRCODE_TRIGGERED_ACTION_EXCEPTION.equalsIgnoreCase(sqle.getSQLState())) {
				String message = sqle.getMessage();
				// remove message header
				int pos = message.indexOf(": ");
				if (pos != -1) {
					message = message.substring(pos + 2);
				}
				throw new CheckException(TRIGGER_EXCEPTION, message);
			} else {
				logger.error("SQL STATE : " + sqle.getSQLState());
				String message = sqle.getMessage();
				throw new CheckException(UNEXPECTED_SQL_ERROR, message);
			}
		} catch (Exception e) {

			// Log the exception
			logger.error("Error while inserting generic data", e);

			// Rethrow e
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
				logger.error("Error while closing statement : " + e.getMessage());
			}
		}
	}

	/**
	 * Check that the string correspond to a valid geometry. And that the geometry type is the one expected in the database.
	 * 
	 * @param wkt
	 *            the geometry string
	 * @param geometryType
	 *            the expected geometry type (POINT, LINESTRING or POLYGON)
	 */
	private void checkGeomValidity(String wkt, String geometryType) throws CheckException {
		try {
			WKTReader wktReader = new WKTReader();
			Geometry geometry = wktReader.read(wkt);

			if (geometryType != null) {
				if (!geometry.getGeometryType().equalsIgnoreCase(geometryType)) {
					throw new CheckException(WRONG_GEOMETRY_TYPE,
							"Geometry type " + geometry.getGeometryType() + " does not correspond to expected geometry " + geometryType);
				}
			}
			// Do not accept GeometryCollection as geometry type
			if (geometry.getGeometryType().equalsIgnoreCase("GeometryCollection")) {
				throw new CheckException(WRONG_GEOMETRY_TYPE, "Geometry type " + geometry.getGeometryType() + " does not correspond to expected geometry."
						+ " Please use POINT, MULTIPOINT, LINESTRING, MULTILINESTRING, POLYGON, or MULTIPOLYGON");
			}

		} catch (ParseException pe) {
			throw new CheckException(INVALID_GEOMETRY);
		}

	}

	/**
	 * Check that the geometry is in degrees.
	 * 
	 * @param geomColValue
	 *            the geometry string
	 */
	private void checkGeomDegree(String geomColValue) throws CheckException {
		try {
			logger.trace("geomColValue (supposed in 4326) : " + geomColValue);
			WKTReader wktReader = new WKTReader();

			Geometry geometry = wktReader.read(geomColValue);
			Envelope envelope = geometry.getEnvelopeInternal();

			Double minx = envelope.getMinX();
			Double miny = envelope.getMinY();
			Double maxx = envelope.getMaxX();
			Double maxy = envelope.getMaxY();

			if (minx < -180 || miny < -90 || maxx > 180 || maxy > 90) {
				throw new CheckException(WRONG_GEOMETRY_SRID);
			}
		} catch (ParseException pe) {
			throw new CheckException(INVALID_GEOMETRY);
		}
	}

	/**
	 * Remove all data from a submission.
	 * 
	 * @param tableName
	 *            the name of the table
	 * @param submissionId
	 *            the identifier of the submission
	 */
	public void deleteRawData(String tableName, Integer submissionId) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		try {

			con = getConnection();

			// Build the SQL INSERT
			String statement = "DELETE FROM " + tableName + " WHERE submission_id  = ?";

			// Prepare the statement
			ps = con.prepareStatement(statement);

			// Set the values
			ps.setInt(1, submissionId);

			// Execute the query
			logger.trace(statement);
			ps.execute();

		} catch (SQLException sqle) {

			// log the exception
			logger.error("Error while deleting raw data", sqle);

			if (SqlStateSQL99.ERRCODE_FOREIGN_KEY_VIOLATION.equalsIgnoreCase(sqle.getSQLState())) {
				throw new CheckException(INTEGRITY_CONSTRAINT);
			}
		} catch (Exception e) {
			// log the exception
			logger.error("Error while deleting raw data", e);

			// Rethrow e
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

	/**
	 * Execute a generic SELECT SQL request and read the data.
	 * 
	 * @param statement
	 *            The SQL request to execute
	 * @param fields
	 *            The descriptors of the columns to read
	 * @return a list of result field
	 */
	public List<Map<String, GenericData>> readData(String statement, List<TableFieldData> fields) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<Map<String, GenericData>> result = new ArrayList<Map<String, GenericData>>();

		try {
			con = getConnection();
			ps = con.prepareStatement(statement);

			rs = ps.executeQuery();

			while (rs.next()) {

				Map<String, GenericData> resultLine = new TreeMap<String, GenericData>();

				Iterator<TableFieldData> fieldsIter = fields.iterator();
				while (fieldsIter.hasNext()) {
					TableFieldData field = fieldsIter.next();
					String columnName = field.getFormat() + "_" + field.getData();

					GenericData data = new GenericData();
					data.setColumnName(field.getColumnName());
					data.setFormat(field.getData());
					data.setType(field.getType());
					if (field.getType().equalsIgnoreCase(STRING)) {
						data.setValue(rs.getString(columnName));
					} else if (field.getType().equalsIgnoreCase(CODE)) {
						data.setValue(rs.getString(columnName));
					} else if (field.getType().equalsIgnoreCase(ARRAY)) {
						String val = rs.getString(columnName);
						if (val == null) {
							data.setValue(null);
						} else {
							java.sql.Array arrayRes = rs.getArray(columnName);
							Object arrayRes2 = arrayRes.getArray();
							String[] res = (String[]) arrayRes2; // Cast in a array of strings
							data.setValue(res);
						}

					} else if (field.getType().equalsIgnoreCase(IMAGE)) {
						data.setValue(rs.getString(columnName));
					} else if (field.getType().equalsIgnoreCase(GEOM)) {
						data.setValue(rs.getObject(columnName));
					} else if (field.getType().equalsIgnoreCase(NUMERIC)) {
						data.setValue(rs.getBigDecimal(columnName));
					} else if (field.getType().equalsIgnoreCase(INTEGER)) {
						data.setValue(rs.getInt(columnName));
					} else if (field.getType().equalsIgnoreCase(DATE) || field.getType().equalsIgnoreCase(TIME)) {
						String val = rs.getString(columnName);
						if (val == null) {
							data.setValue(null);
						} else {
							data.setValue(new Date(rs.getTimestamp(columnName).getTime()));
						}
					} else if (field.getType().equalsIgnoreCase(BOOLEAN)) {
						String val = rs.getString(columnName);
						if (val == null) {
							data.setValue(null);
						} else {
							if (val.equalsIgnoreCase("1")) {
								data.setValue(Boolean.TRUE);
							} else {
								data.setValue(Boolean.FALSE);
							}
						}
					} else {
						throw new Exception("Unexpected type : " + field.getType() + " for field " + field.getData());
					}

					resultLine.put(data.getFormat(), data);

				}

				result.add(resultLine);

			}

			return result;

		} catch (Exception e) {
			logger.trace(statement);
			logger.error("Error while reading generic data", e);
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

	/**
	 * Count the number of lines returned by a select statement.
	 * 
	 * @param statement
	 *            The SQL request to execute
	 * @return a list of result field
	 */
	public int countData(String statement) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = getConnection();
			ps = con.prepareStatement("SELECT COUNT(*) as count FROM (" + statement + ") as foo");

			rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt("count");
			} else {
				return 0;
			}

		} catch (Exception e) {
			logger.trace(statement);
			logger.error("Error while reading generic data", e);
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

	/**
	 * Closes a JDBC connection.
	 * 
	 * @throws Exception
	 */
	public void closeConnection() throws Exception {
		Connection con = getConnection();

		try {
			if (con != null) {
				con.close();
			}
		} catch (SQLException e) {
			logger.error("Error while closing connexion : " + e.getMessage());
		}
	}

	/**
	 * Executes any SQL query.
	 * 
	 * @param request
	 *            the request to execute
	 * @throws Exception
	 */
	public ResultSet executeQueryRequest(String request) throws Exception {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			con = getConnection();

			ps = con.prepareStatement(request);
			logger.trace(request);
			rs = ps.executeQuery();
		} catch (Exception e) {
			logger.error("Error while executing query request : ", e);
		}

		return rs;
	}

	/**
	 * Executes any INSERT, UPDATE or DELETE SQL query.
	 * 
	 * @param request
	 *            the request to execute
	 * @throws Exception
	 */
	public void executeUpdateRequest(String request) throws Exception {
		Connection con = null;
		PreparedStatement ps = null;

		try {

			con = getConnection();

			ps = con.prepareStatement(request);
			logger.trace(request);
			ps.executeUpdate();

		} catch (Exception e) {
			logger.error("Error while executing update request : ", e);
		}
	}

	/**
	 * 
	 * Returns the length of a geometry. If execution fails, will return -1.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param id
	 *            the ogam_id
	 * @param providerId
	 *            the provider_id
	 * @return the length of the geometry
	 * @throws Exception
	 */
	public float getGeometryLength(String format, String tableName, String id, String providerId) throws Exception {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		float result = -1;

		StringBuffer stmt = new StringBuffer();
		stmt.append("SELECT St_Length(geometrie) as length ");
		stmt.append("FROM raw_data." + tableName + " ");
		stmt.append("WHERE ogam_id_" + format + " = '" + id + "' ");
		stmt.append("AND provider_id = '" + providerId + "'");
		try {
			con = getConnection();

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();
			if (rs.next()) {
				result = rs.getFloat("length");
			}
			rs.close();
			ps.close();
			return result;
		} catch (Exception e) {
			logger.error("Error while executing update request : ", e);
			throw e;
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connection : " + e.getMessage());
			}
		}
	}

	/**
	 * 
	 * Returns the area of a geometry. If execution fails, will return -1.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param id
	 *            the ogam_id
	 * @param providerId
	 *            the provider_id
	 * @return the area of the geometry
	 * @throws Exception
	 */
	public float getGeometryArea(String format, String tableName, String id, String providerId) throws Exception {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		float result = -1;

		StringBuffer stmt = new StringBuffer();
		stmt.append("SELECT St_Area(geometrie) as area ");
		stmt.append("FROM raw_data." + tableName + " ");
		stmt.append("WHERE ogam_id_" + format + " = '" + id + "' ");
		stmt.append("AND provider_id = '" + providerId + "'");
		try {
			con = getConnection();

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();
			if (rs.next()) {
				result = rs.getInt("area");
			}
			rs.close();
			ps.close();

			return result;
		} catch (Exception e) {
			logger.error("Error while executing update request : ", e);
			throw e;
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				logger.error("Error while closing connection : " + e.getMessage());
			}
		}
	}
}
