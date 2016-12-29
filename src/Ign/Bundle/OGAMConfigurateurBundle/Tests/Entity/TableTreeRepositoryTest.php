<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableTree;
use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

class TableTreeRepositoryTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_table_tree_repository.sql');
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
		
		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:TableTree');
	}

	public function testfindChildTablesByTableFormat() {

		$conn = $this->container->get('doctrine')->getConnection();
		$childTables = $this->repository->findChildTablesByTableFormat('table1', $conn);
		$this->assertEquals(count($childTables), 2);
		$childTables = $this->repository->findChildTablesByTableFormat('table2', $conn);
		$this->assertEquals(count($childTables), 1);
		$childTables = $this->repository->findChildTablesByTableFormat('table3', $conn);
		$this->assertEquals(count($childTables), 0);
	}	
}