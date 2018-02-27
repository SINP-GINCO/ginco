<?php

namespace Ign\Bundle\GincoBundle\Services;
use Doctrine\Bundle\DoctrineBundle\Registry;
use Doctrine\ORM\ORMException;
use GuzzleHttp\Client;
use Ign\Bundle\GincoBundle\Exception\UserUpdaterException;
use Ign\Bundle\OGAMBundle\Entity\Website\User;
use Ign\Bundle\OGAMBundle\Services\ConfigurationManager;
use Symfony\Bridge\Monolog\Logger;

/**
 * Class INPNUserUpdater
 *
 * Update a local user (in database) with user infos
 * from the INPN webservice.
 *
 * @author SCandelier
 */
class INPNUserUpdater
{
	protected $doctrine;
	protected $configManager;
	protected $providerService;
	protected $logger;

	protected $webservice_authentication;
	protected $authentication_options;
	protected $options;

	/**
	 * INPNUserUpdater constructor.
	 * @param Registry $doctrine
	 * @param ConfigurationManager $configManager
	 * @param Logger $logger
	 */
	public function __construct(Registry $doctrine, ConfigurationManager $configManager, INPNProviderService $providerService, Logger $logger)
	{
		$this->doctrine = $doctrine;
		$this->configManager = $configManager;
		$this->providerService = $providerService;
		$this->logger = $logger;

		$this->webservice_authentication = $this->configManager->getConfig('INPN_authentication_webservice');
		$this->authentication_options = [
			$this->configManager->getConfig('INPN_authentication_login'),
			$this->configManager->getConfig('INPN_authentication_password')
		];

		$this->options = array();
		// Add proxy if needed
		$httpsProxy = $this->configManager->getConfig('https_proxy', '');
		if (!empty($httpsProxy)) {
			$this->options['proxy'] = $httpsProxy;
		}
	}

	/**
	 * Update or create local user from webservice informations,
	 * (create provider if needed), and persist him in database.
	 *
	 * @param $username
	 * @return User|null|object
	 * @throws ORMException
	 * @throws UserUpdaterException
	 */
	public function updateOrCreateLocalUser($username) {

		// Call the INPN authentication webservice to
		// get all attributes of the user ($distantUser)
		$client = new Client($this->options);
		$response = $client->request('GET', $this->webservice_authentication . "/" . rawurlencode($username) . "/", [
			'verify' => false,
			'auth' => $this->authentication_options,
		]);

		if (!$response) {
			$this->logger->addError("INPN authentication webservice is not accessible, URL : ".$this->webservice_authentication . "/$username/?verify=false");
			throw new UserUpdaterException("INPN authentication webservice is not accessible.");
		}
		$code = $response->getStatusCode();
		if ($code !== 200) {
			$this->logger->addError("INPN authentication webservice returned a HTTP code: $code, URL : ".$this->webservice_authentication . "/$username/?verify=false");
			throw new UserUpdaterException("INPN authentication webservice returned a HTTP code: $code");
		}
		$string = $response->getBody()->getContents();
		$distantUser = json_decode($string);

		// Check if returned user is not null (inexisting username)
		if ($distantUser->id == 0) {
			return null;
		}

		// OK, now we got a real distant user, let's go !
		// ----------------------------------------------
		$em = $this->doctrine->getManager();
		$userRepo = $this->doctrine->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
		$providerRepo = $this->doctrine->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Provider', 'website');
		$roleRepo = $this->doctrine->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Role', 'website');

		// Provider of the user: create it if not present in db
		$providerId = $distantUser->codeOrganisme;
		if (intval($providerId) > 1) { // Don't override default provider (1)
			$provider = $providerRepo->find($providerId);
			if (!$provider) {
				// Add the provider in application DB
				$provider = $this->providerService->updateOrCreateLocalProvider($providerId);
			}
		} else {
			// Default provider
			$provider = $providerRepo->find(1);
		}

		// Tests if user exists in database; if not create it
		$user = $userRepo->find($username);
		$newUser = false;
		if (!$user) {
			$user = new User();
			$newUser = true;
		}

		// Create or synchronize local User with distant User from webservice
		$user
			->setLogin($username)
			->setUsername($distantUser->prenom . " " . $distantUser->nom)
			->setEmail($distantUser->email)
			->setProvider($provider);

		// Set default role, only for NEW users (don't override changes)
		if ($newUser) {
			$role = $roleRepo->findOneByIsDefault(true);
			$user->addRole($role);
		}

		try {
			$em->persist($user);
			$em->flush();
		}
		catch (ORMException $e) {
			$this->logger->addError("Impossible to persist user in database : $string; \n
				Doctrine Exception: " . $e->getMessage());
			throw $e;
		}
		return $user;
	}

	/**
	 * Update Last Login field of a user
	 *
	 * @param User $user
	 * @return User
	 * @throws ORMException
	 */
	public function updateLastLogin(User $user) {
		$user->setLastLoginNow();

		$em = $this->doctrine->getManager();
		try {
			$em->persist($user);
			$em->flush();
		}
		catch (ORMException $e) {
			$this->logger->addError("Impossible to persist user in database: " . $user->getLogin() . "\n
				Doctrine Exception: " . $e->getMessage());
			throw $e;
		}
		return $user;
	}

}