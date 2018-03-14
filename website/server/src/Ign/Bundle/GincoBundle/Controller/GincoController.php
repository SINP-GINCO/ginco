<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

/**
 * This controller overrides the getUser() method to allow retrieving
 * the visitor user object.
 * All other controllers MUST extend this class instead of the original Controller class.
 *
 * @author Gautam Pastakia
 *
 */
class GincoController extends Controller {

	public function getUser() {
		$user = parent::getUser();

		if (!is_object($user)) {
			$user = $this->get('app.anonymous_user')->getUser();
		}

		return $user;
	}
}
