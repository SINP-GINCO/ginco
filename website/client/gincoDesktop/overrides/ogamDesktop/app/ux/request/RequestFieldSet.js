Ext.define('Ginco.ux.request.RequestFieldSet', {
    override: 'OgamDesktop.ux.request.RequestFieldSet',

    resizable:true,

	inheritableStatics : {

		/**
		 * @cfg {String} dateFormat The date format for the date fields (defaults to
		 *      <tt>'Y/m/d'</tt>)
		 */
		dateFormat : 'Y/m/d',
		timeFormat : 'H:i:s',
		
		/**
		 * Builds a criteria from the record.
		 * @private
		 * @param {Ext.data.Record} record The criteria combobox record to add. A serialized FormField object.
		 * @return {Object} The criteria config object
		 */
		getCriteriaConfig : function(record) {
			var cls = this.self || OgamDesktop.ux.request.RequestFieldSet;
			var defaultValue = record.get('default_value');
			
			// Check if the field have multiple default values
			if (!Ext.isEmpty(defaultValue) && Ext.isString(defaultValue) && defaultValue.indexOf(';') !== -1) {
				// For multiple default values, duplicate the criteria and return an array of criterion config
				var fields = [];
				var defaultValues = defaultValue.split(';'), i;
				for (i = 0; i < defaultValues.length; i++) {
					record.set('default_value', defaultValues[i], {'silent':true});
					fields.push(cls.getCriteriaConfig(record));
				}
				return fields;
			} else {
				// For single default values
				var field = {};
				field.name = 'criteria__' + record.get('name')+'[]';
				field.cls = 'x-form-item-default'; // Sets the opacity to 0.3 when the field is disabled
				
				// Creates the ext field config
				switch (record.get('inputType')) {
				case 'SELECT': // The input type SELECT correspond generally to a data
				case 'PAGINED_SELECT':
					// type CODE
					field.xtype = 'combo';
					field.hiddenName = field.name;
					field.triggerAction = 'all';
					field.typeAhead = true;
					field.displayField = 'label';
					field.valueField = 'code';
					field.emptyText = cls.prototype.criteriaComboEmptyText;
					field.queryMode = 'remote';
					var storeActionUrl;
					if (record.get('subtype') === 'DYNAMIC') {
						storeActionUrl = 'ajaxgetdynamiccodes';
					} else {
						storeActionUrl = 'ajaxgetcodes';
					}
					var storeConfig = {
						autoDestroy : true,
						model:'OgamDesktop.model.request.object.field.Code',
						remoteFilter: true,
						proxy:{
							type: 'ajax',
							url : Ext.manifest.OgamDesktop.requestServiceUrl + storeActionUrl,
							extraParams : {
								'unit' : record.get('unit')
							},
							reader: {
								type : 'json',
								rootProperty : 'data',
								totalProperty  : 'total',
								successProperty: 'success',
								messageProperty: 'errorMessage'
							}
						},
						data : record.get('data').unit.codes
					};
					if (record.get('inputType') === 'PAGINED_SELECT') {
						field.pageSize = cls.prototype.comboPageSize;
						storeConfig.pageSize = cls.prototype.comboPageSize;
					} else {
						field.pageSize = 0;
						storeConfig.pageSize = 0;
					}
					field.store = new Ext.data.JsonStore(storeConfig);
					break;
				case 'DATE': // The input type DATE correspond generally to a data
					// type DATE
					field.xtype = 'daterangefield';
					field.format = cls.dateFormat;
					break;
				case 'TIME': // The input type TIME correspond generally to a data
					// type TIME
					field.xtype = 'timerangefield';
					field.format = cls.timeFormat;
					//field.submitFormat = 'H:i:s';
					break;
				case 'NUMERIC': // The input type NUMERIC correspond generally to a data
					// type NUMERIC or RANGE
					field.xtype = 'numberrangefield';
					// If RANGE we set the min and max values
					if (record.get('subtype') === 'RANGE') {
						field.minValue = record.get('min_value');
						field.maxValue = record.get('max_value');
						field.decimalPrecision = (record.get('decimals') === null) ? 20 : record.get('decimals');
					}
					// IF INTEGER we remove the decimals
					if (record.get('subtype') === 'INTEGER') {
						field.allowDecimals = false;
						field.decimalPrecision = 0;
					}
					break;
				case 'CHECKBOX': 
					Ext.applyIf(field, OgamDesktop.ux.form.field.Factory.buildCheckboxFieldConfig(record));
					break;
				case 'RADIO':
					Ext.applyIf(field, OgamDesktop.ux.form.field.Factory.buildRadioFieldConfig(record));
					
					//for a group radio, if we want multi group (and each may be submit) they must not have the same name !
					field.name ='criteria__' + record.get('name') +'['+Ext.id()+']';
					break;
				case 'TEXT':
					switch (record.get('subtype')) {
					case 'INTEGER':
						field.xtype = 'numberfield';
						field.allowDecimals = false;
						break;
					case 'NUMERIC':
						field.xtype = 'numberfield';
						break;
					default: // STRING
						field.xtype = 'textfield';
						break;
					}
					break;
				case 'GEOM':
					field.xtype = 'geometryfield';
					field.hideDrawPointButton = true;
					field.hideDrawLineButton = true;
					field.hideDrawPolygonButton = false;
					field.defaultActivatedDrawingButton = 'polygon';
					field.hideValidateAndCancelButtons = true;
					field.forceSingleFeature = false;
					break;
				case 'TREE':
					field.xtype = 'treefield';
					var codes=[];
					if (record.get('type') === 'ARRAY') {
						field.multiSelect= field.multiple = true;
						if (record.get('default_label')) { // to avoid null pointer
							for ( var i = 0; i < record.get('default_label').length; i++) {
								codes.push({
									code : record.get('default_value')[i],
									label : record.get('default_label')[i]
								});
							}
						}
					} else {
						// case of CODE (single value)
						codes.push({
							code : record.get('default_value'),
							label : record.get('default_label')
						});
					}
	
					field.store = {
						xtype : 'jsonstore',
						autoDestroy : true,
						remoteSort : true,
						model:'OgamDesktop.model.request.object.field.Code',
						proxy:{
							type:'ajax',
							url : Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgettreecodes',
							extraParams:{unit:record.get('unit')},
							reader:{
								idProperty : 'code',
								totalProperty : 'results',
								rootProperty : 'rows'
							}
						},
						data :  codes
					};
					field.treePickerStore = Ext.create('OgamDesktop.store.Tree',{
						root :{
							allowDrag : false,
							id : '*'
						},
						proxy:{
							extraParams:{unit:record.get('unit')}
						}});
					break;
				case 'TAXREF':
					field.xtype = 'treefield';
					field.autoLoadOnValue=true; 
					field.valueParam='query';
					var codes;
					if (record.get('type') === 'ARRAY') {
						field.multiSelect= field.multiple = true;
						if (record.get('default_label')) { // to avoid null pointer
							codes=[];
							for ( var i = 0; i < record.get('default_label').length; i++) {
								codes.push({
									code : record.get('default_value')[i],
									label : record.get('default_label')[i]
								});
							}
						}
					} else {
						// case of CODE (single value)
						if (!Ext.isEmpty(record.get('default_value')) && !Ext.isEmpty(record.get('default_label'))){
							codes=[];
							codes.push({
								code : record.get('default_value'),
								label : record.get('default_label')
							});
						}
					}
	
					field.treePickerColumns = {
						    items: [{
						        xtype: 'treecolumn',
					            text: cls.prototype.taxrefScientificNameColumnTitle,
					            tooltip: cls.prototype.taxrefScientificNameColumnTooltip,
					            dataIndex: "scientificName",
					            flex:37
					        },{
					            text: cls.prototype.taxrefLatinNameColumnTitle,
					            tooltip: cls.prototype.taxrefLatinNameColumnTitle,
					            dataIndex: "label",
					            flex:6
					        },{
					            text: cls.prototype.taxrefCompleteNameColumnTitle,
					            tooltip: cls.prototype.taxrefCompleteNameColumnTooltip,
					            dataIndex: "completeName",
					            flex:32
					        },{
					            text: cls.prototype.taxrefVernacularNameColumnTitle,
					            tooltip: cls.prototype.taxrefVernacularNameColumnTooltip,
					            dataIndex: "vernacularName",
					            flex:25
					        }],
							defaults : {
								flex : 1
							}
						};
					field.listConfig={
							itemTpl:  [
								'<tpl for=".">',
								'<div>',
									'<tpl if="!Ext.isEmpty(values.isReference) && values.isReference == 0"><i>{label}</i></tpl>',
									'<tpl if="!Ext.isEmpty(values.isReference) && values.isReference == 1"><b>{label}</b></tpl>',
									'<br/>',
									'<tpl if="!Ext.isEmpty(values.label) && values.label != null">({label})</tpl>',
									'<tpl if="!Ext.isEmpty(values.completeName) && values.completeName != null">({completeName})</tpl>',
									'<tpl if="!Ext.isEmpty(values.vernacularName) && values.vernacularName != null">({vernacularName})</p></tpl>',
						        '</div></tpl>'
						   ]};
						field.store = {
							xtype : 'jsonstore',
							autoDestroy : true,
							remoteSort : true,
							model:'OgamDesktop.model.NodeRef',
							proxy:{
								type:'ajax',
								url : Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgettaxrefcodes',
								extraParams:{unit: record.get('unit')},
								reader:{
									idProperty : 'code',
									totalProperty : 'results',
									rootProperty : 'rows'
								}
							},
							data:codes
						};
						field.treePickerStore = Ext.create('OgamDesktop.store.Tree',{
							width : 1200,
							model:'OgamDesktop.model.NodeRef',
							root :{
								allowDrag : false,
								id : '*'
							},
							proxy:{
								type:'ajax',
								url:Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgettaxrefnodes',
								extraParams:{unit: record.get('unit')}
							}
						});
						
						if(record.label == 'cdRef'){
							field.treePickerStore.filter('isReference', true);
						}
					break;
				default:
					field.xtype = 'field';
					break;
				}
				if (!Ext.isEmpty(defaultValue) && record.get('inputType') !== 'CHECKBOX') { // For a checkbox, the default_value must be applied to the "checked" field parameter not to the "value" field parameter
					field.value = defaultValue;
				}
				if (!Ext.isEmpty(record.get('fixed'))) {
					record.get('fixed') && (field.cls += ' x-item-disabled');
					field.readOnly = record.get('fixed');
				}
				field.fieldLabel = record.get('label');
	
				if (Ext.isEmpty(field.listeners)) {
					field.listeners = {
						// scope : this
					};
				}
				field.listeners.afterrender = function(cmp) {
					if (cmp.xtype != 'hidden') {
						var labelDiv = cmp.getEl().child('.x-form-item-label');
						Ext.QuickTips.register({
							target : labelDiv,
							title : record.get('label'),
							text : record.get('definition'),
							width : 200
						});
					}
				};
				return field;
			}
		}
	}
});