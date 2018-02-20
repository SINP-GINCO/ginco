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

/**
 * List the field types.
 */
public interface UnitTypes {

	/**
	 * A string.
	 */
	String STRING = "STRING";

	/**
	 * A code (mapped to java type String).
	 */
	String CODE = "CODE";

	/**
	 * A numeric value (mapped to java type BigDecimal).
	 */
	String NUMERIC = "NUMERIC";

	/**
	 * An integer (mapped to java type Integer).
	 */
	String INTEGER = "INTEGER";

	/**
	 * A date (mapped to java type Date).
	 */
	String DATE = "DATE";
	
	/**
	 * A time (mapped to java type Date)
	 */
	String TIME= "TIME";
	/**
	 * A boolean (mapped to java type Boolean).
	 */
	String BOOLEAN = "BOOLEAN";

	/**
	 * An array of codes.
	 */
	String ARRAY = "ARRAY";

	/**
	 * A geometry (as a WKT string, mapped to the GEOMETRY type of PostGIS).
	 */
	String GEOM = "GEOM";
	
	/**
	 * An image (the image name in the CSV file).
	 */
	String IMAGE = "IMAGE";

}
