/**
 * This class defined the map component view. 
 */
Ext.define("OgamDesktop.view.map.MapComponent",{
    extend: "GeoExt.component.Map",
    xtype: 'mapcomponent',
    id:'o-map',
    controller: 'mapcomponent',
    listeners: {
        resultswithautozoom: 'zoomToResultFeatures'
    },

    /**
     * The map object.
     * @type {ol.Map}
     * @property map
     */
    map: new ol.Map({
        logo: false, // no attributions to ol
        interactions: ol.interaction.defaults({altShiftDragRotate:false, pinchRotate:false}), // disable rotation
        layers: [
            new ol.layer.Vector({
                name: 'drawingLayer',
                text: 'Drawing layer',
                source: new ol.source.Vector({features: new ol.Collection()}),
                style: new ol.style.Style({
                    fill: new ol.style.Fill({
                        color: 'rgba(255, 255, 255, 0.2)'
                    }),
                    stroke: new ol.style.Stroke({
                        color: '#ffcc33',
                        width: 2
                    }),
                    image: new ol.style.Circle({
                        radius: 7,
                        fill: new ol.style.Fill({
                          color: '#ffcc33'
                        })
                    })
                })
            }),
            new ol.layer.Vector({
                name: 'snappingLayer',
                text: 'Snapping layer',
                source: new ol.source.Vector({features: new ol.Collection()}),
                style: new ol.style.Style({
                    stroke: new ol.style.Stroke({
                        color: 'rgba(0, 0, 255, 1.0)',
                        width: 2
                    }),
                    image: new ol.style.Circle({
                        radius: 2,
                        fill: new ol.style.Fill({
                            color: 'rgba(0, 0, 255, 1.0)'
                        })
                    })
                })
            })
        ],
        view: new ol.View({
            resolutions: OgamDesktop.map.resolutions,
            projection : OgamDesktop.map.projection,
            center: [OgamDesktop.map.x_center, OgamDesktop.map.y_center],
            zoom: OgamDesktop.map.zoomLevel,
            extent: [
                OgamDesktop.map.x_min,
                OgamDesktop.map.y_min,
                OgamDesktop.map.x_max,
                OgamDesktop.map.y_max
            ]
        }),
        controls:  [
            new ol.control.ZoomSlider(),
            new ol.control.ScaleLine(),
            new ol.control.Scale ({className:'o-map-tools-map-scale'}),
            new ol.control.MousePosition({
                className:'o-map-tools-map-mouse-position',
                coordinateFormat :function(coords){
                    var template = 'X: {x} - Y: {y} ' + OgamDesktop.map.projection;
                    return ol.coordinate.format(coords, template);
            }})
        ]
    })
});
