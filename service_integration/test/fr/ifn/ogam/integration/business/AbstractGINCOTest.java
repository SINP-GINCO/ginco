/**
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

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.ConsoleAppender;
import org.apache.log4j.Layout;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.dbunit.JndiBasedDBTestCase;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.xml.FlatXmlDataSet;
import org.dbunit.operation.DatabaseOperation;

import fr.ifn.ogam.common.util.JNDIUnitTestHelper;

/**
 * Mother classe for the EFDAC service test classes.
 */
public class AbstractGINCOTest extends JndiBasedDBTestCase {

	protected static Logger logger = null;

	/**
	 * JNDI names of the datasources
	 */
	protected static final String WEBSITE_JNDI_URL = "java:/comp/env/jdbc/website";
	protected static final String RAWDATA_JNDI_URL = "java:/comp/env/jdbc/rawdata";
	protected static final String METADATA_JNDI_URL = "java:/comp/env/jdbc/metadata";

	/**
	 * JNDI connexion pools.
	 */
	protected JNDIUnitTestHelper websiteJNDI;
	protected JNDIUnitTestHelper rawdataJNDI;
	protected JNDIUnitTestHelper metadataJNDI;

	/**
	 * Constructor
	 * 
	 * @param name
	 */
	public AbstractGINCOTest(String name) {
		super(name);
	}

	/**
	 * Returns the JNDI properties to use.<br>
	 */
	protected Properties getJNDIProperties() {
		Properties env = new Properties();
		env.put(Context.INITIAL_CONTEXT_FACTORY, JNDIUnitTestHelper.getContextFactoryName());
		return env;
	}

	/**
	 * Access to the metadata database
	 */
	protected String getLookupName() {
		return METADATA_JNDI_URL;
	}

	/**
	 * Locate the data
	 */
	protected IDataSet getDataSet() throws Exception {
		return new FlatXmlDataSet(new FileInputStream("./test/test_metadata.xml"), false);
	}

	/**
	 * Insert the test metadata before to do the tests
	 */
	protected DatabaseOperation getSetUpOperation() throws Exception {
		logger.debug("Preparing the metadata for the test");
		return DatabaseOperation.REFRESH;
	}

	/**
	 * Remove the test metadata after the tests
	 */
	protected DatabaseOperation getTearDownOperation() throws Exception {
		logger.debug("Cleaning the metadata after the test");
		return DatabaseOperation.DELETE;
	}

	/**
	 * Initialise the test session.
	 */
	protected void setUp() throws Exception {
		try {
			// Initialise Log4J
			if (logger == null) {
				logger = Logger.getLogger(this.getClass());

				// Log general
				Layout layout = new PatternLayout("%-5p [%t]: %m%n");
				ConsoleAppender appender = new ConsoleAppender(layout, ConsoleAppender.SYSTEM_OUT);
				BasicConfigurator.configure(appender);
				Logger.getRootLogger().setLevel(Level.TRACE);

				Logger dblogger = Logger.getLogger("org.dbunit");
				dblogger.addAppender(appender);

			}

			String dbDriver = "org.postgresql.Driver";
			String dbUrl = "jdbc:postgresql://localhost:5432/sinp_unit_test";
			String dbLogin = "ogam";
			String dbPasword = "ogam";

			websiteJNDI = new JNDIUnitTestHelper(dbDriver, dbUrl, dbLogin, dbPasword, WEBSITE_JNDI_URL);
			rawdataJNDI = new JNDIUnitTestHelper(dbDriver, dbUrl, dbLogin, dbPasword, RAWDATA_JNDI_URL);
			metadataJNDI = new JNDIUnitTestHelper(dbDriver, dbUrl, dbLogin, dbPasword, METADATA_JNDI_URL);

			initiateDatabase();
		} catch (IOException ioe) {
			ioe.printStackTrace();
			fail("IOException thrown : " + ioe.getMessage());
		} catch (NamingException ne) {
			ne.printStackTrace();
			fail("NamingException thrown on Init : " + ne.getMessage());
		}

		// Call the DBUnit setup method
		super.setUp();

	}

