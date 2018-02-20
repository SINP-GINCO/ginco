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
package fr.ifn.ogam.integration;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.NamingException;

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
public class AbstractEFDACTest extends JndiBasedDBTestCase {

	protected static Logger logger = null;

	/**
	 * JNDI names of the datasources
	 */
	protected static final String WEBSITE_JNDI_URL = "java:/comp/env/jdbc/website";
	protected static final String RAWDATA_JNDI_URL = "java:/comp/env/jdbc/rawdata";
	protected static final String METADATA_JNDI_URL = "java:/comp/env/jdbc/metadata";
	protected static final String HARMONIZED_JNDI_URL = "java:/comp/env/jdbc/harmonizeddata";

	/**
	 * JNDI connexion pools.
	 */
	protected JNDIUnitTestHelper websiteJNDI;
	protected JNDIUnitTestHelper rawdataJNDI;
	protected JNDIUnitTestHelper metadataJNDI;
	protected JNDIUnitTestHelper harmonizedJNDI;

	protected static final String SUBMISSION_ID = "SUBMISSION_ID";
	protected static final String PROVIDER_ID = "PROVIDER_ID";
	protected static final String REF_YEAR_BEGIN = "REF_YEAR_BEGIN";
	protected static final String REF_YEAR_END = "REF_YEAR_END";

	/**
	 * Constructor
	 * 
	 * @param name
	 */
	public AbstractEFDACTest(String name) {
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

			// Initialise the connexion pools
			// test-webifn
			// websiteJNDI = new JNDIUnitTestHelper("org.postgresql.Driver", "jdbc:postgresql://test-webifn:5432/ogam", "ogam", "ogam", WEBSITE_JNDI_URL);
			// rawdataJNDI = new JNDIUnitTestHelper("org.postgresql.Driver", "jdbc:postgresql://test-webifn:5432/ogam", "ogam", "ogam", RAWDATA_JNDI_URL);
			// metadataJNDI = new JNDIUnitTestHelper("org.postgresql.Driver", "jdbc:postgresql://test-webifn:5432/ogam", "ogam", "ogam", METADATA_JNDI_URL);
			// harmonizedJNDI = new JNDIUnitTestHelper("org.postgresql.Driver", "jdbc:postgresql://test-webifn:5432/ogam", "ogam", "ogam", HARMONIZED_JNDI_URL);

			// localhost
			websiteJNDI = new JNDIUnitTestHelper("org.postgresql.Driver", "jdbc:postgresql://localhost:5432/ogam", "ogam", "ogam", WEBSITE_JNDI_URL);
			rawdataJNDI = new JNDIUnitTestHelper("org.postgresql.Driver", "jdbc:postgresql://localhost:5432/ogam", "ogam", "ogam", RAWDATA_JNDI_URL);
			metadataJNDI = new JNDIUnitTestHelper("org.postgresql.Driver", "jdbc:postgresql://localhost:5432/ogam", "ogam", "ogam", METADATA_JNDI_URL);
			harmonizedJNDI = new JNDIUnitTestHelper("org.postgresql.Driver", "jdbc:postgresql://localhost:5432/ogam", "ogam", "ogam", HARMONIZED_JNDI_URL);

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
}
