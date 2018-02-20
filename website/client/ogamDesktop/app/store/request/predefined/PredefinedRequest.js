/**
 * This class defines the OgamDesktop predefined request store.
 */
Ext.define('OgamDesktop.store.request.predefined.PredefinedRequest',{
	extend: 'Ext.data.Store',
	model:'OgamDesktop.model.request.predefined.PredefinedRequest',
	autoLoad:true,
	remoteSort: false,
	sorters:{property: 'group_position', direction: "ASC"},
	proxy:{
		type:'ajax',
		url:Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetpredefinedrequestlist',
		reader:{type:'array', rootProperty:'data'}
	}
});