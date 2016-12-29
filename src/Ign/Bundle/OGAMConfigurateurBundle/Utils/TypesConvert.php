<?php
namespace Ign\Bundle\ConfigurateurBundle\Utils;

/**
 *
 * Utility class for converting OGAM types to input fields OGAM types.
 *
 * @author S.Candelier
 *
 */
class TypesConvert {

	public function UnitToInput($type, $subtype = null) {

		$convert = array(
				'STRING' => 'TEXT',
				'ARRAY'	=> array(
					'MODE' => 'SELECT',
					'DYNAMIC' => 'SELECT',
					'TREE' => 'TREE',
					'TAXREF' => 'TAXREF',
				),
				'CODE' => array(
						'MODE' => 'SELECT',
						'DYNAMIC' => 'SELECT',
						'TREE' => 'TREE',
						'TAXREF' => 'TAXREF',
				),
				'NUMERIC' => 'NUMERIC',
				'INTEGER' => 'NUMERIC',
				'DATE' => 'DATE',
				'TIME' => 'TIME',
				'GEOM' => 'GEOM',
				'BOOLEAN' => 'CHECKBOX',
				'IMAGE' => 'IMAGE',
		);

		if (!in_array($type, array_keys($convert))) {
			return null;
		}

		$field_type = $convert[$type];

		if (is_array($field_type)) {
			if ($subtype == null || !in_array($subtype, array_keys($field_type))) {
				return null;
			}
			return $field_type[$subtype];
		}
		else {
			return $field_type;
		}
	}
}
