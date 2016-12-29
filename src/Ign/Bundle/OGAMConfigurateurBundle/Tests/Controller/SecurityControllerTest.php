<?php
namespace Ign\Bundle\ConfigurateurBundle\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Ign\Bundle\ConfigurateurBundle\Entity;
use Ign\Bundle\ConfigurateurBundle\Entity\TableFormat;
use Ign\Bundle\ConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\ConfigurateurBundle\Entity\Model;
use Symfony\Component\HttpFoundation\Session\Attribute\AttributeBag;
use Theodo\Evolution\Bundle\SessionBundle\Attribute\ScalarBag;
use Symfony\Component\Config\Definition\Exception\Exception;
use Symfony\Component\HttpFoundation\Session\Attribute\NamespacedAttributeBag;

class SecurityControllerTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-3-Create_website_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {

		$this->client = static::createClient(array(
			'environment' => 'test'
		));

		$this->client->followRedirects(true);
		$this->container = static::$kernel->getContainer();
	}

	public function testLoginActionUserAdmin() {
		$session = $this->container->get('session');
		$userBag = new NamespacedAttributeBag('user');
		$userBag->setName('user');
		$userBag->set('user', 'developpeur');
		$session->start();
		$session->registerBag($userBag);

		$this->client->request('GET', '/login/');

		$this->assertTrue($this->container->get('security.authorization_checker')->isGranted('ROLE_CONFIGURE_METAMODEL'));
	}

	public function testLoginActionNoUser() {
		$session = $this->container->get('session');
		$session->start();

		$this->client->request('GET', '/login/');

		$this->assertFalse($this->container->get('security.authorization_checker')->isGranted('ROLE_CONFIGURE_METAMODEL'));
	}

	public function testLoginActionUserWithoutAdminRole() {
		$session = $this->container->get('session');
		$userBag = new NamespacedAttributeBag('user');
		$userBag->setName('user');
		$userBag->set('user', 'visiteur');
		$session->start();
		$session->registerBag($userBag);

		$this->client->request('GET', '/login/');

		$this->assertFalse($this->container->get('security.authorization_checker')->isGranted('ROLE_CONFIGURE_METAMODEL'));
	}

	public function showSessionStatus(){
		if(session_status() === PHP_SESSION_NONE) {
			dump("PHP_SESSION_NONE");
		} else if (session_status() === PHP_SESSION_ACTIVE) {
			dump("PHP_SESSION_ACTIVE");
		} else if (session_status() === PHP_SESSION_DISABLED) {
			dump("PHP_SESSION_DISABLED");
		}
	}
}

