<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Dataset;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

class DatasetImportControllerTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_dataset_import_controller.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		static::$kernel = static::createKernel(array(
			'environment' => 'test_ogam'
		));
		static::$kernel->boot();

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();
		$this->client = static::createClient(array(
			'environment' => 'test_ogam'
		));
		$this->client->followRedirects(true);

		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Dataset');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::newAction
	 */
	public function testNew() {
		$crawler = $this->client->request('GET', '/datasetsimport/new/');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_dataset_import]')->form();

		$form['ign_bundle_configurateurbundle_dataset_import[label]'] = "my new import model";
		$form['ign_bundle_configurateurbundle_dataset_import[definition]'] = "desc";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("my new import model")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::editAction
	 */
	public function testEdit() {
		$crawler = $this->client->request('GET', '/datasetsimport/import_model_to_edit/edit/');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_dataset_import]')->form();

		$datasetName = 'name edited dataset';
		$datasetTargetModel = '2';
		$form['ign_bundle_configurateurbundle_dataset_import[label]'] = 'name edited dataset';
		$form['ign_bundle_configurateurbundle_dataset_import[definition]'] = 'New description';
		$form['ign_bundle_configurateurbundle_dataset_import[model]'] = $datasetTargetModel;

		$crawler = $this->client->submit($form);

		$filter = 'html:contains("' . $this->translator->trans('importmodel.edit.title', array(
			'%labelDataset%' => $datasetName
		)) . '")';
		$filter2 = 'html:contains("' . $datasetTargetModel . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($crawler->filter($filter2)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * FIXME
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::editAction
	 */
	public function untestEditWithMappings() {
		$conn = $this->container->get('database_connection');
		$pgConn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$query = "SELECT count(*) FROM metadata_work.field_mapping AS m WHERE src_format IN ('file_mappings_1')";
		$result = pg_query($pgConn, $query) or die('Request failed: ' . pg_last_error());
		$nbMappings = pg_fetch_row($result)[0];
		$this->assertEquals(4, $nbMappings);

		$crawler = $this->client->request('GET', '/datasetsimport/mapping_1/edit');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_dataset_import]')->form();

		// Change the target data model
		$form['ign_bundle_configurateurbundle_dataset_import[model]'] = '11';

		$crawler = $this->client->submit($form);

		// Check that the confirmation message is given
		$filter = 'html:contains("' . $this->translator->trans('importmodel.edit.mappings_removed') . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		$result = pg_query($pgConn, $query) or die('Request failed: ' . pg_last_error());
		$nbMappings = pg_fetch_row($result)[0];
		$this->assertEquals(0, $nbMappings);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::editAction
	 */
	public function testEditWithoutMappings() {
		$crawler = $this->client->request('GET', '/datasetsimport/mapping_2/edit');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_dataset_import]')->form();

		// Change the target data model
		$form['ign_bundle_configurateurbundle_dataset_import[model]'] = '11';

		$crawler = $this->client->submit($form);

		// Check that the confirmation message is not given
		$filter = 'html:contains("' . $this->translator->trans('importmodel.edit.mappings_removed') . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 0);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * Case where an import model already exists with a certain name.
	 * Same name is used to edit another import model but with different casing.
	 * This should prompt an error message.
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::editAction
	 */
	public function testEditWithCaseControl() {
		$crawler = $this->client->request('GET', '/datasetsimport/import_model_to_edit/edit/');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_dataset_import]')->form();

		$form['ign_bundle_configurateurbundle_dataset_import[label]'] = 'import_model';

		$crawler = $this->client->submit($form);

		$filter = 'html:contains("' . $this->translator->trans('dataset.label.caseinsensitive', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::deleteAction
	 */
	public function testDelete() {
		$conn = $this->container->get('database_connection');
		$pgConn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$sql = "SELECT count(*) FROM metadata_work.dataset AS d WHERE d.dataset_id = 'import_model_to_delete'";
		$result = pg_query($pgConn, $sql) or die('Request failed: ' . pg_last_error());
		$nbDatasets = pg_fetch_row($result)[0];
		$this->assertEquals(1, $nbDatasets);

		$crawler = $this->client->request('GET', '/datasetsimport/import_model_to_delete/delete/');
		$result = pg_query($pgConn, $sql) or die('Request failed: ' . pg_last_error());
		$nbDatasets = pg_fetch_row($result)[0];
		$this->assertEquals(0, $nbDatasets);

		$filter = 'html:contains("' . $this->translator->trans('importmodel.delete.success', array(
			'%modelName%' => 'import_model_del'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * FIXME field_mapping issue to resolve.
	 * Test publication scenario, with application-created import model
	 * Checks :
	 * - try to publish an import model with no files fails
	 * - try to publish an import model with a file but no fields fails
	 * - try to publish an import model with a file, a field, but no mapping, fails
	 * - try to publish a complete import model, but unlinked to data model, fails
	 * - try to publish an import model with a file, a field, a mapping, and linked to a published data model, succeeds
	 *
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::publishAction
	 */
	public function untestPublishImportModelScenario() {
		// First, create and publish a new data model (see ModelControllerTest::testPublishModelScenario)

		// Create the model
		$crawler = $this->client->request('GET', '/models/new/');
		$form = $crawler->selectButton('Enregistrer')->form();
		$modelName = "My model to publish";
		$form['ign_bundle_configurateurbundle_model[name]'] = $modelName;
		$crawler = $this->client->submit($form);
		$model = $this->em->getRepository('IgnOGAMConfigurateurBundle:Model')->findOneByName($modelName);

		// Add a table to the model
		$crawler = $this->client->request('GET', '/models/' . $model->getId() . '/tables/new/');
		$form = $crawler->selectButton('Enregistrer')->form();
		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "table_for_model_to_publish";
		$crawler = $this->client->submit($form);
		$table = $model->getTables()->first();

		// Add fields to the table
		$crawler = $this->client->request('GET', '/models/' . $model->getId() . '/tables/' . $table->getFormat() . '/fields/add/jddid/');
		$crawler = $this->client->request('GET', '/models/' . $model->getId() . '/tables/' . $table->getFormat() . '/fields/add/geometrie/');

		// Publish the model
		$crawler = $this->client->request('GET', '/models/' . $model->getId() . '/publish/');

		// Create the import model
		$crawler = $this->client->request('GET', '/datasetsimport/new/');
		$form = $crawler->selectButton('Enregistrer')->form();

		$importModelName = "My Import model to publish";
		$form['ign_bundle_configurateurbundle_dataset_import[label]'] = $importModelName;
		$form['ign_bundle_configurateurbundle_dataset_import[definition]'] = "My import model description";
		$form['ign_bundle_configurateurbundle_dataset_import[model]'] = $model->getId();
		$crawler = $this->client->submit($form);
		$dataset = $this->repository->findOneByLabel($importModelName);

		// The model exists, is linked to a published data model, but contains no files :
		// --> it is not publishable yet
		// Try to publish, MUST fail.
		$crawler = $this->client->request('GET', '/datasetsimport/' . $dataset->getId() . '/publish/');
		$filter = 'html:contains("' . $this->translator->trans('importmodel.publish.fail', array(
			'%importModelName%' => $importModelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		// Add a file
		$crawler = $this->client->request('GET', '/datasetsimport/' . $dataset->getId() . '/files/new/');
		$form = $crawler->selectButton('Enregistrer')->form();
		$form['ign_bundle_configurateurbundle_file_format[label]'] = "file_for_import_model_to_publish";
		$form['ign_bundle_configurateurbundle_file_format[description]'] = 'description for file';
		$crawler = $this->client->submit($form);

		// The import model now contains a file, but it has no field : it is not publishable yet
		// Try to publish, must fail :
		$crawler = $this->client->request('GET', '/datasetsimport/' . $dataset->getId() . '/publish/');
		$filter = 'html:contains("' . $this->translator->trans('importmodel.publish.fail', array(
			'%importModelName%' => $importModelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		// Add a field to the file of the import model :
		$file = $dataset->getFiles()->first();
		$crawler = $this->client->request('GET', '/datasetsimport/' . $dataset->getId() . '/files/' . $file->getFormat() . '/fields/add/jddid/');
		// The import model now contains a file which has one field, but no mapping : it is not publishable yet
		// Try to publish, must fail :
		$crawler = $this->client->request('GET', '/datasetsimport/' . $dataset->getId() . '/publish/');
		$filter = 'html:contains("' . $this->translator->trans('importmodel.publish.fail', array(
			'%importModelName%' => $importModelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		// Add a mapping (directly in SQL because of the Ajax in the application...) :
		$conn = $this->container->get('database_connection');
		$pgConn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$sql = "INSERT INTO metadata_work.field_mapping (src_data, src_format, dst_data, dst_format, mapping_type)
				VALUES ('jddid', '" . $file->getFormat() . "', 'jddid', '" . $table->getFormat() . "', 'FILE');";
		pg_query($pgConn, $sql) or die('Request failed: ' . pg_last_error());

		// First unpublish the data model :
		$crawler = $this->client->request('GET', '/models/' . $model->getId() . '/unpublish');

		// The import model now contains a file which has one field and a mapping, but the related data model is unpublished : it is not publishable
		// Try to publish, must fail :
		$crawler = $this->client->request('GET', '/datasetsimport/' . $dataset->getId() . '/publish');
		$filter = 'html:contains("' . $this->translator->trans('importmodel.publish.fail', array(
			'%importModelName%' => $importModelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		// Then re-publish the data model :
		$crawler = $this->client->request('GET', '/models/' . $model->getId() . '/publish/');

		// The import model now contains a file which has one field and a mapping, and the related data model is published : it IS publishable
		// Try to publish, must succeed :
		$crawler = $this->client->request('GET', '/datasetsimport/' . $dataset->getId() . '/publish/');
		$filter = 'html:contains("' . $this->translator->trans('importmodel.publish.success', array(
			'%importModelName%' => $importModelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::publishAction
	 */
	public function testPublishFalseImportModel() {
		$crawler = $this->client->request('GET', '/datasetsimport/false_id/publish/');

		$filter = 'html:contains("' . $this->translator->trans('importmodel.publish.badid', array(
			'%importModelId%' => 'false_id'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::unpublishAction
	 */
	public function testUnpublishImportModel() {
		$crawler = $this->client->request('GET', '/datasetsimport/5/unpublish');
		$filter = 'html:contains("' . $this->translator->trans('importmodel.unpublish.success', array(
			'%importModelName%' => 'published_import_model'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertContains('id="publish-button-5"', $crawler->html());
		$this->assertNotContains('id="unpublish-button-5"', $crawler->html());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::unpublishAction
	 */
	public function testUnpublishFalseImportModel() {
		$crawler = $this->client->request('GET', '/datasetsimport/false_id/unpublish');

		$filter = 'html:contains("' . $this->translator->trans('importmodel.unpublish.badid', array(
			'%importModelId%' => 'false_id'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::viewAction
	 */
	public function testViewAction() {
		$crawler = $this->client->request('GET', '/datasetsimport/6/view');

		$filter1 = 'html:contains("import_model_view")';
		$filter2 = 'html:contains("model_view2")';
		$filter3 = 'html:contains("description view")';

		$this->assertTrue($crawler->filter($filter1)
			->count() > 0);
		$this->assertTrue($crawler->filter($filter2)
			->count() > 0);
		$this->assertTrue($crawler->filter($filter3)
			->count() > 0);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\DatasetImportController::updateFileOrderAction
	 */
	public function testUpdateFileOrderAction() {
		$crawler = $this->client->request('GET', '/datasetsimport/id_ordered_dataset/edit');

		// Order of files before changing order is the following : file_order_a : 1, file_order_b : 2, file_order_c : 3
		$formats = 'file_order_a,file_order_b,file_order_c';
		$orders = '2,3,1';
		$crawler = $this->client->request('GET', '/datasetsimport/id_ordered_dataset/edit/fields/update/' . $formats . '/' . $orders . '/');
		// Check that order has effectively changed
		$dataset = $this->em->getRepository('IgnOGAMConfigurateurBundle:Dataset')->find('id_ordered_dataset');
		foreach ($dataset->getFiles() as $file) {
			if ($file->getFormat() == 'file_order_a') {
				$this->assertEquals('2', $file->getPosition());
			} else if ($file->getFormat() == 'file_order_b') {
				$this->assertEquals('3', $file->getPosition());
			} else if ($file->getFormat() == 'file_order_c') {
				$this->assertEquals('1', $file->getPosition());
			}
		}

		$filter = 'html:contains("' . $this->translator->trans('importmodel.saveOrder.success') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}
}