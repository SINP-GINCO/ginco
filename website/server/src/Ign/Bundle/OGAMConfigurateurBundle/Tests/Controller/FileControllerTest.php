<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\FileFormat;
use Ign\Bundle\OGAMConfigurateurBundle\IgnOGAMConfigurateurBundle;
use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

class FileControllerTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_file_controller.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		$this->client = static::createClient(array(
			'environment' => 'test_ogam'
		));
		$this->client->followRedirects(true);

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();

		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:FileFormat');
	}

	public function testNew() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/new/');

		$filter = $this->translator->trans('file.new.title', array(
			'%dataset.label%' => 'import_model'
		));
		$this->assertContains($filter, $crawler->text());

		$form = $crawler->selectButton('Enregistrer')->form();

		$form['ign_bundle_configurateurbundle_file_format[label]'] = 'my_new_file';
		$form['ign_bundle_configurateurbundle_file_format[description]'] = 'description';

		$crawler = $this->client->submit($form);

		$filter = $this->translator->trans('file.edit.title', array(
			'%file.label%' => 'my_new_file',
			'%dataset.label%' => 'import_model'
		));

		$this->assertContains($filter, $crawler->text());

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testFileOrderHelpExists() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/edit');

		$filter = 'html:contains("' . $this->translator->trans('file.edit.order.help') . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	public function testEdit() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_file/edit');

		$form = $crawler->filter('form[name=ign_bundle_configurateurbundle_file_format]')->form();

		$newName = 'my_edited_name';
		$form['ign_bundle_configurateurbundle_file_format[label]'] = $newName;

		$crawler = $this->client->submit($form);

		$this->assertContains($newName, $crawler->text());
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testDeleteSimpleFile() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/file_to_delete/delete/');

		$filter = 'html:contains("' . $this->translator->trans('file.delete.success', array(
			'%file.label%' => 'file_to_delete',
			'%datasetLabel%' => 'my_import_model'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	public function testDeleteComplexFile() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/file_to_delete_complex/delete/');

		$filter = 'html:contains("' . $this->translator->trans('file.delete.success', array(
			'%file.label%' => 'file_to_delete',
			'%datasetLabel%' => 'my_import_model'
		)) . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$fields = $this->em->getRepository('IgnOGAMConfigurateurBundle:FileField')->findFieldsByFileFormat('file_to_delete_complex');
		$this->assertEmpty($fields);
	}

	public function testMaskHelpExists() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_file/fields/');

		$filter1 = 'html:contains("' . $this->translator->trans('fileField.mask.date') . '")';
		$filter2 = 'html:contains("' . $this->translator->trans('fileField.mask.example1') . '")';

		$this->assertTrue($crawler->filter($filter1)
			->count() == 1);
		$this->assertTrue($crawler->filter($filter2)
			->count() == 1);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\FileController::viewAction
	 */
	public function testViewAction() {
		$crawler = $this->client->request('GET', '/datasetsimport/import_model_view/files/file_view/view/');

		$filter1 = 'html:contains("file_view")';
		$filter2 = 'html:contains("Date du jour de fin d")';
		$filter3 = 'html:contains("file_view_description")';

		$this->assertTrue($crawler->filter($filter1)
			->count() > 0);
		$this->assertTrue($crawler->filter($filter2)
			->count() > 0);
		$this->assertTrue($crawler->filter($filter3)
			->count() > 0);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\FileController::autoAction
	 */
	public function testAutoAddFieldsWithoutSelectedTable() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/file_auto/fields/');
		// Try to submit the auto-add-fields form without selecting a table
		$form = $crawler->selectButton('Ajout automatique')->form();
		$form['ign_bundle_configurateurbundle_file_field_auto[table_format]'] = '';
		$crawler = $this->client->submit($form);

		$filter = 'html:contains("' . $this->translator->trans('fileField.auto.chooseatable') . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);
	}

	/**
	 * Tests auto add fields
	 * Initial situation :
	 *
	 * TABLE
	 * altitudemin
	 * altitudemax
	 * cdnom (mandatory)
	 * cdref (mandatory)
	 *
	 * FILE
	 *
	 * altitudemin (mandatory)
	 *
	 * Performs auto adding of fields and checks (in db )
	 * - when we add only mandatory fields, adding of 2 fields : cdnom and cdref
	 * - when we add the rest of the fields, 1 field is added : altitudemax ; altuitudemin is left untouched and is still mandatory
	 *
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\FileController::autoAction
	 */
	public function testAutoAction() {
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/file_auto/fields/');

		// Performs auto-add fields, FIRST ON MANDATORY FIELDS
		$form = $crawler->selectButton('Ajout automatique')->form();
		$form['ign_bundle_configurateurbundle_file_field_auto[table_format]'] = 'my_table';
		$form['ign_bundle_configurateurbundle_file_field_auto[only_mandatory]']->tick();
		$crawler = $this->client->submit($form);

		// Extract direct info from DB (table field_mapping) :
		$query = $this->em->createQuery('SELECT
					ff.data, ff.isMandatory
					FROM IgnOGAMConfigurateurBundle:FileField ff
					WHERE ff.fileFormat = :fileFormat')->setParameters(array(
			'fileFormat' => 'file_auto'
		));
		$fields = $query->getResult();

		$altMax = false;
		$altMin = false;
		$cdNom = false;
		$cdRef = false;

		foreach ($fields as $field) {
			if ($field['data'] == 'altitudemax') {
				$altMax = true;
			}
			if ($field['data'] == 'altitudemin') {
				$altMin = true;
			}
			if ($field['data'] == 'cdnom') {
				$cdNom = true;
			}
			if ($field['data'] == 'cdref') {
				$cdRef = true;
			}
		}

		$this->assertTrue($altMin); // already there
		$this->assertFalse($altMax); // Must not be added
		$this->assertTrue($cdNom); // Must be added
		$this->assertTrue($cdRef); // Must be added

		// Performs auto-add fields, NOW ON ALL FIELDS
		$form = $crawler->selectButton('Ajout automatique')->form();
		$form['ign_bundle_configurateurbundle_file_field_auto[table_format]'] = 'my_table';
		$crawler = $this->client->submit($form);

		// Extract direct info from DB (table field_mapping) :
		$query = $this->em->createQuery('SELECT
					ff.data, ff.isMandatory
					FROM IgnOGAMConfigurateurBundle:FileField ff
					WHERE ff.fileFormat = :fileFormat')->setParameters(array(
			'fileFormat' => 'file_auto'
		));
		$fields = $query->getResult();

		$altMax = false;
		$altMin = false;
		$altMinMandatory = false;
		$cdNom = false;
		$cdRef = false;

		foreach ($fields as $field) {
			if ($field['data'] == 'altitudemax') {
				$altMax = true;
			}
			if ($field['data'] == 'altitudemin') {
				$altMin = true;
				if ($field['isMandatory'] == 1) {
					$altMinMandatory = true;
				}
			}
			if ($field['data'] == 'cdnom') {
				$cdNom = true;
			}
			if ($field['data'] == 'cdref') {
				$cdRef = true;
			}
		}

		$this->assertTrue($altMin); // already there
		$this->assertTrue($altMinMandatory); // already there
		$this->assertTrue($altMax); // Must be added
		$this->assertTrue($cdNom); // Already there
		$this->assertTrue($cdRef); // Already there
	}
}

