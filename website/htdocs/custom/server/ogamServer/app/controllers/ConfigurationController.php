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

        // The database
        $this->rawdb = Zend_Registry::get('website');
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
     * Show a user for edition.
     */
    public function editConfigurationAction() {
        $this->logger->debug('editConfigurationAction');

        // Generate the form
        $form = $this->getConfigurationForm('edit');
        $this->view->form = $form;

        $this->render('edit-configuration');
    }

}
