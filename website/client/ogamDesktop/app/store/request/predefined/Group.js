/**
 * This class defines the OgamDesktop predefined group store.
 */
Ext.define('OgamDesktop.store.request.predefined.Group',{
	extend: 'Ext.data.Store',
	model:'OgamDesktop.model.request.predefined.Group',
	autoLoad:true,
	remoteSort: false,
	sorters:{property: 'position', direction: "ASC"},
	proxy:{
		type:'ajax',
		url:Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetpredefinedgrouplist',
		reader:{type:'array', rootProperty:'data'}
	}
});