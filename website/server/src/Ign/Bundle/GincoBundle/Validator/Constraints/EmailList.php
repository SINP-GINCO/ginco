<?php
namespace  Ign\Bundle\GincoBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;

/**
 * Checks wheter a given value is a list of valid email addresses separated by commas
 *
* @Annotation
*/
class EmailList extends Constraint
{
	public $message = 'EmailList.invalid';

	public function validatedBy()
	{
		return get_class($this).'Validator';
	}
}