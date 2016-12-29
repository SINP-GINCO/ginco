<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;

class TableFormatType extends AbstractType {

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->add('label', TextType::class, array(
			'attr' => array(
				'read_only' => false
			),
			'label' => 'Name'
		));
		$builder->add('description', TextareaType::class, array(
			'attr' => array(
				'resize' => 'none'
			),
			'required' => false
		));

		// Parent chooser : if the table already exists, all tables of the model, minus child tables of the given table ;
		// if not, all the tables of the model.
		$choices = array();
		$alltables = $options['model']->getTables()->toArray();
		if ($options['tableFormat']) {
			$conn = $options['conn'];
			$em = $options['em'];
			$tableTreeRepository = $em->getRepository('IgnOGAMConfigurateurBundle:TableTree');
			$childTables = $tableTreeRepository->findChildTablesByTableFormat($options['tableFormat'], $conn);
		} else {
			$childTables = array();
		}
		foreach ($alltables as $table) {
			if (!in_array($table->getFormat(), $childTables) && ($table->getFormat() != $options['tableFormat'])) {
				$choices[$table->getFormat()] = $table->getLabel();
			}
		}

		$builder->add('parent', ChoiceType::class, array(
			'label' => 'Parent table',
			'placeholder' => 'table.updateForm.emptyParent',
			'required' => false,
			// 'mapped' => false,
			// 'data' => $options['parent'],
			'choices' => $choices
		));

		$builder->add('save', SubmitType::class, array(
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
			'data_class' => 'Ign\Bundle\OGAMConfigurateurBundle\Entity\TableFormat',
			'model' => null,
			'tableFormat' => null,
			'conn' => null,
			'em' => null
		));
	}

	/**
	 *
	 * @return string
	 */
	public function getBlockPrefix() {
		return 'ign_bundle_configurateurbundle_table_format_edit';
	}
}