<?php
namespace Ign\Bundle\ConfigurateurBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\Form\FormEvent;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\FileType;

class DatasetImportUploadType extends AbstractType {

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->add('select', FileType::class, array(
			'label' => 'Sélectionnez un fichier...',
			'empty_data' => 'Veuillez sélectionner un fichier'
		));
	}

	/**
	 *
	 * @param OptionsResolverInterface $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'validation_groups' => false
		));
	}

	/**
	 *
	 * @return string
	 */
	public function getBlockPrefix() {
		return 'ign_bundle_configurateurbundle_dataset_import_upload';
	}
}
