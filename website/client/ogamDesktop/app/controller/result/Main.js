/**
 * The main controller of results which manages results grid actions. 
 */
Ext.define('OgamDesktop.controller.result.Main',{
	extend: 'Ext.app.Controller',
	id: 'result-main-controller',
	requires: [
		'OgamDesktop.view.result.GridTab',
		'OgamDesktop.view.result.MainWin',
		'OgamDesktop.view.main.Main'
	],
	config: {
		refs: {
			resultmainwin: 'result-mainwin'
		},
		control: {
			'results-grid': {
				resultsload: 'toggleExportButton'
			},
			'result-mainwin': {
				exportresults: 'exportResults'
			}
		}
	},

	/**
	 * @cfg {int} Number of records to export
	 */
	count: 0,
	
	/**
	 * Toggle the export button
	 * @private
	 * @param {Boolean} emptyResult True if there are no result
	 */
	toggleExportButton: function(emptyResult, count) {
	    if (!emptyResult) {
	    	this.count = count;
	        if (!this.getResultmainwin().hideGridCsvExportMenuItem) {
	            this.getResultmainwin().exportButton.enable();
	        } else {
	            this.getResultmainwin().exportButton.hide();
	        }
	    } else {
	        this.getResultmainwin().exportButton.disable();
	    } 
	},

	/**
	 * Export the data into a file
	 * @param {String} actionName The name of the action to call
	 */
	exportResults : function(actionName) {
		
		// If results are more than 150, inform the user that the export will be asynchronous
		var largeExport = function() {
			if (this.count > 150 && actionName == 'csv-export') {
				Ext.Msg.show({
					title : this.getResultmainwin().csvExportPopupTitle,
					msg : this.getResultmainwin().csvExportPopupMsg,
					buttons : Ext.Msg.OKCANCEL,
					fn : function(buttonId) {
						if (buttonId == "ok") {
				            Ext.Ajax.request({
				                url: Ext.manifest.OgamDesktop.requestServiceUrl + 'csv-asyn-export',
				                failure: function(response, opts) {
				                    console.warm('server-side failure with status code ' + response.status);
				                },
				                scope: this
				            });
						}
					},
					animEl : this.getResultmainwin().exportButton.getEl(),
					icon : Ext.MessageBox.INFO,
					scope : this
				});
			} else {
				window.location = Ext.manifest.OgamDesktop.requestServiceUrl + actionName;
			}
		}

		// Help user to configure IE
		if (Ext.isIE && !this.getResultmainwin().hideCsvExportAlert) {
			Ext.Msg.show({
				title : this.getResultmainwin().csvExportAlertTitle,
				msg : this.getResultmainwin().csvExportAlertMsg,
				buttons : Ext.Msg.OK,
				fn : largeExport,
				animEl : this.getResultmainwin().exportButton.getEl(),
				icon : Ext.MessageBox.INFO,
				scope : this
			});
			// The message is displayed only one time
			this.getResultmainwin().hideCsvExportAlert = true;
		} else {
			largeExport.call(this);
		}
	}
});