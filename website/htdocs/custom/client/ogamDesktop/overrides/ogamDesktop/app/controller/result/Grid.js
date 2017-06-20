Ext.define('Ginco.controller.result.Grid', {
    override: 'OgamDesktop.controller.result.Grid',

    /**
     * Fill the grid by updating binded model and store.
     * Override: disable edit button if the user has no right to edit other provider data
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
                                console.log("Edition rights: " + OgamDesktop.view.result.GridTab.checkEditionRights);
                                console.log("Edition rights: " + OgamDesktop.checkEditionRights);
                                // Redirect to edition-panel
                                if (!OgamDesktop.checkEditionRights || (OgamDesktop.userProviderId == record.data._provider_id)) {
                                    this.redirectTo('edition-edit/' + /*encodeURIComponent(*/record.data.id/*)*//*, true*/);
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
                    gridTab.fireEvent('resultsload', Ext.isEmpty(records));
                }
            });

            // Update the grid adding the columns and the data rows.
            gridTab.reconfigure(resultStore, gridColumnCfg);

        } else { // Success false
            OgamDesktop.toast(operation.getError(), this.getGridColumnsErrorTitle);
        }

        this.getResultmainwin().unmask();
    },

},

function(overriddenClass){
    /*
     * Override: catch the 'resultsPrepared' event instead of the 'requestSuccess'.
     * See: app/controller/map/Main.js
     */
    var config = overriddenClass.prototype.config;
    delete config.listen;
    config.listen = {
        global : {
            resultsPrepared : 'getGridColumns'
        }
    };
});