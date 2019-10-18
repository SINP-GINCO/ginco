package fr.ifn.ogam.integration.business;

import static fr.ifn.ogam.common.business.UnitTypes.ARRAY;
import static fr.ifn.ogam.common.business.UnitTypes.CODE;
import static fr.ifn.ogam.common.business.UnitTypes.INTEGER;
import static fr.ifn.ogam.common.business.UnitTypes.STRING;
import static fr.ifn.ogam.common.business.UnitTypes.TIME;
import static fr.ifn.ogam.common.business.checks.CheckCodes.INVALID_GEOMETRY;
import static fr.ifn.ogam.common.business.checks.CheckCodesGinco.*;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.apache.log4j.Logger;
import org.apache.commons.lang3.StringUtils;

import fr.ifn.ogam.common.database.metadata.DatasetData;
import fr.ifn.ogam.common.database.metadata.MetadataDAO;
import fr.ifn.ogam.common.database.metadata.StandardData;
import fr.ifn.ogam.common.database.metadata.TableFormatData;
import fr.ifn.ogam.common.database.rawdata.SubmissionDAO;
import fr.ifn.ogam.common.database.rawdata.SubmissionData;
import fr.ifn.ogam.common.database.referentiels.ListReferentielsDAO;
import fr.ifn.ogam.common.util.DSRConstants;
import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.business.checks.CheckExceptionArrayList;
import fr.ifn.ogam.common.database.GenericData;

import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.io.WKTReader;
import com.vividsolutions.jts.operation.valid.*;



/**
 * Abstract class for checking incoming data.
 * @author rpas
 *
 */
abstract class AbstractChecksService implements IntegrationEventListener {
	
	public final static String TABLE_FORMAT_OCCTAX = "observation" ;
	public final static String TABLE_FORMAT_STATION = "station" ;
	public final static String TABLE_FORMAT_HABITAT = "habitat" ;
	
	public final static String STANDARD_OCCTAX = "occtax" ;
	public final static String STANDARD_HABITAT = "habitat" ;
	
	/**
	 * The logger used to log the errors or several information.**
	 *
	 * @see org.apache.log4j.Logger
	 */
	protected final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * The Metadata DAO
	 */
	protected MetadataDAO metadataDAO = new MetadataDAO();
	
	/**
	 * The submission DAO
	 */
	protected SubmissionDAO submissionDAO = new SubmissionDAO() ;
	
	/**
	 * The submission to check
	 */
	protected SubmissionData submission ;
	
	/**
	 * The exception array to store errors
	 */
	protected ArrayList < CheckException > alce ;
	
	/**
	 * The list of default values to fill when a value is not given
	 */
	protected Map<String, String> defaultValues = new HashMap < String, String >();
	
	
	/**
	 * Get the expected table format (observation, station or habitat)
	 * @return
	 */
	abstract public String getExpectedTableFormat() ;
	
	
	/**
	 * Checks if input data table format matches current check service.
	 * @param values
	 * @return
	 */
	protected boolean isCorrectTableFormat(Map < String, GenericData > values) throws Exception {
		
		TableFormatData tableFormat = getTableFormat(values) ;
		if (!tableFormat.getLabel().equals(getExpectedTableFormat())) {
			return false ;
		}
		return true ;
	}
	
	
	/**
	 * Get the expected standard (occtax or habitat).
	 * @return
	 */
	abstract String getExpectedStandard() ;
	
	
	/**
	 * Checks if input data standard matches current check service.
	 * @param submissionId
	 * @return
	 */
	protected boolean isCorrectStandard(Integer submissionId) throws Exception {
		
		StandardData standard = getStandard(submissionId) ;
		if (!standard.getLabel().equals(getExpectedStandard())) {
			return false ;
		}
		return true ;
	}
	
	
	/**
	 * Perfoms all coherence checks for GINCO DSR
	 *
	 * @param submissionId
	 *            the submission identifier
	 * @param values
	 *            Entry values
	 * @throws Exception,
	 *             CheckException CheckException in case of database error
	 */
	public void checkLine(Integer submissionId, Map<String, GenericData> values) throws Exception, CheckException, CheckExceptionArrayList {
		
		logger.debug("coherenceChecks: checkLine");
		alce = new ArrayList < CheckException >();
	}

