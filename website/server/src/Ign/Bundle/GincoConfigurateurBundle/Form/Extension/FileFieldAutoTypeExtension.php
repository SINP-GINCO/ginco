<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Form\Extension;

use Doctrine\ORM\EntityRepository;

use Ign\Bundle\OGAMConfigurateurBundle\Form\FileFieldAutoType;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;

use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractTypeExtension;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints\NotNull;

class FileFieldAutoTypeExtension extends AbstractTypeExtension {

	/**
	 * Returns the name of the type being extended.
	 *
	 * @return string The name of the type being extended
	 */
	public function getExtendedType() {
		return FileFieldAutoType::class;
	}

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $formOptions) {
		$modelId = $formOptions['modelId'];

		$builder->add('table_format', EntityType::class, array(
			'class' => TableFormat::class,
			'choice_label' => 'label',
			'placeholder' => 'fileField.selectTable',
			'label' => 'fileField.auto.label',
			'required' => false,
			'constraints' => array(
				new NotNull()
			), // validation message is directly in FieldMappingController->autoAction
			'query_builder' => function (EntityRepository $er) use($modelId) {
				return $er->createQueryBuilder('t')
					->leftJoin('t.models', 'm')
					->where('m.id = :modelId')
					->orderBy('t.label', 'ASC')
					->setParameter('modelId', $modelId)
				;
				return $qb;
			}
		))
			->add('only_mandatory', CheckboxType::class, array(
			'label' => 'Ajouter seulement les champs obligatoires',
			'required' => false
		))
			->add('with_calculated', CheckboxType::class, array(
			'label' => 'Ajouter également les champs calculés/écrasés à l\'import',
			'required' => false
		))
			->add('submit', SubmitType::class, array(
			'label' => 'fileField.auto.button',
			'attr' => array(
				'formnovalidate' => 'formnovalidate'
			)
		));
	}
}