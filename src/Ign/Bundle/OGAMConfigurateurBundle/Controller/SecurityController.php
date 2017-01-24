<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Security\Core\SecurityContext;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\Security\Core\Exception\UsernameNotFoundException;
use Symfony\Component\Security\Core\Authentication\Token\PreAuthenticatedToken;
use Symfony\Component\Security\Http\Event\InteractiveLoginEvent;
use Symfony\Component\Security\Http\SecurityEvents;
use Symfony\Component\Config\Definition\Exception\Exception;
use Symfony\Component\HttpFoundation\Session\Session;

/**
 * This controller allows to interface with the session started by Ogam via Zend Framework 1.
 *
 * @author Gautam Pastakia
 *
 */
class SecurityController extends Controller {

	/**
	 * Authenticates automatically the user based on ZF1 session cookie.
	 *
	 * @Route("/login/", name="configurateur_login")
	 */
	public function loginAction(Request $request) {
		// Retrieve the user bag
		$user = $this->get('session')
			->getBag('user')
			->get('user');
		// Checks : first case is for unit testing, the other is for prod
		if (is_string($user)) {
			$login = $user;
		} else if (get_class($user) == '__PHP_Incomplete_Class') {
			$obj = $this->casttoclass('stdClass', $user);
		}
		// If user information is present, proceed to login
		if (isset($obj) || isset($login)) {
			if ((isset($obj) && property_exists($obj, 'login')) || isset($login)) {
				if (!isset($login)) {
					$login = $obj->login;
				}
				$em = $this->getDoctrine();
				$repo = $em->getRepository("IgnOGAMConfigurateurBundle:User");
				$user = $repo->find($login);
				if (!$user) {
					throw new UsernameNotFoundException("User not found");
				} else {
					// Get user permissions (only a user with a role containing the CONFIGURE_METAMODEL permission is authorized)
					$roles = $em->getRepository("IgnOGAMConfigurateurBundle:Role")->findPermissionsByUser($user);
					$token = new PreAuthenticatedToken($user, null, "main", $roles);
					// Login the user via use of token
					$this->get("security.token_storage")->setToken($token);
					// Dispatch the login event
					$event = new InteractiveLoginEvent($request, $token);
					$this->get("event_dispatcher")->dispatch(SecurityEvents::INTERACTIVE_LOGIN, $event);
				}
				return $this->redirectToRoute('configurateur_homepage');
			}
		} else {
			// Redirect to Ogam user login page
			return new RedirectResponse($request->getSchemeAndHttpHost() . '/user/');
		}
	}

	/**
	 * Allows to read attributes of a __php_incomplete_class.
	 * In our case, we're reading values from session file which are objects that Ogam specfic php types.
	 * We don't know about them in the configurator. Thus the need of this function.
	 *
	 * @param unknown $class
	 * @param unknown $object
	 */
	private function casttoclass($class, $object) {
		return unserialize(preg_replace('/^O:\d+:"[^"]++"/', 'O:' . strlen($class) . ':"' . $class . '"', serialize($object)));
	}
}