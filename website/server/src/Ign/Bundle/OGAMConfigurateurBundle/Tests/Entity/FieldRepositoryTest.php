<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

class FieldRepositoryTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {}

	public function setUp() {
		// Entity Manager
		static::$kernel = static::createKernel(array('environment' => 'test_ogam'));
		static::$kernel->boot();
		$this->em = static::$kernel->getContainer()->get('doctrine.orm.entity_manager');
	}

	public function testFindAll() {
		$repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Field');
		$fields = $repository->findAll();
		$this->assertTrue(count($fields) > 0);
	}
}
