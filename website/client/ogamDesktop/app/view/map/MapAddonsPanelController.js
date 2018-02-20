/**
 * This class manages the legends panel view.
 */
Ext.define('OgamDesktop.view.map.MapAddonsPanelController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.mapaddonspanel',
    listen: {
         controller: {
             'mapcomponent': {
                 resultsBBoxChanged: 'enableRequestLayersAndLegends'
             },
             'layerspanel':{
                checkchange: 'onLayerCheckChange'
             }
         }
     },

    /**
     * Initializes the controller.
     * @private
     */
    init : function() {
        this.layersPanel = this.getView().child('layers-panel');
        this.layersPanelCtrl = this.layersPanel.getController();
        this.legendsPanelCtrl = this.getView().child('legends-panel').getController();
        var mapCmp = Ext.ComponentManager.get('o-map');
        this.mapCmpCtrl = mapCmp.getController();
    },

    /**
     * Toggle the legend in function of the layer tree node check state
     * @private
     * @param {GeoExt.data.model.LayerTreeNode} node The layer tree node
     * @param {Boolean} checked True if the node is checked
     */
    onLayerCheckChange : function(node, checked) {
        var setLegendVisibleFn = function(layer, checked){
            if (layer instanceof ol.layer.Group) {
                layer.getLayers().forEach(function(el, index, layers){
                    setLegendVisibleFn.call(this, el, checked);
                }, this);
            } else {
                this.legendsPanelCtrl.setLegendsVisible([layer], checked);
            }
        };
        setLegendVisibleFn.call(this, node.getOlLayer(), checked);
    },

    /**
     * Enable and show the layer(s) and show the legend(s)
     * @private
     * @param {Boolean} enable True to enable the layers and legends
     * @param {Array} layers The layers
     * @param {Boolean} toggleNodeCheckbox True to toggle the layerTree node checkbox (default to false)
     */
    toggleLayersAndLegends : function(enable, layers, toggleNodeCheckbox) {
        if (!Ext.isEmpty(enable) && !Ext.isEmpty(layers)) {
            var node;
            var currentResolution = this.mapCmpCtrl.map.getView().getResolution();

            for (var i in layers) {
                node = this.layersPanelCtrl.getLayerNode(layers[i]);
                if (!Ext.isEmpty(node)) {
                    var isInRange = this.mapCmpCtrl.isResInLayerRange(layers[i], currentResolution);
                    this.layersPanelCtrl.updateLayerNode(node, (enable && isInRange));
                    toggleNodeCheckbox && this.layersPanelCtrl.toggleNodeCheckbox(node, enable);
                }
            }
            this.legendsPanelCtrl.setLegendsVisible(layers, enable);
        } else {
            console.warn('toggleLayersAndLegends : enable or/and layers parameter(s) is/are empty.');
        }
    },

    /**
     * Enable and show the request layer(s) and legend(s).
     * @private
     * @param {OgamDesktop.view.map.MapComponentController} mapCmpCtrl The map component controller
     */
    enableRequestLayersAndLegends: function(mapCmpCtrl) {
        this.toggleLayersAndLegends(true, mapCmpCtrl.requestLayers, false);
    }
});