<?php
namespace Ign\Bundle\ConfigurateurBundle\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

/**
 * Class that every unit or functional test class should implement.
 *
 * @author Gautam Pastakia
 *
 */
abstract class ConfiguratorTest extends WebTestCase {

	/**
	 *
	 * @var \Doctrine\ORM\EntityManager
	 */
	protected $em;

	/**
	 *
	 * @var \Ign\Bundle\ConfigurateurBundle\Tests\Client
	 */
	protected $client;

	/**
	 * The repository for the main entity tested.
	 *
	 * @var EntityRepository
	 */
	protected $repository;

	/**
	 *
	 * @var Container
	 */
	protected $container;

	/**
	 *
	 * @var Translator
	 */
	protected $translator;

	/**
	 *
	 * @var Session
	 */
	protected $session;

	/**
	 *
	 * Connection to the database via PDO
	 *
	 * @var
	 */
	protected $dbconn;

	/**
	 * Instanciates the unit_test db with data.
	 * Purges it before.
	 */
	public static function setUpBeforeClass() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$container = static::$kernel->getContainer();

		$conn = $container->get('database_connection');

		// Create a specific admin connection to execute admin necessary privileges script
		$adminName = $container->getParameter('database_admin_user');
		$adminPassword = $container->getParameter('database_admin_password');
		$adminDbconn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $adminName . " password=" . $adminPassword) or die('Connection is impossible : ' . pg_last_error());

		// Execute insert scripts
		static::executeScripts($adminDbconn);
	}

	/**
	 * This function execute SQL scripts needed for specific test.
	 *
	 * @param $adminConn connection
	 *        	to postgres
	 */
	abstract static function executeScripts($adminConn);
}
