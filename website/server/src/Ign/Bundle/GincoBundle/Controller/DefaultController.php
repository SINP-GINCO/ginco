<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Doctrine\Common\Collections\ArrayCollection;
use Ign\Bundle\GincoBundle\Entity\Website\Content;
use Ign\Bundle\GincoBundle\Form\ConfigurationType;
use Ign\Bundle\GincoBundle\Form\HomepageContentType;
use Ign\Bundle\GincoBundle\Form\ContactType;
use Ign\Bundle\OGAMBundle\Controller\DefaultController as BaseController;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class DefaultController extends BaseController {

	// Max number of links of each type displayed on homepage
	private $numLinks = 5;

	/**
	 * @Route("/", name="homepage")
	 */
	public function indexAction() {

		// Get configurable content for homepage, from content table
		$contentRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Content', 'website');
		$content = array();
		$content['title'] = $contentRepo->find('homepage.title')->getValue();
		$content['intro'] = $contentRepo->find('homepage.intro')->getValue();
		$content['image'] = $contentRepo->find('homepage.image')->getValue();
		$content['publicLinksTitle'] = $contentRepo->find('homepage.links.title')->getValue();
		$content['privateLinksTitle'] = $contentRepo->find('homepage.private.links.title')->getValue();

		$getValue = function($content) {
			return $content->getJsonDecodedValue();
		};
		$homepageLink = array();
		$homepageDoc = array();
		$homepagePrivateLink = array();
		$homepagePrivateDoc = array();
		for ($i=1; $i<=$this->numLinks; $i++) {
			$homepageLink[$i] = $contentRepo->find("homepage.link.$i");
			$homepageDoc[$i] = $contentRepo->find("homepage.doc.$i");
			$homepagePrivateLink[$i] = $contentRepo->find("homepage.private.link.$i");
			$homepagePrivateDoc[$i] = $contentRepo->find("homepage.private.doc.$i");
		}
		$content['links'] = array_map($getValue, $homepageLink);
		$content['docs'] = array_map($getValue, $homepageDoc);
		$content['privateLinks'] = array_map($getValue, $homepagePrivateLink);
		$content['privateDocs'] = array_map($getValue, $homepagePrivateDoc);

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
	 * @Route("/configuration/homepage", _name="configuration_homepage")
	 */
	public function configurationHomepageAction(Request $request) {
		$em = $this->getDoctrine()->getManager();
		$contentRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Content', 'website');

		// Get homepage intro html, image, links title and links
		$homepageTitle = $contentRepo->find('homepage.title');
		$homepageIntro = $contentRepo->find('homepage.intro');
		$homepageImage = $contentRepo->find('homepage.image');
		$homepagePublicLinksTitle = $contentRepo->find('homepage.links.title');
		$homepagePrivateLinksTitle = $contentRepo->find('homepage.private.links.title');

		$getValue = function($content) {
			return $content->getValue();
		};

		$homepageLink = array();
		$homepageDoc = array();
		$homepagePrivateLink = array();
		$homepagePrivateDoc = array();
		for ($i=1; $i<=$this->numLinks; $i++) {
			$homepageLink[$i] = $contentRepo->find("homepage.link.$i");
			$homepageDoc[$i] = $contentRepo->find("homepage.doc.$i");
			$homepagePrivateLink[$i] = $contentRepo->find("homepage.private.link.$i");
			$homepagePrivateDoc[$i] = $contentRepo->find("homepage.private.doc.$i");
		}
		$homepageLinkValue = array_map($getValue, $homepageLink);
		$homepageDocValue = array_map($getValue, $homepageDoc);
		$homepagePrivateLinkValue = array_map($getValue, $homepagePrivateLink);
		$homepagePrivateDocValue = array_map($getValue, $homepagePrivateDoc);

		// Set default value(s)

		$data = array(
			'homepageTitle' => $homepageTitle->getValue(),
			'homepageIntro' => $homepageIntro->getValue(),
			'homepageImage' => $homepageImage->getValue(),
			'homepagePublicLinksTitle' => $homepagePublicLinksTitle->getValue(),
			'homepagePrivateLinksTitle' => $homepagePrivateLinksTitle->getValue(),
			'homepageLinks' => $homepageLinkValue,
			'homepageDocs' => $homepageDocValue,
			'homepagePrivateLinks' => $homepagePrivateLinkValue,
			'homepagePrivateDocs' => $homepagePrivateDocValue,
		);
		$form = $this->createForm(new HomepageContentType(), $data, array(
			'action' => $this->generateUrl('configuration_homepage'),
			'method' => 'POST'
		));

		$form->handleRequest($request);

		if ($form->isValid()) {

			// Persist the value
			$homepageTitle->setValue($form->get('homepageTitle')->getData());
			$homepageIntro->setValue($form->get('homepageIntro')->getData());
			$homepageImage->setValue($form->get('homepageImage')->getData());
			$homepagePublicLinksTitle->setValue($form->get('homepagePublicLinksTitle')->getData());
			$homepagePrivateLinksTitle->setValue($form->get('homepagePrivateLinksTitle')->getData());
			$homepageLinkValue = $form->get('homepageLinks')->getData();
			$homepageDocValue = $form->get('homepageDocs')->getData();
			$homepagePrivateLinkValue = $form->get('homepagePrivateLinks')->getData();
			$homepagePrivateDocValue = $form->get('homepagePrivateDocs')->getData();

			for ($i=1; $i<=$this->numLinks; $i++) {
				$homepageLink[$i]->setValue($homepageLinkValue[$i]);
				$homepageDoc[$i]->setValue($homepageDocValue[$i]);
				$homepagePrivateLink[$i]->setValue($homepagePrivateLinkValue[$i]);
				$homepagePrivateDoc[$i]->setValue($homepagePrivateDocValue[$i]);
			}
			$em->flush();

			$request->getSession()
				->getFlashBag()
				->add('success', 'Configuration.edit.submit.success');

			return $this->redirect($this->generateUrl('configuration_homepage'));
		}

		return $this->render('IgnGincoBundle:Default:configuration_homepage.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Configuration Presentation page form page
	 * Editable parameters:
	 *
	 * @Route("/configuration/presentation", _name="configuration_presentation")
	 */
	public function configurationPresentationAction(Request $request) {
		$em = $this->getDoctrine()->getManager();
		$contentRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Content', 'website');

		// Get homepage intro html
		$homepageIntro = $contentRepo->find('homepage.intro');
		// Links
		$homepageLink = $contentRepo->find('homepage.link');
		// File
		$homepageFile = $contentRepo->find('homepage.file');
		// File
		$homepageImage = $contentRepo->find('homepage.image');

		// Set default value(s)
		$data = array(
			'homepageIntro' => $homepageIntro->getValue(),
			'homepageLink' => $homepageLink->getValue(),
			'homepageFile' => $homepageFile->getValue(),
			'homepageImage' => $homepageImage->getValue(),
		);

		$form = $this->createForm(new HomepageContentType(), $data, array(
			'action' => $this->generateUrl('configuration_presentation'),
			'method' => 'POST'
		));

		$form->handleRequest($request);

		if ($form->isValid()) {

			// Persist the value
			$homepageIntro->setValue($form->get('homepageIntro')->getData());
			$homepageLink->setValue($form->get('homepageLink')->getData());
			$homepageFile->setValue($form->get('homepageFile')->getData());
			$homepageImage->setValue($form->get('homepageImage')->getData());
			$em->flush();

			$request->getSession()
				->getFlashBag()
				->add('success', 'Configuration.edit.submit.success');

			return $this->redirect($this->generateUrl('configuration_presentation'));
		}

		return $this->render('IgnGincoBundle:Default:configuration_presentation.html.twig', array(
			'form' => $form->createView()
		));
	}
}
