<?php
namespace Ign\Bundle\ConfigurateurBundle\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Ign\Bundle\ConfigurateurBundle\Entity;
use Ign\Bundle\ConfigurateurBundle\Entity\TableFormat;
use Ign\Bundle\ConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\ConfigurateurBundle\Entity\Model;

class TableControllerTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_table_controller.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();
		$this->client = static::createClient();
		$this->client->followRedirects(true);

		$this->repository = $this->em->getRepository('IgnConfigurateurBundle:TableFormat');
	}

	public function testNewWithCorrectName() {
		$modelName = $this->em->getRepository('IgnConfigurateurBundle:Model')
			->find('2')
			->getName();
		$crawler = $this->client->request('GET', '/models/2/tables/new/');

		$form = $crawler->selectButton('Enregistrer')->form();
		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "my_new_table";
		$form['ign_bundle_configurateurbundle_table_format_edit[description]'] = 'description for table';

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('table.edit.def.title', array(
			'%table.label%' => 'my_new_table',
			'%model.name%' => $modelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		// Check correct naming of table
		$this->assertEquals("my_new_table", $this->repository->findOneByTableName('2_my_new_table')
			->getLabel());

		// Check technical fields auto creation
		$table = $this->repository->findOneByLabel("my_new_table");

		$tableFormat = $table->getFormat();

		$tableFieldRepository = $this->em->getRepository('IgnConfigurateurBundle:TableField');
		$tableFields = $tableFieldRepository->findFieldsByTableFormat($tableFormat);
		$numberOfFields = sizeof($tableFields);

		$this->assertTrue($numberOfFields == 3);

		// Check that one of these fields if 'OGAM_ID_<table_format>'
		$datas = array_column($tableFields, 'fieldName');
		$this->assertTrue(in_array('OGAM_ID_' . $tableFormat, $datas));

		// Check that this data exists in Data table
		$ogamId = $this->em->getRepository('IgnConfigurateurBundle:Data')->find('OGAM_ID_' . $tableFormat);
		$this->assertFalse($ogamId == null);
	}

	public function testEditWithDifferentValues() {
		$crawler = $this->client->request('GET', '/models/3/tables/table/edit/');
		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "my_edited_table";
		$form['ign_bundle_configurateurbundle_table_format_edit[description]'] = 'description for table';

		$crawler = $this->client->submit($form);

		$filter = 'html:contains("my_edited_table")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testEditToTableNameAlreadyExistingInSameModel() {
		$modelName = $this->em->getRepository('IgnConfigurateurBundle:Model')
			->find('3')
			->getName();
		$crawler = $this->client->request('GET', '/models/3/tables/table/edit/');
		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		// Table_bis is the name of the other table of the model
		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "table_bis";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('table.name.exists', array(
			'%modelName%' => $modelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * This case should show a warning message concerning table already existing.
	 * And it should not show a warning message concerning missing description.
	 */
	public function testNewTableWhichAlreadyExistsInSameModel() {
		$modelName = $this->em->getRepository('IgnConfigurateurBundle:Model')
			->find('3')
			->getName();
		$crawler = $this->client->request('GET', '/models/3/tables/new/');
		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		// Table_bis is the name of the other table of the model
		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "table_bis";
		$form['ign_bundle_configurateurbundle_table_format_edit[description]'] = "description";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('table.name.exists', array(
			'%modelName%' => $modelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$filter = 'html:contains("' . $this->translator->trans('table.description.notBlank', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * This case should show a warning message concerning table already existing.
	 * It should also show a warning message concerning missing description.
	 */
	public function testNewTableWhichAlreadyExistsInSameModelAndWithoutDescription() {
		$modelName = $this->em->getRepository('IgnConfigurateurBundle:Model')
			->find('3')
			->getName();
		$crawler = $this->client->request('GET', '/models/3/tables/new/');
		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		// Table_bis is the name of the other table of the model
		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "table_bis";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('table.name.exists', array(
			'%modelName%' => $modelName
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testNewTableWhichAlreadyExistsInAnotherModel() {
		$model = $this->em->getRepository('IgnConfigurateurBundle:Model')->find('2');

		$crawler = $this->client->request('GET', '/models/2/tables/new/');
		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		// Table is the name of a table in another model
		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = 'table';
		$form['ign_bundle_configurateurbundle_table_format_edit[description]'] = 'description';

		$crawler = $this->client->submit($form);

		$filter = 'html:contains("' . $this->translator->trans('table.name.exists', array(
			'%modelName%' => $model->getName()
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 0);

		$filter = 'html:contains("' . $this->translator->trans('table.edit.def.title', array(
			'%table.label%' => 'table',
			'%model.name%' => $model->getName()
		)) . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testNewWithoutDescription(){
		$crawler = $this->client->request('GET', '/models/2/tables/new/');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = 'table_without_desc';

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('tableFormat.description.notBlank', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 0);
	}

	/**
	 * Only characters authorized are lowercase letters, underscore and numbers.
	 */
	public function testNewWithSpecialCharacters(){
		$crawler = $this->client->request('GET', '/models/2/tables/new/');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "Table_'8%";
		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('tableFormat.label.regex', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "Table_8";
		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('tableFormat.label.regex', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = "table_8";
		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('tableFormat.label.regex', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 0);
	}

	public function testNewWithNameAndDescriptionLongerThanMaxLength(){
		$crawler = $this->client->request('GET', '/models/3/tables/new/');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		$tableLabel = "my_table_my_table_my_table_my_table_my_table_my_table_my_table_my_table_my_table_my_table_my_table";
		$tableLabel .= "_my_tablemy_table_my_table_my_table_my_table_my_table_my_table_my_tablemy_table_my_table_my_table";
		$tableLabel .= "_my_table_my_table_my_table_my_table_my_table_my_tablemy_table_my_table_my_table_my_table_my_table";

		// name is longer than 36 characters
		$form['ign_bundle_configurateurbundle_table_format_edit[label]'] = $tableLabel;
		// description is longer than 255 characters
		$form['ign_bundle_configurateurbundle_table_format_edit[description]'] = $tableLabel;

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('tableFormat.label.maxLength', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$filter = 'html:contains("' . $this->translator->trans('tableFormat.description.maxLength', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}


	public function testNewChildTable()
	{
		$modelName = $this->em->getRepository('IgnConfigurateurBundle:Model')
			->find('2')
			->getName();
		$crawler = $this->client->request('GET', '/models/2/tables/child_table/edit/');
		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_table_format_edit]')->form();

		$parentFormat = $this->repository->findOneByLabel('my_new_table')->getFormat();
		$form['ign_bundle_configurateurbundle_table_format_edit[parent]'] = $parentFormat;

		$crawler = $this->client->submit($form);

		// Check primary key of the parent table is now in table fields
		$tableFieldRepository = $this->em->getRepository('IgnConfigurateurBundle:TableField');
		$tableFields = $tableFieldRepository->findFieldsByTableFormat('child_table');
		$datas = array_column($tableFields, 'fieldName');
		$this->assertTrue(in_array('OGAM_ID_' . $parentFormat, $datas));

		// Check tables relation is put in table_tree with correct join_key
		$tableTrees = $this->em->getRepository('IgnConfigurateurBundle:TableTree')->findBy(array(
			"childTable" => 'child_table',
			"parentTable" => $parentFormat
		));
		$this->assertTrue(count($tableTrees) > 0);
		$tableTree = current($tableTrees);
		$keys = explode(',', $tableTree->getJoinKey());
		$this->assertTrue(in_array('OGAM_ID_' . $parentFormat, $keys));
	}


	public function testDeleteSimpleTable(){
		$conn = $this->container->get('database_connection');
		$pgConn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$sql = "SELECT count(*) FROM metadata_work.table_format AS tf WHERE tf.format = 'table_to_delete'";
		$result = pg_query($pgConn, $sql) or die('Request failed: ' . pg_last_error());
		$nbOcc = pg_fetch_row($result)[0];
		$this->assertEquals(1, $nbOcc);

		// Test before calling that the primary key data field exists in Data table
		$sql = "SELECT count(*) FROM metadata_work.data WHERE data = 'OGAM_ID_table_to_delete'";
		$result = pg_query($pgConn, $sql) or die('Request failed: ' . pg_last_error());
		$nbOcc = pg_fetch_row($result)[0];
		$this->assertEquals(1, $nbOcc);

		$crawler = $this->client->request('GET', '/models/3/tables/table_to_delete/delete/');

		$result = pg_query($pgConn, $sql) or die('Request failed: ' . pg_last_error());
		$nbOcc = pg_fetch_row($result)[0];
		$this->assertEquals(0, $nbOcc);

		$filter = 'html:contains("' . $this->translator->trans('table.delete.success', array(
			'%tableName%' => 'table'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		// Test adter calling that the primary key data field no more exists in Data table
		$sql = "SELECT count(*) FROM metadata_work.data WHERE data = 'OGAM_ID_table_to_delete'";
		$result = pg_query($pgConn, $sql) or die('Request failed: ' . pg_last_error());
		$nbOcc = pg_fetch_row($result)[0];
		$this->assertEquals(0, $nbOcc);
	}

	/**
	 * The cells in the dictionary table have both the name and the type.
	 * The cells in the table only have name.
	 * So before requesting, the jddid cell should not be present.
	 * After requesting, the jddid cell should therefore be present.
	 */
	public function testAddFields() {
		$fields = "jddid, jddcode";

		$crawler = $this->client->request('GET', '/models/3/tables/table/fields/');

		$this->assertContains('<td>Identifiant de la provenance [STRING]</td>', $crawler->html());
		$this->assertContains('<td id="name" class="hidden">jddid [STRING]</td>', $crawler->html());
		$this->assertNotContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());

		$crawler = $this->client->request('GET', '/models/3/tables/table/fields/add/' . $fields . '/');

		$this->assertContains('<td>Identifiant de la provenance [STRING]</td>', $crawler->html());
		$this->assertContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());
	}

	public function testRemoveAllFields() {
		$crawler = $this->client->request('GET', '/models/3/tables/table_with_fields/fields/');

		$this->assertContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());
		$this->assertContains('<td id="label">Code identifiant la provenance</td>', $crawler->html());

		$crawler = $this->client->request('GET', '/models/3/tables/table/fields/removeAll/');

		$this->assertNotContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());
		$this->assertNotContains('<td id="label">Code identifiant la provenance</td>', $crawler->html());
	}

	public function testRemoveFieldAction() {
		$field = "jddid";

		$crawler = $this->client->request('GET', '/models/3/tables/table_with_field/fields/');

		$this->assertContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());

		$crawler = $this->client->request('GET', '/models/3/tables/table_with_field/fields/remove/' . $field . '/');

		$this->assertNotContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Controller\TableController::viewAction
	 */
	public function testViewWithParent() {
		$crawler = $this->client->request('GET', '/models/4/tables/table_view2/view/');

		$filter1 = 'html:contains("table_view1")';
		$filter2 = 'html:contains("table_view2")';

		$this->assertTrue($crawler->filter($filter1)
			->count() > 0);
		$this->assertTrue($crawler->filter($filter2)
			->count() > 0);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Controller\TableController::viewAction
	 */
	public function testViewWithField() {
		$crawler = $this->client->request('GET', '/models/4/tables/table_view1/view/');

		$filter1 = 'html:contains("table_view1")';
		$filter2 = 'html:contains("' . $this->translator->trans('table.view.noParent') . '")';
		$filter3 = 'html:contains("Code identifiant la provenance")';

		$this->assertTrue($crawler->filter($filter1)
			->count() > 0);
		$this->assertTrue($crawler->filter($filter2)
			->count() > 0);
		$this->assertTrue($crawler->filter($filter3)
			->count() > 0);
	}
}

