package fr.ifn.ogam.integration.business;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.sql.Time;

import org.apache.log4j.Logger;
import org.apache.commons.lang3.StringUtils;

import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.metadata.MetadataDAO;
import fr.ifn.ogam.common.database.referentiels.ListReferentielsDAO;
import fr.ifn.ogam.common.util.DSRConstants;
import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.business.checks.CheckExceptionArrayList;
import static fr.ifn.ogam.common.business.checks.CheckCodesGinco.*;
import static fr.ifn.ogam.common.business.UnitTypes.*;
import static fr.ifn.ogam.common.business.Data.*;

/**
 * 
 * Service used to perform specific GINCO DSR coherence checks and calculations
 * 
 * @author scandelier
 *
 */
public class ChecksDSRGincoService implements IntegrationEventListener {

	/***
	 * The logger used to log the errors or several information.**
	 * 
	 * @see org.apache.log4j.Logger
	 */
	private final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The Metadata DAO
	 */
	private MetadataDAO metadataDAO = new MetadataDAO();

	/**
	 * The exception array to store errors
	 */
	private ArrayList<CheckException> alce;

    /**
     * The destination format (table), assuming there is only one
     */
    private String destFormat;

	/**
	 * The list of default values to fill when a value is not given
	 */
	private Map<String, String> defaultValues = new HashMap<String, String>();;

