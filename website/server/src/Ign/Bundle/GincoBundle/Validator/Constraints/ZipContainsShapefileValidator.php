<?php

namespace Ign\Bundle\GincoBundle\Validator\Constraints;

use Symfony\Component\Validator\Constraint;
use Symfony\Component\Validator\ConstraintValidator;
use Symfony\Component\Validator\Exception\UnexpectedTypeException;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Bundle\FrameworkBundle\Translation\Translator;

/**
 * Description of ZipContainsShapefileValidator
 *
 * @author rpas
 */
class ZipContainsShapefileValidator extends ConstraintValidator {
	
	/**
	 *
	 * @var Translator
	 */
	private $translator ;
	
	
	public function __construct(Translator $translator) {
		$this->translator = $translator ;
	}
	
	
	
	public function validate($value, Constraint $constraint) {
		
		if (!$constraint instanceof ZipContainsShapefile) {
			throw new UnexpectedTypeException($constraint, ZipContainsShapefile::class) ;
		}
		
		if (null === $value || '' === $value) {
			return ;
		}
		
		/* @var $file UploadedFile */
		$file = $value ;
		
		// On ne traite dans cette validation que les fichiers ZIP.
		if ('application/zip' !== $file->getMimeType()) {
			return ;
		}		
		
		$filename = basename($file->getClientOriginalName(), ".zip") ;
		
		// Read zip archive to find shapefile files.
		list($hasSHP, $hasDBF, $hasSHX, $hasPRJ) = [false, false, false, false] ;
		$zip = new \ZipArchive();
		if ($zip->open($file->getPathname()) === TRUE) {
			for ($i = 0 ; $i < $zip->numFiles ; ++$i) {
				$name = basename($zip->getNameIndex($i)) ;
				switch($name) {
					case "$filename.shp" :
						$hasSHP = true ;
						break ;
					case "$filename.dbf" :
						$hasDBF = true ;
						break ;
					case "$filename.shx" :
						$hasSHX = true ;
						break ;
					case "$filename.prj" :
						$hasPRJ = true ;
						break ;
				}
			}
			$zip->close();
		}
		
		$isValid = $hasSHP && $hasDBF && $hasSHX && $hasPRJ ;
		if (!$isValid) {
			// We add an error to the form
			$this->context
				->buildViolation($this->translator->trans($constraint->message))
				->addViolation()
			;
		}
	}
}
