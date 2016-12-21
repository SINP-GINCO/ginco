/**
 * This class manages the map panel toolbar view.
 */
Ext.define('Ginco.view.map.MapToolbarController', {
    override: 'OgamDesktop.view.map.MapToolbarController',


    /**
     * Initializes the controller.
     * @private
     */
    init : function() {
        // Call ogam parent init function
        this.callParent();
        
        // Add event listener for locationInfo
        this.map.on("click", this.getLocationInfo, this);

        // Hide buttons of consultation toolbar
        this.lookupReference('zoomInButton').hide();
        this.lookupReference('resultFeatureInfoButton').hide();
        
    },
    
    /**
     * get the active (currently visible) request layers
     */
    getActiveRequestLayersNames: function() {
        var currentResolution = this.mapCmpCtrl.map.getView().getResolution();
        var requestLayers = this.mapCmpCtrl.requestLayers;
        var activeRequestLayersNames = [];
        requestLayers.forEach(function(element, index, array){
            // test if element is currently viewed, ie visible (checked in layer_tree)
            // and current resolution is between min and max resolutions for this layer
            if (element.getVisible() && this.mapCmpCtrl.isResInLayerRange(element, currentResolution)) {
                activeRequestLayersNames.push(element.get("name"));
            }
        },this);
        return activeRequestLayersNames;
    },

    /**
     * Overwrites to pass the active request layers
     *
     * Makes a ajax request to get some information about a location.
     * @param {ol.MapBrowserEvent} e the map click event
     */
    getLocationInfo : function(e) {

        var lon = e.coordinate[0], lat=e.coordinate[1];
        var url = Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetlocationinfo?LON='+lon+'&LAT='+lat;
        if (OgamDesktop.map.featureinfo_maxfeatures !== 0) {
            url = url + "&MAXFEATURES=" + OgamDesktop.map.featureinfo_maxfeatures;
        }
        // Add the active request layers names
        var activeRequestLayersNames = this.getActiveRequestLayersNames();
        var layersString = [];
        activeRequestLayersNames.forEach(function (element, index) {
            layersString.push( 'layers[]=' + element);
        });
        url += '&' + layersString.join('&');

        Ext.Ajax.request({
            url : url,
            success : function(rpse, options) {
                var result = Ext.decode(rpse.responseText);
                this.getView().up('panel').fireEvent('getLocationInfo', {'result': result});
            },
            scope: this
        });
    }
});