/**
 * This class manages the map panel view.
 */
Ext.define('OgamDesktop.view.map.MapComponentController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.mapcomponent',

   /**
    * The wkt format.
    * @type {ol.format.WKT}
    * @property wktFormat
    */
    wktFormat : new ol.format.WKT(),

   /**
    * @cfg {Boolean} autoZoomOnResultsFeatures True to zoom automatically on the results features
    */
    autoZoomOnResultsFeatures : true,

//<locale>
    /**
     * @cfg {String} noFeatureErrorTitle The no feature error title (default to <tt>'Zoom to result features:'</tt>)
     */
    noFeatureErrorTitle : 'Zoom to result features:',
    /*
     * @cfg {String} noFeatureErrorMessage The no feature error message (default to <tt>'The results layer contains no feature on which to zoom.'</tt>)
     */
    noFeatureErrorMessage : 'The results layer contains no feature on which to zoom.',
//</locale>

   /**
    * A array of ol layers dependents of the request
    * @type {Array}
    * @property requestLayers 
    */
    requestLayers : [],

    /**
     * Initializes the controller.
     */
    init : function() {
        this.map = this.getView().getMap();
        var drawingLayerSource = this.getMapLayer('drawingLayer').getSource();
        var listenerFct = this.fireEvent.bind(this.getView(), ['drawingLayerFeatureChange']);
        drawingLayerSource.on('addfeature', listenerFct);
        drawingLayerSource.on('removefeature', listenerFct);
        drawingLayerSource.on('changefeature', listenerFct);
        this.map.getLayers().forEach(function(lyr){
             lyr.setVisible(lyr.getVisible());
        });
        this.map.getView().on('change:resolution', function(e){
            curRes = e.target.get(e.key); // new value of resolution
            oldRes = e.oldValue; // old value of resolution
            this.retrieveChangedLayers(this.map.getLayerGroup(), oldRes, curRes);
        }, this);
    },

    /**
     * Checks if the resolution is in the layer resolution range.
     * @param {ol.layer} lyr The layer
     * @param {Number} res The resolution
     * @return {Boolean} True is the resolution is in the layer resolution range
     */
    isResInLayerRange: function(lyr, res){
        if (res >= lyr.getMinResolution() && res < lyr.getMaxResolution()) { // in range
            return true;
        } else { // out of range
            return false;
        }
    },

    /**
     * Fires the changevisibilityrange event for each layers having their visibility to change
     * @private
     * @param {ol.layer} layerGrp The layer group
     * @param {Number} resDep The resolution
     * @param {Number} resDest The resolution
     */
    retrieveChangedLayers : function(layerGrp, resDep, resDest) {
        layerGrp.getLayers().forEach(function(lyr) {
            if (lyr.isLayerGroup) {
                this.retrieveChangedLayers(lyr, resDep, resDest);
            } else {
                if (this.isResInLayerRange(lyr, resDest) && !this.isResInLayerRange(lyr, resDep)) {
                       this.fireEvent('changevisibilityrange', lyr, true);
                   } else if (!this.isResInLayerRange(lyr, resDest) && this.isResInLayerRange(lyr, resDep)) {
                       this.fireEvent('changevisibilityrange', lyr, false);
                   }
                }
        }, this);
    },

    /**
     * Return the layer corresponding the passed name.
     * @param {String} layerName The layer name
     * @return {ol.layer} The matched layer
     */
    getMapLayer : function (layerName) {
        var me = {"layerName":layerName};
        var lyrGrp;
        if (arguments.length > 1) {
            lyrGrp = arguments[1];
        } else {
            lyrGrp = this.map.getLayerGroup();
        }
        lyrGrp.getLayers().forEach(
            function(el, index, c_array){
                if (el.get('name') === me.layerName) {
                    me.layer = el;
                    return;
                } else if (el.isLayerGroup) {
                    if (this.getMapLayer(layerName, el)) {
                        me.layer = this.getMapLayer(layerName, el);
                        return;
                    }
                }
            },
            this
        );
        return me.layer;
    },

    /**
     * Zooms in on the result features.
     */
    zoomToResultFeatures : function () {
        // Get wkt geometry corresponding to the result BBOX
        var resultsBBox = this.getView().resultsBBox ? this.getView().resultsBBox : 'POLYGON EMPTY';
        var wktGeom = this.wktFormat.readGeometry(resultsBBox);
        var extent = wktGeom.getExtent();
        if (ol.extent.isEmpty(extent)) {
            OgamDesktop.toast(this.noFeatureErrorMessage, this.noFeatureErrorTitle);
        } else {
            this.map.getView().fit(
                extent, 
                this.map.getSize()
            );
        }
        this.map.render();
    },

    /**
     * Zoom to the passed feature on the map.
     * @param {String} id The plot id
     * @param {String} wkt The wkt feature
     */
    zoomToFeature : function(id, wkt) {
            var feature = this.wktFormat.readFeature(wkt);
            var source = new ol.source.Vector();
            var vectorLyr = new ol.layer.Vector({
               source : source
            });

            var start = new Date().getTime();
            var listenerKey;
            var duration = 1500; // Animation duration
            var map = this.map;
            map.addLayer(vectorLyr);
            function animate(event) {
                var vectorContext = event.vectorContext;
                var frameState = event.frameState;
                var flashGeom = feature.getGeometry().clone();
                var elapsed = frameState.time - start;
                var elapsedRatio = elapsed / duration;
                var opacity = ol.easing.easeOut(1 - elapsedRatio);
                var highlightStyle = new ol.style.Style({
                    geometry: flashGeom,
                    stroke: new ol.style.Stroke({
                        color: 'rgba(255, 0, 0, ' + opacity + ')',
                        width: 1
                    }),
                    fill: new ol.style.Fill({
                        color: 'rgba(255, 0, 0, ' + opacity + ')'
                    }),
                            image: new ol.style.Circle({
                                radius: 7,
                                fill: new ol.style.Fill({
                                  color: 'rgba(255, 0, 0, ' + opacity + ')'
                                })
                            })
                });
                vectorLyr.setStyle(highlightStyle);
                if (source.getFeatures().length === 0) {
                    source.addFeature(feature);
                }
                if (elapsed > duration) {
                    ol.Observable.unByKey(listenerKey);
                    return;
                }
                map.render();
            }
            listenerKey = map.on('postcompose', animate);
            map.getView().fit(feature.getGeometry().getExtent(), map.getSize(), { maxZoom: 10});
    }
});