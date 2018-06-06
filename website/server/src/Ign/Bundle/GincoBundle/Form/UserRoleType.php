<?php
namespace Ign\Bundle\GincoBundle\Form;

use Ign\Bundle\GincoBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Form\Components\ProviderToStringTransformer;
use Ign\Bundle\GincoBundle\Services\INPNProviderService;
use Doctrine\Common\Persistence\ObjectManager;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

/**
 * This form is used instead the regular Ogam user form.
 * It allows only to affect/remove roles to an user
 * Fields of the User are not editable (CAS authentification, Users come from INPN)
 *
 * Class UserRoleType
 *
 * @package Ign\Bundle\GincoBundle\Form
 */
class UserRoleType extends AbstractType {

	private $objectManager;

	private $inpnProviderService;

	public function __construct(ObjectManager $objectManager, INPNProviderService $inpnProviderService) {
		$this->objectManager = $objectManager;
		$this->inpnProviderService = $inpnProviderService;
	}

	public function buildForm(FormBuilderInterface $builder, array $options) {
		// Roles
		$builder->add('roles', EntityType::class, array(
			'label' => 'Roles',
			'class' => 'Ign\Bundle\GincoBundle\Entity\Website\Role',
			'choice_label' => 'label',
			'multiple' => true,
			'expanded' => true
		))->add('provider', TextType::class, array(
			'label' => 'Providers.add.label',
			'invalid_message' => 'administration.provider.inpn_error_label'
		));
		
		$builder->add('submit', SubmitType::class, array(
			'label' => 'Submit'
		));
		
		$builder->get('provider')->addModelTransformer(new ProviderToStringTransformer($this->objectManager, $this->inpnProviderService));
	}

	/**
	 *
	 * @param OptionsResolver $resolver        	
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => User::class
		));
	}
}
