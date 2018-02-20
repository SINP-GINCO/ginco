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

import java.util.HashMap;
import java.util.Map;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.Date;

import fr.ifn.ogam.integration.AbstractEFDACTest;
import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.util.DSRConstants;
import fr.ifn.ogam.common.business.checks.CheckException;
import static fr.ifn.ogam.common.business.checks.CheckCodesGinco.*;
import static fr.ifn.ogam.common.business.UnitTypes.*;

/**
 * Test cases for the ChecksDSRGinco class.
 *
 * @author scandelier
 */
public class ChecksDSRGincoTest extends AbstractGINCOTest {

	// The services
	private ChecksDSRGinco checksDSR = new ChecksDSRGinco();

	/**
	 * Constructor
	 *
	 * @param name
	 */
	public ChecksDSRGincoTest(String name) {
		super(name);
	}

	/**
	 * Do NOT initiate database: we don't need it here.
	 */
	protected void initiateDatabase() {
	}

	/**
	 * Test coherence-OK values
	 *
	 * Get baseValues, a set of DSR-coherent key/values, and test coherenceChecks. The function must execute without raising any Exception.
	 *
	 */
	public void testCoherentValues() {

		Map<String, GenericData> baseValues = getBaseValuesMap();
		// System.out.print(baseValues);

		try {
			checksDSR.coherenceChecks(baseValues);
			assertTrue(true);
		} catch (CheckException e) {
			assertTrue(false);
		} catch (Exception e) {
			assertTrue(false);
		}

	}

