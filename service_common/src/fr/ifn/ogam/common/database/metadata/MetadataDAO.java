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
package fr.ifn.ogam.common.database.metadata;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.util.LocalCache;
import fr.ifn.ogam.common.business.MappingTypes;
import fr.ifn.ogam.common.business.Schemas;

/**
 * Data Access Object used to access metadata.
 */
public class MetadataDAO {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * Local cache, for static data.
	 */
	private static LocalCache tableNamesCache = LocalCache.getLocalCache();
	private static LocalCache allTablesCache = LocalCache.getLocalCache();
	private static LocalCache modesCache = LocalCache.getLocalCache();
	private static LocalCache dynamodeSQLCache = LocalCache.getLocalCache();
	private static LocalCache dynamodeCache = LocalCache.getLocalCache();
	private static LocalCache taxrefmodeCache = LocalCache.getLocalCache();
	private static LocalCache modeExistCache = LocalCache.getLocalCache();
	private static LocalCache treemodeExistCache = LocalCache.getLocalCache();
	private static LocalCache rangeCache = LocalCache.getLocalCache();
	private static LocalCache fileFieldsCache = LocalCache.getLocalCache();
	private static LocalCache datasetFileCache = LocalCache.getLocalCache();
	private static LocalCache tableTreeCache = LocalCache.getLocalCache();

	/**
	 * Get the fields of a csv file format.
	 */
	private static final String GET_FILE_FIELDS_STMT = "SELECT file_field.*, data.label as label, data.unit, unit.type as type, unit.subtype as subtype, data.definition as definition "
			+ //
			" FROM file_field " + //
			" LEFT JOIN data on (file_field.data = data.data)" + //
			" LEFT JOIN unit on (data.unit = unit.unit)" + //
			" WHERE format = ? " + //
			" ORDER BY label_csv ASC";

	/**
	 * Get description of one field.
	 */
	private static final String GET_FILE_FIELD_STMT = "SELECT file_field.*, data.label as label, data.unit, unit.type as type, unit.subtype as subtype, data.definition as definition "
			+ //
			" FROM file_field " + //
			" LEFT JOIN data on (file_field.data = data.data) " + //
			" LEFT JOIN unit on (data.unit = unit.unit) " + //
			" WHERE data.data = ? ";
	
	/**
	 * Get description of one field from label.
	 */
	private static final String GET_FILE_FIELD_FROM_LABELCSV_STMT = "SELECT file_field.*, data.label as label, data.unit, unit.type as type, unit.subtype as subtype, data.definition as definition "
			+ //
			" FROM file_field " + //
			" LEFT JOIN data on (file_field.data = data.data) " + //
			" LEFT JOIN unit on (data.unit = unit.unit) " + //
			" WHERE file_field.label_csv = ? " + //
			" AND file_field.format = ? ";

	/**
	 * Get the fields of a table format.
	 */
	private static final String GET_TABLE_FIELDS_STMT = "SELECT table_field.*, table_name,  data.label, data.unit, unit.type, unit.subtype as subtype, data.definition "
			+ //
			" FROM table_format " + //
			" LEFT JOIN table_field on (table_field.format = table_format.format) " + //
			" LEFT JOIN data on (table_field.data = data.data) " + //
			" LEFT JOIN unit on (data.unit = unit.unit) " + //
			" WHERE table_format.format = ? ";

	/**
	 * Get the mandatory fields of a table format.
	 */
	private static final String GET_MANDATORY_TABLE_FIELDS_STMT = "SELECT table_field.*, table_name,  data.label, data.unit, unit.type, unit.subtype as subtype, data.definition "
			+ //
			" FROM table_format " + //
			" LEFT JOIN table_field on (table_field.format = table_format.format AND table_field.is_mandatory = '1') " + //
			" LEFT JOIN data on (table_field.data = data.data) " + //
			" LEFT JOIN unit on (data.unit = unit.unit) " + //
			" WHERE table_format.format = ? ";

	/**
	 * Get the description of one field of a table format.
	 */
	private static final String GET_TABLE_FIELD_STMT = "SELECT table_field.*, table_name, data.label, data.unit, unit.type, unit.subtype as subtype, data.definition "
			+ //
			" FROM table_format " + //
			" LEFT JOIN table_field on (table_field.format = table_format.format) " + //
			" LEFT JOIN data on (table_field.data = data.data) " + //
			" LEFT JOIN unit on (data.unit = unit.unit) " + //
			" WHERE table_format.format = ? " + //
			" AND   table_field.data = ? ";

	/**
	 * Get the destination columns of the file to table mapping.
	 */
	private static final String GET_FILE_TO_TABLE_MAPPING_STMT = "SELECT table_field.*, field_mapping.src_data, table_name, data.label, data.unit, unit.type, unit.subtype as subtype, data.definition "
			+ //
			" FROM field_mapping" + //
			" LEFT JOIN table_format on (field_mapping.dst_format = table_format.format) " + //
			" LEFT JOIN table_field on (field_mapping.dst_format = table_field.format and field_mapping.dst_data = table_field.data)" + //
			" LEFT JOIN data on (table_field.data = data.data) " + //
			" LEFT JOIN unit on (data.unit = unit.unit) " + //
			" WHERE field_mapping.src_format = ? " + //
			" AND   field_mapping.mapping_type = '" + MappingTypes.FILE_MAPPING + "'";

