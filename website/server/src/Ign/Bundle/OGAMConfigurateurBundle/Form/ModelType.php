<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

use Ign\Bundle\GincoBundle\Entity\Metadata\Model;
use Ign\Bundle\GincoBundle\Entity\Metadata\Standard;

class ModelType extends AbstractType {

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder
			->add('standard', EntityType::class, array(
				'label' => 'Standard',
				'em' => 'metadata',
				'class' => Standard::class,
				'choice_label' => 'label',
				'required' => true
			))
			->add('name', TextType::class, array(
				'label' => 'Name'
			))
			->add('description', TextareaType::class, array(
				'attr' => array(
					'resize' => 'none'
				),
				'label' => 'Description',
				'required' => false
			))
			->add('enregistrer', SubmitType::class, array(
				'label' => 'Save',
				'attr' => array(
					'formnovalidate' => 'formnovalidate'
				)
			))
		;
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => Model::class
		));
	}

	/**
	 *
	 * @return string
	 */
	public function getBlockPrefix() {
		return 'ign_bundle_configurateurbundle_model';
	}
}