	/**
	 * Fills default and calculated values
	 *
	 * @param submissionId
	 *            the submission identifier
	 * @param values
	 *            Entry values
	 * @throws Exception,
	 *             CheckException in case of database error
	 */
	public void beforeLineInsertion(Integer submissionId, Map<String, GenericData> values) throws Exception, CheckException, CheckExceptionArrayList {

		logger.debug("coherenceChecks: beforeLineInsertion");
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
		
		logger.debug("coherenceChecks: beforeIntegration");
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
	 * Get standard from submission id
	 * @param submissionId
	 * @return
	 */
	protected StandardData getStandard(Integer submissionId) throws Exception {
		
		SubmissionData submission = submissionDAO.getSubmission(submissionId) ;
		StandardData standard = metadataDAO.getStandardFromDataset(submission.getDatasetId()) ;
		return standard ;
	}
	
	/**
	 * Get the destination table format given input values.
	 * We use a mandatory input to get destination table.
	 * @param values
	 * @return
	 */
	protected TableFormatData getTableFormat(Map < String, GenericData > values) throws Exception {
		
		GenericData gd = null ;
		if (values.containsKey(DSRConstants.JOUR_DATE_DEBUT)) {
			// Mandatory field in table observation and station
			gd = values.get(DSRConstants.JOUR_DATE_DEBUT) ;
		} else if (values.containsKey(DSRConstants.TECHNIQUE_COLLECTE)) {
			// Mandatory field in table habitat
			gd = values.get(DSRConstants.TECHNIQUE_COLLECTE) ;
		} else {
			throw new Exception("[AbstractChecksService::getTableFormat] No mandatory field found in supplied data.") ;
		}
		
		String tableFormatName = gd.getFormat();
		TableFormatData tableFormat = metadataDAO.getTableFormat(tableFormatName) ;
		return tableFormat ;
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
	protected boolean isEmptyList(String[] set, Map<String, GenericData> values) {

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
	protected ArrayList<String> notEmptyInList(String[] set, Map<String, GenericData> values) {

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
	protected ArrayList<String> emptyInList(String[] set, Map<String, GenericData> values) {

		// Finds the empty fields of the given list
		ArrayList<String> emptyFields = new ArrayList<String>();
		for (String name : set) {
			GenericData dataGD = values.get(name);
			// if dataGD is null (not defined in values taken from CSV), it must be considered as empty
			if (dataGD == null) {
				emptyFields.add(name);
			} else {
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
	protected boolean empty(final String s) {
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
	protected boolean empty(GenericData data) {
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
	protected void ifOneOfAIsNotEmptyThenAllOfBMustNotBeEmpty(String[] listA, String[] listB, Map<String, GenericData> values, String nameOfSet)
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
	 * Tests if geometry is valid
	 * @param values
	 */
	protected void geometryIsValid(Map < String, GenericData > values) throws CheckException {
		
		GenericData genericGeometry = values.get(DSRConstants.GEOMETRIE) ;
		if (genericGeometry != null && !empty(genericGeometry)) {
			String wkt = genericGeometry.getValue().toString() ;
			WKTReader reader = new WKTReader() ;
			String error = "La géométrie n'est pas valide : " ;
			try {
				Geometry geometry = reader.read(wkt) ;
				IsValidOp validOp = new IsValidOp(geometry) ;
				if (validOp.isValid()) {
					return ;
				}
				TopologyValidationError topoError = validOp.getValidationError() ;
				error += topoError.toString() ;
				CheckException ce = new CheckException(INVALID_GEOMETRY, error) ;
				ce.setSourceData(DSRConstants.GEOMETRIE) ;
				alce.add(ce) ;
			} catch (Exception e) {
				error += e.getMessage() ;
				CheckException ce = new CheckException(INVALID_GEOMETRY, error) ;
				ce.setSourceData(DSRConstants.GEOMETRIE) ;
				alce.add(ce) ;
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
	protected boolean sameLengthForAllArrays(String[] list, Map<String, GenericData> values) {

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
	protected void sameLengthForAllFields(String[] list, Map<String, GenericData> values) throws CheckException {

		if (!sameLengthForAllArrays(list, values)) {
			String errorMessage = "Les champs suivants doivent avoir le même nombre d'éléments (séparés par des virgules), ou être vides : "
					+ StringUtils.join(list, ", ") + ".";
			CheckException ce = new CheckException(ARRAY_OF_SAME_LENGTH, errorMessage);
			// Add the exception in the array list and continue doing the checks
			alce.add(ce);
		}
	}
	
	
	/**
	 * Merge to dates, with year-month-day from the first and hour-minute-second from the last.
	 * @param Date date
	 * @param Date time
	 * @return Date
	 */
	protected Date combineDateTime(Date date, Date time) {
    	
    	Calendar calendarA = Calendar.getInstance();
    	calendarA.setTime(date);
    	Calendar calendarB = Calendar.getInstance();
    	calendarB.setTime(time);
     
    	calendarA.set(Calendar.HOUR_OF_DAY, calendarB.get(Calendar.HOUR_OF_DAY));
    	calendarA.set(Calendar.MINUTE, calendarB.get(Calendar.MINUTE));
    	calendarA.set(Calendar.SECOND, calendarB.get(Calendar.SECOND));
    	calendarA.set(Calendar.MILLISECOND, calendarB.get(Calendar.MILLISECOND));
     
    	Date result = calendarA.getTime();
    	return result;
    }
	
	/**
	 * Checks if identifiantpermanent is an UUID.
	 * 
	 * @param values
	 */
	protected void identifiantPermanentIsUUID(String idField, Map < String, GenericData > values) {
		
		GenericData identifiantPermanentGeneric = values.get(idField) ;
		if (identifiantPermanentGeneric == null || empty(identifiantPermanentGeneric)) {
			return ;
		}
		//Test complémentaire pour UUID ne marchant pas correctement pour les versions < Java9
		String identifiantPermanent = identifiantPermanentGeneric.getValue().toString() ;
		
		
		try {
			UUID uuid = UUID.fromString(identifiantPermanent) ;
			if((StringUtils.countMatches(identifiantPermanent, "-") !=4) || (identifiantPermanent.length() != 36)) {
				String errorMessage = "La valeur de " + idField + " doit être un UUID valide, ou une valeur vide" ;
				errorMessage += " (valeur fournie : " + identifiantPermanent + ")." ;
				CheckException ce = new CheckException(IDENTIFIANT_PERMANENT_NOT_UUID, errorMessage) ;
				ce.setFoundValue(identifiantPermanent) ;
				alce.add(ce) ;
			
			} 
		} catch (IllegalArgumentException e) {
			String errorMessage = "La valeur de " + idField + " doit être un UUID valide, ou une valeur vide" ;
			errorMessage += " (valeur fournie : " + identifiantPermanent + ")." ;
			CheckException ce = new CheckException(IDENTIFIANT_PERMANENT_NOT_UUID, errorMessage) ;
			ce.setFoundValue(identifiantPermanent) ;
			alce.add(ce) ;
		}
		
	}
	
	
	/**
	 * Checks if permanent id is unique id database.
	 */
	protected void identifiantPermanentIsUnique(String idField, Map < String, GenericData > values) throws Exception, CheckException {
		
		GenericData identifiantPermanentGeneric = values.get(idField) ;
		if (identifiantPermanentGeneric == null || empty(identifiantPermanentGeneric)) {
			return ;
		}
		String identifiantPermanent = identifiantPermanentGeneric.getValue().toString() ;
		
		TableFormatData tableFormat = getTableFormat(values) ;
		int count = metadataDAO.countPermanentId(tableFormat, idField, identifiantPermanent) ;
		if (count > 0) {
			String errorMessage = "La valeur de l'identifiant unique (" + idField + " = " + identifiantPermanent + ") existe déjà en base." ;  
			errorMessage += " Merci d'en fournir une autre ou de laisser la valeur vide pour une attribution automatique." ;
			CheckException ce = new CheckException(IDENTIFIANT_PERMANENT_NOT_UNIQUE, errorMessage) ;
			ce.setSourceData(idField);
			ce.setFoundValue(identifiantPermanent);
			throw ce ;
		}
	}
	
	
	/**
	 * Checks that dates are in a logical time order
	 *
	 * @param values
	 */
	protected void observationDatesAreCoherent(Map<String, GenericData> values) throws CheckException {

		GenericData jourDateDebutGD = values.get(DSRConstants.JOUR_DATE_DEBUT);
		GenericData jourDateFinGD = values.get(DSRConstants.JOUR_DATE_FIN);
		GenericData heureDateDebut = values.get(DSRConstants.HEURE_DATE_DEBUT) ;
		GenericData heureDateFin = values.get(DSRConstants.HEURE_DATE_FIN) ;

		Date jourDateDebutValue = (Date) jourDateDebutGD.getValue() ;
		Date jourDateFinValue = (Date) jourDateFinGD.getValue() ;	
		
		
		if (jourDateDebutValue != null && jourDateFinValue != null) {
			
			Date debut = jourDateDebutValue ;
			Date fin = jourDateFinValue ;
			Date now = new Date() ;
			
			if(debut.compareTo(fin) == 0) {
				if (heureDateDebut != null && heureDateFin != null) {
					Date heureDateDebutValue = (Date) heureDateDebut.getValue() ;
					Date heureDateFinValue = (Date) heureDateFin.getValue() ;
					if(heureDateDebutValue != null && heureDateFinValue != null) {
						logger.debug("HeureDebut:"+heureDateDebutValue.toString());
						debut = combineDateTime(jourDateDebutValue, heureDateDebutValue) ;
						fin = combineDateTime(jourDateFinValue, heureDateFinValue) ;
					}
				}
			}
			
			if (debut.compareTo(fin) > 0) {
				String errorMessage = "La valeur de " + DSRConstants.JOUR_DATE_DEBUT + " / " + DSRConstants.HEURE_DATE_DEBUT + " est ultérieure à celle de " + DSRConstants.JOUR_DATE_FIN + " / " + DSRConstants.HEURE_DATE_FIN + ".";
				CheckException ce = new CheckException(DATE_ORDER, errorMessage);
				// Add the exception in the array list and continue doing the checks
				alce.add(ce);
			}

			if (fin.compareTo(now) > 0) {
				String errorMessage = "La valeur de " + DSRConstants.JOUR_DATE_FIN + " / " + DSRConstants.HEURE_DATE_FIN + " est ultérieure à la date du jour.";
				CheckException ce = new CheckException(DATE_ORDER, errorMessage);
				// Add the exception in the array list and continue doing the checks
				alce.add(ce);
			}
		}
	}
}
