<?php
namespace Ign\Bundle\OGAMBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;
use Symfony\Component\Validator\ConstraintValidator;
use Symfony\Component\HttpFoundation\RequestStack;
use Doctrine\ORM\EntityManagerInterface;

/**
 * Validator on the saved request permissions
 */
class SavedRequestPermissionsValidator extends ConstraintValidator {

	public function validate($permissions, Constraint $constraint)
	{
		$savePrivateRequest = false;
		$savePublicRequest = false;
		foreach ($permissions as $permission) {
			if ($permission->getCode() == 'MANAGE_OWNED_PRIVATE_REQUEST') {
				$savePrivateRequest = true;
			}
			if ($permission->getCode() == 'MANAGE_PUBLIC_REQUEST') {
				$savePublicRequest = true;
			}
		}
		if ($savePublicRequest && !$savePrivateRequest) {
			// If you're using the new 2.5 validation API (you probably are!)
			$this->context->buildViolation($constraint->message)
				->addViolation();
		}
	}
}