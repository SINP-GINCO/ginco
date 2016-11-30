<?php

require_once APPLICATION_PATH . '/controllers/AbstractOGAMController.php';

/**
 * ContactController is the controller that manages the
 * contact form and the sending of contact emails
 *
 * @package Application_Controller
 */
class Custom_ContactController extends AbstractOGAMController {

    protected $db;

    /**
     * Initialise the controler.
     */
    public function init() {
        parent::init();

        // Set the current module name
        $websiteSession = new Zend_Session_Namespace('website');
        $websiteSession->module = "contact";
        $websiteSession->moduleLabel = "Contact";
        $websiteSession->moduleURL = "contact";

        // The configuration in application_parameters
        $this->configuration = Zend_Registry::get('configuration');

        // The database
        $this->db = Zend_Registry::get('website_db');
    }

    /**
     * Check if the authorization is valid this controller: 
     * no authorization needed to send a mail. 
     *
     * @throws an Exception if the user doesn't have the rights
     */

    /**
     * Show the contact form
     */
    public function indexAction() {
        $this->logger->debug('Contact Controller, indexAction');

        // Generate the form
        $form = $this->getContactForm();
        $this->view->form = $form;

        $this->render('contact');
    }

    /**
     * Build and return the contact form.
     *
     * @return Application_Form_OGAMForm
     */
    protected function getContactForm() {
        $form = new Application_Form_OGAMForm(array(
            'attribs' => array(
                'name' => 'contact-form',
                'action' => $this->baseUrl . '/contact/send'
            )
        ));

        $userSession = new Zend_Session_Namespace('user');
        $user = $userSession->user;

        //
        // Add the anti-spam "name" element
        // This field is hidden by css and must NOT be filled
        // No formal validation is done, but the email is NOT sent if the "name" is not empty
        //
        $name = $form->createElement('text', 'name');
        $name->setLabel('Name');
        $name->setRequired(false);
        
        //
        // Add the visitor email element:
        //
        $fromEmail = $form->createElement('text', 'email');
        $fromEmail->setLabel('contactFromEmail');
        $fromEmail->addValidator('EmailAddress');
        if ($user != null && $user->email != null) {
            $fromEmail->setValue($user->email);
        }
        $fromEmail->setRequired(true);
        $fromEmail->addFilter('StringToLower');

        //
        // Add the message element:
        //
        $message = $form->createElement('textarea', 'message');
        $message->setLabel('Message');
        $message->setRequired(true);

        //
        // Create the submit button
        //
        $submitElement = $form->createElement('submit', 'submit');
        $submitElement->setLabel('Send');

        // Add elements to form:
        $form->addElement($name);
        $form->addElement($fromEmail);
        $form->addElement($message);
        $form->addElement($submitElement);

        return $form;
    }

    /**
     * Check the contact form validity and send the email
     */
    public function sendAction() {
        $this->logger->debug('validateConfigurationAction');

        // Check the validity of the POST
        if (!$this->getRequest()->isPost()) {
            $this->logger->debug('form is not a POST');
            return $this->_forward('index');
        }

        // Check the validity of the form
        $form = $this->getContactForm();
        if (!$form->isValid($_POST)) {
            // Failed validation; redisplay form
            $this->logger->debug('form is not valid');
            $this->view->form = $form;
            return $this->render('contact');
        } else {
            $values = $form->getValues();

            // anti-spam field: it is hidden by css and MUST be empty,
            // if not it has been probably been filled by a robot and the message is not sent.
            $antiSpam = $values['name'];
            if (!empty($antiSpam)) {
                $this->logger->debug("Anti-spam field 'name' filled, not sending the mail");
            } else {

                $f = new Zend_Filter_StripTags();
                $fromEmail = $f->filter($values['email']);
                $this->logger->debug('fromEmail : ' . $fromEmail);
                $message = $f->filter($values['message']);
                $this->logger->debug('message : ' . $message);

                // todo: send the email
                $this->logger->debug("SEND CONTACT MAIL");
                $this->logger->debug("From: " . $fromEmail);
                $this->logger->debug("Message: " . $message);

                // Return to the configuration form, with a "OK" flash message
                $this->_helper->_flashMessenger($this->translator->translate('contactEmailSend'));
            }
            $this->_helper->redirector('index','index','default');
        }
    }

}
