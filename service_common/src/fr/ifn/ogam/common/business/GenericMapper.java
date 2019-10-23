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
package fr.ifn.ogam.common.business;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.util.SIGUtils;
import fr.ifn.ogam.common.util.SynchronizedDateFormat;
import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.database.metadata.FieldData;
import fr.ifn.ogam.common.database.metadata.FileFieldData;
import fr.ifn.ogam.common.database.metadata.MetadataDAO;
import fr.ifn.ogam.common.database.metadata.RangeData;
import fr.ifn.ogam.common.database.metadata.TableFieldData;
import fr.ifn.ogam.common.database.metadata.TableFormatData;
import fr.ifn.ogam.common.database.metadata.TableTreeData;
import fr.ifn.ogam.common.database.GenericDAO;
import fr.ifn.ogam.common.database.GenericData;
import static fr.ifn.ogam.common.business.checks.CheckCodes.*;
import static fr.ifn.ogam.common.business.UnitTypes.*;

/**
 * Class used to copy some data from one source to another using the metadata.
 */
public class GenericMapper {

	/**
	 * The logger used to log the errors or several information.
	 * 
	 * @see org.apache.log4j.Logger
	 */
	private final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The database accessors.
	 */
	private MetadataDAO metadataDAO = new MetadataDAO();
	private GenericDAO genericDAO = new GenericDAO();

	private List<TableFieldData> readColumns = new ArrayList<TableFieldData>();

	/**
	 * Check that a code value correspond to an existing code.
	 * 
	 * @param unit
	 *            the unit of the field to check
	 * @param fieldValue
	 *            the code to check
	 */
	protected void checkCode(String unit, String fieldValue) throws Exception {

		if (!metadataDAO.checkCode(unit, fieldValue)) {
			CheckException ce = new CheckException(INVALID_CODE_FIELD);
			throw ce;
		}
	}

	/**
	 * Check that a code value correspond to an existing code in a dynamic list.
	 * 
	 * @param unit
	 *            the unit of the field to check
	 * @param fieldValue
	 *            the code to check
	 */
	protected void checkDynaCode(String unit, String fieldValue) throws Exception {

		List<String> modes = metadataDAO.getDynamodes(unit);

		if (!modes.contains(fieldValue)) {
			String error = null ;
			if (unit.equals("CodeHabRefValue")) {
				error = "Le code fourni '" + fieldValue + "' ne fait pas partie du référentiel HABREF." ;
			}
			CheckException ce = new CheckException(INVALID_CODE_FIELD, error);
			throw ce;
		}
	}

	/**
	 * Check that a code value correspond to an existing Taxon in a referential.
	 * 
	 * @param unit
	 *            the unit of the field to check
	 * @param fieldValue
	 *            the code to check
	 */
	protected void checkTaxrefCode(String unit, String fieldValue) throws Exception {

		List<String> modes = metadataDAO.getTaxrefCode(unit);

		if (!modes.contains(fieldValue)) {
			CheckException ce = new CheckException(INVALID_CODE_FIELD);
			throw ce;
		}
	}

	/**
	 * Check that a code value correspond to an existing code in a tree of codes.
	 * 
	 * @param unit
	 *            the unit of the field to check
	 * @param fieldValue
	 *            the code to check
	 */
	protected void checkTreeCode(String unit, String fieldValue) throws Exception {

		if (!metadataDAO.checkTreeCode(unit, fieldValue)) {
			CheckException ce = new CheckException(INVALID_CODE_FIELD);
			throw ce;
		}
	}

	/**
	 * Check that a code value correspond to an existing range.
	 * 
	 * @param fieldDescriptor
	 *            the data of the field to check
	 * @param fieldValue
	 *            the field value
	 * @return the range as a BigDecimal
	 */
	protected BigDecimal checkRange(FieldData fieldDescriptor, String fieldValue) throws Exception {

		RangeData range = metadataDAO.getRange(fieldDescriptor.getUnit());
		BigDecimal value = null;

		try {
			value = new BigDecimal(fieldValue);
		} catch (Exception e) {
			throw new CheckException(INVALID_TYPE_FIELD);
		}

		if (range == null) {
			CheckException ce = new CheckException(INVALID_RANGE_FIELD);
			ce.setExpectedValue("Range undefined for data : " + fieldDescriptor.getData());
			throw ce;
		} else if (value.compareTo(range.getMinValue()) < 0 || value.compareTo(range.getMaxValue()) > 0) {
			CheckException ce = new CheckException(INVALID_RANGE_FIELD);
			ce.setExpectedValue(range.getMinValue() + " < x < " + range.getMaxValue());
			throw ce;
		}

		return value;

	}

