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

import java.util.ArrayList;
import java.util.List;

import fr.ifn.ogam.integration.AbstractEFDACTest;
import fr.ifn.ogam.common.business.GenericMapper;
import fr.ifn.ogam.common.business.MappingTypes;
import fr.ifn.ogam.common.business.Schemas;
import fr.ifn.ogam.common.database.metadata.MetadataDAO;
import fr.ifn.ogam.common.database.metadata.TableFormatData;

//
// Note : In order to use this Test Class correctly under Eclipse, you need to change the working directory to
// ${workspace_loc:EFDAC - Framework Contract for forest data and services/service_integration}
//

/**
 * Test cases for the Data service.
 */
public class GenericMapperTest extends AbstractEFDACTest {

	// The services
	private GenericMapper genericMapper = new GenericMapper();

	// The DAOs
	private MetadataDAO metadataDAO = new MetadataDAO();

	/**
	 * Constructor
	 * 
	 * @param name
	 */
	public GenericMapperTest(String name) {
		super(name);
	}

	/**
	 * Test the sorting function.
	 */
	public void testGetSortedAncestors() throws Exception {

		// Get the description of the tables linked with some files
		List<TableFormatData> destinationTables = new ArrayList<TableFormatData>();
		destinationTables.addAll(metadataDAO.getFormatMapping(Formats.PLOT_FILE, MappingTypes.FILE_MAPPING).values());
		destinationTables.addAll(metadataDAO.getFormatMapping(Formats.SPECIES_FILE, MappingTypes.FILE_MAPPING).values());

		// Get the ancestors of these tables, in the right order
		List<String> sortedList = genericMapper.getSortedAncestors(Schemas.RAW_DATA, destinationTables);

		// Test with PLOT and TREE in the raw_data schema
		logger.debug("sortedList : " + sortedList.toString());
		assertEquals(3, sortedList.size());
		assertEquals("SPECIES_DATA", sortedList.get(0));
		assertEquals("PLOT_DATA", sortedList.get(1));
		assertEquals("LOCATION_DATA", sortedList.get(2));

	}

}
