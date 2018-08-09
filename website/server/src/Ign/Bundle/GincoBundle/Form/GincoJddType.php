<?php
namespace Ign\Bundle\GincoBundle\Form;

use Doctrine\Common\Persistence\ObjectManager;

use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Form\Components\ProviderToStringTransformer;
use Ign\Bundle\GincoBundle\Services\INPNProviderService;

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

        private $objectManager;

	private $inpnProviderService;

	public function __construct(ObjectManager $objectManager, INPNProviderService $inpnProviderService) {
		$this->objectManager = $objectManager;
		$this->inpnProviderService = $inpnProviderService;
	}
        
        
	public function buildForm(FormBuilderInterface $builder, array $options) {
		
                $builder->add('metadata_id', TextType::class, array(
			'label' => 'Jdd.new.metadataIdLabel',
			'mapped' => false,
			'constraints' => array(
                            new NotBlank(array('message' => 'Jdd.new.metadataIdNotBlank')),
                        )
		));
                
                if ($options['user']->isAllowed('MANAGE_DATASETS_OTHER_PROVIDER')){
                    $builder->add('provider', TextType::class, array(
                        'label' => 'Jdd.new.provider',
                        'mapped' => false,
                        'required' => false,
                        'attr' => array(
                            'class' => 'inpn_provider_autocomplete'
                        )
                    ));
                    
                    $builder->get('provider')->addModelTransformer(new ProviderToStringTransformer($this->objectManager, $this->inpnProviderService));
                }
                
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {
		$resolver->setDefaults(array(
			'data_class' => Jdd::class,
			'user' => null
		));
		$resolver->setRequired('entity_manager');
	}

	public function getParent()
	{
		return \Ign\Bundle\GincoBundle\Form\JddType::class;
	}
}
