<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\Website\Content;
use Ign\Bundle\GincoBundle\Form\ConfigurationType;
use Ign\Bundle\GincoBundle\Form\ContactType;
use Ign\Bundle\GincoBundle\Form\HomepageContentType;
use Ign\Bundle\GincoBundle\Form\PresentationContentType;
use Ign\Bundle\GincoBundle\Query\TableFormatQueryBuilder;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template ;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;


class DefaultController extends GincoController {
	
	// Max number of links of each type displayed on homepage
	private $numLinks = 5;

	/**
	 * Homepage (configurable content)
	 *
	 * @Route("/", name="homepage")
	 */
	public function indexAction() {
		
		// Get configurable content for homepage, from content table
		$contentRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Content', 'website');
		$content = array();
		$content['title'] = $contentRepo->find('homepage.title')->getValue();
		$content['intro'] = $contentRepo->find('homepage.intro')->getValue();
		$content['presentation'] = $contentRepo->find('presentation.abstract')->getValue();
		$content['image'] = $contentRepo->find('homepage.image')->getValue();
		$content['publicLinksTitle'] = $contentRepo->find('homepage.links.title')->getValue();
		$content['privateLinksTitle'] = $contentRepo->find('homepage.private.links.title')->getValue();
		
		$getValue = function ($content) {
			return $content->getJsonDecodedValue();
		};
		$homepageLink = array();
		$homepageDoc = array();
		$homepagePrivateLink = array();
		$homepagePrivateDoc = array();
		for ($i = 1; $i <= $this->numLinks; $i ++) {
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
	 * Presentation page (configurable content)
	 *
	 * @Route("/presentation", name="presentation")
	 */
	public function presentationAction() {
		
		// Get configurable content for homepage, from content table
		$contentRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Content', 'website');
		$content = array();
		$content['title'] = $contentRepo->find('presentation.title')->getValue();
		$content['intro'] = $contentRepo->find('presentation.intro')->getValue();
		$content['image'] = $contentRepo->find('presentation.image')->getValue();
		$content['publicLinksTitle'] = $contentRepo->find('presentation.links.title')->getValue();
		
		$getValue = function ($content) {
			return $content->getJsonDecodedValue();
		};
		$presentationLink = array();
		$presentationDoc = array();
		for ($i = 1; $i <= $this->numLinks; $i ++) {
			$presentationLink[$i] = $contentRepo->find("presentation.link.$i");
			$presentationDoc[$i] = $contentRepo->find("presentation.doc.$i");
		}
		$content['links'] = array_map($getValue, $presentationLink);
		$content['docs'] = array_map($getValue, $presentationDoc);
		
		return $this->render('IgnGincoBundle:Default:presentation.html.twig', array(
			'content' => $content
		));
	}

	/**
	 * Contact form page
	 *
	 * @Route("/contact", _name="contact")
	 */
	public function contactAction(Request $request) {
		$form = $this->createForm(ContactType::class, null, array(
			'action' => $this->generateUrl('contact'),
			'method' => 'POST'
		));
		
		// If user is authenticated, get his email and set as default value
		if ($this->get('security.authorization_checker')->isGranted('IS_AUTHENTICATED_FULLY')) {
			$email = $this->getUser()->getEmail();
			$form->get('email')->setData($email);
		}
		
		if ($request->isMethod('POST')) {
			// Refill the fields in case the form is not valid.
			$form->handleRequest($request);
			
			if ($form->isValid()) {
				// Contact recipients
				$contactRecipients = $this->get('ginco.configuration_manager')->getConfig('contactEmail', 'sinp-dev@ign.fr');
				$contactRecipients = explode(',', $contactRecipients);
				
                                $parameters = array(
					'email' => $form->get('email')->getData(),
                                        'subject' => $form->get('subject')->getData(),
					'message' => $form->get('message')->getData(),
					'sender' => $form->get('sender')->getData(),
					'job' => $form->get('job')->getData()
				);
                                                                
				// Send the email
				$this->get('app.mail_manager')->sendEmail('IgnGincoBundle:Emails:contact.html.twig', $parameters , $contactRecipients);
				
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
		$confRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\ApplicationParameter', 'website');
		
		// Get contact Email
		$emailConf = $confRepo->find('contactEmail');
		$resultsEPSGConf = $confRepo->find('srs_results');
		
		// Get default role
		$roleRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Role', 'website');
		$defaultRole = $roleRepo->findOneByIsDefault(true);
		
		$form = $this->createForm(ConfigurationType::class, null, array(
			'action' => $this->generateUrl('configuration_parameters'),
			'method' => 'POST',
			'defaultRole' => $defaultRole
		));
		
		// Set default values
		$form->get('contactEmail')->setData($emailConf->getValue());
		$form->get('srs_results')->setData($resultsEPSGConf->getValue());
		
		$form->handleRequest($request);
		
		if ($form->isValid()) {
			
			$contactEmail = $form->get('contactEmail')->getData();
			// Remove all spaces around email adresses (separetd by commas)
			$contactEmail = implode(',', array_map('trim', explode(',', $contactEmail)));
			$emailModified = $emailConf->getValue() != $contactEmail;
			
			// Persist the value
			$emailConf->setValue($contactEmail);
			
			$resultsEPSG = $form->get('srs_results')->getData();
			$resultsEPSGModified = $resultsEPSGConf->getValue() != $resultsEPSG;
			
			// Persist the value
			$resultsEPSGConf->setValue($resultsEPSG);
			
			// Persist the default role chosen if it has been changed
			$newDefaultRole = $form->get('defaultRole')->getData();
			if ($newDefaultRole->getCode() != $defaultRole->getCode()) {
				// Remove the default value of the former default role
				$roleRepo->removeDefaultValue();
				$newDefaultRole->setIsDefault(true);
			}
			$em->flush();
			
			$request->getSession()
				->getFlashBag()
				->add('success', 'Configuration.edit.submit.success');
			if ($emailModified) {
				$request->getSession()
					->getFlashBag()
					->add('success', [
						'id' => 'Configuration.edit.email.success',
						'parameters' => [
							'%contactUrl%' => $this->generateUrl('contact')
							]
					]);
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
		
		$getValue = function ($content) {
			return $content->getValue();
		};
		
		$homepageLink = array();
		$homepageDoc = array();
		$homepagePrivateLink = array();
		$homepagePrivateDoc = array();
		for ($i = 1; $i <= $this->numLinks; $i ++) {
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
			'homepagePrivateDocs' => $homepagePrivateDocValue
		);
		$form = $this->createForm(HomepageContentType::class, $data, array(
			'action' => $this->generateUrl('configuration_homepage'),
			'method' => 'POST'
		));
		
		$form->handleRequest($request);
		
		if ($form->isValid()) {
			
			// Persist the value
			$homepageTitle->setValue($form->get('homepageTitle')
				->getData());
			$homepageIntro->setValue($form->get('homepageIntro')
				->getData());
			$homepageImage->setValue($form->get('homepageImage')
				->getData());
			$homepagePublicLinksTitle->setValue($form->get('homepagePublicLinksTitle')
				->getData());
			$homepagePrivateLinksTitle->setValue($form->get('homepagePrivateLinksTitle')
				->getData());
			$homepageLinkValue = $form->get('homepageLinks')->getData();
			$homepageDocValue = $form->get('homepageDocs')->getData();
			$homepagePrivateLinkValue = $form->get('homepagePrivateLinks')->getData();
			$homepagePrivateDocValue = $form->get('homepagePrivateDocs')->getData();
			
			for ($i = 1; $i <= $this->numLinks; $i ++) {
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
		
		// Get presentation intro html, image, links title and links
		$presentationTitle = $contentRepo->find('presentation.title');
		$presentationAbstract = $contentRepo->find('presentation.abstract');
		$presentationIntro = $contentRepo->find('presentation.intro');
		$presentationImage = $contentRepo->find('presentation.image');
		$presentationPublicLinksTitle = $contentRepo->find('presentation.links.title');
		
		$getValue = function ($content) {
			return $content->getValue();
		};
		
		$presentationLink = array();
		$presentationDoc = array();
		for ($i = 1; $i <= $this->numLinks; $i ++) {
			$presentationLink[$i] = $contentRepo->find("presentation.link.$i");
			$presentationDoc[$i] = $contentRepo->find("presentation.doc.$i");
		}
		$presentationLinkValue = array_map($getValue, $presentationLink);
		$presentationDocValue = array_map($getValue, $presentationDoc);
		
		// Set default value(s)
		
		$data = array(
			'presentationTitle' => $presentationTitle->getValue(),
		    'presentationAbstract' => $presentationAbstract->getValue(),
			'presentationIntro' => $presentationIntro->getValue(),
			'presentationImage' => $presentationImage->getValue(),
			'presentationPublicLinksTitle' => $presentationPublicLinksTitle->getValue(),
			'presentationLinks' => $presentationLinkValue,
			'presentationDocs' => $presentationDocValue
		);
		$form = $this->createForm(PresentationContentType::class, $data, array(
			'action' => $this->generateUrl('configuration_presentation'),
			'method' => 'POST'
		));
		
		$form->handleRequest($request);
		
		if ($form->isValid()) {
			
			// Persist the value
			$presentationTitle->setValue($form->get('presentationTitle')
				->getData());
			$presentationAbstract->setValue($form->get('presentationAbstract')
			    ->getData());
			$presentationIntro->setValue($form->get('presentationIntro')
				->getData());
			$presentationImage->setValue($form->get('presentationImage')
				->getData());
			$presentationPublicLinksTitle->setValue($form->get('presentationPublicLinksTitle')
				->getData());
			$presentationLinkValue = $form->get('presentationLinks')->getData();
			$presentationDocValue = $form->get('presentationDocs')->getData();
			
			for ($i = 1; $i <= $this->numLinks; $i ++) {
				$presentationLink[$i]->setValue($presentationLinkValue[$i]);
				$presentationDoc[$i]->setValue($presentationDocValue[$i]);
			}
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
	
	
	/**
	 * @Route("/taxref-migration", name = "taxref_migration")
	 * @Template()
	 */
	public function taxrefMigrationAction() {
		
		$entityManager = $this->getDoctrine()->getManager('metadata') ;
		$tableFormats = $entityManager->getRepository('IgnGincoBundle:Metadata\TableFormat')->findAll() ;
		
		$query = $this->get('ginco.query') ;
		
		$report = array() ;
		
		foreach ($tableFormats as $tableFormat) {
			
			$model = $tableFormat->getModel()->getName() ;
			$report[$model] = array() ;
			
			// Modification TAXREF 
			$queryBuilder = new TableFormatQueryBuilder($tableFormat, 't') ;
			$queryBuilder->select(array(
					't.cdnom AS cdnom',
					't.cdref AS cdref',
					't.nomvalide',
					's.label AS taxostatut',
					'm.label AS taxomodif',
					'm.code',
					'x.nom_complet',
					'x.nom_vern'
				))
				->distinct()
				->join('referentiels.taxostatutvalue', 's', 's.code = t.taxostatut')
				->join('referentiels.taxomodifvalue', 'm', 'm.code = t.taxomodif')
				->join('referentiels.taxref', 'x', 'x.cd_nom = t.cdnom')
				->orderBy('m.code')
				->orderBy('cdnom')
				->orderBy('cdref')
			;
		
			$report[$model]['observations'] = $query->query($queryBuilder) ;
			
			$cdNomBuilder = new TableFormatQueryBuilder($tableFormat, 't') ;
			$cdNomBuilder->select(array('t.cdnom'))
				->count()
				->distinct()
				->where('taxostatut IS NOT NULL')
			;
			
			$report[$model]['cdNomImpactes'] = $query->query($cdNomBuilder) ;
			
			$dataBuilder = new TableFormatQueryBuilder($tableFormat, 't') ;
			$dataBuilder->select()
				->count()
				->where('taxostatut IS NOT NULL')
			;
			
			$report[$model]['donneesImpactees'] = $query->query($dataBuilder) ;
			
			$verifBuilder = new TableFormatQueryBuilder($tableFormat, 't') ;
			$verifBuilder->select()
				->count()
				->join('referentiels.taxoalertevalue', 'v', 'v.code = t.taxoalerte')
				->where('v.label = :label')
				->setParameter('label', 'OUI')
			;
			
			$report[$model]['donneesVerification'] = $query->query($verifBuilder) ;
			
		}
		
		$referentielRepository = $entityManager->getRepository('IgnGincoBundle:Referentiel\ListeReferentiel') ;
		$taxrefReferentiel = $referentielRepository->find('taxref') ;
		if (!$taxrefReferentiel) {
			$this->createNotFoundException("TAXREF referentiel not found.") ;
		}
		
		return array(
			"taxrefReferentiel" => $taxrefReferentiel,
			"report" => $report
		) ;
		
	}
}