	/**
	 * Perfoms all coherence checks for GINCO DSR
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @param values
	 *            Entry values
	 * @throws Exception, CheckException
	 *             in case of database error
	 */
	public void beforeLineInsertion(Integer submissionId, Map<String, GenericData> values) throws Exception, CheckException, CheckExceptionArrayList {

		logger.debug("coherenceChecks");
		if (values.size() == 0) {
			return;
		}

		alce = new ArrayList<CheckException>();

        // We need to know the destination format (table) of all fields,
        // so We assume the destination fomat is the same for all fields, so we
        // put the same as the one of SUBMISSION_ID (always existing field, whatever the model definition)
        // GenericData submissionIdGD = values.get(SUBMISSION_ID);
        // destFormat = submissionIdGD.getFormat();
        // --
        // This first idea didn't work because the format is no a real one for technical fields;
        // So we take jour_date_debut which is mandatory in Occtax models
        GenericData jourDateDebutGD = values.get(DSRConstants.JOUR_DATE_DEBUT);
        destFormat = jourDateDebutGD.getFormat();

		// Then we check if every value we deal with (possible insertion of values) created as a Generic Data
        Map<String, String> fields = new HashMap<String, String>();
        fields.put(DSRConstants.OBS_METHODE, CODE);
        fields.put(DSRConstants.OCC_ETAT_BIOLOGIQUE, CODE);
        fields.put(DSRConstants.OCC_SEXE, CODE);
        fields.put(DSRConstants.OCC_NATURALITE, CODE);
        fields.put(DSRConstants.OCC_STADE_DE_VIE, CODE);
        fields.put(DSRConstants.OCC_STATUT_BIOGEOGRAPHIQUE, CODE);
        fields.put(DSRConstants.OCC_STATUT_BIOLOGIQUE, CODE);
        fields.put(DSRConstants.PREUVE_EXISTANTE, CODE);
        fields.put(DSRConstants.PREUVE_NUMERIQUE, CODE);
        fields.put(DSRConstants.PREUVE_NON_NUMERIQUE, CODE);
        fields.put(DSRConstants.DETERMINATEUR_NOM_ORGANISME, STRING);
        fields.put(DSRConstants.NOM_VALIDE, STRING);
        fields.put(DSRConstants.HEURE_DATE_DEBUT, TIME);
        fields.put(DSRConstants.HEURE_DATE_FIN, TIME);
        fields.put(DSRConstants.VERSION_REF_MAILLE, STRING);
        fields.put(DSRConstants.NOM_REF_MAILLE, STRING);
        fields.put(DSRConstants.VERSION_TAXREF, STRING);

        for (Map.Entry<String, String> field : fields.entrySet()) {
            if (!values.containsKey(field.getKey())) {
                GenericData data = new GenericData();
                data.setFormat(destFormat);
                data.setColumnName(field.getKey());
                data.setType(field.getValue());
                values.put(field.getKey(), data);
            }
        }

        // ----- SUJET OBSERVATION ------

		// If cdNom or cdRef Given, versionTaxref must be present. If not, fill it with default value
		taxrefVersion(values);

		// jourDateDebut < jourDateFin < today
		observationDatesAreCoherent(values);

		// If heureDateDebut or heureDateFin is not given, fill with default values
		fillHeureDateIfEmpty(values);

		// Fills nomValide" if empty
		calculateValuesSujetObservation(values);

		// ----- SOURCE ------

		// If statutSource = "LI", then refernceBiblio must not be empty
		biblioReference(values);

		// ----- DESCRIPTIF SUJET ------

		// descriptifSujet is 0..1 with 8 mandatory fields
		String[] descriptifSujetAll = { DSRConstants.OBS_METHODE, DSRConstants.OCC_ETAT_BIOLOGIQUE, DSRConstants.OCC_NATURALITE, DSRConstants.OCC_SEXE,
				DSRConstants.OCC_STADE_DE_VIE, DSRConstants.OCC_STATUT_BIOGEOGRAPHIQUE, DSRConstants.OCC_STATUT_BIOLOGIQUE, DSRConstants.PREUVE_EXISTANTE,
				DSRConstants.OBS_DESCRIPTION, DSRConstants.OCC_METHODE_DETERMINATION, DSRConstants.PREUVE_NUMERIQUE, DSRConstants.OBS_CONTEXTE,
				DSRConstants.PREUVE_NON_NUMERIQUE };
		String[] descriptifSujetMandatory = { DSRConstants.OBS_METHODE, DSRConstants.OCC_ETAT_BIOLOGIQUE, DSRConstants.OCC_NATURALITE,
				DSRConstants.OCC_SEXE, DSRConstants.OCC_STADE_DE_VIE, DSRConstants.OCC_STATUT_BIOGEOGRAPHIQUE, DSRConstants.OCC_STATUT_BIOLOGIQUE,
				DSRConstants.PREUVE_EXISTANTE };

		// Tests if one field of descriptif sujet is not empty
		ArrayList<String> notEmptyFieldsinDescriptifSujet = notEmptyInList(descriptifSujetAll, values);
		if (notEmptyFieldsinDescriptifSujet.size() > 0) {
			// If previous test is true, then fill mandatory fields with default values
			calculateValuesDescriptifSujet(values);
		}

		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(descriptifSujetAll, descriptifSujetMandatory, values, "Descriptif Sujet");

		// If preuveExistante = "OUI", then preuveNumerique or preuveNonNumerique must be given
		// If preuveExistante = "NON", then preuveNumerique and preuveNonNumerique must be empty
		existingProof(values);

		// ----- REGROUPEMENT ------

		String[] regroupementAll = { DSRConstants.IDENTIFIANT_REGROUPEMENT_PERMANENT, DSRConstants.METHODE_REGROUPEMENT, DSRConstants.TYPE_REGROUPEMENT };
		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(regroupementAll, regroupementAll, values, "Regroupement");

		// ----- DENOMBREMENT ------

		String[] denombrementAll = { DSRConstants.DENOMBREMENT_MAX, DSRConstants.DENOMBREMENT_MIN, DSRConstants.OBJET_DENOMBREMENT,
				DSRConstants.TYPE_DENOMBREMENT };
		String[] denombrementMandatory = { DSRConstants.DENOMBREMENT_MAX, DSRConstants.DENOMBREMENT_MIN, DSRConstants.OBJET_DENOMBREMENT };
		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(denombrementAll, denombrementMandatory, values, "Dénombrement");

		// ----- HABITAT ------

		String[] habitatAll = { DSRConstants.REF_HABITAT, DSRConstants.VERSION_REF_HABITAT, DSRConstants.CODE_HABITAT, DSRConstants.CODE_HAB_REF };
		String[] habitatMandatory = { DSRConstants.REF_HABITAT, DSRConstants.VERSION_REF_HABITAT };
		// Habitat is 0..*, with 2 mandatory fields
		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(habitatAll, habitatMandatory, values, "Habitat");

		// If exists habitats...
		String[] habitatArrays = { DSRConstants.REF_HABITAT, DSRConstants.CODE_HABITAT, DSRConstants.CODE_HAB_REF };
		ArrayList<String> notEmptyHabitats = notEmptyInList(habitatArrays, values);
		if (notEmptyHabitats.size() > 0) {
			// ... same number of elements in refHabitat, codeHabitat, codeHabRef
			sameLengthForAllFields(habitatArrays, values);

			// Coherence between refHabitat, codeHabitat and codeHabref
			habitatsCoherence(values);
		}

		// ----- DETERMINATEUR ------

		// Determinateur is 0..* (0..1 for now), with 2 mandatory fields
		String[] determinateurAll = { DSRConstants.DETERMINATEUR_IDENTITE, DSRConstants.DETERMINATEUR_NOM_ORGANISME, DSRConstants.DETERMINATEUR_MAIL };
		String[] determinateurMandatory = { DSRConstants.DETERMINATEUR_IDENTITE, DSRConstants.DETERMINATEUR_NOM_ORGANISME };

		// Tests if one field of determinateur is not empty
		ArrayList<String> notEmptyFieldsinDeterminateur = notEmptyInList(determinateurAll, values);
		if (notEmptyFieldsinDeterminateur.size() > 0) {
			// If previous test is true, then fill mandatory fields with default values
			calculateValuesDeterminateur(values);
		}

		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(determinateurAll, determinateurMandatory, values, "Déterminateur");

		// ----- VALIDATEUR ------

		// Validateur is 0..* (0..1 for now), with 2 mandatory fields
		String[] validateurAll = { DSRConstants.VALIDATEUR_IDENTITE, DSRConstants.VALIDATEUR_NOM_ORGANISME, DSRConstants.VALIDATEUR_MAIL };
		String[] validateurMandatory = { DSRConstants.VALIDATEUR_IDENTITE, DSRConstants.VALIDATEUR_NOM_ORGANISME };
		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(validateurAll, validateurMandatory, values, "Validateur");

		// ----- OBJET GEOGRAPHIQUE ------

		// Objet Geographique is 0..1
		String[] objetGeoAll = { DSRConstants.GEOMETRIE, DSRConstants.NATURE_OBJET_GEO, DSRConstants.PRECISION_GEOMETRIE };
		String[] objetGeoMandatory = { DSRConstants.GEOMETRIE, DSRConstants.NATURE_OBJET_GEO };
		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(objetGeoAll, objetGeoMandatory, values, "Objet Géographique");

		// ----- COMMUNES ------

		// Commune is 0..*
		String[] communeAll = { DSRConstants.CODE_COMMUNE, DSRConstants.NOM_COMMUNE, DSRConstants.ANNEE_REF_COMMUNE, DSRConstants.TYPE_INFO_GEO_COMMUNE };
		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(communeAll, communeAll, values, "Communes");

		// same number of elements in codeCommune and nomCommune
		String[] codeNomCommune = { DSRConstants.CODE_COMMUNE, DSRConstants.NOM_COMMUNE };
		ArrayList<String> notEmptyCommunes = notEmptyInList(codeNomCommune, values);
		if (notEmptyCommunes.size() > 0) {
			sameLengthForAllFields(codeNomCommune, values);
		}

		// ----- DEPARTEMENT ------

		// Departement is 0..*
		String[] departementAll = { DSRConstants.CODE_DEPARTEMENT, DSRConstants.ANNEE_REF_DEPARTEMENT, DSRConstants.TYPE_INFO_GEO_DEPARTEMENT };
		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(departementAll, departementAll, values, "Départements");

		// ----- MAILLE ------

        // Maille is 0..*
        String[] mailleAll = { DSRConstants.CODE_MAILLE, DSRConstants.TYPE_INFO_GEO_MAILLE };
        ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(mailleAll, mailleAll, values, "Mailles");

        // If nomRefMaille or versionRefMaille is not empty, the other must be filled.
		// If not, but codeMaille is filled, we fill them with defaut values taken from list_referentiels table
		String[] mailleRef = { DSRConstants.VERSION_REF_MAILLE, DSRConstants.NOM_REF_MAILLE };
		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(mailleRef, mailleRef, values, "Référentiel Mailles");

        maillesVersion(values);

        // ----- MASSE D'EAU ------

		// Masse d'eau is 0..*
		String[] massedeauAll = { DSRConstants.CODE_ME, DSRConstants.VERSION_ME, DSRConstants.DATE_ME, DSRConstants.TYPE_INFO_GEO_ME };
		ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(massedeauAll, massedeauAll, values, "Masses d'Eau");

		// todo Espace Naturel is 0..*

		// ----- GEOREFERENCE ------

		// One and only one georeferenced object must be given
		oneGeoreferencedObject(values);

		// if errors have been found while doing the checks, return an exception containing those to write in check_error
		if( alce.size() > 0) {
			// The arrayList of exceptions
			CheckExceptionArrayList checkExceptionArrayList = new CheckExceptionArrayList();
			checkExceptionArrayList.setCheckExceptionArrayList(alce);
			
			throw checkExceptionArrayList;
		}
	}
	
