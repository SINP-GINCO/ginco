<?php
/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 *
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices.
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents.
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */
include_once APPLICATION_PATH . '/controllers/UsermanagementController.php';

/**
 * UsermanagementController is the controller that manages the users
 *
 * @package controllers
 */
class Custom_UsermanagementController extends UsermanagementController {

	/**
	 * Build and return the user form.
	 *
	 * @param
	 *        	String the mode of the form ('create' or 'edit')
	 * @param
	 *        	Application_Object_Website_User the user
	 * @return a Zend Form
	 */
	protected function getUserForm($mode = null, $user = null) {
		$form = new Application_Form_OGAMForm(array(
			'attribs' => array(
				'name' => 'user-form',
				'action' => $this->baseUrl . '/usermanagement/validate-user'
			)
		));
		
		//
		// Add the login element:
		//
		$login = $form->createElement('text', 'login');
		$login->setLabel('Login');
		$login->addValidator('alnum');
		$login->addValidator('regex', false, array(
			'/^[a-z]+/'
		));
		$login->addValidator('stringLength', false, array(
			2,
			20
		));
		$login->setRequired(true);
		$login->addFilter('StringToLower');
		if ($user != null) {
			$login->setValue($user->login);
		}
		
		if ($mode == 'edit') {
			$login->setAttrib('readonly', 'true');
		} else {
			$login->addValidator(new Application_Validator_UserNotExist());
		}
		
		//
		// Add the password elements
		//
		if ($mode == 'create') {
			// Create and configure password element
			$password = $form->createElement('password', 'password');
			$password->addValidator(new Application_Validator_PasswordConfirmation());
			$password->setLabel('Password');
			$password->setRequired(true);
			$password->setDescription($this->translator->translate('passwordRequirement'));
			$password->addValidator('regex', false, array(
				'pattern' => '/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}/',
				'messages' => $this->translator->translate('InvalidPassword')
			));
			
			$confirmPassword = $form->createElement('password', 'confirmPassword');
			$confirmPassword->setLabel('Confirm Password');
			$confirmPassword->setRequired(true);
		}
		
		//
		// Add the user name element
		//
		$usernameElem = $form->createElement('text', 'username');
		$usernameElem->setLabel('User Name');
		$usernameElem->setRequired(true);
		if ($user != null) {
			$usernameElem->setValue($user->username);
		}
		
		//
		// Add the provider element
		//
		$providerIdElem = $form->createElement('select', 'providerId');
		$providerIdElem->setLabel('Provider');
		$providerIdElem->setRequired(true);
		if ($user != null && $user->provider != null) {
			$providerIdElem->setValue($user->provider->id);
		}
		$providers = $this->providerModel->getProvidersList();
		$providersChoices = array();
		foreach ($providers as $provider) {
			$providersChoices[$provider->id] = $provider->label;
		}
		$providerIdElem->addMultiOptions($providersChoices);
		
		//
		// Add the email element
		//
		$emailElem = $form->createElement('text', 'email');
		$emailElem->setLabel('Email');
		$emailElem->setRequired(true);
		if ($user != null && $user->email != null) {
			$emailElem->setValue($user->email);
		}
		$emailElem->addValidator('EmailAddress');
		
		//
		// Add the roles element
		//
		$roleCodeElem = $form->createElement('multiCheckbox', 'rolesCodes');
		$roleCodeElem->setLabel('Roles');
		$roleCodeElem->setRequired(true);
		$allroles = $this->roleModel->getRolesList();
		$options = array();
		foreach ($allroles as $role) {
			$options[$role->code] = $role->label;
		}
		$roleCodeElem->addMultiOptions($options);
		
		if ($user != null) {
			$userRoles = array();
			foreach ($user->rolesList as $role) {
				$userRoles[] = $role->code;
			}
			$roleCodeElem->setValue($userRoles);
		}
		
		//
		// Create the submit button
		//
		$submitElement = $form->createElement('submit', 'submit');
		$submitElement->setLabel('Submit');
		
		//
		// Create a hidden mode element
		//
		$modeElement = $form->createElement('hidden', 'mode');
		$modeElement->setValue($mode);
		
		// Add elements to form:
		$form->addElement($login);
		if ($mode == 'create') {
			$form->addElement($password);
			$form->addElement($confirmPassword);
		}
		$form->addElement($usernameElem);
		$form->addElement($providerIdElem);
		$form->addElement($emailElem);
		$form->addElement($roleCodeElem);
		$form->addElement($modeElement);
		$form->addElement($submitElement);
		
		return $form;
	}

