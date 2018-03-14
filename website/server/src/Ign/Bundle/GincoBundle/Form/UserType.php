<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Ign\Bundle\GincoBundle\Entity\Website\User;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\RepeatedType;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\Form\FormEvent;

class UserType extends AbstractType {

	/**
	 * Build the user form.
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {

        $builder->add('login', TextType::class, array(
            'label' => 'Login',
        ));

		$builder->add('username', TextType::class, array(
			'label' => 'User Name'
		));

		// Provider
		$builder->add('provider', EntityType::class, array(
			'label' => 'Provider',
			'class' => 'Ign\Bundle\GincoBundle\Entity\Website\Provider',
			'choice_label' => 'label',
			'multiple' => false
		));

		$builder->add('email', EmailType::class, array(
			'label' => 'Email'
		));

		// Roles
		$builder->add('roles', EntityType::class, array(
			'label' => 'Roles',
			'class' => 'Ign\Bundle\GincoBundle\Entity\Website\Role',
			'choice_label' => 'label',
			'multiple' => true,
			'expanded' => true
		));

		$builder->add('submit', SubmitType::class, array(
			'label' => 'Submit'
		));

        // In creation mode:
        // - add the password fields
        // In edition mode:
        // - login is not editable
        $builder->addEventListener(FormEvents::PRE_SET_DATA, function (FormEvent $event) {
            $user = $event->getData();
            $form = $event->getForm();

            // check if the User object is "new"
            // If no data is passed to the form, the data is "null".
            // This should be considered a new "User"
            if (!$user || null === $user->getLogin()) {
                $form->add('plainPassword', RepeatedType::class, array(
                    'type' => PasswordType::class,
                    'first_options' => array(
                        'label' => 'Password',
						'attr' => ['data-help'  => 'Password.constraints']
                    ),
                    'second_options' => array(
                        'label' => 'Confirm Password'
                    )
                ));
            } else {
                $form->add('login', TextType::class, array(
                    'label' => 'Login',
                    'read_only' => true,
                ));
            }
        });

    }

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => User::class,
		));
	}
}
