<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Form\ConfigurationType;
use Ign\Bundle\GincoBundle\Form\HomepageContentType;
use Ign\Bundle\GincoBundle\Form\ContactType;
use Ign\Bundle\OGAMBundle\Controller\DefaultController as BaseController;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class DefaultController extends BaseController {

	/**
	 * @Route("/", name="homepage")
	 */
	public function indexAction() {

		$contentRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Content', 'website');
		$content = array();

		// Get content for homepage
		$content['intro'] = $contentRepo->find('homepage.intro');

		return $this->render('IgnGincoBundle:Default:index.html.twig', array(
			'content' => $content
		));
	}

	/**
	 * Contact form page
	 *
	 * @Route("/contact", _name="contact")
	 */
	public function contactAction(Request $request) {
		$form = $this->createForm(new ContactType(), null, array(
			'action' => $this->generateUrl('contact'),
			'method' => 'POST'
		));

		if ($request->isMethod('POST')) {
			// Refill the fields in case the form is not valid.
			$form->handleRequest($request);

			if ($form->isValid()) {
				// Contact recipients
				$contactRecipients = $this->get('ogam.configuration_manager')->getConfig('contactEmail', 'sinp-dev@ign.fr');
				$contactRecipients = explode(',', $contactRecipients);

				// Send the email
				$this->get('app.mail_manager')->sendEmail('IgnGincoBundle:Emails:contact.html.twig', array(
					'email' => $form->get('email')
						->getData(),
					'message' => $form->get('message')
						->getData()
				), $contactRecipients);

				$request->getSession()
					->getFlashBag()
					->add('success', 'Contact.send.success');

				return $this->redirect($this->generateUrl('contact'));
			}
		}

		return $this->render('IgnGincoBundle:Default:contact.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Configuration parameters form page
	 * Editable parameters:
	 * - contact email address
	 *
	 * @Route("/configuration/parameters", _name="configuration_parameters")
	 */
	public function configurationParametersAction(Request $request) {
		$em = $this->getDoctrine()->getManager();
		$confRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\ApplicationParameter', 'website');

		// Get contact Email
		$emailConf = $confRepo->find('contactEmail');

		$form = $this->createForm(new ConfigurationType(), null, array(
			'action' => $this->generateUrl('configuration_parameters'),
			'method' => 'POST'
		));

		// Set default value(s)
		$form->get('contactEmail')->setData($emailConf->getValue());

		$form->handleRequest($request);

		if ($form->isValid()) {

			$contactEmail = $form->get('contactEmail')->getData();
			// Remove all spaces around email adresses (separetd by commas)
			$contactEmail = implode(',', array_map('trim', explode(',', $contactEmail)));
			$emailModified = $emailConf->getValue() != $contactEmail;

			// Persist the value
			$emailConf->setValue($contactEmail);
			$em->flush();

			$request->getSession()
				->getFlashBag()
				->add('success', 'Configuration.edit.submit.success');
			if ($emailModified) {
				$request->getSession()
					->getFlashBag()
					->add('success', 'Configuration.edit.email.success');
			}

			return $this->redirect($this->generateUrl('configuration_parameters'));
		}

		return $this->render('IgnGincoBundle:Default:configuration_parameters.html.twig', array(
			'form' => $form->createView()
		));
	}


	/**
	 * Configuration Content form page
	 * Editable parameters:
	 *
	 * @Route("/configuration/content", _name="configuration_content")
	 */
	public function configurationContentAction(Request $request) {
		$em = $this->getDoctrine()->getManager();
		$contentRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Content', 'website');

		// Get homepage intro html
		$homepageIntro = $contentRepo->find('homepage.intro');

		$form = $this->createForm(new HomepageContentType(), null, array(
			'action' => $this->generateUrl('configuration_content'),
			'method' => 'POST'
		));

		// Set default value(s)
		$form->get('homepageIntro')->setData($homepageIntro->getValue());

		$form->handleRequest($request);

		if ($form->isValid()) {

			$homepageIntroValue = $form->get('homepageIntro')->getData();

			// Persist the value
			$homepageIntro->setValue($homepageIntroValue);
			$em->flush();

			$request->getSession()
				->getFlashBag()
				->add('success', 'Configuration.edit.submit.success');

			return $this->redirect($this->generateUrl('configuration_content'));
		}

		return $this->render('IgnGincoBundle:Default:configuration_content.html.twig', array(
			'form' => $form->createView()
		));
	}
}
