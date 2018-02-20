/**
 * 
 */
package fr.ifn.ogam.common.database.referentiels;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import fr.ifn.ogam.common.database.GenericDAO;
import fr.ifn.ogam.common.database.metadata.TableFormatData;
import fr.ifn.ogam.common.util.DSRConstants;

/**
 * DAO for methods involving departements georeferencing.
 * 
 * @author gautam
 *
 */
public class DepartementDAO extends AdministrativeEntityDAO {

	/**
	 * Populates the table "observation_departement" by getting the departements from a point geometry. If the distance between the point and a departement is
	 * less than 0.00001m, it is considered as the point is inside or on the border of the departement.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param parameters
	 *            the following values : ogam_id, provider_id
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createDepartmentsLinksFromPoint(String format, String tableName, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createDepartmentsLinksFromPoint");

		PreparedStatement ps = null;
		ResultSet rs = null;

		StringBuffer stmt = new StringBuffer();
		stmt.append("SELECT DISTINCT ref.code_dept ");
		stmt.append("FROM referentiels.departement_carto_2017 as ref, raw_data." + tableName + " AS m ");
		stmt.append("WHERE St_Intersects(ref.geom, m.geometrie) = true ");
		stmt.append("AND m.ogam_id_" + format + " = '" + parameters.get(DSRConstants.OGAM_ID) + "'");
		stmt.append("AND m.provider_id = '" + parameters.get(DSRConstants.PROVIDER_ID) + "'");

		try {

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();

			// Count the number of departements found
			int numberOfDepartements = 0;
			List<String> codesDepartements = new ArrayList<String>();
			while (rs.next()) {
				++numberOfDepartements;
				codesDepartements.add(rs.getString("code_dept"));
			}
			for (String codeDepartement : codesDepartements) {
				stmt = new StringBuffer();
				stmt.append("INSERT INTO mapping.observation_departement VALUES ('");
				stmt.append(parameters.get(DSRConstants.OGAM_ID) + "', '" + parameters.get(DSRConstants.PROVIDER_ID) + "', '");
				stmt.append(format + "', '" + codeDepartement + "', ");
				stmt.append(1 / numberOfDepartements + ");");
				ps = con.prepareStatement(stmt.toString());
				logger.trace(stmt.toString());
				ps.executeUpdate();
			}
			rs.close();
			ps.close();
		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_departement" by getting the departements from a linestring or multilinestring geometry. If proportion of the length of
	 * the intersection between the departement and the line and the length of the line is stricty positive, it is considered as the departement covers partly
	 * or totally the line.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param parameters
	 *            values including : ogam_id, provider_id
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createDepartmentsLinksFromLine(String format, String tableName, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createDepartmentsLinksFromLine");

		PreparedStatement ps = null;

		String ogamId = parameters.get(DSRConstants.OGAM_ID).toString();
		String providerId = parameters.get(DSRConstants.PROVIDER_ID).toString();

		try {
			Float length = genericDao.getGeometryLength(format, tableName, ogamId, providerId);
			if (length >= 0) {
				StringBuffer stmt = new StringBuffer();
				stmt.append("INSERT INTO mapping.observation_departement ");
				stmt.append("SELECT m.ogam_id_" + format + ",  m.provider_id, '" + format + "', ref.code_dept, ");
				if (length > 0) {
					stmt.append("round(cast(St_Length(St_Intersection(m.geometrie, ref.geom))/St_Length(m.geometrie) AS numeric(4,3)), 3)");
				} else {
					stmt.append("1 ");
				}
				stmt.append("FROM referentiels.departement_carto_2017 AS ref, raw_data." + tableName + " AS m ");
				if (length > 0) {
					stmt.append("WHERE St_Intersects(m.geometrie, ref.geom) = true ");
				} else {
					stmt.append("WHERE St_Distance(m.geometrie, ref.geom) = 0 ");
				}
				stmt.append("AND m.ogam_id_" + format + " = '" + ogamId + "' ");
				stmt.append("AND m.provider_id = '" + providerId + "'");

				// con = getConnection();

				ps = con.prepareStatement(stmt.toString());
				logger.trace(stmt.toString());
				ps.executeUpdate();
				ps.close();
			}
		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_departement" by getting the departements from a polygon or multipolygon geometry. If the proportion of the area of the
	 * intersection between the departement and the polygon and the area of the departement is strictly positive, it is considered as the departement covers
	 * partly or totally the polygon.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param parameters
	 *            values including : ogam_id, provider_id
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createDepartmentsLinksFromPolygon(String format, String tableName, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createDepartmentsLinksFromPolygon");

		PreparedStatement ps = null;

		String ogamId = parameters.get(DSRConstants.OGAM_ID).toString();
		String providerId = parameters.get(DSRConstants.PROVIDER_ID).toString();

		try {
			Float area = genericDao.getGeometryArea(format, tableName, ogamId, providerId);
			if (area >= 0) {
				StringBuffer stmt = new StringBuffer();
				stmt.append("INSERT INTO mapping.observation_departement ");
				stmt.append("SELECT m.ogam_id_" + format + ",  m.provider_id, '" + format + "', ref.code_dept, ");
				if (area > 0) {
					stmt.append("round(cast(St_Area(St_Intersection(m.geometrie, ref.geom))/St_Area(m.geometrie) AS numeric(4,3)), 3) AS pct ");
				} else {
					stmt.append("1 ");
				}
				stmt.append("FROM referentiels.departement_carto_2017 AS ref, raw_data." + tableName + " AS m ");
				if (area > 0) {
					stmt.append("WHERE St_Intersects(m.geometrie, ref.geom) = true ");
				} else {
					stmt.append("WHERE St_Distance(m.geometrie, ref.geom) = 0 ");
				}
				stmt.append("AND m.ogam_id_" + format + " = '" + ogamId + "' ");
				stmt.append("AND m.provider_id = '" + providerId + "'");

				ps = con.prepareStatement(stmt.toString());
				logger.trace(stmt.toString());
				ps.executeUpdate();
				ps.close();
			}
		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_departement" by getting the departements from a list of communes codes. The calculation is based on the union of the
	 * geometries of the list of communes given (value X). If the geometries of the union of the communes and the departement has an intersection AND it does
	 * not touches (to avoid getting results where only boundary is in common between the two geometries), then the proportion of the area of the intersection
	 * between the departement and X and the area of X is calculated and an entry added to table observation_departement.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param parameters
	 *            values including : ogam_id, provider_id, codesCommunes
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createDepartmentsLinksFromCommunes(String format, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createDepartmentsLinksFromCommunes");

		PreparedStatement ps = null;

		String[] codesCommunes = ((String[]) parameters.get(DSRConstants.CODE_COMMUNE));
		String providerId = (String) parameters.get(DSRConstants.PROVIDER_ID);
		String ogamId = (String) parameters.get(DSRConstants.OGAM_ID);

		try {
			StringBuffer stmt = new StringBuffer();
			stmt.append("INSERT INTO mapping.observation_departement ");
			stmt.append("SELECT '" + ogamId + "', '" + providerId + "', '" + format + "', departement.code_dept, ");
			stmt.append("round(cast(St_Area(St_Intersection(communes_union, departement.geom))/St_Area(communes_union) ");
			stmt.append("AS numeric(4,3)), 3) AS pct ");
			stmt.append("FROM referentiels.departement_carto_2017 AS departement, ");
			stmt.append("(SELECT St_Union(commune.geom) AS communes_union ");
			stmt.append("FROM referentiels.commune_carto_2017 AS commune ");
			stmt.append("WHERE commune.insee_com = '" + codesCommunes[0] + "' ");
			for (int i = 1; i < codesCommunes.length; ++i) {
				stmt.append("OR commune.insee_com = '" + codesCommunes[i] + "' ");
			}
			stmt.append(") as foo ");
			stmt.append("WHERE St_Intersects(communes_union, departement.geom) = true ");
			stmt.append("AND St_Touches(communes_union, departement.geom) = false ");

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			ps.executeUpdate();
			ps.close();
		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_departement" by getting the departements from a list of mailles codes. The calculation is based on the union of the
	 * geometries of the list of mailles given (value X). If the geometries of the union of the mailles and the departement has an intersection AND it does not
	 * touches (to avoid getting results where only boundary is in common between the two geometries), then the proportion of the area of the intersection
	 * between the departement and X and the area of X is calculated and an entry added to table observation_departement.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param parameters
	 *            values including : ogam_id, provider_id, codesMailles
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createDepartmentsLinksFromMailles(String format, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createDepartmentsLinksFromMailles");

		PreparedStatement ps = null;

		String[] codesMailles = ((String[]) parameters.get(DSRConstants.CODE_MAILLE));
		String providerId = (String) parameters.get(DSRConstants.PROVIDER_ID);
		String ogamId = (String) parameters.get(DSRConstants.OGAM_ID);

		StringBuffer stmt = new StringBuffer();
		stmt.append("INSERT INTO mapping.observation_departement ");
		stmt.append("SELECT '" + ogamId + "', '" + providerId + "', '" + format + "', departement.code_dept, ");
		stmt.append("round(cast(St_Area(St_Intersection(mailles_union, departement.geom))/St_Area(mailles_union) ");
		stmt.append("AS numeric(4,3)), 3) AS pct ");
		stmt.append("FROM referentiels.departement_carto_2017 AS departement, ");
		stmt.append("(SELECT St_Union(grille.geom) AS mailles_union ");
		stmt.append("FROM referentiels.codemaillevalue AS grille ");
		stmt.append("WHERE grille.code_10km = '" + codesMailles[0] + "' ");
		for (int i = 1; i < codesMailles.length; ++i) {
			stmt.append("OR grille.code_10km = '" + codesMailles[i] + "' ");
		}
		stmt.append(") as foo ");
		stmt.append("WHERE St_Intersects(mailles_union, departement.geom) = true ");
		stmt.append("AND St_Touches(mailles_union, departement.geom) = false ");

		try {
			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			ps.executeUpdate();
			ps.close();
		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_departement" by getting the departements from a list of departements codes. If the code_dept exists in the
	 * "departement_carto_2017" referentiel, it is added to the table.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param parameters
	 *            values including : ogam_id, provider_id, codedepartement
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createDepartmentsLinksFromDepartements(String format, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createDepartmentsLinksFromDepartements");

		PreparedStatement ps = null;

		String[] codesDepartements = ((String[]) parameters.get(DSRConstants.CODE_DEPARTEMENT));
		String providerId = (String) parameters.get(DSRConstants.PROVIDER_ID);
		String ogamId = (String) parameters.get(DSRConstants.OGAM_ID);

		StringBuffer stmt = null;
		try {

			for (String codeDepartement : codesDepartements) {
				stmt = new StringBuffer();
				stmt.append("INSERT INTO mapping.observation_departement ");
				stmt.append("SELECT '" + ogamId + "', '" + providerId + "', '" + format + "', ref.code_dept, '1' ");
				stmt.append("FROM referentiels.departement_carto_2017 AS ref ");
				stmt.append("WHERE ref.code_dept = '" + codeDepartement + "' ");

				ps = con.prepareStatement(stmt.toString());
				logger.trace(stmt.toString());
				ps.executeUpdate();
				ps.close();
			}
		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Deletes from tables "observation_departement" all the associations linked to the format. Code is executed only if table above exists.
	 * 
	 * @param format
	 *            the table format
	 * @param submissionId
	 *            the identifier of the submission
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void deleteDepartmentsFromFormat(TableFormatData tableFormat, Integer submissionId, Connection con) throws Exception {
		logger.debug("deleteDepartmentsFromFormat");

		PreparedStatement ps = null;
		ResultSet rs = null;

		String tableName = tableFormat.getTableName();
		String format = tableFormat.getFormat();

		StringBuffer stmt = new StringBuffer();

		stmt.append("SELECT to_regclass('mapping.observation_departement') as od_reg");
		try {

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();

			String odReg;

			if (rs.next()) {
				odReg = rs.getString("od_reg");
				if (odReg != null) {
					stmt = new StringBuffer();
					stmt.append("DELETE FROM mapping.observation_departement AS od ");
					stmt.append("USING raw_data." + tableName + " as rd ");
					stmt.append("WHERE od.id_observation = rd.ogam_id_" + format + " ");
					stmt.append("AND od.id_provider = rd.provider_id ");
					stmt.append("AND submission_id = " + submissionId + ";");

					ps = con.prepareStatement(stmt.toString());
					logger.trace(stmt.toString());
					ps.executeUpdate();
					rs.close();
					ps.close();
				}
			}
		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * 
	 * Populates the field "codeDepartementCalcule" by getting the information from table "observation_departement".
	 * 
	 * @param format
	 *            the table format
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param parameters
	 *            values including : ogam_id, provider_id
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void setCodeDepartementCalcule(String format, String tableName, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("setCodeDepartementCalcule");

		PreparedStatement ps = null;
		ResultSet rs = null;

		StringBuffer stmt = null;

		String providerId = (String) parameters.get(DSRConstants.PROVIDER_ID);
		String ogamId = (String) parameters.get(DSRConstants.OGAM_ID);

		// Get the list of the departements
		stmt = new StringBuffer();
		stmt.append("SELECT id_departement ");
		stmt.append("FROM mapping.observation_departement ");
		stmt.append("WHERE id_observation = '" + ogamId + "' ");
		stmt.append("AND id_provider = '" + providerId + "' ");
		stmt.append("AND table_format = '" + format + "' ");

		try {

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();

			// Create a list of code departements found
			List<String> codesDepartements = new ArrayList<String>();
			while (rs.next()) {
				codesDepartements.add(rs.getString("id_departement"));
			}

			StringBuffer codeDepartementCalcule = new StringBuffer("{");

			for (String codeDepartement : codesDepartements) {
				codeDepartementCalcule.append(codeDepartement);
				codeDepartementCalcule.append(",");
			}

			if (codeDepartementCalcule.length() != 1) {
				codeDepartementCalcule.delete(codeDepartementCalcule.length() - 1, codeDepartementCalcule.length());
			}
			codeDepartementCalcule.append("}");

			stmt = new StringBuffer();
			stmt.append("UPDATE raw_data." + tableName + " ");
			stmt.append("SET " + DSRConstants.CODE_DEPARTEMENT_CALC + " = '" + codeDepartementCalcule.toString() + "' ");
			stmt.append("WHERE provider_id = '" + providerId + "' ");
			stmt.append("AND ogam_id_" + format + " = '" + ogamId + "' ");

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			ps.executeUpdate();
			rs.close();
			ps.close();
		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}
}
