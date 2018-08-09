<?php
namespace Ign\Bundle\GincoBundle\Form;

use Doctrine\Common\Persistence\ObjectManager;

use Ign\Bundle\GincoBundle\Form\Components\ProviderToStringTransformer;
use Ign\Bundle\GincoBundle\Services\INPNProviderService;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;

class ProviderSearchType extends AbstractType {
    
        private $objectManager;

	private $inpnProviderService;

	public function __construct(ObjectManager $objectManager, INPNProviderService $inpnProviderService) {
		$this->objectManager = $objectManager;
		$this->inpnProviderService = $inpnProviderService;
	}

	/**
	 * Build the provider form.
	 *
	 * @param FormBuilderInterface $builder        	
	 * @param array $options        	
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {

		$builder->add('label', TextType::class, array(
			'label' => 'Providers.add.label',
                        'attr' => array(
                            'class' => 'inpn_provider_autocomplete'
                        )
                        ))
                        ->add('submit', SubmitType::class, array(
			'label' => 'Validate'
                        ));
                
                $builder->get('label')->addModelTransformer(new ProviderToStringTransformer($this->objectManager, $this->inpnProviderService));
	}

	/**
	 *
	 * @param OptionsResolver $resolver        	
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array());
	}
}
