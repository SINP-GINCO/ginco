/**
 * 
 */
package fr.ifn.ogam.common.database.referentiels;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
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
 * 
 * DAO for methods involving communes georeferencing.
 * 
 * @author gpastakia
 *
 */
public class CommuneDAO extends AdministrativeEntityDAO {

	/**
	 * Deletes from tables "observation_commune" all the associations linked to the format. Code is executed only if table above exists.
	 * 
	 * @param format
	 *            the table format
	 * @param submissionId
	 *            the identifier of the submission
	 * @param con
	 *            the connection to the database linked to the submission
	 * @throws Exception
	 */
	public void deleteCommunesFromFormat(TableFormatData tableFormat, Integer submissionId, Connection con) throws Exception {
		logger.debug("deleteCommunesFromFormat");

		PreparedStatement ps = null;
		ResultSet rs = null;

		String tableName = tableFormat.getTableName();
		String format = tableFormat.getFormat();

		StringBuffer stmt = new StringBuffer();
		stmt.append("SELECT to_regclass('mapping.observation_commune') as oc_reg");

		try {

			ps = con.prepareStatement(stmt.toString());
			logger.trace(stmt.toString());
			rs = ps.executeQuery();

			String ocReg;

			if (rs.next()) {
				ocReg = rs.getString("oc_reg");
				if (ocReg != null) {
					stmt = new StringBuffer();
					stmt.append("DELETE FROM mapping.observation_commune as oc ");
					stmt.append("USING raw_data." + tableName + " as rd ");
					stmt.append("WHERE oc.id_observation = rd.ogam_id_" + format + " ");
					stmt.append("AND oc.id_provider = rd.provider_id ");
					stmt.append("AND submission_id = " + submissionId + ";");

					ps = con.prepareStatement(stmt.toString());
					logger.trace(stmt.toString());
					ps.executeUpdate();
					ps.close();
				}
				rs.close();
			}
		} catch (Exception e) {
			logger.error("Error while executing function : ", e);
			throw e;
		}
	}
}
