package fr.ifn.ogam.integration.business;

import static fr.ifn.ogam.common.business.UnitTypes.*;

import java.util.HashMap;
import java.util.Map;

import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.business.checks.CheckExceptionArrayList;
import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.referentiels.ListReferentielsDAO;
import fr.ifn.ogam.common.util.DSRConstants;

public class ChecksHabitatService extends AbstractChecksService {

	/**
	 * Get expected table format.
	 */
	public String getExpectedTableFormat() {
		return TABLE_FORMAT_HABITAT ;
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
		
		identifiantPermanentIsUUID(DSRConstants.IDENTIFIANT_HAB_SINP, values);

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
		fields.put(DSRConstants.IDENTIFIANT_HAB_SINP, STRING);
		fields.put(DSRConstants.CLE_STATION, STRING) ;
		fields.put(DSRConstants.TECHNIQUE_COLLECTE, CODE) ;

		for (Map.Entry < String, String > field : fields.entrySet()) {
			if (!values.containsKey(field.getKey())) {
				GenericData data = new GenericData();
				data.setFormat(destFormat);
				data.setColumnName(field.getKey());
				data.setType(field.getValue());
				values.put(field.getKey(), data);
			}
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
		
		super.beforeIntegration(submissionId);
		
		if (!isCorrectStandard(submissionId)) {
			return ;
		}
		

	}
}
