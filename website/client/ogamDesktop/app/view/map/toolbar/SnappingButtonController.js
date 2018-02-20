/**
 * This class manages the snapping button view.
 */
Ext.define('OgamDesktop.view.map.toolbar.SnappingButtonController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.snappingbutton',

    /**
     * Initializes the controller.
     */
    init : function() {
        var mapCmp = this.getView().up('#map-panel').child('mapcomponent');
        this.map = mapCmp.getMap();
        this.mapCmpCtrl = mapCmp.getController();
        this.drawingLayerSnappingInteraction = new ol.interaction.Snap({
            source: this.mapCmpCtrl.getMapLayer('drawingLayer').getSource()
        });
        this.snappingLayerSnappingInteraction = null;
        this.riseSnappingInteractionListenerKey = null;
    },

    /**
     * Fonction handling the toggle event on the split button.
     * @private
     * @param {Ext.button.Button} button The button
     * @param {Boolean} pressed
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    onSnappingButtonToggle : function (button, pressed, eOpts) {
        if (pressed) {
            this.map.addInteraction(this.drawingLayerSnappingInteraction);
            if(this.snappingLayerSnappingInteraction !== null){
                this.map.addInteraction(this.snappingLayerSnappingInteraction);
            } 
            this.updateRiseSnappingInteractionListener();
            this.mapCmpCtrl.getMapLayer('snappingLayer').setVisible(true);
        } else {
            this.map.removeInteraction(this.drawingLayerSnappingInteraction);
            if(this.snappingLayerSnappingInteraction !== null){
                this.map.removeInteraction(this.snappingLayerSnappingInteraction);
            }
            this.removeRiseSnappingInteractionListener();
            this.mapCmpCtrl.getMapLayer('snappingLayer').setVisible(false);
        }
    },

    /**
     * Removes the interaction listener.
     * @private
     */
    removeRiseSnappingInteractionListener: function () {
        ol.Observable.unByKey(this.riseSnappingInteractionListenerKey);
        this.riseSnappingInteractionListenerKey = null;
    },

    /**
     * Updates the interaction listener.
     * @private
     */
    updateRiseSnappingInteractionListener: function () {
            // The snap interaction must be added last, as it needs to be the first to handle the pointermove event.
            if (this.riseSnappingInteractionListenerKey !== null){
                this.removeRiseSnappingInteractionListener();
            }
            this.riseSnappingInteractionListenerKey = this.map.getInteractions().on("add", function (collectionEvent) {
                if (!(collectionEvent.element instanceof ol.interaction.Snap)) { // To avoid an infinite loop
                    this.map.removeInteraction(this.drawingLayerSnappingInteraction);
                    this.map.removeInteraction(this.snappingLayerSnappingInteraction);
                    this.map.addInteraction(this.drawingLayerSnappingInteraction);
                    if (this.snappingLayerSnappingInteraction !== null) {
                        this.map.addInteraction(this.snappingLayerSnappingInteraction);
                    }
                }
            }, this);
    },

    /**
     * Destroys and removes the snapping interaction.
     * @private
     */
    destroyAndRemoveSnappingInteraction : function(){
        this.map.removeInteraction(this.snappingLayerSnappingInteraction);
        this.snappingLayerSnappingInteraction = null;
        this.updateRiseSnappingInteractionListener();
    },

    /**
     * Updates the snapping interaction.
     * @private
     */
    updateSnappingInteraction : function(){
        this.snappingLayerSnappingInteraction = new ol.interaction.Snap({
            source: this.mapCmpCtrl.getMapLayer('snappingLayer').getSource()
        });
    },

    /**
     * Updates and add the snapping interaction.
     * @private
     */
    updateAndAddSnappingInteraction : function(){
        this.map.removeInteraction(this.snappingLayerSnappingInteraction);
        this.updateSnappingInteraction();
        this.map.addInteraction(this.snappingLayerSnappingInteraction);
        this.updateRiseSnappingInteractionListener();
    },

    /**
     * Fonction handling the checkchange event on the menu items.
     * @private
     * @param {Ext.menu.CheckItem} item The checked/unchecked item
     * @param {Boolean} checked
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    onSnappingButtonMenuItemCheckChange : function(item, checked, eOpts) {
        // Changes the checkbox behaviour to a radio button behaviour
        var menu = item.parentMenu;
        menu.items.each(function(item, index, len){
            item.setChecked(false, true);
        });
        item.setChecked(checked, true);

        if (checked) {
            // Update the data source
            var projection = this.map.getView().getProjection().getCode();
            this.snapSource = new ol.source.Vector({
                format: new ol.format.GeoJSON(),
                url: function(extent) {
                	var outputFormat = "geojsonogr";
                	var featureServiceUrl = item.config.data.featureServiceUrl;
                	if (featureServiceUrl.includes("outputFormat")) {
                		outputFormat = featureServiceUrl.split('outputFormat=')[1].split('&')[0];
                	}
                    return featureServiceUrl +
                    	'&outputFormat=' + outputFormat +
                        '&srsname=' + projection +
                        '&typename=' + item.config.data.serviceLayerName +
                        '&bbox=' + extent.join(',') + ',' + projection;
                },
                crossOrigin: 'anonymous',
                strategy: ol.loadingstrategy.tile(ol.tilegrid.createXYZ({
                    maxZoom: OgamDesktop.map.resolutions.length - 1
                }))
            });
            // Update the snapping layer and the snapping interaction
            this.mapCmpCtrl.getMapLayer('snappingLayer').setSource(this.snapSource);
            if (menu.ownerCmp.pressed) {
                this.updateAndAddSnappingInteraction();
            } else {
                this.updateSnappingInteraction();
                menu.ownerCmp.toggle(true);
            }
        } else {
            // Clear the snapping layer and remove the snapping interaction
            this.mapCmpCtrl.getMapLayer('snappingLayer').setSource(new ol.source.Vector({features: new ol.Collection()}));
            this.destroyAndRemoveSnappingInteraction();
            menu.ownerCmp.pressed && menu.ownerCmp.toggle(false);
        }
    }
});