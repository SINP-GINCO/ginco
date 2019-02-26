<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\FormEvent;
use Symfony\Component\Form\FormEvents;

use Doctrine\ORM\EntityManagerInterface;

use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;
use Ign\Bundle\GincoBundle\Repository\Metadata\TableFormatRepository;

class TableFormatType extends AbstractType {
	
	
	/**
	 *
	 * @var EntityManagerInterface
	 */
	private $entityManager ;
	
	
	public function __construct(EntityManagerInterface $entityManager) {
		$this->entityManager = $entityManager ; 
	}

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
		
		$builder->addEventListener(FormEvents::POST_SET_DATA, function (FormEvent $event) {
			
			$tableFormat = $event->getData() ;
			$form = $event->getForm() ;
			
			$form
				->add('parent', EntityType::class, array(
					'class' => TableFormat::class,
					'em' => 'metadata',
					'choices' => $this->entityManager->getRepository('IgnGincoBundle:Metadata\TableFormat')->findNotChildTables($tableFormat),
					'choice_label' => 'label',
					'label' => 'Parent table',
					'placeholder' => 'table.updateForm.emptyParent',
					'required' => false
				))
				->add('save', SubmitType::class, array(
					'attr' => array(
						'formnovalidate' => 'formnovalidate'
					),
					'label' => 'Save'
				))
			;
			
		});
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => TableFormat::class
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