/**
 * This class defines the layers tree view.
 * 
 * {@img LayersPanel.png Layers Panel}
 * 
 */
Ext.define('OgamDesktop.view.map.LayersPanel', {
    extend: 'Ext.tree.Panel',
    xtype: 'layers-panel',
    controller: 'layerspanel',
    requires: [
        'Ext.data.TreeStore'
    ],
    border: false,
    rootVisible: false,
    autoScroll: true,
    title:'Layers',
    viewConfig: {
        plugins: { ptype: 'treeviewdragdrop' }
    },
    flex: 1,
    countLoadedStores: 0,
    stores: {},
    listeners: {
        itemcontextmenu: function(me, rec, item, index, e, eOpts) {
            e.preventDefault();
            if (!rec.getData().isLayerGroup) {
                var opacity = rec.getData().getOpacity();
                var slider = Ext.create('Ext.slider.Single', {
                    width: 120,
                    value: opacity*100,
                    increment: 1,
                    minValue: 0,
                    maxValue: 100,
                    renderTo: Ext.getBody(),
                    listeners: {
                        change: function(slider, newValue) {
                            rec.getData().setOpacity(newValue/100);
                        }
                    }
                });
                var contextMenu = Ext.create('Ext.menu.Menu', {
                    items: [slider]
                });
                contextMenu.showAt(e.getXY());
            }
        },
        beforecheckchange: 'onBeforeCheckChange',
        checkchange: 'onCheckChange'
    },

    /**
     * Initializes the component.
     */
    initComponent : function() {
        var layerTreeNodeStore = Ext.getStore('map.LayerTreeNode');
        layerTreeNodeStore.on('load', function(store, records) {
            this.fireEvent('storeLoaded', store, records);
        }, this);
        this.on('checkchange', function(node, checked, e, eOpts) {
                this.getController().fireEvent('checkchange', node, checked);
        }, this);
        this.callParent(arguments);
    }
});