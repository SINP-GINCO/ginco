package fr.ifn.ogam.integration.business;

import static fr.ifn.ogam.common.business.UnitTypes.*;
import static fr.ifn.ogam.common.business.checks.CheckCodesGinco.*;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.omg.DynamicAny.DynStructOperations;

import java.util.List;

import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.business.checks.CheckExceptionArrayList;
import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.metadata.TableFormatData;
import fr.ifn.ogam.common.database.metadata.TableTreeData;
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
		cdHabIsNotEmpty(values);
		cdHabInteretCommunautaireIsNotEmpty(values);
		cdHabInteretCommunautaireCdTypo(values);
		precisionTechniqueNotEmpty(values);

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
		fields.put(DSRConstants.PRECISION_TECHNIQUE, STRING) ;
		fields.put(DSRConstants.NOM_CITE, STRING) ;
		fields.put(DSRConstants.CD_HAB, ARRAY) ;
		fields.put(DSRConstants.HABITAT_INTERET_COMMUNAUTAIRE, CODE) ;
		fields.put(DSRConstants.CD_HAB_INTERET_COMMUNAUTAIRE, ARRAY) ;

		for (Map.Entry < String, String > field : fields.entrySet()) {
			if (!values.containsKey(field.getKey())) {
				GenericData data = new GenericData();
				data.setFormat(destFormat);
				data.setColumnName(field.getKey());
				data.setType(field.getValue());
				values.put(field.getKey(), data);
			}
		}

		identifiantPermanentIsUnique(DSRConstants.IDENTIFIANT_HAB_SINP, values);
		
		// --- Fills techniqueCollecte
		fillTechniqueCollecte(values);
		
		// --- Checks if cleStation exists in table station.
		cleStationExists(submissionId, values);
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
	 * cdHab have to be filled if nomCite is "Inconnu" or "Nom perdu"
	 * @param values
	 * @return
	 * @throws Exception
	 */
	private void cdHabIsNotEmpty(Map < String, GenericData > values) throws Exception {
		
		GenericData nomCite = values.get(DSRConstants.NOM_CITE) ;
		GenericData cdHab = values.get(DSRConstants.CD_HAB) ;
		
		if (nomCite == null || empty(nomCite)) {
			return ;
		}
		
		String nomCiteValue = nomCite.getValue().toString() ;
		
		if (nomCiteValue.equals("Inconnu") || nomCiteValue.equals("Nom perdu")) {
			
			if (cdHab == null || empty(cdHab)) {
				
				String error = "Le champ cdHab doit être rempli car nomCite a pour valeur '" + nomCiteValue + "'." ;
				CheckException ce = new CheckException(CDHAB_EMPTY, error) ;
				ce.setSourceData("cdHab") ;
				alce.add(ce) ;
			}
		}
	}
	
	
	/**
	 * cdHabInteretCommunautaire must be filled if habitatInteretCommunautaire equals 1 or 3 or if cdhab is empty.
	 * @param values
	 * @throws Exception
	 */
	private void cdHabInteretCommunautaireIsNotEmpty(Map < String, GenericData > values) throws Exception {
		
		GenericData cdHab = values.get(DSRConstants.CD_HAB) ;
		GenericData interetCommunautaire = values.get(DSRConstants.HABITAT_INTERET_COMMUNAUTAIRE) ;
		GenericData cdHabInteretCommunautaire = values.get(DSRConstants.CD_HAB_INTERET_COMMUNAUTAIRE) ;
	
		boolean isInteretCommunautaire = false ;
		if (interetCommunautaire != null && !empty(interetCommunautaire)) {
			String interetCommunautaireValue = interetCommunautaire.getValue().toString() ;
			if (interetCommunautaireValue.equals("1") || interetCommunautaireValue.equals("3")) {
				isInteretCommunautaire = true ;
			}
		}
		
		boolean emptyCdHab = false ;
		if (cdHab == null || empty(cdHab)) {
			emptyCdHab = true ;
		}
		
		if (isInteretCommunautaire || emptyCdHab) {
			
			if (cdHabInteretCommunautaire == null || empty(cdHabInteretCommunautaire)) {
				
				String error = "Le champ cdHabInteretCommunautaire doit être rempli car habitatInteretCommunautaire a pour valeur 1 ou 3, ou aucun cdHab n'est fourni." ;
				CheckException ce = new CheckException(CDHAB_INTERET_COMMUNAUTAIRE_EMPTY, error) ;
				ce.setSourceData("cdHabInteretCommunautaire") ;
				alce.add(ce) ;
			}
		}
	}
	
	/**
	 * interetCommunaitaire must be filled if cdHab has a cdTypo = 8.
	 * @param values
	 * @throws Exception
	 */
	private void cdHabInteretCommunautaireCdTypo(Map < String, GenericData > values) throws Exception {
		
		GenericData cdHab = values.get(DSRConstants.CD_HAB) ;
		GenericData interetCommunautaire = values.get(DSRConstants.HABITAT_INTERET_COMMUNAUTAIRE) ;
		
		String[] cdHabValues = (String[]) cdHab.getValue() ;
		// cdHab ne peut pas être vide, le test a déjà été fait plus haut.
		String cdHabStr = cdHabValues[0] ;
 		int cdTypo = metadataDAO.getCdTypoFromCdHab(cdHabStr) ;
		
		if (8 == cdTypo) {
			
			if (interetCommunautaire == null || empty(interetCommunautaire)) {
				
				String error = "Le champ habitatInteretCommunautaire doit être rempli car le cd_hab fourni (" + cdHabStr + ") est associé à un cd_typo = 8 dans le référentiel HABREF." ;
				CheckException ce = new CheckException(HABITAT_INTERET_COMMUNAUTAIRE_EMPTY, error) ;
				ce.setSourceData("habitatInteretCommunautaire") ;
				alce.add(ce) ;
			}
		}
	}
	
	/**
	 * precisiontechnique have to be filled if techniquecollecte equals 10.
	 * @param values
	 * @throws Exception
	 */
	private void precisionTechniqueNotEmpty(Map < String, GenericData > values) throws Exception {
		
		GenericData precisionTechnique = values.get(DSRConstants.PRECISION_TECHNIQUE) ;
		GenericData techniqueCollecte = values.get(DSRConstants.TECHNIQUE_COLLECTE) ;
		
		String techniqueCollecteValue = techniqueCollecte.getValue().toString() ;
		
		if (techniqueCollecteValue.equals("10")) {
			
			if (empty(precisionTechnique)) {
				
				String error = "Le champ precisionTechnique doit être rempli car la valeur de techniqueCollecte est 10 (Autre, à préciser)." ;
				CheckException ce = new CheckException(PRECISION_TECHNIQUE_EMPTY, error) ;
				ce.setSourceData("precisionTechnique") ;
				alce.add(ce) ;
			}
		}
	}
	
	
	/**
	 * Fills techniqueCollecte if empty.
	 * @param values
	 */
	private void fillTechniqueCollecte(Map < String, GenericData > values) {
		
		GenericData techniqueCollecte = values.get(DSRConstants.TECHNIQUE_COLLECTE) ;
		
		if (techniqueCollecte != null && empty(techniqueCollecte)) {
			techniqueCollecte.setValue("0");
		}
	}
	
	
	/**
	 * Checks if supplied cleStation for habitat can be found in table station.
	 * @param submissionId
	 * @param values
	 * @throws Exception
	 * @throws CheckException
	 */
	private void cleStationExists(Integer submissionId, Map < String, GenericData > values) throws Exception, CheckException {
		
		TableFormatData tableFormat = getTableFormat(values) ;
		List < TableTreeData > tablesTree = metadataDAO.getTablesTree(tableFormat.getFormat(), tableFormat.getSchemaCode()) ;
		
		TableFormatData parentTableFormat = null ;
		Iterator < TableTreeData > it = tablesTree.iterator() ;
		while (it.hasNext()) {
			TableTreeData next = it.next() ;
			if (next.getTable().getFormat().equals(tableFormat.getFormat())) {
				parentTableFormat = next.getParentTable() ;
				break ;
			}
		}
		
		String cleStation = values.get(DSRConstants.CLE_STATION).getValue().toString() ;
		int count = metadataDAO.countCleStation(parentTableFormat, cleStation, submissionId) ;
		
		if (count != 1) {
			String error = "La cleStation " + cleStation + " présente dans le fichier des habitats ne référence aucune station dans le fichier des stations." ;
			CheckException ce = new CheckException(CLE_STATION_NOT_FOUND, error) ;
			ce.setSourceData("cleStation");
			ce.setFoundValue(cleStation);
			throw ce ;
		}
	}
}
