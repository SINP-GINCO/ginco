<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\DBAL\DriverManager;
use Doctrine\DBAL\Connection;
use Monolog\Logger;

/**
 *
 * Utility class containing common content for database utils classes.
 *
 * @author Gautam Pastakia
 *
 */
class DatabaseUtils {

	protected $conn;

	protected $adminConn;

	protected $adminName;

	protected $adminPassword;

	protected $logger;

	/**
	 * DBAL Connection object is retrieved through service container.
	 * See services.yml for ModelPublication and TablesGeneration services
	 * for more information.
	 *
	 * @param Connection $conn
	 * @param string $adminName
	 *        	the user admin name (if not provided, will take the username inside connection param)
	 * @param string $adminPassword
	 *        	the admin password (if not provided, will take the password inside connection param)
	 *
	 */
	public function __construct(Connection $conn, Logger $logger, $adminName = null, $adminPassword = null) {
		$this->conn = $conn;
		$this->logger = $logger;
		if ($adminName == null && $adminPassword == null) {
			$this->adminName = $conn->getUsername();
			$this->adminPassword = $conn->getPassword();
		} else {
			$this->adminName = $adminName;
			$this->adminPassword = $adminPassword;
		}
		$this->setAdminConnection();
	}

	public function getConnection() {
		return $this->conn;
	}

	public function setConnection($conn) {
		$this->conn = $conn;
	}

	public function getAdminConnection() {
		if ($this->adminConn == null) {
			$this->setAdminConnection();
		}
		return $this->adminConn;
	}

	public function setAdminConnection() {
		if ($this->adminConn == null) {
			$connParams = array(
				'dbname' => $this->conn->getDatabase(),
				'user' => $this->adminName,
				'password' => $this->adminPassword,
				'host' => $this->conn->getHost(),
				'driver' => $this->conn->getDriver()->getName()
			);

			$config = new \Doctrine\DBAL\Configuration();

			$this->adminConn = DriverManager::getConnection($connParams, $config);
		}
	}
}
