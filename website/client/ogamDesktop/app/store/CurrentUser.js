/**
 * This class defines the OgamDesktop current user store.
 */
Ext.define('OgamDesktop.store.CurrentUser',{
	extend:'Ext.data.Store',
	model:'OgamDesktop.model.user.User',
	id:'CurrentUser',
	autoLoad:true,
	proxy : {
		type: 'ajax',
		url: Ext.manifest.OgamDesktop.userServiceUrl + 'currentuser',
		limitParam: '', // Set this to '' if you don't want to send a limit parameter.
		startParam: '', // Set this to '' if you don't want to send a start parameter.
		pageParam: '', // Set this to '' if you don't want to send a page parameter.
		reader: {
			type:'json',
			rootProperty: function(data){
				// Extract child nodes from the items or children property in the dataset
				return data.data || data.children;
			}
		}
	}
});