<?php
namespace Ign\Bundle\GincoBundle\EventListener;

use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\HttpKernel;
use Symfony\Component\DependencyInjection\ContainerAwareInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface;
use Symfony\Component\Routing\RouterInterface;

/**
 * Listen kernel requests.
 * Redirect users without provider and with permision to declare it to user_home page.
 */
class UserRedirectListener implements ContainerAwareInterface {

	protected $tokenStorage;

	protected $router;
	
	protected $container ;

	public function __construct(TokenStorageInterface $t, RouterInterface $r) {
		$this->tokenStorage = $t;
		$this->router = $r;
	}
	
	public function setContainer(ContainerInterface $container = null) {
		$this->container = $container;
	}

	/**
	 *
	 * @param GetResponseEvent $event        	
	 */
	public function onKernelRequest(GetResponseEvent $event) {
		$request = $event->getRequest();
		$route = $request->get('_route');
		
		if (!$event->isMasterRequest()) {
			return;
		}
		
		if ('_wdt' === $route) {
			return;
		}
		
		$token = $this->tokenStorage->getToken();
		$user = null;
		if ($token) {
			$user = $token->getUser();
		}
		
		if ($user) {
			// If user is not connected, do nothing
			if ('anon.' === $user) {
				return;
			} else {
				// User has provider or cannot declare it : do nothing
				if ($user->getProvider()->getId() != 0 || !$user->isAllowed('MANAGE_OWN_PROVIDER')) {
					return;
				}
				
				// Authorize homepage and own provider declaration pages
				if ('user_home' === $route || 'search_providers' === $route || 'homepage' === $route || 'user_logout' === $route) {
					return;
				}
				
				// For other pages, redirect
				$response = new RedirectResponse($this->router->generate('user_home'));
				$event->setResponse($response);
			}
		}
	}
}