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
public interface CheckCodesGinco {
	/**
	 * Mandatory/Conditional fields
	 */
	Integer MANDATORY_CONDITIONAL_FIELDS = 1200;

	/**
	 * Array fields must have the same number of elements
	 */
	Integer ARRAY_OF_SAME_LENGTH = 1201;

	/**
	 * Version Taxref mandatory if cdNom or cdRef not empty
	 */
	Integer TAXREF_VERSION = 1202;

	/**
	 * refernceBiblio must not be empty if statutSource = "Li"
	 */
	Integer BIBLIO_REF = 1203;

	/**
	 * Fields preuveExistante, preuveNumerique, preuveNonNumerique
	 */
	Integer PROOF = 1204;

	/**
	 * Fields preuveNumerique must be an url
	 */
	Integer NUMERIC_PROOF_URL = 1205;

	/**
	 * Fields refHabitat, codeHabitat, codeHabRef
	 */
	Integer HABITAT = 1206;

	/**
	 * One and only one georeferenced object must be present
	 * (geometry or commune or maille or departement)
	 */
	Integer NO_GEOREFERENCE = 1207;
	Integer MORE_THAN_ONE_GEOREFERENCE = 1208;

	/**
	 * jourDateDebut < jourDateFin < now
	 */
	Integer DATE_ORDER = 1209;

	/**
	 * heureDateDebut < heureDateFin
	 */
	Integer TIME_ORDER = 1210;
	
	/**
	 * identifiantpermenent must be an UUID
	 */
	Integer IDENTIFIANT_PERMANENT_NOT_UUID = 1211;
	
	/**
	 * cdnom does not exist
	 */
	Integer CDNOM_NOT_FOUND = 1212 ;
	
	/**
	 * cdref does not exist
	 */
	Integer CDREF_NOT_FOUND = 1213 ;
	
	/**
	 * cdhab is empty
	 */
	Integer CDHAB_EMPTY = 1214 ;
	
	/**
	 * techniquecollecte is empty
	 */
	Integer PRECISION_TECHNIQUE_EMPTY = 1215 ;
	
	/**
	 * cdhabinteretcommunautaire is empty
	 */
	Integer CDHAB_INTERET_COMMUNAUTAIRE_EMPTY = 1216 ;
	
	/**
	 * identifiant permanent is not unique
	 */
	Integer IDENTIFIANT_PERMANENT_NOT_UNIQUE = 1217 ;
	
	/**
	 * clestation is not found in table station
	 */
	Integer CLE_STATION_NOT_FOUND = 1218 ;
	
	/**
	 * interetcommunautaire is empty
	 */
	Integer HABITAT_INTERET_COMMUNAUTAIRE_EMPTY = 1219 ;

}
