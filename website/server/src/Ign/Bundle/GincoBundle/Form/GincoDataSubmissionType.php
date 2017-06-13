<?php
namespace Ign\Bundle\GincoBundle\Form;

use Doctrine\ORM\EntityRepository;
use Ign\Bundle\OGAMBundle\Entity\RawData\Submission;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

/**
 * This form inherits from the ogam_data_submission form
 * and adds the provider field.
 *
 * Class DataSubmissionType
 * @package Ign\Bundle\GincoBundle\Form
 */
class GincoDataSubmissionType extends AbstractType  {

	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->add('provider', EntityType::class, array(
			'class' => 'OGAMBundle:Website\Provider',
			'query_builder' => function (EntityRepository$er) {
				return $er->createQueryBuilder('p')
					->orderBy('p.label', 'ASC');
			},
			'choice_label' => 'label',
			'preferred_choices' => array($options['default_provider']),
		));
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => Submission::class,
		));
		$resolver->setRequired('jdd');
		$resolver->setRequired('default_provider');
	}

	public function getParent()
	{
		return \Ign\Bundle\OGAMBundle\Form\DataSubmissionType::class;
	}
}
