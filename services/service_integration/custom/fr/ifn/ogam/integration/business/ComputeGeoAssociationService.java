package fr.ifn.ogam.integration.business;

import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.business.checks.CheckException;
import fr.ifn.ogam.common.database.GenericDAO;
import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.database.mapping.GeometryDAO;
import fr.ifn.ogam.common.database.referentiels.CommuneDAO;
import fr.ifn.ogam.common.database.referentiels.DepartementDAO;
import fr.ifn.ogam.common.database.referentiels.MailleDAO;
import fr.ifn.ogam.common.database.referentiels.AdministrativeEntityDAO;
import fr.ifn.ogam.common.util.DSRConstants;

/**
 * 
 * Service used to calculate the attachments of observations geometries and references to administratives limit.
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
	 * DAO for generic requests
	 * 
	 * @see GenericDao
	 */
	private GenericDAO genericDao = new GenericDAO();

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
	 * DAO for accessing administrative entities
	 * 
	 * @see AdministrativeEntityDAO
	 */
	private AdministrativeEntityDAO administrativeEntityDAO = new AdministrativeEntityDAO();

	/**
	 * The map of JDBC connections by submission id
	 */
	private Map<Integer, Connection> connections;

	public ComputeGeoAssociationService() {
		this.connections = new HashMap<Integer, Connection>();
	}

	/**
	 * Event called before the integration of a submission of data.
	 * Creates and puts the JDBC connection linked to the submission in the map of connections.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	@Override
	public void beforeIntegration(Integer submissionId) throws Exception {
		logger.debug("Connection created for submission : " + submissionId);
		this.connections.put(submissionId, administrativeEntityDAO.getConnection());
	}

	/**
	 * Event called after the integration of a submission of data.
	 * Closes the JDBC connection linked to the submission.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @throws Exception
	 *             in case of database error
	 */
	@Override
	public void afterIntegration(Integer submissionId) throws Exception {

		Connection conn = this.connections.get(submissionId);
		try{
			if(conn !=null) {
				logger.debug("Closing connection for submission : " + submissionId);
				conn.close();
			}
		} catch (Exception e) {
			logger.error("Error while closing connection for submission : " + submissionId, e);
			throw e;
		}

	}

	/**
	 * Event called before each insertion of a line of data.
	 * 
	 * @param submissionId
	 *            the submission identifier
	 * @param values
	 *            Entry values
	 * @throws Exception,
	 *             CheckException in case of database error
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
		if (values.size() == 0) {
			return;
		}
		// Get the connection
		Connection conn = this.connections.get(submissionId);
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
			geometryDAO.createGeometryLinksFromGeometry(format, tableName, parameters, conn);
			if ("POINT".equals(geometryType) || "MULTIPOINT".equals(geometryType)) {
				communeDAO.createCommunesLinksFromPoint(format, tableName, parameters, conn);
				departementDAO.createDepartmentsLinksFromPoint(format, tableName, parameters, conn);
				mailleDAO.createMaillesLinksFromPoint(format, tableName, parameters, conn);
			} else if ("LINESTRING".equals(geometryType) || "MULTILINESTRING".equals(geometryType)) {
				communeDAO.createCommunesLinksFromLine(format, tableName, parameters, conn);
				departementDAO.createDepartmentsLinksFromLine(format, tableName, parameters, conn);
				mailleDAO.createMaillesLinksFromLine(format, tableName, parameters, conn);
			} else if ("POLYGON".equals(geometryType) || "MULTIPOLYGON".equals(geometryType)) {
				communeDAO.createCommunesLinksFromPolygon(format, tableName, parameters, conn);
				departementDAO.createDepartmentsLinksFromPolygon(format, tableName, parameters, conn);
				mailleDAO.createMaillesLinksFromPolygon(format, tableName, parameters, conn);
			}
		} else if (hasCodesCommunes) {
			communeDAO.createCommunesLinksFromCommunes(format, parameters, conn);
			mailleDAO.createMaillesLinksFromCommunes(format, parameters, conn);
			departementDAO.createDepartmentsLinksFromCommunes(format, parameters, conn);
		} else if (hasCodesMailles) {
			mailleDAO.createMaillesLinksFromMailles(format, parameters, conn);
			departementDAO.createDepartmentsLinksFromMailles(format, parameters, conn);
		} else if (hasCodesDepartements) {
			mailleDAO.createMaillesLinksFromDepartements(format, parameters, conn);
			departementDAO.createDepartmentsLinksFromDepartements(format, parameters, conn);
		}

		communeDAO.setCodeCommuneCalcule(format, tableName, parameters, conn);
		communeDAO.setNomCommuneCalcule(format, tableName, parameters, conn);
		mailleDAO.setCodeMailleCalcule(format, tableName, parameters, conn);
		departementDAO.setCodeDepartementCalcule(format, tableName, parameters, conn);
	}

}
