<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Validator\Constraints\Type;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Form\FormBuilderInterface;
use Ign\Bundle\GincoBundle\Validator\Constraints\EmailList;
use Ign\Bundle\GincoBundle\Validator\Constraints\EPSGCode;
use Symfony\Component\Validator\Constraints\NotBlank;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Doctrine\ORM\EntityRepository;
use Symfony\Component\OptionsResolver\OptionsResolver;

/**
 * Class ConfigurationType
 * Configuration parameters form type
 * @package Ign\Bundle\GincoBundle\Form
 */
class ConfigurationType extends AbstractType
{
	public function buildForm(FormBuilderInterface $builder, array $options)
	{
		$defaultRole = $options['defaultRole'];
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
			->add('srs_results', IntegerType::class, array(
				'label' => 'Configuration.edit.epsg',
				'mapped' => false,
				'required' => true,
				'constraints' => array(
					new Type(array(
						'type' => 'int'
					)),
					new Length(array(
						'min' => 4,
						'max' => 8
					)),
					new EPSGCode()
				)
			))
			->add('defaultRole', EntityType::class, array(
				'class' => 'Ign\Bundle\GincoBundle\Entity\Website\Role',
				'choice_label' => 'label',
				'query_builder' => function(EntityRepository $er) use($defaultRole){
					return $er->createQueryBuilder('r')
						->orderBy('r.isDefault', 'DESC');
				},
				'label' => 'Configuration.edit.defaultRole.label',
				'attr' => ['data-help'  => 'Configuration.edit.defaultRole.help']
			))
			->add('submit', SubmitType::class, array(
				'label' => 'Configuration.edit.submit.button'
			))
		;
	}

	/**
	 *
	 * @param OptionsResolverInterface $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'defaultRole' => null
		));
	}

	public function getName()
	{
		return 'configuration_form';
	}
}