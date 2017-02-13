<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Ign\Bundle\OGAMBundle\Form\DataSubmissionType as BaseType;

class DataSubmissionType extends BaseType {

	/**
	 * Build the data submission form.
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->add('DATASET_ID', ChoiceType::class, array(
			'label' => 'Dataset',
			'required' => true,
			'choice_value' => 'id',
			'choice_label' => 'label',
			'choices' => $options['datasetChoices'],
			'choices_as_values' => true
		))
			->add('PROVIDER_ID', ChoiceType::class, array(
			'label' => 'Provider',
			'required' => true,
			'choice_value' => 'id',
			'choice_label' => 'label',
			'choices' => $options['providerChoices'],
			'choices_as_values' => true,
			'preferred_choices' => array($options['defaultProvider'])
		))
			->add('submit', SubmitType::class);
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'datasetChoices' => null,
			'providerChoices' => null,
			'defaultProvider' => null
		));
	}
}