	/**
	 * Event called before the integration of a submission of data.
	 *
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	public void beforeIntegration(Integer submissionId) throws Exception {

        ListReferentielsDAO refDAO = new ListReferentielsDAO();

        //-- Fill default values

		// Versions taken from referentiels list table
		defaultValues.put(DSRConstants.VERSION_TAXREF, refDAO.getReferentielVersion("taxref"));
		defaultValues.put(DSRConstants.VERSION_REF_MAILLE, refDAO.getReferentielVersion("codemaillevalue"));
		defaultValues.put(DSRConstants.NOM_REF_MAILLE, refDAO.getReferentielLabel("codemaillevalue"));
	}

	/**
	 * Event called after the integration of a submission of data.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	@Override
	public void afterIntegration(Integer submissionId) throws Exception {

		// DO NOTHING

	}

	/**
	 * Perfoms all coherence checks for GINCO DSR
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @param format
	 *            the format of the table
	 * @param tableName
	 *            the name of the table
	 * @param values
	 *            Entry values
	 * @param id
	 *            The identifier corresponding to the ogamId
	 * @throws Exception
	 *             in case of database error
	 */
	public void afterLineInsertion(Integer submissionId, String format, String tableName, Map<String, GenericData> values, String id) throws Exception {
		
		// DO NOTHING
	}

