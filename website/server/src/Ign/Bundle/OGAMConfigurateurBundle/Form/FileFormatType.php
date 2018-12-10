<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class FileFormatType extends AbstractType {

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->add('label', TextType::class, array(
			'label' => 'Name'
		))
			->add('description', TextareaType::class, array(
			'label' => 'Description',
			'attr' => array(
				'resize' => 'none'
			),
			'required' => false
		))
			->add('save', SubmitType::class, array(
			'attr' => array(
				'formnovalidate' => 'formnovalidate'
			),
			'label' => 'Save'
		));
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => 'Ign\Bundle\OGAMConfigurateurBundle\Entity\FileFormat'
		));
	}

	/**
	 *
	 * @return string
	 */
	public function getBlockPrefix() {
		return 'ign_bundle_configurateurbundle_file_format';
	}
}