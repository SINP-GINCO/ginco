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
package fr.ifn.ogam.common.business.checks;

/**
 * List the check codes.
 */
public interface CheckCodes {

	/**
	 * Empty file.
	 */
	Integer EMPTY_FILE = 1000;

	/**
	 * Wrong file number.
	 */
	Integer WRONG_FIELD_NUMBER = 1001;

	/**
	 * Integrity constraint (trying to insert a plot when the location doesn't exist).
	 */
	Integer INTEGRITY_CONSTRAINT = 1002;

	/**
	 * Unexpected SQL error.
	 */
	Integer UNEXPECTED_SQL_ERROR = 1003;

	/**
	 * Duplicate row.
	 */
	Integer DUPLICATE_ROW = 1004;

	/**
	 * Mandatory field missing.
	 */
	Integer MANDATORY_FIELD_MISSING = 1101;

	/**
	 * Invalid format.
	 */
	Integer INVALID_FORMAT = 1102;

	/**
	 * Invalid type field (we cannot cast the value to its type).
	 */
	Integer INVALID_TYPE_FIELD = 1103;

	/**
	 * Invalid date field.
	 */
	Integer INVALID_DATE_FIELD = 1104;

	/**
	 * Invalid code field (the value isn't in the list of codes).
	 */
	Integer INVALID_CODE_FIELD = 1105;

	/**
	 * Invalid range field (the value is outside the range).
	 */
	Integer INVALID_RANGE_FIELD = 1106;

	/**
	 * String too long.
	 */
	Integer STRING_TOO_LONG = 1107;

	/**
	 * Undefined column.
	 */
	Integer UNDEFINED_COLUMN = 1108;

	/**
	 * No mapping.
	 */
	Integer NO_MAPPING = 1109;

	/**
	 * Trigger exception.
	 */
	Integer TRIGGER_EXCEPTION = 1110;
	
	/**
	 * Invalid geometry.
	 */
	Integer INVALID_GEOMETRY = 1111;
	
	/**
	 * Wrong geometry type.
	 */
	Integer WRONG_GEOMETRY_TYPE = 1112;
	
	/**
	 * Wrong geometry srid.
	 */
	Integer WRONG_GEOMETRY_SRID = 1113;

	/**
	 * Wrong label_csv.
	 */
	Integer WRONG_FILE_FIELD_CSV_LABEL = 1114;
	
	/**
	 * Duplicate label_csv.
	 */
	Integer DUPLICATED_FILE_LABEL = 1115;
	
	/**
	 * Mandatory field missing in the header.
	 */
	Integer MANDATORY_HEADER_LABEL_MISSING = 1116;
}
