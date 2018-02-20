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

import java.sql.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import fr.ifn.ogam.common.database.GenericData;
import fr.ifn.ogam.common.util.DSRConstants;

/**
 * Test cases for the ComputeGeoAssociationService class.
 * 
 * @author gpastakia
 */
public class ComputeGeoAssociationServiceTest extends AbstractGINCOTest {

	private ComputeGeoAssociationService cgas = new ComputeGeoAssociationService();

	/**
	 * Constructor
	 * 
	 * @param name
	 */
	public ComputeGeoAssociationServiceTest(String name) {
		super(name);
	}

	/**
	 * Launches for 20 observations the calculation of geoadministrative attachments. Many cases tested with different combinations: - with or without geometry
	 * - with or without codecommune - with or without codemaille - with or without codedepartement - with or witout typeinfogeocommune, typeinfogeomaille,
	 * typeinfogeodepartement
	 */
	public void testInsertAdministrativeAssociations() throws Exception {

		try {

			Context initContext = new InitialContext();
			DataSource ds = (DataSource) initContext.lookup(RAWDATA_JNDI_URL);
			Connection con = ds.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;

			for (int i = 0; i < DataValues.OGAM_IDS.length; ++i) {

				cgas.insertAdministrativeAssociations("table_observation", "model_523_observation", getValuesMap(i), DataValues.OGAM_IDS[i]);

				String getStmt = "SELECT codecommunecalcule, nomcommunecalcule, codemaillecalcule, codedepartementcalcule "
						+ "FROM raw_data.model_523_observation " + "WHERE " + DSRConstants.OGAM_ID + "_" + "table_observation = '" + (i + 1) + "';";

				ps = con.prepareStatement(getStmt);
				logger.debug(getStmt);
				rs = ps.executeQuery();
				rs.next();

				Array codeCommuneCalcActualArray = rs.getArray(DSRConstants.CODE_COMMUNE_CALC);
				List<String> codeCommuneCalculesActual = Arrays.asList((String[]) codeCommuneCalcActualArray.getArray());

				Array nomCommuneCalcActualArray = rs.getArray(DSRConstants.NOM_COMMUNE_CALC);
				List<String> nomCommuneCalculesActual = Arrays.asList((String[]) nomCommuneCalcActualArray.getArray());

				Array codeMailleCalcActualArray = rs.getArray(DSRConstants.CODE_MAILLE_CALC);
				List<String> codeMailleCalculesActual = Arrays.asList((String[]) codeMailleCalcActualArray.getArray());

				Array codeDepartementCalcActualArray = rs.getArray(DSRConstants.CODE_DEPARTEMENT_CALC);
				List<String> codeDepartementCalculesActual = Arrays.asList((String[]) codeDepartementCalcActualArray.getArray());

				for (int k = 0; k < DataValues.CODE_COMMUNE_CALCULES_EXPECTED[i].length; ++k) {
					assertTrue(codeCommuneCalculesActual.contains(DataValues.CODE_COMMUNE_CALCULES_EXPECTED[i][k]));
				}
				for (int k = 0; k < DataValues.NOM_COMMUNE_CALCULES_EXPECTED[i].length; ++k) {
					assertTrue(nomCommuneCalculesActual.contains(DataValues.NOM_COMMUNE_CALCULES_EXPECTED[i][k]));
				}
				for (int k = 0; k < DataValues.CODE_MAILLE_CALCULES_EXPECTED[i].length; ++k) {
					assertTrue(codeMailleCalculesActual.contains(DataValues.CODE_MAILLE_CALCULES_EXPECTED[i][k]));
				}
				for (int k = 0; k < DataValues.CODE_DEPARTEMENT_CALCULES_EXPECTED[i].length; ++k) {
					assertTrue(codeDepartementCalculesActual.contains(DataValues.CODE_DEPARTEMENT_CALCULES_EXPECTED[i][k]));
				}

				assertEquals(DataValues.CODE_COMMUNE_CALCULES_EXPECTED[i].length, codeCommuneCalculesActual.size());
				assertEquals(DataValues.NOM_COMMUNE_CALCULES_EXPECTED[i].length, nomCommuneCalculesActual.size());
				assertEquals(DataValues.CODE_MAILLE_CALCULES_EXPECTED[i].length, codeMailleCalculesActual.size());
				assertEquals(DataValues.CODE_DEPARTEMENT_CALCULES_EXPECTED[i].length, codeDepartementCalculesActual.size());

				// Check administrative associations are not computed if the file does not contain geometric field
				// The table does not exist, we just check there is no error calling the function with no geometry 
				cgas.insertAdministrativeAssociations("table_attribut_additionnel", "model_inutile", getValuesMapNoGeometry(), "1");

			}

		} catch (Exception e) {
			logger.error(e);
			assertTrue(false);
		}
	}

