<?php
namespace Ign\Bundle\ConfigurateurBundle\Tests\Entity;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Ign\Bundle\ConfigurateurBundle\Entity;
use Ign\Bundle\ConfigurateurBundle\Entity\Dataset;
use Ign\Bundle\ConfigurateurBundle\Entity\FileField;

class FileFieldRepositoryTest extends WebTestCase {

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
		$repository = $this->em->getRepository('IgnConfigurateurBundle:FileField');
		$fields = $repository->findAll();
		$this->assertTrue(count($fields) > 0);
	}

	/**
	 * TODO complete the test with assertions.
	 */
	public function testDeleteAllByFileFormat() {
		$repository = $this->em->getRepository('IgnConfigurateurBundle:FileField');
		$result = $repository->deleteAllByFileFormat('RAW_DATA_16_TABLE_1_DATA');
		//echo $result;
	}

	/**
	 * TODO complete the test with assertions.
	 */
	public function testFindFieldsByFileFormat() {
		$repository = $this->em->getRepository('IgnConfigurateurBundle:FileField');
		$result = $repository->findFieldsByFileFormat('_7895_DATA');
		//echo sizeof($result);
	}
}