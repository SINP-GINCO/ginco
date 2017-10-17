<?php
namespace Ign\Bundle\GincoBundle\Security;

use Doctrine\Bundle\DoctrineBundle\Registry;
use Doctrine\ORM\EntityManager;
use GuzzleHttp\Client;
use Ign\Bundle\OGAMBundle\Entity\Website\User;
use Symfony\Bridge\Monolog\Logger;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Guard\AbstractGuardAuthenticator;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Exception\AuthenticationException;
use Symfony\Component\Security\Core\User\UserProviderInterface;

/**
 * Class CasAuthenticator
 * @package Ign\Bundle\GincoBundle\Services
 * @author SCandelier (inspiration: https://github.com/PRayno/CasAuthBundle/blob/master/Security/CasAuthenticator.php)
 */
class CasAuthenticator extends AbstractGuardAuthenticator
{
	protected $doctrine;
	protected $logger;

	protected $server_login_url;
	protected $server_validation_url;
	protected $xml_namespace;
	protected $username_attribute;
	protected $query_ticket_parameter;
	protected $query_service_parameter;
	protected $webservice_authentication;
	protected $authentication_options;
	protected $options;

	/**
	 * Process configuration
	 * @param array $config
	 */
	public function __construct(Registry $doctrine, Logger $logger)
	{
		/*
		$this->server_login_url = $config['server_login_url'];
		$this->server_validation_url = $config['server_validation_url'];
		$this->xml_namespace = $config['xml_namespace'];
		$this->username_attribute = $config['username_attribute'];
		$this->query_service_parameter = $config['query_service_parameter'];
		$this->query_ticket_parameter = $config['query_ticket_parameter'];
		$this->options = $config['options'];
		*/
		$this->doctrine = $doctrine;
		$this->logger = $logger;

		$this->server_login_url = 'https://inpn2.mnhn.fr/auth/login';
		// $this->server_validation_url = 'https://inpn2.mnhn.fr/j_spring_cas_security_check';
		$this->server_validation_url = 'https://inpn2.mnhn.fr/auth/serviceValidate';
		$this->xml_namespace = 'cas';
		$this->username_attribute = 'user';
		$this->query_service_parameter = 'service';
		$this->webservice_authentication = 'https://inpn2.mnhn.fr/authentication/information';
		$this->authentication_options = ['user1', 'password1'];
		$this->query_ticket_parameter = 'ticket';
		$this->options = array();
		// Add proxy if needed
		// $httpsProxy = $this->configurationManager->getConfig('https_proxy', '');
		$httpsProxy = 'https://proxy.ign.fr:3128';
		if ($httpsProxy) {
			$this->options['proxy'] = $httpsProxy;
		}


	}

	/**
	 * Called on every request. Return whatever credentials you want,
	 * or null to stop authentication.
	 */
	public function getCredentials(Request $request)
	{
		if ($request->get($this->query_ticket_parameter)) {
			// Validate ticket
			$client = new Client($this->options);
			$response = $client->request('GET', $this->server_validation_url, [
				'query' => [
					$this->query_ticket_parameter => $request->get($this->query_ticket_parameter),
					$this->query_service_parameter => $this->removeCasTicket($request->getUri())
				]
			]);
			if ($response) {
				$string = $response->getBody()->getContents();


				// TODO Ici il faudrait tester la validité du ticket et lever une exception

				// TODO Ici je ne suis pas sure, il faut adapter !!!
				$xml = new \SimpleXMLElement($string, 0, false, $this->xml_namespace, true);
				if (isset($xml->authenticationSuccess)) {
					return (array)$xml->authenticationSuccess;
				} else {
					throw new \Exception("Authentification caca: $string");
				}
			} else {
				throw new \Exception("Authentification caca");
			}
		}
		return null;
	}

