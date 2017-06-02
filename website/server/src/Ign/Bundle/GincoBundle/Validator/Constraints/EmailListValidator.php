<?php
namespace Ign\Bundle\GincoBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;
use Symfony\Component\Validator\ConstraintValidator;

/**
 * Checks wheter a given value is a list of valid email addresses separated by commas
 *
 */
class EmailListValidator extends ConstraintValidator
{
	public function validate($value, Constraint $constraint)
	{
		$emails = array_map('trim',explode(',',$value));
		$wrongMails = array();
		foreach ($emails as $email) {
			if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
				$wrongMails[] = $email;
			}
		}
		if (count($wrongMails) > 0) {
			// If you're using the new 2.5 validation API (you probably are!)
			$this->context->buildViolation($constraint->message)
				->setParameter('{{ string }}', implode(', ',$wrongMails))
				->addViolation();
		}
	}
}
