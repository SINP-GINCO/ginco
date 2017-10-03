<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
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
class HomepageContentType extends AbstractType
{
	public function buildForm(FormBuilderInterface $builder, array $options)
	{
		$builder
			// The homepage intro text field
			->add('homepageIntro', TextareaType::class, array(
				'label' => 'Intro page d\'accueil',
				'attr' => ['data-help'  => 'Bla bla bla'],
				'constraints' => array(
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
		return 'homepage_content_form';
	}
}