<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormBuilderInterface;
use Ign\Bundle\GincoBundle\Validator\Constraints\EmailList;
use Symfony\Component\Validator\Constraints\NotBlank;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

/**
 * Class ConfigurationType
 * Configuration parameters form type
 * @package Ign\Bundle\GincoBundle\Form
 */
class ConfigurationType extends AbstractType
{
	public function buildForm(FormBuilderInterface $builder, array $options)
	{
		$builder
			// The contact email field; can be a list of emails separated by commas
			// It must be a TextType (and not EmailType), to accept list of emails on the client side validation
			->add('contactEmail', TextType::class, array(
				'label' => 'Configuration.edit.email.label',
				'attr' => ['data-help'  => 'Configuration.edit.email.help'],
				'constraints' => array(
					new NotBlank(),
					new EmailList(),
				),
			))
			->add('submit', SubmitType::class, array(
				'label' => 'Configuration.edit.submit.button'
			))
		;
	}

	public function setDefaultOptions(OptionsResolverInterface $resolver)
	{
	}

	public function getName()
	{
		return 'configuration_form';
	}
}