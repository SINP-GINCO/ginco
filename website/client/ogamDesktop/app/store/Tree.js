/**
 * This class defines the OgamDesktop tree store.
 */
Ext.define('OgamDesktop.store.Tree',{
	extend:'Ext.data.TreeStore',
	model:'OgamDesktop.model.Node',
	parentIdProperty: 'parentId',
	proxy : {
		actionMethods : {
			create : 'POST',
			read : 'POST',
			update : 'POST',
			destroy : 'POST'
		},
		url : Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgettreenodes',
		type : 'ajax',
		reader: {
			type:'json',
			rootProperty: function(data){
				// Extract child nodes from the items or children property in the dataset
				return data.data || data.children;
			}
		},
		extraParams : {
			depth : '1'
		}
	}
});