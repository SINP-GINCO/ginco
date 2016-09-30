/**
 * This class manages the map panel toolbar view.
 */
Ext.define('Ginco.view.map.MapComponentController', {
    override: 'OgamDesktop.view.map.MapComponentController',

    /**
     * Zoom to the passed feature on the map.
     *
     * Override : add a maxZoom (for points and small geometries)
     *
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