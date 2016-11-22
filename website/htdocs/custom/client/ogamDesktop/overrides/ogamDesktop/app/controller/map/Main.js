Ext.define('Ginco.controller.map.Main', {
    override: 'OgamDesktop.controller.map.Main',

    config: {
		refs: {
            detailTab: 'grid-detail-panel'
		}
	},
    
    /**
     * Update the map on request success
     *
     * Override: fire a custom Event 'resultsPrepared', listened by Grids.js,
     * in order to have a sequential order in ajax requests :
     *
     * ajaxBuildRequest --> ajaxGetResultsBBox --> // ajaxGetResultsColumns --> ajaxGetResultsRows
     *                                             // mapProxy (map images)
     *
     * @private
     */
    onRequestSuccess: function() {
    	// Clear the detail grid (map bottom panel)
    	this.getDetailTab().reinitializeDetailGrid();
		
        this.getMapmainwin().mask(this.requestLoadingMessage);
        Ext.Ajax.request({
            url : Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetresultsbbox',
            success : function(response, options) {
                var result = Ext.decode(response.responseText);
                if (result.success) {
                    this.setResultsBbox(result.resultsbbox);
                    this.updateRequestLayers();
                    Ext.GlobalEvents.fireEvent('resultsPrepared');
                } else {
                    OgamDesktop.toast(result.errorMessage, this.getresultsbboxErrorTitle);
                    this.getMapmainwin().unmask();
                }
            },
            scope: this
        });
    },

    /**
     * Show the map container and zoom on the result BBox.
     *
     * Override: doesn't "zoomToFeature" if a record has no geometry visible.
     *
     * @private
     * @param {Object} feature The feature corresponding to the grid row,
     * contains id and geometry.
     */
    onSeeOnMapButtonClick: function(feature) {
        if (feature.location_centroid) {
            this.getMapmainwin().ownerCt.setActiveItem(this.getMapmainwin());
            this.getMappanel().child('mapcomponent').getController().zoomToFeature(feature.id, feature.location_centroid);
        } else {
            OgamDesktop.toast(this.noGeometryError, this.noGeometryErrorTitle);
        }
    }

});