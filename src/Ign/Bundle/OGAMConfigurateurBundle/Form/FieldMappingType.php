<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Form;

use Ign\Bundle\OGAMConfigurateurBundle\Entity\FieldMapping;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableField;
use Ign\Bundle\OGAMConfigurateurBundle\Entity\TableFormat;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\HiddenType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\FormEvent;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\Form\FormInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class FieldMappingType extends AbstractType {

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $formOptions) {
		$fileFormat = $formOptions['fileFormat'];
		$modelId = $formOptions['modelId'];
		$em = $formOptions['em'];

		$builder->add('mappingFunction', ChoiceType::class, array(
			'choices' => array(
				'Copier' => 'fieldMapping.copy'
			),
			'mapped' => false,
			'label' => false
		));

		$builder->add('src_format', HiddenType::class, array(
			'data' => $fileFormat
		));

		$srcDataChoices = array();
		$srcData = $em->getRepository('IgnOGAMConfigurateurBundle:FileField')->findFieldsByFileFormat($fileFormat);
		foreach ($srcData as $data) {
			$srcDataChoices[$data['fieldName']] = $data['label'];
		}
		$builder->add('src_data', ChoiceType::class, array(
			'placeholder' => 'fieldMapping.selectFileField',
			'required' => false,
			'label' => false,
			'choices' => $srcDataChoices
		));

		$srcFormatChoices = array();
		$model = $em->getRepository('IgnOGAMConfigurateurBundle:Model')->find($modelId);
		foreach ($model->getTables() as $table) {
			$srcFormatChoices[$table->getFormat()] = $table->getLabel();
		}
		$builder->add('dst_format', ChoiceType::class, array(
			'placeholder' => 'fieldMapping.selectTable',
			'required' => false,
			'label' => false,
			'choices' => $srcFormatChoices
		));

		$builder->add('enregistrer', SubmitType::class, array(
			'label' => 'Save',
			'attr' => array(
				'formnovalidate' => 'formnovalidate'
			)
		));

		// We add a select list dst_data dynamically (cf ajax in the twig)
		$formModifier = function (FormInterface $form, $tableFormat = null) use($em, $fileFormat) {
			$choices = array();
			if ($tableFormat !== null) {
				// Non technical Fields + Keys
				$dstData = $em->getRepository('IgnOGAMConfigurateurBundle:TableField')->findNonTechnicalByTableFormat($tableFormat);
				$keysData = $em->getRepository('IgnOGAMConfigurateurBundle:TableField')->findKeysByTableFormat($tableFormat);
				$allData = array_merge($keysData, $dstData);
				foreach ($allData as $data) {
					$label = $em->getRepository('IgnOGAMConfigurateurBundle:Data')->find($data->getData())->getLabel();
					$choices[$data->getData()] = $label;
				}
			}

			$form->add('dst_data', ChoiceType::class, array(
				'choices' => $choices,
				//'choices_as_values'=> true,
				'label' => false
			));
		};

		// before form submit
		$builder->addEventListener(FormEvents::PRE_SET_DATA, function (FormEvent $event) use($formModifier, $em) {
			$data = $event->getData();
			$formModifier($event->getForm(), $data->getDstFormat());
		});

		// after form submit
		$builder->get('dst_format')->addEventListener(FormEvents::POST_SUBMIT, function (FormEvent $event) use($formModifier) {
			// $event->getForm()->getData() send the initial value (empty)
			$tableFormat = $event->getForm()->getData();
			// the event listener is on the child (dstData),
			// the parent (dstFormat) must be pass to the callback functions
			$formModifier($event->getForm()->getParent(), $tableFormat);
		});
	}

	/**
	 *
	 * @param OptionsResolverInterface $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => 'Ign\Bundle\OGAMConfigurateurBundle\Entity\FieldMapping',
			'fileFormat' => null,
			'modelId' => null,
			'em' => null
		));
	}

	/**
	 *
	 * @return string
	 */
	public function getBlockPrefix() {
		return 'ign_bundle_configurateurbundle_field_mapping';
	}
}