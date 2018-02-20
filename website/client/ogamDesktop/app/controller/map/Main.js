/**
 * This class defines the controller with actions related to 
 * map main view.
 */
Ext.define('OgamDesktop.controller.map.Main',{
    extend: 'Ext.app.Controller',
    requires: [
        'OgamDesktop.view.result.GridTab',
        'OgamDesktop.view.main.Main',
        'Ext.grid.column.Number'
    ],

    /*
     * The refs to get the views concerned
     * and the control to define the handlers of the
     * MapPanel.
     */
    config: {
        refs: {
            mappanel: '#map-panel',
            mapmainwin: 'map-mainwin'
        },        
        control: {
            'deprecated-detail-grid': {
                beforedetailsgridrowenter: 'setResultStateToSelected',
                beforedetailsgridrowleave: 'setResultStateToDefault'
            },
            'results-grid': {
                seeOnMapButtonClick: 'onSeeOnMapButtonClick'
            }
        },
        listen: {
            controller: {
                'advancedrequest': {
                    requestSuccess: 'onRequestSuccess'
                }
            }
        }
    },

    //<locale>
    /**
     * @cfg {String} requestLoadingMessage
     * The request loading message (defaults to <tt>'Please wait, while loading the map...'</tt>)
     */
    requestLoadingMessage: 'Please wait, while loading the map...',
    /**
     * @cfg {String} getresultsbboxErrorTitle
     * The error title when the bounding box loading fails (defaults to <tt>'Loading of bounding box failed:'</tt>)
     */
    getresultsbboxErrorTitle: 'Loading of bounding box failed:',
    //</locale>

    /**
     * Manage the launch event
     * @private
     */
    onLaunch:function(){
        //clean previous request or result in server side
        Ext.Ajax.request({
            url: Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxresetresultlocation',
            failure: function(response, opts) {
                console.warn('server-side failure with status code ' + response.status);
            }
        });
    },

    /**
     * Highlights the passed record on the map
     * @param {Ext.data.Model} record The result record
     */
    setResultStateToSelected: function(record) {
        this.getMappanel().highlightObject(record);
    },

    /**
     * Unhighlights the passed record on the map
     * @param {Ext.data.Model} record The result record
     */
    setResultStateToDefault: function(record) {
        this.getMappanel().showObjectInDefaultStyle(record);
    },

    /**
     * Show the map container and zoom on the result BBox.
     * @private
     * @param {Object} feature The feature corresponding to the grid row,
     * contains id and geometry.
     */
    onSeeOnMapButtonClick: function(feature) {
        this.getMapmainwin().ownerCt.setActiveItem(this.getMapmainwin());
        this.getMappanel().child('mapcomponent').getController().zoomToFeature(feature.id, feature.location_centroid);
    },

    /**
     * Update the map on request success
     * @private
     */
    onRequestSuccess: function() {
        this.getMapmainwin().mask(this.requestLoadingMessage);
        Ext.Ajax.request({
            url : Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetresultsbbox',
            success : function(response, options) {
                var result = Ext.decode(response.responseText);
                if (result.success) {
                    this.setResultsBbox(result.resultsbbox);
                    this.updateRequestLayers();
                    //this.getMapmainwin().ownerCt.setActiveItem(this.getMapmainwin());
                } else {
                    OgamDesktop.toast(result.errorMessage, this.getresultsbboxErrorTitle);
                    this.getMapmainwin().unmask();
                }
            },
            scope: this
        });
    },

    /**
     * Update the map results bounding box
     */
    setResultsBbox: function(resultsbbox) {
        var mapCmp = this.getMappanel().child('mapcomponent');
        var mapCmpCtrl = mapCmp.getController();
        mapCmp.resultsBBox = resultsbbox;
        if (mapCmpCtrl.autoZoomOnResultsFeatures === true) {
            mapCmp.fireEvent('resultswithautozoom');
        }
        mapCmpCtrl.fireEvent('resultsBBoxChanged', mapCmpCtrl, mapCmp.resultsBBox);
    },

    /**
     * Update the request layers
     */
    updateRequestLayers: function() {
        var mapCmp = this.getMappanel().child('mapcomponent');
        // Forces the layer to redraw itself
        var requestLayers = mapCmp.getController().requestLayers;
        this.unmaskMapMainWinCounter = requestLayers.length;
        requestLayers.forEach(function(element, index, array){
            var src = element.getSource();
            src.once('change', this.unmaskMapMainWin, this);
            /*
             * Note : 
             * The ol.source.changed and ol.source.dispatchEvent('change') functions 
             * doesn't work with openlayers v3.12.1
             */
            src.updateParams({"_dc": Date.now()});
        },this);
    },

    /**
     * Unmasks the map main win when all the layer are up-to-date.
     * @private
     */
    unmaskMapMainWin: function() {
        --this.unmaskMapMainWinCounter === 0 && this.getMapmainwin().unmask();
    }
});