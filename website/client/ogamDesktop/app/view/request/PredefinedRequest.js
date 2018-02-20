/**
 * This class manages the predefined request view.
 */
Ext.define('OgamDesktop.view.request.PredefinedRequest', {
    extend: 'OgamDesktop.view.request.MainWin',
    alias: 'widget.predefined-request',
    xtype: 'predefined-request',
    layout: 'hbox',
    title: 'Predefined Request',
    frame: true,
    requires: [
        'OgamDesktop.view.request.PredefinedRequestModel',
        'OgamDesktop.view.request.PredefinedRequestController',
        'OgamDesktop.ux.request.AdvancedRequestFieldSet',
        'Ext.grid.feature.Grouping',
        'OgamDesktop.store.request.predefined.PredefinedRequest',
        'OgamDesktop.view.request.PredefinedRequestSelector',
        'Ext.grid.Panel',
        'OgamDesktop.ux.request.AdvancedRequestSelector'
        ],
    controller: 'predefinedrequest',
    viewModel:{
        type:'predefinedrequest'
    },
    labelColumnHeader : "Label",
//<locale>
    /**
     * @cfg {String} resetButtonText
     * The reset Button Text (defaults to <tt>'Reset'</tt>)
     */
    resetButtonText:"Reset",
    /**
     * @cfg {String} resetButtonTooltip
     * The reset Button Tooltip (defaults to <tt>'Reset the form with the default values'</tt>)
     */
    resetButtonTooltip:"Reset the form with the default values",
    /**
     * @cfg {String} launchRequestButtonText
     * The launch Request Button Text (defaults to <tt>'Launch the request'</tt>)
     */
    launchRequestButtonText:"Launch the request",
    /**
     * @cfg {String} launchRequestButtonTooltip
     * The launch Request Button Tooltip (defaults to <tt>'Launch the request in the consultation page'</tt>)
     */
    launchRequestButtonTooltip:"Launch the request in the consultation page",
    /**
     * @cfg {String} loadingText
     * The loading Text (defaults to <tt>'Loading...'</tt>)
     */
    loadingText:"Loading...",
    /**
     * @cfg {String} defaultErrorCardPanelText
     * The default Error Card Panel Text (defaults to <tt>'Sorry, the loading failed...'</tt>)
     */
    defaultErrorCardPanelText:"Sorry, the loading failed...",
    /**
     * @cfg {String} criteriaPanelTitle
     * The criteria Panel Title (defaults to <tt>'Request criteria'</tt>)
     */
    criteriaPanelTitle:"Request criteria",
    /**
     * @cfg {String} groupTextTpl
     * The group Text Tpl (defaults to <tt>'{name} ({children.length:plural("Request")})'</tt>)
     */
    groupTextTpl:" ({children.length:plural('Request')})",
    /**
     * @cfg {String} editRequestButtonTitle
     * The edit request button title (defaults to <tt>'Edit the request'</tt>)
     */
    editRequestButtonTitle:"Edit the request",
    /**
     * @cfg {String} editRequestButtonTip
     * The edit request button tip (defaults to <tt>'Open the consultation page with the request loaded.'</tt>)
     */
    editRequestButtonTip:"Open the consultation page with the request loaded.",
    /**
     * @cfg {String} removeRequestButtonTitle
     * The remove request button title (defaults to <tt>'Delete the request'</tt>)
     */
    removeRequestButtonTitle:"Delete the request",
    /**
     * @cfg {String} removeRequestButtonTip
     * The remove request button tip (defaults to <tt>'Remove the request permanently.'</tt>)
     */
    removeRequestButtonTip:"Remove the request permanently.",
    /**
     * @cfg {String} datasetColumnTitle
     * The dataset column title (defaults to <tt>'Dataset'</tt>)
     */
    datasetColumnTitle:"Dataset",
    /**
     * @cfg {String} groupColumnTitle
     * The group column title (defaults to <tt>'Group'</tt>)
     */
    groupColumnTitle:"Group",
    /**
     * @cfg {String} defaultGroupName
     * The default group name (defaults to <tt>'Not grouped'</tt>)
     */
    defaultGroupName:"Not grouped", //'Non groupée{[values.rows.length > 1 ? "s" : ""]}',
//</locale>

    /**
     * Initializes the items.
     */
    initItems: function() {
    	var groupers = [{
            property: 'group_label',
            sorterFn: function(item1, item2) {
            	// Something to keep in mind would be capitals. "a" < "b" === true "a" < "B" === false
            	var sorterString1 = item1.data.group_position + item1.data.group_label.toUpperCase();
            	var sorterString2 = item2.data.group_position + item2.data.group_label.toUpperCase();
                return (sorterString1 > sorterString2) ? 1 : (sorterString1 === sorterString2 ? 0 : -1);
            }
    	},{
            property: 'dataset_label',
            sorterFn: function(item1, item2) {
            	// Something to keep in mind would be capitals. "a" < "b" === true "a" < "B" === false
            	var sorterString1 = item1.data.dataset_label.toUpperCase();
            	var sorterString2 = item2.data.dataset_label.toUpperCase();
                return (sorterString1 > sorterString2) ? 1 : (sorterString1 === sorterString2 ? 0 : -1);
            }
        }];
    	
        var store = new OgamDesktop.store.request.predefined.PredefinedRequest({
            storeId:'PredefinedRequestTabRequestStore',
            grouper: groupers[0]
        });

        var columns = [{
            text: this.labelColumnHeader,
            flex: 1,
            dataIndex: 'label',
            groupable: false,
            renderer: function (value, object, record) {
                if (record.get('is_public')) {
                    return value;
                } else {
                    return '<span class="o-predefined-request-grid-panel-private-request">' + value + '</span>';
                }
            }
        },{
            text: this.datasetColumnTitle,
            flex: 1,
            dataIndex: 'dataset_label'
        },{
            text: this.groupColumnTitle,
            flex: 1,
            dataIndex: 'group_label'
        },{
            xtype: 'actioncolumn',
            width: 40,
            fixed : true,
            sortable: false,
            groupable: false,
            menuDisabled: true,
            align : 'center',
            items:[{
                iconCls: 'o-predefined-request-grid-panel-tools-edit-edit',
                tooltip: "<b>"+this.editRequestButtonTitle+"</b><br/>"+this.editRequestButtonTip,
                handler: function(grid, rowIndex, colIndex, item, e, record, row) {
                    // Action managed into the advanced request panel
                    this.fireEvent('predefinedRequestEdition', record);
                },
                isDisabled: function(view, rowIndex, colIndex, item, record) {
                    // OgamDesktop.getApplication().getCurrentUser() can not be used here because it is not yet ready...
                    return record.get('is_read_only');
                },
                scope:this
            },{
                iconCls: 'o-predefined-request-grid-panel-tools-edit-bin',
                tooltip: "<b>"+this.removeRequestButtonTitle+"</b><br/>"+this.removeRequestButtonTip,
                handler: function(grid, rowIndex, colIndex, item, e, record, row) {
                    // Action managed into the advanced request panel
                    this.fireEvent('predefinedRequestDeletion', record);
                },
                isDisabled: function(view, rowIndex, colIndex, item, record) {
                    // OgamDesktop.getApplication().getCurrentUser() can not be used here because it is not yet ready...
                    return record.get('is_read_only');
                },
                scope:this
            }]
        }];

        var features = [{
            ftype: 'grouping',
            groupHeaderTpl: new Ext.XTemplate(
                '<tpl if="name !== \'\'">',
                    '{name}',
                '<tpl else>',
                    this.defaultGroupName,
                '</tpl>',
                this.groupTextTpl
            ),
            hideGroupedHeader: true,
            startCollapsed: false,
            groupers: groupers
        }];
        
        this.items = [{
            xtype: 'gridpanel',
            itemId: 'predefinedRequestGridPanel',
            cls: 'o-predefined-request-grid-panel',
            height:'100%',
            store: store,
            width: '50%',
            margin: '10 10 10 10',
            columns: columns,
            features: features,
            reference:'requete',
            plugins: [{
                ptype: 'rowexpander',
                //columnWidth: 0, doesn't work on extjs 6.0.1.250
                //headerWidth: 0, doesn't work properly on extjs 6.0.1.250
                rowBodyTpl : new Ext.XTemplate('<p class="o-predefined-request-grid-panel-description-text">{definition}</p>')
            }]
        },{
            title: this.criteriaPanelTitle,
            hideMode: 'display',
            xtype:'predefined-request-selector',
            bind:{
                request :{
                    bindTo:'{requete.selection}',
                    deep:true
                }
            },
            flex: 1,
            margin: '10 10 10 0',
            height:'100%',
            dockedItems: [{
                xtype: 'toolbar',
                dock: 'bottom',
                items: [{
	                xtype: 'button',
	                text: this.resetButtonText,
	                tooltipType: 'title',
	                tooltip:this.resetButtonTooltip,
	                handler:'onResetRequest'
	            },'->',{
	                xtype: 'button',
	                itemId:'launchRequest',
	                text: this.launchRequestButtonText,
	                tooltipType: 'title',
	                tooltip:this.launchRequestButtonTooltip
	            }]
            }]
        }];

        this.callParent();
    }
});