<?php
require_once APPLICATION_PATH . '/controllers/AbstractOGAMController.php';

include_once APPLICATION_PATH . '/controllers/IndexController.php';

/**
 * Custom Index Controller for GINCO
 * @package controllers
 */
class Custom_IndexController extends AbstractOGAMController {

	/**
	 * The "index" action is the default action for all controllers.
	 * This
	 * will be the landing page of your application.
	 */
	public function indexAction() {
		$this->logger->debug('index du custom index controller');
		
		try {
			$this->render('custom-index');
		} catch (Exception $e) {
			$this->logger->err($e->getMessage());
			$this->render('index');
		}
	}

}