	/**
	 * Test values with descriptif sujet given by one field, and other mandatory fields present Normally, other "Descriptif Sujet" fields are filled with
	 * default values Get base values and change just the ones needed to make the coherence checks fail.
	 *
	 */
	public void testMissingFieldsInDescriptifSujet() {

		Map<String, GenericData> values = getBaseValuesMap();

		// Modify values to make "Descriptif Sujet" present, but with missing fields
		values.get(DSRConstants.OCC_STATUT_BIOLOGIQUE).setValue("1");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised
			// Check if one of the other fields is correctly filled
			assertEquals(values.get(DSRConstants.OBS_METHODE).getValue(), "21");

		} catch (CheckException e) {
			// If we get here, error is raised, so other mandatory fields are not filled --> bad
			assertTrue(false);
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with regroupement given by one field, and other mandatory fields present
	 *
	 * Get base values and change just the ones needed to make the coherence checks fail.
	 *
	 */
	public void testMissingFieldsInRegroupement() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.IDENTIFIANT_REGROUPEMENT_PERMANENT).setValue("Mon regroupement");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MANDATORY_CONDITIONAL_FIELDS);
			// Check the message contains the name of the group: "Descriptif Sujet"
			assertTrue(e.getMessage().contains("Regroupement"));
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with missing version taxref
	 *
	 */
	public void testMissingVersionTaxref() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.VERSION_TAXREF).setValue("");
		values.get(DSRConstants.CD_NOM).setValue("60615");
		values.get(DSRConstants.CD_REF).setValue("");
		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			System.out.print(e.getMessage());
			assertEquals(e.getCheckCode(), TAXREF_VERSION);

		} catch (Exception e) {
			assertTrue(false);
		}

		values.get(DSRConstants.CD_NOM).setValue("");
		values.get(DSRConstants.CD_REF).setValue("60615");
		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), TAXREF_VERSION);
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with denombrement given by one field, and other mandatory fields missing
	 *
	 */
	public void testMissingFieldsInDenombrement() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.DENOMBREMENT_MIN).setValue("1");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MANDATORY_CONDITIONAL_FIELDS);
			// Check the message contains the name of the group: "Descriptif Sujet"
			assertTrue(e.getMessage().contains("Dénombrement"));
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with validateur given by one field, and other mandatory fields missing
	 *
	 */
	public void testMissingFieldsInValidateur() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.VALIDATEUR_IDENTITE).setValue("");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MANDATORY_CONDITIONAL_FIELDS);
			// Check the message contains the name of the group: "Descriptif Sujet"
			assertTrue(e.getMessage().contains("Validateur"));
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with determinateur given by one field, and other mandatory fields missing
	 *
	 */
	public void testMissingFieldsInDeterminateur() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.DETERMINATEUR_MAIL).setValue("determinateur@mail.fr");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MANDATORY_CONDITIONAL_FIELDS);
			// Check the message contains the name of the group: "Determinateur"
			assertTrue(e.getMessage().contains("Déterminateur"));
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with determinateur identite given, and mandatory field nomOrganisme missing
	 *
	 */
	public void testMissingFieldNomOrganismeInDeterminateur() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.DETERMINATEUR_IDENTITE).setValue("M. déterminateur");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, the mandatory value has been filled ==> good
			assertTrue(true);
		} catch (CheckException e) {
			// If we get here, error is raised, so other mandatory fields are not filled --> bad
			assertTrue(false);
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with objet geographique given by one field, and other mandatory fields missing
	 *
	 */
	public void testMissingFieldsInObjetGeo() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.NATURE_OBJET_GEO).setValue("");
		values.get(DSRConstants.PRECISION_GEOMETRIE).setValue("");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MANDATORY_CONDITIONAL_FIELDS);
			// Check the message contains the name of the group: "Descriptif Sujet"
			assertTrue(e.getMessage().contains("Objet Géographique"));
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with commune given by one field, and other mandatory fields missing
	 *
	 */
	public void testMissingFieldsInCommune() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.TYPE_INFO_GEO_COMMUNE).setValue("");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MANDATORY_CONDITIONAL_FIELDS);
			// Check the message contains the name of the group: "Descriptif Sujet"
			assertTrue(e.getMessage().contains("Communes"));
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with not the same number of code commune and name commune
	 *
	 */
	public void testNotTheSameNumberOfElementsInCommune() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.CODE_COMMUNE).setValue(new String[] { "94080", "94067" });
		values.get(DSRConstants.NOM_COMMUNE).setValue(new String[] { "Vincennes" });

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), ARRAY_OF_SAME_LENGTH);
			// Check the message contains the name of the group: "Descriptif Sujet"
			assertTrue(e.getMessage().contains(DSRConstants.CODE_COMMUNE));
			assertTrue(e.getMessage().contains(DSRConstants.NOM_COMMUNE));
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with commune given by one field, and other mandatory fields missing
	 *
	 */
	public void testMissingFieldsInDepartement() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.CODE_DEPARTEMENT).setValue(new String[] { "17" });
		values.get(DSRConstants.ANNEE_REF_DEPARTEMENT).setValue("2016");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MANDATORY_CONDITIONAL_FIELDS);
			// Check the message contains the name of the group: "Descriptif Sujet"
			assertTrue(e.getMessage().contains("Départements"));
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with mailles given by one field, and other mandatory fields missing
	 *
	 */
	public void testMissingFieldsInMaille() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.CODE_MAILLE).setValue(new String[] { "E041N653", "E041N652", "E042N652" });

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MANDATORY_CONDITIONAL_FIELDS);
			// Check the message contains the name of the group: "Descriptif Sujet"
			assertTrue(e.getMessage().contains("Mailles"));
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with missing refernec biblio when statutSource="Li"
	 *
	 */
	public void testMissingReferenceBiblio() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.STATUT_SOURCE).setValue("Li");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), BIBLIO_REF);
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with proof incoherence
	 *
	 */
	public void testProof() {

		Map<String, GenericData> values = getBaseValuesMap();

		values.get(DSRConstants.OBS_METHODE).setValue("21");
		values.get(DSRConstants.OCC_ETAT_BIOLOGIQUE).setValue("0");
		values.get(DSRConstants.OCC_NATURALITE).setValue("0");
		values.get(DSRConstants.OCC_SEXE).setValue("0");
		values.get(DSRConstants.OCC_STADE_DE_VIE).setValue("0");
		values.get(DSRConstants.OCC_STATUT_BIOGEOGRAPHIQUE).setValue("0");
		values.get(DSRConstants.OCC_STATUT_BIOLOGIQUE).setValue("1");

		// preuveExistante = oui, no preuveNumerique or preuveNonNumerique

		values.get(DSRConstants.PREUVE_EXISTANTE).setValue("1");
		values.get(DSRConstants.PREUVE_NUMERIQUE).setValue("");
		values.get(DSRConstants.PREUVE_NON_NUMERIQUE).setValue("");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), PROOF);
		} catch (Exception e) {
			assertTrue(false);
		}

		// preuveExistante = non, preuveNonNumerique given

		values.get(DSRConstants.PREUVE_EXISTANTE).setValue("2");
		values.get(DSRConstants.PREUVE_NUMERIQUE).setValue("");
		values.get(DSRConstants.PREUVE_NON_NUMERIQUE).setValue("Référence XXX");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), PROOF);
		} catch (Exception e) {
			assertTrue(false);
		}

		// preuveExistante = oui, preuveNumerique given, but is not a url

		values.get(DSRConstants.PREUVE_EXISTANTE).setValue("1");
		values.get(DSRConstants.PREUVE_NUMERIQUE).setValue("Référence XXX");
		values.get(DSRConstants.PREUVE_NON_NUMERIQUE).setValue("");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), NUMERIC_PROOF_URL);
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test habitats with proof incoherence
	 *
	 */
	public void testHabitats() {

		Map<String, GenericData> values = getBaseValuesMap();

		// habitats: missing fields

		values.get(DSRConstants.REF_HABITAT).setValue(new String[] { "HABREF", "ANTMER" });
		values.get(DSRConstants.VERSION_REF_HABITAT).setValue("");
		values.get(DSRConstants.CODE_HABITAT).setValue(new String[] { "1", "2" });
		values.get(DSRConstants.CODE_HAB_REF).setValue(null);

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MANDATORY_CONDITIONAL_FIELDS);
			// Check the message contains the name of the group: "Descriptif Sujet"
			assertTrue(e.getMessage().contains("Habitat"));
		} catch (Exception e) {
			assertTrue(false);
		}

		// habitats: not the same number of elements

		values.get(DSRConstants.REF_HABITAT).setValue(new String[] { "HABREF", "ANTMER" });
		values.get(DSRConstants.VERSION_REF_HABITAT).setValue("2016");
		values.get(DSRConstants.CODE_HABITAT).setValue(new String[] { "1", "2" });
		values.get(DSRConstants.CODE_HAB_REF).setValue(new String[] { "1", "2", "3" });

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), ARRAY_OF_SAME_LENGTH);
		} catch (Exception e) {
			assertTrue(false);
		}

		// habitats: incoherence codehabitat / referentiel (not HABREF)

		values.get(DSRConstants.REF_HABITAT).setValue(new String[] { "ANTMER" });
		values.get(DSRConstants.VERSION_REF_HABITAT).setValue("2016");
		values.get(DSRConstants.CODE_HABITAT).setValue(null);
		values.get(DSRConstants.CODE_HAB_REF).setValue(new String[] { "1" });

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), HABITAT);
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test no georeference
	 *
	 */
	public void testNoGeoreference() {

		Map<String, GenericData> values = getBaseValuesMap();

		// delete georeferencing fields

		values.get(DSRConstants.GEOMETRIE).setValue("");
		values.get(DSRConstants.NATURE_OBJET_GEO).setValue("");
		values.get(DSRConstants.PRECISION_GEOMETRIE).setValue("");
		values.get(DSRConstants.CODE_COMMUNE).setValue(null);
		values.get(DSRConstants.NOM_COMMUNE).setValue(null);
		values.get(DSRConstants.ANNEE_REF_COMMUNE).setValue("");
		values.get(DSRConstants.TYPE_INFO_GEO_COMMUNE).setValue("");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), NO_GEOREFERENCE);
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test more than one georeference
	 *
	 */
	public void testMoreThanOneGeoreference() {

		Map<String, GenericData> values = getBaseValuesMap();

		// delete georeferencing fields

		values.get(DSRConstants.CODE_DEPARTEMENT).setValue(new String[] { "94" });
		values.get(DSRConstants.ANNEE_REF_DEPARTEMENT).setValue("2016");
		values.get(DSRConstants.TYPE_INFO_GEO_DEPARTEMENT).setValue("1");

		try {
			checksDSR.coherenceChecks(values);
			// If we get here, error is not raised ==> bad
			assertTrue(false);
		} catch (CheckException e) {
			// Check exception
			assertEquals(e.getCheckCode(), MORE_THAN_ONE_GEOREFERENCE);
		} catch (Exception e) {
			assertTrue(false);
		}
	}

	/**
	 * Test values with jourDateDebut > jourDateFin
	 *
	 */
	public void testObservationDatesAreCoherent() {

		Map<String, GenericData> values = getBaseValuesMap();

		String date1 = "2015-01-01";
		String date2 = "2014-01-01";

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

		try {
			Date dateDebut = formatter.parse(date1);
			Date dateFin = formatter.parse(date2);

			values.get(DSRConstants.JOUR_DATE_DEBUT).setValue(dateDebut);
			values.get(DSRConstants.JOUR_DATE_FIN).setValue(dateFin);

			try {
				checksDSR.coherenceChecks(values);
				// If we get here, error is not raised ==> bad
				assertTrue(false);
			} catch (CheckException e) {
				// Check exception
				assertEquals(e.getCheckCode(), DATE_ORDER);
			} catch (Exception e) {
				assertTrue(false);
			}
		} catch (Exception ex) {
			System.out.println(ex);
		}
	}

	/**
	 * Test values with jourDateFin > today
	 *
	 */
	public void testObservationDatesAreCoherentWithToday() {

		Map<String, GenericData> values = getBaseValuesMap();

		String date1 = "2099-01-01";

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

		try {
			Date dateFin = formatter.parse(date1);
			Date now = new Date();

			values.get(DSRConstants.JOUR_DATE_FIN).setValue(dateFin);

			try {
				checksDSR.coherenceChecks(values);
				// If we get here, error is not raised ==> bad
				assertTrue(false);
			} catch (CheckException e) {
				// Check exception
				assertEquals(e.getCheckCode(), DATE_ORDER);
			} catch (Exception e) {
				assertTrue(false);
			}
		} catch (Exception ex) {
			System.out.println(ex);
		}
	}

	/**
	 * A in-memory values map normally passing all coherence checks This is a base value map, as we modify only certain fields in order to test specific checks
	 * in every test.
	 *
	 * @param index
	 * @return the values Map
	 */
	private Map<String, GenericData> getBaseValuesMap() {
		Map<String, GenericData> values = new HashMap<String, GenericData>();
		GenericData gd;

		Map<String, Object> theValues = new HashMap<String, Object>();

		theValues.put(DSRConstants.OGAM_ID + "_" + "table_observation", "1");
		theValues.put(DSRConstants.PROVIDER_ID, "1");

		theValues.put(DSRConstants.GEOMETRIE, "POINT(5.0 48.0)");
		theValues.put(DSRConstants.NATURE_OBJET_GEO, "In");
		theValues.put(DSRConstants.PRECISION_GEOMETRIE, "10");

		theValues.put(DSRConstants.CODE_COMMUNE, new String[] { "94080" });
		theValues.put(DSRConstants.NOM_COMMUNE, new String[] { "Vincennes" });
		theValues.put(DSRConstants.ANNEE_REF_COMMUNE, "2016");
		theValues.put(DSRConstants.TYPE_INFO_GEO_COMMUNE, "1");

		theValues.put(DSRConstants.CODE_DEPARTEMENT, null);
		theValues.put(DSRConstants.ANNEE_REF_DEPARTEMENT, "");
		theValues.put(DSRConstants.TYPE_INFO_GEO_DEPARTEMENT, "");

		theValues.put(DSRConstants.REF_HABITAT, null);
		theValues.put(DSRConstants.VERSION_REF_HABITAT, "");
		theValues.put(DSRConstants.CODE_HABITAT, null);
		theValues.put(DSRConstants.CODE_HAB_REF, null);

		theValues.put(DSRConstants.CODE_MAILLE, null);
		theValues.put(DSRConstants.VERSION_REF_MAILLE, "");
		theValues.put(DSRConstants.NOM_REF_MAILLE, "");
		theValues.put(DSRConstants.TYPE_INFO_GEO_MAILLE, "");

		theValues.put(DSRConstants.CODE_ME, null);
		theValues.put(DSRConstants.VERSION_ME, "");
		theValues.put(DSRConstants.DATE_ME, "");
		theValues.put(DSRConstants.TYPE_INFO_GEO_ME, "");

		theValues.put(DSRConstants.DETERMINATEUR_IDENTITE, "");
		theValues.put(DSRConstants.DETERMINATEUR_NOM_ORGANISME, "");
		theValues.put(DSRConstants.DETERMINATEUR_MAIL, "");

		theValues.put(DSRConstants.VALIDATEUR_IDENTITE, "M. Validateur");
		theValues.put(DSRConstants.VALIDATEUR_NOM_ORGANISME, "Organisme Validateur");
		theValues.put(DSRConstants.VALIDATEUR_MAIL, "");

		theValues.put(DSRConstants.STATUT_SOURCE, "Te");
		theValues.put(DSRConstants.REF_BIBLIO, "");

		theValues.put(DSRConstants.CD_NOM, "60615");
		theValues.put(DSRConstants.CD_REF, "");
		theValues.put(DSRConstants.VERSION_TAXREF, "V8.0");
		theValues.put(DSRConstants.NOM_CITE, "XXX");

		try {
			String stringDateDebut = "2014-01-01";
			String stringDateFin = "2015-01-01";

			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

			Date dateDebut = formatter.parse(stringDateDebut);
			Date dateFin = formatter.parse(stringDateFin);

			theValues.put(DSRConstants.JOUR_DATE_DEBUT, dateDebut);
			theValues.put(DSRConstants.JOUR_DATE_FIN, dateFin);
		} catch (Exception ex) {
			System.out.println(ex);
		}

		theValues.put(DSRConstants.OBS_METHODE, "");
		theValues.put(DSRConstants.OCC_ETAT_BIOLOGIQUE, "");
		theValues.put(DSRConstants.OCC_NATURALITE, "");
		theValues.put(DSRConstants.OCC_SEXE, "");
		theValues.put(DSRConstants.OCC_STADE_DE_VIE, "");
		theValues.put(DSRConstants.OCC_STATUT_BIOGEOGRAPHIQUE, "");
		theValues.put(DSRConstants.OCC_STATUT_BIOLOGIQUE, "");
		theValues.put(DSRConstants.PREUVE_EXISTANTE, "");
		theValues.put(DSRConstants.OBS_DESCRIPTION, "");
		theValues.put(DSRConstants.OCC_METHODE_DETERMINATION, "");
		theValues.put(DSRConstants.OBS_CONTEXTE, "");
		theValues.put(DSRConstants.PREUVE_NUMERIQUE, "");
		theValues.put(DSRConstants.PREUVE_NON_NUMERIQUE, "");

		theValues.put(DSRConstants.DENOMBREMENT_MIN, "");
		theValues.put(DSRConstants.DENOMBREMENT_MAX, "");
		theValues.put(DSRConstants.OBJET_DENOMBREMENT, "");
		theValues.put(DSRConstants.TYPE_DENOMBREMENT, "");

		theValues.put(DSRConstants.IDENTIFIANT_REGROUPEMENT_PERMANENT, "");
		theValues.put(DSRConstants.METHODE_REGROUPEMENT, "");
		theValues.put(DSRConstants.TYPE_REGROUPEMENT, "");

		// Types: default STRING (the same as CODE or other for the tests), some fields are ARRAYS, some fields are DATE
		String[] arrayFields = new String[] { DSRConstants.CODE_COMMUNE, DSRConstants.NOM_COMMUNE, DSRConstants.CODE_DEPARTEMENT, DSRConstants.REF_HABITAT,
				DSRConstants.CODE_HABITAT, DSRConstants.CODE_HAB_REF, DSRConstants.CODE_MAILLE, DSRConstants.CODE_ME };

		String[] dateFields = new String[] { DSRConstants.JOUR_DATE_DEBUT, DSRConstants.JOUR_DATE_FIN };

		for (Map.Entry<String, Object> entry : theValues.entrySet()) {
			String key = entry.getKey();
			Object value = entry.getValue();

			gd = new GenericData();
			gd.setColumnName(key);
			gd.setValue(value);

			if (Arrays.asList(arrayFields).contains(key)) {
				gd.setType(ARRAY);
			} else if (Arrays.asList(dateFields).contains(key)) {
				gd.setType(DATE);
			} else {
				gd.setType(STRING);
			}
			values.put(key, gd);
		}

		return values;
	}

}