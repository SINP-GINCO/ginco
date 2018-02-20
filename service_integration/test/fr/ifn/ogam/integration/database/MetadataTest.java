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
package fr.ifn.ogam.integration.database;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import fr.ifn.ogam.integration.AbstractEFDACTest;
import fr.ifn.ogam.integration.business.Formats;
import fr.ifn.ogam.common.business.MappingTypes;
import fr.ifn.ogam.common.database.metadata.FieldData;
import fr.ifn.ogam.common.database.metadata.DatasetData;
import fr.ifn.ogam.common.database.metadata.FileFieldData;
import fr.ifn.ogam.common.database.metadata.FileFormatData;
import fr.ifn.ogam.common.database.metadata.MetadataDAO;
import fr.ifn.ogam.common.database.metadata.ModeData;
import fr.ifn.ogam.common.database.metadata.RangeData;
import fr.ifn.ogam.common.database.metadata.TableFieldData;
import fr.ifn.ogam.common.database.metadata.TableFormatData;
import fr.ifn.ogam.common.database.metadata.TableTreeData;

//
// Note : In order to use this Test Class correctly under Eclipse, you need to change the working directory to
// ${workspace_loc:EFDAC - Framework Contract for forest data and services/service_integration}
//

/**
 * Test cases concerning the metadata.
 */
public class MetadataTest extends AbstractEFDACTest {

	// The DAOs
	private MetadataDAO metadataDAO = new MetadataDAO();

	/**
	 * Constructor
	 * 
	 * @param name
	 */
	public MetadataTest(String name) {
		super(name);
	}

	/**
	 * Test the CheckCode function.
	 */
	public void testCheckCode() throws Exception {

		// The code xxx is not a country code
		assertFalse("The code xxx is not a country code", metadataDAO.checkCode("SPECIES_CODE", "toto"));

		// The code 1 is a country code
		assertTrue("The code 1 is a country code", metadataDAO.checkCode("SPECIES_CODE", "164.002.001"));
	}

	/**
	 * Test the getModes function.
	 */
	public void testGetModes() throws Exception {

		List<ModeData> countryCodes = metadataDAO.getModes("SPECIES_CODE");

		assertEquals("There is 303 differents species codes", 303, countryCodes.size());

	}

	/**
	 * Test the getDatasets function.
	 */
	public void testGetDatasets() throws Exception {

		List<DatasetData> datasets = metadataDAO.getDatasets();

		assertEquals("There should be 2 datasets configured in database", 2, datasets.size());

	}

	/**
	 * Test the getRange function.
	 */
	public void testGetRange() throws Exception {

		RangeData range = metadataDAO.getRange("PERCENTAGE");

		assertEquals("The PH max range should be 100", new BigDecimal(100), range.getMaxValue());

		assertEquals("The PH min range should be 0", BigDecimal.ZERO, range.getMinValue());

	}

	/**
	 * Test the getType function.
	 */
	public void testGetType() throws Exception {

		String type = metadataDAO.getType("SPECIES_CODE");

		assertEquals("The type of the data SPECIES_CODE should be CODE", "CODE", type);

	}

	/**
	 * Test the getRequestFiles function.
	 */
	public void testGetRequestFiles() throws Exception {

		String requestID = "SPECIES";

		List<FileFormatData> requestFormats = metadataDAO.getDatasetFiles(requestID);

		FileFormatData file1 = requestFormats.get(0);
		FileFormatData file2 = requestFormats.get(1);
		FileFormatData file3 = requestFormats.get(2);

		assertEquals("The first file of the REQUEST should be LOCATION_FILE", "LOCATION_FILE", file1.getFormat());
		assertEquals("The first file of the REQUEST should be PLOT_FILE", "PLOT_FILE", file2.getFormat());
		assertEquals("The second file of the REQUEST should be SPECIES_FILE", "SPECIES_FILE", file3.getFormat());

	}

	/**
	 * Test the getFileFields function.
	 */
	public void testGetFileFields() throws Exception {

		String fileFormat = Formats.SPECIES_FILE;

		List<FileFieldData> fields = metadataDAO.getFileFields(fileFormat);

		assertEquals("The basic test tree file should have 5 columns", 5, fields.size());

	}

	/**
	 * Test the getTablesTree function.
	 */
	public void testGetTablesTree() throws Exception {

		String tableFormat = Formats.SPECIES_DATA;
		String schemaCode = "RAW_DATA";

		List<TableTreeData> tables = metadataDAO.getTablesTree(tableFormat, schemaCode);

		assertEquals("The SPECIES_DATA table should have 3 ancestors", 3, tables.size());

		logger.debug(tables);

	}

	/**
	 * Test the getFormatMapping function.
	 */
	public void testGetFormatMapping() throws Exception {

		String tableFormat = Formats.SPECIES_FILE;

		Map<String, TableFormatData> tables = metadataDAO.getFormatMapping(tableFormat, MappingTypes.FILE_MAPPING);

		logger.debug(tables);

		assertTrue("The SPECIES_DATA should be the destination of SPECIES_FILE", tables.containsKey("SPECIES_DATA"));

	}

	/**
	 * Test the getField function.
	 */
	public void testGetField() throws Exception {

		String fieldName = "PLOT_CODE";

		FieldData field = metadataDAO.getFileField(fieldName);
		if (field == null) {
			fail("Field should not be null");
		}

		assertEquals("The field name should correspond", field.getData(), fieldName);
		assertEquals("The PLOT_CODE unit should be PLOT_CODE", field.getUnit(), "PLOT_CODE");

	}

	/**
	 * Test the getFieldMapping function.
	 */
	public void testGetFieldMapping() throws Exception {

		String sourceFormat = Formats.PLOT_FILE;

		Map<String, TableFieldData> mapping = metadataDAO.getFileToTableMapping(sourceFormat);
		if (mapping == null) {
			fail("Mapping should not be null");
		}

		TableFieldData dest = mapping.get("PLOT_CODE");

		assertEquals("The destination of the PLOT_CODE field should be the table PLOT_DATA", dest.getFormat(), "PLOT_DATA");

	}

	/**
	 * Test the getTableFields function.
	 */
	public void testGetTableFields() throws Exception {

		String tableFormat = "PLOT_DATA";

		Map<String, TableFieldData> fields = metadataDAO.getTableFields(tableFormat);

		logger.debug(fields);

		assertEquals("The PLOT_DATA table should contain 10 fields", 11, fields.size());

	}

	/**
	 * Test the getTableName function.
	 */
	public void testGetTableName() throws Exception {

		String tableFormatName = "PLOT_DATA";

		TableFormatData tableFormat = metadataDAO.getTableFormat(tableFormatName);

		assertEquals("The physical name of the PLOT_DATA table should be PLOT_DATA", tableFormat.getTableName(), tableFormatName);

	}

}
