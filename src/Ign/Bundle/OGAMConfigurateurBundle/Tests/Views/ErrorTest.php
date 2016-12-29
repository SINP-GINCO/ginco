<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Views;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;

class ErrorTest extends ConfiguratorTest {

	public static function executeScripts($adminConn) {
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

		$this->repository = $this->em->getRepository('IgnOGAMConfigurateurBundle:Data');
	}

	/**
	 * Tests if error 404 page exists
	 */
	public function testError404() {
		$crawler = $this->client->request('GET', '/_error/404');
		$error404 = 'La page demandée n\'existe pas. Veuillez vérifier que l\'URL est correcte ou';
		$pageNotFound = 'Ressource introuvable';

		$filter = 'html:contains("' . $error404 . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);

		$filter = 'html:contains("' . $pageNotFound . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * Tests if error 403 page exists
	 */
	public function testError403() {
		$crawler = $this->client->request('GET', '/_error/403');
		$error403 = 'Vous n\'avez les droits suffisants pour accéder à cette ressource.';
		$forbidden = 'Accès refusé';

		$filter = 'html:contains("' . $error403 . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);

		$filter = 'html:contains("' . $forbidden . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}

	/**
	 * Tests if error default page exists
	 */
	public function testErrorDefault() {
		$crawler = $this->client->request('GET', '/_error/500');
		$error = 'Un problème a été rencontré. Merci de signaler cet incident ainsi que les actions qui y ont mené afin qu\'il puisse être corrigé. Veuillez excuser le désagrément causé.';
		$anErrorOccurred = 'Une erreur est survenue';

		$filter = 'html:contains("' . $error . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);

		$filter = 'html:contains("' . $anErrorOccurred . '")';
		$this->assertTrue($crawler->filter($filter)
			->count() > 0);

		$this->assertTrue($this->client->getResponse()
			->isSuccessful());
	}
}
