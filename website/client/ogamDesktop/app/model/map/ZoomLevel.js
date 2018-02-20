/**
 * This class defines the model for the zoom level.
 */
Ext.define('OgamDesktop.model.map.ZoomLevel',{
    extend: 'OgamDesktop.model.base',
    alias: 'data.field.zoomlevel',
    idProperty: 'id',
    fields: [
        {name: 'id', type: 'string'},
        {name: 'zoomLevel', type: 'integer'},
        {name: 'resolution', type: 'number'},
        {name: 'approximateScaleDenominator', type: 'integer'},
        {name: 'scaleLabel', type: 'string'},
        {name: 'isMapZoomLevel', type: 'boolean'}
    ]
});