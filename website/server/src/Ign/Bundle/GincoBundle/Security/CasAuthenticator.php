<?php
namespace Ign\Bundle\GincoBundle\Security;

use Doctrine\Bundle\DoctrineBundle\Registry;
use Doctrine\ORM\EntityManager;
use GuzzleHttp\Client;
use Ign\Bundle\GincoBundle\Exception\CASException;
use Ign\Bundle\GincoBundle\Services\INPNUserUpdater;
use Ign\Bundle\GincoBundle\Services\ConfigurationManager;
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
 *
 * @author SCandelier (inspiration: https://github.com/PRayno/CasAuthBundle/blob/master/Security/CasAuthenticator.php)
 */
class CasAuthenticator extends AbstractGuardAuthenticator
{
	protected $doctrine;
	protected $configManager;
	protected $userUpdater;
	protected $logger;

	protected $server_login_url;
	protected $server_validation_url;
	protected $query_ticket_parameter;
	protected $query_service_parameter;
	protected $xml_namespace;
	protected $username_attribute;
	protected $webservice_authentication;
	protected $authentication_options;
	protected $options;

	/**
	 * Process configuration
	 * @param array $config
	 */
	public function __construct(Registry $doctrine, ConfigurationManager $configManager, INPNUserUpdater $userUpdater, Logger $logger)
	{
		$this->doctrine = $doctrine;
		$this->configManager = $configManager;
		$this->userUpdater = $userUpdater;
		$this->logger = $logger;

		$this->server_login_url = $this->configManager->getConfig('CAS_login_url');
		$this->server_validation_url = $this->configManager->getConfig('CAS_validation_url');
		$this->query_service_parameter = $this->configManager->getConfig('CAS_service_parameter');
		$this->query_ticket_parameter = $this->configManager->getConfig('CAS_ticket_parameter');
		$this->xml_namespace = $this->configManager->getConfig('CAS_xml_namespace');
		$this->username_attribute = $this->configManager->getConfig('CAS_username_attribute');

		$this->options = array();
		// Add proxy if needed
		$httpsProxy = $this->configManager->getConfig('https_proxy', '');
		if (!empty($httpsProxy)) {
			$this->options['proxy'] = $httpsProxy;
		}

	}
	
	public function supports(Request $request) {
		
		if ($request->get($this->query_ticket_parameter)) {
			return true ;
		}
		return false ;
	}

	/**
	 * Called on every request. Return whatever credentials you want,
	 * or null to stop authentication.
	 */
	public function getCredentials(Request $request)
	{
		// Validate ticket
		$client = new Client($this->options);
		$response = $client->request('GET', $this->server_validation_url, [
			'query' => [
				$this->query_ticket_parameter => $request->get($this->query_ticket_parameter),
				$this->query_service_parameter => $this->removeCasTicket($request->getUri())
			]
		]);

		if (!$response) {
			$this->logger->addError("INPN CAS validation service is not accessible, URL : " . $this->server_validation_url);
			throw new CASException("INPN CAS validation service is not accessible.");
		}
		$code = $response->getStatusCode();
		if ($code !== 200) {
			$this->logger->addError("INPN CAS validation service returned a HTTP code: $code, URL : " . $this->server_validation_url);
			throw new CASException("INPN CAS validation service returned a HTTP code: $code");
		}

		$string = $response->getBody()->getContents();
		$xml = new \SimpleXMLElement($string, 0, false, $this->xml_namespace, true);
		if (isset($xml->authenticationSuccess)) {
			return (array)$xml->authenticationSuccess;
		} else {
			$this->logger->addError("INPN CAS denied authentication: $string");
			throw new CASException("INPN CAS denied authentication: $string");
		}
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
		// Create or update local User with INPN authentication webservice
		$this->userUpdater->updateOrCreateLocalUser($username);
		// Load User
		$user = $userProvider->loadUserByUsername($username);
		// Update last login time
		$this->userUpdater->updateLastLogin($user);
		// Finally return user
		return $user;
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