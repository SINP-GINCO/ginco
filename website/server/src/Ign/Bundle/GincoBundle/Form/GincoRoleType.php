<?php
namespace Ign\Bundle\GincoBundle\Form;

use Ign\Bundle\OGAMBundle\Form\RoleType;
use Ign\Bundle\OGAMBundle\Entity\Website\Role;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\NotBlank;

/**
 * This form inherits from the ogam_role form
 * and removes the "schema" and "datasets restriction" fields.:
 * --> schema: always RAW_DATA
 * --> datasets restrictions: none
 *
 * Class GincoRoleType
 * @package Ign\Bundle\GincoBundle\Form
 */
class GincoRoleType extends AbstractType  {

	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->remove('schemas')
			->remove('datasets');
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => Role::class,
		));
	}

	public function getParent()
	{
		return RoleType::class;
	}
}
