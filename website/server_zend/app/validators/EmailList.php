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

/**
 * Validator for the contact email field
 * Value must be a list of emails separated by commas
 *
 * @package Application_Validator
 */
class Application_Validator_EmailList extends Zend_Validate_Abstract {

    const INVALID = 'invalid';

    protected $_messageTemplates = array(
        self::INVALID => "Email(s) invalide(s) : '%value%'"
    );

	/**
	 * Defined by Zend_Validate_Interface
	 *
	 * Returns true if the login doesn't exist
	 *
	 * @param String $value
	 *        	the value to test
	 * @param Array $context
	 *        	some contextual information
	 * @return boolean
	 */
	public function isValid($value, $context = null) {
		$value = (string) $value;
		$this->_setValue($value);

		$emails = array_map('trim',explode(',',$value));
        $wrongMails = array();
        foreach ($emails as $email) {
            if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                $wrongMails[] = $email;
            }
        }
        if (count($wrongMails) > 0) {
            $this->_setValue(implode(', ', $wrongMails));
            $this->_error(self::INVALID);
            return false;
        }
        return true;
	}
}
