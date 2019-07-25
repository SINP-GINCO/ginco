<?php

namespace Ign\Bundle\GincoBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;

use Ign\Bundle\GincoBundle\Entity\RawData\Submission ;
use Ign\Bundle\GincoBundle\Entity\Metadata\FileFormat ;

/**
 * Description of ZipContainsShapefile
 *
 * @author rpas
 */
class ZipContainsShapefile extends Constraint {
	
	
	public $message = 'import.format.shp.files' ;
	
	
	/**
	 * Submission contenant ce fichier.
	 * Doit être public pour que le constructeur l'accepte comme une option. 
	 * @var Submission 
	 */
	public $submission ;
	
	/**
	 *
	 * @var FileFormat
	 */
	public $fileFormat ;
	
	public function __construct(array $options = null) {
		
		if (isset($options['submission'])) {
			$this->submission = $options['submission'] ;
		}
		
		if (isset($options['fileFormat'])) {
			$this->fileFormat = $options['fileFormat'] ;
		}
		
		parent::__construct($options) ;
	}
	
	
	/**
	 * Get submission
	 * @return Submission
	 */
	public function getSubmission() : Submission {
		return $this->submission ;
	}
	
	/**
	 * Get file format
	 * @return FileFormat
	 */
	public function getFileFormat() : FileFormat {
		return $this->fileFormat ;
	}
	
	/**
	 * 
	 * @return array
	 */
	public function getRequiredOptions(): array {
		
		$requiredOptions = parent::getRequiredOptions() ;
		$requiredOptions[] = "submission" ;
		return $requiredOptions ;
 	}
	
	
	/**
	 * Validated by
	 * @return string
	 */
	public function validatedBy(): string {
		
		return ZipContainsShapefileValidator::class ;
	}
}
