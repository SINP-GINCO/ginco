/**
 * This class defines the OgamDesktop request object field code model.
 */
Ext.define('OgamDesktop.model.request.object.field.Code',{
	extend: 'OgamDesktop.model.base',
	idProperty : 'code',
	fields : [ {
		name : 'code',
		type: 'auto'
	}, {
		name : 'label',
		type: 'string'
	} ]
});