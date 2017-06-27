<?php
namespace Ign\Bundle\GincoBundle\Form;

use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\NotBlank;

/**
 * This form inherits from the ogam_jdd form
 * and adds the metadata_id field.
 *
 * Class GincoJddType
 * @package Ign\Bundle\GincoBundle\Form
 */
class GincoJddType extends AbstractType  {

	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder->add('metadata_id', TextType::class, array(
			'label' => 'Jdd.new.metadataIdLabel',
			'mapped' => false,
			'constraints' => array(
                    new NotBlank(array('message' => 'Jdd.new.metadataIdNotBlank')),
                ),
		));
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => Jdd::class,
		));
		$resolver->setRequired('entity_manager');
	}

	public function getParent()
	{
		return \Ign\Bundle\OGAMBundle\Form\JddType::class;
	}
}
