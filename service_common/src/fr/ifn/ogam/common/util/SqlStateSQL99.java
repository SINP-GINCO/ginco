package fr.ifn.ogam.common.util;

/**
 * Done from the file found to this address : http://doxygen.postgresql.org/errcodes_8h-source.html
 * 
 * @author sgalopin
 * 
 * 
 *         Generated on Wed Jun 6 03:06:08 2007 for PostgreSQL Source Code by doxygen 1.4.7
 * 
 */
public interface SqlStateSQL99 {

	/*-------------------------------------------------------------------------
	 *
	 * errcodes.h
	 *    POSTGRES error codes
	 *
	 * The error code list is kept in its own source file for possible use by
	 * automatic tools.  Each error code is identified by a five-character string
	 * following the SQLSTATE conventions.  The exact representation of the
	 * string is determined by the MAKE_SQLSTATE() macro, which is not defined
	 * in this file; it can be defined by the caller for special purposes.
	 *
	 * Copyright (c) 2003-2007, PostgreSQL Global Development Group
	 *
	 * $PostgreSQL: pgsql/src/include/utils/errcodes.h,v 1.23 2007/02/03 14:06:56 petere Exp $
	 *
	 *-------------------------------------------------------------------------
	 */

	/* there is deliberately not an #ifndef ERRCODES_H here */

	/*
	 * SQLSTATE codes for errors.
	 * 
	 * The SQL99 code set is rather impoverished, especially in the area of syntactical and semantic errors. We have borrowed codes from IBM's DB2 and invented
	 * our own codes to develop a useful code set.
	 * 
	 * When adding a new code, make sure it is placed in the most appropriate class (the first two characters of the code value identify the class). The listing
	 * is organized by class to make this prominent.
	 * 
	 * The generic '000' subclass code should be used for an error only when there is not a more-specific subclass code defined.
	 * 
	 * The SQL spec requires that all the elements of a SQLSTATE code be either digits or upper-case ASCII characters.
	 * 
	 * Classes that begin with 0-4 or A-H are defined by the standard. Within such a class, subclass values defined by the standard must begin with 0-4 or A-H.
	 * To define a new error code, ensure that it is either in an "implementation-defined class" (it begins with 5-9 or I-Z), or its subclass falls outside the
	 * range of error codes that could be present in future versions of the standard (i.e. the subclass value begins with 5-9 or I-Z).
	 * 
	 * The convention is that new error codes defined by PostgreSQL in a class defined by the standard have a subclass value that begins with 'P'. In addition,
	 * error codes defined by PostgreSQL clients (such as ecpg) have a class value that begins with 'Y'.
	 */

	/* Class 00 - Successful Completion */
	String ERRCODE_SUCCESSFUL_COMPLETION = "00000";

	/* Class 01 - Warning */
	/* (do not use this class for failure conditions!) */
	String ERRCODE_WARNING = "01000";

	String ERRCODE_WARNING_DYNAMIC_RESULT_SETS_RETURNED = "0100C";

	String ERRCODE_WARNING_IMPLICIT_ZERO_BIT_PADDING = "01008";

	String ERRCODE_WARNING_NULL_VALUE_ELIMINATED_IN_SET_FUNCTION = "01003";

	String ERRCODE_WARNING_PRIVILEGE_NOT_GRANTED = "01007";

	String ERRCODE_WARNING_PRIVILEGE_NOT_REVOKED = "01006";

	String ERRCODE_WARNING_STRING_DATA_RIGHT_TRUNCATION = "01004";

	String ERRCODE_WARNING_DEPRECATED_FEATURE = "01P01";

	/* Class 02 - No Data --- this is also a warning class per SQL99 */
	/* (do not use this class for failure conditions!) */
	String ERRCODE_NO_DATA = "02000";

	String ERRCODE_NO_ADDITIONAL_DYNAMIC_RESULT_SETS_RETURNED = "02001";

	/* Class 03 - SQL Statement Not Yet Complete */
	String ERRCODE_SQL_STATEMENT_NOT_YET_COMPLETE = "03000";

	/* Class 08 - Connection Exception */
	String ERRCODE_CONNECTION_EXCEPTION = "08000";

	String ERRCODE_CONNECTION_DOES_NOT_EXIST = "08003";

	String ERRCODE_CONNECTION_FAILURE = "08006";

	String ERRCODE_SQLCLIENT_UNABLE_TO_ESTABLISH_SQLCONNECTION = "08001";

	String ERRCODE_SQLSERVER_REJECTED_ESTABLISHMENT_OF_SQLCONNECTION = "08004";

