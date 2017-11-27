<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Validator\Constraints\NotBlank;

class UserAddFromINPNType extends AbstractType {

	/**
	 * Form to search a User in the INPN directory, given his login.
	 * On success, the User is added in database.
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {

        $builder->add('login', TextType::class, array(
            'label' => 'Login',
			'constraints' => array(
				new NotBlank(),
			)
        ));
		$builder->add('submit', SubmitType::class, array(
			'label' => 'Search'
		));
    }

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => null,
		));
	}
}
