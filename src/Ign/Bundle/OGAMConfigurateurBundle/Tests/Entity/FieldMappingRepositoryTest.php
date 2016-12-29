<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Dataset;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\FileField;
use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

class FileFieldRepositoryTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_field_mapping_repository.sql');
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
		
		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:FieldMapping');
	}

	public function testFindMappings() {
		$mappings = $this->repository->findMappings('localisation_file', 'FILE');
		$this->assertEquals(count($mappings), 4);
	}
	
	public function testFindNotMappedFields() {
		$mappings = $this->repository->findNotMappedFields('localisation_file', 'FILE');
		$this->assertEquals(count($mappings), 0);
	}
	
	public function testRemoveAllByFileField() {
		$mappings = $this->repository->findMappings('file_removeAllByFileField', 'FILE');
		$this->assertEquals(count($mappings), 1);
		$this->repository->removeAllByFileField('file_removeAllByFileField', 'altitudemax');
		$mappings = $this->repository->findMappings('file_removeAllByFileField', 'FILE');
		$this->assertEquals(count($mappings), 0);
	}
	
	public function testRemoveAllByFileFormat() {
		$mappings = $this->repository->findMappings('file_removeAllByFileFormat', 'FILE');
		$this->assertEquals(count($mappings), 1);
		$this->repository->removeAllByFileFormat('file_removeAllByFileFormat');
		$mappings = $this->repository->findMappings('file_removeAllByFileFormat', 'FILE');
		$this->assertEquals(count($mappings), 0);
	}
	
	public function testRemoveAllByTableField() {
		$mappings = $this->repository->findMappings('file1', 'FILE');
		$this->assertEquals(count($mappings), 2);
		$this->repository->removeAllByTableField('table_removeAllByTableField', 'altitudemax');
		$mappings = $this->repository->findMappings('file1', 'FILE');
		$this->assertEquals(count($mappings), 1);
	}
	
	public function testRemoveAllByTableFormat() {
		$mappings = $this->repository->findMappings('file1', 'FILE');
		$this->assertEquals(count($mappings), 1);
		$this->repository->removeAllByTableFormat('table_removeAllByTableFormat');
		$mappings = $this->repository->findMappings('file1', 'FILE');
		$this->assertEquals(count($mappings), 0);
	}
}