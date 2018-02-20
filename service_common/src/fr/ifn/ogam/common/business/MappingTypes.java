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
 * List the types of mapping.
 */
public interface MappingTypes {

	/**
	 * Map a field from the database to a form.
	 */
	String FORM_MAPPING = "FORM";

	/**
	 * Map a field from a file to the raw database.
	 */
	String FILE_MAPPING = "FILE";

	/**
	 * Map a field from the raw database to the harmonization database.
	 */
	String HARMONIZATION_MAPPING = "HARMONIZE";

}