	/**
	 * Calls the UserProvider providing a valid User
	 *
	 * @param mixed $credentials
	 * @param UserProviderInterface $userProvider
	 * @return null|UserInterface
	 * @throws \Exception
	 */
	public function getUser($credentials, UserProviderInterface $userProvider)
	{
		if (!isset($credentials[$this->username_attribute])) {
			return;
		}

		$username = $credentials[$this->username_attribute];

		// Get all known infos of User from INPN
		$client = new Client($this->options);

		$url = $this->webservice_authentication . "/$username/?verify=false";

		$response = $client->request('GET', $this->webservice_authentication . "/$username/", [
			'verify' => false,
			'auth' => $this->authentication_options,
		]);

		// Todo gérer les codes d'erreur, voir code Stéphane
		if (!$response) {
			throw new \Exception("Le webservice d'authentification INPN ne répond pas.");
		}
		$string = $response->getBody()->getContents();
		$distantUser = json_decode($string);
		// todo: vérifier que $distantUser->id !== null (ça arrive si on envoie le mauvais user

		$em = $this->doctrine->getManager();
		$userRepo = $this->doctrine->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
		$providerRepo = $this->doctrine->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Provider', 'website');
		$roleRepo = $this->doctrine->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Role', 'website');

		// Todo: organisme du user: le récupérer et/oucréer ?
		// todo à changer quand on aura le code organisme dans le webservice
		$provider = $providerRepo->find(1);

		// Todo teste si le user existe dans la base, sinon le créer, puis synchroniser
		$user = $userRepo->find($username);
		if (!$user) {
			$user = new User();
		}
		// Create or synchronize local User with distant User from webservice
		$user
			->setLogin($username)
			->setUsername($distantUser->prenom . " " . $distantUser->nom)
			->setEmail("X." . uniqid() . "@nullepart.fr") // todo à changer quand on aura récpéré l'email via le webservice
			->setProvider($provider);

		// todo: attribuer le rôle par défaut (seulement pour les NOUVEAUX user)
		$role = $roleRepo->find(1);
		$user->addRole($role);

		$em->persist($user);
		$em->flush();

		// Puis le charger
		return $userProvider->loadUserByUsername($username);
	}

	/**
	 * Mandatory but not in use in a remote authentication
	 * @param $credentials
	 * @param UserInterface $user
	 * @return bool
	 */
	public function checkCredentials($credentials, UserInterface $user)
	{
		return true;
	}
	/**
	 * Mandatory but not in use in a remote authentication
	 * @param Request $request
	 * @param TokenInterface $token
	 * @param $providerKey
	 * @return null
	 */
	public function onAuthenticationSuccess(Request $request, TokenInterface $token, $providerKey)
	{
		// If authentication was successful, redirect to the current URI with
		// the ticket parameter removed so that it is hidden from end-users.
		if ($request->query->has($this->query_ticket_parameter)) {
			return new RedirectResponse($this->removeCasTicket($request->getUri()));
		} else {
			return null;
		}
	}
	/**
	 * Mandatory but not in use in a remote authentication
	 * @param Request $request
	 * @param AuthenticationException $exception
	 * @return JsonResponse
	 */
	public function onAuthenticationFailure(Request $request, AuthenticationException $exception)
	{
		// todo gérer ça mieux : exception + logger ???

		$data = array(
			'message' => strtr($exception->getMessageKey(), $exception->getMessageData())
		);
		return new JsonResponse($data, 403);
	}
	/**
	 * Called when authentication is needed, redirect to your CAS server authentication form
	 */
	public function start(Request $request, AuthenticationException $authException = null)
	{
		return new RedirectResponse($this->server_login_url.'?'.$this->query_service_parameter.'='.urlencode($request->getUri()));
	}
	/**
	 * Mandatory but not in use in a remote authentication
	 * @return bool
	 */
	public function supportsRememberMe()
	{
		return false;
	}
	/**
	 * Strip the CAS 'ticket' parameter from a uri.
	 */
	protected function removeCasTicket($uri) {
		$parsed_url = parse_url($uri);
		// If there are no query parameters, then there is nothing to do.
		if (empty($parsed_url['query'])) {
			return $uri;
		}
		parse_str($parsed_url['query'], $query_params);
		// If there is no 'ticket' parameter, there is nothing to do.
		if (!isset($query_params[$this->query_ticket_parameter])) {
			return $uri;
		}
		// Remove the ticket parameter and rebuild the query string.
		unset($query_params[$this->query_ticket_parameter]);
		if (empty($query_params)) {
			unset($parsed_url['query']);
		} else {
			$parsed_url['query'] = http_build_query($query_params);
		}
		// Rebuild the URI from the parsed components.
		// Source: https://secure.php.net/manual/en/function.parse-url.php#106731
		$scheme   = isset($parsed_url['scheme']) ? $parsed_url['scheme'] . '://' : '';
		$host     = isset($parsed_url['host']) ? $parsed_url['host'] : '';
		$port     = isset($parsed_url['port']) ? ':' . $parsed_url['port'] : '';
		$user     = isset($parsed_url['user']) ? $parsed_url['user'] : '';
		$pass     = isset($parsed_url['pass']) ? ':' . $parsed_url['pass']  : '';
		$pass     = ($user || $pass) ? "$pass@" : '';
		$path     = isset($parsed_url['path']) ? $parsed_url['path'] : '';
		$query    = isset($parsed_url['query']) ? '?' . $parsed_url['query'] : '';
		$fragment = isset($parsed_url['fragment']) ? '#' . $parsed_url['fragment'] : '';
		return "$scheme$user$pass$host$port$path$query$fragment";
	}
}