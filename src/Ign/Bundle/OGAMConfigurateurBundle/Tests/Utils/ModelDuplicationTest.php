<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelDuplication;

/**
 * Test class for model duplication service (see Story #36).
 * Note : this class test needs metadata_work schema
 * initialized in order to work.
 *
 * @author Gautam Pastakia
 *
 */
class ModelDuplicationTest extends ConfiguratorTest {

	/**
	 *
	 * @var ModelDuplication
	 */
	public $md;

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_duplication_service.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$this->container = static::$kernel->getContainer();

		$conn = $this->container->get('database_connection');
		$logger = $this->container->get('logger');

		$adminName = $this->container->getParameter('database_admin_user');
		$adminPassword = $this->container->getParameter('database_admin_password');

		$this->md = new ModelDuplication($conn, $logger, $adminName, $adminPassword);
		$this->em = $this->container->get('doctrine')->getManager();
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelDuplication::duplicateModel
	 */
	public function testDuplicateModel() {
		$md = $this->md;
		// Test with a bad id
		$repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Model');

		$modelWithBadId = $repository->find('5');
		$modelWithBadId->addId('badId');

		$duplicateStatus = $md->duplicateModel($modelWithBadId, 'my_copied_model');
		$this->assertEquals('datamodel.duplicate.badid', $duplicateStatus);

		// Test with a model already copied
		$modelAlreadyCopied = $repository->find('2');

		$duplicateStatus = $md->duplicateModel($modelAlreadyCopied, 'my_copied_model');
		$this->assertEquals('datamodel.duplicate.hasCopy', $duplicateStatus);

		// Test with a model to be copied
		$modelToCopy = $repository->find('4');

		$duplicateStatus = $md->duplicateModel($modelToCopy, 'my_copied_model');
		$this->assertEquals('datamodel.duplicate.success', $duplicateStatus);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelDuplication::updatePrimaryKeys
	 */
	public function testUpdatePrimaryKeys() {
		$repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Model');
		$model = $repository->find('6');

		$sql = "SELECT format from metadata_work.format WHERE format = ? ";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'format_2_copy');
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) === 'format_2_copy');

		// Check that keys all finish with '_copy' before calling method
		$sql = "SELECT format from metadata_work.table_format WHERE format like '%copy' ";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertEquals('format_2_copy', $stmt->fetchColumn(0));
		$sql = "SELECT format from metadata_work.field WHERE format like '%copy' ";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertEquals('format_2_copy', $stmt->fetchColumn(0));
		$sql = "SELECT schema_code from metadata_work.table_tree WHERE parent_table like '%copy' OR child_table like '%copy'";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertEquals('RAW_DATA', $stmt->fetchColumn(0));
		$sql = "SELECT format from metadata_work.table_field WHERE format like '%copy' ";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertEquals('format_2_copy', $stmt->fetchColumn(0));
		$sql = "SELECT table_id from metadata_work.model_tables WHERE table_id like '%copy' ";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertEquals('format_2_copy', $stmt->fetchColumn(0));

		// Call method
		$this->md->updatePrimaryKeys($model, '6');

		// Check that keys have been changed --> No more keys finishing with '_copy'
		$sql = "SELECT format from metadata_work.table_format WHERE format like '%copy' ";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertFalse($stmt->fetchColumn(0));
		$sql = "SELECT format from metadata_work.field WHERE format like '%copy' ";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertFalse($stmt->fetchColumn(0));
		$sql = "SELECT schema_code from metadata_work.table_tree WHERE parent_table like '%copy' OR child_table like '%copy'";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertFalse($stmt->fetchColumn(0));
		$sql = "SELECT format from metadata_work.table_field WHERE format like '%copy' ";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertFalse($stmt->fetchColumn(0));
		$sql = "SELECT table_id from metadata_work.model_tables WHERE table_id like '%copy' ";
		$stmt = $this->md->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertFalse($stmt->fetchColumn(0));
	}
}