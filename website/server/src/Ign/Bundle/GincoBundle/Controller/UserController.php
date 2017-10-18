<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Ign\Bundle\OGAMBundle\Controller\UserController as BaseController;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

/**
 * Extends the UserController from OGAM in order
 * to invalidate the login form and the logout, to
 * replace it by CAS login and logout redirections.
 * We also invalidate all the no more useful account managment:
 * i.e. password operations.
 *
 * @author SCandelier
 *
 * @Route("/user")
 */
class UserController extends BaseController {

	/**
	 * Default action. todo: redirect to INPN user ou 404
	 *
	 * @Route("/", name = "user_home")
	 */
	public function indexAction(Request $request) {
		// Display the login form by default
		return $this->showLoginFormAction($request);
	}

	/**
	 * Display the login form from the CAS.
	 *
	 * @Route("/login", name = "user_login")
	 */
	public function showLoginFormAction(Request $request) {
		$CASloginUrl = $this->get('ogam.configuration_manager')->getConfig('CAS_login_url');
		$CASservice = $this->get('ogam.configuration_manager')->getConfig('CAS_service_parameter');
		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ?: $this->generateUrl('homepage',array(),UrlGeneratorInterface::ABSOLUTE_URL);
		$CASloginUrl .= '?' . $CASservice . '=' . urlencode($redirectUrl);
		return new RedirectResponse($CASloginUrl);
	}

	/**
	 * Logout from CAS, then redirects to application logout.
	 *
	 * @Route("/logout", name = "user_logout")
	 */
	public function CASlogoutAction() {
		$CASlogoutUrl = $this->get('ogam.configuration_manager')->getConfig('CAS_logout_url');
		$CASservice = $this->get('ogam.configuration_manager')->getConfig('CAS_service_parameter');
		$redirectUrl = urlencode($this->generateUrl('app_logout', array(),UrlGeneratorInterface::ABSOLUTE_URL));
		$CASlogoutUrl .= '?' . $CASservice . '=' . $redirectUrl;
		return new RedirectResponse($CASlogoutUrl);
	}

	/**
	 * Logout from the application.
	 *
	 * @Route("/applogout", name = "app_logout")
	 */
	public function logoutAction() {
		// todo: mettre un test sur le referer pour empêcher l'appel direct de la page
		$test=1;
		// Nothing to do, the security module redirects automatically to the homepage (cf security.yml)
	}

	/**
	 * No more password operations.
	 * @Route("/changePassword", name = "user_changepassword")
	 */
	public function changePasswordAction(Request $request) {
		throw $this->createNotFoundException('To manage your user account settings, please visit INPN website');
	}

	/**
	 * No more password operations.
	 * @Route("/forgottenpassword", name = "user_forgotten_password")
	 */
	public function forgottenPasswordFormAction(Request $request) {
		throw $this->createNotFoundException('To manage your user account settings, please visit INPN website');
	}

	/**
	 * No more password operations.
	 * @Route("/validateForgottenPassword", name = "user_validateForgottenPassword")
	 */
	public function validateForgottenPasswordAction(Request $request) {
		throw $this->createNotFoundException('To manage your user account settings, please visit INPN website');
	}

	/**
	 * No more login operations.
	 * @Route("/validateLogin", name = "user_validatelogin")
	 */
	public function validateLoginAction() {
		throw $this->createNotFoundException('To manage your user account settings, please visit INPN website');
	}
}