	String ERRCODE_TRANSACTION_RESOLUTION_UNKNOWN = "08007";

	String ERRCODE_PROTOCOL_VIOLATION = "08P01";

	/* Class 09 - Triggered Action Exception */
	String ERRCODE_TRIGGERED_ACTION_EXCEPTION = "09000";

	/* Class 0A - Feature Not Supported */
	String ERRCODE_FEATURE_NOT_SUPPORTED = "0A000";

	/* Class 0B - Invalid Transaction Initiation */
	String ERRCODE_INVALID_TRANSACTION_INITIATION = "0B000";

	/* Class 0F - Locator Exception */
	String ERRCODE_LOCATOR_EXCEPTION = "0F000";

	String ERRCODE_L_E_INVALID_SPECIFICATION = "0F001";

	/* Class 0L - Invalid Grantor */
	String ERRCODE_INVALID_GRANTOR = "0L000";

	String ERRCODE_INVALID_GRANT_OPERATION = "0LP01";

	/* Class 0P - Invalid Role Specification */
	String ERRCODE_INVALID_ROLE_SPECIFICATION = "0P000";

	/* Class 21 - Cardinality Violation */
	/* (this means something returned the wrong number of rows) */
	String ERRCODE_CARDINALITY_VIOLATION = "21000";

	/* Class 22 - Data Exception */
	String ERRCODE_DATA_EXCEPTION = "22000";

	String ERRCODE_ARRAY_ELEMENT_ERROR = "2202E";

	/* SQL99's actual definition of "array element error" is subscript error */
	String ERRCODE_ARRAY_SUBSCRIPT_ERROR = ERRCODE_ARRAY_ELEMENT_ERROR;

	String ERRCODE_CHARACTER_NOT_IN_REPERTOIRE = "22021";

	String ERRCODE_DATETIME_FIELD_OVERFLOW = "22008";

	String ERRCODE_DATETIME_VALUE_OUT_OF_RANGE = ERRCODE_DATETIME_FIELD_OVERFLOW;

	String ERRCODE_DIVISION_BY_ZERO = "22012";

	String ERRCODE_ERROR_IN_ASSIGNMENT = "22005";

	String ERRCODE_ESCAPE_CHARACTER_CONFLICT = "2200B";

	String ERRCODE_INDICATOR_OVERFLOW = "22022";

	String ERRCODE_INTERVAL_FIELD_OVERFLOW = "22015";

	String ERRCODE_INVALID_ARGUMENT_FOR_LOG = "2201E";

	String ERRCODE_INVALID_ARGUMENT_FOR_POWER_FUNCTION = "2201F";

	String ERRCODE_INVALID_ARGUMENT_FOR_WIDTH_BUCKET_FUNCTION = "2201G";

	String ERRCODE_INVALID_CHARACTER_VALUE_FOR_CAST = "22018";

	String ERRCODE_INVALID_DATETIME_FORMAT = "22007";

	String ERRCODE_INVALID_ESCAPE_CHARACTER = "22019";

	String ERRCODE_INVALID_ESCAPE_OCTET = "2200D";

	String ERRCODE_INVALID_ESCAPE_SEQUENCE = "22025";

	String ERRCODE_NONSTANDARD_USE_OF_ESCAPE_CHARACTER = "22P06";

	String ERRCODE_INVALID_INDICATOR_PARAMETER_VALUE = "22010";

	String ERRCODE_INVALID_LIMIT_VALUE = "22020";

	String ERRCODE_INVALID_PARAMETER_VALUE = "22023";

	String ERRCODE_INVALID_REGULAR_EXPRESSION = "2201B";

	String ERRCODE_INVALID_TIME_ZONE_DISPLACEMENT_VALUE = "22009";

	String ERRCODE_INVALID_USE_OF_ESCAPE_CHARACTER = "2200C";

	String ERRCODE_MOST_SPECIFIC_TYPE_MISMATCH = "2200G";

	String ERRCODE_NULL_VALUE_NOT_ALLOWED = "22004";

	String ERRCODE_NULL_VALUE_NO_INDICATOR_PARAMETER = "22002";

	String ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE = "22003";

	String ERRCODE_STRING_DATA_LENGTH_MISMATCH = "22026";

	String ERRCODE_STRING_DATA_RIGHT_TRUNCATION = "22001";

	String ERRCODE_SUBSTRING_ERROR = "22011";

	String ERRCODE_TRIM_ERROR = "22027";

	String ERRCODE_UNTERMINATED_C_STRING = "22024";

	String ERRCODE_ZERO_LENGTH_CHARACTER_STRING = "2200F";

