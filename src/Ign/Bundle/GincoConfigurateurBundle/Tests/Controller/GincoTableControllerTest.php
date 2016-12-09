<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Tests\Controller;

use Ign\Bundle\ConfigurateurBundle\Entity\TableFormat;
use Ign\Bundle\ConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\ConfigurateurBundle\Entity\Model;

class GincoTableControllerTest extends ConfiguratorTest {

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

	/**
	 * #600: Should be forbidden to create a new table.
	 */
	public function testNew() {
		$crawler = $this->client->request('GET', '/models/2/tables/new/');

		$filter = 'html:contains("' . $this->translator->trans('table.new.forbidden') . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	/**
	 * #600: Should be forbidden to delete any table.
	 */
	public function testDeleteSimpleTable() {
		$crawler = $this->client->request('GET', '/models/3/tables/table_to_delete/delete/');

		$filter = 'html:contains("' . $this->translator->trans('table.delete.forbidden') . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}

	public function testRemoveAllFields() {
		$crawler = $this->client->request('GET', '/models/3/tables/table_with_fields/fields/');

		$this->assertContains('<td id="label">jddCode</td>', $crawler->html());
		$this->assertContains('<td id="label">jddCode</td>', $crawler->html());

		$this->assertContains('<td id="label">custom_field</td>', $crawler->html());
		$this->assertContains('<td id="label">custom_field</td>', $crawler->html());

		$crawler = $this->client->request('GET', '/models/3/tables/table_with_fields/fields/removeall/');

		$this->assertContains('<td id="label">jddCode</td>', $crawler->html());
		$this->assertContains('<td id="label">jddCode</td>', $crawler->html());

		$this->assertNotContains('<td id="label">custom_field</td>', $crawler->html());
		$this->assertNotContains('<td id="label">custom_field</td>', $crawler->html());
	}
}

