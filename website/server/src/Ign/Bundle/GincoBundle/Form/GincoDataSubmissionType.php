<?php
namespace Ign\Bundle\GincoBundle\Form;

use Ign\Bundle\GincoBundle\Entity\RawData\Submission;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

/**
 * This form inherits from the ogam_data_submission form
 *
 * Class DataSubmissionType
 * @package Ign\Bundle\GincoBundle\Form
 */
class GincoDataSubmissionType extends AbstractType  {

	public function buildForm(FormBuilderInterface $builder, array $options) {
		
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

	public function getParent()
	{
		return \Ign\Bundle\GincoBundle\Form\DataSubmissionType::class;
	}
}
