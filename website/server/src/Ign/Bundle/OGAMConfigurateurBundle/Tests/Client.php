<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests;

use Symfony\Bundle\FrameworkBundle\Client as BaseClient;

/**
 * This class overrides the basic test client class of Symfony2.
 * It allows to override the basic Symfony2 behavior which creates a new container for each request,
 * leading to having different Doctrine objects in each request.
 * Each request has its own connection, while we want to have the same connection for all our requests.
 * This class addresses this issue.
 * It is also possible to use the doRequest method to surround the handle request method call by a transaction.
 *
 * @author Gautam Pastakia
 *
 */
class Client extends BaseClient {

	protected static $connection;

	protected $requested;

	protected function doRequest($request) {
		if ($this->requested) {
			$this->kernel->shutdown();
			$this->kernel->boot();
		}

		$this->injectConnection();
		$this->requested = true;

		$response = $this->kernel->handle($request);

		return $response;
	}

	protected function injectConnection() {
		if (null === self::$connection) {
			self::$connection = $this->getContainer()->get('doctrine.dbal.default_connection');
		} else {
			if (!$this->requested) {
				self::$connection->rollback();
			}
			$this->getContainer()->set('doctrine.dbal.default_connection', self::$connection);
		}

		if (!$this->requested) {
			self::$connection->beginTransaction();
		}
	}
}
