<?php
namespace Ign\Bundle\GincoBundle\Form\Components;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormBuilderInterface;
use Ign\Bundle\GincoBundle\Validator\Constraints\EmailList;
use Symfony\Component\Validator\Constraints\NotBlank;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

/**
 * Class LinkType
 * A custom form type for links, with two fields: anchor and url
 * @package Ign\Bundle\GincoBundle\Form
 */
class LinkType extends AbstractType
{
	public function buildForm(FormBuilderInterface $builder, array $options)
	{
		$builder
			->add('anchor', TextType::class, array(
				'label' => 'Anchor',
				'required' => false,
				// 'attr' => ['data-help'  => 'Texte du lien'],
			))
			->add('href', TextType::class, array(
				'label' => 'Url',
				'required' => false,
				// 'attr' => ['data-help'  => 'Commence par / (interne) ou http(s)://(externe)'],
			))
			->add('target', ChoiceType::class, array(
				'label' => 'Target',
				'required' => false,
				'choices' => array(
					'Same window' => '_self',
					'New window' => '_blank'
				),
				'choices_as_values' => true,
			))
			->addModelTransformer(new LinkToJsonTransformer())
		;
	}

	public function setDefaultOptions(OptionsResolverInterface $resolver)
	{
	}
}