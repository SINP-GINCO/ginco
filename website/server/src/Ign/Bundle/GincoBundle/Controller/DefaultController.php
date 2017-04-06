<?php

namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Form\ContactType;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

class DefaultController extends Controller
{

    /**
     * Contact form page
     *
     * @Route("/contact", _name="contact")
     */
    public function contactAction(Request $request)
    {
        $form = $this->createForm(new ContactType(), null, array(
            'action' => $this->generateUrl('contact'),
            'method' => 'POST'
        ));

        if ($request->isMethod('POST')) {
            // Refill the fields in case the form is not valid.
            $form->handleRequest($request);

            if($form->isValid()){
                // Contact recipients
                $contactRecipients = $this->get('ogam.configuration_manager')->getConfig('contactEmail','sinp-dev@ign.fr');
                $contactRecipients = explode(',',$contactRecipients);

                // Send the email
                $this->get('app.mail_manager')->sendEmail(
                    'IgnGincoBundle:Emails:contact.html.twig',
                    array(
                        'email' => $form->get('email')->getData(),
                        'message' => $form->get('message')->getData(),
                    ),
                    $contactRecipients
                );

                $request->getSession()->getFlashBag()->add('success', 'Contact.send.success');

                return $this->redirect($this->generateUrl('contact'));
            }
        }

        return $this->render('IgnGincoBundle:Default:contact.html.twig', array(
            'form' => $form->createView()
        ));
    }

}
