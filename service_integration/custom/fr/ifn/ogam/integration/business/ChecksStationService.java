package fr.ifn.ogam.integration.business;

import static fr.ifn.ogam.common.business.UnitTypes.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.business.checks.CheckExceptionArrayList;
import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.metadata.TableFormatData;
import fr.ifn.ogam.common.database.referentiels.ListReferentielsDAO;
import fr.ifn.ogam.common.util.DSRConstants;

public class ChecksStationService extends AbstractChecksService {

	/**
	 * Get expected table format.
	 */
	public String getExpectedTableFormat() {
		return TABLE_FORMAT_STATION ;
	}
	
	/**
	 * Get expexted standard.
	 */
	public String getExpectedStandard() {
		return STANDARD_HABITAT ;
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
		
		super.checkLine(submissionId, values);
		
		if (!isCorrectTableFormat(values)) {
			return ;
		}

		identifiantPermanentIsUUID(DSRConstants.IDENTIFIANT_STA_SINP, values);
		observationDatesAreCoherent(values);
		
		// if errors have been found while doing the checks, return an exception containing those to write in check_error
		if (alce.size() > 0) {
			// The arrayList of exceptions
			CheckExceptionArrayList checkExceptionArrayList = new CheckExceptionArrayList();
			checkExceptionArrayList.setCheckExceptionArrayList(alce);

			throw checkExceptionArrayList;
		}
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

		super.beforeLineInsertion(submissionId, values);
		
		if (!isCorrectTableFormat(values)) {
			return ;
		}
		
		if (values.size() == 0) {
			return;
		}
		
		String destFormat = getTableFormat(values).getFormat() ;

		// Then we check if every value we deal with (possible insertion of values) created as a Generic Data
		Map < String, String > fields = new HashMap < String, String >();
		fields.put(DSRConstants.IDENTIFIANT_STA_SINP, STRING);
		fields.put(DSRConstants.CLE_STATION, STRING) ;
		fields.put(DSRConstants.SURFACE, NUMERIC) ;
		fields.put(DSRConstants.METHODE_CALCUL_SURFACE, CODE) ;
		fields.put(DSRConstants.DS_PUBLIQUE, CODE) ;
		fields.put(DSRConstants.NATURE_OBJET_GEO, CODE) ;

		for (Map.Entry < String, String > field : fields.entrySet()) {
			if (!values.containsKey(field.getKey())) {
				GenericData data = new GenericData();
				data.setFormat(destFormat);
				data.setColumnName(field.getKey());
				data.setType(field.getValue());
				values.put(field.getKey(), data);
			}
		}

		// --- Identifiant permanent : idStaSINP
		identifiantPermanentIsUnique(DSRConstants.IDENTIFIANT_STA_SINP, values);
		
		// --- dspublique
		fillDSPublique(values) ;
		
		// --- methcalculsurface
		fillMethCalcSurface(values);
		
		// --- natureobjetgeo
		fillNatureObjetGeo(values) ;
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
		
		super.beforeIntegration(submissionId);
		
		if (!isCorrectStandard(submissionId)) {
			return ;
		}

	}
	
	
	/**
	 * Fill dspublique value if not supplied.
	 * @param values
	 */
	public void fillDSPublique(Map < String, GenericData > values) {
		
		GenericData dsPublique = values.get(DSRConstants.DS_PUBLIQUE) ;
		if (dsPublique != null && empty(dsPublique)) {
			dsPublique.setValue("NSP") ;
		}
	}
	
	
	/**
	 * Fills methCalculSurface if surface is supplied and methCalculSurface is not.
	 * @param values
	 */
	public void fillMethCalcSurface(Map < String, GenericData > values) {
		
		GenericData methCalcSurface = values.get(DSRConstants.METHODE_CALCUL_SURFACE) ;
		GenericData surface = values.get(DSRConstants.SURFACE) ;
		
		if (surface != null && !empty(surface)) {
			
			if (methCalcSurface != null && empty(methCalcSurface)) {
				methCalcSurface.setValue("nsp");
			}
		}
	}
	
	
	/**
	 * Fills natureobjetgeo if empty.
	 * @param values
	 */
	public void fillNatureObjetGeo(Map < String, GenericData > values) {
		
		GenericData natureObjetGeo = values.get(DSRConstants.NATURE_OBJET_GEO) ;
		if (natureObjetGeo != null && empty(natureObjetGeo)) {
			natureObjetGeo.setValue("NSP");
		}
	}
}
