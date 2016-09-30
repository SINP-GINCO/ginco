<?php
/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 * 
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices. 
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents. 
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */
//require_once 'AbstractOGAMController.php';
include_once APPLICATION_PATH . '/controllers/DataeditionController.php';
/**
 * DataEditionController is the controller that allow the edition of simple data.
 * @package controllers
 */
class Custom_DataEditionController extends DataEditionController {

	/**
	 * The "index" action is the default action for all controllers.
	 *
	 * @return the index view
	 */
	public function indexAction() {
		$this->chooseFormatAction();
	}

	/**
	 * Presents to user a choice in
	 * all tables in schema RAW_DATA
	 */
	public function chooseFormatAction() {

		// Query format and labels in metadat.table_format, where schema_code = RAW_DATA
		// (not done in models, it's why we do a direct sql request here).
		$db = Zend_Db_Table::getDefaultAdapter();

		$req = "SELECT tf.format, tf.label, m.id, m.name
				FROM metadata.table_format tf
 				LEFT JOIN metadata.model_tables mt ON mt.table_id = tf.format
 				INNER JOIN  metadata.model m ON mt.model_id = m.id
				WHERE tf.schema_code = 'RAW_DATA'";
		$query = $db->prepare($req);
		$query->execute(array());

		$results = $query->fetchAll();

		// titles for grouping tables by models
		$this->view->models = array();
		// table names and formats, grouped by model ids
		$this->view->formats = array();
		foreach ($results as $result) {
			$this->view->models[$result['id']] = $result ['name'];
			$this->view->formats[$result['id']][$result['format']] = $result['label'];
		}

		return $this->render('choose-format');
	}

}
