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
 * The following parameters are expected : title : The title of the form id :
 * The identifier of the form
 * 
 * @class OgamDesktop.ux.request.RequestFieldSet
 * @extends Ext.panel.Panel
 * @constructor Create a new RequestFieldSet
 * @param {Object} config The config object
 */
Ext.define('Ginco.ux.request.RequestFieldSet', {
	override:'OgamDesktop.ux.request.RequestFieldSet',

//<locale>
	/**
	 * @cfg {String} taxrefLatinNameColumnTitle The taxref code olumn title
	 */
	taxrefScientificNameColumnTitle : 'Nom scientifique',
	/**
	 * @cfg {String} taxrefLatinNameColumnTitle The taxref code olumn title
	 */
	taxrefScientificNameColumnTooltip : 'Le nom scientifique sans l\'autorité (LB_NOM) du taxon',
	/**
	 * @cfg {String} taxrefLatinNameColumnTitle The taxref code olumn title
	 */
	taxrefLatinNameColumnTitle : 'Cd_nom',
	/**
	 * @cfg {String} taxrefLatinNameColumnTitle The taxref code olumn title
	 */
	taxrefLatinNameColumnTooltip : 'Le code (CD_NOM) du taxon',
	/**
	 * @cfg {String} taxrefVernacularColumnTitle The taxref vernacular name column title
	 */
	taxrefVernacularNameColumnTitle : 'Nom vernaculaire',
	/**
	 * @cfg {String} taxrefVernacularNameColumnTooltip The taxref vernacular name column tooltip
	 */
	taxrefVernacularNameColumnTooltip : 'Le nom vernaculaire du taxon',
	/**
	 * @cfg {String} taxrefCompleteNameColumnTitle The taxref complete name column title
	 */
	taxrefCompleteNameColumnTitle : 'Nom complet',
	/**
	 * @cfg {String} taxrefCompleteNameColumnTooltip The taxref complete name column tooltip
	 */
	taxrefCompleteNameColumnTooltip : 'Le nom complet du taxon (nom et auteur)',
//</locale>

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

			// If the field have multiple default values, duplicate the criteria
			if (!Ext.isEmpty(record.default_value) && Ext.isString(record.default_value) && record.default_value.indexOf(';') !== -1) {
				var fields = [];
				var defaultValues = record.default_value.split(';'), i;
				for (i = 0; i < defaultValues.length; i++) {
					record.default_value = defaultValues[i];
					fields.push(cls.getCriteriaConfig(record));
				}
				return fields;
			}
			var field = {};
			field.name = 'criteria__' + record.name+'[]';
			
			//the default value make values (and valueLabel)
			if (!Ext.isEmpty(record.default_value) && Ext.isEmpty(record.value) && record.inputType !== 'CHECKBOX') { // For a checkbox, the default_value must be applied to the "checked" field parameter not to the "value" field parameter
				record.value = record.default_value;
				if( Ext.isDefined(record.params) && Ext.isEmpty(record.valueLabel)){
					record.valueLabel = record.params.valueLabel;
				}
			}

			// Creates the ext field config
			switch (record.inputType) {
			case 'SELECT': // The input type SELECT correspond generally to a data
				// type CODE
				field.xtype = 'combo';
				field.hiddenName = field.name;
				field.triggerAction = 'all';
				field.typeAhead = true;
				field.displayField = 'label';
				field.valueField = 'code';
				field.emptyText = cls.prototype.criteriaComboEmptyText;
				if (record.subtype === 'DYNAMIC') {
					field.queryMode = 'remote';
					field.store = new Ext.data.JsonStore({
						autoDestroy : true,
						autoLoad : true,
						model:'OgamDesktop.model.request.object.field.Code',
						proxy:{
							type: 'ajax',
							url : Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgetdynamiccodes',
							extraParams : {
								'unit' : record.unit
							},
							reader: {
								rootProperty:'codes'
							}
						}
						
					});
				} else {
					// Subtype == CODE (other possibilities are not available)
					field.queryMode = 'remote';
					field.store = new Ext.data.JsonStore({
						autoDestroy : true,
						autoLoad : true,
						model:'OgamDesktop.model.request.object.field.Code',
						proxy:{
							type: 'ajax',
							url: Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgetcodes',
							extraParams : {
								'unit' : record.unit
							},
							reader: {
								rootProperty:'codes'
							}
						}
					});
				}
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
				break;
			case 'NUMERIC': // The input type NUMERIC correspond generally to a data
				// type NUMERIC or RANGE
				field.xtype = 'numberrangefield';
				// If RANGE we set the min and max values
				if (record.subtype === 'RANGE') {
					field.minValue = record.params.min;
					field.maxValue = record.params.max;
					field.decimalPrecision = (record.params.decimals === null) ? 20 : record.params.decimals;
				}
				// IF INTEGER we remove the decimals
				if (record.subtype === 'INTEGER') {
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
				field.name ='criteria__' + record.name+'['+Ext.id()+']';
				break;
			case 'TEXT':
				switch (record.subtype) {
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
				if (record.type === 'ARRAY') {
					field.multiSelect= field.multiple = true;
					if (record.valueLabel) { // to avoid null pointer
						for ( var i = 0; i < record.valueLabel.length; i++) {
							codes.push({
								code : record.value[i],
								label : record.valueLabel[i]
							});
						}
					}
				} else {
					// case of CODE (single value)
					codes.push({
						code : record.value,
						label : record.valueLabel
					});
				}

				//field.unit = record.unit;
				field.store = {
					xtype : 'jsonstore',
					autoDestroy : true,
					remoteSort : true,
					model:'OgamDesktop.model.request.object.field.Code',
					proxy:{
						type:'ajax',
						url : Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgettreecodes',
						extraParams:{unit:record.unit},
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
						extraParams:{unit:record.unit}
					}});
				break;
			case 'TAXREF':
				field.xtype = 'treefield';
				field.autoLoadOnValue=true; 
				field.valueParam='query';
				var codes;
				if (record.type === 'ARRAY') {
					field.multiSelect= field.multiple = true;
					if (record.valueLabel) { // to avoid null pointer
						codes=[];
						for ( var i = 0; i < record.valueLabel.length; i++) {
							codes.push({
								code : record.value[i],
								label : record.valueLabel[i]
							});
						}
					}
				} else {
					// case of CODE (single value)
					if (!Ext.isEmpty(record.value) && !Ext.isEmpty(record.valueLabel)){
						codes=[];
						codes.push({
							code : record.value,
							label : record.valueLabel
						});
					}
				}

				//field.unit = record.unit;
				field.treePickerColumns = {
				    items: [{
				        xtype: 'treecolumn',
			            text: cls.prototype.taxrefScientificNameColumnTitle,
			            tooltip: cls.prototype.taxrefScientificNameColumnTooltip,
			            dataIndex: "scientificName",
			            flex:35
			        },{
			            text: cls.prototype.taxrefLatinNameColumnTitle,
			            tooltip: cls.prototype.taxrefLatinNameColumnTitle,
			            dataIndex: "label",
			            flex:8
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
						extraParams:{unit:record.unit},
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
						extraParams:{unit:record.unit}
					}});
				break;
			default:
				field.xtype = 'field';
				break;
			}
			if (!Ext.isEmpty(record.default_value) && record.inputType !== 'CHECKBOX') { // For a checkbox, the default_value must be applied to the "checked" field parameter not to the "value" field parameter
				field.value = record.default_value;
			}
			if (!Ext.isEmpty(record.fixed)) {
				field.readOnly = record.fixed;
			}
			field.cls = 'x-form-item-default'; // Sets the opacity to 0.3 when the field is disabled
			field.fieldLabel = record.label;

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
						title : record.label,
						text : record.definition,
						width : 300
					});
				}
			};
			return field;
		}
	}
});