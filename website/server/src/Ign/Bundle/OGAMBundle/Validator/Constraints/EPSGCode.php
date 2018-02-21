<?php
namespace  Ign\Bundle\OGAMBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;

/**
 * Checks wheter a given value is an existing EPSG Code
 *
* @Annotation
*/
class EPSGCode extends Constraint
{
	public $message = 'EPSGCode.invalid';

	public function validatedBy()
	{
		return get_class($this).'Validator';
	}
}