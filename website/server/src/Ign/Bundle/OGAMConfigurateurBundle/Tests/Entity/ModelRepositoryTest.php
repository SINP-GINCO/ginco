<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

class ModelRepositoryTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_model_repository.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		$this->client = static::createClient(array('environment' => 'test_ogam'));

		$this->container = static::$kernel->getContainer();

		$this->em = $this->container->get('doctrine')->getManager();

		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Model');
	}

	public function testFindAllOrderedByName() {

		$orderedModels = $this->repository->findAllOrderedByName();
		$this->assertEquals($orderedModels[0]->getName(), "albatros");
		$this->assertEquals($orderedModels[1]->getName(), "brebis");
		$this->assertEquals($orderedModels[2]->getName(), "Corbeaux");
		$this->assertEquals($orderedModels[3]->getName(), "std_occ_taxon_dee_v1-2");
		$this->assertEquals($orderedModels[4]->getName(), "zebre");

	}
}