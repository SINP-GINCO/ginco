/**
 * This class defined the map component view. 
 */
Ext.define("Ginco.view.map.MapComponent",{
    override: "OgamDesktop.view.map.MapComponent"
}, function(overriddenClass){
	var map = this.listeners;
	console.log(JSON.stringify(map));
//	var drawingLayer = map.getLayersByName('drawingLayer')[0];
//	drawingLayer.setZIndex(1000);
});