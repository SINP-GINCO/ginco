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
 * DAO for methods involving mailles georeferencing
 * 
 * @author gpastakia
 *
 */
public class MailleDAO extends AdministrativeEntityDAO {

	/**
	 * Populates the table "observation_maille" by getting the mailles from a point geometry. If the distance between the point and a maille is less than
	 * 0.00001m, it is considered as the point is inside or on the border of the maille.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param parameters
	 *            the following values : ogam_id, provider_id
	 *             @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createMaillesLinksFromPoint(String format, String tableName, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createMaillesLinksFromPoint");

		PreparedStatement ps = null;
		ResultSet rs = null;

		StringBuffer stmt = new StringBuffer();
		stmt.append("SELECT DISTINCT ref.code_10km ");
		stmt.append("FROM referentiels.codemaillevalue AS ref, raw_data." + tableName + " AS m ");
		stmt.append("WHERE St_Intersects(ref.geom, m.geometrie) = true ");
		stmt.append("AND m.ogam_id_" + format + " = '" + parameters.get(DSRConstants.OGAM_ID) + "'");
		stmt.append("AND m.provider_id = '" + parameters.get(DSRConstants.PROVIDER_ID) + "'");

		try {

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();

			// Count the number of mailles found
			int numberOfMailles = 0;
			List<String> codesMailles = new ArrayList<String>();
			while (rs.next()) {
				++numberOfMailles;
				codesMailles.add(rs.getString("code_10km"));
			}
			for (String codeMaille : codesMailles) {
				stmt = new StringBuffer();
				stmt.append("INSERT INTO mapping.observation_maille VALUES ('");
				stmt.append(parameters.get(DSRConstants.OGAM_ID) + "', '" + parameters.get(DSRConstants.PROVIDER_ID) + "', '");
				stmt.append(format + "', '" + codeMaille + "', ");
				stmt.append(1 / numberOfMailles + ");");

				ps = con.prepareStatement(stmt.toString());
				logger.trace(stmt.toString());
				ps.executeUpdate();
				
				rs.close();
				ps.close();
			}
		} catch (Exception e){
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_maille" by getting the mailles from a linestring or multilinestring geometry. If proportion of the length of the
	 * intersection between the maille and the line and the length of the line is stricty positive, it is considered as the maille covers partly or totally the
	 * line.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param parameters
	 *            values including : ogam_id, provider_id
	 *             @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createMaillesLinksFromLine(String format, String tableName, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createMaillesLinksFromLine");

		PreparedStatement ps = null;

		String ogamId = parameters.get(DSRConstants.OGAM_ID).toString();
		String providerId = parameters.get(DSRConstants.PROVIDER_ID).toString();

		try {
			
			Float length = genericDao.getGeometryLength(format, tableName, ogamId, providerId);
			if (length >= 0) {
				StringBuffer stmt = new StringBuffer();
				stmt.append("INSERT INTO mapping.observation_maille ");
				stmt.append("SELECT m.ogam_id_" + format + ",  m.provider_id, '" + format + "', ref.code_10km, ");
				if (length > 0) {
					stmt.append("round(cast(St_Length(St_Intersection(m.geometrie, ref.geom))/St_Length(m.geometrie) AS numeric(4,3)), 3)");
				} else {
					stmt.append("1 ");
				}
				stmt.append("FROM referentiels.codemaillevalue AS ref, raw_data." + tableName + " AS m ");
				if (length > 0) {
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
		} catch (Exception e){
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_maille" by getting the mailles from a polygon or multipolygon geometry. If the proportion of the area of the
	 * intersection between the maille and the polygon and the area of the polygon is strictly positive, it is considered as the maille covers partly or totally
	 * the polygon.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param parameters
	 *            values including : ogam_id, provider_id
	 *             @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createMaillesLinksFromPolygon(String format, String tableName, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createMaillesLinksFromPolygon");

		PreparedStatement ps = null;

		String ogamId = parameters.get(DSRConstants.OGAM_ID).toString();
		String providerId = parameters.get(DSRConstants.PROVIDER_ID).toString();

		try {
			Float area = genericDao.getGeometryArea(format, tableName, ogamId, providerId);
			if (area >= 0) {
				StringBuffer stmt = new StringBuffer();
				stmt.append("INSERT INTO mapping.observation_maille ");
				stmt.append("SELECT m.ogam_id_" + format + ",  m.provider_id, '" + format + "', ref.code_10km, ");
				if (area > 0) {
					stmt.append("round(cast(St_Area(St_Intersection(m.geometrie, ref.geom))/St_Area(m.geometrie) AS numeric(4,3)), 3) AS pct ");
				} else {
					stmt.append("1 ");
				}
				stmt.append("FROM referentiels.codemaillevalue AS ref, raw_data." + tableName + " AS m ");
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
		} catch (Exception e){
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_maille" by getting the mailles from a list of communes codes. The calculation is based on the union of the geometries of
	 * the list of communes given (value X). If the geometries of the union of the communes and the maille has an intersection AND it does not touches (to avoid
	 * getting results where only boundary is in common between the two geometries), then the proportion of the area of the intersection between the departement
	 * and X and the area of X is calculated and an entry added to table observation_maille.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param parameters
	 *            values including : ogam_id, provider_id, codesCommunes
	 *             @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createMaillesLinksFromCommunes(String format, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createMaillesLinksFromCommunes");

		PreparedStatement ps = null;

		String[] codesCommunes = ((String[]) parameters.get(DSRConstants.CODE_COMMUNE));
		String providerId = (String) parameters.get(DSRConstants.PROVIDER_ID);
		String ogamId = (String) parameters.get(DSRConstants.OGAM_ID);

		StringBuffer stmt = new StringBuffer();
		try {
			stmt.append("INSERT INTO mapping.observation_maille ");
			stmt.append("SELECT '" + ogamId + "', '" + providerId + "', '" + format + "', grille.code_10km, ");
			stmt.append("round(cast(St_Area(St_Intersection(communes_union, grille.geom))/St_Area(communes_union) ");
			stmt.append("AS numeric(4,3)), 3) AS pct ");
			stmt.append("FROM referentiels.codemaillevalue AS grille, ");
			stmt.append("(SELECT St_Union(commune.geom) AS communes_union ");
			stmt.append("FROM referentiels.commune_carto_2017 AS commune ");
			stmt.append("WHERE commune.insee_com = '" + codesCommunes[0] + "' ");
			for (int i = 1; i < codesCommunes.length; ++i) {
				stmt.append("OR commune.insee_com = '" + codesCommunes[i] + "' ");
			}
			stmt.append(") as foo ");
			stmt.append("WHERE St_Intersects(communes_union, grille.geom) = true ");
			stmt.append("AND St_Touches(communes_union, grille.geom) = false ");
			
			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			ps.executeUpdate();
			ps.close();
		} catch (Exception e){
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_maille" by getting the mailles from a list of mailles codes. If the code 10km exists in the "codemaillevalue"
	 * referentiel, it is added to the table.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param parameters
	 *            values including : ogam_id, provider_id, codemaille
	 *             @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createMaillesLinksFromMailles(String format, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createMaillesLinksFromMailles");

		PreparedStatement ps = null;

		String[] codeMailles = ((String[]) parameters.get(DSRConstants.CODE_MAILLE));
		String providerId = (String) parameters.get(DSRConstants.PROVIDER_ID);
		String ogamId = (String) parameters.get(DSRConstants.OGAM_ID);

		StringBuffer stmt = null;
		try {
			for (String codeMaille : codeMailles) {
				stmt = new StringBuffer();
				stmt.append("INSERT INTO mapping.observation_maille ");
				stmt.append("SELECT '" + ogamId + "', '" + providerId + "', '" + format + "', ref.code_10km, '1' ");
				stmt.append("FROM referentiels.codemaillevalue AS ref ");
				stmt.append("WHERE ref.code_10km = '" + codeMaille + "' ");
				ps = con.prepareStatement(stmt.toString());
				logger.trace(stmt.toString());
				ps.executeUpdate();
				ps.close();
			}
		} catch (Exception e){
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Populates the table "observation_maille" by getting the maille from a list of departement codes. The calculation is based on the union of the geometries
	 * of the list of departements given (value X). If the geometries of the union of the departements and the maille has an intersection AND it does not
	 * touches (to avoid getting results where only boundary is in common between the two geometries), then the proportion of the area of the intersection
	 * between the maille and X and the area of X is calculated and an entry added to table observation_maille.
	 * 
	 * @param format
	 *            the table_format of the table
	 * @param parameters
	 *            values including : ogam_id, provider_id, codedepartement
	 *             @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void createMaillesLinksFromDepartements(String format, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("createMaillesLinksFromDepartements");

		PreparedStatement ps = null;
		ResultSet rs = null;

		String[] codesDepartements = ((String[]) parameters.get(DSRConstants.CODE_DEPARTEMENT));
		String providerId = (String) parameters.get(DSRConstants.PROVIDER_ID);
		String ogamId = (String) parameters.get(DSRConstants.OGAM_ID);

		StringBuffer stmt = new StringBuffer();

		stmt.append("INSERT INTO mapping.observation_maille ");
		stmt.append("SELECT '" + ogamId + "', '" + providerId + "', '" + format + "', grille.code_10km, ");
		stmt.append("round(cast(St_Area(St_Intersection(departements_union, grille.geom))/St_Area(departements_union) ");
		stmt.append("AS numeric(4,3)), 3) AS pct ");
		stmt.append("FROM referentiels.codemaillevalue AS grille, ");
		stmt.append("(SELECT St_Union(departement.geom) AS departements_union ");
		stmt.append("FROM referentiels.departement_carto_2017 as departement ");
		stmt.append("WHERE departement.code_dept = '" + codesDepartements[0] + "' ");
		for (int i = 1; i < codesDepartements.length; ++i) {
			stmt.append("OR departement.code_dept = '" + codesDepartements[i] + "' ");
		}
		stmt.append(") as foo ");
		stmt.append("WHERE St_Intersects(departements_union, grille.geom) = true ");
		stmt.append("AND St_Touches(departements_union, grille.geom) = false ");
		try {

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			ps.executeUpdate();
			ps.close();
		} catch (Exception e){
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * Deletes from tables "observation_maille" all the associations linked to the format. Code is executed only if table above exists.
	 * 
	 * @param format
	 *            the table format
	 * @param submissionId
	 *            the identifier of the submission
	 *             @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void deleteMaillesFromFormat(TableFormatData tableFormat, Integer submissionId, Connection con) throws Exception {
		logger.debug("deleteMaillesFromFormat");

		PreparedStatement ps = null;
		ResultSet rs = null;

		String tableName = tableFormat.getTableName();
		String format = tableFormat.getFormat();

		StringBuffer stmt = new StringBuffer();

		stmt.append("SELECT to_regclass('mapping.observation_maille') as om_reg");
		try {

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();

			String omReg;

			if (rs.next()) {
				omReg = rs.getString("om_reg");
				if (omReg != null) {
					stmt = new StringBuffer();
					stmt.append("DELETE FROM mapping.observation_maille AS om ");
					stmt.append("USING raw_data." + tableName + " as rd ");
					stmt.append("WHERE om.id_observation = rd.ogam_id_" + format + " ");
					stmt.append("AND om.id_provider = rd.provider_id ");
					stmt.append("AND submission_id = " + submissionId + ";");

					ps = con.prepareStatement(stmt.toString());
					logger.trace(stmt.toString());
					ps.executeUpdate();
					rs.close();
					ps.close();
				}
			}
		} catch (Exception e){
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

	/**
	 * 
	 * Populates the field "codeMailleCalcule" by getting the information from table "observation_maille".
	 * 
	 * @param format
	 *            the table format
	 * @param tableName
	 *            the tablename in raw_data schema
	 * @param parameters
	 *            values including : ogam_id, provider_id
	 *             @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void setCodeMailleCalcule(String format, String tableName, Map<String, Object> parameters, Connection con) throws Exception {
		logger.debug("setCodeMailleCalcule");

		PreparedStatement ps = null;
		ResultSet rs = null;

		StringBuffer stmt = null;

		String providerId = (String) parameters.get(DSRConstants.PROVIDER_ID);
		String ogamId = (String) parameters.get(DSRConstants.OGAM_ID);

		// Get the list of the mailles
		stmt = new StringBuffer();
		stmt.append("SELECT id_maille ");
		stmt.append("FROM mapping.observation_maille as om ");
		stmt.append("WHERE om.id_observation = '" + ogamId + "' ");
		stmt.append("AND om.id_provider = '" + providerId + "' ");
		stmt.append("AND om.table_format = '" + format + "' ");

		try {

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();

			// Create a list of code mailles found
			List<String> codesMailles = new ArrayList<String>();

			while (rs.next()) {
				codesMailles.add(rs.getString("id_maille"));
			}

			StringBuffer codeMailleCalcule = new StringBuffer("{");

			for (String codeMaille : codesMailles) {
				codeMailleCalcule.append(codeMaille);
				codeMailleCalcule.append(",");
			}

			if (codeMailleCalcule.length() != 1) {
				codeMailleCalcule.delete(codeMailleCalcule.length() - 1, codeMailleCalcule.length());
			}
			codeMailleCalcule.append("}");

			stmt = new StringBuffer();
			stmt.append("UPDATE raw_data." + tableName + " ");
			stmt.append("SET " + DSRConstants.CODE_MAILLE_CALC + " = '" + codeMailleCalcule.toString() + "' ");
			stmt.append("WHERE provider_id = '" + providerId + "' ");
			stmt.append("AND ogam_id_" + format + " = '" + ogamId + "' ");

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			ps.executeUpdate();
			rs.close();
			ps.close();
		} catch (Exception e){
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}

}
