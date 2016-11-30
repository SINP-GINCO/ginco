<?php

require_once APPLICATION_PATH . '/controllers/AbstractOGAMController.php';

/**
 * ConfigurationController is the controller that manages the control
 * of configurable parameters in table website.application_parameters.
 *
 * @package Application_Controller
 */
class Custom_ConfigurationController extends AbstractOGAMController {

    protected $jobManager = null;

    protected $exportFileModel = null;

    protected $submissionModel = null;

    protected $rawdb;

    /**
     * Initialise the controler.
     */
    public function init() {
        parent::init();

        // Set the current module name
        $websiteSession = new Zend_Session_Namespace('website');
        $websiteSession->module = "configuration";
        $websiteSession->moduleLabel = "Configuration";
        $websiteSession->moduleURL = "configuration";

        // The configuration in application_parameters
        $this->configuration = Zend_Registry::get('configuration');

        // The database
        $this->db = Zend_Registry::get('website_db');
    }

    /**
     * Check if the authorization is valid this controler.
     *
     * @throws an Exception if the user doesn't have the rights
     */
    function preDispatch() {
        parent::preDispatch();

        $userSession = new Zend_Session_Namespace('user');
        $user = $userSession->user;
        if (empty($user) || !$user->isAllowed('CONFIGURE_WEBSITE_PARAMETERS')) {
            throw new Zend_Auth_Exception('Permission denied for right : CONFIGURE_WEBSITE_PARAMETERS');
        }
    }

    /**
     * The "index" action is the default action for all controllers.
     * -- Does Nothing --
     */
    public function indexAction() {
        // Return to the user list page
        $this->_helper->redirector('edit-configuration','configuration','default');
    }

    /**
     * Show the configuration form for edition.
     */
    public function editConfigurationAction() {
        $this->logger->debug('editConfigurationAction');

        // Generate the form
        $form = $this->getConfigurationForm();
        $this->view->form = $form;

        $this->render('edit-configuration');
    }

    /**
     * Build and return the configuration form.
     *
     * @return Application_Form_OGAMForm
     */
    protected function getConfigurationForm() {
        $form = new Application_Form_OGAMForm(array(
            'attribs' => array(
                'name' => 'configuration-form',
                'action' => $this->baseUrl . '/configuration/validate-configuration'
            )
        ));

        //
        // Add the contact email element:
        //
        $contactEmail = $form->createElement('text', 'contact-email');
        $contactEmail->setLabel('contactEmailLabel');
        $contactEmail->addValidator(new Application_Validator_EmailList());
        $contactEmail->setRequired(true);
        $contactEmail->setDescription('contactEmailDescription');
        $contactEmail->addFilter('StringToLower');
        $formerContactMail = $this->configuration->getConfig('contactEmail','sinp-dev@ign.fr');
        $contactEmail->setValue($formerContactMail);

        //
        // Create the submit button
        //
        $submitElement = $form->createElement('submit', 'submit');
        $submitElement->setLabel('Submit');

        // Add elements to form:
        $form->addElement($contactEmail);
        $form->addElement($submitElement);

        return $form;
    }

    /**
     * Check the configuration form validity and update the configuration
     */
    public function validateConfigurationAction() {
        $this->logger->debug('validateConfigurationAction');

        // Check the validity of the POST
        if (!$this->getRequest()->isPost()) {
            $this->logger->debug('form is not a POST');
            return $this->_forward('index');
        }

        // Check the validity of the form
        $form = $this->getConfigurationForm();
        if (!$form->isValid($_POST)) {
            // Failed validation; redisplay form
            $this->logger->debug('form is not valid');
            $this->view->form = $form;
            return $this->render('edit-configuration');
        } else {
            $values = $form->getValues();

            $f = new Zend_Filter_StripTags();
            $contactEmail = $f->filter($values['contactemail']);
            // Remove all spaces around email adresses
            $contactEmail = implode(',',array_map('trim', explode(',',$contactEmail)));
            $this->logger->debug('contactEmail : ' . $contactEmail);

            // Update Configuration
            $req = "UPDATE website.application_parameters SET value=? WHERE name='contactEmail'";
            $query = $this->db->prepare($req);
            $query->execute(array($contactEmail));

            // Return to the configuration form, with a "OK" flash message
            $this->_helper->_flashMessenger($this->translator->translate('contactEmailConfirmation'));
            $this->_helper->redirector('edit-configuration','configuration','default');
        }
    }

}
