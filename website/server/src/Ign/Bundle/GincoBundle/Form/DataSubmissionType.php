<?php
namespace Ign\Bundle\GincoBundle\Form;

use Doctrine\ORM\EntityRepository;
use Ign\Bundle\GincoBundle\Entity\RawData\Submission;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\HiddenType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\OptionsResolver\OptionsResolver;

use Ign\Bundle\GincoBundle\Entity\Metadata\Dataset;

class DataSubmissionType extends AbstractType {

	/**
	 * Build the data submission form.
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		// If no jdd is provided, all datasets are proposed
		if (null == $options['jdd']) {
			$builder
				->add('dataset', EntityType::class, array(
					'label' => 'Dataset',
					'class' => 'IgnGincoBundle:Metadata\Dataset',
					'choice_label' => 'label',
					'query_builder' => function (EntityRepository $er) {
						return $er->createQueryBuilder('d')
							->leftJoin('d.files', 'f')
							->where('f.format IS NOT NULL')
							->where('d.status = :status')
							->setParameter('status', Dataset::PUBLISHED)
							->orderBy('d.label', 'ASC');
					}
				)
			);
		}
		// If a jdd is provided, filter datasets by the model of the jdd
		// And add jdd id as hidden field
		else {
			$datasets = $options['jdd']->getModel()->getPublishedImportDatasets();
			$builder
				->add('dataset', EntityType::class, array(
						'label' => 'Dataset',
						'class' => 'IgnGincoBundle:Metadata\Dataset',
						'choice_label' => 'label',
						'choices' => $datasets
					))
				->add('jddid', HiddenType::class, array(
					'data' => $options['jdd']->getId(),
					'mapped' => false,
				));
		}
		$builder->add('submit', SubmitType::class);
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => Submission::class,
		));
		$resolver->setRequired('jdd');
	}
}
