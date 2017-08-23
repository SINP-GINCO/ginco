<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\Data;
use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

class DataControllerTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_data_controller.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	/**
	 * Sets up the entity manager and the test client.
	 */
	public function setUp() {
		$this->client = static::createClient(array(
			'environment' => 'test_ogam'
		));
		$this->client->followRedirects(true);

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();

		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Data');
	}

	/**
	 * Tests if a editable data (non related to a table) is listed in the first part of the list.
	 * And if edit and delete buttons exist
	 */
	public function testListForEditableData() {
		$crawler = $this->client->request('GET', '/data');
		$dataName = 'unrelated_data_field';

		// Select table after first title
		$table = $crawler->filterXPath('//*[text() = "' . $this->translator->trans('data.list.title.1') . '"]/following-sibling::table');
		// $html = $table->html();

		// Finds td with name of the data field
		$this->assertTrue($table->filterXPath('//td[text()="' . $dataName . '"]')
			->count() > 0);

		// Finds buttons and checks they are enabled
		$buttonEdit = $table->filterXPath('//tr[td[text()="' . $dataName . '"]]//a[contains(@class,"edit-button")]');
		$this->assertTrue($buttonEdit->count() == 1);

		$buttonDelete = $table->filterXPath('//tr[td[text()="' . $dataName . '"]]//a[contains(@class,"delete-button")]');
		$this->assertTrue($buttonDelete->count() == 1);
	}

	/**
	 * Tests if a non editable data (related to a table) is listed in the second part of the list.
	 * And if there is no edit and delete buttons
	 */
	public function testListForUneditableData() {
		$crawler = $this->client->request('GET', '/data');
		$dataName = 'related_data_field';

		// Select table after first title
		$table = $crawler->filterXPath('//*[text() = "' . $this->translator->trans('data.list.title.2') . '"]/following-sibling::table');

		// Finds td with name of the data field
		$this->assertTrue($table->filterXPath('//td[text()="' . $dataName . '"]')
			->count() > 0);

		// Finds buttons and checks they are NOT enabled
		$buttonEdit = $table->filterXPath('//tr[td[text()="' . $dataName . '"]]//a[contains(@class,"edit-button")]');
		$this->assertTrue($buttonEdit->count() == 0);

		$buttonDelete = $table->filterXPath('//tr[td[text()="' . $dataName . '"]]//a[contains(@class,"delete-button")]');
		$this->assertTrue($buttonDelete->count() == 0);
	}

	/**
	 * Tests new Data insertion with not already used name,
	 * non empty name and unit
	 */
	public function testNewWithNewName() {
		$crawler = $this->client->request('GET', '/data/new');

		$this->assertContains($this->translator->trans('data.label.tooltip'), $crawler->html());
		$this->assertContains($this->translator->trans('data.name.tooltip'), $crawler->html());

		$form = $crawler->selectButton('Ajouter')->form();

		$form['ign_bundle_configurateurbundle_data[name]'] = "data_test";
		// Selects the second option (first is empty)
		$unit = $crawler->filter('#ign_bundle_configurateurbundle_data_unit > option')
			->eq(1)
			->attr('value');
		$form['ign_bundle_configurateurbundle_data[unit]'] = $unit;
		$form['ign_bundle_configurateurbundle_data[label]'] = "Test label";
		$form['ign_bundle_configurateurbundle_data[definition]'] = "Test definition";
		$form['ign_bundle_configurateurbundle_data[comment]'] = "Test comment";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("data_test")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$data = $this->repository->findOneByName('data_test');
		$this->assertEquals('data_test', $data->getName());
		$this->assertEquals($data->getUnit()
			->getName(), $unit);
		$this->assertEquals($data->getLabel(), 'Test label');
		$this->assertEquals($data->getDefinition(), 'Test definition');
		$this->assertEquals($data->getComment(), 'Test comment');
	}

	/**
	 * Tests new Data insertion with special character
	 */
	public function testWithSpecialCharacterInName() {
		$crawler = $this->client->request('GET', '/data/new');
		$form = $crawler->selectButton('Ajouter')->form();

		// no number first
		$form['ign_bundle_configurateurbundle_data[name]'] = "2DATA_TEST";
		$unit = $crawler->filter('#ign_bundle_configurateurbundle_data_unit > option')
			->eq(1)
			->attr('value');
		$form['ign_bundle_configurateurbundle_data[unit]'] = $unit;

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('data.name.regex', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		// no special caracter except _
		$form['ign_bundle_configurateurbundle_data[name]'] = "data-test";
		$form['ign_bundle_configurateurbundle_data[unit]'] = $unit;
		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('data.name.regex', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * Tests new Data insertion with empty name, unit and label
	 */
	public function testNewWithEmptyNameAndUnit() {
		$crawler = $this->client->request('GET', '/data/new');
		$form = $crawler->selectButton('Ajouter')->form();

		$form['ign_bundle_configurateurbundle_data[name]'] = "";
		$form['ign_bundle_configurateurbundle_data[unit]'] = "";
		$form['ign_bundle_configurateurbundle_data[label]'] = "";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('data.name.notBlank', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$filter = 'html:contains("' . $this->translator->trans('data.unit.notNull', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$filter = 'html:contains("' . $this->translator->trans('data.label.notBlank', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * Tests new Data insertion with already used name,
	 */
	public function testNewWithAlreadyUsedName() {
		$crawler = $this->client->request('GET', '/data/new');
		$form = $crawler->selectButton('Ajouter')->form();

		$form['ign_bundle_configurateurbundle_data[name]'] = "data_field_to_override";
		// Selects the second option (first is empty)
		$unit = $crawler->filter('#ign_bundle_configurateurbundle_data_unit > option')
			->eq(1)
			->attr('value');
		$form['ign_bundle_configurateurbundle_data[unit]'] = $unit;
		$form['ign_bundle_configurateurbundle_data[label]'] = "Test label";
		$form['ign_bundle_configurateurbundle_data[definition]'] = "Test definition";
		$form['ign_bundle_configurateurbundle_data[comment]'] = "Test comment";

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('data.name.unique', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * Tests new correct Data insertion, from a table edition page.
	 * The new entity must be attached to the table.
	 */
	public function testNewAttachToTable() {
		// Go to table edition page
		$tableEditPath = '/models/2/tables/table_with_fields/fields/';
		$crawler = $this->client->request('GET', $tableEditPath);
		// From there, go to add a new data field page
		$link = $crawler->selectLink($this->translator->trans('data.add.button'))
			->link();
		$crawler = $this->client->click($link);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		// Fill form
		$form = $crawler->selectButton($this->translator->trans('data.add.attach.table'))
			->form();
		$form['ign_bundle_configurateurbundle_data[name]'] = "data_to_attach";
		$form['ign_bundle_configurateurbundle_data[unit]'] = 'BOOLEAN';
		$form['ign_bundle_configurateurbundle_data[label]'] = "Test label";
		$form['ign_bundle_configurateurbundle_data[definition]'] = "Test definition";
		$form['ign_bundle_configurateurbundle_data[comment]'] = "Test comment";

		// Tests redirection to table edit page
		$crawler = $this->client->submit($form);

		$this->assertRegExp('#' . $tableEditPath . '$#', $this->client->getRequest()
			->getUri());

		// Tests if the new entity is found and if it is related to the table
		$data = $this->repository->findOneByName('data_to_attach');
		$this->assertEquals('data_to_attach', $data->getName());
		$this->assertEquals($data->getUnit()
			->getName(), 'BOOLEAN');
		$this->assertEquals($data->getLabel(), 'Test label');
		$this->assertEquals($data->getDefinition(), 'Test definition');
		$this->assertEquals($data->getComment(), 'Test comment');

		$field = $data->getFields()->first();
		$this->assertEquals($field->getFormat()
			->getFormat(), 'table_with_fields');
	}

	/**
	 * Tests new correct Data insertion, from a file edition page.
	 * The new entity must be attached to the file.
	 * FIXME
	 */
	public function untestNewAttachToFile() {
		// Go to table edition page
		$fileEditPath = '/datasetsimport/2/files/my_file/fields/';
		$crawler = $this->client->request('GET', $fileEditPath);
		// From there, go to add a new data field page
		$link = $crawler->selectLink($this->translator->trans('data.add.button'))
			->link();
		$crawler = $this->client->click($link);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$fileEditPath = '/data/new/addto/my_file';
		$crawler = $this->client->request('GET', $fileEditPath);

		// Fill form
		$form = $crawler->selectButton($this->translator->trans('data.add.attach.file'))
			->form();
		$form['ign_bundle_configurateurbundle_data[name]'] = "data_to_attach_to_file2";
		$form['ign_bundle_configurateurbundle_data[unit]'] = 'BOOLEAN';
		$form['ign_bundle_configurateurbundle_data[label]'] = "Test label";
		$form['ign_bundle_configurateurbundle_data[definition]'] = "Test definition";
		$form['ign_bundle_configurateurbundle_data[comment]'] = "Test comment";

		// Tests redirection to table edit page
		$crawler = $this->client->submit($form);

		$fileEditPath = '/datasetsimport/2/files/my_file/fields/';
		$crawler = $this->client->request('GET', $fileEditPath);

		// Tests if the new entity is found and if it is related to the table
		$data = $this->repository->findOneByName('data_to_attach_to_file2');
		$this->assertEquals('data_to_attach_to_file2', $data->getName());
		$this->assertEquals($data->getUnit()
			->getName(), 'BOOLEAN');
		$this->assertEquals($data->getLabel(), 'Test label');
		$this->assertEquals($data->getDefinition(), 'Test definition');
		$this->assertEquals($data->getComment(), 'Test comment');

		$field = $data->getFields()->first();
		$this->assertEquals($field->getFormat()
			->getFormat(), 'my_file');
	}

	/**
	 * Tests edition of data with the same value for the name
	 */
	public function testEditWithSameName() {
		$dataName = 'data_field_to_edit';
		$crawler = $this->client->request('GET', '/data/' . $dataName . '/edit');
		$form = $crawler->selectButton('Modifier')->form();

		$form['ign_bundle_configurateurbundle_data[name]'] = $dataName;
		// Selects option DATE
		$form['ign_bundle_configurateurbundle_data[unit]'] = 'Date';
		$form['ign_bundle_configurateurbundle_data[label]'] = "Test label";
		$form['ign_bundle_configurateurbundle_data[definition]'] = "Test definition";
		$form['ign_bundle_configurateurbundle_data[comment]'] = "Test comment";

		$crawler = $this->client->submit($form);

		$filter = 'html:contains("' . $dataName . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$data = $this->repository->findOneByName($dataName);
		$this->assertEquals($data->getName(), $dataName);
		$this->assertEquals($data->getUnit()
			->getName(), 'Date');
		$this->assertEquals($data->getLabel(), 'Test label');
		$this->assertEquals($data->getDefinition(), 'Test definition');
		$this->assertEquals($data->getComment(), 'Test comment');
	}

	/**
	 * Tests edition of data with the same value for the name
	 */
	public function testEditWithNewCorrectName() {
		$dataName = 'data_field_to_edit';
		$crawler = $this->client->request('GET', '/data/' . $dataName . '/edit');
		$form = $crawler->selectButton('Modifier')->form();

		$form['ign_bundle_configurateurbundle_data[name]'] = $dataName . '_new';

		$crawler = $this->client->submit($form);

		$filter = 'html:contains("' . $dataName . '_new")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$data = $this->repository->findOneByName($dataName . '_new');
		$this->assertEquals($data->getName(), $dataName . '_new');
	}

	/**
	 * Tests edition of data with already existing name
	 */
	public function testEditWithAlreadyExistingtName() {
		$dataName = "data_field_to_edit_2";
		$dataNameNew = "data_field_to_override";
		$crawler = $this->client->request('GET', '/data/' . $dataName . '/edit');
		$form = $crawler->selectButton('Modifier')->form();

		$form['ign_bundle_configurateurbundle_data[name]'] = $dataNameNew;

		$crawler = $this->client->submit($form);
		$filter = 'html:contains("' . $this->translator->trans('data.name.unique', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * Tests edition of data with empty values
	 */
	public function testEditWithEmptyValues() {
		$dataName = "data_field_to_edit_2";
		$crawler = $this->client->request('GET', '/data/' . $dataName . '/edit');
		$form = $crawler->selectButton('Modifier')->form();

		$form['ign_bundle_configurateurbundle_data[name]'] = "";
		$form['ign_bundle_configurateurbundle_data[unit]'] = "";
		$form['ign_bundle_configurateurbundle_data[label]'] = "";

		$crawler = $this->client->submit($form);

		$filter = 'html:contains("' . $this->translator->trans('data.name.notBlank', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$filter = 'html:contains("' . $this->translator->trans('data.unit.notNull', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$filter = 'html:contains("' . $this->translator->trans('data.label.notBlank', array(), 'validators') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * Tests edition of non editable data fields :
	 * - One attached to a table
	 * - Another one attached to a import file
	 */
	public function testEditUneditableData() {
		$this->client->followRedirects(false);

		foreach (array(
			"related_data_field",
			"related_to_file_data_field"
		) as $dataName) {
			$crawler = $this->client->request('GET', '/data/' . $dataName . '/edit');

			// tests redirection (you mustn't access the edit page)
			$this->assertTrue($this->client->getResponse()
				->isRedirect());

			$crawler = $this->client->followRedirect();
			// tests error message
			$filter = 'html:contains("' . $this->translator->trans('data.edit.forbidden', array(
				'%dataName%' => $dataName
			)) . '")';
			$this->assertTrue($crawler->filter($filter)
				->count() == 1);
		}
		$this->client->followRedirects();
	}

	/**
	 * Tests deletion of a data field not related to a table
	 */
	public function testDeleteDeletableData() {
		$dataName = 'data_field_to_delete';
		$this->client->request('GET', '/data/' . $dataName . '/delete');

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$datas = $this->repository->findByName($dataName);
		$this->assertEquals(count($datas), 0);
	}

	/**
	 * Tests deletion of a data fields :
	 * - One attached to a table
	 * - Another one attached to a import file
	 */
	public function testDeleteUndeletableData() {
		$this->client->followRedirects(false);

		foreach (array(
			"related_data_field",
			"related_to_file_data_field"
		) as $dataName) {

			$crawler = $this->client->request('GET', '/data/' . $dataName . '/delete');

			// tests redirection (you mustn't access the delete page)
			$this->assertTrue($this->client->getResponse()
				->isRedirect());

			$crawler = $this->client->followRedirect();
			// tests error message
			$filter = 'html:contains("' . $this->translator->trans('data.delete.forbidden', array(
				'%dataName%' => $dataName
			)) . '")';
			$this->assertTrue($crawler->filter($filter)
				->count() == 1);

			$datas = $this->repository->findByName($dataName);
			$this->assertEquals(count($datas), 1);
		}
		$this->client->followRedirects();
	}
}