	String ERRCODE_FLOATING_POINT_EXCEPTION = "22P01";

	String ERRCODE_INVALID_TEXT_REPRESENTATION = "22P02";

	String ERRCODE_INVALID_BINARY_REPRESENTATION = "22P03";

	String ERRCODE_BAD_COPY_FILE_FORMAT = "22P04";

	String ERRCODE_UNTRANSLATABLE_CHARACTER = "22P05";

	String ERRCODE_NOT_AN_XML_DOCUMENT = "2200L";

	String ERRCODE_INVALID_XML_DOCUMENT = "2200M";

	String ERRCODE_INVALID_XML_CONTENT = "2200N";

	String ERRCODE_INVALID_XML_COMMENT = "2200S";

	String ERRCODE_INVALID_XML_PROCESSING_INSTRUCTION = "2200T";

	/* Class 23 - Integrity Constraint Violation */
	String ERRCODE_INTEGRITY_CONSTRAINT_VIOLATION = "23000";

	String ERRCODE_RESTRICT_VIOLATION = "23001";

	String ERRCODE_NOT_NULL_VIOLATION = "23502";

	String ERRCODE_FOREIGN_KEY_VIOLATION = "23503";

	String ERRCODE_UNIQUE_VIOLATION = "23505";

	String ERRCODE_CHECK_VIOLATION = "23514";

	/* Class 24 - Invalid Cursor State */
	String ERRCODE_INVALID_CURSOR_STATE = "24000";

	/* Class 25 - Invalid Transaction State */
	String ERRCODE_INVALID_TRANSACTION_STATE = "25000";

	String ERRCODE_ACTIVE_SQL_TRANSACTION = "25001";

	String ERRCODE_BRANCH_TRANSACTION_ALREADY_ACTIVE = "25002";

	String ERRCODE_HELD_CURSOR_REQUIRES_SAME_ISOLATION_LEVEL = "25008";

	String ERRCODE_INAPPROPRIATE_ACCESS_MODE_FOR_BRANCH_TRANSACTION = "25003";

	String ERRCODE_INAPPROPRIATE_ISOLATION_LEVEL_FOR_BRANCH_TRANSACTION = "25004";

	String ERRCODE_NO_ACTIVE_SQL_TRANSACTION_FOR_BRANCH_TRANSACTION = "25005";

	String ERRCODE_READ_ONLY_SQL_TRANSACTION = "25006";

	String ERRCODE_SCHEMA_AND_DATA_STATEMENT_MIXING_NOT_SUPPORTED = "25007";

	String ERRCODE_NO_ACTIVE_SQL_TRANSACTION = "25P01";

	String ERRCODE_IN_FAILED_SQL_TRANSACTION = "25P02";

	/* Class 26 - Invalid SQL Statement Name */
	/* (we take this to mean prepared statements) */
	String ERRCODE_INVALID_SQL_STATEMENT_NAME = "26000";

	/* Class 27 - Triggered Data Change Violation */
	String ERRCODE_TRIGGERED_DATA_CHANGE_VIOLATION = "27000";

	/* Class 28 - Invalid Authorization Specification */
	String ERRCODE_INVALID_AUTHORIZATION_SPECIFICATION = "28000";

	/* Class 2B - Dependent Privilege Descriptors Still Exist */
	String ERRCODE_DEPENDENT_PRIVILEGE_DESCRIPTORS_STILL_EXIST = "2B000";

	String ERRCODE_DEPENDENT_OBJECTS_STILL_EXIST = "2BP01";

	/* Class 2D - Invalid Transaction Termination */
	String ERRCODE_INVALID_TRANSACTION_TERMINATION = "2D000";

	/* Class 2F - SQL Routine Exception */
	String ERRCODE_SQL_ROUTINE_EXCEPTION = "2F000";

	String ERRCODE_S_R_E_FUNCTION_EXECUTED_NO_RETURN_STATEMENT = "2F005";

	String ERRCODE_S_R_E_MODIFYING_SQL_DATA_NOT_PERMITTED = "2F002";

	String ERRCODE_S_R_E_PROHIBITED_SQL_STATEMENT_ATTEMPTED = "2F003";

	String ERRCODE_S_R_E_READING_SQL_DATA_NOT_PERMITTED = "2F004";

	/* Class 34 - Invalid Cursor Name */
	String ERRCODE_INVALID_CURSOR_NAME = "34000";

	/* Class 38 - External Routine Exception */
	String ERRCODE_EXTERNAL_ROUTINE_EXCEPTION = "38000";