	/**
	 * Get the destination columns of the table to table mapping (harmonization).
	 */
	private static final String GET_TABLE_TO_TABLE_MAPPING_STMT = "SELECT table_field.*, table_name, data.label, data.unit, unit.type, unit.subtype as subtype, data.definition  "
			+ //
			" FROM field_mapping" + //
			" LEFT JOIN table_format on (field_mapping.dst_format = table_format.format) " + //
			" LEFT JOIN table_field on (field_mapping.dst_format = table_field.format and field_mapping.dst_data = table_field.data)" + //
			" LEFT JOIN data on (table_field.data = data.data) " + //
			" LEFT JOIN unit on (data.unit = unit.unit) " + //
			" WHERE field_mapping.src_format = ? " + //
			" AND   field_mapping.mapping_type = ?";

	/**
	 * Get the destination columns of the table to table mapping (harmonization).
	 */
	private static final String GET_DATASET_HARMONIZED_FIELDS_STMT = "SELECT table_field.*, field_mapping.src_data, table_name, data.label, data.unit, unit.type, unit.subtype as subtype, data.definition  "
			+ //
			" FROM field_mapping" + //
			" LEFT JOIN table_format on (field_mapping.dst_format = table_format.format) " + //
			" LEFT JOIN table_field on (field_mapping.dst_format = table_field.format and field_mapping.dst_data = table_field.data)" + //
			" LEFT JOIN data on (table_field.data = data.data) " + //
			" LEFT JOIN unit on (data.unit = unit.unit) " + //
			" WHERE field_mapping.dst_format = ? " + //
			" AND   field_mapping.mapping_type = '" + MappingTypes.HARMONIZATION_MAPPING + "'";

	/**
	 * Get the destination tables of the mapping.
	 */
	private static final String GET_FORMAT_MAPPING_STMT = "SELECT DISTINCT table_format.format as format, table_name " + //
			" FROM field_mapping" + //
			" LEFT JOIN table_format on (field_mapping.dst_format = table_format.format) " + //
			" WHERE field_mapping.src_format = ? " + //
			" AND   field_mapping.mapping_type = ? ";

	/**
	 * Get the source tables of the mapping.
	 */
	private static final String GET_SOUCE_FORMAT_MAPPING_STMT = "SELECT DISTINCT table_format.format as format, table_name " + //
			" FROM field_mapping" + //
			" LEFT JOIN table_format on (field_mapping.src_format = table_format.format) " + //
			" WHERE field_mapping.dst_format = ? " + //
			" AND   field_mapping.mapping_type = ? ";

	/**
	 * Get type of a field.
	 */
	private static final String GET_TYPE_STMT = "SELECT type " + //
			" FROM unit " + //
			" LEFT JOIN data on (data.unit = unit.unit)" + //
			" WHERE data.data = ? ";

	/**
	 * Get the list of modes of a given unit.
	 */
	private static final String GET_MODES_STMT = "SELECT code, label FROM mode WHERE unit = ? ORDER BY position, code";

	/**
	 * Get the list of modes of a given unit from a taxonomic referential.
	 */
	private static final String GET_TAXREF_MODES_STMT = "SELECT code, label FROM mode_taxref ORDER BY code";

	/**
	 * Get the name associated with the code from a taxonomic referential.
	 */
	private static final String GET_TAXREF_NAME_FROM_CODE_STMT = "SELECT nom_valide FROM referentiels.taxref WHERE cd_nom = ?";

	/**
	 * Get the one mode of a given unit.
	 */
	private static final String GET_MODE_STMT = "SELECT label FROM mode WHERE unit = ? AND code = ?";

	/**
	 * Check if a mode exists.
	 */
	private static final String CHECK_MODE_EXIST_STMT = "SELECT code FROM mode WHERE unit = ? AND code = ?";

	/**
	 * Check if a tree mode exists.
	 */
	private static final String CHECK_TREE_MODE_EXIST_STMT = "SELECT code FROM mode_tree WHERE unit = ? AND code = ?";

	/**
	 * Get a range value.
	 */
	private static final String GET_RANGE_STMT = "SELECT min, max FROM range WHERE unit = ?";

	/**
	 * Get a dynamic mode SQL request.
	 */
	private static final String GET_DYNAMODE_SQL_STMT = "SELECT sql FROM dynamode WHERE unit = ?";

	/**
	 * Get the table physical name.
	 */
	private static final String GET_TABLE_FORMAT_STMT = "SELECT * FROM table_format WHERE format = ?";

	/**
	 * Get all the tables physical names.
	 */
	private static final String GET_ALL_TABLE_FORMAT_STMT = "SELECT * FROM table_format tf JOIN model_tables mt ON mt.table_id = tf.format JOIN model m ON m.id = mt.model_id WHERE m.created_at IS NOT NULL ";