	/**
	 * Convert a String representing a coordinate to a Long.
	 * 
	 * @param coordinate
	 *            the coordinate to check
	 * @return the coordinate as a decimal value
	 */
	protected BigDecimal getCoordinate(String coordinate) throws Exception {
		return new BigDecimal(SIGUtils.degreesToDecimals(coordinate));
	}

	/**
	 * Convert a String representing an array to an Array Object.
	 * 
	 * The string format is { value1, value2, value3 }
	 * 
	 * @param fieldValue
	 *            the field value
	 * @return the array object
	 */
	protected String[] getArray(String fieldValue) throws Exception {

		fieldValue = fieldValue.replaceAll("\\{", "");
		fieldValue = fieldValue.replaceAll("\\}", "");
		fieldValue = fieldValue.trim();

		String[] array = fieldValue.split(",");

		for (int i = 0; i < array.length; i++) {
			array[i] = ((String) array[i]).trim();
		}

		return array;
	}

	/**
	 * Check that a value is consistent with the expected type. And convert the strig value to the expected type
	 * 
	 * @param fieldDescriptor
	 *            the descriptor of the field
	 * @param fieldValue
	 *            the field as a String
	 * @return the field value casted to its correct type
	 */
	protected Object convertType(FileFieldData fieldDescriptor, String fieldValue) throws Exception {

		try {

			Object result = null;

			String type = fieldDescriptor.getType();

			if (fieldValue.equalsIgnoreCase("") && fieldDescriptor.getIsMandatory()) {
				throw new CheckException(MANDATORY_FIELD_MISSING);
			}

			if (type.equalsIgnoreCase(STRING) || type.equalsIgnoreCase(GEOM) || type.equalsIgnoreCase(IMAGE)) {
				result = fieldValue;
			}

			if (type.equalsIgnoreCase(CODE) && !fieldValue.equalsIgnoreCase("")) {
				if (fieldDescriptor.getSubtype() != null) {
					if (fieldDescriptor.getSubtype().equalsIgnoreCase(UnitSubTypes.TREE)) {
						checkTreeCode(fieldDescriptor.getUnit(), fieldValue);
					} else if (fieldDescriptor.getSubtype().equalsIgnoreCase(UnitSubTypes.DYNAMIC)) {
						checkDynaCode(fieldDescriptor.getUnit(), fieldValue);
					} else if (fieldDescriptor.getSubtype().equalsIgnoreCase(UnitSubTypes.TAXREF)) {
						checkTaxrefCode(fieldDescriptor.getUnit(), fieldValue);
					} else {
						checkCode(fieldDescriptor.getUnit(), fieldValue);
					}
				} else {
					checkCode(fieldDescriptor.getUnit(), fieldValue);
				}
				result = fieldValue;
			}

			if (type.equalsIgnoreCase(NUMERIC)) {
				try {
					// Just in case, replace the comma with a dot
					String normalizedFieldValue = fieldValue.replace(",", ".");

					if (fieldDescriptor.getSubtype() != null) {
						if (fieldDescriptor.getSubtype().equalsIgnoreCase(UnitSubTypes.RANGE)) {
							result = checkRange(fieldDescriptor, normalizedFieldValue);
						} else if (fieldDescriptor.getSubtype().equalsIgnoreCase(UnitSubTypes.COORDINATE)) {
							result = getCoordinate(normalizedFieldValue);
						} else {
							result = new BigDecimal(normalizedFieldValue);
						}
					} else {
						result = new BigDecimal(normalizedFieldValue);
					}
				} catch (Exception e) {
					if (fieldDescriptor.getIsMandatory()) {
						throw new CheckException(INVALID_TYPE_FIELD);
					}
				}
			}

			if (type.equalsIgnoreCase(INTEGER)) {
				try {
					String normalizedFieldValue = fieldValue.replace(",", ".");
					result = Integer.parseInt(normalizedFieldValue);
				} catch (Exception e) {
					if (fieldDescriptor.getIsMandatory()) {
						throw new CheckException(INVALID_TYPE_FIELD);
					}
				}
			}

			if (type.equalsIgnoreCase(DATE) || type.equalsIgnoreCase(TIME)) {
				if (fieldValue == null || fieldValue.equalsIgnoreCase("")) {
					result = null;
				} else {
					String mask = "yyyy-MM-dd";
					if( type.equalsIgnoreCase(TIME)){
						mask = "HH:mm:ss";
					}
					try {
						String fieldMask = fieldDescriptor.getMask();
						if (fieldMask != null && !fieldMask.equalsIgnoreCase("")) {
							mask = fieldMask;
						}
						SynchronizedDateFormat formatter = new SynchronizedDateFormat(mask);
						formatter.setLenient(false);
						String normalizedFieldValue = fieldValue.replace(",", ".");
						result = formatter.parse(normalizedFieldValue);
					} catch (Exception e) {
						CheckException ce = new CheckException(INVALID_DATE_FIELD);
						ce.setExpectedValue(mask);
						throw ce;
					}
				}
			}

			if (type.equalsIgnoreCase(BOOLEAN)) {
				try {
					if (fieldValue.trim().equals("1") || fieldValue.trim().equalsIgnoreCase("true")) {
						result = Boolean.TRUE;
					} else {
						result = Boolean.FALSE;
					}
				} catch (Exception e) {
					if (fieldDescriptor.getIsMandatory()) {
						throw new CheckException(INVALID_TYPE_FIELD);
					}
				}
			}

			if (type.equalsIgnoreCase(ARRAY)) {
				String[] resultArray;
				try {
					 resultArray = getArray(fieldValue);
				} catch (Exception e) {
					throw new CheckException(INVALID_TYPE_FIELD);
				}

				// Check all values if they are of type code
				String subtype = fieldDescriptor.getSubtype();
				if (subtype.equalsIgnoreCase(UnitSubTypes.TREE) ||
						subtype.equalsIgnoreCase(UnitSubTypes.DYNAMIC) ||
						subtype.equalsIgnoreCase(UnitSubTypes.TAXREF) ||
						subtype.equalsIgnoreCase(UnitSubTypes.MODE) ) {
					for (int i = 0; i < resultArray.length; i++) {
						if (!resultArray[i].equalsIgnoreCase("")) {
							if (subtype.equalsIgnoreCase(UnitSubTypes.TREE)) {
								checkTreeCode(fieldDescriptor.getUnit(), resultArray[i]);
							} else if (fieldDescriptor.getSubtype().equalsIgnoreCase(UnitSubTypes.DYNAMIC)) {
								checkDynaCode(fieldDescriptor.getUnit(), resultArray[i]);
							} else if (fieldDescriptor.getSubtype().equalsIgnoreCase(UnitSubTypes.TAXREF)) {
								checkTaxrefCode(fieldDescriptor.getUnit(), resultArray[i]);
							} else if (fieldDescriptor.getSubtype().equalsIgnoreCase(UnitSubTypes.MODE)) {
								checkCode(fieldDescriptor.getUnit(), resultArray[i]);
							}
						}
					}
				}
				result = resultArray;
			}
			return result;

		} catch (CheckException ce) {

			// Fill the data
			ce.setSourceData(fieldDescriptor.getData());
			throw ce;
		}
	}

