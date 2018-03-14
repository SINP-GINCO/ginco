<?php
namespace Ign\Bundle\GincoBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;
use Symfony\Component\Validator\ConstraintValidator;
use Doctrine\ORM\EntityManager;

/**
 * Checks wheter a value is a valid EPSG code using postgis spatial_re_sys table
 *
 */
class EPSGCodeValidator extends ConstraintValidator
{
	public function __construct(EntityManager $em)
	{
		$this->em = $em;
	}
	
	public function validate($value, Constraint $constraint)
	{
		$em = $this->em;
		$existingCode = $em->getRepository('Ign\Bundle\GincoBundle\Entity\SpatialRefSys')->findOneBy(
			array('srid' => $value)
		);
		
		if ($existingCode == null) {
			// If you're using the new 2.5 validation API (you probably are!)
			$this->context->buildViolation($constraint->message)
				->setParameter('{{ string }}', $value)
				->addViolation();
		}
	}
}