	String ERRCODE_E_R_E_CONTAINING_SQL_NOT_PERMITTED = "38001";

	String ERRCODE_E_R_E_MODIFYING_SQL_DATA_NOT_PERMITTED = "38002";

	String ERRCODE_E_R_E_PROHIBITED_SQL_STATEMENT_ATTEMPTED = "38003";

	String ERRCODE_E_R_E_READING_SQL_DATA_NOT_PERMITTED = "38004";

	/* Class 39 - External Routine Invocation Exception */
	String ERRCODE_EXTERNAL_ROUTINE_INVOCATION_EXCEPTION = "39000";

	String ERRCODE_E_R_I_E_INVALID_SQLSTATE_RETURNED = "39001";

	String ERRCODE_E_R_I_E_NULL_VALUE_NOT_ALLOWED = "39004";

	String ERRCODE_E_R_I_E_TRIGGER_PROTOCOL_VIOLATED = "39P01";

	String ERRCODE_E_R_I_E_SRF_PROTOCOL_VIOLATED = "39P02";

	/* Class 3B - Savepoint Exception */
	String ERRCODE_SAVEPOINT_EXCEPTION = "3B000";

	String ERRCODE_S_E_INVALID_SPECIFICATION = "3B001";

	/* Class 3D - Invalid Catalog Name */
	String ERRCODE_INVALID_CATALOG_NAME = "3D000";

	/* Class 3F - Invalid Schema Name */
	String ERRCODE_INVALID_SCHEMA_NAME = "3F000";

	/* Class 40 - Transaction Rollback */
	String ERRCODE_TRANSACTION_ROLLBACK = "40000";

	String ERRCODE_T_R_INTEGRITY_CONSTRAINT_VIOLATION = "40002";

	String ERRCODE_T_R_SERIALIZATION_FAILURE = "40001";

	String ERRCODE_T_R_STATEMENT_COMPLETION_UNKNOWN = "40003";

	String ERRCODE_T_R_DEADLOCK_DETECTED = "40P01";

	/* Class 42 - Syntax Error or Access Rule Violation */
	String ERRCODE_SYNTAX_ERROR_OR_ACCESS_RULE_VIOLATION = "42000";

	/* never use the above; use one of these two if no specific code exists: */
	String ERRCODE_SYNTAX_ERROR = "42601";

	String ERRCODE_INSUFFICIENT_PRIVILEGE = "42501";

	String ERRCODE_CANNOT_COERCE = "42846";

	String ERRCODE_GROUPING_ERROR = "42803";

	String ERRCODE_INVALID_FOREIGN_KEY = "42830";

	String ERRCODE_INVALID_NAME = "42602";

	String ERRCODE_NAME_TOO_LONG = "42622";

	String ERRCODE_RESERVED_NAME = "42939";

	String ERRCODE_DATATYPE_MISMATCH = "42804";

	String ERRCODE_INDETERMINATE_DATATYPE = "42P18";

	String ERRCODE_WRONG_OBJECT_TYPE = "42809";

	/*
	 * Note: for ERRCODE purposes, we divide namable objects into these categories: databases, schemas, prepared statements, cursors, tables, columns, functions
	 * (including operators), and all else (lumped as "objects"). (The first four categories are mandated by the existence of separate SQLSTATE classes for them
	 * in the spec; in this file, however, we group the ERRCODE names with all the rest under class 42.) Parameters are sort-of-named objects and get their own
	 * ERRCODE.
	 * 
	 * The same breakdown is used for "duplicate" and "ambiguous" complaints, as well as complaints associated with incorrect declarations.
	 */
	String ERRCODE_UNDEFINED_COLUMN = "42703";

	String ERRCODE_UNDEFINED_CURSOR = ERRCODE_INVALID_CURSOR_NAME;

	String ERRCODE_UNDEFINED_DATABASE = ERRCODE_INVALID_CATALOG_NAME;

	String ERRCODE_UNDEFINED_FUNCTION = "42883";

	String ERRCODE_UNDEFINED_PSTATEMENT = ERRCODE_INVALID_SQL_STATEMENT_NAME;

	String ERRCODE_UNDEFINED_SCHEMA = ERRCODE_INVALID_SCHEMA_NAME;

	String ERRCODE_UNDEFINED_TABLE = "42P01";

	String ERRCODE_UNDEFINED_PARAMETER = "42P02";

	String ERRCODE_UNDEFINED_OBJECT = "42704";

	String ERRCODE_DUPLICATE_COLUMN = "42701";

	String ERRCODE_DUPLICATE_CURSOR = "42P03";