	/**
	 * Tests if at leat one field in a set has a non-empty value.
	 *
	 * @param set
	 *            array of fields names
	 * @param values
	 *            the Map of keys/values for all fields
	 * @return boolean true if one field in the set has a not empty value
	 */
	private boolean isEmptyList(String[] set, Map<String, GenericData> values) {

		// Tests if one of the fields given in list is not empty
		boolean isEmpty = true;
		ArrayList<String> notEmptyFields = notEmptyInList(set, values);
		isEmpty = (notEmptyFields.size() == 0);
		return isEmpty;
	}

	/**
	 * Returns the not-empty fields in the given list
	 *
	 * @param set
	 *            a list of field names
	 * @param values
	 *            the Map of keys/values for all fields
	 * @return
	 */
	private ArrayList<String> notEmptyInList(String[] set, Map<String, GenericData> values) {

		// Finds the not-empty fields of the given list
		ArrayList<String> notEmptyFields = new ArrayList<String>();
		for (String name : set) {
			GenericData dataGD = values.get(name);
			// dataGD is null if the values for name is not defined ==> must be considered as an empty value
			if (dataGD != null) {
				if (!empty(dataGD)) {
					notEmptyFields.add(name);
				}
			}
		}
		return notEmptyFields;
	}

	/**
	 * Returns the empty fields in the given list
	 *
	 * @param set
	 *            a list of field names
	 * @param values
	 *            the Map of keys/values for all fields
	 * @return
	 */
	private ArrayList<String> emptyInList(String[] set, Map<String, GenericData> values) {

		// Finds the empty fields of the given list
		ArrayList<String> emptyFields = new ArrayList<String>();
		for (String name : set) {
			GenericData dataGD = values.get(name);
			// if dataGD is null (not defined in values taken from CSV), it must be considered as empty
			if (dataGD == null) {
				emptyFields.add(name);
			}
			else {
				if (empty(dataGD)) {
					emptyFields.add(name);
				}
			}
		}
		return emptyFields;
	}

	/**
	 * A PHP-like empty function: Returns true if string is null, empty, or contains only whitespaces
	 *
	 * @param s
	 *            String
	 * @return boolean
	 */
	private boolean empty(final String s) {
		// Null-safe, short-circuit evaluation.
		return s == null || s.trim().isEmpty();
	}

	/**
	 * An empty function to test the emptiness of the value of GenericData objects
	 *
	 * @param data
	 *            GenericData
	 * @return
	 */
	private boolean empty(GenericData data) {
		if (data.getValue() == null) {
			return true;
		}

		if (data.getType().equalsIgnoreCase(ARRAY)) {
			String[] dataValue = (String[]) data.getValue();
			// The value is get by splitting the input string on ','
			// and even if it is an empty string, the result is an array of 1 element containing the string ""
			// so we have to test this specific case
			if (dataValue.length == 0) {
				return true;
			} else if (dataValue.length == 1 && empty(dataValue[0])) {
				return true;
			} else {
				return false;
			}
		} else {
			String dataValue = (data.getValue() != null) ? data.getValue().toString() : null;
			return empty(dataValue);
		}
	}

	/**
	 * Tests a condition like "Mandatory Conditionel" (obligatoire conditionnel): if some fields are not empty in the A list, then all fields in the B list must
	 * not be empty.
	 *
	 * @param listA
	 * @param listB
	 * @param values
	 * @param nameOfSet
	 * @throws Exception
	 */
	private void ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(String[] listA, String[] listB, Map<String, GenericData> values, String nameOfSet)
			throws CheckException {

		// Tests if one of the A list is not empty (length of returned array is >0)
		ArrayList<String> notEmptyFieldsinA = notEmptyInList(listA, values);

		// If previous test is true, then all fields in the B list must be not empty
		if (notEmptyFieldsinA.size() > 0) {
			ArrayList<String> emptyFieldsinB = emptyInList(listB, values);

			if (emptyFieldsinB.size() > 0) {
				String errorMessage = "Champs obligatoires conditionnels manquants pour le groupe \"" + nameOfSet + "\" : "
						+ StringUtils.join(emptyFieldsinB, ", ") + " (\"" + nameOfSet + "\" doit être fourni car les champs suivants sont remplis : "
						+ StringUtils.join(notEmptyFieldsinA, ", ") + ").";
				CheckException ce = new CheckException(MANDATORY_CONDITIONAL_FIELDS, errorMessage);
				// Add the exception in the array list and continue doing the checks
				alce.add(ce);
			}
		}
	}

