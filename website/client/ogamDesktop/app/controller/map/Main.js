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
            mapmainwin: 'map-mainwin',
			detailTab : 'grid-detail-panel'
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
     * @cfg {String} getToMuchResultsTitle
     */
    getToMuchResultsTitle: 'Search failed :',
    
    /**
     * @cfg {String} getToMuchResultsMessage
     */
    getToMuchResultsMessage: '{0} results found. This number of results is huge. Please precise your research.',

    /**
     * Manage the launch event
     * @private
     */
    onLaunch:function(){
		//clean previous request or result in server side
		Ext.Ajax.request({
			url: Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxresetresult',
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
     * Doesn't "zoomToFeature" if a record has no geometry visible. -
	 * Ajax request for dynamic result instead of pre-calculcation on search
	 * click.
     * @private
     * @param {Object} feature The feature corresponding to the grid row,
     * contains id and geometry.
     */
    onSeeOnMapButtonClick: function(feature) {
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
    },

    /**
     * Update the map on request success
     * Fire a custom Event 'resultsPrepared', listened by Grids.js, in
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
				if (result.success ) {
					if (result.resultsbbox){
						this.setResultsBbox(result.resultsbbox);
					} else {
						this.setResultsBbox(null);
					}
					
					this.updateRequestLayers();
					Ext.GlobalEvents.fireEvent('resultsPrepared');
				} else {
					if (result.count) {
						OgamDesktop.toast(Ext.String.format(this.getToMuchResultsMessage, result.count),
								this.getToMuchResultsTitle);
						this.getMapmainwin().unmask();
					} else {
						OgamDesktop.toast(result.errorMessage,
								this.getresultsbboxErrorTitle);
						this.getMapmainwin().unmask();
					}
				}
			},
			scope : this
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