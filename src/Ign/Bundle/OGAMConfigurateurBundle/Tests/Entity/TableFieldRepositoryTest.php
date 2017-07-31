<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class TableFieldRepositoryTest extends WebTestCase {

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
		$repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:TableField');
		$fields = $repository->findAll();
		$this->assertTrue(count($fields) > 0);
	}

	/**
	 * TODO complete the test with assertions.
	 */
	public function testDeleteAllByTableFormat() {
		$repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:TableField');
		$result = $repository->deleteAllByTableFormat('RAW_DATA_16_TABLE_1_DATA');
		// echo $result;
	}

	/**
	 * TODO complete the test with assertions.
	 */
	public function testDeleteNonTechnicalByTableFormat() {
		$repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:TableField');
		$result = $repository->deleteNonTechnicalByTableFormat('RAW_DATA_16_TABLE_1_DATA');
		$this->em->flush();

		// $tableFieldRepository = $this->em->getRepository('IgnOGAMConfigurateurBundle:TableField');
		// $tableFields = $tableFieldRepository->findFieldsByTableFormat(RAW_DATA_16_TABLE_1_DATA);
		// $numberOfFields = sizeof($tableFields);

		// $this->assertTrue($numberOfFields == 3);

		// echo $result;
	}

	/**
	 * TODO complete the test with assertions.
	 */
	public function testFindFieldsByTableFormat() {
		$repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:TableField');
		$result = $repository->findFieldsByTableFormat('_7895_DATA');
		// echo sizeof($result);
	}
}