<?php
namespace Ign\Bundle\GincoBundle\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\VarDumper\Cloner\VarCloner;
use Symfony\Component\VarDumper\Dumper\CliDumper;

/**
 * Class that every unit or functional test class should implement.
 *
 * @author Gautam Pastakia
 *
 */
abstract class GincoBaseTest extends WebTestCase implements GincoBaseInterface {

	/**
	 *
	 * @var \Doctrine\ORM\EntityManager
	 */
	protected $em;

	/**
	 *
	 * @var \Ign\Bundle\OGAMConfigurateurBundle\Tests\Client
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
	 *
	 */
	protected $dbconn;

	/**
	 *
	 * @var VarCloner
	 */
	public $cloner;

	/**
	 *
	 * @var Dumper
	 */
	public $dumper;

	function __construct() {
		parent::__construct();
		// Utilities for dumping variables
		$this->cloner = new VarCloner();
		$this->dumper = new CliDumper();
	}

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
}
