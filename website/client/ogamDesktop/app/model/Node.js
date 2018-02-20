/**
 * This class defines the OgamDesktop node model.
 */
Ext.define('OgamDesktop.model.Node', {
    extend : 'Ext.data.TreeModel',
    //childType:'OgamDesktop.model.request.object.field.Code',
    defaultRootProperty:'children',
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
    },
    fields : [ {
        mapping : 'text',
        name : 'label'
    }, {
        mapping : 'id',
        name : 'code'
    } ]
});