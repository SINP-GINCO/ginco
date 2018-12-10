<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\IgnOGAMConfigurateurBundle;
use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

class FileFieldControllerTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_file_field_controller.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		$this->client = static::createClient(array('environment' => 'test_ogam'));
		$this->client->followRedirects(true);

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();

		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:FileField');
	}

	public function testAddFieldsWithNoMappingPossibleAction() {
		$fields = "jddid,jddcode";

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/');

		$this->assertContains('<td id="name" class="hidden">jddid</td>', $crawler->html());
		$this->assertContains('class="longtext" title="Identifiant de la provenance">Identifiant de la provenance</div></td>', $crawler->html());
		$this->assertNotContains('<td id="name" class="hidden">jddcode</td>', $crawler->html());
		$this->assertNotContains('class="longtext" title="Code identifiant de la provenance">Code identifiant de la provenance</div></td>', $crawler->html());

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/add/' . $fields . '/');

		$this->assertContains('<td id="name" class="hidden">jddid</td>', $crawler->html());
		$this->assertContains('class="longtext" title="Identifiant de la provenance">Identifiant de la provenance</div></td>', $crawler->html());
		$this->assertContains('<td id="name" class="hidden">jddcode</td>', $crawler->html());
		$this->assertContains('class="longtext" title="Code identifiant la provenance">Code identifiant la provenance</div></td>', $crawler->html());
	
		// Extract direct info from DB to check field_mapping has been done
		$query = $this->em->createQuery('SELECT
					fm.srcData as srcData, fm.dstData as dstData
					FROM IgnOGAMConfigurateurBundle:FieldMapping fm
					WHERE fm.mappingType = :mappingType
					AND fm.srcFormat = :fileFormat
					AND fm.dstFormat = :tableFormat')->setParameters(array(
								'fileFormat' => 'my_add_file',
								'tableFormat' => 'my_table',
								'mappingType' => 'FILE'
							));
		$mappings = $query->getResult();
		
		$jddidMappedtojddid = false;
		$jddcodeMappedtojddcode = false;
		
		foreach ($mappings as $mapping) {
			if ($mapping['srcData'] == 'jddid' && $mapping['dstData'] == 'jddid') {
				$jddidMappedtojddid = true;
			}
			if ($mapping['srcData'] == 'jddcode' && $mapping['dstData'] == 'jddcode') {
				$jddcodeMappedtojddcode = true;
			}

		}
		// Fields does not exist in model tables which does not exists too : can't be mapped
		$this->assertFalse($jddcodeMappedtojddcode);
		$this->assertFalse($jddidMappedtojddid);
	
	}
	
	public function testAddFieldsAndMappingAction() {
		$fields = "cdnom,cdref";
	
		$crawler = $this->client->request('GET', '/datasetsimport/3/files/file_auto_mapping/fields/add/' . $fields . '/');
	
		$this->assertContains('<td id="name" class="hidden">cdnom</td>', $crawler->html());
		$this->assertContains('<td id="name" class="hidden">cdref</td>', $crawler->html());

		// Extract direct info from DB (table field_mapping) :
		$query = $this->em->createQuery('SELECT
					fm.srcData as srcData, fm.dstData as dstData
					FROM IgnOGAMConfigurateurBundle:FieldMapping fm
					WHERE fm.mappingType = :mappingType
					AND fm.srcFormat = :fileFormat
					AND fm.dstFormat = :tableFormat')->setParameters(array(
			'fileFormat' => 'file_auto_mapping',
			'tableFormat' => 'table_auto_mapping',
			'mappingType' => 'FILE'
		));
		$mappings = $query->getResult();

		$altMinMapped = false;
		$cdnomMappedtoCdnom = false;
		$cdrefMappedtoCdref = false;

		foreach ($mappings as $mapping) {
			if ($mapping['srcData'] == 'altitudemin') {
				$altMinMapped = true;
			}
			if ($mapping['srcData'] == 'cdnom' && $mapping['dstData'] == 'cdnom') {
				$cdnomMappedtoCdnom = true;
			}
			if ($mapping['srcData'] == 'cdref' && $mapping['dstData'] == 'cdref') {
				$cdrefMappedtoCdref = true;
			}
		}

		$this->assertFalse($altMinMapped);
		$this->assertTrue($cdnomMappedtoCdnom);
		$this->assertTrue($cdrefMappedtoCdref);
	
	}

	public function testRemoveField() {
		$field = "jddid";

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_remove_file/fields/');

		$this->assertContains('class="longtext" title="Identifiant de la provenance">Identifiant de la provenance</div></td>', $crawler->html());

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_remove_file/fields/remove/' . $field . '/');

		$this->assertNotContains('class="longtext" title="Identifiant de la provenance">Identifiant de la provenance</div></td>', $crawler->html());
	}

	public function testDeleteSimpleFile() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/file_to_delete/delete/');

		$filter = 'html:contains("' . $this->translator->trans('file.delete.success', array(
			'%file.label%' => 'file_to_delete',
			'%datasetLabel%' => 'my_import_model'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testDeleteComplexFile() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/file_to_delete_complex/delete/');

		$filter = 'html:contains("' . $this->translator->trans('file.delete.success', array(
			'%file.label%' => 'file_to_delete',
			'%datasetLabel%' => 'my_import_model'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$fields = $this->em->getRepository('IgnOGAMConfigurateurBundle:FileField')->findFieldsByFileFormat('file_to_delete_complex');
		$this->assertEmpty($fields);
	}

	public function testAddDateMask() {
		$fields = "commentaire";

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/add/' . $fields . '/');
		$this->assertNotContains('value="yyyy-MM-dd"', $crawler->html());
		$this->assertContains('<p id="mask"></p>', $crawler->html());
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$fields = "datefin";
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/add/' . $fields . '/');
		$mask = "yyyy-MM-dd'T'HH:mmZ";
		$this->assertContains('value="' . $mask . '"', $crawler->html());
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$fields = "dateME";
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/add/' . $fields . '/');
		$this->assertContains('value="yyyy-MM-dd"', $crawler->html());
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}
	
	public function testAddLabelCSV() {
		$field = "altitudemax";
	
		$crawler = $this->client->request('GET', '/datasetsimport/3/files/file_auto_mapping/fields/add/' . $field . '/');
		$this->assertNotContains('value="altitudemax"', $crawler->html());
		$this->assertContains('<input id="labelCSV"', $crawler->html());
		$this->assertContains('value="altitudeMax"', $crawler->html());
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}
	
	public function testDeleteMappingsWhenDeletingFile() {
		$crawler = $this->client->request('GET', '/datasetsimport/3/files/file_auto_mapping/delete/');
	
		$filter = 'html:contains("' . $this->translator->trans('file.delete.success', array(
			'%file.label%' => 'file_auto_mapping',
			'%datasetLabel%' => 'dataset_import_to_edit'
		)) . '")';
	
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	
		$fields = $this->em->getRepository('IgnOGAMConfigurateurBundle:FileField')->findFieldsByFileFormat('file_auto_mapping');
		$this->assertEmpty($fields);
		
		// Extract direct info from DB (table field_mapping) :
		$query = $this->em->createQuery('SELECT
					fm.srcData as srcData, fm.dstData as dstData
					FROM IgnOGAMConfigurateurBundle:FieldMapping fm
					WHERE fm.mappingType = :mappingType
					AND fm.srcFormat = :fileFormat
					AND fm.dstFormat = :tableFormat')->setParameters(array(
								'fileFormat' => 'file_auto_mapping',
								'tableFormat' => 'table_auto_mapping',
								'mappingType' => 'FILE'
							));
		$mappings = $query->getResult();
		
		$altMinMapped = false;
		$cdnomMappedtoCdnom = false;
		$cdrefMappedtoCdref = false;
		
		foreach ($mappings as $mapping) {
			if ($mapping['srcData'] == 'altitudemin') {
				$altMinMapped = true;
			}
			if ($mapping['srcData'] == 'cdnom' && $mapping['dstData'] == 'cdnom') {
				$cdnomMappedtoCdnom = true;
			}
			if ($mapping['srcData'] == 'cdref' && $mapping['dstData'] == 'cdref') {
				$cdrefMappedtoCdref = true;
			}
		}
		
		$this->assertFalse($altMinMapped);
		$this->assertFalse($cdnomMappedtoCdnom);
		$this->assertFalse($cdrefMappedtoCdref);
	}
}
