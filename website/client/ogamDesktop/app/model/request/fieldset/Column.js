/**
 * This class defines the OgamDesktop request fieldset column model.
 * @deprecated
 */
Ext.define('OgamDesktop.model.request.fieldset.Column', {
	extend: 'OgamDesktop.model.base',
	idProperty: 'id',
    fields: [
        { name: 'id', type: 'auto' },
        { name: 'name', mapping: 'id', type: 'string' },
        { name: 'data' },
        { name: 'format', type: 'string' },
        { name: 'is_default', mapping: 'is_default_result', type: 'boolean', defaultValue: false },
        { name: 'decimals', type: 'integer' },
        // Data
        { name: 'label', type: 'string', calculate: function (field) { return field.data.label; } },
        { name: 'definition', type: 'string', calculate: function (field) { return field.data.definition; } }
    ]
});