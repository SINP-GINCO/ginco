<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Form;

use Doctrine\ORM\EntityRepository;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\NotNull;

/**
 * Form for adding the same fields to a file (given by Controller)
 * that the ones of a table (chosen by user),
 *
 * Class FileFieldAutoType
 * @package Ign\Bundle\OGAMConfigurateurBundle\Form
 */
class FileFieldAutoType extends AbstractType {

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $formOptions)
	{
		$modelId = $formOptions['modelId'];

		$builder->add('table_format', EntityType::class, array(
			'class' => 'IgnOGAMConfigurateurBundle:TableFormat',
			'choice_label' => 'label',
			'placeholder' => 'fileField.selectTable',
			'label' => 'fileField.auto.label',
			'required' => false,
			'constraints' => array(new NotNull()), // validation message is directly in FieldMappingController->autoAction
			'query_builder' => function (EntityRepository $er) use ($modelId) {
				$qb = $er->createQueryBuilder('t')
					->select('t')
					->from('IgnOGAMConfigurateurBundle:ModelTables', 'mt')
					->where('mt.model=:modelId')
					->andWhere('mt.table = t.format')
					->orderBy('t.label', 'ASC')
					->setParameters(array(
						'modelId' => $modelId
					));
				return $qb;
			}
		))
		->add('only_mandatory',  CheckboxType::class, array(
				'label'    => 'Ajouter seulement les champs obligatoires',
				'required' => false,
		))
		->add('submit', SubmitType::class, array(
			'label' => 'fileField.auto.button',
			'attr' => array(
				'formnovalidate' => 'formnovalidate',
			)
		));
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'modelId' => null,
		));
	}

	/**
	 *
	 * @return string
	 */
	public function getBlockPrefix() {
		return 'ign_bundle_configurateurbundle_file_field_auto';
	}
}