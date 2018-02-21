<?php
namespace Ign\Bundle\OGAMBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Ign\Bundle\OGAMBundle\Form\ChangeUserPasswordType;
use Ign\Bundle\OGAMBundle\Form\ChangeForgottenPasswordType;
use Ign\Bundle\OGAMBundle\Entity\Website\User;

/**
 * @Route("/user")
 */
class UserController extends GincoController {

	/**
	 * Default action.
	 *
	 * @Route("/", name = "user_home")
	 */
	public function indexAction(Request $request) {
		// Display the login form by default
		return $this->showLoginFormAction($request);
	}

	/**
	 * Show the change password form.
	 *
	 * @Route("/changePassword", name = "user_changepassword")
	 */
	public function changePasswordAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('changePasswordAction');

		// Get the current user
		$user = $this->getUser();

		// Get the change password form
		$form = $this->createForm(ChangeUserPasswordType::class, $user);

		$form->handleRequest($request);

		if ($form->isSubmitted() && $form->isValid()) {
			// $form->getData() holds the submitted values
			// but, the original `$user` variable has also been updated
			$user = $form->getData();

			// Check that the old password is correct
			$encoder = $this->get('ogam.challenge_response_encoder');
			$oldPassword = $form->get('oldpassword')->getData();
			$cryptedOldPassword = $encoder->encodePassword($oldPassword, '');

			if ($user->getPassword() !== $cryptedOldPassword) {
				$this->addFlash('error', "Old password is not correct");
				return $this->redirectToRoute('homepage');
			}

			// Encrypt the password if in creation mode
			if (!empty($user->getPlainPassword())) {
				$password = $encoder->encodePassword($user->getPlainPassword(), '');
				$user->setPassword($password);
			}

			// Save the user
			$em = $this->getDoctrine()->getManager();
			$em->persist($user);
			$em->flush();

			$this->addFlash('success', $this->get('translator')
				->trans('Your password has been changed.'));

			return $this->redirectToRoute('homepage');
		}

		return $this->render('OGAMBundle:User:change_password.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Display the login form.
	 *
	 * @Route("/login", name = "user_login")
	 */
	public function showLoginFormAction(Request $request) {
		$authenticationUtils = $this->get('security.authentication_utils');

		// get the login error if there is one
		$error = $authenticationUtils->getLastAuthenticationError();

		// last username entered by the user
		$lastUsername = $authenticationUtils->getLastUsername();

		// generate a new challenge
		$encoder = $this->get('ogam.challenge_response_encoder');
		$challenge = $encoder->generateChallenge();

		// Store the challenge in session
		$session = $request->getSession();
		$session->set('challenge', $challenge);

		// Display the login form
		return $this->render('OGAMBundle:User:login_form.html.twig', array(
			// last username entered by the user
			'last_username' => $lastUsername,
			'error' => $error,
			'challenge' => $challenge
		));
	}

	/**
	 * Display the forgotten password form.
	 *
	 * @Route("/forgottenpassword", name = "user_forgotten_password")
	 */
	public function forgottenPasswordFormAction(Request $request) {
		$form = $this->createFormBuilder()
			->add('email', EmailType::class, array(
			'label' => 'Email'
		))
			->add('send', SubmitType::class, array(
			'label' => 'Submit'
		))
			->getForm();

		$form->handleRequest($request);

		if ($form->isSubmitted() && $form->isValid()) {

			$email = $form->get('email')->getData();

			// On récupère les infos sur l'utilisateur
			$userRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
			$user = $userRepo->findOneByEmail($email);

			// Send an email only if a user with this email has been found
			if ($user) {

				// On génère un nouveau code d'activation
				$encoder = $this->get('ogam.challenge_response_encoder');
				$codeActivation = $encoder->generateChallenge();

				$user->setActivationCode($codeActivation);

				$em = $this->getDoctrine()->getManager();
				$em->persist($user);
				$em->flush();

				// Send the email
				$this->get('app.mail_manager')->sendEmail(
					'OGAMBundle:Emails:forgotten_password.html.twig',
					array(
						'user' => $user,
					),
					$user->getEmail()
				);
			}

			// In both cases (user is found or not), display a confirmation message
			$this->addFlash('success', $this->get('translator')->trans("Password_change_request_msg", array("%email%" => $email)));
			return $this->showLoginFormAction($request);

		} else {

			// Display the forgotten password form
			return $this->render('OGAMBundle:User:forgotten_password.html.twig', array(
				'form' => $form->createView()
			));
		}
	}

	/**
	 * Validate the password change request for forgotten password.
	 *
	 * @Route("/validateForgottenPassword", name = "user_validateForgottenPassword")
	 */
	public function validateForgottenPasswordAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('validateForgottenPasswordAction');

		// Get URL parameters
		$login = $request->query->get('login');
		$activationCode = $request->query->get('activationCode');

		$userRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
		$user = $userRepo->findOneByLogin($login);

		if ($user == null) {
			$this->addFlash('error', 'The user does not exist.');
			return $this->redirectToRoute('homepage');
		}
		// Check the activation code to confirm this is the correct user
		if ($activationCode !== $user->getActivationCode()) {
			$this->addFlash('error', 'The activation code is not valid, check that you have used the last received email.');
			return $this->redirectToRoute('homepage');
		}

		// Get the change password form
		$form = $this->createForm(ChangeForgottenPasswordType::class, $user);

		$form->handleRequest($request);

		// Display the change password form
		if ($form->isSubmitted() && $form->isValid()) {

			// Encrypt the password
			$encoder = $this->get('ogam.challenge_response_encoder');
			$plainPassword = $form->get('plainPassword')->getData();
			$password = $encoder->encodePassword($plainPassword, '');
			$user->setPassword($password);

			// Save the user
			$em = $this->getDoctrine()->getManager();
			$em->persist($user);
			$em->flush();

			// Display a confirmation message
			$this->addFlash('success', 'Your password has been changed.');
			return $this->redirectToRoute('homepage');
		}

		return $this->render('OGAMBundle:User:change_password.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Logout.
	 *
	 * @Route("/logout", name = "user_logout")
	 */
	public function logoutAction() {
		// Nothing to do, the security module redirects automatically to the homepage (cf security.yml)
	}

	/**
	 * Validate the login.
	 *
	 * @Route("/validateLogin", name = "user_validatelogin")
	 */
	public function validateLoginAction() {
		// Nothing to do, the security module redirects automatically to the homepage (cf security.yml)
		return new Response();
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
	    return $this->render('OGAMBundle:User:get_current_user.json.twig', array(
	        'data' => $this->getUser()
	    ), $response);
	}
}
