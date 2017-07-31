<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class FieldRepositoryTest extends WebTestCase {

	/**
	 *
	 * @var \Doctrine\ORM\EntityManager
	 */
	private $em;

	public function setUp() {
		// Entity Manager
		static::$kernel = static::createKernel();
		static::$kernel->boot();
		$this->em = static::$kernel->getContainer()->get('doctrine.orm.entity_manager');
	}

	public function testFindAll() {
		$repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Field');
		$fields = $repository->findAll();
		$this->assertTrue(count($fields) > 0);
	}
}