	/**
	 * Get the list of available datasets.
	 */
	private static final String GET_DATASET_STMT = "SELECT dataset_id, label FROM dataset";

	/**
	 * Get the tables used by a given dataset.
	 */
	private static final String GET_DATASET_TABLES_STMT = "SELECT DISTINCT dst_format as format " + //
			" FROM dataset_files " + //
			" LEFT JOIN field_mapping on (dataset_files.format = field_mapping.src_format and mapping_type = 'FILE') " + //
			" WHERE dataset_id = ? ";

	/**
	 * Get the expected file formats for a dataset.
	 */
	private static final String GET_DATASET_FORMATS_STMT = "SELECT file_format.* " + //
			"FROM dataset_files " + //
			"LEFT JOIN file_format USING (format) " + //
			"WHERE dataset_id = ? " + //
			"ORDER BY position";

	/**
	 * Get the description of the table in the tables hierarchie.
	 */
	private static final String GET_TABLE_TREE_STMT = "SELECT child_table, parent_table, join_key " + //
			" FROM table_tree " + //
			" WHERE child_table = ? " + //
			" AND schema_code = ?";

	/**
	 * Get the cdref value from given cdnom.
	 */
	private static final String GET_CDREF_FROM_CDNOM = "SELECT cd_ref FROM referentiels.taxref WHERE cd_nom = ?" ;
	
