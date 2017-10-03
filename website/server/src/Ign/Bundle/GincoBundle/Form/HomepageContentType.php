<?php
namespace Ign\Bundle\GincoBundle\Form;

use Ivory\CKEditorBundle\Form\Type\CKEditorType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormBuilderInterface;
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
			->add('homepageIntro', CKEditorType::class, array(
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