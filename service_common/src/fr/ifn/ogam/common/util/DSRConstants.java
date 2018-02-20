
package fr.ifn.ogam.common.util;

/**
 * Constants for fields in the DSR standard.
 * 
 * @author gautam
 */
public class DSRConstants {

	public final static String PROVIDER_ID = "PROVIDER_ID";
	public final static String OGAM_ID = "OGAM_ID";

	// Geography
	public final static String GEOMETRIE = "geometrie";
	public final static String NATURE_OBJET_GEO = "natureobjetgeo";
	public final static String PRECISION_GEOMETRIE = "precisiongeometrie";

	public final static String CODE_COMMUNE = "codecommune";
	public final static String NOM_COMMUNE = "nomcommune";
	public final static String ANNEE_REF_COMMUNE = "anneerefcommune";
	public final static String TYPE_INFO_GEO_COMMUNE = "typeinfogeocommune";

	public final static String CODE_MAILLE = "codemaille";
	public final static String VERSION_REF_MAILLE = "versionrefmaille";
	public final static String NOM_REF_MAILLE = "nomrefmaille";
	public final static String TYPE_INFO_GEO_MAILLE = "typeinfogeomaille";

	public final static String CODE_DEPARTEMENT = "codedepartement";
	public final static String ANNEE_REF_DEPARTEMENT = "anneerefdepartement";
	public final static String TYPE_INFO_GEO_DEPARTEMENT = "typeinfogeodepartement";

	public final static String CODE_COMMUNE_CALC = "codecommunecalcule";
	public final static String NOM_COMMUNE_CALC = "nomcommunecalcule";
	public final static String CODE_MAILLE_CALC = "codemaillecalcule";
	public final static String CODE_DEPARTEMENT_CALC = "codedepartementcalcule";

	public final static String CODE_ME = "codeme";
	public final static String VERSION_ME = "versionme";
	public final static String DATE_ME = "dateme";
	public final static String TYPE_INFO_GEO_ME = "typeinfogeome";

    public final static String TYPE_INFO_GEO_EN = "typeinfogeoen";

	// Sujet Observation
	public final static String CD_NOM = "cdnom";
	public final static String CD_REF = "cdref";
	public final static String VERSION_TAXREF = "versiontaxref";
	public final static String NOM_CITE = "nomcite";
	public final static String JOUR_DATE_DEBUT = "jourdatedebut";
	public final static String JOUR_DATE_FIN = "jourdatefin";
	public final static String HEURE_DATE_DEBUT = "heuredatedebut";
	public final static String HEURE_DATE_FIN = "heuredatefin";
	public final static String NOM_VALIDE = "nomvalide";

	// Descriptif Sujet
	public final static String OBS_METHODE = "obsmethode";
	public final static String OCC_ETAT_BIOLOGIQUE = "occetatbiologique";
	public final static String OCC_NATURALITE = "occnaturalite";
	public final static String OCC_SEXE = "occsexe";
	public final static String OCC_STADE_DE_VIE = "occstadedevie";
	public final static String OCC_STATUT_BIOGEOGRAPHIQUE = "occstatutbiogeographique";
	public final static String OCC_STATUT_BIOLOGIQUE = "occstatutbiologique";
	public final static String PREUVE_EXISTANTE = "preuveexistante";

	public final static String OBS_DESCRIPTION = "obsdescription";
	public final static String OCC_METHODE_DETERMINATION = "occmethodedetermination";
	public final static String OBS_CONTEXTE = "obscontexte";
	public final static String PREUVE_NUMERIQUE = "preuvenumerique";
	public final static String PREUVE_NON_NUMERIQUE = "preuvenonnumerique";

	// Source
	public final static String STATUT_SOURCE = "statutsource";
	public final static String REF_BIBLIO = "referencebiblio";

	// Regroupements
	public final static String IDENTIFIANT_REGROUPEMENT_PERMANENT = "identifiantregroupementpermanent";
	public final static String METHODE_REGROUPEMENT = "methoderegroupement";
	public final static String TYPE_REGROUPEMENT = "typeregroupement";

	// Dénombrement
	public final static String DENOMBREMENT_MAX = "denombrementmax";
	public final static String DENOMBREMENT_MIN = "denombrementmin";
	public final static String OBJET_DENOMBREMENT = "objetdenombrement";
	public final static String TYPE_DENOMBREMENT = "typedenombrement";

	// Déterminateur
	public final static String DETERMINATEUR_IDENTITE = "determinateuridentite";
	public final static String DETERMINATEUR_NOM_ORGANISME = "determinateurnomorganisme";
	public final static String DETERMINATEUR_MAIL = "determinateurmail";

	// Validateur
	public final static String VALIDATEUR_IDENTITE = "validateuridentite";
	public final static String VALIDATEUR_NOM_ORGANISME = "validateurnomorganisme";
	public final static String VALIDATEUR_MAIL = "validateurmail";

	// Habitat
	public final static String REF_HABITAT = "refhabitat";
	public final static String VERSION_REF_HABITAT = "versionrefhabitat";
	public final static String CODE_HABITAT = "codehabitat";
	public final static String CODE_HAB_REF = "codehabref";

	// Standardisation
	public final static String JDD_METADONNEE_DEE_ID = "jddmetadonneedeeid";
	public final static String TPS_ID = "tpsid";

}
