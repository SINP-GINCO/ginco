<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

use Symfony\Component\HttpFoundation\BinaryFileResponse;

class UploadedFileController extends GincoController {
	

	/**
	 * @Route("/file/{file}", name="file_show")
	 */
	public function showAction($file) {
		
		$uploadDirectory = $this->get('ginco.configuration_manager')->getConfig('UploadDirectory') ;
		
		$filePath = $uploadDirectory . DIRECTORY_SEPARATOR . $file ;
		if (!file_exists($filePath)) {
			throw $this->createNotFoundException("$file not found.") ;
		}
		
		return new BinaryFileResponse($filePath) ;
	}
	
}
