package fr.ifn.ogam.integration.business;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.mapping.GeometryDAO;
import fr.ifn.ogam.common.database.referentiels.CommuneDAO;
import fr.ifn.ogam.common.database.referentiels.DepartementDAO;
import fr.ifn.ogam.common.database.referentiels.MailleDAO;
import fr.ifn.ogam.common.util.DSRConstants;

/**
 * 
 * Service used to calculate the attachments of observations geometries and references to administratives limit
 * 
 * @author gpastakia
 *
 */
public class ComputeGeoAssociationService implements IntegrationEventListener {

	/**
	 * The logger used to log the errors or several information.
	 * 
	 * @see org.apache.log4j.Logger
	 */
	private final transient Logger logger = Logger.getLogger(this.getClass());

	/**
	 * DAO for accessing geometry table
	 * 
	 * @see MailleDAO
	 */
	private GeometryDAO geometryDAO = new GeometryDAO();

	/**
	 * DAO for accessing commune table
	 * 
	 * @see CommuneDAO
	 */
	private CommuneDAO communeDAO = new CommuneDAO();

	/**
	 * DAO for accessing maille table
	 * 
	 * @see MailleDAO
	 */
	private MailleDAO mailleDAO = new MailleDAO();

	/**
	 * DAO for accessing departement table
	 * 
	 * @see DepartementDAO
	 */
	private DepartementDAO departementDAO = new DepartementDAO();

	/**
	 * Event called before the integration of a submission of data.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	@Override
	public void beforeIntegration(Integer submissionId) throws Exception {

		// DO NOTHING
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
	 * Event called before each insertion of a line of data.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @param values
	 *            Entry values
	 * @throws Exception, CheckException
	 *             in case of database error
	 */
	@Override
	public void beforeLineInsertion(Integer submissionId, Map<String, GenericData> values) throws Exception, CheckException {

		// DO NOTHING
	}

	/**
	 * Ajoute le résultat du croisement avec les entités administratives.
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

		logger.debug("insertAdministrativeAssociations");
		if (values.size() == 0) {
			return;
		}
		// Administrative associations are computed only if the file contains a geometric field
		if (values.get(DSRConstants.GEOMETRIE) == null) {
			return;
		}
		// Champs à récupérer
		String geometry = (String) values.get(DSRConstants.GEOMETRIE).getValue();

		GenericData codesCommunesGD = values.get(DSRConstants.CODE_COMMUNE);
		GenericData codesMaillesGD = values.get(DSRConstants.CODE_MAILLE);
		GenericData codesDepartementsGD = values.get(DSRConstants.CODE_DEPARTEMENT);
		GenericData typeInfoGeoCommuneGD = values.get(DSRConstants.TYPE_INFO_GEO_COMMUNE);
		GenericData typeInfoGeoMailleGD = values.get(DSRConstants.TYPE_INFO_GEO_MAILLE);
		GenericData typeInfoGeoDepartementGD = values.get(DSRConstants.TYPE_INFO_GEO_DEPARTEMENT);

		String[] codesCommunes = { "" };
		String[] codesMailles = { "" };
		String[] codesDepartements = { "" };
		String typeInfoGeoCommune = "";
		String typeInfoGeoMaille = "";
		String typeInfoGeoDepartement = "";
		boolean hasCodesCommunes = false;
		boolean hasCodesMailles = false;
		boolean hasCodesDepartements = false;

		// Booléens de présence de champs géométriques ou référençant une géométrie
		if (codesCommunesGD != null) {
			codesCommunes = (String[]) values.get(DSRConstants.CODE_COMMUNE).getValue();
			if (!codesCommunes[0].isEmpty()) {
				hasCodesCommunes = true;
				typeInfoGeoCommune = (String) typeInfoGeoCommuneGD.getValue();
			}
		}
		if (codesMaillesGD != null) {
			codesMailles = (String[]) values.get(DSRConstants.CODE_MAILLE).getValue();
			if (!codesMailles[0].isEmpty()) {
				hasCodesMailles = true;
				typeInfoGeoMaille = (String) typeInfoGeoMailleGD.getValue();
			}
		}
		if (codesDepartementsGD != null) {
			codesDepartements = (String[]) values.get(DSRConstants.CODE_DEPARTEMENT).getValue();
			if (!codesDepartements[0].isEmpty()) {
				hasCodesDepartements = true;
				typeInfoGeoDepartement = (String) typeInfoGeoDepartementGD.getValue();
			}
		}

		Map<String, Object> parameters = new HashMap<>();
		parameters.put(DSRConstants.GEOMETRIE, (String) values.get(DSRConstants.GEOMETRIE).getValue());
		parameters.put(DSRConstants.CODE_COMMUNE, codesCommunes);
		parameters.put(DSRConstants.CODE_MAILLE, codesMailles);
		parameters.put(DSRConstants.CODE_DEPARTEMENT, codesDepartements);
		parameters.put(DSRConstants.OGAM_ID, id);
		parameters.put(DSRConstants.PROVIDER_ID, (String) values.get(DSRConstants.PROVIDER_ID).getValue());

		logger.debug("Computing administrative associations for observation with id : " + parameters.get(DSRConstants.OGAM_ID) + " and provider id : "
				+ parameters.get(DSRConstants.PROVIDER_ID) + " in table : " + tableName);

		if (geometry != null && !geometry.isEmpty()) {

			logger.debug(geometry);
			String geometryType = geometryDAO.getGeometryType(geometry);
			geometryDAO.createGeometryLinksFromGeometry(format, tableName, parameters);
			if ("POINT".equals(geometryType) || "MULTIPOINT".equals(geometryType)) {
				communeDAO.createCommunesLinksFromPoint(format, tableName, parameters);
				departementDAO.createDepartmentsLinksFromPoint(format, tableName, parameters);
				mailleDAO.createMaillesLinksFromPoint(format, tableName, parameters);
			} else if ("LINESTRING".equals(geometryType) || "MULTILINESTRING".equals(geometryType)) {
				communeDAO.createCommunesLinksFromLine(format, tableName, parameters);
				departementDAO.createDepartmentsLinksFromLine(format, tableName, parameters);
				mailleDAO.createMaillesLinksFromLine(format, tableName, parameters);
			} else if ("POLYGON".equals(geometryType) || "MULTIPOLYGON".equals(geometryType)) {
				communeDAO.createCommunesLinksFromPolygon(format, tableName, parameters);
				departementDAO.createDepartmentsLinksFromPolygon(format, tableName, parameters);
				mailleDAO.createMaillesLinksFromPolygon(format, tableName, parameters);
			}
		} else if (hasCodesCommunes) {
			communeDAO.createCommunesLinksFromCommunes(format, parameters);
			mailleDAO.createMaillesLinksFromCommunes(format, parameters);
			departementDAO.createDepartmentsLinksFromCommunes(format, parameters);
		} else if (hasCodesMailles) {
			mailleDAO.createMaillesLinksFromMailles(format, parameters);
			departementDAO.createDepartmentsLinksFromMailles(format, parameters);
		} else if (hasCodesDepartements) {
			mailleDAO.createMaillesLinksFromDepartements(format, parameters);
			departementDAO.createDepartmentsLinksFromDepartements(format, parameters);
		}

		communeDAO.setCodeCommuneCalcule(format, tableName, parameters);
		communeDAO.setNomCommuneCalcule(format, tableName, parameters);
		mailleDAO.setCodeMailleCalcule(format, tableName, parameters);
		departementDAO.setCodeDepartementCalcule(format, tableName, parameters);

	}

}