	/**
	 * Get standard from dataset.
	 */
	private static final String GET_STANDARD_FROM_DATASET_STMT = "SELECT s.* " + // 
			" FROM standard s " + //
			" INNER JOIN model m ON s.name = m.standard " + //
			" INNER JOIN model_datasets md ON m.id = md.model_id " + //
			" WHERE md.dataset_id = ?";
	
	
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
	 * Return the table format a logical table.
	 * 
	 * @param format
	 *            the logical name of a table (ex : "LOCATION_DATA")
	 * @return table format descriptor
	 */
	public TableFormatData getTableFormat(String format) throws Exception {
		TableFormatData result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		result = (TableFormatData) tableNamesCache.get(format);

		if (result == null) {

			try {

				con = getConnection();

				ps = con.prepareStatement(GET_TABLE_FORMAT_STMT);
				ps.setString(1, format);
				logger.trace(GET_TABLE_FORMAT_STMT);
				logger.trace("format : " + format);
				rs = ps.executeQuery();

				if (rs.next()) {
					result = new TableFormatData();
					result.setFormat(format);
					result.setTableName(rs.getString("table_name"));
					result.setSchemaCode(rs.getString("schema_code"));
					result.setLabel(rs.getString("label"));
					String primaryKeys = rs.getString("primary_key");
					if (primaryKeys != null) {
						StringTokenizer tokenizer = new StringTokenizer(primaryKeys, ",");
						while (tokenizer.hasMoreTokens()) {
							result.addPrimaryKey(tokenizer.nextToken());
						}
					}
				}

				tableNamesCache.put(format, result);

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

		return result;
	}

	/**
	 * Return all the table formats.
	 * 
	 * @return list of table format descriptor
	 */
	public List<TableFormatData> getAllTables() throws Exception {
		TableFormatData table = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		Object cacheTables = "allTables";
		List<TableFormatData> result = (List<TableFormatData>) allTablesCache.get(cacheTables);

		if (result == null || result.isEmpty()) {

			result = new ArrayList<TableFormatData>();

			try {
				con = getConnection();

				ps = con.prepareStatement(GET_ALL_TABLE_FORMAT_STMT);
				logger.trace(GET_ALL_TABLE_FORMAT_STMT);
				rs = ps.executeQuery();

				while (rs.next()) {
					table = new TableFormatData();
					table.setFormat(rs.getString("format"));
					table.setTableName(rs.getString("table_name"));
					table.setSchemaCode(rs.getString("schema_code"));
					String primaryKeys = rs.getString("primary_key");
					if (primaryKeys != null) {
						StringTokenizer tokenizer = new StringTokenizer(primaryKeys, ",");
						while (tokenizer.hasMoreTokens()) {
							table.addPrimaryKey(tokenizer.nextToken());
						}
					}
					result.add(table);
				}

				allTablesCache.put(cacheTables, result);

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

		return result;
	}

	/**
	 * Return all the available datasets.
	 * 
	 * @return The list of available datasets
	 */
	public List<DatasetData> getDatasets() throws Exception {
		List<DatasetData> result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			result = new ArrayList<DatasetData>();

			con = getConnection();

			ps = con.prepareStatement(GET_DATASET_STMT);
			logger.trace(GET_DATASET_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				DatasetData request = new DatasetData();
				request.setRequestId(rs.getString("dataset_id"));
				request.setLabel(rs.getString("label"));
				result.add(request);
			}

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
	 * Check that a code value correspond to an existing code (used during conformity checking).
	 * 
	 * @param unit
	 *            The unit to test
	 * @param mode
	 *            The mode to test
	 * @return true if the mode exist for this unit
	 */
	public boolean checkCode(String unit, String mode) throws Exception {
		boolean result = false;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			String key = unit + "_" + mode;
			Object foundValue = modeExistCache.get(key);

			if (foundValue != null) {
				return true;
			} else {

				con = getConnection();

				ps = con.prepareStatement(CHECK_MODE_EXIST_STMT);
				ps.setString(1, unit);
				ps.setString(2, mode);
				logger.trace(CHECK_MODE_EXIST_STMT);
				rs = ps.executeQuery();

				if (rs.next()) {
					modeExistCache.put(key, rs.getString(1));
					result = true;
				}

			}

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
	 * Check that a code value correspond to an existing code (used during conformity checking).
	 * 
	 * @param unit
	 *            The unit to test
	 * @param mode
	 *            The mode to test
	 * @return true if the mode exist for this unit
	 */
	public boolean checkTreeCode(String unit, String mode) throws Exception {
		boolean result = false;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			String key = unit + "_" + mode;
			Object foundValue = treemodeExistCache.get(key);

			if (foundValue != null) {
				return true;
			} else {

				con = getConnection();

				ps = con.prepareStatement(CHECK_TREE_MODE_EXIST_STMT);
				ps.setString(1, unit);
				ps.setString(2, mode);
				logger.trace(CHECK_TREE_MODE_EXIST_STMT);
				rs = ps.executeQuery();

				if (rs.next()) {
					treemodeExistCache.put(key, rs.getString(1));
					result = true;
				}

			}

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
	 * Get a range for a unit.
	 * 
	 * @param unit
	 *            The unit of type RANGE (example : "PH")
	 * @return The range of the unit
	 */
	public RangeData getRange(String unit) throws Exception {
		RangeData result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			result = (RangeData) rangeCache.get(unit);

			if (result == null) {

				con = getConnection();

				ps = con.prepareStatement(GET_RANGE_STMT);
				ps.setString(1, unit);
				logger.trace(GET_RANGE_STMT);
				rs = ps.executeQuery();

				if (rs.next()) {
					result = new RangeData();
					result.setMinValue(rs.getBigDecimal("min"));
					result.setMaxValue(rs.getBigDecimal("max"));
				}

				rangeCache.put(unit, result);

			}

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
	 * Get a SQL request to execute for a unit.
	 * 
	 * @param unit
	 *            The unit of type CODE and subtype DYNAMODE
	 * @return The SQL request to run
	 */
	private String getDynamodeSQL(String unit) throws Exception {
		String result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			result = (String) dynamodeSQLCache.get(unit);

			if (result == null) {

				con = getConnection();

				ps = con.prepareStatement(GET_DYNAMODE_SQL_STMT);
				ps.setString(1, unit);
				logger.trace(GET_DYNAMODE_SQL_STMT);
				rs = ps.executeQuery();

				if (rs.next()) {
					result = rs.getString("sql");
					dynamodeSQLCache.put(unit, result);
				} else {
					throw new Exception("No SQL query found for the modes of unit " + unit);
				}

			}

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
	 * Get one mode for a unit.
	 * 
	 * @param unit
	 *            The unit of type MODE (example : "COUNTRY_CODE");
	 * @param code
	 *            The code of type MODE (example : "01");
	 * @return the mode label.
	 */
	public String getMode(String unit, String code) throws Exception {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_MODE_STMT);
			ps.setString(1, unit);
			ps.setString(2, code);
			logger.trace(GET_MODE_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = rs.getString("label");
			}

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
	 * Get the list of available modes for a unit.
	 * 
	 * @param unit
	 *            The unit of type MODE (example : "COUNTRY_CODE");
	 * @return the list of modes
	 */
	public List<ModeData> getModes(String unit) throws Exception {
		List<ModeData> result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			result = (List<ModeData>) modesCache.get(unit);

			if (result == null) {

				result = new ArrayList<ModeData>();

				con = getConnection();

				ps = con.prepareStatement(GET_MODES_STMT);
				ps.setString(1, unit);
				logger.trace(GET_MODES_STMT);
				rs = ps.executeQuery();

				while (rs.next()) {
					ModeData mode = new ModeData();
					mode.setMode(rs.getString("code"));
					mode.setLabel(rs.getString("label"));
					result.add(mode);
				}

				modesCache.put(unit, result);

			}

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
	 * Get the type of a data.
	 * 
	 * @param data
	 *            the data object (example : "BASAL_AREA")
	 * @return the type of the data (example : "NUMERIC");
	 */
	public String getType(String data) throws Exception {
		String result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_TYPE_STMT);
			ps.setString(1, data);
			logger.trace(GET_TYPE_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = rs.getString("type");
			}

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
	 * Get the description of the fields of a table.
	 * 
	 * @param tableformat
	 *            the logical name of the table
	 * @return the list of fields of the table
	 */
	public Map<String, TableFieldData> getTableFields(String tableformat) throws Exception {
		Map<String, TableFieldData> result = new HashMap<String, TableFieldData>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			String req = GET_TABLE_FIELDS_STMT;
			logger.trace(req);

			ps = con.prepareStatement(req);
			ps.setString(1, tableformat);
			rs = ps.executeQuery();

			while (rs.next()) {
				TableFieldData field = new TableFieldData();
				field.setData(rs.getString("data"));
				field.setFormat(rs.getString("format"));
				field.setType(rs.getString("type"));
				field.setSubtype(rs.getString("subtype"));
				field.setUnit(rs.getString("unit"));
				field.setColumnName(rs.getString("column_name"));
				field.setTableName(rs.getString("table_name"));
				field.setDefinition(rs.getString("definition"));
				field.setLabel(rs.getString("label"));
				field.setDefaultValue(rs.getString("default_value"));
				String iscalculated = rs.getString("is_calculated");
				if (iscalculated != null) {
					field.setIsCalculated(iscalculated.equalsIgnoreCase("1"));
				}

				result.put(field.getData(), field);
			}

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
	 * Get the list of the mandatory fields of a table.
	 *
	 * @param tableformat
	 *            the logical name of the table
	 * @return the list of madnatory fields of the table
	 */
	public List<TableFieldData> getMandatoryTableFields(String tableformat) throws Exception {
		List<TableFieldData> result = new ArrayList<TableFieldData>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			String req = GET_MANDATORY_TABLE_FIELDS_STMT;
			logger.trace(req);

			ps = con.prepareStatement(req);
			ps.setString(1, tableformat);
			rs = ps.executeQuery();

			while (rs.next()) {
				TableFieldData field = new TableFieldData();
				field.setData(rs.getString("data"));
				String isMandatory = rs.getString("is_mandatory");
				if (isMandatory != null) {
					field.setIsMandatory(isMandatory.equalsIgnoreCase("1"));
				}
				String iscalculated = rs.getString("is_calculated");
				if (iscalculated != null) {
					field.setIsCalculated(iscalculated.equalsIgnoreCase("1"));
				}

				result.add(field);
			}

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
	 * Get the description of one field of a table.
	 * 
	 * @param tableformat
	 *            the logical name of the table
	 * @param data
	 *            the logical name of the field
	 * @return the field of the table
	 */
	public TableFieldData getTableField(String tableformat, String data) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_TABLE_FIELD_STMT);
			ps.setString(1, tableformat);
			ps.setString(2, data);
			logger.trace(GET_TABLE_FIELD_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				TableFieldData field = new TableFieldData();
				field.setData(rs.getString("data"));
				field.setFormat(rs.getString("format"));
				field.setType(rs.getString("type"));
				field.setSubtype(rs.getString("subtype"));
				field.setUnit(rs.getString("unit"));
				field.setColumnName(rs.getString("column_name"));
				field.setTableName(rs.getString("table_name"));
				field.setDefinition(rs.getString("definition"));
				field.setLabel(rs.getString("label"));
				field.setDefaultValue(rs.getString("default_value"));
				String iscalculated = rs.getString("is_calculated");
				if (iscalculated != null) {
					field.setIsCalculated(iscalculated.equalsIgnoreCase("1"));
				}
				return field;
			} else {
				return null;
			}

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
	 * Get the description of one File Field.
	 * 
	 * @param data
	 *            the logical name of the data corresponding to the field
	 * @return the field descriptor
	 */
	public FileFieldData getFileField(String data) throws Exception {
		FileFieldData result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_FILE_FIELD_STMT);
			ps.setString(1, data);
			logger.trace(GET_FILE_FIELD_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = new FileFieldData();
				result.setData(rs.getString("data"));
				result.setFormat(rs.getString("format"));
				result.setLabel(rs.getString("label"));
				result.setUnit(rs.getString("unit"));
				result.setType(rs.getString("type"));
				result.setSubtype(rs.getString("subtype"));
				result.setDefinition(rs.getString("definition"));
				result.setIsMandatory(rs.getBoolean("is_mandatory"));
				result.setMask(rs.getString("mask"));
				result.setDefaultValue(rs.getString("default_value"));				
			}

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
	 * Get the description of one File Field having is label.
	 * 
	 * @param labelCSV
	 *            the label_csv of the file_field
	 * @param fileFormat 
	 *      
	 * @return the field descriptor
	 */
	public FileFieldData getFileFieldFromLabelCSV(String labelCSV, String fileFormat) throws Exception {
		FileFieldData result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();
						
			ps = con.prepareStatement(GET_FILE_FIELD_FROM_LABELCSV_STMT);
			ps.setString(1, labelCSV);
			ps.setString(2, fileFormat);
			logger.trace(GET_FILE_FIELD_FROM_LABELCSV_STMT);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = new FileFieldData();
				result.setData(rs.getString("data"));
				result.setFormat(rs.getString("format"));
				result.setLabel(rs.getString("label"));
				result.setLabelCSV(rs.getString("label_csv"));
				result.setUnit(rs.getString("unit"));
				result.setType(rs.getString("type"));
				result.setSubtype(rs.getString("subtype"));
				result.setDefinition(rs.getString("definition"));
				result.setIsMandatory(rs.getBoolean("is_mandatory"));
				result.setMask(rs.getString("mask"));
				result.setDefaultValue(rs.getString("default_value"));
				
			}
			
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
	 * Get the list of the mandatory fields of a file_format.
	 *
	 * @param fileformat
	 *            the logical name of the file
	 * @return the list of field descriptors
	 */
	public List<FileFieldData> getFileFields(String fileformat) throws Exception {
		List<FileFieldData> result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			String key = fileformat;
			result = (List<FileFieldData>) fileFieldsCache.get(key);

			if (result == null) {

				result = new ArrayList<FileFieldData>();

				con = getConnection();

				ps = con.prepareStatement(GET_FILE_FIELDS_STMT);
				ps.setString(1, fileformat);
				logger.trace(GET_FILE_FIELDS_STMT);
				rs = ps.executeQuery();

				while (rs.next()) {
					FileFieldData field = new FileFieldData();
					field.setData(rs.getString("data"));
					field.setFormat(rs.getString("format"));
					field.setLabel(rs.getString("label"));
					field.setLabelCSV(rs.getString("label_csv"));
					field.setUnit(rs.getString("unit"));
					field.setType(rs.getString("type"));
					field.setSubtype(rs.getString("subtype"));
					field.setDefinition(rs.getString("definition"));
					field.setIsMandatory(rs.getBoolean("is_mandatory"));
					field.setMask(rs.getString("mask"));
					field.setDefaultValue(rs.getString("default_value"));
					result.add(field);
					logger.debug(rs.getString("data"));
				}

				fileFieldsCache.put(key, result);

			}

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
	 * Get the CSV Files composing a dataset.
	 * 
	 * @param datasetId
	 *            the identifier of the dataset
	 * @return the list of file descriptors
	 */
	public List<FileFormatData> getDatasetFiles(String datasetId) throws Exception {
		List<FileFormatData> result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			result = (List<FileFormatData>) datasetFileCache.get(datasetId);

			if (result == null) {

				result = new ArrayList<FileFormatData>();

				con = getConnection();

				ps = con.prepareStatement(GET_DATASET_FORMATS_STMT);
				ps.setString(1, datasetId);
				logger.trace(GET_DATASET_FORMATS_STMT);
				rs = ps.executeQuery();

				while (rs.next()) {
					FileFormatData fileformat = new FileFormatData();
					fileformat.setFormat(rs.getString("format"));
					fileformat.setFileType(rs.getString("file_type"));
					fileformat.setFileExtension(rs.getString("file_extension"));
					fileformat.setLabel(rs.getString("label"));
					fileformat.setPosition(rs.getInt("position"));
					result.add(fileformat);
				}

				datasetFileCache.put(datasetId, result);

			}

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
	 * Get the destination tables for a given source format (a file).
	 * 
	 * @param sourceformat
	 *            the logical name of a file format
	 * @param mappingType
	 *            the type of mapping
	 * @return a map where we have for each logical name of a destination table the corresponding table descriptor
	 */
	public Map<String, TableFormatData> getFormatMapping(String sourceformat, String mappingType) throws Exception {
		Map<String, TableFormatData> result = new HashMap<String, TableFormatData>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_FORMAT_MAPPING_STMT);
			ps.setString(1, sourceformat);
			ps.setString(2, mappingType);

			logger.trace(GET_FORMAT_MAPPING_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				TableFormatData format = new TableFormatData();

				// format, table_name
				format.setFormat(rs.getString("format"));
				format.setTableName(rs.getString("table_name"));
				result.put(format.getFormat(), format);
			}

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
	 * Get the source tables for a given destination format.
	 * 
	 * @param destformat
	 *            the logical name of a file format
	 * @param mappingType
	 *            the type of mapping
	 * @return a map where we have for each logical name of a destination table the corresponding table descriptor
	 */
	public Map<String, TableFormatData> getSourceTablesMapping(String destformat, String mappingType) throws Exception {
		Map<String, TableFormatData> result = new HashMap<String, TableFormatData>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_SOUCE_FORMAT_MAPPING_STMT);
			ps.setString(1, destformat);
			ps.setString(2, mappingType);

			logger.trace(GET_SOUCE_FORMAT_MAPPING_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				TableFormatData format = new TableFormatData();

				// format, table_name
				format.setFormat(rs.getString("format"));
				format.setTableName(rs.getString("table_name"));
				result.put(format.getFormat(), format);
			}

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
	 * Get the destination columns of a mapping (a file).
	 * 
	 * @param sourceformat
	 *            the logical name of a file format
	 * @return a map where we have the list of destination table fields indexed by the logical name
	 */
	public Map<String, TableFieldData> getFileToTableMapping(String sourceformat) throws Exception {
		Map<String, TableFieldData> result = new HashMap<String, TableFieldData>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_FILE_TO_TABLE_MAPPING_STMT);
			ps.setString(1, sourceformat);

			logger.trace(GET_FILE_TO_TABLE_MAPPING_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				TableFieldData field = new TableFieldData();
				field.setData(rs.getString("data"));
				field.setFormat(rs.getString("format"));
				field.setType(rs.getString("type"));
				field.setSubtype(rs.getString("subtype"));
				field.setUnit(rs.getString("unit"));
				field.setColumnName(rs.getString("column_name"));
				field.setTableName(rs.getString("table_name"));
				field.setDefinition(rs.getString("definition"));
				field.setLabel(rs.getString("label"));
				field.setDefaultValue(rs.getString("default_value"));
				String iscalculated = rs.getString("is_calculated");
				if (iscalculated != null) {
					field.setIsCalculated(iscalculated.equalsIgnoreCase("1"));
				}

				String sourceData = rs.getString("src_data");

				result.put(sourceData, field);
			}

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
	 * Get the destination columns of a mapping (a file).
	 * 
	 * @param sourceTable
	 *            the logical name of a table format
	 * @param mappingType
	 *            the mapping type (HARMONIZATION_MAPPING)
	 * @return a map where we have the list of destination table fields indexed by the logical name
	 */
	public Map<String, TableFieldData> getTableToTableFieldMapping(String sourceTable, String mappingType) throws Exception {
		Map<String, TableFieldData> result = new HashMap<String, TableFieldData>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_TABLE_TO_TABLE_MAPPING_STMT);
			ps.setString(1, sourceTable);
			ps.setString(2, mappingType);

			logger.trace(GET_TABLE_TO_TABLE_MAPPING_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				TableFieldData field = new TableFieldData();
				field.setData(rs.getString("data"));
				field.setFormat(rs.getString("format"));
				field.setType(rs.getString("type"));
				field.setSubtype(rs.getString("subtype"));
				field.setUnit(rs.getString("unit"));
				field.setColumnName(rs.getString("column_name"));
				field.setTableName(rs.getString("table_name"));
				field.setDefinition(rs.getString("definition"));
				field.setLabel(rs.getString("label"));
				field.setDefaultValue(rs.getString("default_value"));
				String iscalculated = rs.getString("is_calculated");
				if (iscalculated != null) {
					field.setIsCalculated(iscalculated.equalsIgnoreCase("1"));
				}

				result.put(field.getData(), field);
			}

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
	 * Get the destination columns of a mapping (a file).
	 * 
	 * @param destTable
	 *            the logical name of the harmonized table format
	 * @return a map where we have the list of destination table fields indexed by the logical name of the source data
	 */
	public Map<String, TableFieldData> getDatasetHarmonizedFields(String destTable) throws Exception {
		Map<String, TableFieldData> result = new HashMap<String, TableFieldData>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_DATASET_HARMONIZED_FIELDS_STMT);
			ps.setString(1, destTable);

			logger.trace(GET_DATASET_HARMONIZED_FIELDS_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				TableFieldData field = new TableFieldData();
				field.setData(rs.getString("data"));
				field.setFormat(rs.getString("format"));
				field.setType(rs.getString("type"));
				field.setSubtype(rs.getString("subtype"));
				field.setUnit(rs.getString("unit"));
				field.setColumnName(rs.getString("column_name"));
				field.setTableName(rs.getString("table_name"));
				field.setDefinition(rs.getString("definition"));
				field.setLabel(rs.getString("label"));
				field.setDefaultValue(rs.getString("default_value"));
				String iscalculated = rs.getString("is_calculated");
				if (iscalculated != null) {
					field.setIsCalculated(iscalculated.equalsIgnoreCase("1"));
				}

				String sourceData = rs.getString("src_data");
				result.put(sourceData, field);
			}

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
	 * Get the descriptor of one table.
	 * 
	 * @param tableFormat
	 *            the logical name of a table (example : "LOCATION")
	 * @param schemaCode
	 *            the name of a schema (example : "RAW_DATA")
	 * @return the descriptor of the table
	 */
	public TableTreeData getTableDescriptor(String tableFormat, String schemaCode) throws Exception {

		// The descriptor of the table is always the first item of the table hierarchy
		return getTablesTree(tableFormat, schemaCode).get(0);
	}

	/**
	 * Get the hierarchy of tables from the specified table format to the root ancestor.
	 * 
	 * @param tableFormat
	 *            the logical name of a table (example : "LOCATION")
	 * @param schemaCode
	 *            the name of a schema (example : "RAW_DATA")
	 * @return the list of ancestors of the table with the join keys for each ancestor
	 */
	public List<TableTreeData> getTablesTree(String tableFormat, String schemaCode) throws Exception {
		List<TableTreeData> result = null;
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		String key = "TablesTreeCache_" + tableFormat + "_" + schemaCode;
		result = (List<TableTreeData>) tableTreeCache.get(key);

		if (result == null) {

			result = new ArrayList<TableTreeData>();

			try {

				con = getConnection();

				ps = con.prepareStatement(GET_TABLE_TREE_STMT);
				ps.setString(1, tableFormat);
				ps.setString(2, schemaCode);

				logger.trace(GET_TABLE_TREE_STMT);
				logger.trace("tableFormat : " + tableFormat);
				logger.trace("schemaCode : " + schemaCode);
				rs = ps.executeQuery();

				if (rs.next()) {

					TableTreeData table = new TableTreeData();
					String childTable = rs.getString("child_table");
					table.setTable(getTableFormat(childTable));
					String parentTable = rs.getString("parent_table");
					if (parentTable != null) {
						table.setParentTable(getTableFormat(parentTable));
					}
					String keys = rs.getString("join_key");
					if (keys != null) {
						StringTokenizer tokenizer = new StringTokenizer(keys, ",");
						while (tokenizer.hasMoreTokens()) {
							table.addKey(tokenizer.nextToken());
						}
					}

					result.add(table);

					// Recursively call the function
					if (table.getParentTable() != null && !table.getParentTable().getFormat().equals("*")) {
						result.addAll(getTablesTree(table.getParentTable().getFormat(), schemaCode));
					}
				}

				tableTreeCache.put(key, result);

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
		return result;
	}

	/**
	 * Get the raw_data tables used by a dataset.
	 * 
	 * @param datasetId
	 *            the identifier of the dataset
	 * @return the list of table logical names
	 */
	public List<String> getDatasetRawTables(String datasetId) throws Exception {
		List<String> result = new ArrayList<String>();
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			con = getConnection();

			ps = con.prepareStatement(GET_DATASET_TABLES_STMT);
			ps.setString(1, datasetId);
			logger.trace(GET_DATASET_TABLES_STMT);
			rs = ps.executeQuery();

			while (rs.next()) {
				result.add(rs.getString("format"));
			}

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
	 * Get a list of modes for a unit using a dynamic list.
	 * 
	 * @param sql
	 *            the SQL query used to generate the dynamic list
	 * @return List<String> the list of modes
	 */
	public List<String> getDynamodes(String unit) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			List<String> result = (List<String>) dynamodeCache.get(unit);

			// If cache is empty
			if (result == null) {

				result = new ArrayList<String>();

				con = getConnection();

				// Get the SQL used to extract a list
				String sql = getDynamodeSQL(unit);
				logger.trace(sql);

				// Execute the statement
				ps = con.prepareStatement(sql);
				rs = ps.executeQuery();

				while (rs.next()) {
					result.add(rs.getString(1)); // We expect the first column to contain the code
				}

				// fill the cache
				dynamodeCache.put(unit, result);

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
	 * Get a list of modes for a taxonomic referential.
	 * 
	 * @param unit
	 *            the unit
	 * @return List<String> the list of modes
	 */
	public List<String> getTaxrefCode(String unit) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			List<String> result = (List<String>) taxrefmodeCache.get(unit);

			// If cache is empty
			if (result == null) {

				result = new ArrayList<String>();

				con = getConnection();

				// Execute the statement
				ps = con.prepareStatement(GET_TAXREF_MODES_STMT);
				rs = ps.executeQuery();

				while (rs.next()) {
					result.add(rs.getString("code"));
				}

				// fill the cache
				taxrefmodeCache.put(unit, result);

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
	 * Get the cdref associated to the cdnom.
	 * 
	 * @param cdnom the cd_nom
	 * @return String the cd_ref
	 */
	public String getCdrefFromCdnom(String cdnom) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			String result = new String() ;

			con = getConnection();

			// Execute the statement
			ps = con.prepareStatement(GET_CDREF_FROM_CDNOM);
			ps.setString(1, cdnom);
			rs = ps.executeQuery();

			if (rs.next()) {
				result = rs.getString("cd_ref") ;
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
	 * Get the name associated with the code given in mode_taxref table.
	 * 
	 * @param code
	 *            the cd_ref or cd_nom
	 * @return String the name associated with the code given
	 */
	public List<String> getNameFromTaxrefCode(String code) throws Exception {

		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			List<String> result = new ArrayList<String>();

			con = getConnection();

			// Execute the statement
			ps = con.prepareStatement(GET_TAXREF_NAME_FROM_CODE_STMT);
			ps.setString(1, code);
			rs = ps.executeQuery();

			while (rs.next()) {
				result.add(rs.getString("nom_valide"));
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
	 * Get standard from dataset
	 * @param datasetId the dataset ID
	 * @return StandardData
	 * @throws Exception
	 */
	public StandardData getStandardFromDataset(String datasetId) throws Exception {
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			StandardData standard = new StandardData() ;

			con = getConnection();

			// Execute the statement
			ps = con.prepareStatement(GET_STANDARD_FROM_DATASET_STMT);
			ps.setString(1, datasetId);
			rs = ps.executeQuery();

			
			while (rs.next()) {
				standard.setName(rs.getString("name")) ;
				standard.setLabel(rs.getString("label")) ;
				standard.setVersion(rs.getString("version")) ;
			}

			return standard ;

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
	 * Clear the local caches, to reset the metadata.
	 */
	public void clearCaches() {

		tableNamesCache.reset();
		modesCache.reset();
		dynamodeSQLCache.reset();
		dynamodeCache.reset();
		taxrefmodeCache.reset();
		modeExistCache.reset();
		treemodeExistCache.reset();
		rangeCache.reset();
		fileFieldsCache.reset();
		datasetFileCache.reset();
		tableTreeCache.reset();

		logger.debug("Local caches cleaned");
	}
}
