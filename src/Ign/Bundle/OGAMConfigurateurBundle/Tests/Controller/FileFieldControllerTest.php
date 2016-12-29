<?php
namespace Ign\Bundle\ConfigurateurBundle\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Ign\Bundle\ConfigurateurBundle\Entity;
use Ign\Bundle\ConfigurateurBundle\Entity\FileFormat;
use Ign\Bundle\ConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\ConfigurateurBundle\IgnConfigurateurBundle;

class FileFieldControllerTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_file_field_controller.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		$this->client = static::createClient();
		$this->client->followRedirects(true);

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();

		$this->repository = $this->em->getRepository('IgnConfigurateurBundle:FileField');
	}

	public function testAddFieldsAction() {
		$fields = "jddid,jddcode";

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/');

		$this->assertContains('<td id="label">Identifiant de la provenance [STRING]</td>', $crawler->html());
		$this->assertContains('<td id="name" class="hidden">jddid [STRING]</td>', $crawler->html());
		$this->assertContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());
		$this->assertNotContains('<td id="label">Code identifiant la provenance</td>', $crawler->html());

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/add/' . $fields . '/');

		$this->assertContains('<td id="label">Identifiant de la provenance [STRING]</td>', $crawler->html());
		$this->assertContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());
		$this->assertContains('<td id="label">Code identifiant la provenance</td>', $crawler->html());
	}

	public function testRemoveField() {
		$field = "jddid";

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_remove_file/fields/');

		$this->assertContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_remove_file/fields/remove/' . $field . '/');

		$this->assertNotContains('<td id="label">Identifiant de la provenance</td>', $crawler->html());
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

		$fields = $this->em->getRepository('IgnConfigurateurBundle:FileField')->findFieldsByFileFormat('file_to_delete_complex');
		$this->assertEmpty($fields);
	}

	public function testAddDateMask() {
		$fields = "commentaire";

		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/add/' . $fields . '/');
		$this->assertNotContains('value="yyyy-MM-dd"', $crawler->html());
		$this->assertContains('<p id="mask"></p>', $crawler->html());
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$fields = "datefin";
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/add/' . $fields . '/');
		$mask = "yyyy-MM-dd'T'HH:mmZ";
		$this->assertContains('value="' . $mask . '"', $crawler->html());
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());

		$fields = "dateME";
		$crawler = $this->client->request('GET', '/datasetsimport/my_import_model/files/my_add_file/fields/add/' . $fields . '/');
		$this->assertContains('value="yyyy-MM-dd"', $crawler->html());
		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

}

