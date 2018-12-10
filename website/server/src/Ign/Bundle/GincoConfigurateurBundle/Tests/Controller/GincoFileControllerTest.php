<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Controller;

use Ign\Bundle\GincoConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\FileFormat;
use Ign\Bundle\OGAMConfigurateurBundle\IgnOGAMConfigurateurBundle;

class GincoFileControllerTest extends ConfiguratorTest {

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
			'environment' => 'test'
		));
		$this->client->followRedirects(true);

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();
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
	 * sensiniveau (calculated not mandatory)
	 *
	 * FILE
	 *
	 * altitudemin (mandatory)
	 *
	 * Performs auto adding of fields and checks (in db )
	 * - when we add only mandatory fields, adding of 2 fields : cdnom and cdref
	 * - when we add the rest of the fields, 1 field is added : altitudemax ; altuitudemin is left untouched and is still mandatory
	 *
	 * @covers Ign\Bundle\GincoConfigurateurBundle\Controller\FileController::autoAction
	 */
	public function testAutoAction() {
		//exit();
		$crawler = $this->client->request('GET', '/datasetsimport/ginco_my_import_model/files/file_auto/fields/');

 		//var_dump($crawler->html());
 		//exit();

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
		$sensiNiveau = false;

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
			if ($field['data'] == 'sensiniveau') {
				$sensiNiveau = true;
			}
		}

		$this->assertTrue($altMin); // already there
		$this->assertFalse($altMax); // Must not be added
		$this->assertTrue($cdNom); // Must be added
		$this->assertTrue($cdRef); // Must be added
		$this->assertFalse($sensiNiveau); // Must not be added (calculated)

		// Performs auto-add fields, NOW ON ALL FIELDS except those calculated
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
		$sensiNiveau = false;

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
			if ($field['data'] == 'sensiniveau') {
				$sensiNiveau = true;
			}
		}

		$this->assertTrue($altMin); // already there
		$this->assertTrue($altMinMandatory); // already there
		$this->assertTrue($altMax); // Must be added
		$this->assertTrue($cdNom); // Already there
		$this->assertTrue($cdRef); // Already there
		$this->assertFalse($sensiNiveau); // Must not be added

		// Performs auto-add fields, NOW ON ALL FIELDS
		$form = $crawler->selectButton('Ajout automatique')->form();
		$form['ign_bundle_configurateurbundle_file_field_auto[table_format]'] = 'my_table';
		$form['ign_bundle_configurateurbundle_file_field_auto[with_calculated]']->tick();
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
		$sensiNiveau = false;

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
			if ($field['data'] == 'sensiniveau') {
				$sensiNiveau = true;
			}
		}

		$this->assertTrue($altMin); // already there
		$this->assertTrue($altMinMandatory); // already there
		$this->assertTrue($altMax); // Must be added
		$this->assertTrue($cdNom); // Already there
		$this->assertTrue($cdRef); // Already there
		$this->assertTrue($sensiNiveau); // Must be added
	}
}

