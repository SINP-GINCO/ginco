/**
 * This class manages the selectwfsfeature button view.
 */
Ext.define('OgamDesktop.view.map.toolbar.SelectWFSFeatureButtonController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.selectwfsfeaturebutton',

//<locale>
    /**
     * @cfg {String} selectWFSFeatureButtonErrorTitle The select WFS feature button error title (default to <tt>'Feature import:'</tt>)
     */
    selectWFSFeatureButtonErrorTitle : 'Feature import:',
    /*
     * @cfg {String} layerFeatureInfoButtonErrorMessage The select WFS feature button error message (default to <tt>'Please select a layer into the menu.'</tt>)
     */
    selectWFSFeatureButtonErrorMessage : 'Please select a layer into the menu.',
//</locale>

    /**
     * Initializes the controller.
     */
    init : function() {
        var mapCmp = this.getView().up('#map-panel').child('mapcomponent');
        this.map = mapCmp.getMap();
        this.mapCmpCtrl = mapCmp.getController();
        this.selectWFSFeatureListenerKey = null;
        this.coordinateExtentDefaultBuffer = OgamDesktop.map.featureinfo_margin ? OgamDesktop.map.featureinfo_margin : 1000;
    },

    /**
     * Fonction handling the toggle event on the split button.
     * @private
     * @param {Ext.button.Button} button The button
     * @param {Boolean} pressed
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    onSelectWFSFeatureButtonToggle : function (button, pressed, eOpts) {
        if (pressed) {
            var checkedItem = null;
            button.getMenu().items.each(function(item, index, len) {
                item.checked && (checkedItem = item);
            });
            if (checkedItem !== null) {
                this.updateAndAddSelectWFSFeatureListener(checkedItem);
            } else {
                OgamDesktop.toast(this.selectWFSFeatureButtonErrorMessage, this.selectWFSFeatureButtonErrorTitle);
                button.toggle(false);
            }
        } else {
            this.removeSelectWFSFeatureListener();
        }
    },

    /**
     * Removes the map singleclick listener.
     * @private
     */
    removeSelectWFSFeatureListener: function () {
        ol.Observable.unByKey(this.selectWFSFeatureListenerKey);
        this.selectWFSFeatureListenerKey = null;
    },

    /**
     * Updates and adds the map singleclick listener.
     * @private
     * @param {Ext.menu.CheckItem} item The checked/unchecked item
     */
    updateAndAddSelectWFSFeatureListener: function(item) {
        this.removeSelectWFSFeatureListener();
        var projection = this.map.getView().getProjection().getCode();
        this.selectWFSFeatureListenerKey = this.map.on('singleclick', function(evt) {
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
            ol.featureloader.xhr(
                url,
                new ol.format.GeoJSON()
            ).call(this.mapCmpCtrl.getMapLayer('drawingLayer').getSource());
        },this);
    },

    /**
     * Fonction handling the checkchange event on the menu items.
     * @private
     * @param {Ext.menu.CheckItem} item The checked/unchecked item
     * @param {Boolean} checked
     * @param {Object} eOpts The options object passed to {@link Ext.util.Observable.addListener}
     */
    onSelectWFSFeatureButtonMenuItemCheckChange : function(item, checked, eOpts) {
        // Changes the checkbox behaviour to a radio button behaviour
        var menu = item.parentMenu;
        menu.items.each(function(item, index, len){
            item.setChecked(false, true);
        });
        item.setChecked(checked, true);

        if (checked) {
            if (menu.ownerCmp.pressed) {
                this.updateAndAddSelectWFSFeatureListener(item);
            } else {
                menu.ownerCmp.toggle(true);
            }
        } else {
            this.removeSelectWFSFeatureListener();
            menu.ownerCmp.pressed && menu.ownerCmp.toggle(false);
        }
    }
});