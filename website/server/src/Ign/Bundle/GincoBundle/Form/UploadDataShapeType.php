<?php
namespace Ign\Bundle\GincoBundle\Form;

use Doctrine\ORM\EntityRepository;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Entity\RawData\Submission;
use Symfony\Component\Form\AbstractType;
use Ign\Bundle\GincoBundle\GincoBundle;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Validator\Constraints\Type;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Validator\Constraints\Regex;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Validator\Constraints\File;
use Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat;

class UploadDataShapeType extends AbstractType {

	/**
	 *
	 * @param FormBuilderInterface $builder
	 * @param array $options
	 */
	public function buildForm(FormBuilderInterface $builder, array $options) {
		$submission = $options['data']['submission'];
		$fileMaxSize = $options['data']['fileMaxSize'];
		$requestedFiles = $submission->getDataset()->getFiles();
		
		foreach ($requestedFiles as $requestedFile) {
			// Checks if geom unit field is present in the file
			$fileLabel = $requestedFile->getLabel();
			$builder->add($requestedFile->getFormat(), FileType::class, array(
				'data_class' => null,
				'label' => $fileLabel,
				'empty_data' => 'Veuillez sélectionner un fichier',
				'block_name' => 'fileformat',
				'mapped' => false,
				'required' => true,
				'constraints' => array(
					new File(array(
						'maxSize' => "${fileMaxSize}Mi"
					))
				)
			));
		}

		$builder->add('submit', SubmitType::class);
	}

	/**
	 *
	 * @param OptionsResolver $resolver
	 */
	public function configureOptions(OptionsResolver $resolver) {

	}
}
