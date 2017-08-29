<?php
namespace Ign\Bundle\GincoBundle\Tests\Controller;

use Ign\Bundle\GincoBundle\Tests\GincoBaseTest;

class DefaultControllerTest extends GincoBaseTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-3-Create_website_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_jdd_controller.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	/**
	 * Sets up the entity manager and the test client.
	 */
	public function setUp() {
		$this->client = static::createClient();
		$this->client->followRedirects(true);

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();
	}

	/**
	 * Checks if the link to view regional data for ANY user is available.
	 */
	public function testIndexAction() {
		$crawler = $this->client->request('GET', '/');

		$this->assertContains($this->translator->trans('Menu.RegionalData'), $crawler->text());
	}
}
