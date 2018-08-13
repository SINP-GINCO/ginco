/**
 * An EditionPanel correspond to the complete page for editing/inserting a table
 * row.
 * 
 * @class OgamDesktop.view.edition.Panel
 * @extends Ext.Panel
 * @constructor Create a new Edition Panel
 * @param {Object}
 *            config The config object
 * @xtype editionpanel
 */
Ext.define('OgamDesktop.view.edition.Panel', {
	extend: 'Ext.Panel',
	xtype:'editionpage',
	controller: 'editionpage',
	requires:[
		'Ext.layout.container.Center',
		'Ext.button.Button',
		'Ext.LoadMask',
		'Ext.form.Panel',
		'Ext.data.JsonStore','OgamDesktop.store.Tree',
		'OgamDesktop.model.request.object.field.Code'],
	uses:[
		'Ext.form.field.Tag',
		'OgamDesktop.ux.form.field.*',
		'Ext.form.field.*',
		'Ext.window.Toast'
	],
	itemId : 'editionPage',
	padding : 20,
	scrollable : true,
	fieldSetWidth : 700,
	fieldWidth : 450,
	layout : 'fit',
	
	/**
	 * @cfg {Integer} comboPageSize The criteria and column combobox page size (defaults to
	 *      <tt>10</tt>)
	 */
	comboPageSize : 10,

//<locale>	
	/*
	 * Internationalization.
	 */
	/**
	 * @cfg {String} geoMapWindowTitle The geo map window title (defaults to 'Draw the localisation').
	 */
	geoMapWindowTitle : 'Draw the localisation',
	/**
	 * @cfg {String} unsavedChangesMessage The unsaved changes message (defaults to 'You have unsaved changes').
	 */
	unsavedChangesMessage : 'You have unsaved changes',
	/**
	 * @cfg {String} title The title text to be used as innerHTML (html tags are
	 *      accepted) to display in the panel <code>{@link #header}</code>
	 *      (defaults to ''). When a <code>title</code> is specified the
	 *      <code>{@link #header}</code> element will automatically be created
	 *      and displayed unless {@link #header} is explicitly set to
	 *      <code>false</code>. If you do not want to specify a
	 *      <code>title</code> at config time, but you may want one later, you
	 *      must either specify a non-empty <code>title</code> (a blank space ' '
	 *      will do) or <code>header:true</code> so that the container element
	 *      will get created.
	 */
	title : 'Edition',
	/**
	 * @cfg {String} parentsFSTitle The parents FieldSet Title (defaults to
	 *      'Parents Summary').
	 */
	parentsFSTitle : 'Parents Summary',
	/**
	 * @cfg {String} dataEditFSDeleteButtonText The data Edit FieldSet Delete
	 *      Button Text (defaults to 'Delete').
	 */
	dataEditFSDeleteButtonText : 'Delete',
	/**
	 * @cfg {String} dataEditFSDeleteButtonTooltip The data Edit FieldSet Delete
	 *      Button Tooltip (defaults to 'Delete the data (Disabled if exist
	 *      children)').
	 */
	dataEditFSDeleteButtonTooltip : 'Delete the data',
	/**
	 * @cfg {String} dataEditFSDeleteButtonConfirmTitle The data edit fieldSet delete
	 *      button confirmation title.
	 */
	dataEditFSDeleteButtonConfirmTitle: 'Confirm deletion:',
	/**
	 * @cfg {String} dataEditFSDeleteButtonConfirmMessage The data edit fieldSet delete
	 *      button confirmation message.
	 */
	dataEditFSDeleteButtonConfirmMessage : 'Do you really want to delete this data ?',
	/**
	 * @cfg {String} dataEditFSDeleteButtonTooltip The data Edit FieldSet Delete
	 *      Button Tooltip (defaults to 'Delete the data (Disabled if exist
	 *      children)').
	 */
	dataEditFSDeleteButtonDisabledTooltip : 'Data cannot be deleted (children exit)',
	/**
	 * @cfg {String} dataEditFSValidateButtonText The data Edit FieldSet
	 *      Validate Button Text (defaults to 'Validate').
	 */
	dataEditFSValidateButtonText : 'Validate',
	/**
	 * @cfg {String} dataEditFSValidateButtonTooltip The data Edit FieldSet
	 *      Validate Button Tooltip (defaults to 'Save changes').
	 */
	dataEditFSValidateButtonTooltip : 'Save changes',
	/**
	 * @cfg {String} dataEditFSSavingMessage.
	 */
	dataEditFSSavingMessage : 'Saving...',
	/**
	 * @cfg {String} dataEditFSSavingMessage.
	 */
	dataEditFSLoadingMessage : 'Loading...',
	/**
	 * @cfg {String} dataEditFSValidateButtonDisabledTooltip The data Edit
	 *      FieldSet
	 */
	dataEditFSValidateButtonDisabledTooltip : 'Data cannot be edited (not enought rights)',
	/**
	 * @cfg {String} childrenFSTitle The children FieldSet Title (defaults to
	 *      'Children Summary').
	 */
	childrenFSTitle : 'Children Summary',
	/**
	 * @cfg {String} childrenFSAddNewChildButtonText The children FieldSet Add
	 *      New Child Button Text (defaults to 'New child').
	 */
	childrenFSAddNewChildButtonText : 'Add',
	/**
	 * @cfg {String} childrenFSAddNewChildButtonTooltip The children FieldSet
	 *      Add New Child Button Tooltip (defaults to 'Add a new child').
	 */
	childrenFSAddNewChildButtonTooltip : 'Add a new child',
	/**
	 * @cfg {String} contentTitleAddPrefix The content Title Add Prefix
	 *      (defaults to 'Add').
	 */
	contentTitleAddPrefix : 'Add',
	/**
	 * @cfg {String} contentTitleEditPrefix The content Title Edit Prefix
	 *      (defaults to 'Edit').
	 */
	contentTitleEditPrefix : 'Edit',
	/**
	 * @cfg {String} tooltipEditPrefix The tooltip Edit Prefix (defaults to
	 *      'Edit the').
	 */
	tipEditPrefix : 'Edit the',
	/**
	 * @cfg {String} editToastTitle The edit toast title (defaults to
	 *      'Form submission:').
	 */
	editToastTitle : 'Form submission:',
	/**
	 * @cfg {String} deleteToastTitle The delete toast title (defaults to
	 *      'Removal operation:').
	 */
	deleteToastTitle : 'Removal operation:',
//</locale>	

	/**
	 * @cfg {String} dataId Unique identifier of the data being edited.
	 */
	dataId : '',
	/**
	 * @config {string}
	 * @required
	 */
	dataTitle:'',
	/**
	 * @cfg {Numeric} tipDefaultWidth The tip Default Width (defaults to '350').
	 */
	tipDefaultWidth : 350,
	/**
	 * @cfg {String} addMode The constant for the add mode (defaults to 'ADD').
	 */
	addMode : 'ADD',
	/**
	 * @cfg {String} editMode The constant for the edit mode (defaults to
	 *      'EDIT').
	 */
	editMode : 'EDIT',
	/**
	 * @cfg {Ext.FormPanel} the form panel.
	 */
	dataEditForm : null,
	/**
	 * @cfg {Ext.form.FieldSet} the fieldset (that contains the form).
	 */
	dataEditFS : null,
	/**
	 * @cfg {Ext.Button} the delete button.
	 */
	deleteButton : null,
	/**
	 * @cfg {Ext.Button} the validate button.
	 */
	validateButton : null,
	/**
	 * @cfg {Ext.LoadMask} Loading mask
	 */
	loadMask : null,
	
    // Change width of fields - widths of labels is in sass/src/view/edition/Panel.js
    fieldSetWidth : 700,
    fieldWidth : 650,

    toggleVisibleButton : null,
    /**
     * @cfg {Ext.form.FieldSet} a group of items.
     */
    dataGroupFS : null,

	/**
	 * Initializes the component.
	 * @private
	 */
	initComponent : function() {

		// Header
		var contentTitlePrefix = '';
		var getFormURL = '';
		switch (this.mode) {
			case this.addMode:
				contentTitlePrefix = this.contentTitleAddPrefix + '&nbsp';
				getFormURL = Ext.manifest.OgamDesktop.editionServiceUrl+ 'ajax-get-add-form/' + this.dataId;
				break;
			case this.editMode:
				contentTitlePrefix = this.contentTitleEditPrefix + '&nbsp';
				getFormURL = Ext.manifest.OgamDesktop.editionServiceUrl+ 'ajax-get-edit-form/' + this.dataId;
				break;
		}
				
		/**
		 * The form fields Data Store.
		 * 
		 * @property criteriaDS
		 * @type Ext.data.JsonStore
		 */
		this.formDS = new Ext.data.JsonStore({
			proxy:{
				type:'ajax',
				url : getFormURL,
				method : 'POST',
				reader:{
					type:'json',
					rootProperty : 'data'
				}
			},

			autoLoad : true,
			fields : [ {
				name : 'name',
				mapping : 'name'
			}, {
				name : 'data',
				mapping : 'data'
			}, {
				name : 'format',
				mapping : 'format'
			}, {
				name : 'label',
				mapping : 'label'
			}, {
				name : 'inputType',
				mapping : 'inputType'
			}, {
				name : 'unit',
				mapping : 'unit'
			}, {
				name : 'type',
				mapping : 'type'
			}, {
				name : 'subtype',
				mapping : 'subtype'
			}, {
				name : 'definition',
				mapping : 'definition'
			}, {
				name : 'decimals',
				mapping : 'decimals'
			}, {
				name : 'value',
				mapping : 'value'
			}, // the current value
			{
				name : 'valueLabel',
				mapping : 'valueLabel'
			}, // the label of the current value
			{
				name : 'editable',
				mapping : 'editable'
			}, // is the field editable?
			{
				name : 'insertable',
				mapping : 'insertable'
			}, // is the field insertable?
			{
				name : 'required',
				mapping : 'required'
			}, // is the field required?
			{
				name : 'isPK',
				mapping : 'isPK'
			}, // is the field is primary key?
			{
				name : 'params',
				mapping : 'params'
			} // reserved for min/max or list of codes
			],
			idProperty : 'name',
			listeners : {
				'load' : this.buildFieldForm,
				scope : this
			},
			waitMsg :this.dataEditFSLoadingMessage
		});

		var centerPanelItems = [];

		this.headerPanel = Ext.create({
			xtype:'box',
			html : '<h1>' + contentTitlePrefix + this.dataTitle.toLowerCase() + '</h1>'
		});
		centerPanelItems.push(this.headerPanel);

		// Parents
		if (!Ext.isEmpty(this.parentsLinks)) {
			this.parentsFS = new Ext.form.FieldSet({
				title : '&nbsp;' + this.parentsFSTitle + '&nbsp;',
				html : this.getEditLinks(this.parentsLinks)
			});
			centerPanelItems.push(this.parentsFS);
		}

		// Delete Button
		this.deleteButton = new Ext.Button({
			text : this.dataEditFSDeleteButtonText,
			disabled : this.disableDeleteButton,
			tooltip : this.dataEditFSDeleteButtonTooltip,
			handler : this.askDataDeletion,
			scope : this
		});
		if (this.disableDeleteButton) {
			this.deleteButton.tooltip = this.dataEditFSDeleteButtonDisabledTooltip;
		}

		// Validate Button
		this.validateButton = new Ext.Button({
			text : this.dataEditFSValidateButtonText,
			tooltip : this.dataEditFSValidateButtonTooltip,
			handler : this.editData,
			formBind : true, // The button is desactivated if the form is not valid
			scope : this
		});

		if (this.mode === "EDIT") {
			var buttons = [ this.deleteButton, this.validateButton ];
		} else {
			var buttons = [ this.validateButton ];
		}

		// Data
		this.dataEditForm = new Ext.FormPanel({
			border : false,
			trackResetOnLoad : true,
			url : Ext.manifest.OgamDesktop.editionServiceUrl+ 'ajax-validate-edit-data',
			labelWidth : 200,
			defaults : {
				msgTarget : 'side',
				width : 250
			},
			buttonAlign : 'center',
			buttons : buttons
		});


		this.dataEditFS = new Ext.form.FieldSet({
			title : this.dataTitle ,
			items : this.dataEditForm
		});
		centerPanelItems.push(this.dataEditFS);

		// Children
		if (this.mode === this.editMode) {
			if (!Ext.isEmpty(this.childrenConfigOptions)) {
				var childrenItems = [];
				for ( var i in this.childrenConfigOptions) {
					if (typeof this.childrenConfigOptions[i] !== 'function') {
						var cCO = this.childrenConfigOptions[i];
						// title
						cCO['title'] =cCO['title'];

						// html
						if (Ext.isEmpty(cCO['html'])) {
							cCO['html'] = this.getEditLinks(cCO['childrenLinks']);
							delete cCO['childrenLinks'];
						} else {
							cCO['html'] = '<div style="text-align:center;">' + cCO['html'] + '</div>';
						}

						// buttons
						Ext.applyIf(cCO, {items:[]});
						cCO['items'].push( {
							xtype:'button',
							text : this.childrenFSAddNewChildButtonText,
							tooltip : this.childrenFSAddNewChildButtonTooltip,
							handler:(function(location) {
								this.lookupController().redirectTo(location);
							}).bind(this,cCO['AddChildURL']),
							scope : this
						});
						childrenItems.push(new Ext.form.FieldSet(cCO));
					}
				}
				this.childrenFS = new Ext.form.FieldSet({
					title : '&nbsp;' + this.childrenFSTitle + '&nbsp;',
					items : childrenItems,
					cls : 'o-columnLabelColor'
				});
				centerPanelItems.push(this.childrenFS);
			}
		}

		this.items = [{
			layout: {
				type: 'vbox',
				align:'middle'
			},
			items : centerPanelItems,
			width : this.fieldSetWidth,
			border : false,
			defaults : {
				width : this.fieldSetWidth
			}
		}];
		
		

		this.callParent(arguments);
		
        // Hide/Show not-required fields button
        this.toggleVisibleButton = new Ext.Button({
            text: this.toggleVisibilityLabel,
            tooltip: this.toggleVisibilityLabel,
            handler: this.toggleOptionnalFieldsVisibility,
            scope: this,
            style: {
                'max-width': '200px',
                marginBottom: '10px',
                marginRight: '15px',
                float: 'right'
            }
        });

        // Insert the button in the already existing panel
        this.dataEditFS.insert(0,this.toggleVisibleButton);
	},
	
    /**
     * Handler for the toggle visibility button
      */
    toggleOptionnalFieldsVisibility: function () {
        Ext.each(Ext.select('.not-required'), function (item) {
            item.toggle();
        });
        // Redo the layout to adjust height
        this.dataEditForm.updateLayout();
    },

    /**
     * Add the form items and groups to the field form.
     * @private
     * @param {Ext.data.Record} records The records
     */
    buildFieldForm : function(store, records) {
	
	var dataProvider = '';
	var dataUserLogin = '' ;

        // Sorts store fields according to their label, and form_format.position
        store.sort('label');
        store.sort('position');
        // Easier to take records from the store : it is sorted
        records = store.data.items;
		
        // Splits items in sub-forms according to the position of metadata.form_format they belongs to
		var formItems = [];
		for ( var i = 0; i < records.length; i++) {
			
			var formItem = formItems[records[i].data.formPosition];
			if (!formItem) {
				// There is not already a form with this position : we create it
				formItems[records[i].data.formPosition] = [];
				formItem = formItems[records[i].data.formPosition];
			}
				
			var item = this.getFieldConfig(records[i].data, true);
			formItem.push(item);

			if (item.name.indexOf('PROVIDER_ID') !== -1) { 
				// detect the provider id
				dataProvider = item.value;
			}

			if (item.name.indexOf('USER_LOGIN') !== -1) {
				// detect the user login
				dataUserLogin = item.value ;
			}
		}
		
        for (var i = 1; i < formItems.length; i++) {
            // Do not display an empty form
            if (formItems[i]) {
                    if (formItems[i][0].formLabel != "Autres" || formItems[i].length > 3) {
                            // Add the form to the form of the form Panel
                            this.dataGroupFS = new Ext.form.FieldSet({
                                    title : "Catégorie : " + formItems[i][0].formLabel,
                                    items : formItems[i],
                                    width: '100%'
                            });
                            this.dataEditForm.insert(this.dataGroupFS);
                    }
            }

        }

		// Add a hidden field for the mode (ADD or EDIT)
		var modeItem = {
			xtype : 'hidden',
			name : 'MODE',
			hiddenName : 'MODE',
			value : this.mode
		};
		formItems.push(modeItem);

		// Add the fields to the Form Panel
		this.dataEditForm.add(formItems);

		// Check the rights on the data for the validate button
		if (this.checkEditionRights) {

			// Look for the provider of the data
			if (!(OgamDesktop.userCanEditProvider && OgamDesktop.userProviderId == dataProvider)
				&& !(OgamDesktop.userCanEditOwn && OgamDesktop.userLogin == dataUserLogin)
				&& !OgamDesktop.userCanEditAll
			) {
				this.dataEditForm.disable();
				this.validateButton.setTooltip(this.dataEditFSValidateButtonDisabledTooltip);
			}
		}

		this.unmask();

		// Redo the layout
		this.dataEditForm.updateLayout();
            
    },

	/**
     * Construct a FieldForm from the record
     * @private
     * @param {Ext.data.Record} record The criteria combobox record to add
     * @return a Form Field
     */
    getFieldConfig : function(record) {
            var cls = this.self || OgamDesktop.view.edition.Panel;
            var field = {};
            field.name = record.name;
            field.listeners = {};

            // Set the CSS for the field
            field.itemCls = 'trigger-field o-columnLabelColor';

            // Creates the ext field config
            switch (record.inputType) {
            case 'SELECT':
            case 'PAGINED_SELECT':
                    // The input type SELECT correspond to a data type CODE or ARRAY

                    if (record.type === 'ARRAY') {
                            field.xtype = 'tagfield';
                            field.stacked = true;
                            field.hiddenName = field.name = field.name + '[]';// OGAM-582 - FIXME : needed name with [] to extjs5.0.1  (hiddenName not used in submit ?)?                   
                            field.forceSelection = false;
                            field.filterPickList = false; // pb de perf avec les communes
                            field.triggerOnClick =false;
                    } else {
                            field.xtype = 'combo';
                            field.hiddenName = field.name;
                    }

                    field.triggerAction = 'all';
                    field.typeAhead = true;
                    field.displayField = 'label';
                    field.valueField = 'code';
                    field.emptyText = OgamDesktop.ux.request.RequestFieldSet.prototype.criteriaComboEmptyText;
                    field.queryMode = 'remote';

                    // Fill the list of codes / labels for default values
                    var codes = [];
                    if (record.type === 'ARRAY') {
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

                    var storeActionUrl;
                    if (record.subtype === 'DYNAMIC') {
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
                                            'unit' : record.unit
                                    },
                                    reader: {
                                        type : 'json',
                                        rootProperty : 'data',
                                        totalProperty  : 'total',
                                        successProperty: 'success',
                                        messageProperty: 'errorMessage'
                                    }
                            },
                            data : codes
                    };
                    if (record.inputType === 'PAGINED_SELECT') {
                            field.pageSize = cls.prototype.comboPageSize;
                            storeConfig.pageSize = cls.prototype.comboPageSize;
                    } else {
                            field.pageSize = 0;
                            storeConfig.pageSize = 0;
                    }
                    field.store = new Ext.data.JsonStore(storeConfig);
                    break;
            case 'DATE': // The input type DATE correspond generally to a
                    // data
                    // type DATE
                    field.xtype = 'datefield';
                    field.format = OgamDesktop.ux.request.RequestFieldSet.dateFormat;
                    break;
            case 'TIME': // The input type DATE correspond generally to a
                    // data
                    // type DATE
                    field.xtype = 'timefield';
                    field.format = OgamDesktop.ux.request.RequestFieldSet.timeFormat;
                    break;
            case 'NUMERIC': // The input type NUMERIC correspond generally to a
                    // data
                    // type NUMERIC or RANGE
                    field.xtype = 'numberfield';
                    // If RANGE we set the min and max values
                    if (record.subtype === 'RANGE') {
                            if(Ext.isNumeric(record.params.min)){
                                    field.minValue = record.params.min;
                            }
                            if(Ext.isNumeric(record.params.max)){
                                    field.maxValue = record.params.max;
                            }
                            field.decimalPrecision = (record.params.decimals == null) ? 20 : record.get('params').decimals;
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
                    break;
            case 'TEXT':
                    switch (record.subtype) {
                    // OGAM-602 - TODO : BOOLEAN, COORDINATE
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
                    field.hideValidateAndCancelButtons = false;
                    field.listeners['featureEditionValidated'] = 'onFeatureEditionEnded';
                    field.listeners['featureEditionCancelled'] = 'onFeatureEditionEnded';
                    field.zoomToFeatureOnInit = true;
                    field.mapWindowTitle = this.geoMapWindowTitle;
                    field.forceSingleFeature = true;
                    switch (record.subtype) {
                            case 'POINT':
                                    field.hideDrawPointButton = false;
                                    field.hideDrawLineButton = true;
                                    field.hideDrawPolygonButton = true;
                                    field.defaultActivatedDrawingButton = 'point';
                                    break;
                            case 'LINESTRING':
                                    field.hideDrawPointButton = true;
                                    field.hideDrawLineButton = false;
                                    field.hideDrawPolygonButton = true;
                                    field.defaultActivatedDrawingButton = 'line';
                                    break;
                            case 'POLYGON':
                                    field.hideDrawPointButton = true;
                                    field.hideDrawLineButton = true;
                                    field.hideDrawPolygonButton = false;
                                    field.defaultActivatedDrawingButton = 'polygon';
                                    break;
                            default:
                                    field.hideDrawPointButton = false;
                                    field.hideDrawLineButton = false;
                                    field.hideDrawPolygonButton = false;
                                    field.defaultActivatedDrawingButton = 'point';
                                    break;
                    }
                    break;
            case 'TREE':
                    field.xtype = 'treefield';
                    var codes=[];
                    if (record.type === 'ARRAY') {
                            field.multiSelect= field.multiple = true;
                            field.name = field.name + '[]';
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
                    
                    field.store = {
                            xtype : 'jsonstore',
                            autoDestroy : true,
                            //autoLoad : true,
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
                            autoLoad : true,
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
                    var codes=[];
                    if (record.type === 'ARRAY') {
                            field.multiSelect= field.multiple = true;
                            field.name = field.name + '[]';
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
                    
                    field.treePickerColumns = {
                            items: [{
                                    xtype: 'treecolumn',
                                    text: OgamDesktop.ux.request.RequestFieldSet.prototype.taxrefLatinNameColumnTitle,
                                    dataIndex: "label"
                            },{
                                    text: OgamDesktop.ux.request.RequestFieldSet.prototype.taxrefVernacularNameColumnTitle,
                                    dataIndex: "vernacularName"
                            },Ext.applyIf({
                                            text: OgamDesktop.ux.request.RequestFieldSet.prototype.taxrefReferentColumnTitle,
                                            dataIndex: "isReference",
                                            flex:0,
                                            witdh:15
                                    }, OgamDesktop.ux.grid.column.Factory.buildBooleanColumnConfig())],
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
                                            '<tpl if="!Ext.isEmpty(values.vernacularName) && values.vernacularName != null">({vernacularName})</tpl>',
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
            case 'IMAGE':
                    field.xtype = 'imagefield';
                    field.uploadId = this.dataId;
                    field.hiddenName = field.name;
                    break;
            default:
                    field.xtype = 'field';
                    break;
            }

            // Set the default value
            if (!Ext.isEmpty(record.value)) {
                    field.value = record.value;
            }

            // Check if the field is mandatory
            field.allowBlank = !(record.required == true);

            // Add a tooltip
            if (!Ext.isEmpty(record.definition)) {
                    field.listeners['afterrender'] = {
                            fn: function(cmp) {
                                    if (cmp.inputType != 'hidden') {
                                            Ext.QuickTips.register({
                                                    target : cmp.labelEl,
                                                    title : record.label,
                                                    text : record.definition,
                                                    width : 200
                                            });
                                    }
                            },
                            scope : this, 
                            single: true
                    };
            }

            // Set the label
            field.fieldLabel = record.label;
            if (record.required == true) {
                    field.fieldLabel += '<span style="color: rgb(255, 0, 0); padding-left: 2px;">*</span> ';
                    field.cls = ' required';
            }
            else {
                    field.cls = ' not-required';
            }
            
            // Set the width
            field.width = this.fieldWidth;

            if ((this.mode === this.editMode && !Ext.isEmpty(record.editable) && record.editable !== "1")
                            || (this.mode === this.editMode && !Ext.isEmpty(record.isPK) && record.isPK === "1")
                            || (this.mode === this.addMode && !Ext.isEmpty(record.insertable) && record.insertable !== "1")) {
                    // Note: Disabled Fields will not be submitted.
                    field.readOnly = true;
                    //field.editable = false;
                    if (Ext.Array.contains(['combo','tag','treefield'], field.xtype)){
                            field.selectOnFocus = false; //If selectOnFocus is enabled the combo must be editable: true
                            field.typeAhead= false;
                    }
                    field.cls += ' x-item-disabled';
            }
            field.formLabel = record.formLabel;

            return field;
    },

	/**
	 * Submit the form to save the edited data
	 */
	editData : function() {
		this.dataEditForm.getForm().submit({
			submitEmptyText: false,
			url : Ext.manifest.OgamDesktop.editionServiceUrl+ 'ajax-validate-edit-data',
			timeout : 480000,
			success : this.editSuccess,
			failure : this.editFailure,
			scope : this,
			waitMsg : this.dataEditFSSavingMessage
		});
		
	},

	/**
	 * Ask for deletion of the data
	 */
	askDataDeletion : function() {
		Ext.Msg.confirm(this.dataEditFSDeleteButtonConfirmTitle, this.dataEditFSDeleteButtonConfirmMessage, function(btn, text) {
			if (btn == 'yes') {
				this.deleteData(this.dataId);
			}
		}, this);
	},

	/**
	 * Delete the data
	 */
	deleteData : function(dataId) {
		Ext.Ajax.request({
			url : Ext.manifest.OgamDesktop.editionServiceUrl+ 'ajax-delete-data/' + dataId,
			success : this.deleteSuccess,
			failure : this.deleteFailure,
			scope : this
		});
	},

	/**
	 * Ajax Edit success.
	 * @private
	 * @param {Ext.form.BasicForm} form
	 * @param {Ext.form.Action} action
	 */
	editSuccess : function(form, action) {

		// We set the current mode to EDIT
		this.mode = "EDIT";

		var obj = action.result;

		// Set to NOT DIRTY to avoid a warning when leaving the page
		form.setValues(form.getValues());
		
		// We display the update message
		if (!Ext.isEmpty(obj.message)) {
			OgamDesktop.toast(obj.message, this.editToastTitle);
		}

		// We redirect
		if (!Ext.isEmpty(obj.redirectLink)) {
			if( obj.redirectLink.indexOf('#') == 0){//same hash with # bugs with force
				//maybe an action route
				this.lookupController().redirectTo(obj.redirectLink.substr(1), true);
			}
			else{ 
				this.lookupController().redirectTo(obj.redirectLink);
			}
		}

		if (!Ext.isEmpty(obj.errorMessage)) {
			OgamDesktop.toast(obj.errorMessage, this.editToastTitle);
			console.log('Server-side failure with status code : ' + action.response.status);
			console.log('errorMessage : ' + action.response.errorMessage);
		}
	},

	/**
	 * Ajax Edit failure.
	 * @private
	 * @param {Ext.form.BasicForm} form
	 * @param {Ext.form.Action} action
	 */
	editFailure : function(form, action) {
		var obj = Ext.util.JSON.decode(action.response.responseText);
		if (!Ext.isEmpty(obj.errorMessage)) {
			OgamDesktop.toast(obj.errorMessage, this.editToastTitle);
		}
		console.log('Server-side failure with status code : ' + action.response.status);
		console.log('errorMessage : ' + action.response.errorMessage);
	},

	/**
	 * Ajax success common function
	 * @private
	 */
	deleteSuccess : function(response, opts) {

		// Display a confirmation of the deletion
		var obj = Ext.decode(response.responseText);
		if (!Ext.isEmpty(obj.message)) {
			OgamDesktop.toast(obj.message, this.deleteToastTitle);
		}
		
		// Set to NOT DIRTY to avoid a warning when leaving the page
		this.dataEditForm.saveState();

		// Return to the index page
		if (!Ext.isEmpty(obj.redirectLink)) {
			this.lookupController().redirectTo(obj.redirectLink, true);
		} else if (obj.success) {
			this.close();
			OgamDesktop.toast(obj.message, this.deleteToastTitle);
		}

		if (!Ext.isEmpty(obj.errorMessage)) {
			OgamDesktop.toast(obj.errorMessage, this.deleteToastTitle);
			console.log('Server-side failure with status code : ' + response.status);
			console.log('errorMessage : ' + response.errorMessage);
		}
	},

	/**
	 * Ajax failure common function
	 * @private
	 */
	deleteFailure : function(response, opts) {
		console.log(response);
		var obj = Ext.decode(response.responseText);
		if (!Ext.isEmpty(obj.errorMessage)) {
			OgamDesktop.toast(obj.errorMessage, this.deleteToastTitle);
		}
		console.log('Server-side failure with status code : ' + response.status);
		console.log('errorMessage : ' + response.errorMessage);
	},

	/**
	 * Generate the html links
	 * @param {Object} links A links object
	 * @return {String} The html links
	 */
	getEditLinks : function(links) {
		var html = '', tipContent;
		for ( var i in links) {
			if (typeof links[i] !== 'function') {
				var tipTitle = this.tipEditPrefix + '&nbsp' + links[i].text.toLowerCase() + ' :';
				tipContent = '';
				for ( var data in links[i].fields) {
					var value = links[i].fields[data];
					if (typeof value !== 'function') {
						value = Ext.isEmpty(value) ? ' -' : value;
						tipContent += '<b>' + data + ' : </b>' + value + '<br/>';
					}
				}
				html += '<a href="' + links[i].url + '" ' + 'data-qtitle="<u>' + tipTitle + '</u>" ' + 'data-qwidth="' + this.tipDefaultWidth + '" '
						+ 'data-qtip="' + tipContent + '" ' + '>' + links[i].text + '</a>';
			}
		}
		return html;
	},

    /**
	 * Check if the form is dirty before to close the page and launch an alert.
	 */
	isDischargeable: function() { 
        if (this.dataEditForm.isDirty()) {
            return confirm(this.unsavedChangesMessage);
        } else {
            return true;
        }
	}
});

