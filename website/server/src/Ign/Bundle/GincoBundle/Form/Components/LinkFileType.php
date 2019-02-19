<?php
namespace Ign\Bundle\GincoBundle\Form\Components;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;

use Symfony\Component\Form\FormEvent;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\Form\FormError;



use Ign\Bundle\GincoBundle\Services\ConfigurationManager;

/**
 * Class LinkFileType
 * A custom form type for links to uploaded files
 * @package Ign\Bundle\GincoBundle\Form
 */
class LinkFileType extends AbstractType
{
	private $uploadDirectory;

	public function __construct(ConfigurationManager $configurationManager)
	{
		$this->uploadDirectory = $configurationManager->getConfig('UploadDirectory') ;
	}

	public function buildForm(FormBuilderInterface $builder, array $options)
	{
		$builder
			->add('anchor', TextType::class, array(
				'label' => 'Name',
				// 'attr' => ['data-help'  => 'Nom du fichier à afficher'],
			))
			->add('file', TextType::class, array(
				'disabled' => true,
				'label' => 'Upload.File',
			))
			->add('uploadedFile', FileType::class, array(
				'label' => ''
			))
			->add('suppressFile', CheckboxType::class, array(
				'label' => 'Suppress'
			))
			->addModelTransformer(new LinkFileToJsonTransformer($this->uploadDirectory))
		;
		
		$builder->addEventListener(FormEvents::SUBMIT, function (FormEvent $event) {
			
			$data = $event->getData() ;
			$form = $event->getForm() ;
			
			/* @var $uploadedFile \Symfony\Component\HttpFoundation\File\UploadedFile */
			$uploadedFile = $data['uploadedFile'] ;
			if ($uploadedFile && !in_array($uploadedFile->getMimeType(), ['application/pdf'])) {
				$form->get('uploadedFile')->addError(new FormError("Seuls les fichiers PDF sont autorisés.")) ;
			}
		});
	}

}