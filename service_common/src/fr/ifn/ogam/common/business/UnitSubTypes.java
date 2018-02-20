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
 * List the field sub-types.
 */
public interface UnitSubTypes {

	/**
	 * A decimal value comprised in a specified range (mapped to java type BigDecimal). For NUMERIC type.
	 */
	String RANGE = "RANGE";

	/**
	 * A coordinate expressed in decimal degrees (mapped to java type BigDecimal). For NUMERIC type.
	 */
	String COORDINATE = "COORDINATE";

	/**
	 * A mode (list of values) For CODE type.
	 */
	String MODE = "MODE";

	/**
	 * A tree (hierarchical list of values) For CODE type.
	 */
	String TREE = "TREE";

	/**
	 * A mode selected in a table using a dynamic SQL request. For CODE type.
	 */
	String DYNAMIC = "DYNAMIC";
	
	/**
	 * A mode selected in a taxonomic referential. For CODE type.
	 */
	String TAXREF = "TAXREF";

}
