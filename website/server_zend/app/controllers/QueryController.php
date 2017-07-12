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
include_once APPLICATION_PATH . '/controllers/QueryController.php';

/**
 * QueryController is the controller that manages the query module.
 *
 * @package controllers
 */
class Custom_QueryController extends QueryController {

	/**
	 * AJAX function : Nodes of a taxonomic referential under a given node.
	 *
	 * @return JSON.
	 */
	public function ajaxgettaxrefnodesAction() {
		$this->logger->debug('custom ajaxgettaxrefnodesAction');

		$unit = $this->getRequest()->getParam('unit');
		$code = $this->getRequest()->getPost('node');
		$depth = $this->getRequest()->getParam('depth');

		$customMetadata = new Application_Model_Metadata_CustomMetadata();
		$tree = $customMetadata->getTaxrefChildren($unit, $code, $depth);

		// Send the result as a JSON String
		$json = '{"success":true,' . '"data":[' . $tree->toJSON() . ']' . '}';

		echo $json;

		// No View, we send directly the JSON
		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
		$this->getResponse()->setHeader('Content-type', 'application/json');
	}

	/**
	 * Returns a kml file corresponding to the requested data.
	 * KML export is not defined in GINCO because of the hiding of geometry
	 */
	public function kmlExportAction() {
		$this->logger->debug('gridKMLExportAction');

		// Define the header of the response
		$configuration = Zend_Registry::get("configuration");
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');
		$this->getResponse()->setHeader('Content-Type', 'application/vnd.google-earth.kml+xml;charset=' . $charset . ';application/force-download;', true);
		$this->getResponse()->setHeader('Content-disposition', 'attachment; filename=DataExport_' . date('dmy_Hi') . '.kml', true);

		$this->outputCharset("// L'export KML n'est pas prévu dans GINCO, merci de contacter l'administrateur.");

		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
	}

	/**
	 * Returns a geoJSON file corresponding to the requested data.
	 * GeoJson export is not defined in GINCO
	 */
	public function geojsonExportAction() {
		$this->logger->debug('geojsonExportAction');

		// Define the header of the response
		$configuration = Zend_Registry::get("configuration");
		$charset = $configuration->getConfig('csvExportCharset', 'UTF-8');
		$this->getResponse()->setHeader('Content-Type', 'application/json;charset=' . $charset . ';application/force-download;', true);
		$this->getResponse()->setHeader('Content-disposition', 'attachment; filename=DataExport_' . date('dmy_Hi') . '.geojson', true);

		$this->outputCharset("// L'export GeoJson n'est pas prévu dans GINCO, merci de contacter l'administrateur.");

		$this->_helper->layout()->disableLayout();
		$this->_helper->viewRenderer->setNoRender();
	}
}