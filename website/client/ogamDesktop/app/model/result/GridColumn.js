/**
 * This class defines the OgamDesktop result grid column model.
 */
Ext.define('OgamDesktop.model.result.GridColumn', {
    extend: 'Ext.data.Model',
    idProperty: 'name',
    fields: [
        { name: 'name', type: 'auto' },
        { name: 'label', type: 'string' },
        { name: 'definition', type: 'string' },
        { name: 'data', type: 'string' },
        { name: 'format', type: 'string' },
        { name: 'unit', type: 'string' },
        { name: 'type', type: 'string' },
        { name: 'subtype', type: 'string' },
        { name: 'inputType', type: 'string' },
        { name: 'decimals', type: 'integer' },
        { name: 'hidden', type: 'boolean', defaultValue: false }
    ]
});