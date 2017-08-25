<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController;
use Ign\Bundle\OGAMConfigurateurBundle\Entity;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ResetTomcatCaches;
use Symfony\Bundle\FrameworkBundle\Translation\Translator;
use Symfony\Component\DependencyInjection\Container;

/**
 * TODO correct issue on delete complex model
 *
 * @author Gautam Pastakia
 *
 *
 */
class ModelControllerTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_model_controller.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	/**
	 * Sets up the entity manager and the test client.
	 */
	public function setUp() {
		static::$kernel = static::createKernel(array('environment' => 'test_ogam'));
		static::$kernel->boot();

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();
		$this->client = static::createClient(array('environment' => 'test_ogam'));
		$this->client->followRedirects(true);

		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Model');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::newAction
	 */
	public function testNewWithCorrectName() {
		$crawler = $this->client->request('GET', '/models/new/');
		$form = $crawler->selectButton('Enregistrer')->form();

		$modelName = "My model";
		$form['ign_bundle_configurateurbundle_model[name]'] = $modelName;
		$form['ign_bundle_configurateurbundle_model[description]'] = "My model description";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $modelName . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$model = $this->repository->findOneByName('My model');
		$this->assertEquals('My model', $model->getName());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::newAction
	 */
	public function testNewWithoutNameNorDescription() {
		$crawler = $this->client->request('GET', '/models/new/');
		$form = $crawler->selectButton('Enregistrer')->form();

		$form['ign_bundle_configurateurbundle_model[name]'] = "";
		$form['ign_bundle_configurateurbundle_model[description]'] = "";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('model.name.notBlank', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::newAction
	 */
	public function testNewWithNameLongerThan128Characters() {
		$name = "my model name is too long my model name is too long my model name is too long my model name is too long my model name is too long.";

		$crawler = $this->client->request('GET', '/models/new/');
		$form = $crawler->selectButton('Enregistrer')->form();

		$form['ign_bundle_configurateurbundle_model[name]'] = $name;
		$form['ign_bundle_configurateurbundle_model[description]'] = "";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('model.name.maxLength', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::newAction
	 */
	public function testNewWithSpecialCharacters() {
		$modelName = "My model's name has special #?!__'#* characters";
		// Test creating with a name that contains special characters
		$crawler = $this->client->request('GET', '/models/new/');
		$form = $crawler->selectButton('Enregistrer')->form();

		$form['ign_bundle_configurateurbundle_model[name]'] = $modelName;
		$form['ign_bundle_configurateurbundle_model[description]'] = "";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $modelName . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
	}

	public function testEditWithSameValues() {
		$modelName = $this->repository->find('2')->getName();
		$crawler = $this->client->request('GET', '/models/2/edit');
		$form = $crawler->selectButton('Enregistrer')->form();

		$form['ign_bundle_configurateurbundle_model[name]'] = $modelName;
		$form['ign_bundle_configurateurbundle_model[description]'] = '';

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $modelName . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * FIXME This test checks if all mappings between files and tables are correctly
	 * removed on edit action.
	 * The model tested has 2 tables, each containing 3 fields.
	 * It has an import model which targets it, and which has 2 files containing
	 * for the first one 4 fields and the second one 2 fields.
	 * All the fields are mapped.
	 * There are 6 mappings in total before editing.
	 * Expected is that there are none left after editaction
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::editAction
	 */
	public function testEditWithMappings() {
		$conn = $this->container->get('database_connection');
		$pgConn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$query = "SELECT count(*) FROM metadata_work.field_mapping AS m WHERE src_format IN ('file_mappings_1', 'file_mappings_2')";
		$result = pg_query($pgConn, $query) or die('Request failed: ' . pg_last_error());
		$nbMappings = pg_fetch_row($result)[0];
		$this->assertEquals(6, $nbMappings);

		$this->client->request('GET', '/models/15/edit');

		$result = pg_query($pgConn, $query) or die('Request failed: ' . pg_last_error());
		$nbMappings = pg_fetch_row($result)[0];
		$this->assertEquals(0, $nbMappings);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::editAction
	 */
	public function testEditWithDifferentValues() {
		$crawler = $this->client->request('GET', '/models/2/edit');
		$form = $crawler->selectButton('Enregistrer')->form();

		$form['ign_bundle_configurateurbundle_model[name]'] = "model_edited";
		$form['ign_bundle_configurateurbundle_model[description]'] = '';

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("model_edited")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::editAction
	 */
	public function testEditWithDifferentCasing() {
		$modelName = $this->repository->find('2')->getName();
		$modelNameUpper = strtoupper($modelName);

		// Users edits the name of the model by upper casing the name : the form should be valid.
		$crawler = $this->client->request('GET', '/models/2/edit');
		$form = $crawler->selectButton('Enregistrer')->form();
		$form['ign_bundle_configurateurbundle_model[name]'] = $modelNameUpper;

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $modelNameUpper . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::editAction
	 */
	public function testEditToNameThatAlreadyExists() {
		// User tries to change the name to one that already exists
		$existingModelName = $this->repository->find('3')->getName();

		$crawler = $this->client->request('GET', '/models/2/edit');
		$form = $crawler->selectButton('Enregistrer')->form();
		$form['ign_bundle_configurateurbundle_model[name]'] = $existingModelName;
		$form['ign_bundle_configurateurbundle_model[description]'] = 'desc';

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('model.name.caseinsensitive', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::editAction
	 */
	public function testEditToNameThatAlreadyExistsButWithDifferentCasing() {
		$existingModelNameUpperCase = strtoupper($this->repository->find('3')->getName());
		// User wants to create a model with same name but different case : the form should be invalid.
		$crawler = $this->client->request('GET', '/models/new/');
		$form = $crawler->selectButton('Enregistrer')->form();

		$form['ign_bundle_configurateurbundle_model[name]'] = $existingModelNameUpperCase;
		$form['ign_bundle_configurateurbundle_model[description]'] = "";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('model.name.caseinsensitive', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * Deleting a model should also delete the associated import models.
	 *
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::deleteAction
	 */
	public function testDeleteSimpleModel() {
		$conn = $this->container->get('database_connection');
		$pgConn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		// Check that model is in the database
		$modelSql = "SELECT count(*) FROM metadata_work.model AS m WHERE m.id = '3'";
		$result = pg_query($pgConn, $modelSql) or die('Request failed: ' . pg_last_error());
		$nbModels = pg_fetch_row($result)[0];
		$this->assertEquals(1, $nbModels);

		// Check that the import model related to this model is in the database
		$datasetSql = "SELECT count(*) FROM metadata_work.dataset AS d WHERE d.dataset_id= 'to_delete'";
		$result = pg_query($pgConn, $datasetSql) or die('Request failed: ' . pg_last_error());
		$nbImportModels = pg_fetch_row($result)[0];
		$this->assertEquals(1, $nbImportModels);

		// Call the delete route
		$crawler = $this->client->request('GET', '/models/3/delete/');

		// Check that model is not in the database anymore
		$result = pg_query($pgConn, $modelSql) or die('Request failed: ' . pg_last_error());
		$nbModels = pg_fetch_row($result)[0];
		$this->assertEquals(0, $nbModels);

		// Check that the import model related to this model is not in the database anymore
		$result = pg_query($pgConn, $datasetSql) or die('Request failed: ' . pg_last_error());
		$nbImportModels = pg_fetch_row($result)[0];
		$this->assertEquals(0, $nbImportModels);

		$filter = 'html:contains("' . $this->translator->trans('datamodel.delete.success', array(
			'%modelName%' => 'model_to_delete_simple'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		$filter = 'html:contains("' . $this->translator->trans('importmodel.delete.success', array(
			'%modelName%' => 'my_dataset_to_delete'
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::deleteAction
	 */
	public function testDeleteComplexModel() {
		$conn = $this->container->get('database_connection');
		$pgConn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$queries = array(
			"SELECT count(*) FROM metadata_work.model AS m WHERE m.id = '4'",
			"SELECT count(*) FROM metadata_work.format AS f WHERE f.format = 'table_son'",
			"SELECT count(*) FROM metadata_work.table_tree AS tt WHERE tt.schema_code = 'RAW_DATA' AND tt.child_table = 'table_son'",
			"SELECT count(*) FROM metadata_work.table_format AS tf WHERE tf.format = 'table_son'",
			"SELECT count(*) FROM metadata_work.model_tables AS mt WHERE mt.model_id = '4' AND mt.table_id = 'table_son'"
		);

		foreach ($queries as $query) {
			$result = pg_query($pgConn, $query) or die('Request failed: ' . pg_last_error());
			$nbOcc = pg_fetch_row($result)[0];
			$this->assertEquals(1, $nbOcc);
		}

		$crawler = $this->client->request('GET', '/models/4/delete/');

		foreach ($queries as $query) {
			$result = pg_query($pgConn, $query) or die('Request failed: ' . pg_last_error());
			$nbOcc = pg_fetch_row($result)[0];
			$this->assertEquals(0, $nbOcc);
		}

		$filter = 'html:contains("' . $this->translator->trans('datamodel.delete.success', array(
			'%modelName%' => 'model_to_delete_complex'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::deleteAction
	 */
	public function testDeleteModelWhichHasSpecialCharacters() {
		$conn = $this->container->get('database_connection');
		$pgConn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$sql = "SELECT count(*) FROM metadata_work.model AS m WHERE m.id = '5'";
		$result = pg_query($pgConn, $sql) or die('Request failed: ' . pg_last_error());
		$nbModels = pg_fetch_row($result)[0];
		$this->assertEquals(1, $nbModels);

		$crawler = $this->client->request('GET', '/models/5/delete/');

		$result = pg_query($pgConn, $sql) or die('Request failed: ' . pg_last_error());
		$nbModels = pg_fetch_row($result)[0];
		$this->assertEquals(0, $nbModels);

		$filter = 'html:contains("' . $this->translator->trans('datamodel.delete.success', array(
			'%modelName%' => "model_that\%has'special_characters"
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::publishAction
	 */
	public function testPublishFalseModel() {
		$crawler = $this->client->request('GET', '/models/false_id/publish/');

		$filter = 'html:contains("' . $this->translator->trans('datamodel.publish.badid', array(
			'%modelId%' => 'false_id'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * Test publication scenario, with application-created model
	 * Checks :
	 * - try to publish a model with no tables fails
	 * - try to publish a model with a table but no fields fails
	 * - try to publish a model with table and fields succeeds
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::publishAction
	 * @requires PHP 5.5
	 */
	public function testPublishModelScenario() {

		// Creation of the model
		$crawler = $this->client->request('GET', '/models/new/');
		$form = $crawler->selectButton('Enregistrer')->form();

		$modelName = "My model to publish";
		$form['ign_bundle_configurateurbundle_model[name]'] = $modelName;
		$form['ign_bundle_configurateurbundle_model[description]'] = "My model description";

		$crawler = $this->client->submit($form);

		$model = $this->repository->findOneByName($modelName);
		// create mocked client for tomcat response = false
		$stub = $this->getMockBuilder(ResetTomcatCaches::class)
			->disableOriginalConstructor()
			->getMock();
		$stub->expects($this->exactly(1))
			->method('performRequest')
			->will($this->returnValue(false));

		$client = self::createClient(array('environment' => 'test_ogam'));
		$client->followRedirects(true);
		$client->getContainer()->set('app.resettomcatcaches', $stub);

		// Tomcat caches are not erased
		// Try to publish, must fail :
		$crawler = $client->request('GET', '/models/' . $model->getId() . '/publish/');
		$filter = 'html:contains("' . $this->translator->trans('datamodel.resetCaches.fail', array(
			'%modelName%' => $modelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		// create mocked client
		$stub = $this->getMockBuilder(ResetTomcatCaches::class)
			->disableOriginalConstructor()
			->getMock();
		$stub->expects($this->exactly(1))
			->method('performRequest')
			->will($this->returnValue(true));

		$client = self::createClient(array('environment' => 'test_ogam'));
		$client->followRedirects(true);
		$client->getContainer()->set('app.resettomcatcaches', $stub);

		// The model exists and contains no tables : it is not publishable yet
		// Try to publish, must fail :
		$crawler = $client->request('GET', '/models/' . $model->getId() . '/publish/');
		$filter = 'html:contains("' . $this->translator->trans('datamodel.publish.fail', array(
			'%modelName%' => $modelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		// Add a table
		$crawler = $this->client->request('GET', '/models/' . $model->getId() . '/tables/new/');
		$form = $crawler->selectButton('Enregistrer')->form();
		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "table_for_model_to_publish";
		$form['ign_bundle_configurateurbundle_table_format_edit[description]'] = 'description for table';
		$crawler = $this->client->submit($form);

		// Mocked service must be injected at each request.
		// It's because the client rebuilds kernel between each requests.
		$stub = $this->getMockBuilder(ResetTomcatCaches::class)
			->disableOriginalConstructor()
			->getMock();
		$stub->expects($this->exactly(1))
			->method('performRequest')
			->will($this->returnValue(true));
		$client = self::createClient(array('environment' => 'test_ogam'));
		$client->followRedirects(true);
		$client->getContainer()->set('app.resettomcatcaches', $stub);

		// The model now contains a table, but it has no field : it is not publishable yet
		// Try to publish, must fail :
		$crawler = $client->request('GET', '/models/' . $model->getId() . '/publish/');
		$filter = 'html:contains("' . $this->translator->trans('datamodel.publish.fail', array(
			'%modelName%' => $modelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		// Add a field to the table of the model :
		$table = $model->getTables()->first();
		$crawler = $this->client->request('GET', '/models/' . $model->getId() . '/tables/' . $table->getFormat() . '/fields/add/jddid/');

		// Inject mocked service
		$stub = $this->getMockBuilder(ResetTomcatCaches::class)
			->disableOriginalConstructor()
			->getMock();
		$stub->expects($this->exactly(1))
			->method('performRequest')
			->will($this->returnValue(true));
		$client = self::createClient(array('environment' => 'test_ogam'));
		$client->followRedirects(true);
		$client->getContainer()->set('app.resettomcatcaches', $stub);

		// The model now contains a table which has one field : it is not publishable yet
		// Try to publish, must fail :
		$crawler = $client->request('GET', '/models/' . $model->getId() . '/publish/');
		$filter = 'html:contains("' . $this->translator->trans('datamodel.publish.fail', array(
			'%modelName%' => $modelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		// Add a geometrical field to a table of the model :
		$table = $model->getTables()->first();
		$crawler = $this->client->request('GET', '/models/' . $model->getId() . '/tables/' . $table->getFormat() . '/fields/add/geometrie/');

		// Inject mocked service
		$stub = $this->getMockBuilder(ResetTomcatCaches::class)
			->disableOriginalConstructor()
			->getMock();
		$stub->expects($this->exactly(1))
			->method('performRequest')
			->will($this->returnValue(true));
		$client = self::createClient(array('environment' => 'test_ogam'));
		$client->followRedirects(true);
		$client->getContainer()->set('app.resettomcatcaches', $stub);

		// The model now contains a table which has a geometrical field : it IS publishable now
		// Try to publish, must success :
		$crawler = $client->request('GET', '/models/' . $model->getId() . '/publish/');
		$filter = 'html:contains("' . $this->translator->trans('datamodel.publish.success', array(
			'%modelName%' => $modelName
		)) . '")';
		$message = $this->translator->trans('datamodel.publish.success', array(
			'%modelName%' => $modelName
		));
		$this->assertContains($message, $crawler->text());

		$this->assertTrue($crawler->filter($filter)
		->count() == 1);
	}

	/**
	 * This case should show a warning modal.
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::editAction
	 */
	public function testEditPublishedModelWithoutData() {
		$crawler = $this->client->request('GET', '/models/');

		$link = $crawler->filter('#edit-button-7')->first();
		$crawler = $this->client->click($link->link());
		$filter = 'html:contains("' . $this->container->get('translator')->trans('datamodel.edit.warning', array(
			'%modelName%' => 'model_published_without_data'
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * This case should go straight to edit page.
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::editAction
	 */
	public function testEditUnpublishedModel() {
		$modelName = $this->repository->find('6')->getName();
		$crawler = $this->client->request('GET', '/models/');

		$linkOnModal = $crawler->filter('#modal-edit-files-6')
			->children()
			->filter('a')
			->first();
		$crawler = $this->client->click($linkOnModal->link());

		$filter = 'html:contains("' . $this->container->get('translator')->trans('datamodel.edit.title', array(
			'%name%' => $modelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * This case should prompt an information modal not allowing editing.
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::editAction
	 */
	public function testEditPublishedModelWithData() {
		$crawler = $this->client->request('GET', '/models/');
		$link = $crawler->filter('#edit-button-8')->first();

		$linkOnModal = $crawler->filter('#modal-confirm-edit-8')
			->children()
			->filter('a')
			->first();
		$crawler = $this->client->click($linkOnModal->link());

		$crawler = $this->client->click($link->link());
		$filter = 'html:contains("' . $this->container->get('translator')->trans('datamodel.edit.warning', array(
			'%modelName%' => 'model_published_with_data'
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	public function testIsDeleteButtonActiveForUnpublishedModel() {
		$crawler = $this->client->request('GET', '/models/');
		$class = $crawler->filter('#delete-button-6')
			->first()
			->attr('class');
		$this->assertNotContains('disabled', $class);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::unpublishAction
	 */
	public function testUnpublishModel() {
		$crawler = $this->client->request('GET', '/models/10/unpublish');
		$filter = 'html:contains("' . $this->translator->trans('datamodel.unpublish.success', array(
			'%modelName%' => 'model_to_unpublish'
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertContains('id="publish-button-10"', $crawler->html());
		$this->assertNotContains('id="unpublish-button-10"', $crawler->html());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::unpublishAction
	 */
	public function testUnpublishModelWithoutFileUploadRunning() {
		$crawler = $this->client->request('GET', '/models/11/unpublish');
		$filter = 'html:contains("' . $this->translator->trans('datamodel.unpublish.success', array(
			'%modelName%' => 'model_to_unpublish_0_running'
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertContains('id="publish-button-11"', $crawler->html());
		$this->assertNotContains('id="unpublish-button-11"', $crawler->html());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::unpublishAction
	 */
	public function testUnpublishModelWithOneOfManyFileUploadRunning() {
		$crawler = $this->client->request('GET', '/models/12/unpublish');
		$filter = 'html:contains("' . $this->translator->trans('importmodel.unpublish.uploadrunning', array(
			'%modelName%' => 'model_to_unpublish_1_running'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		$this->assertNotContains('id="publish-button-12"', $crawler->html());
		$this->assertContains('id="unpublish-button-12"', $crawler->html());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::unpublishAction
	 */
	public function testUnpublishModelWithAllFileUploadRunning() {
		$crawler = $this->client->request('GET', '/models/13/unpublish');
		$filter = 'html:contains("' . $this->translator->trans('importmodel.unpublish.uploadrunning', array(
			'%modelName%' => 'model_to_unpublish_all_running'
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertNotContains('id="publish-button-13"', $crawler->html());
		$this->assertContains('id="unpublish-button-13"', $crawler->html());
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::unpublishAction
	 */
	public function testUnpublishFalseModel() {
		$crawler = $this->client->request('GET', '/models/false_id/unpublish');

		$filter = 'html:contains("' . $this->translator->trans('datamodel.unpublish.badid', array(
			'%modelId%' => 'false_id'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * FIXME error update or delete on table "field" violates foreign key constraint "fk_field_mapping_field_dst"
	 *  on table "field_mapping" --> Related to field_mapping, will be redone.
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::unpublishAction
	 */
	public function untestUnpublishDEEModel() {
		$crawler = $this->client->request('GET', '/models/1/unpublish');
		$filter = 'html:contains("' . $this->translator->trans('datamodel.unpublish.success', array(
			'%modelName%' => 'std_occ_taxon_dee_v1-2'
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::viewAction
	 */
	public function testViewAction() {
		$model = $this->repository->find('14');
		$crawler = $this->client->request('GET', '/models/14/view');

		$filter1 = 'html:contains("' . $model->getName() . '")';
		$filter2 = 'html:contains("' . $model->getDescription() . '")';

		$this->assertTrue($crawler->filter($filter1)
			->count() > 0);
		$this->assertTrue($crawler->filter($filter2)
			->count() > 0);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::duplicateAction
	 */
	public function testDuplicateAction() {
		$model = $this->repository->find('7');
		$crawler = $this->client->request('GET', '/models/14/duplicate');

		$form = $crawler->selectButton('Enregistrer')->form();

		$modelName = "My copied model";
		$form['ign_bundle_configurateurbundle_model[name]'] = $modelName;
		$form['ign_bundle_configurateurbundle_model[description]'] = "My model description";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $modelName . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		// $this->assertTrue($this->client->getResponse()
		// ->isSuccessful());

		$model = $this->repository->findOneByName('My copied model');
		$this->assertEquals('My copied model', $model->getName());
	}
}
