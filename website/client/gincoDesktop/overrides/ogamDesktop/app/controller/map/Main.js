Ext.define('Ginco.controller.map.Main', {
	override : 'OgamDesktop.controller.map.Main',

	config : {
		refs : {
			detailTab : 'grid-detail-panel'
		}
	},

	/**
	 * Update the map on request success
	 * 
	 * Override: fire a custom Event 'resultsPrepared', listened by Grids.js, in
	 * order to have a sequential order in ajax requests :
	 * 
	 * ajaxBuildRequest --> ajaxGetResultsBBox --> // ajaxGetResultsColumns -->
	 * ajaxGetResultsRows // mapProxy (map images)
	 * 
	 * @private
	 */
	onRequestSuccess : function() {
		// Clear the detail grid (map bottom panel)
		this.getDetailTab().reinitializeDetailGrid();

		this.getMapmainwin().mask(this.requestLoadingMessage);
		Ext.Ajax.request({
			url : Ext.manifest.OgamDesktop.requestServiceUrl
					+ 'ajaxgetresultsbbox',
			success : function(response, options) {
				var result = Ext.decode(response.responseText);
				if (result.success) {
					this.setResultsBbox(result.resultsbbox.bbox);
					this.updateRequestLayers();
					Ext.GlobalEvents.fireEvent('resultsPrepared');
					if (result.resultsbbox.restrained) {
						OgamDesktop.toast(this.restrainedBboxWarning,
								this.restrainedBboxWarningTitle, 5000);
						this.getMapmainwin().unmask();
					}
				} else {
					OgamDesktop.toast(result.errorMessage,
							this.getresultsbboxErrorTitle);
					this.getMapmainwin().unmask();
				}
			},
			scope : this
		});
	},

	/**
	 * Show the map container and zoom on the result BBox.
	 * 
	 * Override: - Doesn't "zoomToFeature" if a record has no geometry visible. -
	 * Ajax request for dynamic result instead of pre-calculcation on search
	 * click.
	 * 
	 * @private
	 * @param {Object}
	 *            feature The feature corresponding to the grid row, contains id
	 *            and geometry.
	 */
	onSeeOnMapButtonClick : function(feature) {

		Ext.Ajax.request({
			url : Ext.manifest.OgamDesktop.requestServiceUrl
					+ 'ajaxgetobservationbbox',
			actionMethods : {
				create : 'POST',
				read : 'POST',
				update : 'POST',
				destroy : 'POST'
			},
			success : function(response, options) {
				var data = Ext.decode(response.responseText);
				var bbox = data.bbox;
				if (bbox) {
					this.getMapmainwin().ownerCt.setActiveItem(this
							.getMapmainwin());
					this.getMappanel().child('mapcomponent').getController()
							.zoomToFeature(feature.id, bbox);
				} else {
					OgamDesktop.toast(this.noGeometryError,
							this.noGeometryErrorTitle);
				}
			},
			method : 'POST',
			params : {
				observationId : feature.id
			},
			scope : this
		});
	}

});