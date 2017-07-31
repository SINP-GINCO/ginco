<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelPublication;

/**
 * Test class for model publication service (see Story #148).
 * Note : this class test needs metadata and metadata_work schemas
 * initialized in order to work.
 *
 * @author Gautam Pastakia
 *
 */
class ModelPublicationTest extends ConfiguratorTest {

	/**
	 *
	 * @var ModelPublication
	 */
	public $mp;

	/**
	 *
	 * @var string the id of the model to test
	 */
	public $modelId = '2';

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_publication_service.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$container = static::$kernel->getContainer();

		$conn = $container->get('database_connection');
		$logger = $container->get('logger');

		$adminName = $container->getParameter('database_admin_user');
		$adminPassword = $container->getParameter('database_admin_password');

		$this->mp = new ModelPublication($conn, $logger, $adminName, $adminPassword);
		$this->mp->setCopyUtils(new CopyUtils($conn, $logger, $adminName, $adminPassword));
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelPublication::publishModel
	 */
	public function testPublish() {
		// Try to publish a model that does not exist
		$success = $this->mp->publishModel('my_false_id');
		$this->assertFalse($success);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelPublication::isPublished
	 */
	public function testIsPublished() {
		$published = $this->mp->isPublished('1');
		$this->assertTrue($published);

		$published = $this->mp->isPublished('2');
		$this->assertFalse($published);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelPublication::isPublishable
	 */
	public function testIsPublishable() {
		$test = $this->mp->isPublishable(2);
		$this->assertTrue($test);
		$test = $this->mp->isPublishable(5);
		$this->assertFalse($test);
		$test = $this->mp->isPublishable(4);
		$this->assertFalse($test);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelPublication::modelHasTables
	 */
	public function testModelHasTables() {
		$test = $this->mp->modelHasTables(5);
		$this->assertTrue($test);
		$test = $this->mp->modelHasTables(4);
		$this->assertFalse($test);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelPublication::modelTablesHaveFields
	 */
	public function testModelTablesHaveFields() {
		$test = $this->mp->modelTablesHaveFields(5);
		$this->assertFalse($test);
		$test = $this->mp->modelTablesHaveFields(2);
		$this->assertTrue($test);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelPublication::modelHasGeometricalField
	 */
	public function testModelHasGeometricalField() {
		$test = $this->mp->modelHasGeometricalField(5);
		$this->assertFalse($test);
		$test = $this->mp->modelHasGeometricalField(2);
		$this->assertTrue($test);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelPublication::getUnpublishedImportModelsNames
	 */
	public function testGetUnpublishedImportModelsNames() {
		$names = $this->mp->getUnpublishedImportModelsNames('6');
		$this->assertEquals(2, count($names));
		$names = $this->mp->getUnpublishedImportModelsNames('7');
		$this->assertEquals(0, count($names));
	}
}