	/**
	 * Check that a value is consistent with the expected mask (regular expression).
	 * 
	 * @param mask
	 *            the expected mask
	 * @param fieldValue
	 *            the value
	 */
	protected void checkMask(String mask, String fieldValue) throws CheckException {
		if (!Pattern.matches(mask, fieldValue)) {
			throw new CheckException(INVALID_FORMAT);
		}
	}

	/**
	 * Get a list of tables used with their ancestors, sorted from the leaf to the root.
	 * 
	 * @param schema
	 *            the schema in which we are working
	 * @param destinationTables
	 *            the list of tables we want to sort
	 * @return The list of tables used with their ancestors, sorted from the leaf to the root
	 */
	public LinkedList<String> getSortedAncestors(String schema, List<TableFormatData> destinationTables) throws Exception {

		LinkedList<String> sortedTablesList = new LinkedList<String>();
		Iterator<TableFormatData> destinationTablesIter = destinationTables.iterator();
		while (destinationTablesIter.hasNext()) {
			TableFormatData table = destinationTablesIter.next();
			String tableFormat = table.getFormat();

			// Get the list of ancestors of the table
			List<TableTreeData> ancestors = metadataDAO.getTablesTree(tableFormat, schema);

			// Check if one of the ancestors of the current table is already in
			// the resulting list
			boolean found = false;
			Iterator<TableTreeData> ancestorsIter = ancestors.iterator();
			while (ancestorsIter.hasNext() && !found) {
				TableTreeData ancestor = ancestorsIter.next();
				if (ancestor.getParentTable() != null) {
					int index = sortedTablesList.indexOf(ancestor.getParentTable().getFormat());
					if (index != -1) {
						found = true;
						// We insert the table just before its ancestor
						sortedTablesList.add(index, table.getFormat());
					}
				}
			}
			if (!found) {
				// If not found, we add the table and all its ancestors
				ancestorsIter = ancestors.iterator();
				while (ancestorsIter.hasNext()) {
					TableTreeData ancestor = ancestorsIter.next();

					if (!sortedTablesList.contains(ancestor.getTable().getFormat())) {
						sortedTablesList.add(ancestor.getTable().getFormat());
					}
				}
			}
		}

		return sortedTablesList;

	}

