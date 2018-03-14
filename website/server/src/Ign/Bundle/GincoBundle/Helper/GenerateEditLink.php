<?php
namespace Ign\Bundle\GincoBundle\Helper;

use Symfony\Component\Templating\Helper\Helper;

class GenerateEditLink extends Helper {

	/**
	 * Generate a link corresponding to a data object
	 *
	 * @param GenericTableFormat $data        	
	 * @return Link the HTML link
	 */
	function getEditLink($data) {
		
		// Build the URL to link to the parent items
		$urlArray = array(
			'controller' => 'index',
			'action' => 'index'
		);
		
		// Add the schema
		$urlArray['SCHEMA'] = $data->getTableFormat()->getSchemaCode();
		
		// Add the format
		$urlArray['FORMAT'] = $data->getTableFormat()->getFormat();
		
		// Add the PK elements
		foreach ($data->getIdFields() as $infoField) {
			$urlArray[$infoField->getData()] = $infoField->getValue();
		}
		
		// Add the fields to generate the tooltip
		$fields = array();
		foreach ($data->all() as $field) {
			if (is_array($field->getValueLabel())) {
				$val = "";
				foreach ($field->getValueLabel() as $value) {
					$val .= htmlspecialchars($value, ENT_QUOTES, $this->getCharset()) . ", ";
				}
				$fields[$field->getMetadata()->getLabel()] = substr($val, 0, -2);
			} else {
				$fields[$field->getMetadata()->getLabel()] = htmlspecialchars($field->getValueLabel(), ENT_QUOTES, $this->getCharset());
			}
		}
		// output the result
		return array(
			'url' => '#edition-edit/' . $data->getId(),
			'text' => htmlspecialchars($data->getTableFormat()->getLabel(), ENT_QUOTES, $this->getCharset()),
			'fields' => $fields
		);
	}

	/**
	 * @inheritdoc
	 */
	public function getName() {
		return __CLASS__;
	}
}