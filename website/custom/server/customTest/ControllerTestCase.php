<?php
require_once 'Zend/Application.php';
require_once 'Zend/Test/PHPUnit/ControllerTestCase.php';

/**
 * Test case for a controller.
 */
abstract class ControllerTestCase extends Zend_Test_PHPUnit_ControllerTestCase {

	protected $application;

	protected $logger;

	/**
	 * Set up the test case.
	 *
	 * @see sources/library/Zend/Test/PHPUnit/Zend_Test_PHPUnit_ControllerTestCase::setUp()
	 */
	public function setUp() {
		if ($this->application == null) {
			$this->application = new Zend_Application(APPLICATION_ENV, CUSTOM_APPLICATION_PATH . '/configs/application.ini');
			$this->application->bootstrap();

			$bootstrap = $this->application->getBootstrap();
			$front = $bootstrap->getResource('FrontController');
			$front->setParam('bootstrap', $bootstrap);
			$front->getRouter()->addDefaultRoutes();

			$this->logger = Zend_Registry::get("logger");

			// Force the cache usage to false
			$configuration = Zend_Registry::get("configuration");
			$configuration->useCache = false;
		}
	}

	/**
	 * Returns the database connection string.
	 *
	 * @return string the connection string
	 */
	protected function getConnectionString() {
		$db = Zend_Registry::get('mapping_db');
		$config = $db->getConfig();
		$connectionString = "host=" . $config['host'] . " port=" . $config['port'] . " dbname=" . $config['dbname'] . " user=". $config['username']. " password=". $config['password'];
		return $connectionString;
	}
}