	/**
	 * Sort the tables from the leaf to the root.
	 * 
	 * @param schema
	 *            the schema in which we are working
	 * @param tables
	 *            the list of tables we want to sort
	 * @return The list of tables sorted from the leaf to the root
	 */
	public LinkedList<String> getSortedTables(String schema, List<TableFormatData> tables) throws Exception {

		LinkedList<String> sortedTablesList = new LinkedList<String>();
		Iterator<TableFormatData> tablesIter = tables.iterator();
		while (tablesIter.hasNext()) {
			TableFormatData table = tablesIter.next();
			String tableFormat = table.getFormat();

			// Check if the table is already listed
			if (!sortedTablesList.contains(tableFormat)) {

				// Get the list of descriptor of the table
				TableTreeData tableDescriptor = metadataDAO.getTableDescriptor(tableFormat, schema);
				TableFormatData parentTable = tableDescriptor.getParentTable();
				String parentTableFormat = null;
				if (parentTable != null) {
					parentTableFormat = tableDescriptor.getParentTable().getFormat();
				}

				// If the parent table is listed, we insert the table just
				// before
				if (parentTableFormat != null && sortedTablesList.contains(parentTableFormat)) {
					sortedTablesList.add(sortedTablesList.indexOf(parentTableFormat), tableFormat);
				} else {
					// If not found, we add the table at the end of the list
					sortedTablesList.add(tableFormat);
				}
			}

		}

		return sortedTablesList;

	}

