<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Form;

use Doctrine\ORM\EntityRepository;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\NotNull;

/**
 * Form for launching auto-mapping between a table (chosen by user),
 * and a file (given by Controller)
 *
 * Class FieldMappingAutoType
 * @package Ign\Bundle\OGAMConfigurateurBundle\Form
 */
class FieldMappingAutoType extends AbstractType {

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $formOptions)
	{
		$modelId = $formOptions['modelId'];

		$builder->add('dst_format', EntityType::class, array(
			'class' => 'IgnOGAMConfigurateurBundle:TableFormat',
			'choice_label' => 'label',
			'placeholder' => 'fieldMapping.selectTable',
			'label' => 'fieldMapping.auto.label',
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
			->add('submit', SubmitType::class, array(
				'label' => 'fieldMapping.auto.title',
				'attr' => array(
					'formnovalidate' => 'formnovalidate',
				)
			));
	}

	/**
	 *
	 * @param OptionsResolverInterface $resolver
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
		return 'ign_bundle_configurateurbundle_field_mapping_auto';
	}
}