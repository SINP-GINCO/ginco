<?php
namespace Ign\Bundle\OGAMBundle\Helper;

use Symfony\Component\Templating\Helper\Helper;
use Ign\Bundle\OGAMBundle\Entity\Generic\GenericField;

class GenerateAddLink extends Helper {

	/**
	 * Generate a link corresponding to a data object
	 *
	 * @param String $schema
	 *        	The schema
	 * @param String $format
	 *        	The format
	 * @param Array[GenericField] $infoFields
	 *        	The primary keys
	 * @return String the URL for the link
	 */
	function getAddLink($schema, $format, $infoFields) {
		
		// Build the URL to link to the parent items
		$urlArray = array()
		// 'controller' => 'dataedition',
		// 'action' => 'show-add-data'
		;
		
		// Add the schema
		$urlArray['SCHEMA'] = $schema;
		
		// Add the format
		$urlArray['FORMAT'] = $format;
		
		// Add the PK elements
		foreach ($infoFields as $infoField) {
			$urlArray[$infoField->getData()] = $infoField->getValue();
		}
		
		$uri = '';
		foreach (array_filter($urlArray) as $key => $val) {
			$uri .= "/$key/$val";
		}
		// output the result
		return '#edition-add' . $uri;
	}

	/**
	 * @inheritdoc
	 */
	public function getName() {
		return __CLASS__;
	}
}