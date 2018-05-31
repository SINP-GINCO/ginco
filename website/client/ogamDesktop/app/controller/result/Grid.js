/**
 * This class defines the controller with actions related to 
 * data loading into results grid
 */
Ext.define('OgamDesktop.controller.result.Grid',{
	extend: 'Ext.app.Controller',
	requires: [
		'OgamDesktop.view.result.GridTab',
		'OgamDesktop.store.result.Grid',
		'OgamDesktop.model.result.GridColumn',
		'OgamDesktop.ux.data.field.Factory',
		'OgamDesktop.ux.grid.column.Factory',
		'Ext.window.MessageBox',
		'Ext.grid.column.Action',
		'Ext.grid.column.Date',
		'Ext.grid.column.Boolean'
	],
	uses:[
	    'OgamDesktop.view.edition.Panel',
	    'OgamDesktop.view.edition.PanelController'
	],
	config: {
		refs: {
			resultsgrid: 'results-grid',
			resultmainwin: 'result-mainwin',
			mainView: 'app-main'
		},
		listen: {
	        global : {
	            resultsPrepared : 'getGridColumns'
	        }
        }
	},

    //<locale>
    /**
     * @cfg {String} requestLoadingMessage
     * The request loading message (defaults to <tt>'Please wait, while loading the results...'</tt>)
     */
    requestLoadingMessage: 'Please wait, while loading the results...',
    /**
     * @cfg {String} getGridColumnsErrorTitle
     * The error title when the grid columns loading fails (defaults to <tt>'Loading of columns in the grid failed:'</tt>)
     */
    getGridColumnsErrorTitle: 'Loading of columns in the grid failed:',
    //</locale>

    /**
     * Gets the grid columns configuration
     * @private
     */
	getGridColumns: function() {

		this.getResultmainwin().mask(this.requestLoadingMessage);

		var columnsStore = Ext.create('Ext.data.Store', {
		    model: 'OgamDesktop.model.result.GridColumn',
		    proxy: {
		        type: 'ajax',
		        url : Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgetresultcolumns',
				reader: {
				    type : 'json',
				    rootProperty : 'data',
				    successProperty: 'success',
				    messageProperty: 'errorMessage'
				}
		    }
		});

		columnsStore.load({
		    callback: this.setResultsGrid,
		    scope: this
		});
	},

    /**
     * Fill the grid by updating binded model and store.
     * @private
     * @param {Array} fields The grid's colums that the server returns on the query form submission
     */
    setResultsGrid: function(fields, operation, success) {
        if (success) {
            var resultStore = this.getStore('result.Grid');
            var gridModel = resultStore.getModel();
            var gridTab = this.getResultsgrid();
            var mainView = this.getMainView();
            var gridModelCfg = [];
            var gridColumnCfg = [];

            if(!Ext.isEmpty(fields)) {

                // Add 'open details' and 'see on the map' actions
                var leftActionColumnItems = [];
                if (!gridTab.hideNavigationButton) {
                    leftActionColumnItems.push({
                        iconCls: 'o-result-tools-nav-showdetails',
                        tooltip: "<b>"+gridTab.openNavigationButtonTitle+"</b><br/>"+gridTab.openNavigationButtonTip,
                        handler: function(grid, rowIndex, colIndex, item, e, record, row) {
                            // Action managed into result main controller
                            gridTab.fireEvent('onOpenNavigationButtonClick', record);
                        }
                    });
                }
                leftActionColumnItems.push({
                    iconCls: 'o-result-tools-nav-showmap',
                    tooltip: "<b>"+gridTab.seeOnMapButtonTitle+"</b><br/>"+gridTab.seeOnMapButtonTip,
                    handler: function(grid, rowIndex, colIndex, item, e, record, row) {
                        // Action managed into result main controller
                        gridTab.fireEvent('seeOnMapButtonClick', record.data);
                    }
                });
                gridColumnCfg.push({
                    xtype: 'actioncolumn',
                    sortable : false,
                    fixed : true,
                    menuDisabled : true,
                    align : 'center',
                    width : 40,
					hideable: false,
                    items: leftActionColumnItems
                });

                // Add 'edit data' action
                if (!gridTab.hideGridDataEditButton) {
                    Ext.require([
                        'OgamDesktop.view.edition.Panel',
                        'OgamDesktop.view.edition.PanelController'
                    ]);
                    Ext.Loader.loadScript(Ext.manifest.OgamDesktop.editionServiceUrl+'getParameters');
                    gridColumnCfg.push({
                        xtype: 'actioncolumn',
                        sortable : false,
                        fixed : true,
                        menuDisabled : true,
                        align : 'center',
                        width : 30,
						hideable: false,
                        items:[{
                            iconCls: 'o-result-tools-edit-editdetails',
                            tooltip: "<b>"+gridTab.editDataButtonTitle+"</b><br/>"+gridTab.editDataButtonTip,
                            handler: function(grid, rowIndex, colIndex, item, e, record, row) {
                                // Redirect to edition-panel
                                if (!OgamDesktop.checkEditionRights || (OgamDesktop.userProviderId == record.data._provider_id)) {
                                this.redirectTo('edition-edit/'+/*encodeURIComponent(*/record.data.id/*)*//*, true*/);
                                }
                                else {
                                    OgamDesktop.toast('L\'édition de cette donnée est impossible, vous n\'avez pas les droits de modifier les données d\'un autre organisme.');
                                }
                            },
                            getClass: function (value, meta, record, rowIndex, colIndex, store) {
                                if (OgamDesktop.checkEditionRights && (OgamDesktop.userProviderId != record.data._provider_id) ) {
                                    return 'o-result-tools-edit-editdetails disabled';
                                }
                                return 'o-result-tools-edit-editdetails';
                            },
                            scope:this
                        }]
                    });
                }

                // Build the result fields for the model and the column
                for (i in fields) {
                    var field = fields[i].data;
                    var fieldConfig = {
                        name: field.name,
                        type: field.type ? field.type.toLowerCase() : 'auto',
                        defaultValue : null
                    };
					var columnConfig = {
							dataIndex: field.name,
							text: field.label,
							tooltip: field.definition,
							hidden: field.hidden,
							hideable: true
						};
					if (field.label == 'Identifier of the line' || field.label == 'Provider') {
						columnConfig.hideable = false;
					}
                    switch (field.inputType) {
                        case 'CHECKBOX':
                            Ext.applyIf(columnConfig, OgamDesktop.ux.grid.column.Factory.buildBooleanColumnConfig());
                            Ext.applyIf(fieldConfig, OgamDesktop.ux.data.field.Factory.buildCheckboxFieldConfig(field));
                            break;
                        // OGAM-586 - TODO: refactor the code below to have only the switch on the inputType
                        default:
                            switch (field.type) {
                                // OGAM-587 - TODO : CODE, COORDINATE, ARRAY
                                case 'STRING':
                                    columnConfig.xtype = 'gridcolumn';
                                    if (field.subtype === 'LINK'){
                                        columnConfig.width = 30;
                                        columnConfig.renderer= this.renderLink
                                    }
                                    break;
                                case 'INTEGER':
                                    columnConfig.xtype = 'gridcolumn';
                                    break;
                                case 'NUMERIC':
                                    columnConfig.xtype = 'numbercolumn';
                                    if (field.decimals !== null) {
                                        columnConfig.format = this.numberPattern('.', field.decimals);
                                    }
                                    break;
                                case 'DATE':
                                    columnConfig.xtype = 'datecolumn';
                                    columnConfig.format = gridTab.dateFormat;
                                    break;
                                case 'IMAGE':
                                    columnConfig.header = '';
                                    columnConfig.width = 30;
                                    columnConfig.sortable = false;
                                    // OGAM-588 - TODO : createDelegate deprecated : using of Ext.Function.pass instead, not tested...
                                    //columnConfig.renderer = Ext.Function.pass(this.renderIcon, [Ext.String.htmlEncode(field.label)], this);
                                    break;
                                default:
                                    columnConfig.xtype = 'gridcolumn';
                                    break;
                            }
                            break;
                    }
                    gridColumnCfg.push(columnConfig);
                    gridModelCfg.push(Ext.create('Ext.data.field.Field', fieldConfig));
                }

                // Update the grid model
                gridModel.replaceFields(gridModelCfg, true);

            } else { // Fields parameter is empty
                console.warn('There is no defined columns to configure the grid.');
                // Avoids to freeze the grid
                gridModel = Ext.create('Ext.data.Model');
            }

            // Update the results grid store binding the model to it
            // and apply pageSize value.
            resultStore.setConfig('pageSize', gridTab.gridPageSize);
            resultStore.setModel(gridModel);

            // Load the grid results store
            resultStore.loadPage(1, {
                callback: function(records) {
					gridTab.fireEvent('resultsload', Ext.isEmpty(records), resultStore.getTotalCount());
                }
            });

            // Update the grid adding the columns and the data rows.
            gridTab.reconfigure(resultStore, gridColumnCfg);

        } else { // Success false
            OgamDesktop.toast(operation.getError(), this.getGridColumnsErrorTitle);
        }

        this.getResultmainwin().unmask();
    },
	
	/**
	 * Return the pattern used to format a number.
	 * @param {String} decimalSeparator The decimal separator (default to',')
	 * @param {Integer} decimalPrecision The decimal precision
	 * @param {String} groupingSymbol The grouping separator (absent by default)
	 * @return {String} The number format pattern
	 */
	numberPattern : function(decimalSeparator, decimalPrecision, groupingSymbol) {
		// Building the number format pattern for use by ExtJS
		// Ext.util.Format.number
		var pattern = [], i;
		pattern.push('0');
		if (groupingSymbol) {
			pattern.push(groupingSymbol + '000');
		}
		if (decimalPrecision) {
			pattern.push(decimalSeparator);
			for (i = 0; i < decimalPrecision; i++) {
				pattern.push('0');
			}
		}
		return pattern.join('');
	},
	
	/**
	 * Return a link or emptyCellText if url is empty
	 * @param {String} uri Href of the link to generate
	 * @return {String} a link or text
	 */
	renderLink:function (uri, metadata){
		if (Ext.isEmpty(uri)){
			return this.emptyCellText;
		}
		return Ext.String.format('<a class ="external" href="{0}" target="_blank">&#160;</a>',uri);
	}//,
	/*
	 * OGAM-589 - TODO: Render an Icon for the data grid.
	 */
	/*renderIcon : function(value, metadata, record, rowIndex, colIndex, store, columnLabel) {
		if (!Ext.isEmpty(value)) {
			return '<img src="' + Ext.manifest.OgamDesktop.requestServiceUrl + '../client/ogamDesktop/resources/images/picture.png"'
			+ 'ext:qtitle="' + columnLabel + ' :"'
			+ 'ext:qwidth="' + this.getResultsgrid().tipImageDefaultWidth + '"'
			+ 'ext:qtip="'
			+ Ext.String.htmlEncode('<img width="' + (this.getResultsgrid().tipImageDefaultWidth - 12) 
			+ '" src="' + Ext.manifest.OgamDesktop.requestServiceUrl + '../client/ogamDesktop/img/photos/' + value 
			+'" />') 
			+ '">';
		}
	}*/
});