	/**
	 * Tests if all values for given list of fields (list), if they are array and not empty, have the same number of elements
	 *
	 * Empty arrays are not taken into account (you must check if they are not empty before)
	 *
	 * @param list
	 *            list of names of array fields to compare
	 * @param values
	 * @return
	 */
	private boolean sameLengthForAllArrays(String[] list, Map<String, GenericData> values) {

		// Get not-empty arrays in list
		ArrayList<String> notEmpty = notEmptyInList(list, values);

		// If every array is empty, return true (length 0 for all)
		if (notEmpty.size() == 0) {
			return true;
		}

		ArrayList<Integer> length = new ArrayList<Integer>();

		// Lengths of non empty array values
		for (String name : notEmpty) {
			GenericData dataGD = values.get(name);
			if (dataGD.getType().equalsIgnoreCase(ARRAY)) {
				String[] dataValue = (String[]) dataGD.getValue();
				length.add(dataValue.length);
			}
		}

		return (Collections.min(length) == Collections.max(length));
	}

	/**
	 *
	 * @param list
	 * @param values
	 */
	private void sameLengthForAllFields(String[] list, Map<String, GenericData> values) throws CheckException {

		if (!sameLengthForAllArrays(list, values)) {
			String errorMessage = "Les champs suivants doivent avoir le même nombre d'éléments (séparés par des virgules), ou être vides : "
					+ StringUtils.join(list, ", ") + ".";
			CheckException ce = new CheckException(ARRAY_OF_SAME_LENGTH, errorMessage);
			// Add the exception in the array list and continue doing the checks
			alce.add(ce);
		}
	}

	/**
	 * If taxrefVersion is empty and if cdNom or cdRef are present,
	 * fill it with default version
	 *
	 * @param values
	 * @throws Exception
	 */
	private void taxrefVersion(Map<String, GenericData> values) throws CheckException {
		// If cdNom or cdRef Given, versionTaxref must be present
		String[] cdNomRef = { DSRConstants.CD_NOM, DSRConstants.CD_REF };
		ArrayList<String> notEmpty = notEmptyInList(cdNomRef, values);

		if (notEmpty.size() > 0) {
			// checks if versionTaxref is empty
            String[] vTaxref = { DSRConstants.VERSION_TAXREF };
            ArrayList<String> emptyVersion = emptyInList(vTaxref, values);
			if (emptyVersion.size() > 0) {

                // Fills with the default value of versionTaxref (taken from table liste_referentiels)
                GenericData versionTaxrefGD = values.get(DSRConstants.VERSION_TAXREF);
                versionTaxrefGD.setValue(defaultValues.get(DSRConstants.VERSION_TAXREF));
			}
		}
	}

	/**
	 * If mailleReferentielName and version are empty but a code maille is given,
	 * fill it with default version
	 *
	 * @param values
	 * @throws Exception
	 */
	private void maillesVersion(Map<String, GenericData> values) throws CheckException {

        // If typeInfoGeoMaille Given, infos about the referentiel must be present
		String[] codeMaille = { DSRConstants.TYPE_INFO_GEO_MAILLE };
		ArrayList<String> notEmpty = notEmptyInList(codeMaille, values);

		if (notEmpty.size() > 0) {

            // Then checks if they are empty
            String[] refMaille = { DSRConstants.VERSION_REF_MAILLE, DSRConstants.NOM_REF_MAILLE };
            ArrayList<String> emptyVersion = emptyInList(refMaille, values);
			if (emptyVersion.size() > 0) {
                // Fills with the default values (taken from table liste_referentiels)
                GenericData versionRefMailleGD = values.get(DSRConstants.VERSION_REF_MAILLE);
                versionRefMailleGD.setValue(defaultValues.get(DSRConstants.VERSION_REF_MAILLE));

                GenericData nomRefMailleGD = values.get(DSRConstants.NOM_REF_MAILLE);
                nomRefMailleGD.setValue(defaultValues.get(DSRConstants.NOM_REF_MAILLE));
			}
		}
	}

	/**
	 * If statutSource = "Li", then referenceBiblio must not be empty
	 *
	 * @param values
	 * @throws Exception
	 */
	private void biblioReference(Map<String, GenericData> values) throws CheckException {

		GenericData statutSourceGD = values.get(DSRConstants.STATUT_SOURCE);
		if (statutSourceGD != null && !empty(statutSourceGD)) {
			String statutSourceValue = (String) statutSourceGD.getValue();
			if (statutSourceValue.equalsIgnoreCase("LI")) {

				GenericData refBiblioGD = values.get(DSRConstants.REF_BIBLIO);
				if (refBiblioGD == null || empty(refBiblioGD)) {

					String errorMessage = DSRConstants.REF_BIBLIO + " est obligatoire car " + DSRConstants.STATUT_SOURCE + " a la valeur \"Li\".";
					CheckException ce = new CheckException(BIBLIO_REF, errorMessage);
					// Add the exception in the array list and continue doing the checks
					alce.add(ce);
				}
			}
		}
	}