	/**
	 * Build the SQL select corresponding to the data to harmonize. Populate the list of colums to read
	 * 
	 * @param schema
	 *            the schema in which we are working
	 * @param sourceTables
	 *            the tables we want to read
	 * @param criteriaFields
	 *            some static values that can be used in the WHERE criteria
	 * @return The list of values
	 */
	private String buildSelect(String schema, LinkedList<String> sourceTables, TreeMap<String, GenericData> criteriaFields) throws Exception {

		String SELECT = "";
		String FROM = "";
		String WHERE = "";
		String ORDER = "";

		this.readColumns = new ArrayList<TableFieldData>();

		// Build the SQL Request
		Iterator<String> sourceTablesIter = sourceTables.descendingIterator();
		while (sourceTablesIter.hasNext()) {
			String sourceTableFormat = sourceTablesIter.next();

			// Get the descriptor of the table
			Map<String, TableFieldData> sourceFields = metadataDAO.getTableFields(sourceTableFormat);
			TableTreeData tableDescriptor = metadataDAO.getTableDescriptor(sourceTableFormat, schema);

			// Build the SELECT clause
			Iterator<TableFieldData> sourceFieldsIter = sourceFields.values().iterator();
			while (sourceFieldsIter.hasNext()) {
				TableFieldData sourceField = sourceFieldsIter.next();
				if (SELECT.equals("")) {
					SELECT += "SELECT ";
				} else {
					SELECT += ", ";
				}
				if (ORDER.equals("")) {
					ORDER += " ORDER BY ";
				} else {
					ORDER += ", ";
				}
				SELECT += sourceField.getTableName() + "." + sourceField.getColumnName() + " AS " + sourceField.getFormat() + "_" + sourceField.getData() + " ";
				ORDER += sourceField.getTableName() + "." + sourceField.getColumnName();
				this.readColumns.add(sourceField);
			}

			// Build the FROM clause
			if (FROM.equals("")) {
				FROM += " FROM " + tableDescriptor.getTable().getTableName();
			} else {
				FROM += " INNER JOIN " + tableDescriptor.getTable().getTableName() + " ON (";
				Iterator<String> keyIter = tableDescriptor.getKeys().iterator();
				while (keyIter.hasNext()) {
					String key = keyIter.next();
					String parentTableName = tableDescriptor.getParentTable().getTableName();
					FROM += tableDescriptor.getTable().getTableName() + "." + key + " = " + parentTableName + "." + key;
					if (keyIter.hasNext()) {
						FROM += " AND ";
					}
				}
				FROM += ")";
			}

			// Build the WHERE clause

			// When we find a source field that match one of our criteria, we
			// add the clause
			sourceFieldsIter = sourceFields.values().iterator();
			while (sourceFieldsIter.hasNext()) {
				TableFieldData sourceField = sourceFieldsIter.next();

				if (criteriaFields.containsKey(sourceField.getData())) {
					if (WHERE.equals("")) {
						WHERE += " WHERE ";
					} else {
						WHERE += " AND ";
					}
					WHERE += sourceField.getTableName() + "." + sourceField.getColumnName() + " = ";

					// Change the criteria depending on the type of the value
					GenericData value = criteriaFields.get(sourceField.getData());
					if (value.getType().equalsIgnoreCase(UnitTypes.INTEGER) || value.getType().equalsIgnoreCase(UnitTypes.NUMERIC)) {
						WHERE += value.getValue();
					} else {
						WHERE += "'" + value.getValue() + "'";
					}
				}
			}

		}

		return SELECT + FROM + WHERE + ORDER;
	}

	/**
	 * Read data from a list of source tables.<br>
	 * <br>
	 * Build a SELECT request with the JOIN of all the source tables. <br>
	 * TODO : Limit the read values to the values needed by the dataset.<br>
	 * 
	 * @param schema
	 *            the schema in which we are working
	 * @param sourceTables
	 *            the tables we want to read
	 * @param criteriaFields
	 *            some static values that can be used in the WHERE criteria
	 * @param page
	 *            the page number
	 * @param maxlines
	 *            the number of lines per page
	 * @return The list of values
	 */
	public List<Map<String, GenericData>> readData(String schema, LinkedList<String> sourceTables, TreeMap<String, GenericData> criteriaFields, int page,
			int maxlines) throws Exception {

		String SQL = buildSelect(schema, sourceTables, criteriaFields);

		// Calculate the limits
		String LIMIT = " LIMIT " + maxlines;
		String OFFSET = " OFFSET " + page * maxlines;
		SQL = SQL + LIMIT + OFFSET;

		logger.debug("************************************");
		logger.debug("SQL " + SQL);
		logger.debug("************************************");

		return genericDAO.readData(SQL, this.readColumns);
	}

	/**
	 * Count the number of lines to harmonize.
	 * 
	 * @param schema
	 *            the schema in which we are working
	 * @param sourceTables
	 *            the tables we want to read
	 * @param criteriaFields
	 *            some static values that can be used in the WHERE criteria
	 * @return The list of values
	 */
	public int countData(String schema, LinkedList<String> sourceTables, TreeMap<String, GenericData> criteriaFields) throws Exception {

		String SQL = buildSelect(schema, sourceTables, criteriaFields);

		return genericDAO.countData(SQL);
	}
}
