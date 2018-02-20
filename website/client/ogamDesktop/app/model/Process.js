/**
 * This class defines the OgamDesktop process model.
 */
Ext.define('OgamDesktop.model.Process', {
	extend: 'Ext.data.Model',
	idProperty: 'id',
    fields: [
        { name: 'id', type: 'auto' },
        { name: 'label', type: 'string' },
        { name: 'definition', type: 'string' },
        { name: 'is_default', type: 'boolean', defaultValue: false }
    ],
	proxy: {
		type: 'ajax',
        url: Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetdatasets',
        reader : {
            type            : 'json',
            rootProperty    : 'data',
            messageProperty : 'errorMessage'
        }
    }
});