	/**
	 * If preuveExistante = "1" (Yes), then preuveNumerique or preuveNonNumerique must be given Else preuveNumerique and preuveNonNumerique must be empty If
	 * preuveNumerique is not empty, it must be a url (begin with http://, https://, ftp://
	 *
	 * @param values
	 * @throws Exception
	 */
	private void existingProof(Map<String, GenericData> values) throws CheckException {

		GenericData preuveExistanteGD = values.get(DSRConstants.PREUVE_EXISTANTE);
		if (preuveExistanteGD != null && !empty(preuveExistanteGD)) {

			String preuveExistanteValue = (String) preuveExistanteGD.getValue();
			GenericData preuveNumeriqueGD = values.get(DSRConstants.PREUVE_NUMERIQUE);
			GenericData preuveNonNumeriqueGD = values.get(DSRConstants.PREUVE_NON_NUMERIQUE);

			if (preuveExistanteValue.equalsIgnoreCase("1")) {

				if (empty(preuveNumeriqueGD) && empty(preuveNonNumeriqueGD)) {
					String errorMessage = DSRConstants.PREUVE_NUMERIQUE + " ou " + DSRConstants.PREUVE_NON_NUMERIQUE + " sont obligatoires car "
							+ DSRConstants.PREUVE_EXISTANTE + " vaut \"1\" (Oui).";
					CheckException ce = new CheckException(PROOF, errorMessage);
					// Add the exception in the array list and continue doing the checks
					alce.add(ce);
				}

				// preuveNumerique doit commencer comme une url
				if (!empty(preuveNumeriqueGD)) {
					String preuveNumeriqueValue = (String) preuveNumeriqueGD.getValue();
					if (!StringUtils.startsWithAny(preuveNumeriqueValue.toLowerCase(), new String[] { "http://", "https://", "ftp://" })) {
						String errorMessage = DSRConstants.PREUVE_NUMERIQUE
								+ " doit être une adresse web et commencer par \"http://\", \"https://\" ou \"ftp://\".";
						CheckException ce = new CheckException(NUMERIC_PROOF_URL, errorMessage);
						// Add the exception in the array list and continue doing the checks
						alce.add(ce);
					}
				}

			} else {

				String[] proofs = { DSRConstants.PREUVE_NUMERIQUE, DSRConstants.PREUVE_NON_NUMERIQUE };
				ArrayList<String> notEmpty = notEmptyInList(proofs, values);

				if (notEmpty.size() > 0) {
					String errorMessage = DSRConstants.PREUVE_EXISTANTE + " ne vaut pas \"1\" (oui) donc les champs suivants doivent être vides : "
							+ StringUtils.join(notEmpty, ", ") + ".";
					CheckException ce = new CheckException(PROOF, errorMessage);
					// Add the exception in the array list and continue doing the checks
					alce.add(ce);
				}
			}
		}
	}

	/**
	 * Checks the coherence between Habitats fields:
	 *
	 * If refHabitat != "HABREF", then codeHabitat must not be empty Else, one of codeHabitat and codeHabRef must not be empty
	 *
	 * As these are ARRAY values, it must be true for all elemnts of the arrays.
	 *
	 * @param values
	 * @throws Exception
	 */
	private void habitatsCoherence(Map<String, GenericData> values) throws CheckException {

		GenericData refHabitatGD = values.get(DSRConstants.REF_HABITAT);
		GenericData codeHabitatGD = values.get(DSRConstants.CODE_HABITAT);
		GenericData codeHabRefGD = values.get(DSRConstants.CODE_HAB_REF);

		// We tested before that REF_HABITAT is not empty
		String[] refHabitatArray = (String[]) refHabitatGD.getValue();

		// If these two arrays exists, we already tested they have the same length than refHabitatArray
		String[] codeHabitatArray = null;
		if (!empty(codeHabitatGD)) {
			codeHabitatArray = (String[]) codeHabitatGD.getValue();
		}

		String[] codeHabRefArray = null;
		if (!empty(codeHabRefGD)) {
			codeHabRefArray = (String[]) codeHabRefGD.getValue();
		}

		for (int i = 0; i < refHabitatArray.length; i++) {
			String refHabitatValue = refHabitatArray[i];

			if (!refHabitatValue.equalsIgnoreCase("HABREF")) {
				// codeHabitat must be given
				if (codeHabitatArray == null || empty(codeHabitatArray[i])) {
					String errorMessage = DSRConstants.CODE_HABITAT + " est obligatoire car " + DSRConstants.REF_HABITAT + " n'est pas HABREF (position "
							+ (i + 1) + ").";
					CheckException ce = new CheckException(HABITAT, errorMessage);
					// Add the exception in the array list and continue doing the checks
					alce.add(ce);
				}
			} else {
				// codeHabitat ou codeHabRef doit être fourni.
				if ((codeHabitatArray == null || empty(codeHabitatArray[i])) && (codeHabRefArray == null || empty(codeHabRefArray[i]))) {
					String errorMessage = DSRConstants.CODE_HABITAT + " ou " + DSRConstants.CODE_HAB_REF + " doit être fourni (position " + (i + 1) + ").";
					CheckException ce = new CheckException(HABITAT, errorMessage);
					// Add the exception in the array list and continue doing the checks
					alce.add(ce);
				}
			}
		}
	}

