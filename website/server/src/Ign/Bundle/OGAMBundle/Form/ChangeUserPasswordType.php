<?php
namespace Ign\Bundle\OGAMBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\RepeatedType;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Ign\Bundle\OGAMBundle\Entity\Website\User;

/**
 * Form used to change a password.
 *
 * This form is used by a non-connected user to change is own password when he forgot it.
 *
 */
class ChangeUserPasswordType extends AbstractType {

	/**
	 * Build the user change password form.
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {

		// non-mapped field for the old password
		$builder->add('oldpassword', PasswordType::class, array(
			'label' => 'Old Password',
			'mapped' => false
		));

		// the password fields
		$builder->add('plainPassword', RepeatedType::class, array(
			'type' => PasswordType::class,
			'first_options' => array(
				'label' => 'New Password',
				'attr' => ['data-help'  => 'Password.constraints']
			),
			'second_options' => array(
				'label' => 'Confirm Password'
			)
		));

		// submit button
		$builder->add('submit', SubmitType::class, array(
			'label' => 'Submit'
		));
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => User::class
		));
	}
}
