<?php
namespace Ign\Bundle\OGAMBundle\Tests\Repository\Metadata;

use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Unit;

class UnitRepositoryTest extends KernelTestCase {

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
			->getManager('metadata');
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
	 * Test the unit's mode function with a MODE type
	 */
	public function unitModesFctsWithUnitCode($unitCode) {
		$repo = $this->em->getRepository('OGAMBundle:Metadata\Unit', 'metadata');
		$unit = $this->em->getReference(Unit::class, $unitCode);
		$locale = 'FR';
		
		// Check the getModes function
		$modes = $repo->getModes($unit, $locale);
		$this->assertEquals(3, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('Le code 1', $modes[0]->getDefinition()); // Check the locale
		                                                              
		// Check the getModesFilteredByCode function with a simple code
		$modes = $repo->getModesFilteredByCode($unit, '1', $locale);
		$this->assertEquals(1, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('1', $modes[0]->getCode()); // Check the code
		$this->assertEquals('Le code 1', $modes[0]->getDefinition()); // Check the locale
		                                                              
		// Check the getModesFilteredByCode function with an array of code
		$modes = $repo->getModesFilteredByCode($unit, [
			'1',
			'2'
		], $locale);
		$this->assertEquals(2, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('1', $modes[0]->getCode()); // Check the code
		$this->assertEquals('Le code 1', $modes[0]->getDefinition()); // Check the locale
		$this->assertEquals($unitCode, $modes[1]->getUnit()); // Check the unit
		$this->assertEquals('2', $modes[1]->getCode()); // Check the code
		$this->assertEquals('Le code 2', $modes[1]->getDefinition()); // Check the locale
		                                                              
		// Check the getModesFilteredByLabel function with a simple label
		$modes = $repo->getModesFilteredByLabel($unit, 'Code_1', $locale);
		$this->assertEquals(1, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('Code_1', $modes[0]->getLabel()); // Check the label
		$this->assertEquals('Le code 1', $modes[0]->getDefinition()); // Check the locale
		                                                              
		// Check the getModesLabelsFilteredByCode function with a simple code
		$modes = $repo->getModesLabelsFilteredByCode($unit, '1', $locale);
		$this->assertEquals(1, count($modes)); // Check the count
		$this->assertEquals('Code_1', $modes['1']); // Check the code and the label
		                                            
		// Check the getModesLabelsFilteredByCode function with an array of code
		$modes = $repo->getModesLabelsFilteredByCode($unit, [
			'1',
			'2'
		], $locale);
		$this->assertEquals(2, count($modes)); // Check the count
		$this->assertEquals('Code_1', $modes['1']); // Check the code and the label
		$this->assertEquals('Code_2', $modes['2']); // Check the code and the label
	}

	/**
	 * Test the unit's mode function with a MODE type
	 */
	public function testUnitModesFctsWithModeType() {
		$this->unitModesFctsWithUnitCode('CODE_CODE_3');
	}

	/**
	 * Test the unit's mode function with a DYNAMODE type
	 */
	public function testUnitModesFctsWithDynamodeType() {
		$this->unitModesFctsWithUnitCode('CODE_DYNAMIC_3');
	}

	/**
	 * Test the unit's mode function with a MODE_TREE type
	 */
	public function testUnitModesFctsWithModetreeType() {
		$repo = $this->em->getRepository('OGAMBundle:Metadata\Unit', 'metadata');
		$unitCode = 'CORINE_BIOTOPE';
		$unit = $this->em->getReference(Unit::class, $unitCode);
		$locale = 'FR';
		
		// Check the getModes function
		$modes = $repo->getModes($unit, $locale);
		$this->assertEquals(50, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('Habitats littoraux et halophiles', $modes[0]->getDefinition()); // Check the locale
		                                                                                     
		// Check the getModesFilteredByCode function with a simple code
		$modes = $repo->getModesFilteredByCode($unit, '11.1', $locale);
		$this->assertEquals(1, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('11.1', $modes[0]->getCode()); // Check the code
		$this->assertEquals('Eaux marines', $modes[0]->getDefinition()); // Check the locale
		                                                                 
		// Check the getModesFilteredByCode function with an array of code
		$modes = $repo->getModesFilteredByCode($unit, [
			'11.1',
			'11.11'
		], $locale);
		$this->assertEquals(2, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('11.1', $modes[0]->getCode()); // Check the code
		$this->assertEquals('Eaux marines', $modes[0]->getDefinition()); // Check the locale
		$this->assertEquals($unitCode, $modes[1]->getUnit()); // Check the unit
		$this->assertEquals('11.11', $modes[1]->getCode()); // Check the code
		$this->assertEquals('Eaux océaniques', $modes[1]->getDefinition()); // Check the locale
		                                                                    
		// Check the getModesFilteredByLabel function with a simple label
		$modes = $repo->getModesFilteredByLabel($unit, 'eaux', $locale);
		$this->assertEquals(16, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('Eaux marines', $modes[0]->getLabel()); // Check the label
		$this->assertEquals('Eaux marines', $modes[0]->getDefinition()); // Check the locale
		                                                                 
		// Check the getModesLabelsFilteredByCode function with a simple code
		$modes = $repo->getModesLabelsFilteredByCode($unit, '11.1', $locale);
		$this->assertEquals(1, count($modes)); // Check the count
		$this->assertEquals('Eaux marines', $modes['11.1']); // Check the code and the label
		                                                     
		// Check the getModesLabelsFilteredByCode function with an array of code
		$modes = $repo->getModesLabelsFilteredByCode($unit, [
			'11.1',
			'11.11'
		], $locale);
		$this->assertEquals(2, count($modes)); // Check the count
		$this->assertEquals('Eaux marines', $modes['11.1']); // Check the code and the label
		$this->assertEquals('Eaux océaniques', $modes['11.11']); // Check the code and the label
	}

	/**
	 * Test the unit's mode function with a MODE_TAXREF type
	 */
	public function testUnitModesFctsWithModetaxrefType() {
		$repo = $this->em->getRepository('OGAMBundle:Metadata\Unit', 'metadata');
		$unitCode = 'ID_TAXON';
		$unit = $this->em->getReference(Unit::class, $unitCode);
		$locale = 'FR';
		
		// Check the getModes function
		$modes = $repo->getModes($unit, $locale);
		$this->assertEquals(50, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('Acanthocephala', $modes[0]->getLabel()); // Check the locale
		                                                              
		// Check the getModesFilteredByCode function with a simple code
		$modes = $repo->getModesFilteredByCode($unit, '100', $locale);
		$this->assertEquals(1, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('100', $modes[0]->getCode()); // Check the code
		$this->assertEquals('Salamandra salamandra salamandra', $modes[0]->getLabel()); // Check the locale
		                                                                                
		// Check the getModesFilteredByCode function with an array of code
		$modes = $repo->getModesFilteredByCode($unit, [
			'100',
			'1000'
		], $locale);
		$this->assertEquals(2, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('100', $modes[0]->getCode()); // Check the code
		$this->assertEquals('Salamandra salamandra salamandra', $modes[0]->getLabel()); // Check the locale
		$this->assertEquals($unitCode, $modes[1]->getUnit()); // Check the unit
		$this->assertEquals('1000', $modes[1]->getCode()); // Check the code
		$this->assertEquals('Procellaria glacialis', $modes[1]->getLabel()); // Check the locale
		                                                                     
		// Check the getModesFilteredByLabel function with a simple label
		$modes = $repo->getModesFilteredByLabel($unit, 'salaman', $locale);
		$this->assertEquals(28, count($modes)); // Check the count
		$this->assertEquals($unitCode, $modes[0]->getUnit()); // Check the unit
		$this->assertEquals('Salamandra salamandra salamandra', $modes[0]->getLabel()); // Check the label and the locale
		                                                                                
		// Check the getModesLabelsFilteredByCode function with a simple code
		$modes = $repo->getModesLabelsFilteredByCode($unit, '100', $locale);
		$this->assertEquals(1, count($modes)); // Check the count
		$this->assertEquals('Salamandra salamandra salamandra', $modes['100']); // Check the code and the label
		                                                                        
		// Check the getModesLabelsFilteredByCode function with an array of code
		$modes = $repo->getModesLabelsFilteredByCode($unit, [
			'100',
			'1000'
		], $locale);
		$this->assertEquals(2, count($modes)); // Check the count
		$this->assertEquals('Salamandra salamandra salamandra', $modes['100']); // Check the code and the label
		$this->assertEquals('Procellaria glacialis', $modes['1000']); // Check the code and the label
	}
}