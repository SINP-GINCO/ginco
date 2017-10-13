<?php
namespace Ign\Bundle\GincoBundle\Form\Components;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints\File;
use Symfony\Component\Validator\Constraints\NotBlank;
use Symfony\Component\OptionsResolver\OptionsResolverInterface;

/**
 * Class LinkFileType
 * A custom form type for links to uploaded files
 * @package Ign\Bundle\GincoBundle\Form
 */
class LinkFileType extends AbstractType
{
	private $uploadDirectory;

	public function __construct($uploadDir)
	{
		$this->uploadDirectory = $uploadDir;
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
	}

	public function setDefaultOptions(OptionsResolverInterface $resolver)
	{
	}
}