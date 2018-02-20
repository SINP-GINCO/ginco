/**
 * This class defines the store for the tree layers nodes.
 */
Ext.define('OgamDesktop.store.map.LayerTreeNode',{
    extend: 'Ext.data.Store',
    model: 'OgamDesktop.model.map.LayerTreeNode',
    autoLoad: true,
    // Way to access data (ajax) and to read them (json)
    proxy: {
        type: 'ajax',
        isSynchronous: true,
        url: Ext.manifest.OgamDesktop.mapServiceUrl +'ajaxgetlayertreenodes',
        actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'},
        reader: {
            type: 'json',
            rootProperty: 'data'
        }
    }
});