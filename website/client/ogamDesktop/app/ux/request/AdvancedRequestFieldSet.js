/**
 * Licensed under EUPL v1.1 (see http://ec.europa.eu/idabc/eupl).
 *
 * © European Union, 2008-2012
 *
 * Reuse is authorised, provided the source is acknowledged. The reuse policy of the European Commission is implemented by a Decision of 12 December 2011.
 *
 * The general principle of reuse can be subject to conditions which may be specified in individual copyright notices.
 * Therefore users are advised to refer to the copyright notices of the individual websites maintained under Europa and of the individual documents.
 * Reuse is not applicable to documents subject to intellectual property rights of third parties.
 */

/**
 * Show one field form.
 * 
 * The following parameters are expected : 
 *     title : The title of the form
 *     id : The identifier of the form
 * 
 * @class OgamDesktop.ux.request.AdvancedRequestFieldSet
 * @extends OgamDesktop.ux.request.RequestFieldSet
 * @constructor Create a new AdvancedRequestFieldSet
 * @param {Object}
 *            config The config object
 */
Ext.define('OgamDesktop.ux.request.AdvancedRequestFieldSet', {
	extend: 'OgamDesktop.ux.request.RequestFieldSet',
	alias:'widget.advancedrequestfieldset',
	xtype: 'advanced-request-fieldset',
	requires:['OgamDesktop.ux.request.RequestFieldSet'],

	//<locale>
	/**
	 * @cfg {String} criteriaPanelTbarLabel The criteria Panel Tbar Label
	 *      (defaults to <tt>'Criteria'</tt>)
	 */
	criteriaPanelTbarLabel : 'Criteria',
	/**
	 * @cfg {String} criteriaPanelTbarComboLoadingText The criteria Panel Tbar
	 *      Combo Loading Text (defaults to <tt>'searching...'</tt>)
	 */
	criteriaPanelTbarComboLoadingText : 'Searching...',
	/**
	 * @cfg {String} columnsPanelTbarLabel The columns Panel Tbar Label
	 *      (defaults to <tt>'Columns'</tt>)
	 */
	columnsPanelTbarLabel : 'Columns',
	/**
	 * @cfg {String} columnsPanelTbarComboEmptyText The columns Panel Tbar Combo
	 *      Empty Text (defaults to <tt>'Select...'</tt>)
	 */
	columnsPanelTbarComboEmptyText : 'Select...',
	/**
	 * @cfg {String} columnsPanelTbarComboLoadingText The columns Panel Tbar
	 *      Combo Loading Text (defaults to <tt>'searching...'</tt>)
	 */
	columnsPanelTbarComboLoadingText : 'Searching...',
	/**
	 * @cfg {String} columnsPanelTbarAddAllButtonTooltip The columns Panel Tbar
	 *      Add All Button Tooltip (defaults to <tt>'Add all the columns'</tt>)
	 */
	columnsPanelTbarAddAllButtonTooltip : 'Add all the columns',
	/**
	 * @cfg {String} columnsPanelTbarRemoveAllButtonTooltip The columns Panel
	 *      Tbar Remove All Button Tooltip (defaults to
	 *      <tt>'Remove all the columns'</tt>)
	 */
	columnsPanelTbarRemoveAllButtonTooltip : 'Remove all the columns',
	//</locale>

	/**
	 * @cfg {Boolean} frame See {@link Ext.Panel#frame}. Default to true.
	 */
	frame : true,

	/**
	 * @cfg {Integer} criteriaLabelWidth The criteria Label Width (defaults to
	 *      <tt>120</tt>)
	 */
	criteriaLabelWidth : 120,

	/**
	 * @cfg {Integer} comboPageSize The criteria and column combobox page size (defaults to
	 *      <tt>10</tt>)
	 */
	comboPageSize : 10,

	/**
	 * Initialise the component.
	 * @protected
	 */
	initComponent: function() {
		this.callParent(arguments);
		this.collapsible = true;
		this.titleCollapse = true;
		this.updateLayout();
	},

	/**
	 * Initialise the items.
	 * @protected
	 */
	initItems: function(){

		// Prepares the parameters for the local or the remote mode
		if (this.criteriaDS.count() > this.comboPageSize) {
			var comboCriteriaInLocalMode = false;
			/**
			 * A remote criteria data store (We get better performances with a remote store).
			 * @property remoteCriteriaDS
			 * @type {Ext.data.JsonStore}
			 */
			this.remoteCriteriaDS = new Ext.data.JsonStore({
				model:'OgamDesktop.model.request.fieldset.Criterion',
				proxy: {
					type: 'ajax',
					url: Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetqueryformfields',
					reader: {
						type : 'json',
						rootProperty : 'data',
						totalProperty  : 'total',
						successProperty: 'success',
						messageProperty: 'errorMessage'
					}
				},
				filters:[{
					"property": "processId",
					"value": this.currentProcessId
				},{
					"property": "form",
					"value": this.id
				},{
					"property": "fieldsType",
					"value": "criteria"
				}],
				remoteFilter: true,
				pageSize: this.comboPageSize
			});
		} else {
			var comboCriteriaInLocalMode = true;
			/**
			 * A local criteria data store (Reset the bad default criteriaDS config (No edit filter, remoteSort set to true...)).
			 * @property localCriteriaDS
			 * @type {Ext.data.JsonStore}
			 */
			this.localCriteriaDS = Ext.create('Ext.data.Store', {
				model:'OgamDesktop.model.request.fieldset.Criterion',
				data:this.criteriaDS.getData().items
			});
		}

		/**
		 * The panel used to show the criteria.
		 * @property criteriaPanel
		 * @type {Ext.Panel}
		 */
		this.criteriaPanel = new Ext.panel.Panel({
			layout : {
				type : 'form'
				//labelWidth: 100 // Don't use this parameter because it change the bin width (Bug Ext! Check with ext 5.0.1 post version)
			},
			hideMode : 'offsets',
			cls : 'o-ux-adrfs-filter-item',
			labelWidth : this.criteriaLabelWidth,
			defaults : {
				labelStyle : 'padding: 0;',
				beforeLabelTpl : '<div class="o-ux-adrfs-filterBin">&nbsp;&nbsp;&nbsp;</div>',
				labelClsExtra : 'o-columnLabelColor o-ux-adrfs-labelNextBin'
				//width : 180 not used in a form layout (Table-row display)
			},
			items :( Ext.isEmpty(this.criteriaValues) ? this.getDefaultCriteriaConfig() : this.getFilledCriteriaConfig()),
			tbar : [ {
				// Filler
				xtype : 'tbfill'
			},
			// The label
			{
				xtype : 'tbtext',
				text  : this.criteriaPanelTbarLabel
			},{
				// A spacer
				xtype : 'tbspacer'
			}, {
				// The combobox with the list of available criterias
				xtype : 'combo',
				hiddenName : 'Criteria',
				store: comboCriteriaInLocalMode ? this.localCriteriaDS : this.remoteCriteriaDS,
				queryMode : comboCriteriaInLocalMode ? 'local' : 'remote',
				pageSize : comboCriteriaInLocalMode ? 0 : this.comboPageSize,
				editable : true,
				autoLoadOnValue: true,
				displayField : 'label',
				valueField : 'name',
				width : 220,
				maxHeight : 100,
				emptyText : this.criteriaPanelTbarComboEmptyText,
				loadingText : this.criteriaPanelTbarComboLoadingText,
				listeners : {
					'select' : this.addSelectedCriteria,
					scope : this
				}
			}, {
				// A spacer
				xtype : 'tbspacer'
			} ]
		});

		// Prepares the parameters for the local or the remote mode
		if (this.columnsDS.count() > this.comboPageSize) {
			var comboColumnsInLocalMode = false;
			/**
			 * A remote columns data store (We get better performances with a remote store).
			 * @property remoteColumnsDS
			 * @type {Ext.data.JsonStore}
			 */
			this.remoteColumnsDS = new Ext.data.JsonStore({
				model:'OgamDesktop.model.request.fieldset.Column',
				proxy: {
					type: 'ajax',
					url: Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetqueryformfields',
					reader: {
						type : 'json',
						rootProperty : 'data',
						totalProperty  : 'total',
						successProperty: 'success',
						messageProperty: 'errorMessage'
					}
				},
				filters:[{
					"property": "processId",
					"value": this.currentProcessId
				},{
					"property": "form",
					"value": this.id
				},{
					"property": "fieldsType",
					"value": "result"
				}],
				remoteFilter: true,
				pageSize: this.comboPageSize
			});
		} else {
			var comboColumnsInLocalMode = true;
			/**
			 * A local columns data store (Reset the bad default criteriaDS config (No edit filter, remoteSort set to true...)).
			 * @property localColumnsDS
			 * @type {Ext.data.JsonStore}
			 */
			this.localColumnsDS = Ext.create('Ext.data.Store', {
				model:'OgamDesktop.model.request.fieldset.Column',
				data:this.columnsDS.getData().items
			});
		}

		/**
		 * The panel used to show the columns.
		 * @property columnsPanel
		 * @type Ext.Panel
		 */
		this.columnsPanel = new Ext.panel.Panel({
			hidden : Ext.isEmpty(this.columnsDS) ? true : false,
			hideMode : 'offsets',
			items : this.getDefaultColumnsConfig(),
			tbar : [ {
				// The add-all button
				type : 'plus',
				xtype :'tool',
				tooltip : this.columnsPanelTbarAddAllButtonTooltip,
				handler : this.addAllColumns,
				scope : this
			}, {
				// The remove-all button
				xtype :'tool',
				type : 'minus',
				tooltip : this.columnsPanelTbarRemoveAllButtonTooltip,
				handler : this.removeAllColumns,
				scope : this
			}, {
				// Filler
				xtype : 'tbfill'
			},
			// The label
			{
				xtype : 'tbtext',
				text  : this.columnsPanelTbarLabel
			}, {
				// A space
				xtype : 'tbspacer'
			}, {
				// The combobox with the list of available columns
				xtype : 'combo',
				hiddenName : 'Columns',
				store: comboColumnsInLocalMode ? this.localColumnsDS : this.remoteColumnsDS,
				queryMode : comboColumnsInLocalMode ? 'local' : 'remote',
				pageSize : comboColumnsInLocalMode ? 0 : this.comboPageSize,
				editable : true,
				autoLoadOnValue: true,
				displayField : 'label',
				valueField : 'name',
				width : 220,
				maxHeight : 100,
				emptyText : this.columnsPanelTbarComboEmptyText,
				loadingText : this.columnsPanelTbarComboLoadingText,
				listeners : {
					'select' : this.addColumn,
					scope : this
				}
			}, {
				xtype : 'tbspacer'
			} ]
		});

		if (!this.items) {
			this.items = [ this.criteriaPanel, this.columnsPanel ];
		}
		this.callParent();
	},

	/**
	 * Add the selected criteria to the list of criteria.
	 * @private
	 * @param {Ext.form.field.ComboBox}	combo The criteria combobox
	 * @param {Ext.data.Model[]} record The criteria combobox record to add
	 * @param {Object} The options object passed to Ext.util.Observable.addListener.
	 */
	addSelectedCriteria : function(combo, records, eOpts) {
		
		if (combo !== null) {
			combo.clearValue();
			combo.collapse();
		}
		// Add the field
		if (!Ext.isEmpty(records) && !Ext.isIterable(records)){
			records =[records];
		}
		
		for(var i=0, l=records.length;i<l; i++) {
			this.criteriaPanel.add(this.self.getCriteriaConfig(records[i]));
		}
		//this.criteriaPanel.updateLayout();
	},

	/**
	 * Add the criteria to the list of criteria.
	 * @param {String} criteriaId The criteria id
	 * @param {String} value The criteria value
	 * @return {Object} The criteria object
	 */
	addCriteria : function(criteriaId, value) {
		// Setup the field
		var record = this.criteriaDS.getById(criteriaId);
		record.data.default_value = value;
		// Add the field
		var criteria = this.criteriaPanel.add(this.self.getCriteriaConfig(record));
		//this.criteriaPanel.updateLayout();
		return criteria;
	},

	/**
	 * Add the selected column to the column list.
	 * @private
	 * @param {Ext.form.ComboBox}combo The column combobox
	 * @param {Ext.data.Record[]} records The column combobox records to add
	 * @param {Object} The options object passed to Ext.util.Observable.addListener.
	 */
	addColumn : function(combo, records, eOpts) {
		
		if (combo !== null) {
			combo.clearValue();
			combo.collapse();
		}
		
		if (!Ext.isEmpty(records) && !Ext.isIterable(records)){
			records =[records];
		}
		
		for(var i=0, l=records.length;i<l; i++) {
			if (this.columnsPanel.down('[name=column__' + records[i].data.name+']')=== null) {
				// Add the field
				this.columnsPanel.add(this.getColumnConfig(records[i].data));
				//this.columnsPanel.updateLayout();
			}
		}
	},

	/**
	 * Construct a column for the record.
	 * @private
	 * @param {Ext.data.Record} record The column combobox record to add
	 * @return {Object} The column config object
	 */
	getColumnConfig : function(record) {
		var field = {
			xtype : 'container',
			autoEl : 'div',
			width : '100%',
			cls : 'o-ux-adrfs-column-item',
			items : [ {
				xtype : 'box',
				autoEl : {
					tag : 'div',
					cls : 'o-ux-adrfs-columnLabelBin o-ux-adrfs-columnLabelBinColor',
					html : '&nbsp;&nbsp;&nbsp;&nbsp;'
				},
				listeners : {
					'render' : function(cmp) {
						cmp.getEl().on('click', function(event, el, options) {
							this.columnsPanel.remove(cmp.ownerCt);
						}, this, {
							single : true
						});
					},
					scope : this
				}
			}, {
				xtype : 'box',
				autoEl : {
					tag : 'span',
					cls : 'o-columnLabel columnLabelColor',
					html : record.label
				},
				listeners : {
					'render' : function(cmp) {
						Ext.QuickTips.register({
							target : cmp.getEl(),
							title : record.label,
							text : record.definition,
							width : 200
						});
					},
					scope : this
				}
			}, {
				xtype : 'hidden',
				name : 'column__' + record.name,
				value : '1'
			} ]
		};
		return field;
	},

	/**
	 * Construct the default columns.
	 * @return {Array} An array of the default columns config
	 */
	getDefaultColumnsConfig : function() {
		var items = [];
		this.columnsDS.each(function(record) {
			if (record.data.is_default) {
				this.items.push(this.form.getColumnConfig(record.data));
			}
		}, {
			form : this,
			items : items
		});
		return items;
	},

	/**
	 * Adds all the columns of a column panel.
	 */
	addAllColumns : function() {

		if (this.columnsDS) {
			this.addColumn(null, this.columnsDS.getData().items);
		}	
	},

	/**
	 * Adds all the columns of a column panel.
	 */
	removeAllColumns : function() {
		this.columnsPanel.removeAll();
	},
	statics : {
		getCriteriaConfig : function(record) {
			var cls = this.self || OgamDesktop.ux.request.AdvancedRequestFieldSet,
			field = cls.callParent(arguments),
			fieldExtend={};

			fieldExtend.listeners={
				render:function(cmp) {
					if (cmp.xtype !== 'hidden') {
						// Add the tooltip
						var binCt = cmp.getEl().parent();

						var labelDiv = cmp.getEl().child('.x-form-item-label');

						labelDiv.parent().first().on('click', function(event, el, options) {
							cmp.ownerCt.remove(cmp);
						}, this, {
							single : true
						});
					}
				}
			};
			Ext.apply(field.listeners, fieldExtend.listeners);
			return field;
		}
	}
});