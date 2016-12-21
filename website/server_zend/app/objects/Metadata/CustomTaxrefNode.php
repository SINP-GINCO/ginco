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
 * Represent a node in a taxonomic referential.
 *
 * @SuppressWarnings checkUnusedVariables
 *
 * @package Application_Object
 * @subpackage Metadata
 */
class Application_Object_Metadata_CustomTaxrefNode extends Application_Object_Metadata_TaxrefNode {

	/**
	 * Add a child.
	 *
	 * @param Application_Object_Metadata_TreeNode $child
	 *        	a node to add
	 */

	/**
	 * Serialize the object as a JSON.
	 *
	 * @return JSON the descriptor
	 */
	public function toJSON() {
		$return = '';
		if (empty($this->code) && empty($this->label)) {
			// Case when the root is just a placeholder, we return only the children
			foreach ($this->children as $child) {
				$return .= $child->toJSON() . ',';
			}
			$return = substr($return, 0, -1); // remove the last comma
		} else {
			// We return the root itself plus the children
			$return .= '{"text":' . json_encode($this->name);
			$return .= ',"id":' . json_encode($this->code);
			if ($this->isLeaf) {
				$return .= ',"leaf":true';
			}
			$return .= ',"vernacularName":' . json_encode($this->vernacularName);
			$return .= ',"completeName":' . json_encode($this->completeName);
			$return .= ',"scientificName":' . json_encode($this->scientificName);
			$return .= ',"isReference":' . json_encode($this->isReference);

			if (!empty($this->children)) {
				$return .= ',"children": [';
				foreach ($this->children as $child) {
					$return .= $child->toJSON() . ',';
				}
				$return = substr($return, 0, -1); // remove the last comma
				$return .= ']';
			}
			$return .= '}';
		}

		return $return;
	}
}
