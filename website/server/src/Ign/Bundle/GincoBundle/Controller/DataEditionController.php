<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericTableFormat;
use Ign\Bundle\OGAMBundle\Controller\DataEditionController as BaseController;
use Symfony\Component\Serializer\Serializer;
use Symfony\Component\Serializer\Normalizer\PropertyNormalizer;
use Symfony\Component\Serializer\Normalizer\ObjectNormalizer;

/**
 * @Route ("/dataedition")
 */
class DataEditionController extends BaseController {

	/**
	 * Add a new data.
	 * Disabled in Ginco.
	 *
	 * @param GenericTableFormat $data
	 *        	The data to display (optional)
	 * @param String $message
	 *        	A confirmation/warning message to display
	 * @return the HTML view
	 *         @Route("/show-add-data/{id}", requirements={"id"= ".*"}, name="dataedition_showAddData")
	 *         @Template(engine="php")
	 */
	public function showAddDataAction(Request $request, GenericTableFormat $data = null, $message = '') {
		// Redirect to home page
		return $this->redirectToRoute('homepage');
	}

	/**
	 * AJAX function : Get the AJAX structure corresponding to the edition form.
	 *
	 * @return JSON The list of forms
	 *         @Route("/ajax-get-edit-form/{id}", requirements={"id"= ".*"}, name="dataedition_ajaxGetEditForm")
	 */
	public function ajaxGetEditFormAction(Request $request, $id = null) {
		$data = $this->getDataFromRequest($request);

		// Complete the data object with the existing values from the database.
		$genericModel = $this->get('ogam.manager.generic');
		// A user not allowed to see sensitive data should not have rights to edit data.
		// As it is permitted by the persmission configuration, we use getDatumGinco to hide sensitive fields all the same.
		$requestId = $this->get('doctrine')->getRepository('Ign\Bundle\GincoBundle\Entity\Mapping\Request', 'mapping')->getLastRequestIdFromSession(session_id());
		$data = $genericModel->getDatumGinco($data, $requestId);

		// The service used to manage the query module
		$res = $this->getQueryService()->getEditForm($data);

		$bag = $request->getSession();
		json_encode($data);
		$ser = new Serializer(array(
			new PropertyNormalizer(),
			new ObjectNormalizer()
		));
		//FIXME: Comes from OGAM and not useful?
		//$ser->normalize($data); // FIXME : treewalker force loading proxy element ...
		//$bag->set('data', $data);
		return $this->json($res);
	}

/**
 * AJAX function : Get the AJAX structure corresponding to the add form.
 * Disabled in Ginco.
 *
 * @return JSON The list of forms
 *         @Route("/ajax-get-add-form/{id}", requirements={"id"= ".*"}, name="dataedition_ajaxGetAddForm")
 */
	// public function ajaxGetAddFormAction(Request $request, $id = null) {
	// // Redirect to home page
	// return $this->redirectToRoute('homepage');
	// }
}