	/**
	 * Checks two things :
	 *
	 * 1) At least one georeference is given: it can be geometry, or a typeInfoGeo = 1 2) No more than one typeINfoGeo field can = 1
	 *
	 * @param values
	 * @throws Exception
	 */
	private void oneGeoreferencedObject(Map<String, GenericData> values) throws CheckException {

		GenericData geometrieGD = values.get(DSRConstants.GEOMETRIE);

		// todo: add TYPE_INFO_GEO_EN et TYPE_INFO_GEO_ME
		String[] typeInfoGeoAll = { DSRConstants.TYPE_INFO_GEO_COMMUNE, DSRConstants.TYPE_INFO_GEO_DEPARTEMENT, DSRConstants.TYPE_INFO_GEO_MAILLE };

		int georeferencedObjectsNumber = 0;

		for (String name : typeInfoGeoAll) {
			GenericData typeInfoGeoGD = values.get(name);
			if (typeInfoGeoGD != null && !empty(typeInfoGeoGD)) {
				String typeInfoGeoValue = (String) typeInfoGeoGD.getValue();
				if (typeInfoGeoValue.equals("1")) {
					georeferencedObjectsNumber++;
				}
			}
		}

		String[] typeInfoGeoUnauthorized = { DSRConstants.TYPE_INFO_GEO_EN, DSRConstants.TYPE_INFO_GEO_ME };

		int georeferencedUnauthorizedNumber = 0;

		for (String name : typeInfoGeoUnauthorized) {
			GenericData typeInfoGeoGD = values.get(name);
			if (typeInfoGeoGD != null && !empty(typeInfoGeoGD)) {
				String typeInfoGeoValue = (String) typeInfoGeoGD.getValue();
				if (typeInfoGeoValue.equals("1")) {
					georeferencedUnauthorizedNumber++;
				}
			}
		}

		// At least one georeferenced object must be given, ie geometry or one typeInfoGeo = 1
		if (geometrieGD == null || empty(geometrieGD) && (georeferencedObjectsNumber == 0)) {
			String errorMessage = "Au moins un géoréférencement doit être livré: soit une géométrie dans le champ " + DSRConstants.GEOMETRIE
					+ ", soit l'un des champs suivants doit valoir 1 : " + StringUtils.join(typeInfoGeoAll, ", ") + ".";
			if (georeferencedUnauthorizedNumber > 0) {
				errorMessage += " GINCO n'accepte pas les géoréférencements aux espaces naturels ou masses d'eau.";
			}
			CheckException ce = new CheckException(NO_GEOREFERENCE, errorMessage);
			// Add the exception in the array list and continue doing the checks
			alce.add(ce);
		
		} else if (georeferencedObjectsNumber > 1) {
			String errorMessage = "Un seul des champs typeInfoGeo peut valoir 1 (parmi " + StringUtils.join(typeInfoGeoAll, ", ") + ").";
			CheckException ce = new CheckException(MORE_THAN_ONE_GEOREFERENCE, errorMessage);
			// Add the exception in the array list and continue doing the checks
			alce.add(ce);
		}
	}


	/**
	 * Fills nomValide if it is empty.
	 *
	 * @param values
	 */
	private void calculateValuesSujetObservation(Map<String, GenericData> values) throws Exception {

		// -- Calculate nomValide
		GenericData nomValideGD = values.get(DSRConstants.NOM_VALIDE);
		if (nomValideGD != null) {
			if (empty(nomValideGD)) {
				GenericData cdRefGD = values.get(DSRConstants.CD_REF);
				if (!empty(cdRefGD)) {
					try {
						List<String> codeNames = metadataDAO.getNameFromTaxrefCode(cdRefGD.getValue().toString());
						String nomValide = codeNames.get(0);
						nomValideGD.setValue(nomValide);
					} catch (Exception e) {
						throw e;
					}
				} else {
					GenericData cdNomGD = values.get(DSRConstants.CD_NOM);
					if (!empty(cdNomGD)) {
						try {
							List<String> codeNames = metadataDAO.getNameFromTaxrefCode(cdNomGD.getValue().toString());
							String nomValide = codeNames.get(0);
							nomValideGD.setValue(nomValide);
						} catch (Exception e) {
							throw e;
						}
					}
				}
			}
		}
	}

