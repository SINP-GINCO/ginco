<?php
namespace Ign\Bundle\ConfigurateurBundle\Tests\Controller;

use Ign\Bundle\ConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\ConfigurateurBundle\Entity;
use Ign\Bundle\ConfigurateurBundle\Entity\FileFormat;
use Ign\Bundle\ConfigurateurBundle\Entity\TableFormat;

class FieldMappingControllerTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_field_mapping_controller.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();
		$this->client = static::createClient();
		$this->client->followRedirects(true);

		$this->repository = $this->em->getRepository('IgnConfigurateurBundle:FieldMapping');
	}

	public function testNewMappingRelation() {
		// table format is added so it is possible to select dst_data (no need for ajax loading)
		$crawler = $this->client->request('GET', 'datasetsimport/3/files/file_with_fields/mappings/?dstFormat=table_with_fields');
		$this->assertTrue($crawler->filter('#mappingRelations')
			->filter('html:contains("altitudemax")')
			->count() == 0);

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_field_mapping]')->form();
		$form['ign_bundle_configurateurbundle_field_mapping[dst_format]'] = "table_with_fields";
		$form['ign_bundle_configurateurbundle_field_mapping[src_data]'] = 'altitudemax';
		$form['ign_bundle_configurateurbundle_field_mapping[dst_data]'] = 'altitudemax';

		$crawler = $this->client->submit($form);
		$this->assertTrue(strpos($crawler->filter('#mappingRelations')
			->html(), 'altitudemax') !== false);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testEditMappingRelation() {
		$fileLabel = $this->em->getRepository('IgnConfigurateurBundle:FileFormat')
			->find('file_with_field')
			->getLabel();

		$crawler = $this->client->request('GET', 'datasetsimport/3/files/file_with_field/mappings?srcData=identite&dstFormat=table_with_fields2&dstData=identite');

		$filter = 'html:contains("' . $this->translator->trans('fieldMapping.fileField') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_field_mapping]')->form();
		$form['ign_bundle_configurateurbundle_field_mapping[dst_data]'] = 'nomorganisme';
		$crawler = $this->client->submit($form);

		$filter = '#mappingRelations';
		$this->assertEquals($crawler->filter($filter)
			->count(), 1);
		$filter = 'html:contains("Nom officiel de(s) l")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testConstraintSrcDataNotBlank() {
		$crawler = $this->client->request('GET', 'datasetsimport/3/files/file_with_fields/mapping/edit/jddid/table_with_fields/jddid');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_field_mapping]')->form();
		$form['ign_bundle_configurateurbundle_field_mapping[src_data]'] = "";
		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('fieldMapping.srcData.notBlank', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testConstraintDstFormatNotBlank() {
		$crawler = $this->client->request('GET', 'datasetsimport/3/files/file_with_fields/mapping/edit/altitudemax/table_with_fields/altitudemax');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_field_mapping]')->form();
		$form['ign_bundle_configurateurbundle_field_mapping[dst_format]'] = "";
		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('fieldMapping.dstFormat.notBlank', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testConstraintUnicitySameFileSameTableSameTableField() {
		$crawler = $this->client->request('GET', 'datasetsimport/3/files/file_with_fields/mappings/?srcData=altitudemax&dstFormat=table_with_fields2');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_field_mapping]')->form();
		$form['ign_bundle_configurateurbundle_field_mapping[dst_data]'] = "referencebiblio";
		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('fieldMapping.unique', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testNotConstraintUnicityDifferentFileSameTableSameTableField() {
		$crawler = $this->client->request('GET', 'datasetsimport/3/files/file_with_fields/mapping/edit/jddcode/table_with_fields2/referencebiblio');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_field_mapping]')->form();
		$form['ign_bundle_configurateurbundle_field_mapping[dst_data]'] = "identite";
		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('fieldMapping.unique', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testRemoveMapping() {
		$crawler = $this->client->request('GET', 'datasetsimport/3/files/file_with_fields/mapping/remove/jddcode/table_with_fields2/identite');

		$filter = '#mappingRelations';
		$this->assertTrue($crawler->filter($filter)
			->count() == 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * TODO complete the test.
	 */
	public function testRemoveFileFieldRemovesMapping() {

		$crawler = $this->client->request('GET', 'datasetsimport/5/files/file_with_cdnom/mappings/');
		$filter = 'html:contains("Code du taxon « cd_nom » de TaxRef")';
		$this->assertEquals($crawler->filter($filter)
			->count(), 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$this->client = static::createClient();
		$this->client->followRedirects(true);

		$crawler = $this->client->request('GET', 'datasetsimport/5/files/file_with_cdnom/fields/remove/cdnom/update/cdnom,/false,/null,/1,/');
		$filter = 'html:contains(">Code du taxon « cd_nom » de TaxRef<")';
		$this->assertEquals($crawler->filter($filter)
			->count(), 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$this->client = static::createClient();
		$this->client->followRedirects(true);

		$crawler = $this->client->request('GET', 'datasetsimport/5/files/file_with_cdnom/mappings/');
		$filter = 'html:contains("Code du taxon « cd_nom » de TaxRef")';
		$this->assertEquals($crawler->filter($filter)
			->count(), 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * TODO complete the test.
	 */
	public function testRemoveFileRemovesMapping() {
		$crawler = $this->client->request('GET', 'datasetsimport/3/files/file_with_fields/delete/');

		$filter = 'html:contains("file_with_fields")';

		$filter = 'html:contains("' . $this->translator->trans('file.delete.success', array(
			'%file.label%' => 'file_with_fields',
			'%datasetLabel%' => 'dataset_import_to_edit'
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * TODO complete the test.
	 */
	public function testRemoveTableRemovesMapping() {
		$crawler = $this->client->request('GET', 'models/3/tables/table_to_delete/delete/');

		$filter = 'html:contains("' . $this->translator->trans('table.delete.success', array(
			'%tableName%' => 'table_to_delete'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testViewWithNoMapping() {
		$crawler = $this->client->request('GET', '/datasetsimport/4/files/file_without_mapping/view/');

		$filter1 = 'html:contains("' . $this->translator->trans('fieldMapping.none') . '")';

		$this->assertTrue($crawler->filter($filter1)
			->count() > 0);
	}

	public function testViewWithMapping() {
		$crawler = $this->client->request('GET', '/datasetsimport/4/files/file_with_mapping/view/');

		$filter1 = 'html:contains("NOM Prénom (organisme)")';

		$this->assertTrue($crawler->filter($filter1)
			->count() > 0);
	}

	public function testAutoMappingWithoutSelectedTable() {
		$crawler = $this->client->request('GET', '/datasetsimport/3/files/file_auto_mapping/mappings/');
		// Try to submit the auto-mapping form without selecting a table
		$form = $crawler->selectButton('Mapping automatique')->form();
		$form['ign_bundle_configurateurbundle_field_mapping_auto[dst_format]'] = '';
		$crawler = $this->client->submit($form);

		$filter = 'html:contains("' . $this->translator->trans('fieldMapping.auto.chooseatable') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
	}

	/**
	 * Tests auto mapping.
	 * Initial situation :
	 * FILE | TABLE
	 * altitudemin | altitudemin
	 * altitudemax | altitudemax
	 * cdnom | cdnom
	 * codecommune | cdref
	 * And altitudemax is mapped on altitudemin
	 *
	 * Performs auto-mapping and checks (in db )
	 * - altitudemax is still mapped on altitudemin (not changed by auto-mapping)
	 * - altitudemin is not mapped (already involved in a mapping)
	 * - cdnom is now mapped on cdnom
	 * - codecommune is not mapped (no corresponding field).
	 *
	 * @covers Ign\Bundle\ConfigurateurBundle\Controller\FieldMappingController::autoAction
	 */
	public function testAutoMapping() {
		$crawler = $this->client->request('GET', '/datasetsimport/3/files/file_auto_mapping/mappings/');
		// Performs auto-mapping
		$form = $crawler->selectButton('Mapping automatique')->form();

		$form['ign_bundle_configurateurbundle_field_mapping_auto[dst_format]'] = 'table_auto_mapping';
		$crawler = $this->client->submit($form);

		$filter = '#mappingRelations';
		$tableMappings = $crawler->filter($filter);
		$this->assertTrue($tableMappings->count() > 0);

		// Extract direct info from DB (table field_mapping) :
		$query = $this->em->createQuery('SELECT
					fm.srcData as srcData, fm.dstData as dstData
					FROM IgnConfigurateurBundle:FieldMapping fm
					WHERE fm.mappingType = :mappingType
					AND fm.srcFormat = :fileFormat
					AND fm.dstFormat = :tableFormat')->setParameters(array(
			'fileFormat' => 'file_auto_mapping',
			'tableFormat' => 'table_auto_mapping',
			'mappingType' => 'FILE'
		));
		$mappings = $query->getResult();

		$altMaxMappedtoAltMin = false;
		$altMinMapped = false;
		$cdnomMappedtoCdnom = false;
		$codecommuneMapped = false;

		foreach ($mappings as $mapping) {
			if ($mapping['srcData'] == 'altitudemax' && $mapping['dstData'] == 'altitudemin') {
				$altMaxMappedtoAltMin = true;
			}
			if ($mapping['srcData'] == 'altitudemin') {
				$altMinMapped = true;
			}
			if ($mapping['srcData'] == 'cdnom' && $mapping['dstData'] == 'cdnom') {
				$cdnomMappedtoCdnom = true;
			}
			if ($mapping['srcData'] == 'codecommune') {
				$codecommuneMapped = true;
			}
		}

		$this->assertTrue($altMaxMappedtoAltMin);
		$this->assertFalse($altMinMapped);
		$this->assertTrue($cdnomMappedtoCdnom);
		$this->assertFalse($codecommuneMapped);
	}
}