<?php
namespace Ign\Bundle\GincoBundle\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\HiddenType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormError;
use Ign\Bundle\GincoBundle\Entity\Website\ProviderInpn;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\Form\FormEvent;


class ProviderInpnType extends AbstractType {

	/**
	 * Build the provider form.
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		$builder
		->add('label', TextType::class, array(
			'label' => 'Label'
		))
		->add('submit', SubmitType::class, array(
			'label' => 'Submit'
		));
		
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => ProviderInpn::class,
		));
	}
}
