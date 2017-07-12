<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Template;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericTableFormat;
use Ign\Bundle\OGAMBundle\Controller\DataEditionController as BaseController;

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
	 * Disabled in Ginco.
	 *
	 * @return JSON The list of forms
	 *         @Route("/ajax-get-edit-form/{id}", requirements={"id"= ".*"}, name="dataedition_ajaxGetEditForm")
	 */
	public function ajaxGetEditFormAction(Request $request, $id = null) {
		// Redirect to home page
		return $this->redirectToRoute('homepage');
	}

	/**
	 * AJAX function : Get the AJAX structure corresponding to the add form.
	 * Disabled in Ginco.
	 *
	 * @return JSON The list of forms
	 *         @Route("/ajax-get-add-form/{id}", requirements={"id"= ".*"}, name="dataedition_ajaxGetAddForm")
	 */
	public function ajaxGetAddFormAction(Request $request, $id = null) {
		// Redirect to home page
		return $this->redirectToRoute('homepage');
	}
}
