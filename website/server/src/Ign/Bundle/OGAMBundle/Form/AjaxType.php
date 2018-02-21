<?php
namespace Ign\Bundle\OGAMBundle\Form;

use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\AbstractType;

class AjaxType extends AbstractType {
	// ...
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'csrf_protection' => false
		)
		);
	}
}