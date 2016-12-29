<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Tests\Controller;

use Ign\Bundle\OGAMConfigurateurBundle\Entity;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController;
use Symfony\Component\DependencyInjection\Container;
use Symfony\Bundle\FrameworkBundle\Translation\Translator;
use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

/**
 * TODO correct issue on delete complex model
 *
 * @author Gautam Pastakia
 *
 *
 */
class GincoModelControllerTest extends ConfiguratorTest {

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
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$this->container = static::$kernel->getContainer();
		$this->translator = $this->container->get('translator');

		$this->em = $this->container->get('doctrine')->getManager();
		$this->client = static::createClient();
		$this->client->followRedirects(true);

		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Model');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController::newAction
	 */
	public function testNewWithCorrectName() {
		$crawler = $this->client->request('GET', '/models/new/');

		$filter = 'html:contains("' . $this->translator->trans('datamodel.new.forbidden') . '")';

		$this->assertTrue($crawler->filter($filter)
			->count() == 1);
	}
}
