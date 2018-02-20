/**
 * This class manages the layerfeatureinfo button view.
 */
Ext.define('OgamDesktop.view.map.toolbar.LayerFeatureInfoButtonController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.layerfeatureinfobutton',

//<locale>
    /**
     * @cfg {String} layerFeatureInfoButtonErrorTitle The layer feature info button error title (default to <tt>'Layer information:'</tt>)
     */
    layerFeatureInfoButtonErrorTitle : 'Layer information:',
    /*
     * @cfg {String} layerFeatureInfoButtonErrorMessage The layer feature info button error message (default to <tt>'Please select a layer into the menu.'</tt>)
     */
    layerFeatureInfoButtonErrorMessage : 'Please select a layer into the menu.',
//</locale>

    /**
     * Initializes the controller.
     */
    init : function() {
        var mapCmp = this.getView().up('#map-panel').child('mapcomponent');
        this.map = mapCmp.getMap();
        this.layerFeatureInfoListenerKey = null;
        this.popup = Ext.create('GeoExt.component.Popup', {
            map: this.map,
            width: 250,
            tpl: [
                '<p><tpl for="features">',
                    '<u>' + this.getView().popupTitleText + ' {#}:</u><br />',
                    '<tpl foreach=".">',
                        '{$}: {.}<br />',
                    '</tpl>',
                '<br /></tpl></p>'
            ]
        });
        this.coordinateExtentDefaultBuffer = OgamDesktop.map.featureinfo_margin ? OgamDesktop.map.featureinfo_margin : 1000;
    },

    /**
     * Fonction handling the toggle event on the split button.
     * @private
     * @param {Ext.button.Button} button The button
     * @param {Boolean} pressed
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    onLayerFeatureInfoButtonToggle : function (button, pressed, eOpts) {
        if (pressed) {
            var checkedItem = null;
            button.getMenu().items.each(function(item, index, len) {
                item.checked && (checkedItem = item);
            });
            if (checkedItem !== null) {
                this.updateAndAddLayerFeatureInfoListener(checkedItem);
            } else {
                OgamDesktop.toast(this.layerFeatureInfoButtonErrorMessage,this.layerFeatureInfoButtonErrorTitle);
                button.toggle(false);
            }
        } else {
            this.removeLayerFeatureInfoListener();
        }
    },

    /**
     * Removes the map singleclick listener.
     * @private
     */
    removeLayerFeatureInfoListener: function () {
        ol.Observable.unByKey(this.layerFeatureInfoListenerKey);
        this.layerFeatureInfoListenerKey = null;
        this.popup.hide();
    },

    /**
     * Updates and adds the map singleclick listener.
     * @private
     * @param {Ext.menu.CheckItem} item The checked/unchecked item
     */
    updateAndAddLayerFeatureInfoListener: function(item) {
        this.removeLayerFeatureInfoListener();
        var projection = this.map.getView().getProjection().getCode();
        this.layerFeatureInfoListenerKey = this.map.on('singleclick', function(evt) {
        	var outputFormat = "geojsonogr";
        	var featureServiceUrl = item.config.data.featureServiceUrl;
        	if (featureServiceUrl.includes("outputFormat")) {
        		outputFormat = featureServiceUrl.split('outputFormat=')[1].split('&')[0];
        	}
            var url = featureServiceUrl +
            	'&outputFormat=' + outputFormat +
                '&srsname=' + projection +
                '&typename=' + item.config.data.serviceLayerName +
                '&bbox=' + ol.extent.buffer(ol.extent.boundingExtent([evt.coordinate]), this.coordinateExtentDefaultBuffer).join(',') + ',' + projection;
            ol.featureloader.loadFeaturesXhr(
                url,
                new ol.format.GeoJSON(),
                function(features, dataProjection) {
                    // Set up the data object
                    var data = {features:[]};
                    features.forEach(function(feature){
                        var properties = feature.getProperties();
                        delete properties.geometry;
                        data.features.push(properties);
                    });
                    // Set content and position popup
                    if (data.features.length !== 0) {
                        this.popup.setData(data);
                        this.popup.position(evt.coordinate);
                        this.popup.show();
                    }
                },
                ol.nullFunction /* OGAM-583 - FIXME handle error */
            ).call(this);
        },this);
    },

    /**
     * Fonction handling the checkchange event on the menu items.
     * @private
     * @param {Ext.menu.CheckItem} item The checked/unchecked item
     * @param {Boolean} checked
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    onLayerFeatureInfoButtonMenuItemCheckChange : function(item, checked, eOpts) {
        // Changes the checkbox behaviour to a radio button behaviour
        var menu = item.parentMenu;
        menu.items.each(function(item, index, len){
            item.setChecked(false, true);
        });
        item.setChecked(checked, true);

        if (checked) {
            if (menu.ownerCmp.pressed) {
                this.updateAndAddLayerFeatureInfoListener(item);
            } else {
                menu.ownerCmp.toggle(true);
            }
        } else {
            this.removeLayerFeatureInfoListener();
            menu.ownerCmp.pressed && menu.ownerCmp.toggle(false);
        }
    }
});