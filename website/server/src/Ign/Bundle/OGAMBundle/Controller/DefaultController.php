<?php
namespace Ign\Bundle\OGAMBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

class DefaultController extends GincoController {

	/**
	 * @Route("/", name="homepage")
	 */
	public function indexAction() {
		$logger = $this->get('logger');
		$logger->info('indexAction');

		/*
		 * $userRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
		 * $users = $userRepo->findAll();
		 *
		 * $appRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\ApplicationParameter', 'website');
		 * $applicationParameters = $appRepo->findAll();
		 *
		 * $modeRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Metadata\Mode', 'metadata');
		 * $mode = $modeRepo->find(array('unit' => 'PROVIDER_ID', 'code' => '1'));
		 *
		 * $tableFieldRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Metadata\TableField', 'metadata');
		 * $tableField = $tableFieldRepo->find(array('format' => 'PLOT_DATA', 'data' => 'COMMENT'));
		 *
		 * $layersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Mapping\Layer', 'mapping');
		 * $layers = $layersRepo->findAll();
		 */

		return $this->render('OGAMBundle:Default:index.html.twig', array());
	}
}