	String ERRCODE_DUPLICATE_DATABASE = "42P04";

	String ERRCODE_DUPLICATE_FUNCTION = "42723";

	String ERRCODE_DUPLICATE_PSTATEMENT = "42P05";

	String ERRCODE_DUPLICATE_SCHEMA = "42P06";

	String ERRCODE_DUPLICATE_TABLE = "42P07";

	String ERRCODE_DUPLICATE_ALIAS = "42712";

	String ERRCODE_DUPLICATE_OBJECT = "42710";

	String ERRCODE_AMBIGUOUS_COLUMN = "42702";

	String ERRCODE_AMBIGUOUS_FUNCTION = "42725";

	String ERRCODE_AMBIGUOUS_PARAMETER = "42P08";

	String ERRCODE_AMBIGUOUS_ALIAS = "42P09";

	String ERRCODE_INVALID_COLUMN_REFERENCE = "42P10";

	String ERRCODE_INVALID_COLUMN_DEFINITION = "42611";

	String ERRCODE_INVALID_CURSOR_DEFINITION = "42P11";

	String ERRCODE_INVALID_DATABASE_DEFINITION = "42P12";

	String ERRCODE_INVALID_FUNCTION_DEFINITION = "42P13";

	String ERRCODE_INVALID_PSTATEMENT_DEFINITION = "42P14";

	String ERRCODE_INVALID_SCHEMA_DEFINITION = "42P15";

	String ERRCODE_INVALID_TABLE_DEFINITION = "42P16";

	String ERRCODE_INVALID_OBJECT_DEFINITION = "42P17";

	/* Class 44 - WITH CHECK OPTION Violation */
	String ERRCODE_WITH_CHECK_OPTION_VIOLATION = "44000";

	/* Class 53 - Insufficient Resources (PostgreSQL-specific error class) */
	String ERRCODE_INSUFFICIENT_RESOURCES = "53000";

	String ERRCODE_DISK_FULL = "53100";

	String ERRCODE_OUT_OF_MEMORY = "53200";

	String ERRCODE_TOO_MANY_CONNECTIONS = "53300";

	/* Class 54 - Program Limit Exceeded (class borrowed from DB2) */
	/* (this is for wired-in limits, not resource exhaustion problems) */
	String ERRCODE_PROGRAM_LIMIT_EXCEEDED = "54000";

	String ERRCODE_STATEMENT_TOO_COMPLEX = "54001";

	String ERRCODE_TOO_MANY_COLUMNS = "54011";

	String ERRCODE_TOO_MANY_ARGUMENTS = "54023";

	/* Class 55 - Object Not In Prerequisite State (class borrowed from DB2) */
	String ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE = "55000";

	String ERRCODE_OBJECT_IN_USE = "55006";

	String ERRCODE_CANT_CHANGE_RUNTIME_PARAM = "55P02";

	String ERRCODE_LOCK_NOT_AVAILABLE = "55P03";

	/* Class 57 - Operator Intervention (class borrowed from DB2) */
	String ERRCODE_OPERATOR_INTERVENTION = "57000";

	String ERRCODE_QUERY_CANCELED = "57014";

	String ERRCODE_ADMIN_SHUTDOWN = "57P01";

	String ERRCODE_CRASH_SHUTDOWN = "57P02";

	String ERRCODE_CANNOT_CONNECT_NOW = "57P03";

	/* Class 58 - System Error (class borrowed from DB2) */
	/* (we define this as errors external to PostgreSQL itself) */
	String ERRCODE_IO_ERROR = "58030";

	String ERRCODE_UNDEFINED_FILE = "58P01";

	String ERRCODE_DUPLICATE_FILE = "58P02";

	/* Class F0 - Configuration File Error (PostgreSQL-specific error class) */
	String ERRCODE_CONFIG_FILE_ERROR = "F0000";

	String ERRCODE_LOCK_FILE_EXISTS = "F0001";

	/* Class P0 - PL/pgSQL Error (PostgreSQL-specific error class) */
	String ERRCODE_PLPGSQL_ERROR = "P0000";

	String ERRCODE_RAISE_EXCEPTION = "P0001";

	String ERRCODE_NO_DATA_FOUND = "P0002";

	String ERRCODE_TOO_MANY_ROWS = "P0003";

	/* Class XX - Internal Error (PostgreSQL-specific error class) */
	/* (this is for "can't-happen" conditions and software bugs) */
	String ERRCODE_INTERNAL_ERROR = "XX000";

	String ERRCODE_DATA_CORRUPTED = "XX001";

	String ERRCODE_INDEX_CORRUPTED = "XX002";

}
