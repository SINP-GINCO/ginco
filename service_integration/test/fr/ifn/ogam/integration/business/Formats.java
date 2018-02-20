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
package fr.ifn.ogam.integration.business;

/**
 * List the file types.
 */
public interface Formats {

	//
	// CSV File formats
	//

	/**
	 * A location file.
	 */
	String LOCATION_FILE = "LOCATION_FILE";

	/**
	 * A plot file.
	 */
	String PLOT_FILE = "PLOT_FILE";

	/**
	 * A species file.
	 */
	String SPECIES_FILE = "SPECIES_FILE";

	//
	// Table formats
	//

	/**
	 * The plot table.
	 */
	String PLOT_DATA = "PLOT_DATA";

	/**
	 * /** The species table.
	 */
	String SPECIES_DATA = "SPECIES_DATA";

	/**
	 * The location table.
	 */
	String LOCATION_DATA = "LOCATION_DATA";

	//
	// Form formats
	//

	/**
	 * The plot form.
	 */
	String PLOT_FORM = "PLOT_FORM";

	/**
	 * The species form.
	 */
	String SPECIES_FORM = "SPECIES_FORM";

}