	/**
	 * In-memory values to simulate the values map argument to insertAdministrativeAssociations(...) function.
	 * 
	 * @param index
	 * @return the values Map
	 */
	private Map<String, GenericData> getValuesMap(int index) {
		Map<String, GenericData> values = new HashMap<String, GenericData>();
		GenericData gd;

		String[] columnNames = { DSRConstants.OGAM_ID + "_" + "table_observation", DSRConstants.PROVIDER_ID, DSRConstants.GEOMETRIE, DSRConstants.CODE_COMMUNE,
				DSRConstants.NOM_COMMUNE, DSRConstants.CODE_MAILLE, DSRConstants.CODE_DEPARTEMENT, DSRConstants.TYPE_INFO_GEO_COMMUNE,
				DSRConstants.TYPE_INFO_GEO_MAILLE, DSRConstants.TYPE_INFO_GEO_DEPARTEMENT, "sensiniveau", DSRConstants.CODE_COMMUNE_CALC,
				DSRConstants.NOM_COMMUNE_CALC, DSRConstants.CODE_MAILLE_CALC, DSRConstants.CODE_DEPARTEMENT_CALC };

		Object[] dataValues = { DataValues.OGAM_IDS[index], DataValues.PROVIDER_IDS[index], DataValues.GEOMETRIES[index], DataValues.CODE_COMMUNES[index],
				DataValues.NOM_COMMUNES[index], DataValues.CODE_MAILLES[index], DataValues.CODE_DEPARTEMENTS[index], DataValues.TYPE_INFO_GEO_COMMUNES[index],
				DataValues.TYPE_INFO_GEO_MAILLES[index], DataValues.TYPE_INFO_GEO_DEPARTEMENTS[index], DataValues.SENSI_NIVEAUX[index],
				DataValues.CODE_COMMUNE_CALCULES[index], DataValues.NOM_COMMUNE_CALCULES[index], DataValues.CODE_MAILLE_CALCULES[index],
				DataValues.CODE_DEPARTEMENT_CALCULES[index] };

		for (int i = 0; i < columnNames.length; ++i) {
			gd = new GenericData();
			gd.setColumnName(columnNames[i]);
			gd.setValue(dataValues[i]);
			values.put(columnNames[i], gd);
		}

		return values;
	}
	
	/**
	 * In-memory values with no geometry to simulate the values map argument to insertAdministrativeAssociations(...) function.
	 * 
	 * @param index
	 * @return the values Map
	 */
	private Map<String, GenericData> getValuesMapNoGeometry() {
		Map<String, GenericData> values = new HashMap<String, GenericData>();
		GenericData gd;

		String[] columnNames = { DSRConstants.OGAM_ID + "_" + "table_attribut_additionnel", DSRConstants.PROVIDER_ID, "nomattribut","definitionattribut", "valeurattribut", };

		Object[] dataValues = { "23", "1", "couleurplumes", "la couleur des plumes de l'oiseau", "rouge"};

		for (int i = 0; i < columnNames.length; ++i) {
			gd = new GenericData();
			gd.setColumnName(columnNames[i]);
			gd.setValue(dataValues[i]);
			values.put(columnNames[i], gd);
		}

		return values;
	}
}
