<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Form\ChangeForgottenPasswordType;
use Ign\Bundle\GincoBundle\Form\ChangeUserPasswordType;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
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
class UserController extends GincoController {

	/**
	 * Default action: a "my account" page
	 * Todo, maybe in the future: show personal Jdd.
	 *
	 * @Route("/", name = "user_home")
	 */
	public function indexAction(Request $request) {
		// Check if user is logged in; if not redirect to login
		// It is because this route is not protected in security.yml)
		if (!$this->get('security.authorization_checker')->isGranted('IS_AUTHENTICATED_FULLY')) {
			throw $this->createAccessDeniedException();
		}
		// No need to pass the user, it is already in app.user
		return $this->render('IgnGincoBundle:User:index.html.twig', array(
		));
	}

	/**
	 * Refresh user infos from INPN webservice
	 * If login is not given, refresh infos of current user
	 * @Route("/refresh/{username}", name = "user_refresh")
	 */
	public function refreshAction(Request $request, $username = null) {

		if (!$username) {
			// Get username
			if (!$this->get('security.authorization_checker')->isGranted('IS_AUTHENTICATED_FULLY')) {
				throw $this->createAccessDeniedException();
			}
			$username = $this->getUser()->getLogin();
		}

		// Update via the INPN webservice
		$user = $this->get('ginco.inpn_user_updater')->updateOrCreateLocalUser($username);

		// If user not found, flash message
		if (!$user) {
			$this->addFlash('warning', $this->get('translator')
				->trans('User.refresh.notfound'));
		}

		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('user_home');
		return $this->redirect($redirectUrl);
	}

	/**
	 * Display the login form from the CAS.
	 *
	 * @Route("/login", name = "user_login")
	 */
	public function showLoginFormAction(Request $request) {
		$CASloginUrl = $this->get('ginco.configuration_manager')->getConfig('CAS_login_url');
		$CASservice = $this->get('ginco.configuration_manager')->getConfig('CAS_service_parameter');
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
		$CASlogoutUrl = $this->get('ginco.configuration_manager')->getConfig('CAS_logout_url');
		$CASservice = $this->get('ginco.configuration_manager')->getConfig('CAS_service_parameter');
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
	
	/**
	 * Return the current logged user
	 *
	 * @Route("/currentuser", name="current_user")
	 */
	public function getCurrentUserAction() {
		$logger = $this->get('logger');
		$logger->debug('getCurrentUserAction');
	
		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('IgnGincoBundle:User:get_current_user.json.twig', array(
			'data' => $this->getUser()
		), $response);
	}
}
