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

/**
 * Represent a Custom Field of a Form.
 *
 * @SuppressWarnings checkUnusedVariables
 *
 * @package Application_Object
 * @subpackage Metadata
 */
class Application_Object_Metadata_CustomFormField extends Application_Object_Metadata_FormField {

	/**
	 * Serialize the object as a JSON string for display in the detail panel
	 *
	 * @return JSON the form field descriptor
	 */
	public function toDetailJSON() {
		$return = '{"label":' . json_encode($this->label);
		
		if ($this->inputType == 'NUMERIC' && $this->decimals != null && $this->decimals != "") {
			$this->valueLabel = number_format($this->valueLabel, $this->decimals);
		}
		
		$return .= ',"value":' . json_encode($this->getValueLabel());
		$return .= ',"inputType":' . json_encode($this->inputType);
		$return .= ',"type":' . json_encode($this->type);
		$return .= ',"subtype":' . json_encode($this->subtype);
		$return .= ',"formLabel":' . json_encode($this->formLabel);
		$return .= ',"formPosition":' . json_encode($this->formPosition);
		$return .= ',"position":' . json_encode($this->position) . '}';
		
		return $return;
	}
	
	/**
	 * Serialize the object as a JSON used to describe form field for the edition module.
	 *
	 * @return JSON the form field descriptor
	 */
	public function toEditJSON() {
		$return = '"name":' . json_encode($this->getName());
		$return .= ',"data":' . json_encode($this->data);
		$return .= ',"format":' . json_encode($this->format);
		$return .= ',"label":' . json_encode($this->label);
		$return .= ',"inputType":' . json_encode($this->inputType);
		$return .= ',"unit":' . json_encode($this->unit);
		$return .= ',"type":' . json_encode($this->type);
		$return .= ',"subtype":' . json_encode($this->subtype);
		$return .= ',"definition":' . json_encode($this->definition);
		$return .= ',"decimals":' . json_encode($this->decimals);
		$return .= ',"value":' . json_encode($this->value);
		$return .= ',"valueLabel":' . json_encode($this->getValueLabel());
		$return .= ',"editable":' . json_encode($this->editable);
		$return .= ',"insertable":' . json_encode($this->insertable);
		$return .= ',"isPK":' . json_encode($this->isPK);
		$return .= ',"required":' . json_encode($this->required);
		$return .= ',"position":' . json_encode($this->position);
		$return .= ',"formPosition":' . json_encode($this->formPosition);
		$return .= ',"formLabel":' . json_encode($this->formLabel);
		return $return;
	}
}