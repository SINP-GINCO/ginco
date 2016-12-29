<?php
namespace Ign\Bundle\ConfigurateurBundle\Tests\Controller;

use Ign\Bundle\ConfigurateurBundle\Entity;
use Ign\Bundle\ConfigurateurBundle\Tests\ConfiguratorTest;

class DatasetRepositoryTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_dataset_repository.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		$this->client = static::createClient();

		$this->container = static::$kernel->getContainer();
		$this->em = $this->container->get('doctrine')->getManager();
		$this->repository = $this->em->getRepository('IgnConfigurateurBundle:Dataset');
	}

	public function testFindByTypeAndOrderedByName() {
		$orderedDatasets = $this->repository->findByTypeAndOrderedByName("IMPORT");

		$this->assertEquals(count($orderedDatasets), 5);
		$this->assertEquals($orderedDatasets[0]->getLabel(), "import_1");
		$this->assertEquals($orderedDatasets[1]->getLabel(), "import_152_a");
		$this->assertEquals($orderedDatasets[2]->getLabel(), "import_2");
		$this->assertEquals($orderedDatasets[3]->getLabel(), "import_ok");
		$this->assertEquals($orderedDatasets[4]->getLabel(), "std_occ_taxon_dee_v1-2");
	}
}