	/**
	 * Clean the test session.
	 */
	protected void tearDown() throws Exception {
		try {

			// Call the DBUnit teardown method
			super.tearDown();

			// Shutdown les pools de connexion JNDI
			websiteJNDI.shutdown();
			rawdataJNDI.shutdown();
			metadataJNDI.shutdown();

		} catch (NamingException ne) {
			ne.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * This test does nothing, its to avoid a problem with Gradle.
	 */
	public void testEmpty() throws Exception {
		assertTrue(true);
	}

	protected void initiateDatabase() {
		try {
			Context initContext = new InitialContext();
			DataSource ds = (DataSource) initContext.lookup(RAWDATA_JNDI_URL);
			Connection con = ds.getConnection();
			PreparedStatement ps = null;

			String createStmt = "DELETE FROM mapping.observation_geometrie;" + "DELETE FROM mapping.observation_commune;"
					+ "DELETE FROM mapping.observation_maille;" + "DELETE FROM mapping.observation_departement;"
					+ "DROP TABLE IF EXISTS raw_data.model_523_observation ; CREATE TABLE raw_data.model_523_observation ("
					+ "codedepartement character varying(255)[]," + "typeinfogeomaille character varying(255)," + "codecommunecalcule character varying(255)[],"
					+ "ogam_id_table_observation character varying(255) NOT NULL," + "typeinfogeocommune character varying(255),"
					+ "sensiniveau character varying(255) NOT NULL," + "codedepartementcalcule character varying(255)[],"
					+ "codemaille character varying(255)[]," + "typeinfogeodepartement character varying(255)," + "nomcommunecalcule character varying(255)[],"
					+ "codecommune character varying(255)[]," + "codemaillecalcule character varying(255)[]," + "nomcommune character varying(255)[],"
					+ "provider_id character varying(255) NOT NULL," + "geometrie public.geometry(Geometry,4326));";

			ps = con.prepareStatement(createStmt);
			logger.debug(createStmt);
			ps.execute();

			String insertInto = "INSERT INTO raw_data.model_523_observation VALUES";
			String[] insertValues = {
					"('{\"\"}', NULL, '{\"\"}', '1', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{97313}','{\"\"}' , '{\"\"}', '1', '0101000020E6100000548A66B35D001740CDE29BFDEB274840');",
					"('{\"\"}', NULL, '{\"\"}', '2', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', '0101000020E6100000406A1327F74B4AC09C6A2DCC426B1340');",
					"('{\"\"}', NULL, '{\"\"}', '3', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', '0104000020E6100000030000000101000000406A1327F74B4AC09C6A2DCC426B13400101000000AD4ECE50DC4F4AC0BC07E8BE9C99134001010000008A73D4D171494AC03DB5FAEAAAC01340');",
					"('{\"\"}', NULL, '{\"\"}', '4', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{97313}', '{\"\"}', '{\"\"}', '1', '0102000020E610000002000000406A1327F74B4AC09C6A2DCC426B13402DB29DEFA73E4AC012876C205D7C1340');",
					"('{971}', NULL, '{\"\"}', '5', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{97129,97111,97121,97106}', '{\"\"}', '{\"\"}', '1', NULL);",
					"('{\"\"}', NULL, '{\"\"}', '6', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', '0105000020E610000002000000010200000002000000406A1327F74B4AC09C6A2DCC426B13402DB29DEFA73E4AC012876C205D7C1340010200000002000000AD4ECE50DC4F4AC0BC07E8BE9C9913408A73D4D171494AC03DB5FAEAAAC01340');",
					"('{\"\"}', NULL, '{\"\"}', '7', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{94080}', '{\"\"}', '{\"\"}', '1', '0103000020E61000000100000005000000A1F831E6AE651F40D578E926317848406688635DDCC61F4072F90FE9B7774840C8073D9B55DF1F4092CB7F48BF6D48402C6519E258571F4039454772F96F4840A1F831E6AE651F40D578E92631784840');",
					"('{17}', NULL, '{\"\"}', '8', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', '0101000020E6100000B2A7019AEE3301400016CF301F5B4840');",
					"('{94}', NULL, '{\"\"}', '9', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', '0102000020E610000002000000B80721205F620340ECA694D74A6C48402FF7C95180680340D5D00660036E4840');",
					"('{17}', NULL, '{\"\"}', '10', NULL, '0', '{\"\"}', '{E041N653,E041N652,E042N652}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', NULL);",
					"('{\"\"}', NULL, '{\"\"}', '11', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{94080}', '{\"\"}', '{\"\"}', '1', '0103000020E610000001000000060000007F130A1170C80340161747E5266C4840C93B873254C503405DE2C803916B4840C616821C94D003405DE2C803916B4840FBC9181F66CF0340E23C9CC0746C4840B7EBA52902BC03402E8F3523836C48407F130A1170C80340161747E5266C4840');",
					"('{\"\"}', NULL, '{\"\"}', '12', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', '0106000020E61000000200000001030000000100000004000000265305A3927A1F4000917EFB3A704840DB8AFD65F7641F408FE4F21FD26F48400DE02D90A0781F4014AE47E17A6C4840265305A3927A1F4000917EFB3A7048400103000000010000000400000010E9B7AF03271F400BB5A679C769484077BE9F1A2F1D1F40E5D022DBF96648409A779CA223391F40E86A2BF69765484010E9B7AF03271F400BB5A679C7694840');",
					"('{94}', NULL, '{\"\"}', '13', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{94080}', '{\"\"}', '{\"\"}', '1', '0106000020E61000000300000001030000000100000004000000265305A3927A1F4000917EFB3A704840DB8AFD65F7641F408FE4F21FD26F48400DE02D90A0781F4014AE47E17A6C4840265305A3927A1F4000917EFB3A7048400103000000010000000400000010E9B7AF03271F400BB5A679C769484077BE9F1A2F1D1F40E5D022DBF96648409A779CA223391F40E86A2BF69765484010E9B7AF03271F400BB5A679C7694840010300000001000000050000003D2CD49AE69D1F40ABCFD556EC5F484058CA32C4B1AE1F40C976BE9F1A5F4840E4839ECDAACF1F40F0A7C64B3761484088855AD3BCA31F404260E5D0226348403D2CD49AE69D1F40ABCFD556EC5F4840');",
					"('{17}', NULL, '{\"\"}', '14', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{67444}', '{\"\"}', '{\"\"}', '1', NULL);",
					"('{\"\"}', NULL, '{\"\"}', '15', '1', '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{67444}', '{\"\"}', '{\"\"}', '1', NULL);",
					"('{\"\"}', '1', '{\"\"}', '16', NULL, '0', '{17}', '{E041N653,E041N652,E042N652}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', NULL)",
					"('{78}', NULL, '{\"\"}', '17', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', NULL);",
					"('{95}', NULL, '{\"\"}', '18', NULL, '0', '{\"\"}', '{\"\"}', '1', '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', NULL);",
					"('{77}', NULL, '{\"\"}', '19', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', '0101000020E6100000D9B11188D77520403255302AA97B4840');",
					"('{94}', NULL, '{\"\"}', '20', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{94080,94067}', '{\"\"}', '{Vincennes,Saint-Mandée}', '1', NULL);",
					"('{\"\"}', NULL, '{\"\"}', '21', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', '0102000020E610000002000000A5E7CC2CF87B12408DD47B2AA7CD4540A5E7CC2CF87B12408DD47B2AA7CD4540');",
					"('{\"\"}', NULL, '{\"\"}', '22', NULL, '0', '{\"\"}', '{\"\"}', NULL, '{\"\"}', '{\"\"}', '{\"\"}', '{\"\"}', '1', '0103000020E61000000100000006000000A5E7CC2CF87B1240F33AE2900DF44540A5E7CC2CF87B1240F33AE2900DF44540A5E7CC2CF87B1240F33AE2900DF44540A5E7CC2CF87B1240F33AE2900DF44540A5E7CC2CF87B1240F33AE2900DF44540A5E7CC2CF87B1240F33AE2900DF44540');" };

			for (String insertValue : insertValues) {
				ps = con.prepareStatement(insertInto + insertValue);
				logger.debug(insertInto + insertValue);
				ps.executeUpdate();
			}

		} catch (Exception e) {
			logger.error(e);
			assertTrue(false);
		}
	}

}
