<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Form;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\Model;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class DatasetImportType extends AbstractType {

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->add('label', TextType::class, array(
			'label' => 'Name'
		))
			->add('definition', TextareaType::class, array(
			'attr' => array(
				'resize' => 'none'
			),
			'label' => 'Description',
			'required' => false,

			));
		if($options['isNew'] == true){
			$builder->add('model', EntityType::class, array(
				'class' => 'IgnOGAMConfigurateurBundle:Model',
				'choice_label' => 'name',
				'label' => 'importmodel.DataModelTarget'
			));
		} else {
			// Add a tooltip to make user aware about mappings being dropped
			$builder->add('model', EntityType::class, array(
				'class' => 'IgnOGAMConfigurateurBundle:Model',
				'choice_label' => 'name',
				'label' => 'importmodel.DataModelTarget',
				'attr' => array(
					'data-toggle' => 'tooltip',
					'data-placement' => 'left',
					'title' => 'importmodel.edit.targetModelChanged'
				)
			));
		}
		$builder->add('enregistrer', SubmitType::class, array(
			'label' => 'Save',
			'attr' => array(
				'formnovalidate' => 'formnovalidate'
			)
		));
	}

	/**
	 *
	 * @param OptionsResolverInterface $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => 'Ign\Bundle\OGAMConfigurateurBundle\Entity\Dataset',
			'isNew' => false
		));
	}

	/**
	 *
	 * @return string
	 */
	public function getBlockPrefix() {
		return 'ign_bundle_configurateurbundle_dataset_import';
	}
}