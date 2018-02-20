/**
 * This class manages the map main win view.
 */
Ext.define('OgamDesktop.view.map.MainWinController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.mapmainwin',
    listen: {
         controller: {
             'mapcomponent': {
                 changevisibilityrange: 'toggleLayersAndLegendsForZoom'
             }
         }
     },

    /**
     * Initializes the controller.
     * @private
     */
    init : function() {
        this.mapAddonsPanel = this.getView().child('map-addons-panel');
        this.mapAddonsPanelCtrl = this.mapAddonsPanel.getController();
        this.layersPanel = this.mapAddonsPanel.child('layers-panel');
        this.layersPanelCtrl = this.layersPanel.getController();
        this.mapToolbarCtrl = this.getView().child('#map-panel').getDockedItems('toolbar[dock="top"]')[0].getController();
    },

    /**
     * Toggle the layer and legend in function of the zoom range
     * @private
     * @param {OpenLayers.Layer} layer The layer to check
     * @param {Boolean} enable True to enable the layers and legends
     */
    toggleLayersAndLegendsForZoom : function(layer, enable) {
        var node = this.layersPanelCtrl.getLayerNode(layer);
        if (!Ext.isEmpty(node) && !node.hidden) {
            if (!enable) {
                // Disable Layers And Legends
                this.mapAddonsPanelCtrl.toggleLayersAndLegends(false, [ layer ], false);
                this.mapToolbarCtrl.toggleMenusItems(false, [ layer ]);
            } else {
                if (node.forceDisable !== true) {
                    // Enable Layers And Legends
                    this.mapAddonsPanelCtrl.toggleLayersAndLegends(true, [ layer ], false);
                    this.mapToolbarCtrl.toggleMenusItems(true, [ layer ]);
                }
            }
        }
    }
});