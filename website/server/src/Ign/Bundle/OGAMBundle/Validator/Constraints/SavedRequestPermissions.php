<?php
namespace  Ign\Bundle\OGAMBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;

/**
 * Checks wheter the saved request permissions are correctly attribuated
 *
* @Annotation
*/
class SavedRequestPermissions extends Constraint
{
	public $message = 'permissions.savedRequest.invalid';

	public function validatedBy()
	{
		return get_class($this).'Validator';
	}
}