	/**
	 * Build and return the role form.
	 *
	 * @param String $mode
	 *        	the mode of the form ('create' or 'edit')
	 * @param Role $role
	 *        	the role
	 * @return a Zend Form
	 */
	protected function getRoleForm($mode = null, $role = null) {
		$form = new Application_Form_OGAMForm(array(
			'attribs' => array(
				'name' => 'role-form',
				'action' => $this->baseUrl . '/usermanagement/validate-role'
			)
		));
		
		//
		// Add the role code
		//
		$roleCode = $form->createElement('text', 'roleCode');
		$roleCode->setLabel('Role Code');
		$roleCode->setRequired(true);
		if ($role != null) {
			$roleCode->setValue($role->code);
		}
		if ($mode == 'edit') {
			$roleCode->setAttrib('readonly', 'true');
		}
		
		//
		// Add the role label
		//
		$roleLabel = $form->createElement('text', 'roleLabel');
		$roleLabel->setLabel('Role Label');
		$roleLabel->setRequired(true);
		if ($role != null) {
			$roleLabel->setValue($role->label);
		}
		
		//
		// Add the role definition
		//
		$roleDefinition = $form->createElement('text', 'roleDefinition');
		$roleDefinition->setLabel('Role Definition');
		$roleDefinition->setRequired(true);
		if ($role != null) {
			$roleDefinition->setValue($role->definition);
		}
		
		// Permissions
		// Get all the Permissions
		$allpermissions = $this->roleModel->getAllPermissions();
		$rolepermissions = $form->createElement('multiCheckbox', 'rolepermissions');
		$rolepermissions->setLabel($this->translator->translate('Permissions'));
		$rolepermissions->setDisableTranslator(true); // Pas de trad par Zend, c'est géré dans les métadonnées
		$rolepermissions->addMultiOptions($allpermissions);
		if ($role != null) {
			$rolepermissions->setValue($role->permissionsList); // set the selected permissions
		}
		
		//
		// Create the submit button
		//
		$submitElement = $form->createElement('submit', 'submit');
		$submitElement->setLabel('Submit');
		
		//
		// Create a hidden mode element
		//
		$modeElement = $form->createElement('hidden', 'mode');
		$modeElement->setValue($mode);
		
		// Add elements to form:
		$form->addElement($roleCode);
		$form->addElement($roleLabel);
		$form->addElement($roleDefinition);
		$form->addElement($modeElement);
		$form->addElement($rolepermissions);
		$form->addElement($submitElement);
		
		return $form;
	}

	/**
	 * Check the role form validity and update the role information.
	 *
	 * @return a view.
	 */
	public function validateRoleAction() {
		$this->logger->debug('validateRole');
		
		// Check the validity of the POST
		if (!$this->getRequest()->isPost()) {
			$this->logger->debug('form is not a POST');
			return $this->_forward('index');
		}
		
		// Check the validity of the form
		$mode = $_POST['mode'];
		$form = $this->getRoleForm($mode);
		
		if (!$form->isValid($_POST)) {
			// Failed validation; redisplay form
			$this->logger->debug('form is not valid');
			$this->view->form = $form;
			if ($mode == 'edit') {
				return $this->render('show-edit-role');
			} else {
				return $this->render('show-create-role');
			}
		} else {
			// extra validation
			$permissionsList = $form->getValue('rolepermissions');
			if (in_array('MANAGE_PUBLIC_REQUESTS', $permissionsList) && !in_array('MANAGE_PRIVATE_REQUESTS', $permissionsList)) {
				$form->markAsError();
				$form->rolepermissions->addError($this->translator->translate('ManageRequestPermissionError'));
				// Redisplay form
				$this->logger->debug('form is not valid');
				$this->view->form = $form;
				if ($mode == 'edit') {
					return $this->render('show-edit-role');
				} else {
					return $this->render('show-create-role');
				}
			}
			
			$values = $form->getValues();
			
			$f = new Zend_Filter_StripTags();
			$roleCode = $f->filter($values['roleCode']);
			$roleLabel = $f->filter($values['roleLabel']);
			$roleDefinition = $f->filter($values['roleDefinition']);
			$rolepermissions = $values['rolepermissions'];
			
			// schema : we add RAW_DATA
			$schemasList = array();
			$schemasList['RAW_DATA'] = 'RAW_DATA';
			
			// Build the user
			$role = new Application_Object_Website_Role();
			$role->code = $roleCode;
			$role->label = $roleLabel;
			$role->definition = $roleDefinition;
			$role->permissionsList = $rolepermissions;
			$role->schemasList = $schemasList;
			
			if ($mode == 'edit') {
				//
				// EDIT the role
				//
				
				// Update the user in database
				$this->roleModel->updateRole($role);
			} else {
				//
				// CREATE the new role
				//
				
				// Create the user in database
				$this->roleModel->createRole($role);
			}
			
			// Return to the user list page
			$this->showRolesAction();
		}
	}
}