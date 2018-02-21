<?php
namespace Ign\Bundle\OGAMBundle\Tests\Entity;

use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;

class SchemaTest extends KernelTestCase {

	/**
	 *
	 * @var \Doctrine\ORM\EntityManager
	 */
	private $em;

	/**
	 *
	 * {@inheritdoc}
	 *
	 */
	protected function setUp() {
		self::bootKernel();

		$this->em = static::$kernel->getContainer()
			->get('doctrine')
			->getManager();
	}

	/**
	 *
	 * {@inheritdoc}
	 *
	 */
	protected function tearDown() {
		parent::tearDown();

		if ($this->em) {
			$this->em->close();
		}
		$this->em = null; // avoid memory leaks
	}

	/**
	 * Test la récupération des schémas.
	 */
	public function testGetSchemas() {

		// Récupère la liste des schémas
		$schemas = $this->em->getRepository('Ign\Bundle\OGAMBundle\Entity\Metadata\TableSchema', 'metadata')->findAll();

		// On vérifie que l'on a ramené la bonne modalité
		$this->assertEquals(5, count($schemas));

		$rawSchema = $schemas['RAW_DATA'];
		$this->assertEquals('RAW_DATA', $rawSchema->getCode());
		$this->assertEquals('RAW_DATA', $rawSchema->getName());
		$this->assertEquals('Raw Data', $rawSchema->getLabel());
		$this->assertEquals('Contains raw data', $rawSchema->getDescription());
	}
}