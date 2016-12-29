<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Validator;

use Symfony\Component\Validator\Constraint;

/**
 * //rend disponible la contrainte dans les autres classes
 * @Annotation
 */
class CaseInsensitive extends Constraint {

	public $message;

	public function getTargets() {
		return self::CLASS_CONSTRAINT;
	}

	public function validatedBy() {
		return 'ign_configurateur_caseinsensitive'; // appel à l'alias du service
	}
}