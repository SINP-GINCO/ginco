/**
 * This class defines the OgamDesktop request fieldset criterion model.
 * @deprecated
 */
Ext.define('OgamDesktop.model.request.fieldset.Criterion', {
	extend: 'OgamDesktop.model.base',
	idProperty: 'id',
    fields: [
        // Form Field
        { name: 'id', type: 'auto' },
        { name: 'name', mapping: 'id', type: 'string' },
        { name: 'data' }, // Don't use that param (Must be only used by the calculate fcts)
        { name: 'format', type: 'string' }, // Don't use that param (Must be only used by the calculate fcts)
        { name: 'is_default', mapping: 'is_default_criteria', type: 'boolean', defaultValue: false },
        { name: 'decimals', type: 'integer' },
        { name: 'default_value', type: 'string' },
        { name: 'default_label', type: 'string', calculate: function (field) { return (field.inputType === 'TREE' || field.inputType === 'TAXREF' || field.inputType === 'SELECT' || field.inputType === 'PAGINED_SELECT') && !Ext.isEmpty(field.default_value) ? field.data.unit.codes[0].label : null; } },
        { name: 'inputType', mapping: 'input_type', type: 'string' },
        // Data
        { name: 'label', type: 'string', calculate: function (field) { return field.data.label; } },
        { name: 'definition', type: 'string', calculate: function (field) { return field.data.definition; } },
        // Unit
        { name: 'unit', type: 'string', calculate: function (field) { return field.data.unit.unit; } },
        { name: 'type', type: 'string', calculate: function (field) { return field.data.unit.type; } },
        { name: 'subtype', type: 'string', calculate: function (field) { return field.data.unit.subtype; } },
        // Range
        { name: 'min_value', type: 'auto', calculate: function (field) { return field.data.unit.range ? field.data.unit.range.min : null; } },
        { name: 'max_value', type: 'auto', calculate: function (field) { return field.data.unit.range ? field.data.unit.range.max : null; } },
        // Code
        { name: 'codes', calculate: function (field) { return field.data.unit.codes ? field.data.unit.codes : null; } }
    ],
    proxy: {
		reader:{
			type:'json',
			rootProperty:'criteria'
		}
    }
});