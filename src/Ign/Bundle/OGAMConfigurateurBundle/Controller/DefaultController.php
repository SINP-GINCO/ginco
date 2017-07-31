<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class DefaultController extends Controller {

	/**
	 * @Route("/", name="configurateur_homepage")
	 * @Template()
	 */
	public function indexAction() {
		return array();
	}
}
