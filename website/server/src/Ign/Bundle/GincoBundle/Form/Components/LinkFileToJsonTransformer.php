<?php
namespace Ign\Bundle\GincoBundle\Form\Components;

use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\HttpFoundation\File\File;
use Symfony\Component\HttpFoundation\File\UploadedFile;

class LinkFileToJsonTransformer implements DataTransformerInterface
{
	private $uploadDirectory;

	public function __construct($uploadDir)
	{
		$this->uploadDirectory = $uploadDir;
	}

	/**
	* Transforms a JSON string into fields: anchor and file
	*
	*/
	public function transform($data)
	{
		$data = json_decode($data, true);
		$data['uploadedFile'] = null; // Must be an instance of file, but it is always overrided
		return $data;
	}

	/**
	* Transforms the two fields anchor and file into a json string
	 * But before, save the uploaded file
	*/
	public function reverseTransform($data)
	{
		// $file stores the uploaded PDF file
		/** @var Symfony\Component\HttpFoundation\File\UploadedFile $file */
		$file = $data['uploadedFile'];
		$previousFile = $this->uploadDirectory . '/' . $data['file'] ;
		// Upload new file
		if ($file instanceof UploadedFile) {

			// Sanitizing the name for the file before saving it
			$normalizeChars = array(
				'Š'=>'S', 'š'=>'s', 'Ð'=>'Dj','Ž'=>'Z', 'ž'=>'z', 'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A',
				'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E', 'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I',
				'Ï'=>'I', 'Ñ'=>'N', 'Ń'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O', 'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U',
				'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss','à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a',
				'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e', 'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i',
				'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ń'=>'n', 'ò'=>'o', 'ó'=>'o', 'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u',
				'ú'=>'u', 'û'=>'u', 'ü'=>'u', 'ý'=>'y', 'ý'=>'y', 'þ'=>'b', 'ÿ'=>'y', 'ƒ'=>'f',
				'ă'=>'a', 'î'=>'i', 'â'=>'a', 'ș'=>'s', 'ț'=>'t', 'Ă'=>'A', 'Î'=>'I', 'Â'=>'A', 'Ș'=>'S', 'Ț'=>'T',
			);
			$fileNameWithoutAccents = strtr($file->getClientOriginalName(), $normalizeChars);
			$fileNameWithoutSpaces = preg_replace('/\s+/', '_', $fileNameWithoutAccents);
			$fileName =  filter_var ( $fileNameWithoutSpaces, FILTER_SANITIZE_ENCODED );

			// If there is a previous file, we remove it
			if (file_exists($previousFile) && is_file($previousFile)) {
				unlink($previousFile) ;
			}

			// Move the file to the directory where brochures are stored
			$file->move(
				$this->uploadDirectory,
				$fileName
			);
			$data['file'] = $fileName;
		}
		// Don't upload, and suppress file
		else if ($data['suppressFile']) {
			if (file_exists($previousFile) && is_file($previousFile)) {
				unlink($previousFile) ;
			}
			$data['file'] = '';
		}

		unset($data['uploadedFile']);
		unset($data['suppressFile']);

		return json_encode($data);
	}
}
