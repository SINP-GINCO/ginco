<?php
namespace Ign\Bundle\OGAMBundle\Controller;

use Ign\Bundle\OGAMBundle\Entity\Mapping\LayerTreeNode;
use Ign\Bundle\OGAMBundle\Entity\Mapping\ProviderMapParameters;
use Ign\Bundle\OGAMBundle\Entity\Mapping\ZoomLevel;
use Ign\Bundle\OGAMBundle\Entity\Website\User;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * @Route("/map")
 */
class MapController extends GincoController {

	/**
	 * Get the parameters used to initialise a map.
	 * @Route("/get-map-parameters")
	 */
	public function getMapParametersAction() {

		$user = $this->getUser();
		$providerId = $user->getProvider()->getId();

		// Get the parameters from configuration file
		$configuration = $this->get("ogam.configuration_manager");
		$view = new \ArrayObject();
		$view->setFlags(\ArrayObject::ARRAY_AS_PROPS);
		$view->bbox_x_min = $configuration->getConfig('bbox_x_min'); // x min of Bounding box
		$view->bbox_y_min = $configuration->getConfig('bbox_y_min'); // y min of Bounding box
		$view->bbox_x_max = $configuration->getConfig('bbox_x_max'); // x max of Bounding box
		$view->bbox_y_max = $configuration->getConfig('bbox_y_max'); // y max of Bounding box
		$view->tilesize = $configuration->getConfig('tilesize', 256); // Tile size
		$view->projection = "EPSG:" . $configuration->getConfig('srs_visualisation'); // Projection

		// Get the map resolution
		$resolutions = $this->get('doctrine')
			->getRepository(ZoomLevel::class)
			->getResolutions();
		$resolString = implode(",", $resolutions);
		$view->resolutions = $resolString;
		$view->numZoomLevels = count($resolutions);

		$userPerProviderCenter = ($configuration->getConfig('usePerProviderCenter', true) === '1');

		if ($userPerProviderCenter) {
			// Center the map on the provider location
			$providerParams = $this->getDoctrine()
				->getManagerForClass(ProviderMapParameters::class)
				->find(ProviderMapParameters::class, $providerId);
			$center = $providerParams->getCenter();
			$view->zoomLevel = $providerParams->getZoomLevel()->getZoomLevel();
			list($view->centerX, $view->centerY) = $center;
		} else {
			// Use default settings
			$view->zoomLevel = $configuration->getConfig('zoom_level', '1');
			$view->centerX = ($view->bbox_x_min + $view->bbox_x_max) / 2;
			$view->centerY = ($view->bbox_y_min + $view->bbox_y_max) / 2;
		}

		// Feature parameters
		$view->featureinfo_margin = $configuration->getConfig('featureinfo_margin', '1000');
		$view->featureinfo_typename = $configuration->getConfig('featureinfo_typename', "result_locations");
		$view->featureinfo_maxfeatures = $configuration->getConfig('featureinfo_maxfeatures', 20);

		// Rights parameters
		$view->checkEditionRights = ($user->isAllowed('DATA_EDITION_OTHER_PROVIDER')) ? 0 : 1 ;
		return $this->render('OGAMBundle:Map:get_map_parameters.js.twig', $view->getArrayCopy(), (new Response())->headers->set('Content-type', 'application/javascript'));
	}

	/**
	 * Return the list of available layer tree nodes as a JSON.
	 *
	 * @Route("/ajaxgetlayertreenodes")
	 */
	public function ajaxgetlayertreenodesAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('ajaxgetlayertreenodes');

		$response = new Response();
		$response->headers->set('Content-Type', 'application/json');
		return $this->render('OGAMBundle:Map:ajaxgetlayertreenodes.json.twig', array(
			'layerTreeNodes' => $this->get('doctrine')
				->getRepository(LayerTreeNode::class)
				->findBy([], [
				'position' => 'DESC'
			])
		), $response);
	}
}
