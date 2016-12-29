<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;
use Ign\Bundle\OGAMConfigurateurBundle\Controller\ModelController as ModelControllerBase;

class ModelController extends ModelControllerBase {

	/**
	 * #600 : Forbid access to model creation.
	 * User is only allowed to
	 * create a model with duplication functionality.
	 * @Route("/models/new/", name="configurateur_model_new")
	 */
	public function newAction(Request $request) {
		$this->addFlash('error', $this->get('translator')
			->trans('datamodel.new.forbidden'));

		return $this->redirectToRoute('configurateur_model_index');
	}
}