	/**
	 * Fills mandatory fields of Descriptif Sujet if empty
	 *
	 * @param values
	 */
	private void calculateValuesDescriptifSujet(Map<String, GenericData> values) {

		// Default Values
		Map<String, String> defaultValuesMap = new HashMap<String, String>();
		defaultValuesMap.put(DSRConstants.OBS_METHODE, "21"); // "Inconnu"
		defaultValuesMap.put(DSRConstants.OCC_ETAT_BIOLOGIQUE, "1"); // "L'information n'a pas été renseignée. "
		defaultValuesMap.put(DSRConstants.OCC_SEXE, "0"); // "Inconnu : Il n'y a pas d'information disponible pour cet individu, parce que cela n'a pas été
															// renseigné."
		defaultValuesMap.put(DSRConstants.OCC_NATURALITE, "0"); // "Inconnu : la naturalité du sujet est inconnue"
		defaultValuesMap.put(DSRConstants.OCC_STADE_DE_VIE, "0"); // "Le stade de vie de l'individu n'est pas connu."
		defaultValuesMap.put(DSRConstants.OCC_STATUT_BIOGEOGRAPHIQUE, "1"); // "Non renseigné"
		defaultValuesMap.put(DSRConstants.OCC_STATUT_BIOLOGIQUE, "1"); // "Non renseigné"

		for (Map.Entry<String, String> entry : defaultValuesMap.entrySet()) {
			GenericData dataGD = values.get(entry.getKey());
			if (dataGD != null) {
				if (empty(dataGD)) {
					dataGD.setValue(entry.getValue());
				}
			}
		}

		// preuveExistante: depends of the presence of preuveNumerique and preuveNonNumerique
		// If one of preuveNumerique and preuveNonNumerique is given --> 1 (Yes)
		// If none is given --> 0 (NSP)
		GenericData preuveExistanteGD = values.get(DSRConstants.PREUVE_EXISTANTE);
		if (preuveExistanteGD != null && empty(preuveExistanteGD)) {
			GenericData preuveNumeriqueGD = values.get(DSRConstants.PREUVE_NUMERIQUE);
			GenericData preuveNonNumeriqueGD = values.get(DSRConstants.PREUVE_NON_NUMERIQUE);
			if (empty(preuveNumeriqueGD) && empty(preuveNonNumeriqueGD)) {
				preuveExistanteGD.setValue("0"); // NSP
			} else {
				preuveExistanteGD.setValue("1"); // Yes
			}
		}
	}

	/**
	 * Fills determinateurNomOrganisme if empty
	 *
	 * @param values
	 */
	private void calculateValuesDeterminateur(Map<String, GenericData> values) {

		GenericData determinateurOrganismeGD = values.get(DSRConstants.DETERMINATEUR_NOM_ORGANISME);
		if (empty(determinateurOrganismeGD)) {
			determinateurOrganismeGD.setValue("Inconnu");
		}
	}

	/**
	 * Checks that dates are in a logical time order
	 *
	 * @param values
	 */
	private void observationDatesAreCoherent(Map<String, GenericData> values) throws CheckException {

		GenericData jourDateDebutGD = values.get(DSRConstants.JOUR_DATE_DEBUT);
		GenericData jourDateFinGD = values.get(DSRConstants.JOUR_DATE_FIN);

		Date jourDateDebutValue = (Date) jourDateDebutGD.getValue();
		Date jourDateFinValue = (Date) jourDateFinGD.getValue();

		if (jourDateDebutValue != null && jourDateFinValue != null) {

			Date now = new Date();

			if (jourDateDebutValue.after(jourDateFinValue)) {
				String errorMessage = "La valeur de " + DSRConstants.JOUR_DATE_DEBUT + " est ultérieure à celle de " + DSRConstants.JOUR_DATE_FIN + ".";
				CheckException ce = new CheckException(DATE_ORDER, errorMessage);
				// Add the exception in the array list and continue doing the checks
				alce.add(ce);
			}

			if (jourDateFinValue.after(now)) {
				String errorMessage = "La valeur de " + DSRConstants.JOUR_DATE_FIN + " est ultérieure à la date du jour.";
				CheckException ce = new CheckException(DATE_ORDER, errorMessage);
				// Add the exception in the array list and continue doing the checks
				alce.add(ce);
			}
		}
	}

	/**
	 * Checks that heureDateDebut and heureDateFin are not empty.
	 * If so, fill with default values:
	 * heureDateDebut: 00:00:00
	 * heureDateFin: 23:59:59
	 *
	 * @param values
	 */
	private void fillHeureDateIfEmpty(Map<String, GenericData> values) throws CheckException {

		GenericData heureDateDebutGD = values.get(DSRConstants.HEURE_DATE_DEBUT);
		if (empty(heureDateDebutGD)) {
			Time heureDateDebut = new Time(0,0,0);
			heureDateDebutGD.setValue(heureDateDebut);
		}
		GenericData heureDateFinGD = values.get(DSRConstants.HEURE_DATE_FIN);
		if (empty(heureDateFinGD)) {
			Time heureDateFin = new Time(23,59,59);
			heureDateFinGD.setValue(heureDateFin);
		}
	}
}
