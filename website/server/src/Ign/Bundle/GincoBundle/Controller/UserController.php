<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Ign\Bundle\OGAMBundle\Form\ChangeUserPasswordType;
use Ign\Bundle\OGAMBundle\Form\ChangeForgottenPasswordType;
use Ign\Bundle\OGAMBundle\Entity\Website\User;
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

	protected $casBaseUrl = 'XXX';

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
		return new RedirectResponse('https://inpn2.mnhn.fr/auth/login?service='.urlencode($this->generateUrl('homepage',array(),UrlGeneratorInterface::ABSOLUTE_URL)));
	}

	/**
	 * Logout from CAS, then redirects to application logout.
	 *
	 * @Route("/logout", name = "user_logout")
	 */
	public function CASlogoutAction() {
		$redirectUrl = urlencode($this->generateUrl('app_logout', array(),UrlGeneratorInterface::ABSOLUTE_URL));
		// todo: je ne sais absolument pas si il faut mettre le param url ou pas ?
		return new RedirectResponse("https://inpn2.mnhn.fr/auth/logout?url=$redirectUrl&service=$redirectUrl");
		// Nothing to do, the security module redirects automatically to the homepage (cf security.yml)
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
		throw $this->createNotFoundException('To manage your user account settings, please visit '.$this->casBaseUrl);
	}

	/**
	 * No more password operations.
	 * @Route("/forgottenpassword", name = "user_forgotten_password")
	 */
	public function forgottenPasswordFormAction(Request $request) {
		return new Response('To manage your user account settings, please visit '.$this->casBaseUrl, Response::HTTP_NOT_FOUND);
	}

	/**
	 * No more password operations.
	 * @Route("/validateForgottenPassword", name = "user_validateForgottenPassword")
	 */
	public function validateForgottenPasswordAction(Request $request) {
		return new Response('To manage your user account settings, please visit '.$this->casBaseUrl, Response::HTTP_NOT_FOUND);
	}

	/**
	 * No more login operations.
	 * @Route("/validateLogin", name = "user_validatelogin")
	 */
	public function validateLoginAction() {
		return new Response('To manage your user account settings, please visit '.$this->casBaseUrl, Response::HTTP_NOT_FOUND);
	}
}
